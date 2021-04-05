library(igraph)
library(ggraph)
cnetplot.enrichResult <- function(x,
                                  foldChange   = NULL,
                                  layout = "kk",
                                  termcolor="#E5C494",
                                  palette=c("darkgreen", "#0AFF34", "#B3B3B3", "#FF6347", "red"),
                                  colorEdge = FALSE,
                                  Edgecolors="None",
                                  circular = FALSE,
                                  node_label = FALSE) {

  if (circular) {
    layout <- "linear"
    geom_edge <- geom_edge_arc
  } else {
    geom_edge <- geom_edge_link
  }

  geneSets <- lapply(x$Objects,function(x)strsplit(x,"/")[[1]]) #enrichplot:::extract_geneSets(x, showCategory)
  if(node_label) {
    names(geneSets)<-x$ID
  }else{
    names(geneSets)<-x$Term
  }
  g <- enrichplot:::list2graph(geneSets)

  #foldChange <- enrichplot:::fc_readable(x, foldChange)

  size <- sapply(geneSets, length)
  V(g)$size <- min(size)/2

  n <- length(geneSets)
  V(g)$size[1:n] <- size

  if (colorEdge) {
    E(g)$Edge <- rep(names(geneSets), sapply(geneSets, length))
    edge_layer <- geom_edge(aes_(color = ~Edge), alpha=.8)
  } else {
    edge_layer <- geom_edge(alpha=.8, colour='darkgrey')
  }

  if (!is.null(foldChange)) {
    fc <- foldChange[V(g)$name[(n+1):length(V(g))]]
    V(g)$color <- NA
    V(g)$color[(n+1):length(V(g))] <- fc
    palette <- palette#enrichplot:::fc_palette(fc)
    p <- ggraph(g, layout=layout, circular = circular) +
      edge_layer +
      geom_node_point(aes_(color=~as.numeric(as.character(color)), size=~size)) +
      scale_color_gradientn(name = "fold change", colors=palette, na.value = termcolor)
    if(Edgecolors[1]=="None"){
      p <- p
    }else{
      p <- p+scale_edge_colour_manual(name="Edges",values = Edgecolors)
    }
  } else {
    V(g)$color <- "#B3B3B3"
    V(g)$color[1:n] <- termcolor#"#E5C494"
    p <- ggraph(g, layout=layout, circular=circular) +
      edge_layer +
      geom_node_point(aes_(color=~I(color), size=~size))
  }

  p <- p + scale_size(range=c(3, 10), breaks=unique(round(seq(min(size), max(size), length.out=4)))) +
    theme_void()

  p <- p + geom_node_text(aes_(label=~name), repel=TRUE)

  return(p)
}
overlap_ratio <- function(x, y) {
  x <- unlist(x)
  y <- unlist(y)
  length(intersect(x, y))#/length(unique(c(x,y)))
}
emapplot.enrichResult <- function(x, colorx="p.adjust", palette=c("darkgreen", "#B3B3B3", "red"),
                                  layout = "kk", node_label = FALSE) {
  n <- nrow(x)
  geneSets <- lapply(x$Objects,function(x)strsplit(x,"/")[[1]]) #enrichplot:::extract_geneSets(x, showCategory)
  if(node_label) {
    names(geneSets)<-x$ID
  }else{
    names(geneSets)<-x$Term
  }
  y <- as.data.frame(x)
  if (is.numeric(n)) {
    y <- y[1:n,]
  } else {
    y <- y[match(n, y$Term),]
    n <- length(n)
  }


  if (n == 0) {
    stop("no enriched term found...")
  } else if (n == 1) {
    g <- graph.empty(0, directed=FALSE)
    g <- add_vertices(g, nv = 1)
    V(g)$name <- y$Term
    V(g)$color <- "red"
    return(ggraph(g) + geom_node_point(color="red", size=5) + geom_node_text(aes_(label=~name)))
  } else {
    n <- nrow(y) #
    w <- matrix(NA, nrow=n, ncol=n)
    if(node_label){
      id <- y$ID
      #geneSets <- geneSets[id]
      colnames(w) <- rownames(w) <- y$ID
    }else{
      id <- y$Term
      #geneSets <- geneSets[id]
      colnames(w) <- rownames(w) <- y$Term
    }

    for (i in 1:n) {
      for (j in i:n) {
        w[i,j] = overlap_ratio(geneSets[id[i]], geneSets[id[j]])
      }
    }

    wd <- melt(w)
    wd <- wd[wd[,1] != wd[,2],]
    wd <- wd[!is.na(wd[,3]),]
    g <- graph.data.frame(wd[,-3], directed=FALSE)
    E(g)$width=sqrt(wd[,3] * 5)
    g <- delete.edges(g, E(g)[wd[,3] < 0.2])
    if(node_label){
      idx <- unlist(sapply(V(g)$name, function(x) which(x == y$ID)))
    }else{
      idx <- unlist(sapply(V(g)$name, function(x) which(x == y$Term)))
    }


    cnt <- sapply(geneSets[idx], length)
    V(g)$size <- cnt

    colVar <- y[idx, colorx]
    V(g)$colorx <- colVar
  }


  p <- ggraph(g, layout=layout)

  if (length(E(g)$width) > 0) {
    p <- p + geom_edge_link(alpha=.8, aes(width=width), colour='darkgrey')#aes_(width=~I(width))
  }

  p + geom_node_point(aes_(color=~colorx, size=~size)) +
    geom_node_text(aes_(label=~name), repel=TRUE) + theme_void() +
    scale_color_continuous(low=palette[1], high=palette[length(palette)], name = colorx,
                           guide=guide_colorbar(reverse=TRUE)) +
    ## scale_color_gradientn(name = color, colors=sig_palette, guide=guide_colorbar(reverse=TRUE)) +
    scale_size(range=c(3, 10))
}
ridgeplot.gseaResult <- function(x, foldChange=NULL, palette=c("darkgreen", "red"),
                                 fill="p.adjust", node_label = FALSE,type="density") {
  n <- nrow(x)
  #gs2id <- x@geneSets[x$ID[seq_len(n)]]
  geneSets <- lapply(x$Objects,function(x)strsplit(x,"/")[[1]]) #enrichplot:::extract_geneSets(x, showCategory)
  if(node_label) {
    names(geneSets)<-x$ID
  }else{
    names(geneSets)<-x$Term
  }
  gs2id <- geneSets
  gs2val <- lapply(gs2id, function(id) {
    res <- foldChange[id]
    res <- res[!is.na(res)]
  })

  nn <- names(gs2val)
  if(node_label){
    i <- match(nn, x$ID)
    nn <- x$ID[i]
  }else{
    i <- match(nn, x$Term)
    nn <- x$Term[i]
  }

  j <- order(x$Count[i], decreasing=TRUE)

  len <- sapply(gs2val, length)
  gs2val.df <- data.frame(category = rep(nn, times=len),
                          color = rep(x[i, fill], times=len),
                          value = unlist(gs2val))

  colnames(gs2val.df)[2] <- fill
  gs2val.df$category <- factor(gs2val.df$category, levels=nn[j])

  if(type=="density"){
    ggplot(gs2val.df, aes_string(x="value", y="category", fill=fill)) + geom_density_ridges() +
      ## scale_x_reverse() +
      scale_fill_continuous(low=palette[1], high=palette[2], name = fill, guide=guide_colorbar(reverse=TRUE)) +
      ## scale_fill_gradientn(name = fill, colors=sig_palette, guide=guide_colorbar(reverse=TRUE)) +
      ## geom_vline(xintercept=0, color='firebrick', linetype='dashed') +
      xlab("Fold Change") + ylab(NULL) +  theme_dose()
  }else{
    ggplot(gs2val.df, aes_string(x="value", y="category", fill=fill)) + 
      geom_density_ridges(alpha=0.9, stat="binline", bins=50) +
      ## scale_x_reverse() +
      scale_fill_continuous(low=palette[1], high=palette[2], name = fill, guide=guide_colorbar(reverse=TRUE)) +
      ## scale_fill_gradientn(name = fill, colors=sig_palette, guide=guide_colorbar(reverse=TRUE)) +
      ## geom_vline(xintercept=0, color='firebrick', linetype='dashed') +
      xlab("Fold Change") + ylab(NULL) +  theme_dose()
  }
}
