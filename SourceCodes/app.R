pacman::p_load(shiny,shinyjs,shinyBS,ggsci,DT)
source("plotcodes.R")
#library(KSEAapp)
colpalettes<-unique(c(pal_npg("nrc")(10),pal_aaas("default")(10),pal_nejm("default")(8),pal_lancet("lanonc")(9),
                      pal_jama("default")(7),pal_jco("default")(10),pal_ucscgb("default")(26),pal_d3("category10")(10),
                      pal_locuszoom("default")(7),pal_igv("default")(51),
                      pal_uchicago("default")(9),pal_startrek("uniform")(7),
                      pal_tron("legacy")(7),pal_futurama("planetexpress")(12),pal_rickandmorty("schwifty")(12),
                      pal_simpsons("springfield")(16),pal_gsea("default")(12)))
#
ui<-renderUI(
  fluidPage(
    title="EnrichVisBox",
    shinyjs::useShinyjs(),
    fluidRow(
      div(
        HTML(
          "<div style='text-align:center;'>
          <a href='#' target=''><img src='EnrichVisBoxti.png' width='300px'>
          </a>
          </div>"
        )
      )
        ),
    tagList(
      tags$head(
        tags$link(rel="stylesheet", type="text/css",href="busystyle.css"),
        tags$script(type="text/javascript", src = "busy.js"),
        tags$style(type="text/css", "
                           #loadmessage {
                     position: fixed;
                     top: 0px;
                     left: 0px;
                     width: 100%;
                     height:100%;
                     padding: 250px 0px 5px 0px;
                     text-align: center;
                     font-weight: bold;
                     font-size: 100px;
                     color: #000000;
                     background-color: #D6D9E4;
                     opacity:0.6;
                     z-index: 105;
                     }
                     "),
        tags$script('
                            var dimension = [0, 0];
                    $(document).on("shiny:connected", function(e) {
                    dimension[0] = window.innerWidth;
                    dimension[1] = window.innerHeight;
                    Shiny.onInputChange("dimension", dimension);
                    });
                    $(window).resize(function(e) {
                    dimension[0] = window.innerWidth;
                    dimension[1] = window.innerHeight;
                    Shiny.onInputChange("dimension", dimension);
                    });
                    '),
        tags$style(type="text/css", "
                   #tooltip {
			position: absolute;
			border: 1px solid #333;
			background: #fff;
			padding: 1px;
			color: #333;
      display: block;
      width:300px;
      z-index:5;
		}
                   "),#F5F5DC
        tags$style(type="text/css", "
                   #tooltip2 {
			position: absolute;
			border: 1px solid #333;
			background: #fff;
			padding: 1px;
			color: #333;
      display: block;
      width:300px;
      z-index:5;
		}
                   "),
        tags$style(type="text/css", "
                   #tooltip3 {
			position: absolute;
			border: 1px solid #333;
			background: #fff;
			padding: 1px;
			color: #333;
      display: block;
      width:300px;
      z-index:5;
		}
                   "),
        tags$style(type="text/css", "
                   #tooltip4 {
			position: absolute;
			border: 1px solid #333;
			background: #fff;
			padding: 1px;
			color: #333;
      display: block;
      width:300px;
      z-index:5;
		}
                   "),
        tags$style(type="text/css", "
                   #tooltip5 {
			position: absolute;
			border: 1px solid #333;
			background: #fff;
			padding: 1px;
			color: #333;
      display: block;
      width:300px;
      z-index:5;
		}
                   "),
        tags$style(type="text/css", "
                   #tooltip6 {
			position: absolute;
			border: 1px solid #333;
			background: #fff;
			padding: 1px;
			color: #333;
      display: block;
      width:300px;
      z-index:5;
		}
                   "),
        tags$style(type="text/css", "
                   #tooltip7 {
			position: absolute;
			border: 1px solid #333;
			background: #fff;
			padding: 1px;
			color: #333;
      display: block;
      width:300px;
      z-index:5;
		}
                   ")
      )
    ),

    conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                     tags$div(h2(strong("Calculating......")),img(src="rmd_loader.gif"),id="loadmessage")),
    tabsetPanel(
      tabPanel(
        "Welcome",
        uiOutput("welcomeui"),
        icon = icon("home")
      ),
      tabPanel(
        "Import Data",
        sidebarLayout(
          sidebarPanel(
            width=3,
            h3(
              'Import Data',
              tags$span(
                id = 'span1',
                `data-toggle` = "tooltip",
                title = '
                In this part, users should upload their own "Enrichment result data" and "Expression data". If users do not upload their data, the default data shown here are example data. The example data with .csv format can be downloaded on our GitHub at https://github.com/wangshisheng/EnrichVisBox.
                ',
                tags$span(class = "glyphicon glyphicon-question-sign")
              )
            ),
            radioButtons(
              "metabopathfileType_Input",
              label = h4("File format："),
              choices = list(".xlsx" = 1,".xls"=2, ".csv/txt" = 3),
              selected = 1,
              inline = TRUE
            ),
            fileInput('metabopathfile1', '1. Import Enrichment Results Data：',
                      accept=c('text/csv','text/plain','.xlsx','.xls')),
            checkboxInput('metabopathheader', 'First row as column names ?', TRUE),
            checkboxInput('metabopathfirstcol', 'First column as row names ?', FALSE),
            conditionalPanel(condition = "input.metabopathfileType_Input==1",
                             numericInput("metabopathxlsxindex",h5("Sheet index:"),value = 1)),
            conditionalPanel(condition = "input.metabopathfileType_Input==2",
                             numericInput("metabopathxlsxindex",h5("Sheet index:"),value = 1)),
            conditionalPanel(condition = "input.metabopathfileType_Input==3",
                             radioButtons('metabopathsep', 'Separator：',
                                          c(Comma=',',
                                            Semicolon=';',
                                            Tab='\t',
                                            BlankSpace=' '),
                                          ',')),
            tags$hr(style="border-color: grey;"),
            radioButtons(
              "mfunctionalinkyibanfileType_Input_fenzu",
              label = h4("File format："),
              choices = list(".xlsx" = 1,".xls"=2, ".csv/txt" = 3),
              selected = 1,
              inline = TRUE
            ),
            fileInput('mfunctionalinkyibanfile1_fenzu', '2. Import Expression Data：',
                      accept=c('text/csv','text/plain','.xlsx','.xls')),
            checkboxInput('mfunctionalinkyibanheader_fenzu', 'First row as column names ?', TRUE),
            checkboxInput('mfunctionalinkyibanfirstcol_fenzu', 'First column as row names ?', TRUE),
            conditionalPanel(condition = "input.mfunctionalinkyibanfileType_Input_fenzu==1",
                             numericInput("mfunctionalinkyibanxlsxindex_fenzu",h5("Sheet index:"),value = 1)),
            conditionalPanel(condition = "input.mfunctionalinkyibanfileType_Input_fenzu==2",
                             numericInput("mfunctionalinkyibanxlsxindex_fenzu",h5("Sheet index:"),value = 1)),
            conditionalPanel(condition = "input.mfunctionalinkyibanfileType_Input_fenzu==3",
                             radioButtons('mfunctionalinkyibansep_fenzu', 'Separator：',
                                          c(Comma=',',
                                            Semicolon=';',
                                            Tab='\t',
                                            BlankSpace=' '),
                                          ',')),
            tags$hr(style="border-color: grey;"),
            textInput("groupinfo","3. Group information:",value = "2;3-3"),
            bsTooltip("groupinfo",'The group information of the expression data. For example, the example data has two group samples with three replicates in each group, so users should type in "2;3-3" here.',
                      placement = "right",options = list(container = "body"))
          ),
          mainPanel(
            width = 9,
            hr(),
            h4("1. Enrichment Result Data："),
            dataTableOutput("enrichdata"),
            tags$hr(style="border-color: grey;"),
            h4("2. Expression Data："),
            dataTableOutput("expressdata")
          )
        ),
        icon = icon("upload")
      ),
      tabPanel(
        "Preview",
        sidebarLayout(
          sidebarPanel(
            width = 3,
            h3(
              "Preview",
              tags$span(
                id = 'span2',
                `data-toggle` = "tooltip2",
                title = '
                The bubble plot and UpSet plot here. In this part, users can preview and summarize some basic information (e.g., top-10 GO ids with most enriched genes/proteins and their intersections) in their data.
                ',
                tags$span(class = "glyphicon glyphicon-question-sign")
              )
            ),
            textInput('precolor', h5('1. Color for dot plot:'), "#4B0082;#CD5C5C"),
            bsTooltip("precolor",'To change bubble colour. Users can type in two colour names with a semicolon. The first one is for the lowest p.adjust, and the second one is for the highest p.adjust.',
                      placement = "right",options = list(container = "body")),
            textInput('preindex', h5('2. Index:'), "1-10"),
            bsTooltip("preindex",'Which terms or objects will be plotted. The default ‘1-10’ means the top 10 (1 to 10) terms or objects are shown. If users type in ’10-21’, it means it shows the 10th to 21st terms or objects (total of 12 terms or objects). If users input ‘1,10,21’, this means it will show the 1st, the 10th, and the 21st terms or objects (total three terms or objects).',
                      placement = "right",options = list(container = "body")),
            checkboxInput('classicmultisiteif', '3. Polar coordinate or not ?', TRUE),
            bsTooltip("classicmultisiteif",'If the dot plot is shown in a circle or not, the default is true, otherwise, the dot plot is shown in a normal rectangular coordinate system.',
                      placement = "right",options = list(container = "body")),
            checkboxInput('showidif', '4. ID as label or not ?', TRUE),
            bsTooltip("showidif",'The label in the dot plot is shown with IDs or Terms, the default is with IDs.',
                      placement = "right",options = list(container = "body")),
            textInput('precolorupset', h5('5. Color for upset plot:'), "#4B0082;#CD5C5C;#E64B35FF"),
            bsTooltip("precolorupset",' To change colours in the upset plot. Users can type in three colour names with two semicolons. The first one is the colour of the set size bar plot, the second one is the colour of the intersection points, and the third one is the colour of the main bar plot.',
                      placement = "right",options = list(container = "body")),
            tags$hr(style="border-color: grey;"),
            numericInput("preheight","Height for figure:",value = 800),
            hr(),
            actionButton("mcsbtn_Preview","Calculate",icon("paper-plane"),
                         style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
          ),
          mainPanel(
            width = 9,
            radioButtons(
              "previewxuanze",
              label = h4(""),
              choices = list("Dot Plot for Terms" = 1,"Dot Plot for Objects"=2,"UpSet Plot"=3),
              selected = 1,
              inline = TRUE
            ),
            tags$hr(style="border-color: grey;"),
            conditionalPanel(
              condition = "input.previewxuanze==1",
              downloadButton("dotplottermdl","Download"),
              plotOutput("dotplotterm")
            ),
            conditionalPanel(
              condition = "input.previewxuanze==2",
              downloadButton("dotplotobjectdl","Download"),
              plotOutput("dotplotobject")#,
              #tags$hr(style="border-color: grey;"),
              #h4("Multi-Sites Data:"),
              #downloadButton("dotplotobjectdatadl","Download"),
              #dataTableOutput("dotplotobjectdata")
            ),
            conditionalPanel(
              condition = "input.previewxuanze==3",
              downloadButton("upSetplotdl","Download"),
              plotOutput("upSetplot")
            )
          )
        ),
        icon = icon("binoculars")
      ),
      tabPanel(
        "Polar Plot",
        sidebarLayout(
          sidebarPanel(
            width = 3,
            h3(
              "Polar bar Plot",
              tags$span(
                id = 'span3',
                `data-toggle` = "tooltip3",
                title = '
                In this part, users can can show more multidimensional information (e.g. ID, Category, Count, and p.adjust) simultaneously.
                ',
                tags$span(class = "glyphicon glyphicon-question-sign")
              )
            ),
            checkboxInput("leibieif","1. Contain 'Category' column or not？",TRUE),
            bsTooltip("leibieif",'If there is this "Category" column in the enrichment analysis resulting data, users should select this parameter and input colour names in the Color for category parameter. Otherwise, unselect this parameter. The number should be same, which means there are three categories, so there should be three colours here.',
                      placement = "right",options = list(container = "body")),
            conditionalPanel(
              condition = "input.leibieif==true",
              textInput("leibiecol",h5("Color for Category："),value="orange;purple;green")
            ),
            textInput('polarindex', h5('2. Index:'), "10;10;10"),
            bsTooltip("polarindex",'Which terms will be plotted. If users select the "Contain Category column or not" parameter, the index number should be the same as the category number and linked with semicolons. For instance, there are three categories in the example data, and, to show top 10 (1 to 10) terms in each category, "10;10;10" is input here. If users unselect the "Contain Category column or not" parameter, the number here will sum up, which means the plot will show the top 30 ("10;10;10" is typed in here) terms in all the data.',
                      placement = "right",options = list(container = "body")),
            textInput('barcolor', h5('3. Color for polar bar plot:'), "#4B0082;#CD5C5C"),
            bsTooltip("barcolor",'To change the bar colour. Users can type in two colour names with a semicolon. The first one is for lowest p.adjust, and the second one is for highest p.adjust.',
                      placement = "right",options = list(container = "body")),
            numericInput("labelyuanjin",h5("4. Outer label position："),min=0,max=10,value=1.5,step=0.5),
            bsTooltip("labelyuanjin",'To change the position of outer labels.',
                      placement = "right",options = list(container = "body")),
            numericInput("labeljiaodu",h5("5. Outer label angle："),value=45,step=1),
            bsTooltip("labeljiaodu",'To change the angle of outer labels.',
                      placement = "right",options = list(container = "body")),
            numericInput("lablesize",h5("6. Outer label size"),value=3,step=0.5),
            bsTooltip("lablesize",'To change the size of outer labels.',
                      placement = "right",options = list(container = "body")),
            tags$hr(style="border-color: grey;"),
            numericInput("preheight2","Height for figure:",value = 800),
            hr(),
            actionButton("mcsbtn_Polarplot","Calculate",icon("paper-plane"),
                         style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
          ),
          mainPanel(
            width = 9,
            hr(),
            downloadButton("roseplotdl","Download"),
            plotOutput("roseplotplot")
          )
        ),
        icon = icon("sun")
      ),
      tabPanel(
        "Network Plot",
        sidebarLayout(
          sidebarPanel(
            width = 3,
            h3(
              "Network Plot",
              tags$span(
                id = 'span4',
                `data-toggle` = "tooltip4",
                title = '
                In this part, users can visualize the relationships between every enriched protein and GO id/term or the interactions between every two GO ids/terms.
                ',
                tags$span(class = "glyphicon glyphicon-question-sign")
              )
            ),
            textInput('netdotcolor', h5('1. Color for objects:'), "#4B0082;#B3B3B3;#CD5C5C"),
            bsTooltip("netdotcolor",'To change point (object) colour. Users can type in two or three colour names with a/two semicolon(s). The first one is for the lowest fold change value (log2 here), and the last one is for the highest fold change value (log2 here).',
                      placement = "right",options = list(container = "body")),
            textInput('nettermcolor', h5('2. Color for terms:'), "brown"),
            bsTooltip("nettermcolor",'To change point (ID/term) colour.',
                      placement = "right",options = list(container = "body")),
            textInput('netindex', h5('3. Index:'), "1-10"),
            bsTooltip("netindex",'Which terms or objects will be plotted. The default "1-10" means the top 10 (1 to 10) terms or objects are shown. If users type in "10-21", it means it shows the 10th to 21st terms or objects (total of 12 terms or objects). If users input "1,10,21", this means it will show the 1st, 10th, and 21st terms or objects (total of three terms or objects).',
                      placement = "right",options = list(container = "body")),
            checkboxInput('netshowidif', '4. ID as label or not ?', TRUE),
            bsTooltip("netshowidif",'If selected, the IDs will be shown; otherwise, the terms will be shown.',
                      placement = "right",options = list(container = "body")),
            checkboxInput('colorEdgeif', '5. Edge with color or not ?', TRUE),
            bsTooltip("colorEdgeif",'If selected, users should type in the same number of colours in the Edge colors parameter. For example, if "1-10" is input in the index parameter, here one should type in 10 colour names for each ID/term. If it is not selected, the line colours will become grey.',
                      placement = "right",options = list(container = "body")),
            conditionalPanel(
              condition = 'input.colorEdgeif==true',
              textInput('edgecolor', h5('Edge Colors:'), value = paste0(colpalettes[c(1:5,11:15)],collapse = ";"))
            ),
            selectInput("nettype",h5("6. Network type:"),choices = c("circle","kk")),
            bsTooltip("nettype",'To determine how the vertices are placed on the plot. There are two types here: circle and kk. Circle means showing the plot with a circular layout, and kk means placing the vertices on the plane based on the Kamada–Kawai layout algorithm.',
                      placement = "right",options = list(container = "body")),
            tags$hr(style="border-color: grey;"),
            numericInput("preheight3","Height for figure:",value = 800),
            hr(),
            actionButton("mcsbtn_networkp","Calculate",icon("paper-plane"),
                         style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
          ),
          mainPanel(
            width = 9,
            radioButtons(
              "networkpxuanze",
              label = h4(""),
              choices = list("Objects-Terms Network" = 1,"Terms Network"=2),
              selected = 1,
              inline = TRUE
            ),
            tags$hr(style="border-color: grey;"),
            downloadButton("networkpdl","Download"),
            plotOutput("networkp")
          )
        ),
        icon = icon("project-diagram")
      ),
      tabPanel(
        "Heatmap",
        sidebarLayout(
          sidebarPanel(
            width = 3,
            h3(
              "Heatmap",
              tags$span(
                id = 'span5',
                `data-toggle` = "tooltip5",
                title = '
                This module shows a heatmap-like plot. There is a coloured rectangle if one object is mapped in one ID/term, and the colour corresponds to the fold change (log2 here); otherwise, there is nothing in the position.
                ',
                tags$span(class = "glyphicon glyphicon-question-sign")
              )
            ),
            textInput('heatmapcolor', h5('1. Color:'), "#4B0082;#CD5C5C"),
            bsTooltip("heatmapcolor",'To change rectangles colour. Users can type in two colour names with a semicolon. The first one is for the lowest fold change value (log2 here), and the second one is for the highest fold change value (log2 here).',
                      placement = "right",options = list(container = "body")),
            textInput('heatmapindex', h5('2. Index:'), "1-10"),
            bsTooltip("heatmapindex",'Which terms or objects will be plotted. The default "1-10" means the top 10 (1 to 10) terms or objects are shown. If users type in "10-21", it means it shows the 10th to 21st terms or objects (total of 12 terms or objects). If users input "1,10,21", this means it will show the 1st, 10th, and 21st terms or objects (total of three terms or objects).',
                      placement = "right",options = list(container = "body")),
            checkboxInput('heatmapshowidif', '3. ID as label or not ?', TRUE),
            bsTooltip("heatmapshowidif",'If selected, the IDs will be shown; otherwise, the terms will be shown.',
                      placement = "right",options = list(container = "body")),
            tags$hr(style="border-color: grey;"),
            numericInput("preheight4","Height for figure:",value = 800),
            hr(),
            actionButton("mcsbtn_heatmap","Calculate",icon("paper-plane"),
                         style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
          ),
          mainPanel(
            width = 9,
            hr(),
            downloadButton("Heatmapdl","Download"),
            plotOutput("Heatmap")
          )
        ),
        icon = icon("map")
      ),
      tabPanel(
        "Ridgeline",
        sidebarLayout(
          sidebarPanel(
            width = 3,
            h3(
              "Ridgeline",
              tags$span(
                id = 'span6',
                `data-toggle` = "tooltip6",
                title = '
                In this part, users can show the density distribution of all object fold changes (log2 here) across each ID/term, and colour corresponds to adjusted p values.
                ',
                tags$span(class = "glyphicon glyphicon-question-sign")
              )
            ),
            textInput('ridgelinecolor', h5('1. Color:'), "#4B0082;#CD5C5C"),
            bsTooltip("ridgelinecolor",'To change the ridgeline colour. Users can type in two colour names with a semicolon. The first one is for the lowest adjusted p value, and the second one is for the highest adjusted p value.',
                      placement = "right",options = list(container = "body")),
            textInput('ridgelineindex', h5('2. Index:'), "1-10"),
            bsTooltip("ridgelineindex",'Which terms or objects will be plotted. The default "1-10" means the top 10 (1 to 10) terms or objects are shown. If users type in "10-21", it means it shows the 10th to 21st terms or objects (total of 12 terms or objects). If users input "1,10,21", this means it will show the 1st, the 10th, and the 21st terms or objects (total of three terms or objects).',
                      placement = "right",options = list(container = "body")),
            checkboxInput('ridgelineshowidif', '3. ID as label or not ?', TRUE),
            bsTooltip("ridgelineshowidif",'If selected, the IDs will be shown; otherwise, the terms will be shown.',
                      placement = "right",options = list(container = "body")),
            tags$hr(style="border-color: grey;"),
            numericInput("preheight5","Height for figure:",value = 800),
            hr(),
            actionButton("mcsbtn_ridgeline","Calculate",icon("paper-plane"),
                         style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
          ),
          mainPanel(
            width = 9,
            hr(),
            downloadButton("ridgelinedl","Download"),
            plotOutput("ridgeline")
          )
        ),
        icon = icon("chart-area")
      ),
      tabPanel(
        "Objects-Terms Link",
        sidebarLayout(
          sidebarPanel(
            width = 3,
            h3(
              "Objects-Terms Link",
              tags$span(
                id = 'span7',
                `data-toggle` = "tooltip7",
                title = '
                This is a kind of variant chord plot that can show the enrichment result data and the expression data together. The left part is the intensity heatmap of proteins in every sample, and the right part is a bar plot of each ID/term; the two parts are linked via coloured lines (green means up-regulated, brown means down-regulated, and colours can be adjusted in the corresponding parameter).
                ',
                tags$span(class = "glyphicon glyphicon-question-sign")
              )
            ),
            textInput('linkpindex', h5('1. Number of category:'), "10;10;10"),
            bsTooltip("linkpindex",'Which terms will be plotted. The index number should be same as the category number and linked with semicolons. For instance, there are three categories in the example data, and, to show the top 10 (1 to 10) terms in each category, one inputs "10;10;10" here.',
                      placement = "right",options = list(container = "body")),
            numericInput("objectnum",h5("2. Number of Objects："),value = 50,min = 1),
            bsTooltip("objectnum",'How many objects in the expression data users want to show. For instance, if the user types in "50" here, it means the first 50 proteins in the expression data will be placed on the plot.',
                      placement = "right",options = list(container = "body")),
            checkboxInput('linkpshowidif', '3. ID as label or not ?', TRUE),
            bsTooltip("linkpshowidif",'If selected, the IDs will be shown; otherwise, the terms will be shown.',
                      placement = "right",options = list(container = "body")),
            textInput("retucol",h5("4. Color for heatmap："),value = "#4B0082;#B3B3B3;#CD5C5C"),
            bsTooltip("retucol",'To change the heatmap colour, which corresponds to the intensity value in the expression data. Users should input three colour names here. The first one is for the lowest intensity value, the second one is for the middle intensity value, and the third one is for the highest intensity value.',
                      placement = "right",options = list(container = "body")),
            textInput("duixianglinkcol",h5("5. Link color："),value = "green;pink"),
            bsTooltip("duixianglinkcol",'To change the line colour. Users should type in two colour names with a semicolon. The first one indicates the negative fold change value (log2 here), and the second one corresponds to the positive fold change value (log2 here).',
                      placement = "right",options = list(container = "body")),
            numericInput("touminglink",h5("6. Link alpha："),value = 0.6,step = 0.1,max = 1,min = 0),
            bsTooltip("touminglink",'To change line colour transparency. The value should be in (0, 1).',
                      placement = "right",options = list(container = "body")),
            textInput("linkjianju",h5("7. Link end position："),value = "0.54;0.58"),
            bsTooltip("linkjianju",'To change the line position to objects or IDs/terms. Users should type in two values here. The first one is for adjusting the line end distance to objects, and the second one is for adjusting the line end distance to IDs/terms. When the value is larger, the line end is further from the objects or IDs/terms.',
                      placement = "right",options = list(container = "body")),
            numericInput("zitisize",h5("8. Label size："),value = 0.6,step = 0.1),
            bsTooltip("zitisize",'To change the size of labels.',
                      placement = "right",options = list(container = "body")),
            tags$hr(style="border-color: grey;"),
            numericInput("trackheight",h5("9. Track height："),value = 0.3,step = 0.1,max = 1,min = 0),
            bsTooltip("trackheight",'To change the height of tracks. It is the percentage according to the radius of the unit circle. The height includes the top and bottom cell paddings but not the margins.',
                      placement = "right",options = list(container = "body")),
            numericInput("gapdegree",h5("10. Gap degree："),value = 15,step = 0.5,max = 50,min = 1),
            bsTooltip("gapdegree",'To change the gap between two neighbour sectors.',
                      placement = "right",options = list(container = "body")),
            numericInput("startdegree",h5("11. Start degree："),value = -70,step = 0.5),
            bsTooltip("startdegree",'To change the starting degree from which the circle begins to draw.',
                      placement = "right",options = list(container = "body")),
            tags$hr(style="border-color: grey;"),
            textInput("fujileibiecol",h5("12. Color for category："),value = "blue;purple;red"),
            bsTooltip("fujileibiecol",'To change the category colour. The colour names and category number should be the same, for instance, in the example data, there are three categories, so there should be three colours here, which are linked with semicolons.',
                      placement = "right",options = list(container = "body")),
            textInput("fujibeiweizhi",h5("13. Adjusting inner position："),value = "6;-1_15;-1_25;-1"),
            bsTooltip("fujibeiweizhi",'To change the inner category title position. The position contains the values on the x-axis and y-axis linked with a semicolon. Every two positions are linked with an underline. For example, if "6;-1_15;-1_25;-1" is input here, it means that "6;-1" is for the first category ("BP") position ("6" is x-axis value, "-1" is y-axis value), "15;-1" is for the second category ("CC") position ("15" is x-axis value, "-1" is y-axis value), and "25;-1" is for the third category ("MF") position ("25" is x-axis value, "-1" is y-axis value).',
                      placement = "right",options = list(container = "body")),
            textInput("fujiwaiweizhi",h5("14. Adjusting outer position and label："),value = "15;10_GO ID"),
            bsTooltip("fujiwaiweizhi",'To change the outer title position and title text, they are connected with an underline. For example, if "15;10_GO ID" is input here, "15;10" is for the title position ("15" is x-axis value, "10" is y-axis value), and "GO ID" is the title.',
                      placement = "right",options = list(container = "body")),
            tags$hr(style="border-color: grey;"),
            checkboxInput("fugaicolif","15. Covering color or not?",TRUE),
            bsTooltip("fugaicolif",'Whether to change the sector colours for every category. If selected, users will adjust the parameters, including Radius (radii for the outer arc and the inner arc in the sector, linked with a semicolon), Color (colours for sectors), Alpha (colour transparency), Angle (start and end degrees for every sector in a counterclockwise direction, linked with a semicolon, while the angles between every two sectors are linked with an underline — for instance, if "27;70.5_-13.5;27_-57;-13.5" is input here, "27;70.5" is for the first sector ("27" is the start degree, "70.5" is the end degree), "-13.5;27" is for the second sector ("-13.5" is the start degree, "27" is the end degree), and "-57;-13.5" is for the third sector ("-57" is the start degree, "-13.5" is the end degree)).',
                      placement = "right",options = list(container = "body")),
            conditionalPanel(
              condition = "input.fugaicolif==true",
              textInput("fugaibanjing","Radius：",value = "1;0.6"),
              textInput("fugaicol","Color：",value = "blue;purple;red"),
              numericInput("fugaicolalpha","Alpha：",value = 0.3,step = 0.1,max = 1,min = 0),
              textInput("fugaiweizhi","Angle：",value = "27;70.5_-13.5;27_-57;-13.5")
            ),
            tags$hr(style="border-color: grey;"),
            numericInput("linkpheight","Height for figure:",value = 900)
          ),
          mainPanel(
            width = 9,
            hr(),
            actionButton("mcsbtn_mfunctionalink","Calculate",icon("paper-plane"),
                         style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
            hr(),
            downloadButton("mfunctionalinkplotdl","Download"),
            plotOutput("mfunctionalinkplot")
          )
        ),
        icon = icon("spa")
      )
    )
  )
)
#
server<-shinyServer(function(input, output, session){
  options(shiny.maxRequestSize=30*1024^2)
  usertimenum<-as.numeric(Sys.time())
  #ui
  output$welcomeui<-renderUI({
    screenwidth<-input$dimension[1]
    if(is.null(screenwidth)){
      return(NULL)
    }else{
      if(screenwidth<=1024){
        imgwidth<-400
      }
      else if(screenwidth>1024 & screenwidth<=1440){
        imgwidth<-450
      }
      else{
        imgwidth<-550
      }
    }

    fluidRow(
      div(
        id="mainbody",
        column(3),
        column(
          6,#strong("EnrichVisBox"),
          div(style="text-align:left;margin-top:20px;font-size:140%;color:darkred",
              HTML("~~ <em>Dear Users, Welcome to EnrichVisBox</em> ~~")),
          div(style="width:fit-content;width:-webkit-fit-content;width:-moz-fit-content;font-size:120%;margin-top:10px",
              HTML("<b>EnrichVisBox</b> is a web-based tool, which contains seven different plots including bubble plot, UpSet plot, polar bar plot, rectangle plot, ridgeline plot, network plot, and variant chord plot, to visualize the functional enrichment analysis result data and the expression data from multiple perspectives.")),
          div(style="text-align:center;margin-top: 20px",
              a(href='#',
                img(src='EVBlogo.png',height=imgwidth))),
          div(style="width:fit-content;width:-webkit-fit-content;width:-moz-fit-content;margin-top:20px;font-size:120%",
              HTML("EnrichVisBox is developed by <a href='https://shiny.rstudio.com/' target='_blank'>R shiny (Version 1.3.2)</a>, and is free and open to all users with no login requirement. It can be readily accessed by all popular web browsers including Google Chrome, Mozilla Firefox, Safari and Internet Explorer 10 (or later), and so on.<br />")),
          div(style="text-align:left;margin-top:20px;font-size:120%",
              HTML("The <b>example data, detailed manual, and source codes</b> can be found at our GitHub: <a href='https://github.com/wangshisheng/EnrichVisBox' target='_blank'>https://github.com/wangshisheng/EnrichVisBox</a>.<br />")),
          div(style="text-align:left;margin-top:20px;font-size:120%",
              HTML("We would highly appreciate that if you could send your feedback about any bug or feature request to Shisheng Wang at <u>wssdandan2009@outlook.com</u>.<br />")),
          div(style="text-align:center;margin-top:20px;font-size:140%;color:darkgreen",
              HTML("<br />"),
              HTML("^_^ <em>Enjoy yourself in EnrichVisBox</em> ^_^")),
          tags$hr(style="border-color: grey60;"),
          div(style="text-align:center;margin-top: 20px;font-size:100%",
              HTML(" &copy; 2019 <a href='http://english.cd120.com/' target='_blank'>Hao Yang's Group</a>. All Rights Reserved.")),
          div(style="text-align:center;margin-bottom: 20px;font-size:100%",
              HTML("&nbsp;&nbsp; Created by Shisheng Wang. E-mail: <u>wssdandan2009@outlook.com</u>."))
        ),
        column(3)
      )
    )
  })
  #show data
  #######
  enrichdataout<-reactive({
    pacman::p_load(openxlsx,gdata)
    files <- input$metabopathfile1
    if(is.null(files)){
      dataread<-read.csv("example_enrich.csv",stringsAsFactors = F)
    }else{
      if (input$metabopathfileType_Input == "1"){
        dataread<-read.xlsx(files$datapath,rowNames=input$metabopathfirstcol,
                            colNames = input$metabopathheader,sheet = input$metabopathxlsxindex)
      }
      else if(input$metabopathfileType_Input == "2"){
        if(sum(input$metabopathfirstcol)==1){
          rownametfmetabopath<-1
        }else{
          rownametfmetabopath<-NULL
        }
        dataread<-read.xls(files$datapath,sheet = input$metabopathxlsxindex,header=input$metabopathheader,
                           row.names = rownametfmetabopath, sep=input$metabopathsep,stringsAsFactors = F)
      }
      else{
        if(sum(input$metabopathfirstcol)==1){
          rownametfmetabopath<-1
        }else{
          rownametfmetabopath<-NULL
        }
        dataread<-read.csv(files$datapath,header=input$metabopathheader,
                           row.names = rownametfmetabopath, sep=input$metabopathsep,stringsAsFactors = F)
      }
    }
    enrichdatacolns<-c("ID","Term","Category","Count","p.adjust","Objects")
    colnames(dataread)<-enrichdatacolns
    dataread<-dataread[order(dataread$Count,decreasing = TRUE),]
    dataread
  })
  output$enrichdata<-renderDataTable({
    pacman::p_load(ComplexHeatmap,UpSetR,glue,ggplot2,DOSE,reshape2,ggridges)
    dataread<-enrichdataout()
    datatable(dataread, options = list(pageLength = 10))
  })
  expressdataout<-reactive({
    files <- input$mfunctionalinkyibanfile1_fenzu
    if (is.null(files)){
      dataread<-read.csv("example_pro.csv",stringsAsFactors = F,row.names = 1)
    }else{
      if (input$mfunctionalinkyibanfileType_Input_fenzu == "1"){
        dataread<-read.xlsx(files$datapath,rowNames=input$mfunctionalinkyibanfirstcol_fenzu,
                            colNames = input$mfunctionalinkyibanheader_fenzu,sheet = input$mfunctionalinkyibanxlsxindex_fenzu)
      }
      else if(input$mfunctionalinkyibanfileType_Input_fenzu == "2"){
        if(sum(input$mfunctionalinkyibanfirstcol_fenzu)==1){
          rownametfmfunctionalinkyiban_fenzu<-1
        }else{
          rownametfmfunctionalinkyiban_fenzu<-NULL
        }
        dataread<-read.xls(files$datapath,sheet = input$mfunctionalinkyibanxlsxindex_fenzu,header=input$mfunctionalinkyibanheader_fenzu,
                           row.names = rownametfmfunctionalinkyiban_fenzu, sep=input$mfunctionalinkyibansep_fenzu,stringsAsFactors = F)
      }
      else{
        if(sum(input$mfunctionalinkyibanfirstcol_fenzu)==1){
          rownametfmfunctionalinkyiban_fenzu<-1
        }else{
          rownametfmfunctionalinkyiban_fenzu<-NULL
        }
        dataread<-read.csv(files$datapath,header=input$mfunctionalinkyibanheader_fenzu,
                           row.names = rownametfmfunctionalinkyiban_fenzu, sep=input$mfunctionalinkyibansep_fenzu,stringsAsFactors = F)
      }
    }
    dataread
  })
  output$expressdata<-renderDataTable({
    datareadbj<-expressdataout()
    datatable(datareadbj, options = list(pageLength = 10))
  })
  #
  preheightx<-reactive({
    input$preheight
  })
  objesttoterm<-reactive({
    pacman::p_load(clusterProfiler,enrichplot,circlize)
    enrichdatax<-enrichdataout()
    IDx<-lapply(enrichdatax$Objects,function(x) strsplit(x,"\\/\\s?|;\\s?|,\\s?")[[1]])
    if(input$showidif){
      names(IDx)<-enrichdatax$ID
    }else{
      names(IDx)<-enrichdatax$Term
    }
    IDxmatrix<-list_to_matrix(IDx)
    IDxmatrix
  })
  observeEvent(
    input$mcsbtn_Preview,{
      output$dotplotterm<-renderPlot({
        precolorx<-strsplit(isolate(input$precolor),";")[[1]]
        douhaox1<-grep(",",isolate(input$preindex))
        douhaox2<-grep("-",isolate(input$preindex))
        if(length(douhaox1)>0){
          preindex1<-as.numeric(strsplit(isolate(input$preindex),",")[[1]])
        }
        if(length(douhaox2)>0){
          preindex1x<-as.numeric(strsplit(isolate(input$preindex),"-")[[1]])
          preindex1<-preindex1x[1]:preindex1x[2]
        }
        if(length(douhaox1)==0 & length(douhaox2)==0){
          preindex1<-1:as.numeric(isolate(input$preindex))
        }

        enrichdatax<-enrichdataout()
        enrichdatax1<-enrichdatax[preindex1,]

        if(input$classicmultisiteif){
          label_data<-enrichdatax1
          label_data$id=seq(1,nrow(label_data))
          number_of_bar=nrow(label_data)
          angle= 90 - 360 * (label_data$id) /number_of_bar
          label_data$hjust<-ifelse( angle < -90, 1, 0)
          label_data$angle<-ifelse(angle < -90, angle+180, angle)
          if(input$showidif){
            dotplottermx<-ggplot(enrichdatax1, aes(x = reorder(ID,Count), y = Count,size=Count))+
              geom_point(aes(color=p.adjust))+ #coord_flip()+
              scale_size(range = c(2,10))+
              scale_color_gradient(low=precolorx[1],high=precolorx[2])+
              coord_polar(theta = "x")+
              theme_minimal()+
              theme(
                legend.position = "right",
                axis.text = element_blank(),
                axis.title = element_blank()
              ) +
              geom_text(data=label_data, aes(x=id, y=rev(Count)+0.5, label=rev(ID), hjust=hjust), color="black",
                        alpha=0.8, size=3, angle= label_data$angle+8*20/nrow(enrichdatax1), inherit.aes = FALSE)
          }else{
            dotplottermx<-ggplot(enrichdatax1, aes(x = reorder(Term,Count), y = Count,size=Count))+
              geom_point(aes(color=p.adjust))+ #coord_flip()+
              scale_size(range = c(2,10))+#round(max(enrichdatax1$Count)*0.8)
              scale_color_gradient(low=precolorx[1],high=precolorx[2])+
              coord_polar(theta = "x")+
              theme_minimal()+
              theme(
                legend.position = "right",
                axis.text = element_blank(),
                axis.title = element_blank()
              ) +
              geom_text(data=label_data, aes(x=id, y=rev(Count)+0.5, label=rev(Term), hjust=hjust), color="black",
                        alpha=0.8, size=3, angle= label_data$angle+8*20/nrow(enrichdatax1), inherit.aes = FALSE)
          }
        }else{
          if(input$showidif){
            dotplottermx<-ggplot(enrichdatax1, aes(x = reorder(ID,Count), y = Count,size=Count))+
              geom_point(aes(color=p.adjust))+ scale_size(range = c(2,10))+
              labs(x="IDs")+
              coord_flip()+
              scale_color_gradient(low=precolorx[1],high=precolorx[2])+
              theme_bw()
          }else{
            dotplottermx<-ggplot(enrichdatax1, aes(x = reorder(Term,Count), y = Count,size=Count))+
              geom_point(aes(color=p.adjust))+ scale_size(range = c(2,10))+
              labs(x="Terms")+
              coord_flip()+
              scale_color_gradient(low=precolorx[1],high=precolorx[2])+
              theme_bw()
          }
        }
        dotplottermx
      },height = preheightx)
      dotplottermout<-reactive({
        precolorx<-strsplit(input$precolor,";")[[1]]
        douhaox1<-grep(",",input$preindex)
        douhaox2<-grep("-",input$preindex)
        if(length(douhaox1)>0){
          preindex1<-as.numeric(strsplit(input$preindex,",")[[1]])
        }
        if(length(douhaox2)>0){
          preindex1x<-as.numeric(strsplit(input$preindex,"-")[[1]])
          preindex1<-preindex1x[1]:preindex1x[2]
        }
        if(length(douhaox1)==0 & length(douhaox2)==0){
          preindex1<-1:as.numeric(input$preindex)
        }

        enrichdatax<-enrichdataout()
        enrichdatax1<-enrichdatax[preindex1,]

        if(input$classicmultisiteif){
          label_data<-enrichdatax1
          label_data$id=seq(1,nrow(label_data))
          number_of_bar=nrow(label_data)
          angle= 90 - 360 * (label_data$id) /number_of_bar
          label_data$hjust<-ifelse( angle < -90, 1, 0)
          label_data$angle<-ifelse(angle < -90, angle+180, angle)
          if(input$showidif){
            dotplottermx<-ggplot(enrichdatax1, aes(x = reorder(ID,Count), y = Count,size=Count))+
              geom_point(aes(color=p.adjust))+ #coord_flip()+
              scale_size(range = c(2,10))+
              scale_color_gradient(low=precolorx[1],high=precolorx[2])+
              coord_polar(theta = "x")+
              theme_minimal()+
              theme(
                legend.position = "right",
                axis.text = element_blank(),
                axis.title = element_blank()
              ) +
              geom_text(data=label_data, aes(x=id, y=rev(Count)+0.5, label=rev(ID), hjust=hjust), color="black",
                        alpha=0.8, size=3, angle= label_data$angle+8*20/nrow(enrichdatax1), inherit.aes = FALSE)
          }else{
            dotplottermx<-ggplot(enrichdatax1, aes(x = reorder(Term,Count), y = Count,size=Count))+
              geom_point(aes(color=p.adjust))+ #coord_flip()+
              scale_size(range = c(2,10))+
              scale_color_gradient(low=precolorx[1],high=precolorx[2])+
              coord_polar(theta = "x")+
              theme_minimal()+
              theme(
                legend.position = "right",
                axis.text = element_blank(),
                axis.title = element_blank()
              ) +
              geom_text(data=label_data, aes(x=id, y=rev(Count)+0.5, label=rev(Term), hjust=hjust), color="black",
                        alpha=0.8, size=3, angle= label_data$angle+8*20/nrow(enrichdatax1), inherit.aes = FALSE)
          }
        }else{
          if(input$showidif){
            dotplottermx<-ggplot(enrichdatax1, aes(x = reorder(ID,Count), y = Count,size=Count))+
              geom_point(aes(color=p.adjust))+ scale_size(range = c(2,10))+
              labs(x="IDs")+
              coord_flip()+
              scale_color_gradient(low=precolorx[1],high=precolorx[2])+
              theme_bw()
          }else{
            dotplottermx<-ggplot(enrichdatax1, aes(x = reorder(Term,Count), y = Count,size=Count))+
              geom_point(aes(color=p.adjust))+ scale_size(range = c(2,10))+
              labs(x="Terms")+
              coord_flip()+
              scale_color_gradient(low=precolorx[1],high=precolorx[2])+
              theme_bw()
          }
        }
        dotplottermx
      })
      output$dotplottermdl<-downloadHandler(
        filename = function(){paste("Dotplot_Term",usertimenum,".pdf",sep="")},
        content = function(file){
          pdf(file, width = preheightx()/100+1,height = preheightx()/100+1)
          print(dotplottermout())
          dev.off()
        }
      )
      #
      output$dotplotobject<-renderPlot({
        objesttotermx<-objesttoterm()
        objesttotermx1<-data.frame(Objects=rownames(objesttotermx),Count=apply(objesttotermx,1,sum),stringsAsFactors = F)
        objesttotermx1<-objesttotermx1[order(objesttotermx1$Count,decreasing = TRUE),]
        precolorx<-strsplit(isolate(input$precolor),";")[[1]]
        douhaox1<-grep(",",isolate(input$preindex))
        douhaox2<-grep("-",isolate(input$preindex))
        if(length(douhaox1)>0){
          preindex1<-as.numeric(strsplit(isolate(input$preindex),",")[[1]])
        }
        if(length(douhaox2)>0){
          preindex1x<-as.numeric(strsplit(isolate(input$preindex),"-")[[1]])
          preindex1<-preindex1x[1]:preindex1x[2]
        }
        if(length(douhaox1)==0 & length(douhaox2)==0){
          preindex1<-1:as.numeric(isolate(input$preindex))
        }
        enrichdatax1<-objesttotermx1[preindex1,]
        if(input$classicmultisiteif){
          label_data<-enrichdatax1
          label_data$id=seq(1,nrow(label_data))
          number_of_bar=nrow(label_data)
          angle= 90 - 360 * (label_data$id) /number_of_bar
          label_data$hjust<-ifelse( angle < -90, 1.5, -0.5)
          label_data$angle<-ifelse(angle < -90, angle+180, angle)
          dotplottermx<-ggplot(enrichdatax1, aes(x = reorder(Objects,Count), y = Count,size=Count))+
            geom_point(aes(color=Count))+ #coord_flip()+
            scale_size(range = c(2,10))+#round(max(enrichdatax1$Count)*0.8)
            scale_color_gradient(low=precolorx[1],high=precolorx[2])+
            coord_polar(theta = "x")+
            theme_minimal()+
            theme(
              legend.position = "right",
              axis.text = element_blank(),
              axis.title = element_blank()
            ) +
            geom_text(data=label_data, aes(x=id, y=rev(Count)+0.5, label=rev(Objects), hjust=hjust), color="black",
                      alpha=0.8, size=3, angle= label_data$angle+8*20/nrow(enrichdatax1), inherit.aes = FALSE)
        }else{
          dotplottermx<-ggplot(enrichdatax1, aes(x = reorder(Objects,Count), y = Count,size=Count))+
            geom_point(aes(color=Count))+ scale_size(range = c(2,10))+
            labs(x="Objects")+
            coord_flip()+
            scale_color_gradient(low=precolorx[1],high=precolorx[2])+
            theme_bw()
        }
        dotplottermx
      },height = preheightx)
      dotplotobjectout<-reactive({
        objesttotermx<-objesttoterm()
        objesttotermx1<-data.frame(Objects=rownames(objesttotermx),Count=apply(objesttotermx,1,sum),stringsAsFactors = F)
        objesttotermx1<-objesttotermx1[order(objesttotermx1$Count,decreasing = TRUE),]
        precolorx<-strsplit(isolate(input$precolor),";")[[1]]
        douhaox1<-grep(",",isolate(input$preindex))
        douhaox2<-grep("-",isolate(input$preindex))
        if(length(douhaox1)>0){
          preindex1<-as.numeric(strsplit(isolate(input$preindex),",")[[1]])
        }
        if(length(douhaox2)>0){
          preindex1x<-as.numeric(strsplit(isolate(input$preindex),"-")[[1]])
          preindex1<-preindex1x[1]:preindex1x[2]
        }
        if(length(douhaox1)==0 & length(douhaox2)==0){
          preindex1<-1:as.numeric(isolate(input$preindex))
        }
        enrichdatax1<-objesttotermx1[preindex1,]
        if(input$classicmultisiteif){
          label_data<-enrichdatax1
          label_data$id=seq(1,nrow(label_data))
          number_of_bar=nrow(label_data)
          angle= 90 - 360 * (label_data$id) /number_of_bar
          label_data$hjust<-ifelse( angle < -90, 1.5, -0.5)
          label_data$angle<-ifelse(angle < -90, angle+180, angle)
          dotplottermx<-ggplot(enrichdatax1, aes(x = reorder(Objects,Count), y = Count,size=Count))+
            geom_point(aes(color=Count))+ #coord_flip()+
            scale_size(range = c(2,10))+#round(max(enrichdatax1$Count)*0.8)
            scale_color_gradient(low=precolorx[1],high=precolorx[2])+
            coord_polar(theta = "x")+
            theme_minimal()+
            theme(
              legend.position = "right",
              axis.text = element_blank(),
              axis.title = element_blank()
            ) +
            geom_text(data=label_data, aes(x=id, y=rev(Count)+0.5, label=rev(Objects), hjust=hjust), color="black",
                      alpha=0.8, size=3, angle= label_data$angle+8*20/nrow(enrichdatax1), inherit.aes = FALSE)
        }else{
          dotplottermx<-ggplot(enrichdatax1, aes(x = reorder(Objects,Count), y = Count,size=Count))+
            geom_point(aes(color=Count))+ scale_size(range = c(2,10))+
            labs(x="Objects")+
            coord_flip()+
            scale_color_gradient(low=precolorx[1],high=precolorx[2])+
            theme_bw()
        }
        dotplottermx
      })
      output$dotplotobjectdl<-downloadHandler(
        filename = function(){paste("Dotplot_Objects",usertimenum,".pdf",sep="")},
        content = function(file){
          pdf(file, width = preheightx()/100+1,height = preheightx()/100+1)
          print(dotplotobjectout())
          dev.off()
        }
      )
      #
      output$upSetplot<-renderPlot({
        objesttotermx<-objesttoterm()
        precolorupsetx<-strsplit(isolate(input$precolorupset),";")[[1]]
        douhaox1<-grep(",",isolate(input$preindex))
        douhaox2<-grep("-",isolate(input$preindex))
        if(length(douhaox1)>0){
          preindex1<-as.numeric(strsplit(isolate(input$preindex),",")[[1]])
        }
        if(length(douhaox2)>0){
          preindex1x<-as.numeric(strsplit(isolate(input$preindex),"-")[[1]])
          preindex1<-preindex1x[1]:preindex1x[2]
        }
        if(length(douhaox1)==0 & length(douhaox2)==0){
          preindex1<-1:as.numeric(isolate(input$preindex))
        }
        #preindex1<<-preindex1
        upset(as.data.frame(objesttotermx), nintersects = NA, sets = colnames(objesttotermx)[preindex1],text.scale=1.5,
              sets.bar.color =precolorupsetx[1],matrix.color=precolorupsetx[2],main.bar.color =precolorupsetx[3])
      },height = preheightx)
      upSetplotout<-reactive({
        objesttotermx<-objesttoterm()
        precolorupsetx<-strsplit(isolate(input$precolorupset),";")[[1]]
        douhaox1<-grep(",",isolate(input$preindex))
        douhaox2<-grep("-",isolate(input$preindex))
        if(length(douhaox1)>0){
          preindex1<-as.numeric(strsplit(isolate(input$preindex),",")[[1]])
        }
        if(length(douhaox2)>0){
          preindex1x<-as.numeric(strsplit(isolate(input$preindex),"-")[[1]])
          preindex1<-preindex1x[1]:preindex1x[2]
        }
        if(length(douhaox1)==0 & length(douhaox2)==0){
          preindex1<-1:as.numeric(isolate(input$preindex))
        }
        upset(as.data.frame(objesttotermx), nintersects = NA, sets = colnames(objesttotermx)[preindex1],text.scale=1.5,
              sets.bar.color =precolorupsetx[1],matrix.color=precolorupsetx[2],main.bar.color =precolorupsetx[3])
      })
      output$upSetplotdl<-downloadHandler(
        filename = function(){paste("Upsetplot",usertimenum,".pdf",sep="")},
        content = function(file){
          pdf(file, width = preheightx()/100+1,height = preheightx()/100+1)
          print(upSetplotout())
          dev.off()
        }
      )
    }
  )
  #
  preheightx2<-reactive({
    input$preheight2
  })

  observeEvent(
    input$mcsbtn_Polarplot,{
      output$roseplotplot<-renderPlot({
        polarindexx<-as.numeric(strsplit(isolate(input$polarindex),";")[[1]])
        barcolx<-strsplit(input$barcolor,";")[[1]]
        enrichdatax<-enrichdataout()

        if(input$leibieif){
          leibiecolx<-strsplit(isolate(input$leibiecol),";")[[1]]
          termclassname<-dimnames(table(enrichdatax$Category))[[1]]
          dataread<-NULL
          for(i in 1:length(termclassname)){
            dataread1<-enrichdatax[enrichdatax$Category==termclassname[i],]
            dataread2<-dataread1[1:polarindexx[i],]
            dataread<-rbind(dataread,dataread2)
          }
          dat1<-dat<-dataread
          datacolnames<-colnames(dat)

          #dat1<-dat1[order(dat1[[4]]),]
          dat1[[1]]<-factor(dat[[1]],levels = dat[[1]])
          dat1$id<-1:nrow(dat1)
          dat_label<-dat1
          number_of_bar=nrow(dat_label)
          angle= 90 - 360 * (dat_label$id-0.5) /number_of_bar
          dat_label$hjust<-ifelse( angle < -90, 1, 0)
          dat_label$angle<-ifelse(angle < -90, angle+180, angle)

          dat1table<-table(dat1[[3]])
          dat1tablenum<-as.numeric(dat1table)
          dat1tablenum2<-c(0,cumsum(dat1tablenum))
          roseplot_dp1<-"ggplot(data = dat1) +
    geom_hline(yintercept = seq(.5, max(dat1[[4]])+2.5, by = 3),color = '#F5F5F5',size = .5)+
    geom_vline(xintercept = seq(.5, dim(dat1)[1]+.5, by = 1),color = '#F5F5F5',size = .5) +
    geom_bar(aes_string(x = datacolnames[1], fill = 'p.adjust', y = 'Count'),stat = 'identity', position = 'dodge', width = 1) +
    scale_x_discrete()"
          for(ik in 1:length(termclassname)){
            pp1<-paste0("geom_segment(aes(x=dat1tablenum2[",ik,"]+0.5,xend=dat1tablenum2[",ik+1,"]+0.5,y=max(dat1[[4]])+1.5,yend=max(dat1[[4]])+1.5,color=dimnames(dat1table)[[1]][",ik,"]),size=5)")
            roseplot_dp1<-paste0(roseplot_dp1,"+",pp1)
          }
          roseplot_dp <- eval(parse(text = glue(roseplot_dp1)))+
            coord_polar(start = input$labeljiaodu) +
            theme_minimal() +
            labs(x = NULL, y = NULL) +
            scale_fill_gradient(low=barcolx[1], high=barcolx[2])+
            scale_color_manual(name=datacolnames[3],labels = dimnames(dat1table)[[1]], values = leibiecolx)+
            theme(axis.text.y = element_blank(),
                  axis.text.x = element_blank(),
                  panel.grid = element_blank())+
            geom_text(data=dat_label, aes_string(x="id", y=max(dat1[[4]])+input$labelyuanjin, label=datacolnames[1], hjust="hjust"),
                      color="black", fontface="bold",alpha=0.6, size=input$lablesize, angle= dat_label$angle, inherit.aes = FALSE )
        }else{
          dat1<-dat<-enrichdatax[1:sum(polarindexx),]
          datacolnames<-colnames(dat)
          dat1[[1]]<-factor(dat[[1]],levels = dat[[1]])
          dat1$id<-1:nrow(dat1)
          dat_label<-dat1
          number_of_bar=nrow(dat_label)
          angle= 90 - 360 * (dat_label$id-0.5) /number_of_bar
          dat_label$hjust<-ifelse( angle < -90, 1, 0)
          dat_label$angle<-ifelse(angle < -90, angle+180, angle)

          roseplot_dp <- ggplot(data = dat1) +
            geom_hline(yintercept = seq(.5, max(dat1[[4]])+2.5, by = 3),color = "#F5F5F5",size = .5)+
            geom_vline(xintercept = seq(.5, dim(dat1)[1]+.5, by = 1),color = "#F5F5F5",size = .5) +
            geom_bar(aes_string(x = "ID", fill = "p.adjust", y = "Count"),stat = "identity", position = "dodge", width = 1) +
            scale_x_discrete()+
            coord_polar(start = input$labeljiaodu) +
            theme_minimal() +
            labs(x = NULL, y = NULL) +
            scale_fill_gradient(low=barcolx[1], high=barcolx[2])+
            theme(axis.text.y = element_blank(),
                  axis.text.x = element_blank(),
                  panel.grid = element_blank())+
            geom_text(data=dat_label, aes_string(x="id", y=max(dat1[[4]])+input$labelyuanjin, label=datacolnames[1], hjust="hjust"),
                      color="black", fontface="bold",alpha=0.6, size=input$lablesize, angle= dat_label$angle, inherit.aes = FALSE )
        }
        roseplot_dp
      },height = preheightx2)
      roseplotplotout<-reactive({
        polarindexx<-as.numeric(strsplit(isolate(input$polarindex),";")[[1]])
        barcolx<-strsplit(input$barcolor,";")[[1]]
        enrichdatax<-enrichdataout()

        if(input$leibieif){
          leibiecolx<-strsplit(isolate(input$leibiecol),";")[[1]]
          termclassname<-dimnames(table(enrichdatax$Category))[[1]]
          dataread<-NULL
          for(i in 1:length(termclassname)){
            dataread1<-enrichdatax[enrichdatax$Category==termclassname[i],]
            dataread2<-dataread1[1:polarindexx[i],]
            dataread<-rbind(dataread,dataread2)
          }
          dat1<-dat<-dataread
          datacolnames<-colnames(dat)

          #dat1<-dat1[order(dat1[[4]]),]
          dat1[[1]]<-factor(dat[[1]],levels = dat[[1]])
          dat1$id<-1:nrow(dat1)
          dat_label<-dat1
          number_of_bar=nrow(dat_label)
          angle= 90 - 360 * (dat_label$id-0.5) /number_of_bar
          dat_label$hjust<-ifelse( angle < -90, 1, 0)
          dat_label$angle<-ifelse(angle < -90, angle+180, angle)

          dat1table<-table(dat1[[3]])
          dat1tablenum<-as.numeric(dat1table)
          dat1tablenum2<-c(0,cumsum(dat1tablenum))
          roseplot_dp1<-"ggplot(data = dat1) +
    geom_hline(yintercept = seq(.5, max(dat1[[4]])+2.5, by = 3),color = '#F5F5F5',size = .5)+
    geom_vline(xintercept = seq(.5, dim(dat1)[1]+.5, by = 1),color = '#F5F5F5',size = .5) +
    geom_bar(aes_string(x = datacolnames[1], fill = 'p.adjust', y = 'Count'),stat = 'identity', position = 'dodge', width = 1) +
    scale_x_discrete()"
          for(ik in 1:length(termclassname)){
            pp1<-paste0("geom_segment(aes(x=dat1tablenum2[",ik,"]+0.5,xend=dat1tablenum2[",ik+1,"]+0.5,y=max(dat1[[4]])+1.5,yend=max(dat1[[4]])+1.5,color=dimnames(dat1table)[[1]][",ik,"]),size=5)")
            roseplot_dp1<-paste0(roseplot_dp1,"+",pp1)
          }
          roseplot_dp <- eval(parse(text = glue(roseplot_dp1)))+
            coord_polar(start = input$labeljiaodu) +
            theme_minimal() +
            labs(x = NULL, y = NULL) +
            scale_fill_gradient(low=barcolx[1], high=barcolx[2])+
            scale_color_manual(name=datacolnames[3],labels = dimnames(dat1table)[[1]], values = leibiecolx)+
            theme(axis.text.y = element_blank(),
                  axis.text.x = element_blank(),
                  panel.grid = element_blank())+
            geom_text(data=dat_label, aes_string(x="id", y=max(dat1[[4]])+input$labelyuanjin, label=datacolnames[1], hjust="hjust"),
                      color="black", fontface="bold",alpha=0.6, size=input$lablesize, angle= dat_label$angle, inherit.aes = FALSE )
        }else{
          dat1[[1]]<-factor(dat[[1]],levels = dat[[1]])
          dat1$id<-1:nrow(dat1)
          dat_label<-dat1
          number_of_bar=nrow(dat_label)
          angle= 90 - 360 * (dat_label$id-0.5) /number_of_bar
          dat_label$hjust<-ifelse( angle < -90, 1, 0)
          dat_label$angle<-ifelse(angle < -90, angle+180, angle)

          roseplot_dp <- ggplot(data = dat1) +
            geom_hline(yintercept = seq(.5, max(dat1[[4]])+2.5, by = 3),color = "#F5F5F5",size = .5)+
            geom_vline(xintercept = seq(.5, dim(dat1)[1]+.5, by = 1),color = "#F5F5F5",size = .5) +
            geom_bar(aes_string(x = "ID", fill = "p.adjust", y = "Count"),stat = "identity", position = "dodge", width = 1) +
            scale_x_discrete()+
            coord_polar(start = input$labeljiaodu) +
            theme_minimal() +
            labs(x = NULL, y = NULL) +
            scale_fill_gradient(low=barcolx[1], high=barcolx[2])+
            theme(axis.text.y = element_blank(),
                  axis.text.x = element_blank(),
                  panel.grid = element_blank())+
            geom_text(data=dat_label, aes_string(x="id", y=max(dat1[[4]])+input$labelyuanjin, label=datacolnames[1], hjust="hjust"),
                      color="black", fontface="bold",alpha=0.6, size=input$lablesize, angle= dat_label$angle, inherit.aes = FALSE )
        }
        roseplot_dp
      })

      output$roseplotdl<-downloadHandler(
        filename = function(){paste("Polarplot",usertimenum,".pdf",sep="")},
        content = function(file){
          pdf(file, width = preheightx2()/100+1,height = preheightx2()/100+1)
          print(roseplotplotout())
          dev.off()
        }
      )
    })


  #
  preheightx3<-reactive({
    input$preheight3
  })
  observeEvent(
    input$mcsbtn_networkp,{
      output$networkp<-renderPlot({
        netdotcolorx<-strsplit(isolate(input$netdotcolor),";")[[1]]
        douhaox1<-grep(",",isolate(input$netindex))
        douhaox2<-grep("-",isolate(input$netindex))
        if(length(douhaox1)>0){
          preindex1<-as.numeric(strsplit(isolate(input$netindex),",")[[1]])
        }
        if(length(douhaox2)>0){
          preindex1x<-as.numeric(strsplit(isolate(input$netindex),"-")[[1]])
          preindex1<-preindex1x[1]:preindex1x[2]
        }
        if(length(douhaox1)==0 & length(douhaox2)==0){
          preindex1<-1:as.numeric(isolate(input$netindex))
        }

        expressdatax<-expressdataout()
        fcdata<-expressdatax[,ncol(expressdatax)]
        names(fcdata)<-rownames(expressdatax)

        enrichdatax<-enrichdataout()
        enrichdatax1<-enrichdatax[preindex1,]
        #xnew<-new("enrichResult",result=enrichdatax1,
        #          organism = "UNKNOWN", keytype = "UNKNOWN", ontology = "UNKNOWN",
        #          readable = FALSE)
        edgecolorx<<-strsplit(isolate(input$edgecolor),";")[[1]]
        if(input$networkpxuanze==1){
          if(input$nettype=="kk"){
            cnetplot.enrichResult(x=enrichdatax1,foldChange = fcdata,layout = "kk",
                                  termcolor=input$nettermcolor,colorEdge=input$colorEdgeif,Edgecolors=edgecolorx,
                                  palette=netdotcolorx,node_label=input$netshowidif)
          }else{
            cnetplot.enrichResult(x=enrichdatax1,foldChange = fcdata,circular = TRUE,
                                  termcolor=input$nettermcolor,colorEdge=input$colorEdgeif,Edgecolors=edgecolorx,
                                  palette=netdotcolorx,node_label=input$netshowidif)
          }
        }else{
          emapplot.enrichResult(x=enrichdatax1, colorx="p.adjust", palette=netdotcolorx,
                                layout = input$nettype, node_label = input$netshowidif)
        }
      },height = preheightx3)
      networkpout<-reactive({
        netdotcolorx<-strsplit(isolate(input$netdotcolor),";")[[1]]
        douhaox1<-grep(",",isolate(input$netindex))
        douhaox2<-grep("-",isolate(input$netindex))
        if(length(douhaox1)>0){
          preindex1<-as.numeric(strsplit(isolate(input$netindex),",")[[1]])
        }
        if(length(douhaox2)>0){
          preindex1x<-as.numeric(strsplit(isolate(input$netindex),"-")[[1]])
          preindex1<-preindex1x[1]:preindex1x[2]
        }
        if(length(douhaox1)==0 & length(douhaox2)==0){
          preindex1<-1:as.numeric(isolate(input$netindex))
        }

        expressdatax<-expressdataout()
        fcdata<-expressdatax[,ncol(expressdatax)]
        names(fcdata)<-rownames(expressdatax)

        enrichdatax<-enrichdataout()
        enrichdatax1<-enrichdatax[preindex1,]
        #xnew<-new("enrichResult",result=enrichdatax1,
        #          organism = "UNKNOWN", keytype = "UNKNOWN", ontology = "UNKNOWN",
        #          readable = FALSE)
        edgecolorx<<-strsplit(isolate(input$edgecolor),";")[[1]]
        if(input$networkpxuanze==1){
          if(input$nettype=="kk"){
            cnetplot.enrichResult(x=enrichdatax1,foldChange = fcdata,layout = "kk",
                                  termcolor=input$nettermcolor,colorEdge=input$colorEdgeif,Edgecolors=edgecolorx,
                                  palette=netdotcolorx,node_label=input$netshowidif)
          }else{
            cnetplot.enrichResult(x=enrichdatax1,foldChange = fcdata,circular = TRUE,
                                  termcolor=input$nettermcolor,colorEdge=input$colorEdgeif,Edgecolors=edgecolorx,
                                  palette=netdotcolorx,node_label=input$netshowidif)
          }
        }else{
          emapplot.enrichResult(x=enrichdatax1, colorx="p.adjust", palette=netdotcolorx,
                                layout = input$nettype, node_label = input$netshowidif)
        }
      })
      output$networkpdl<-downloadHandler(
        filename = function(){paste("Objects_Terms_Network",usertimenum,".pdf",sep="")},
        content = function(file){
          pdf(file, width = preheightx3()/100+2,height = preheightx3()/100+1)
          print(networkpout())
          dev.off()
        }
      )
    }
  )
  #
  preheightx4<-reactive({
    input$preheight4
  })
  observeEvent(
    input$mcsbtn_heatmap,{
      output$Heatmap<-renderPlot({
        netdotcolorx<-strsplit(isolate(input$heatmapcolor),";")[[1]]
        douhaox1<-grep(",",isolate(input$heatmapindex))
        douhaox2<-grep("-",isolate(input$heatmapindex))
        if(length(douhaox1)>0){
          preindex1<-as.numeric(strsplit(isolate(input$heatmapindex),",")[[1]])
        }
        if(length(douhaox2)>0){
          preindex1x<-as.numeric(strsplit(isolate(input$heatmapindex),"-")[[1]])
          preindex1<-preindex1x[1]:preindex1x[2]
        }
        if(length(douhaox1)==0 & length(douhaox2)==0){
          preindex1<-1:as.numeric(isolate(input$heatmapindex))
        }

        expressdatax<-expressdataout()
        fcdata<-expressdatax[,ncol(expressdatax)]
        names(fcdata)<-rownames(expressdatax)

        enrichdatax<-enrichdataout()
        enrichdatax1<-enrichdatax[preindex1,]

        geneSets <- lapply(enrichdatax1$Objects,function(x)strsplit(x,"/")[[1]])
        if(input$heatmapshowidif) {
          names(geneSets)<-enrichdatax1$ID
        }else{
          names(geneSets)<-enrichdatax1$Term
        }

        foldChange <- fcdata
        ddx <- enrichplot:::list2df(geneSets)
        ddx$foldChange <- foldChange[as.character(ddx[, 2])]
        ppx1 <- ggplot(ddx, aes_(~Gene, ~categoryID)) +
          geom_tile(aes_(fill = ~foldChange), color = "white") +
          scale_fill_continuous(low = netdotcolorx[1], high = netdotcolorx[2], name = "fold change")
        ppx<-ppx1 + xlab(NULL) + ylab(NULL) + theme_minimal() +
          theme(panel.grid.major.x = element_blank(),axis.text.y = element_text(size = 14),
                axis.text.x = element_text(angle = 60, hjust = 1,size = 14))
        ppx
      },height = preheightx4)
      Heatmapout<-reactive({
        netdotcolorx<-strsplit(isolate(input$heatmapcolor),";")[[1]]
        douhaox1<-grep(",",isolate(input$heatmapindex))
        douhaox2<-grep("-",isolate(input$heatmapindex))
        if(length(douhaox1)>0){
          preindex1<-as.numeric(strsplit(isolate(input$heatmapindex),",")[[1]])
        }
        if(length(douhaox2)>0){
          preindex1x<-as.numeric(strsplit(isolate(input$heatmapindex),"-")[[1]])
          preindex1<-preindex1x[1]:preindex1x[2]
        }
        if(length(douhaox1)==0 & length(douhaox2)==0){
          preindex1<-1:as.numeric(isolate(input$heatmapindex))
        }

        expressdatax<-expressdataout()
        fcdata<-expressdatax[,ncol(expressdatax)]
        names(fcdata)<-rownames(expressdatax)

        enrichdatax<-enrichdataout()
        enrichdatax1<-enrichdatax[preindex1,]

        geneSets <- lapply(enrichdatax1$Objects,function(x)strsplit(x,"/")[[1]])
        if(input$heatmapshowidif) {
          names(geneSets)<-enrichdatax1$ID
        }else{
          names(geneSets)<-enrichdatax1$Term
        }

        foldChange <- fcdata
        ddx <- enrichplot:::list2df(geneSets)
        ddx$foldChange <- foldChange[as.character(ddx[, 2])]
        ppx1 <- ggplot(ddx, aes_(~Gene, ~categoryID)) +
          geom_tile(aes_(fill = ~foldChange), color = "white") +
          scale_fill_continuous(low = netdotcolorx[1], high = netdotcolorx[2], name = "fold change")
        ppx<-ppx1 + xlab(NULL) + ylab(NULL) + theme_minimal() +
          theme(panel.grid.major.x = element_blank(),axis.text.y = element_text(size = 14),
                axis.text.x = element_text(angle = 60, hjust = 1,size = 14))
        ppx
      })
      output$Heatmapdl<-downloadHandler(
        filename = function(){paste("Heatmap",usertimenum,".pdf",sep="")},
        content = function(file){
          pdf(file, width = preheightx4()/100+1,height = preheightx4()/100+1)
          print(Heatmapout())
          dev.off()
        }
      )
    }
  )
  #
  preheightx5<-reactive({
    input$preheight5
  })
  observeEvent(
    input$mcsbtn_ridgeline,{
      output$ridgeline<-renderPlot({
        netdotcolorx<-strsplit(isolate(input$ridgelinecolor),";")[[1]]
        douhaox1<-grep(",",isolate(input$ridgelineindex))
        douhaox2<-grep("-",isolate(input$ridgelineindex))
        if(length(douhaox1)>0){
          preindex1<-as.numeric(strsplit(isolate(input$ridgelineindex),",")[[1]])
        }
        if(length(douhaox2)>0){
          preindex1x<-as.numeric(strsplit(isolate(input$ridgelineindex),"-")[[1]])
          preindex1<-preindex1x[1]:preindex1x[2]
        }
        if(length(douhaox1)==0 & length(douhaox2)==0){
          preindex1<-1:as.numeric(isolate(input$ridgelineindex))
        }

        expressdatax<-expressdataout()
        fcdata<-expressdatax[,ncol(expressdatax)]
        names(fcdata)<-rownames(expressdatax)

        enrichdatax<-enrichdataout()
        enrichdatax1<-enrichdatax[preindex1,]

        ridgeplot.gseaResult(x=enrichdatax1, foldChange=fcdata, palette=netdotcolorx,
                             fill="p.adjust", node_label = input$ridgelineshowidif)
      },height = preheightx5)
      ridgelineout<-reactive({
        netdotcolorx<-strsplit(isolate(input$ridgelinecolor),";")[[1]]
        douhaox1<-grep(",",isolate(input$ridgelineindex))
        douhaox2<-grep("-",isolate(input$ridgelineindex))
        if(length(douhaox1)>0){
          preindex1<-as.numeric(strsplit(isolate(input$ridgelineindex),",")[[1]])
        }
        if(length(douhaox2)>0){
          preindex1x<-as.numeric(strsplit(isolate(input$ridgelineindex),"-")[[1]])
          preindex1<-preindex1x[1]:preindex1x[2]
        }
        if(length(douhaox1)==0 & length(douhaox2)==0){
          preindex1<-1:as.numeric(isolate(input$ridgelineindex))
        }

        expressdatax<-expressdataout()
        fcdata<-expressdatax[,ncol(expressdatax)]
        names(fcdata)<-rownames(expressdatax)

        enrichdatax<-enrichdataout()
        enrichdatax1<-enrichdatax[preindex1,]

        ridgeplot.gseaResult(x=enrichdatax1, foldChange=fcdata, palette=netdotcolorx,
                             fill="p.adjust", node_label = input$ridgelineshowidif)
      })
      output$ridgelinedl<-downloadHandler(
        filename = function(){paste("Ridgeline",usertimenum,".pdf",sep="")},
        content = function(file){
          pdf(file, width = preheightx5()/100+1,height = preheightx5()/100+1)
          print(ridgelineout())
          dev.off()
        }
      )
    }
  )
  #
  linkpheightx<-reactive({
    input$linkpheight
  })
  observeEvent(
    input$mcsbtn_mfunctionalink,{
      output$mfunctionalinkplot<-renderPlot({
        enrichdatax<-enrichdataout()
        linkpindexx<-as.numeric(strsplit(input$linkpindex,";")[[1]])
        termclassname<-dimnames(table(enrichdatax$Category))[[1]]
        dataread<-NULL
        for(i in 1:length(termclassname)){
          dataread1<-enrichdatax[enrichdatax$Category==termclassname[i],]
          dataread2<-dataread1[1:linkpindexx[i],]
          dataread<-rbind(dataread,dataread2)
        }
        expressdatax<-expressdataout()
        #expressdatax1<-expressdatax[,-ncol(expressdatax)]

        #objectnames<-unique(unlist(lapply(dataread$Objects,function(x)strsplit(x,"/")[[1]])))
        expressdatax1<-expressdatax[1:input$objectnum,]
        expressdatax2<-expressdatax1[,-ncol(expressdatax1)]
        fcdata<-expressdatax1[,ncol(expressdatax1)]
        hytestrawdata2<-t(expressdatax2)
        enrichres3<-dataread

        retucolx<-strsplit(isolate(input$retucol),";")[[1]]
        fujileibiecolx<-strsplit(isolate(input$fujileibiecol),";")[[1]][as.numeric(factor(enrichres3$Category))]
        duixianglinkcolx<-strsplit(isolate(input$duixianglinkcol),";")[[1]]
        duixianglinkcolx1<-ifelse(fcdata>0,duixianglinkcolx[1],duixianglinkcolx[2])

        rangeres1<-round(range(hytestrawdata2))
        colxx <-col_funxx<- colorRamp2(c(rangeres1[1]-0.5, mean(rangeres1), rangeres1[2]+0.5), retucolx)
        factorsx <- rep(letters[1:2], times = c(ncol(hytestrawdata2), nrow(enrichres3)))
        trackheightx<-as.numeric(isolate(input$trackheight))
        gapdegreex<-as.numeric(isolate(input$gapdegree))
        startdegreex<-as.numeric(isolate(input$startdegree))

        circos.clear()
        circos.par("canvas.xlim" = c(-1, 1.5), "canvas.ylim" = c(-1, 1),"track.height"=trackheightx,
                   cell.padding = c(0, 0, 0, 0), gap.degree = gapdegreex, start.degree = startdegreex)
        circos.initialize(factors = factorsx, xlim = cbind(c(0, 0), table(factorsx)))
        circos.trackPlotRegion(factors = factorsx, ylim = c(0,nrow(hytestrawdata2)), bg.col = NA, bg.border = NA)
        circos.update(sector.index = "a")
        d2 = hytestrawdata2
        col_data = colxx(d2)
        nr = nrow(d2)
        nc = ncol(d2)
        for (i in 1:nr) {
          circos.rect(1:nc - 1, rep(nr - i, nc), 1:nc, rep(nr - i + 1, nc),
                      border = col_data[i, ], col = col_data[i, ],sector.index ="a") }
        circos.axis(h = "bottom",direction="inside", major.at = seq(0.5,ncol(hytestrawdata2)), labels.facing="clockwise",
                    labels=colnames(hytestrawdata2),minor.ticks=0,labels.cex=isolate(input$zitisize))
        circos.yaxis(side ="right",at=1:nrow(hytestrawdata2),labels = rev(rownames(hytestrawdata2)),labels.cex=isolate(input$zitisize))
        circos.yaxis(side ="left",at=1:nrow(hytestrawdata2),labels = rev(rownames(hytestrawdata2)),labels.cex=isolate(input$zitisize))

        circos.update(sector.index = "b")
        countratio1<-enrichres3$Count/max(enrichres3$Count)*nrow(hytestrawdata2)
        circos.lines(1:nrow(enrichres3)-0.5, nrow(hytestrawdata2)-countratio1,
                     sector.index = "b",type="h",lwd=2,baseline = nrow(hytestrawdata2),
                     col=fujileibiecolx)
        circos.axis(major.at = seq(1,nrow(enrichres3))-0.5, labels.facing="clockwise",
                    labels=enrichres3$ID,minor.ticks=0,labels.cex = isolate(input$zitisize))
        circos.axis(h = "bottom",direction="inside", labels=FALSE)
        circos.yaxis(side ="right",at=seq(0,nrow(hytestrawdata2),by=2),
                     labels =paste0(seq(max(enrichres3$Count),0,by=-2*round(max(enrichres3$Count)/nrow(hytestrawdata2)))),
                     labels.cex=isolate(input$zitisize))
        circos.yaxis(side ="left",at=seq(0,nrow(hytestrawdata2),by=2),
                     labels =paste0(seq(max(enrichres3$Count),0,by=-2*round(max(enrichres3$Count)/nrow(hytestrawdata2)))),
                     labels.cex=isolate(input$zitisize))

        fujibeiweizhix<-strsplit(isolate(input$fujibeiweizhi),"_")[[1]]
        leibienames<-unique(enrichres3$Category)
        for(i1 in 1:length(leibienames)){
          fujibeiweizhix1<-as.numeric(strsplit(fujibeiweizhix[i1],";")[[1]])
          circos.text(fujibeiweizhix1[1],fujibeiweizhix1[2],labels = leibienames[i1],
                      sector.index ="b",facing = "bending.outside", cex = 1)
        }
        #circos.text(2,-2,labels = "BP",sector.index ="b",facing = "bending.outside", cex = 1)
        #circos.text(7.5,-2,labels = "CC",sector.index ="b",facing = "bending.outside", cex = 1)
        #circos.text(12,-2,labels = "MF",sector.index ="b",facing = "bending.outside", cex = 1)
        fujiwaiweizhix<-strsplit(isolate(input$fujiwaiweizhi),"_")[[1]]
        fujiwaiweizhix1<-as.numeric(strsplit(fujiwaiweizhix[1],";")[[1]])
        circos.text(fujiwaiweizhix1[1],fujiwaiweizhix1[2],labels = fujiwaiweizhix[2],
                    sector.index ="b",facing = "bending.outside", cex = 1.2)
        fugaibanjingx<-as.numeric(strsplit(isolate(input$fugaibanjing),";")[[1]])

        if(isolate(input$fugaicolif)){
          fugaicolx<-strsplit(isolate(input$fugaicol),";")[[1]]
          fugaiweizhix<-strsplit(isolate(input$fugaiweizhi),"_")[[1]]
          for(i2 in 1:length(fugaiweizhix)){
            fugaiweizhix1<-as.numeric(strsplit(fugaiweizhix[i2],";")[[1]])
            draw.sector(fugaiweizhix1[1],fugaiweizhix1[2], rou1 = fugaibanjingx[1], rou2 = fugaibanjingx[2],
                        col = adjustcolor(fugaicolx[i2], alpha.f =isolate(input$fugaicolalpha)), clock.wise = FALSE)
          }
        }
        #draw.sector(18,43.5, rou1 = 1, rou2 = 0.6, col = adjustcolor("red", alpha.f =0.3), clock.wise = FALSE)
        #draw.sector(-10,18, rou1 = 1, rou2 = 0.6, col = adjustcolor("blue", alpha.f =0.3), clock.wise = FALSE)
        #draw.sector(-35,-10, rou1 = 1, rou2 = 0.6, col = adjustcolor("purple", alpha.f =0.3), clock.wise = FALSE)

        linkjianjux<-as.numeric(strsplit(isolate(input$linkjianju),";")[[1]])
        xx1<-seq(0.5,ncol(hytestrawdata2))
        xx2<-colnames(hytestrawdata2)
        xx3<-seq(1,nrow(enrichres3))-0.5
        xx4<-enrichres3$Objects
        for(ii in 1:length(xx2)){
          ii1<-grep(xx2[ii],xx4,ignore.case = FALSE,perl = TRUE)
          if(length(ii1)>0){
            for(ik in ii1){
              circos.link("a", xx1[ii], "b", xx3[ik],rou1 =linkjianjux[1],rou2 =linkjianjux[2],
                          col = adjustcolor(duixianglinkcolx1[ii], alpha.f =input$touminglink))
            }
          }
        }

        circos.clear()

        lgd_links = Legend(at = c(rangeres1[1]-0.5, mean(rangeres1), rangeres1[2]+0.5),col_fun = col_funxx,
                           title_position = "topleft", title = "Intensity", direction = "horizontal")
        draw(lgd_links, x = unit(1, "npc") - unit(80, "mm"), y = unit(40, "mm"), just = "top")
      },height = linkpheightx)
      mfunctionalinkplotout<-reactive({
        enrichdatax<-enrichdataout()
        linkpindexx<-as.numeric(strsplit(input$linkpindex,";")[[1]])
        termclassname<-dimnames(table(enrichdatax$Category))[[1]]
        dataread<-NULL
        for(i in 1:length(termclassname)){
          dataread1<-enrichdatax[enrichdatax$Category==termclassname[i],]
          dataread2<-dataread1[1:linkpindexx[i],]
          dataread<-rbind(dataread,dataread2)
        }
        expressdatax<-expressdataout()
        #expressdatax1<-expressdatax[,-ncol(expressdatax)]

        #objectnames<-unique(unlist(lapply(dataread$Objects,function(x)strsplit(x,"/")[[1]])))
        expressdatax1<-expressdatax[1:input$objectnum,]
        expressdatax2<-expressdatax1[,-ncol(expressdatax1)]
        fcdata<-expressdatax1[,ncol(expressdatax1)]
        hytestrawdata2<-t(expressdatax2)
        enrichres3<-dataread

        retucolx<-strsplit(isolate(input$retucol),";")[[1]]
        fujileibiecolx<-strsplit(isolate(input$fujileibiecol),";")[[1]][as.numeric(factor(enrichres3$Category))]
        duixianglinkcolx<-strsplit(isolate(input$duixianglinkcol),";")[[1]]
        duixianglinkcolx1<-ifelse(fcdata>0,duixianglinkcolx[1],duixianglinkcolx[2])

        rangeres1<-round(range(hytestrawdata2))
        colxx <-col_funxx<- colorRamp2(c(rangeres1[1]-0.5, mean(rangeres1), rangeres1[2]+0.5), retucolx)
        factorsx <- rep(letters[1:2], times = c(ncol(hytestrawdata2), nrow(enrichres3)))
        trackheightx<-as.numeric(isolate(input$trackheight))
        gapdegreex<-as.numeric(isolate(input$gapdegree))
        startdegreex<-as.numeric(isolate(input$startdegree))

        circos.clear()
        circos.par("canvas.xlim" = c(-1, 1.5), "canvas.ylim" = c(-1, 1),"track.height"=trackheightx,
                   cell.padding = c(0, 0, 0, 0), gap.degree = gapdegreex, start.degree = startdegreex)
        circos.initialize(factors = factorsx, xlim = cbind(c(0, 0), table(factorsx)))
        circos.trackPlotRegion(factors = factorsx, ylim = c(0,nrow(hytestrawdata2)), bg.col = NA, bg.border = NA)
        circos.update(sector.index = "a")
        d2 = hytestrawdata2
        col_data = colxx(d2)
        nr = nrow(d2)
        nc = ncol(d2)
        for (i in 1:nr) {
          circos.rect(1:nc - 1, rep(nr - i, nc), 1:nc, rep(nr - i + 1, nc),
                      border = col_data[i, ], col = col_data[i, ],sector.index ="a") }
        circos.axis(h = "bottom",direction="inside", major.at = seq(0.5,ncol(hytestrawdata2)), labels.facing="clockwise",
                    labels=colnames(hytestrawdata2),minor.ticks=0,labels.cex=isolate(input$zitisize))
        circos.yaxis(side ="right",at=1:nrow(hytestrawdata2),labels = rev(rownames(hytestrawdata2)),labels.cex=isolate(input$zitisize))
        circos.yaxis(side ="left",at=1:nrow(hytestrawdata2),labels = rev(rownames(hytestrawdata2)),labels.cex=isolate(input$zitisize))

        circos.update(sector.index = "b")
        countratio1<-enrichres3$Count/max(enrichres3$Count)*nrow(hytestrawdata2)
        circos.lines(1:nrow(enrichres3)-0.5, nrow(hytestrawdata2)-countratio1,
                     sector.index = "b",type="h",lwd=2,baseline = nrow(hytestrawdata2),
                     col=fujileibiecolx)
        circos.axis(major.at = seq(1,nrow(enrichres3))-0.5, labels.facing="clockwise",
                    labels=enrichres3$ID,minor.ticks=0,labels.cex = isolate(input$zitisize))
        circos.axis(h = "bottom",direction="inside", labels=FALSE)
        circos.yaxis(side ="right",at=seq(0,nrow(hytestrawdata2),by=2),
                     labels =paste0(seq(max(enrichres3$Count),0,by=-2*round(max(enrichres3$Count)/nrow(hytestrawdata2)))),
                     labels.cex=isolate(input$zitisize))
        circos.yaxis(side ="left",at=seq(0,nrow(hytestrawdata2),by=2),
                     labels =paste0(seq(max(enrichres3$Count),0,by=-2*round(max(enrichres3$Count)/nrow(hytestrawdata2)))),
                     labels.cex=isolate(input$zitisize))

        fujibeiweizhix<-strsplit(isolate(input$fujibeiweizhi),"_")[[1]]
        leibienames<-unique(enrichres3$Category)
        for(i1 in 1:length(leibienames)){
          fujibeiweizhix1<-as.numeric(strsplit(fujibeiweizhix[i1],";")[[1]])
          circos.text(fujibeiweizhix1[1],fujibeiweizhix1[2],labels = leibienames[i1],
                      sector.index ="b",facing = "bending.outside", cex = 1)
        }
        #circos.text(2,-2,labels = "BP",sector.index ="b",facing = "bending.outside", cex = 1)
        #circos.text(7.5,-2,labels = "CC",sector.index ="b",facing = "bending.outside", cex = 1)
        #circos.text(12,-2,labels = "MF",sector.index ="b",facing = "bending.outside", cex = 1)
        fujiwaiweizhix<-strsplit(isolate(input$fujiwaiweizhi),"_")[[1]]
        fujiwaiweizhix1<-as.numeric(strsplit(fujiwaiweizhix[1],";")[[1]])
        circos.text(fujiwaiweizhix1[1],fujiwaiweizhix1[2],labels = fujiwaiweizhix[2],
                    sector.index ="b",facing = "bending.outside", cex = 1.2)
        fugaibanjingx<-as.numeric(strsplit(isolate(input$fugaibanjing),";")[[1]])

        if(isolate(input$fugaicolif)){
          fugaicolx<-strsplit(isolate(input$fugaicol),";")[[1]]
          fugaiweizhix<-strsplit(isolate(input$fugaiweizhi),"_")[[1]]
          for(i2 in 1:length(fugaiweizhix)){
            fugaiweizhix1<-as.numeric(strsplit(fugaiweizhix[i2],";")[[1]])
            draw.sector(fugaiweizhix1[1],fugaiweizhix1[2], rou1 = fugaibanjingx[1], rou2 = fugaibanjingx[2],
                        col = adjustcolor(fugaicolx[i2], alpha.f =isolate(input$fugaicolalpha)), clock.wise = FALSE)
          }
        }
        #draw.sector(18,43.5, rou1 = 1, rou2 = 0.6, col = adjustcolor("red", alpha.f =0.3), clock.wise = FALSE)
        #draw.sector(-10,18, rou1 = 1, rou2 = 0.6, col = adjustcolor("blue", alpha.f =0.3), clock.wise = FALSE)
        #draw.sector(-35,-10, rou1 = 1, rou2 = 0.6, col = adjustcolor("purple", alpha.f =0.3), clock.wise = FALSE)

        linkjianjux<-as.numeric(strsplit(isolate(input$linkjianju),";")[[1]])
        xx1<-seq(0.5,ncol(hytestrawdata2))
        xx2<-colnames(hytestrawdata2)
        xx3<-seq(1,nrow(enrichres3))-0.5
        xx4<-enrichres3$Objects
        for(ii in 1:length(xx2)){
          ii1<-grep(xx2[ii],xx4,ignore.case = FALSE,perl = TRUE)
          if(length(ii1)>0){
            for(ik in ii1){
              circos.link("a", xx1[ii], "b", xx3[ik],rou1 =linkjianjux[1],rou2 =linkjianjux[2],
                          col = adjustcolor(duixianglinkcolx1[ii], alpha.f =input$touminglink))
            }
          }
        }

        circos.clear()

        lgd_links = Legend(at = c(rangeres1[1]-0.5, mean(rangeres1), rangeres1[2]+0.5),col_fun = col_funxx,
                           title_position = "topleft", title = "Intensity", direction = "horizontal")
        draw(lgd_links, x = unit(1, "npc") - unit(80, "mm"), y = unit(40, "mm"), just = "top")
      })
      output$mfunctionalinkplotdl<-downloadHandler(
        filename = function(){paste("Functionalinkplot_",usertimenum,".pdf",sep="")},
        content = function(file){
          pdf(file,height=linkpheightx()/100+3,width=linkpheightx()/100+3)
          print(mfunctionalinkplotout())
          dev.off()
        }
      )
    })

})

shinyApp(ui = ui, server = server)
