# https://alyeskabear.shinyapps.io/BNandCausalinference/

# Install the following packages prior to using the shiny app.
# install.packages("devtools")
# library(devtools)
# Packages on CRAN
# install.packages(c("shiny","shinydashboard","shinydashboardPlus","sqldf","writexl","readxl","reshape2","DT","bnlearn","ggsci","shinyjqui","ggplot2","visNetwork","pROC","rmda","knitr"))
# 
# Packages on Bioconductor
# For R version 3.5 or greater, install Bioconductor packages using BiocManager; see https://bioconductor.org/install
# if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
# BiocManager::install(c("gRain","igraph","AnnotationDbi","EBImage"))
# # Others
# source("http://bioconductor.org/biocLite.R")
# biocLite(c("gRain","igraph","AnnotationDbi","EBImage"))
# 
# Packages on Github
# install_github(c("ramnathv/rblocks","woobe/rPlotter"))
#  
# install.packages(c("bnlearn","arules","shiny", "shinythemes", "rhandsontable", "DiagrammeR"), dependencies=TRUE)
# if (!requireNamespace("BiocManager", quietly = TRUE))
# install.packages("BiocManager", dependencies=TRUE)
# BiocManager::install(c("graph", "Rgraphviz", "RBGL"), dependencies=TRUE)
# install.packages("gRain", dependencies=TRUE)
# install.packages("BiocInstaller", repos="http://www.bioconductor.org/packages/3.14/bioc")
options(repos = BiocManager::repositories())
library(BiocManager)
library(bnlearn)
library(gRain)
library(arules)
library(dplyr)
library(shiny)
library(shinythemes)
library(rhandsontable)
library(DiagrammeR)
linebreaks <- function(n){HTML(strrep(br(), n))}

ex1.Sex<-data.frame(Male=character(1),Female=character(1))
ex1.Pregnancy<-data.frame(Sex=c("Male", "Female"), Yes=character(2), No=character(2))

ex2.Sex<-data.frame(Male=character(1),Female=character(1))
ex2.Color<-data.frame(Sex=c("Male", "Female"), Black=character(2), Blue=character(2), Red=character(2))

ex3.Sex<-data.frame(Male=character(1),Female=character(1))
ex3.Treatment<-data.frame(Medication=character(1), Placebo=character(1))
ex3.Recovery<-data.frame(Sex=c("Male","Male","Female","Female"),
                         Treatment=c("Medication","Placebo","Medication","Placebo"),
                         Yes=character(4),
                         No=character(4))


ex4.Jen<-data.frame(Door1=character(1),Door2=character(1),Door3=character(1))
ex4.Car<-data.frame(Door1=character(1),Door2=character(1),Door3=character(1))
ex4.Host<-data.frame(Jen=c("Door1","Door1","Door1","Door2","Door2","Door2","Door3","Door3","Door3"),
                     Car=c("Door1","Door2","Door3","Door1","Door2","Door3","Door1","Door2","Door3"),
                     Door1=character(9),
                     Door2=character(9),
                     Door3=character(9))


# ex1.Sex<-data.frame(Male=c("100/200"),Female=c("100/200"))
# ex1.Pregnancy<-data.frame(Sex=c("Male", "Female"), Yes=c("0/100","10/100"), No=c("100/100","90/100"))
# 
# ex2.Sex<-data.frame(Male=c("50/100"),Female=c("50/100"))
# ex2.Color<-data.frame(Sex=c("Male", "Female"), Black=c("25/50","5/50"), Blue=c("15/50","10/50"), Red=c("10/50","35/50"))
# 
# ex3.Sex<-data.frame(Male=c("40/80"),Female=c("40/80"))
# ex3.Treatment<-data.frame(Medication=c("40/80"), Placebo=c("40/80"))
# ex3.Recovery<-data.frame(Sex=c("Male","Male","Female","Female"),
#                          Treatment=c("Medication","Placebo","Medication","Placebo"),
#                          Yes=c("18/30", "7/10", "2/10", "9/30"),
#                          No=c("12/30","3/10","8/10","21/30"))
# 
# 
# ex4.Jen<-data.frame(Door1=c("1/3"),Door2=c("1/3"),Door3=c("1/3"))
# ex4.Car<-data.frame(Door1=c("1/3"),Door2=c("1/3"),Door3=c("1/3"))
ex4.Host<-data.frame(Jen=c("Door1","Door1","Door1","Door2","Door2","Door2","Door3","Door3","Door3"),
                     Car=c("Door1","Door2","Door3","Door1","Door2","Door3","Door1","Door2","Door3"),
                     Door1=c("0","0","0","0","1/2","1","0","1","1/2"),
                     Door2=c("1/2","0","1","0","0","0","1","0","1/2"),
                     Door3=c("1/2","1","0","1","1/2","0","0","0","0"))


ui <- fluidPage(theme=shinytheme("united"),
                # Application title
                titlePanel(h2("Introducing Causal Inference Using Bayesian Networks and do-Calculus", align="center")),
                HTML("<em>", 
                     paste(
                         h4(" ", align="center"),"</em>"),
                     linebreaks(0),
                     HTML("<em>", 
                          paste(
                              h4(" ", align="center")),"</em>")
                ),
                
                # FluidRow Panel
                fluidRow(
                    column(4,
                           wellPanel(HTML("<span style='line-height: 150%'><b>Download the app instruction</b> </span> <br>"),
                                     downloadButton("downloadfile0", label = "Download")),
                           wellPanel(radioButtons("example","Select an example",list("Sex as a Cause of Pregnancy",
                                                                                      "Color of Children's Shoes",
                                                                                      "Efficacy of Medication Treatment",
                                                                                      "Should I Switch?",
                                                                                      "Effect of Smoking on Forced Expiratory Volume"),
                                                  selected="Sex as a Cause of Pregnancy")),
                           
                           wellPanel(HTML("<b>The Bayes Network model structure </b>"),
                                     uiOutput("BNmodel")),
                           
                           wellPanel(conditionalPanel(
                                        condition = "input.example != 'Effect of Smoking on Forced Expiratory Volume'",
                                            uiOutput("vars"),
                                            actionButton("runButton","Apply")),
                                     conditionalPanel(
                                         condition = "input.example == 'Effect of Smoking on Forced Expiratory Volume'",
                                            # fileInput("file", "Upload the CSV data file")
                                         HTML("<span style='line-height: 150%'><b>Load the example data file from JSDSE website</b> </span> <br>"),
                                            actionButton("downloadkey","Load"))
                                     ),
                           
                           wellPanel(HTML("<span style='line-height: 150%'><b> Model compiling </b> </span> <br>"),
                                     actionButton("runButton2","Compile")),
                           
                           wellPanel(HTML("<b> Node intervention and manipulation </b>"),
                                     textInput("N", "Intervene on the nodes of", "", placeholder = "e.g., A, B, C"),
                                     textInput("S", "Fix their states at", "", placeholder = "e.g., a, b, c"),
                                     actionButton("runButton3","Apply")),
                           
                           wellPanel(uiOutput("vars2")),
                           
                           wellPanel(HTML("<span style='line-height: 150%'><b>Download the sample R code</b> </span> <br>"),
                                     downloadButton("downloadfile", label = "Download"))
                           
                    ),
                    column(8,
                           tabsetPanel(tabPanel("DAG",plotOutput("dag")),
                                       tabPanel("Prob. Table/Data File",
                                                conditionalPanel(
                                                    condition = "input.example != 'Effect of Smoking on Forced Expiratory Volume'",
                                                        rHandsontableOutput('BNInput')),
                                                conditionalPanel(
                                                    condition = "input.example == 'Effect of Smoking on Forced Expiratory Volume'",
                                                    dataTableOutput('input_file')),
                                               ),
                                       tabPanel("Preintervention Model",plotOutput("preInt",height = "1000px",
                                                                                    width = "800px")),
                                       tabPanel("Postintervention Distribution",
                                                conditionalPanel(
                                                    condition = "input.var2=='pregnancy'|input.var2=='color'|input.var2=='recovery'|input.var2=='host'|input.var2=='fev'",
                                                    HTML("<b> Marginal Distribution </b>"),
                                                    verbatimTextOutput("postIntM")),
                                                HTML("<b> Conditional Distribution </b>"),
                                                plotOutput("postIntC",height = "1000px", width = "800px"))
                                       #id="tsp"
                           )
                    )
                )
)

# Define server logic required to draw a histogram

server<-function(input, output, session){
    
    output$BNmodel <- renderUI({
        if(input$example=="Sex as a Cause of Pregnancy"){
            HTML("P(Sex,Pregnancy)=P(Sex)P(Pregnancy|Sex)") # Example 1
        } 
        
        else if(input$example=="Color of Children's Shoes"){
            HTML("P(Sex,Color)=P(Sex)P(Color|Sex)") # Example 2
        }
        
        else if(input$example=="Efficacy of Medication Treatment"){
            HTML("P(Treatment,Sex,Recovery)=P(Recovery|Sex,Treatment)P(Treatment)P(Sex)") # Example 3
        }
        
        else if(input$example=="Should I Switch?"){
            HTML("P(Host,Jen,Car)=P(Jen)P(Car)P(Jen)P(Host|Jen,Car)") # Example 4
        }
        
        else if(input$example=="Effect of Smoking on Forced Expiratory Volume"){
            HTML("P(FEV,Smoke,Age,Sex) = P(FEV|Smoke,Age,Sex)P(Height|Smoke,Age,Sex)P(Smoke|Age, Sex)P(Age)P(Sex)") # Example 5
        }
    })
    
    output$dag<-renderPlot({
        if(input$example=="Sex as a Cause of Pregnancy"){
            Ex1.DAG <- model2network('[Sex][Pregnancy|Sex]')
            graphviz.plot(Ex1.DAG) # Example 1
        } 
        
        else if(input$example=="Color of Children's Shoes"){
            Ex2.DAG <- model2network('[Sex][Color|Sex]')
            graphviz.plot(Ex2.DAG) # Example 2
        }
        
        else if(input$example=="Efficacy of Medication Treatment"){
            Ex3.DAG <- model2network('[Sex][Treatment][Recovery|Sex:Treatment]')
            graphviz.plot(Ex3.DAG) # Example 3
        }
        
        else if(input$example=="Should I Switch?"){
            Ex4.DAG <- model2network('[Jen][Car][Host|Jen:Car]')
            graphviz.plot(Ex4.DAG) # Example 4
        }
        
        else if(input$example=="Effect of Smoking on Forced Expiratory Volume"){
            Ex5.DAG <- model2network("[Sex][Age][Smoke|Sex:Age][Height|Sex:Age:Smoke][FEV|Sex:Age:Smoke:Height]")
            graphviz.plot(Ex5.DAG) # Example 5
        }
        
    })
    output$vars <- renderUI({
        if(input$example=="Sex as a Cause of Pregnancy"){
            radioButtons("var","Complete the probability table(i.e., the row sum of each row is one) for",selected="sex",
                         list("Sex"="sex","Pregnancy"="pregnancy") # Example 1
            )
        } 
        
        else if(input$example=="Color of Children's Shoes"){
            radioButtons("var","Complete the probability table(i.e., the row sum of each row is one) for",selected="sex",
                         list("Sex"="sex","Color"="color") # Example 2
            )
        }
        
        else if(input$example=="Efficacy of Medication Treatment"){
            radioButtons("var","Complete the probability table(i.e., the row sum of each row is one) for",selected="sex",
                         list("Sex"="sex","Treatment"="treatment", "Recovery"="recovery") # Example 3
            )
        }
        
        else if(input$example=="Should I Switch?"){
            radioButtons("var","Complete conditional probability table(i.e., the row sum of each row is one) for",selected="jen",
                         list("Jen"="jen","Car"="car", "Host"="host") # Example 4
            )
        }
        
        # else if(input$example=="Effect of Smoking on Forced Expiratory Volume"){
        #     radioButtons("var","Distribution:",selected="chisq",
        #                  list("Chi-squared"="chisq","Exponential"="exp","Normal"="norm","t"="t","Uniform"="unif")
        #     )
        # }
    })
    
    output$BNInput <- renderRHandsontable({
        if ((input$example=="Sex as a Cause of Pregnancy")&(input$var=="sex")){
            if (is.null(ex1.Sex.values$data)==FALSE) {rhandsontable(ex1.Sex.values$data)}
            else {rhandsontable(ex1.Sex)}
        }
        else if ((input$example=="Sex as a Cause of Pregnancy")&(input$var=="pregnancy")){
            if (is.null(ex1.Pregnancy.values$data)==FALSE) {rhandsontable(ex1.Pregnancy.values$data)}
            else {rhandsontable(ex1.Pregnancy)}
            }
        
        else if ((input$example=="Color of Children's Shoes")&(input$var=="sex")){
            if (is.null(ex2.Sex.values$data)==FALSE) {rhandsontable(ex2.Sex.values$data)}
            else {rhandsontable(ex2.Sex)}
            }
        else if ((input$example=="Color of Children's Shoes")&(input$var=="color")){
            if (is.null(ex2.Color.values$data)==FALSE) {rhandsontable(ex2.Color.values$data)}
            else {rhandsontable(ex2.Color)}
            }
        
        else if ((input$example=="Efficacy of Medication Treatment")&(input$var=="sex")){
            if (is.null(ex3.Sex.values$data)==FALSE) {rhandsontable(ex3.Sex.values$data)}
            else {rhandsontable(ex3.Sex)}
            }
        else if ((input$example=="Efficacy of Medication Treatment")&(input$var=="treatment")){
            if (is.null(ex3.Treatment.values$data)==FALSE) {rhandsontable(ex3.Treatment.values$data)}
            else {rhandsontable(ex3.Treatment)}
            }
        else if ((input$example=="Efficacy of Medication Treatment")&(input$var=="recovery")){
            if (is.null(ex3.Recovery.values$data)==FALSE) {rhandsontable(ex3.Recovery.values$data)}
            else {rhandsontable(ex3.Recovery)}
            }
        
        else if ((input$example=="Should I Switch?")&(input$var=="jen")){
            if (is.null(ex4.Jen.values$data)==FALSE) {rhandsontable(ex4.Jen.values$data)}
            else {rhandsontable(ex4.Jen)}
            }
        else if ((input$example=="Should I Switch?")&(input$var=="car")){
            if (is.null(ex4.Car.values$data)==FALSE) {rhandsontable(ex4.Car.values$data)}
            else {rhandsontable(ex4.Car)}
            }
        else if ((input$example=="Should I Switch?")&(input$var=="host")){
            if (is.null(ex4.Host.values$data)==FALSE) {rhandsontable(ex4.Host.values$data)}
            else {rhandsontable(ex4.Host)}
            }
    })
    
    observeEvent(input$downloadkey, {
    output$input_file<-renderDataTable({
        # file_to_read = input$file
        # if (is.null(file_to_read)){
        #     return()
        # }
        # 
        # read.table(file_to_read$datapath, header = TRUE, sep = ",")
        read.table("http://jse.amstat.org/datasets/fev.dat.txt", col.names = c("Age", "FEV", "Height", "Sex",	"Smoke"))
    }, options = list(pageLength = 10))
    })
    
    ex1.Sex.values <- reactiveValues()
    ex1.Pregnancy.values <- reactiveValues()
    
    ex2.Sex.values <- reactiveValues()
    ex2.Color.values <- reactiveValues()
    
    ex3.Sex.values <- reactiveValues()
    ex3.Treatment.values <- reactiveValues()
    ex3.Recovery.values <- reactiveValues()
    
    
    ex4.Jen.values <- reactiveValues()
    ex4.Car.values <- reactiveValues()
    ex4.Host.values <- reactiveValues()
    
    
    observeEvent(input$runButton, {
        if ((input$example=="Sex as a Cause of Pregnancy")&(input$var=="sex")){
            ex1.Sex.values$data <-  hot_to_r(input$BNInput)}
        else if ((input$example=="Sex as a Cause of Pregnancy")&(input$var=="pregnancy")){
            ex1.Pregnancy.values$data <-  hot_to_r(input$BNInput)}
        
        else if ((input$example=="Color of Children's Shoes")&(input$var=="sex")){
            ex2.Sex.values$data <-  hot_to_r(input$BNInput)}
        else if ((input$example=="Color of Children's Shoes")&(input$var=="color")){
            ex2.Color.values$data <-  hot_to_r(input$BNInput)}
        
        else if ((input$example=="Efficacy of Medication Treatment")&(input$var=="sex")){
            ex3.Sex.values$data <-  hot_to_r(input$BNInput)}
        else if ((input$example=="Efficacy of Medication Treatment")&(input$var=="treatment")){
            ex3.Treatment.values$data <-  hot_to_r(input$BNInput)}
        else if ((input$example=="Efficacy of Medication Treatment")&(input$var=="recovery")){
            ex3.Recovery.values$data <-  hot_to_r(input$BNInput)}
        
        else if ((input$example=="Should I Switch?")&(input$var=="jen")){
            ex4.Jen.values$data <-  hot_to_r(input$BNInput)}
        else if ((input$example=="Should I Switch?")&(input$var=="car")){
            ex4.Car.values$data <-  hot_to_r(input$BNInput)}
        else if ((input$example=="Should I Switch?")&(input$var=="host")){
            ex4.Host.values$data <-  hot_to_r(input$BNInput)}
        
    })
    
    output$BNOutput <- DT::renderDataTable({
        if ((input$example=="Sex as a Cause of Pregnancy")&(input$var=="sex")){ex1.Sex.values$data}
        else if ((input$example=="Sex as a Cause of Pregnancy")&(input$var=="pregnancy")){ex1.Pregnancy.values$data}
        
        else if ((input$example=="Color of Children's Shoes")&(input$var=="sex")){ex2.Sex.values$data}
        else if ((input$example=="Color of Children's Shoes")&(input$var=="color")){ex2.Color.values$data}
        
        else if ((input$example=="Efficacy of Medication Treatment")&(input$var=="sex")){ex3.Sex.values$data}
        else if ((input$example=="Efficacy of Medication Treatment")&(input$var=="treatment")){ex3.Treatment.values$data}
        else if ((input$example=="Efficacy of Medication Treatment")&(input$var=="recovery")){ex3.Recovery.values$data}
        
        else if ((input$example=="Should I Switch?")&(input$var=="jen")){ex4.Jen.values$data}
        else if ((input$example=="Should I Switch?")&(input$var=="car")){ex4.Car.values$data}
        else if ((input$example=="Should I Switch?")&(input$var=="host")){ex4.Host.values$data}
    })
    
    
    Ex1.fit <- reactiveValues()
    Ex2.fit<- reactiveValues()
    Ex3.fit<- reactiveValues()
    Ex4.fit <- reactiveValues()
    Ex5.fit <- reactiveValues()
    
    observeEvent(input$runButton2, {
        if (input$example=="Sex as a Cause of Pregnancy"){
            # Propose the causal structure
            # P(Sex,Pregnancy)=P(Sex)P(Pregnancy|Sex)
            Ex1.DAG <- model2network('[Sex][Pregnancy|Sex]')
            
            # Create the probability tables for the nodes of Sex and Pregnancy
            # specify different states of a node
            sex <- c("Male","Female")
            pregnancy<-c("Yes","No")
            
            Sex.value<-as.data.frame(ex1.Sex.values$data)
            Sex.value<-as.matrix(Sex.value) 
            Sex.value<-sapply(Sex.value, function(x) eval(parse(text=x)))
            
            
            # parent node
            # S <- array(dimnames = list(Sex = sex), dim = 2, c(100/200,100/200))
            
            S <- array(dimnames = list(Sex = sex), dim = 2, Sex.value)
            # the Pregnancy node 
            
            Pregnancy.value<-as.data.frame(ex1.Pregnancy.values$data)
            Pregnancy.value<-t(as.matrix(Pregnancy.value)) 
            Pregnancy.value[2:3,1:2]<-sapply(Pregnancy.value[2:3,1:2], function(x) eval(parse(text=x)))
            suppressWarnings(Pregnancy.value<-matrix(as.numeric(Pregnancy.value),    # Convert to numeric matrix
                                                     ncol = ncol(Pregnancy.value)))
            
            # child node <-- parent node
            #PR <- array(dimnames = list(Pregnancy=pregnancy, Sex = sex 
            #                            ), dim = c(2,2), c(0,100/100,
            #                                               10/100,90/100))
            
            PR <- array(dimnames = list(Pregnancy=pregnancy, Sex = sex 
            ), dim = c(2,2), Pregnancy.value[2:3,1:2])
            
            # Check the created probability tables
            S  # the Sex node 
            PR # the Pregnancy node 
            
            # Feed the probability tables to the causal structure
            cpts <- list(Sex = S, Pregnancy = PR)
            Ex1.fit$graph = custom.fit(Ex1.DAG, cpts)
            }
        
        else if ((input$example=="Color of Children's Shoes")){
            # Propose the causal structure
            # P(Sex,Color)=P(Sex)P(Color|Sex)
            Ex2.DAG <- model2network('[Sex][Color|Sex]')
            
            # Create the probability tables for the nodes of Sex and Color
            # specify different states of a node
            sex <- c("Male","Female")
            color<-c("Black","Blue", "Red" )
            
            # assign probability values to different states
            # the Sex node 
            # parent node
            
            Sex.value<-as.data.frame(ex2.Sex.values$data)
            Sex.value<-as.matrix(Sex.value) 
            Sex.value<-sapply(Sex.value, function(x) eval(parse(text=x)))
            
            
            # S <- array(dimnames = list(Sex = sex), dim = 2, c(50/100,50/100))
            S <- array(dimnames = list(Sex = sex), dim = 2, Sex.value)
            # the Color node 
            # child node <-- parent node
            
            Color.value<-as.data.frame(ex2.Color.values$data)
            Color.value<-t(as.matrix(Color.value)) 
            Color.value[2:4,1:2]<-sapply(Color.value[2:4,1:2], function(x) eval(parse(text=x)))
            suppressWarnings(Color.value<-matrix(as.numeric(Color.value),    # Convert to numeric matrix
                                                     ncol = ncol(Color.value)))
            
            C <- array(dimnames = list(Color=color, Sex = sex 
            ), dim = c(3,2), Color.value[2:4,1:2])
            # Check the created probability tables
            S  # the Sex node 
            C # the Color node 
            
            # Feed the probability tables to the causal structure
            cpts <- list(Sex = S, Color = C)
            Ex2.fit$graph = custom.fit(Ex2.DAG, cpts)}
        
        else if (input$example=="Efficacy of Medication Treatment"){
            # Propose the causal structure
            # P(Treatment, Sex, Recovery)=P(Recovery|Sex,Treatment)P(Treatment)P(Sex)
            Ex3.DAG <- model2network('[Sex][Treatment][Recovery|Sex:Treatment]')
            
            # Create the probability tables for the nodes of Recovery, Treatment and Sex
            # specify different states of a node
            recovery<- c("Yes","No")
            treatment<-c("Medication","Placebo")
            sex<-c("Male","Female")
            
            # assign probability values to different states
            # the Sex node
            # parent node
            Sex.value<-as.data.frame(ex3.Sex.values$data)
            Sex.value<-as.matrix(Sex.value) 
            Sex.value<-sapply(Sex.value, function(x) eval(parse(text=x)))
            
            S <- array(dimnames = list(Sex = sex # Male=18+12+7+3=40; Female=2+8+9+21=40
            ), dim = 2, Sex.value)
            
            # the Treatment node
            # parent node
            Treatment.value<-as.data.frame(ex3.Treatment.values$data)
            Treatment.value<-as.matrix(Treatment.value) 
            Treatment.value<-sapply(Treatment.value, function(x) eval(parse(text=x)))
            
            T <- array(dimnames = list(Treatment=treatment
                                       # Medication =18+12+2+8=40
                                       # Placebo =7+3+9+21=40
                                       
            ), dim = 2, Treatment.value)
            
            # the Recovery node
            # child node <-- parent node, parent node
            
            Recovery.value<-as.data.frame(ex3.Recovery.values$data)
            Recovery.value<-t(as.matrix(Recovery.value)) 
            Recovery.value[3:4,1:4]<-sapply(Recovery.value[3:4,1:4], function(x) eval(parse(text=x)))
            suppressWarnings(Recovery.value<-matrix(as.numeric(Recovery.value),    # Convert to numeric matrix
                                                     ncol = ncol(Recovery.value)))
            
            R <- array(dimnames = list(Recovery=recovery, Treatment=treatment, Sex = sex
                                       # Yes Medication Male=18
                                       # No Medication Male=12
                                       # Yes Placebo Male=7
                                       # No Placebo Male=3
                                       
                                       # Yes Medication Female=2
                                       # No Medication Female=8 
                                       # Yes Placebo Female=9
                                       # No Placebo Female=21 
                                       
            ), dim = c(2,2,2), Recovery.value[3:4,1:4])
            
            # Check the created probability tables
            S   # the Sex node
            T  # the Treatment node
            R # the Recovery node
            
            # Feed the probability tables to the causal structure
            cpts <- list(Recovery = R, Treatment = T, Sex=S)
            Ex3.fit$graph = custom.fit(Ex3.DAG, cpts)}
        
        else if (input$example=="Should I Switch?"){
            # Propose the causal structure
            # P(Host, Jen, Car)=P(Jen)P(Car)P(Jen)P(Host|Jen,Car)
            Ex4.DAG <- model2network('[Jen][Car][Host|Jen:Car]')
            
            # Create the probability tables for the nodes of Sex and Color
            # specify different states of a node
            jen <- c("Door1","Door2", "Door3")
            car<-c("Door1","Door2", "Door3")
            host<-c("Door1","Door2", "Door3")
            
            # assign probability values to different states
            # the Jen node 
            # parent node
            Jen.value<-as.data.frame(ex4.Jen.values$data)
            Jen.value<-as.matrix(Jen.value) 
            Jen.value<-sapply(Jen.value, function(x) eval(parse(text=x)))
            
            J <- array(dimnames = list(Jen = jen), dim = 3, Jen.value)
            
            # the Car node 
            # parent node
            Car.value<-as.data.frame(ex4.Car.values$data)
            Car.value<-as.matrix(Car.value) 
            Car.value<-sapply(Car.value, function(x) eval(parse(text=x)))
            
            C <- array(dimnames = list(Car=car), dim = 3, Car.value)
            
            # the Host node
            # child node <-- parent node, parent node
            Host.value<-as.data.frame(ex4.Host.values$data)
            Host.value<-t(as.matrix(Host.value)) 
            Host.value[3:5,1:9]<-sapply(Host.value[3:5,1:9], function(x) eval(parse(text=x)))
            suppressWarnings(Host.value<-matrix(as.numeric(Host.value),    # Convert to numeric matrix
                                                     ncol = ncol(Host.value)))
            
            
            H <- array(dimnames = list(Host=host, Jen=jen,  Car=car 
                                       # Door1	Door1: Door1	0
                                       # Door2	Door1: Door1	1/2
                                       # Door3	Door1: Door1	1/2
                                       # Door1	Door2: Door1	0
                                       # Door2	Door2: Door1	0
                                       # Door3	Door2: Door1	1
                                       # Door1	Door3: Door1	0
                                       # Door2	Door3: Door1	1
                                       # Door3	Door3: Door1	0
                                       
                                       # Door1	Door1: Door2	0
                                       # Door2	Door1: Door2	0
                                       # Door3	Door1: Door2	1
                                       # Door1	Door2: Door2	1/2
                                       # Door2	Door2: Door2	0
                                       # Door3	Door2: Door2	1/2
                                       # Door1	Door3: Door2	1
                                       # Door2	Door3: Door2	0
                                       # Door3	Door3: Door2	0
                                       
                                       # Door1	Door1: Door3  0
                                       # Door2	Door1: Door3	1
                                       # Door3	Door1: Door3	0
                                       # Door1	Door2: Door3	1
                                       # Door2	Door2: Door3	0
                                       # Door2	Door2: Door3	0
                                       # Door1	Door3: Door3	1/2
                                       # Door2	Door3: Door3	1/2
                                       # Door3	Door3: Door3	0   
                                       
                                       
            ), dim = c(3,3,3), Host.value[3:5, 1:9])
            
            H
            
            # Check the created probability tables
            J  # the Jen node 
            C # the Car node 
            H # the Host node
            
            # Feed the probability tables to the causal structure
            cpts <- list(Jen = J, Car = C, Host=H)
            Ex4.fit$graph = custom.fit(Ex4.DAG, cpts)
            }
        
        else if (input$example=="Effect of Smoking on Forced Expiratory Volume"){
            # file_to_use = input$file
            # if (is.null(file_to_use)){
            #     return()
            # }
            #FEV.data1<-read.table(file_to_use$datapath, header = TRUE, sep = ",")
            #FEV.data<-data.frame(apply(FEV.data, 2, function(x) as.numeric(as.character(x))))
            #FEV.data<-FEV.data1
            
            FEV.data<-read.table("http://jse.amstat.org/datasets/fev.dat.txt", col.names = c("Age", "FEV", "Height", "Sex",	"Smoke"))
            # Discretize age, fev, and height.
            FEV.data.discrete<-data.frame(Age=arules::discretize(FEV.data$Age, method = "fixed", breaks = c(3, 5, 12, 15, 19), include.lowest=TRUE, right=FALSE, labels = c("3 to 5", 
                                                                                                                                                                            "5 to 12", 
                                                                                                                                                                            "12 to 15", 
                                                                                                                                                                            "15 to 19")),
                                          FEV=arules::discretize(FEV.data$FEV, method = "fixed", breaks = c(0, 1, 2, 3, 4, 5, 6), include.lowest=TRUE, right=FALSE, labels = c("0 to 1", 
                                                                                                                                                                               "1 to 2", 
                                                                                                                                                                               "2 to 3", 
                                                                                                                                                                               "3 to 4",
                                                                                                                                                                               "4 to 5",
                                                                                                                                                                               "5 to 6")),
                                          Height=arules::discretize(FEV.data$Height, method = "fixed", breaks = c(45, 50, 55, 60, 65, 70, 75), include.lowest=TRUE, right=FALSE, labels = c("45 to 50", 
                                                                                                                                                                                            "50 to 55", 
                                                                                                                                                                                            "55 to 60", 
                                                                                                                                                                                            "60 to 65",
                                                                                                                                                                                            "65 to 70",
                                                                                                                                                                                            "70 to 75")),
                                          Sex=as.factor(FEV.data$Sex),
                                          Smoke=as.factor(FEV.data$Smoke))
            
            # Convert all data to be of factor format.
            FEV.data.discrete<- FEV.data.discrete %>% mutate_if((~is.factor(.)==FALSE), as.factor)
            
            # Propose the causal structure
            # P(FEV,Smoke,Age,Sex) = P(FEV|Smoke,Age,Sex)P(Height|Smoke,Age,Sex)P(Smoke|Age, Sex)P(Age)P(Sex)
            Ex5.DAG <- model2network("[Sex][Age][Smoke|Sex:Age][Height|Sex:Age:Smoke][FEV|Sex:Age:Smoke:Height]")
            graphviz.plot(Ex5.DAG)
            
            # Feed the probability tables to the causal structure
            Ex5.fit$graph<-bn.fit(Ex5.DAG, FEV.data.discrete, method = 'bayes', iss=290) 
            #---------------------------------------------------------------------------------------------------#
            # When building a BN model from an empirical data file, Netica follows a specific way to avoid the 
            # zero-probability problem. Suppose a data file contains three records for the variable X 
            # with possible values x1 and x2, as below
            #                                     X
            #                                     x1
            #                                     x1
            #                                     x1
            #
            # The frequency table for X based on this data file is 
            #                               x1    x2
            #                           X   3      0
            #
            # To avoid the zero probability for X=x2, Netica adds one to both frequencies of x1 and x2,
            #                               x1    x2
            #                           X   4      1
            #
            # Then the proability table is calculated to be 
            #                               x1    x2
            #                           X   0.8   0.2
            #
            # In the bn.fit() function, setting method = 'bayes' and iss(imaginary sample size) = 290 approximates 
            # the Netica's way of aoviding the zero-probability problem for this example.
            #---------------------------------------------------------------------------------------------------#
            }
        
        
    })
    
    output$preInt<-renderPlot({
        if(input$example=="Sex as a Cause of Pregnancy"){
            graphviz.chart(Ex1.fit$graph,type = "barprob", scale = c(1.25, 2), bar.col = "green", strip.bg = "lightgray") # Example 1
        } 
        
        else if(input$example=="Color of Children's Shoes"){
            graphviz.chart(Ex2.fit$graph, type = "barprob", scale = c(1.25, 2), bar.col = "green", strip.bg = "lightgray") # Example 2
        }
        
        else if(input$example=="Efficacy of Medication Treatment"){
            graphviz.chart(Ex3.fit$graph, type = "barprob", scale = c(1.25, 2), bar.col = "green", strip.bg = "lightgray") # Example 3
        }
        
        else if(input$example=="Should I Switch?"){
            graphviz.chart(Ex4.fit$graph, type = "barprob", scale = c(1.25, 2), bar.col = "green", strip.bg = "lightgray") # Example 4
        }
        
        else if(input$example=="Effect of Smoking on Forced Expiratory Volume"){
            Ex5.DAG <- model2network("[Sex][Age][Smoke|Sex:Age][Height|Sex:Age:Smoke][FEV|Sex:Age:Smoke:Height]")
            graphviz.chart(Ex5.fit$graph, type = "barprob", scale = c(1.5, 2), bar.col = "green", strip.bg = "lightgray")  # Example 5
        }
        
    })
    
    Ex1.postInt <- reactiveValues()
    Ex2.postInt<- reactiveValues()
    Ex3.postInt<- reactiveValues()
    Ex4.postInt <- reactiveValues()
    Ex5.postInt <- reactiveValues()
    
    observeEvent(input$runButton3, {
        if (input$example=="Sex as a Cause of Pregnancy"){
            Nodes<-gsub("(^[[:space:]]+|[[:space:]]+$)", "", strsplit(input$N, ',')[[1]])
            States<-gsub("(^[[:space:]]+|[[:space:]]+$)", "", strsplit(input$S, ',')[[1]])
            junction<-compile(as.grain(Ex1.fit$graph))
            Ex1.postInt$result<-setEvidence(junction, nodes=Nodes, states=States) # Example 1
        }
        
        else if (input$example=="Color of Children's Shoes"){
            Nodes<-gsub("(^[[:space:]]+|[[:space:]]+$)", "", strsplit(input$N, ',')[[1]])
            States<-gsub("(^[[:space:]]+|[[:space:]]+$)", "", strsplit(input$S, ',')[[1]])
            junction<-compile(as.grain(Ex2.fit$graph))
            Ex2.postInt$result<-setEvidence(junction, nodes=Nodes, states=States)} # Example 2
        
        else if (input$example=="Efficacy of Medication Treatment"){
            Nodes<-gsub("(^[[:space:]]+|[[:space:]]+$)", "", strsplit(input$N, ',')[[1]])
            States<-gsub("(^[[:space:]]+|[[:space:]]+$)", "", strsplit(input$S, ',')[[1]])
            junction<-compile(as.grain(Ex3.fit$graph))
            Ex3.postInt$result<-setEvidence(junction, nodes=Nodes, states=States)} # Example 3
        
        
        else if (input$example=="Should I Switch?"){
            Nodes<-gsub("(^[[:space:]]+|[[:space:]]+$)", "", strsplit(input$N, ',')[[1]])
            States<-gsub("(^[[:space:]]+|[[:space:]]+$)", "", strsplit(input$S, ',')[[1]])
            junction<-compile(as.grain(Ex4.fit$graph))
            Ex4.postInt$result<-setEvidence(junction, nodes=Nodes, states=States)} # Example 4
        
        else if (input$example=="Effect of Smoking on Forced Expiratory Volume"){
            Nodes<-gsub("(^[[:space:]]+|[[:space:]]+$)", "", strsplit(input$N, ',')[[1]])
            States<-gsub("(^[[:space:]]+|[[:space:]]+$)", "", strsplit(input$S, ',')[[1]])
            junction<-compile(as.grain(Ex5.fit$graph))
            Ex5.postInt$result<-setEvidence(junction, nodes=Nodes, states=States)} # Example 5
        
        
    })
    
    output$vars2 <- renderUI({
        if(input$example=="Sex as a Cause of Pregnancy"){
            radioButtons("var2","Postintervention distribution for", selected="sex",
                         list("Sex"="sex","Pregnancy"="pregnancy") # Example 1
            )
        } 
        
        else if(input$example=="Color of Children's Shoes"){
            radioButtons("var2","Postintervention distribution for",selected="sex",
                         list("Sex"="sex","Color"="color") # Example 2
            )
        }
        
        else if(input$example=="Efficacy of Medication Treatment"){
            radioButtons("var2","Postintervention distribution for", selected="sex",
                         list("Sex"="sex","Treatment"="treatment", "Recovery"="recovery") # Example 3
            )
        }
        
        else if(input$example=="Should I Switch?"){
            radioButtons("var2","Postintervention distribution for", selected="jen",
                         list("Jen"="jen","Car"="car", "Host"="host") # Example 4
            )
        }
        
        else if(input$example=="Effect of Smoking on Forced Expiratory Volume"){
            radioButtons("var2","Postintervention distribution for",selected="age",
                         list("Age"="age","Sex"="sex","Smoke"="smoke","Height"="height","FEV"="fev")
            )
        }
    })
    
    output$postIntC<-renderPlot({
        if ((input$example=="Sex as a Cause of Pregnancy")&(input$var2=="sex")){
              bn.fit.barchart(as.bn.fit(Ex1.postInt$result,including.evidence = TRUE)$Sex, main="Sex", xlab="Posterintervention Distribution") # Example 1
        }
        else if ((input$example=="Sex as a Cause of Pregnancy")&(input$var2=="pregnancy")){
            bn.fit.barchart(as.bn.fit(Ex1.postInt$result,including.evidence = TRUE)$Pregnancy, main="Pregnancy", xlab="Posterintervention Distribution") # Example 1
        }
        
        else if ((input$example=="Color of Children's Shoes")&(input$var2=="sex")){
            bn.fit.barchart(as.bn.fit(Ex2.postInt$result,including.evidence = TRUE)$Sex, main="Sex", xlab="Posterintervention Distribution") # Example 2
        }
        else if ((input$example=="Color of Children's Shoes")&(input$var2=="color")){
            bn.fit.barchart(as.bn.fit(Ex2.postInt$result,including.evidence = TRUE)$Color, main="Color", xlab="Posterintervention Distribution") # Example 2
        }
        
        else if ((input$example=="Efficacy of Medication Treatment")&(input$var2=="sex")){
            bn.fit.barchart(as.bn.fit(Ex3.postInt$result,including.evidence = TRUE)$Sex, main="Sex", xlab="Posterintervention Distribution") # Example 3
        }
        else if ((input$example=="Efficacy of Medication Treatment")&(input$var2=="treatment")){
            bn.fit.barchart(as.bn.fit(Ex3.postInt$result,including.evidence = TRUE)$Treatment, main="Treatment", xlab="Posterintervention Distribution") # Example 3
        }
        else if ((input$example=="Efficacy of Medication Treatment")&(input$var2=="recovery")){
            bn.fit.barchart(as.bn.fit(Ex3.postInt$result,including.evidence = TRUE)$Recovery, main="Recovery", xlab="Posterintervention Distribution") # Example 3
        }
        
        else if ((input$example=="Should I Switch?")&(input$var2=="jen")){
            bn.fit.barchart(as.bn.fit(Ex4.postInt$result,including.evidence = TRUE)$Jen, main="Jen", xlab="Posterintervention Distribution") # Example 4
        }
        else if ((input$example=="Should I Switch?")&(input$var2=="car")){
            bn.fit.barchart(as.bn.fit(Ex4.postInt$result,including.evidence = TRUE)$Car, main="Car", xlab="Posterintervention Distribution") # Example 4
        }
        else if ((input$example=="Should I Switch?")&(input$var2=="host")){
            bn.fit.barchart(as.bn.fit(Ex4.postInt$result,including.evidence = TRUE)$Host, main="Host", xlab="Posterintervention Distribution") # Example 4
        }
        
        
        else if ((input$example=="Effect of Smoking on Forced Expiratory Volume")&(input$var2=="age")){
            bn.fit.barchart(as.bn.fit(Ex5.postInt$result,including.evidence = TRUE)$Age, main="Age", xlab="Posterintervention Distribution") # Example 5
        }
        else if ((input$example=="Effect of Smoking on Forced Expiratory Volume")&(input$var2=="sex")){
            bn.fit.barchart(as.bn.fit(Ex5.postInt$result,including.evidence = TRUE)$Sex, main="Sex", xlab="Posterintervention Distribution") # Example 5
        }
        else if ((input$example=="Effect of Smoking on Forced Expiratory Volume")&(input$var2=="smoke")){
            bn.fit.barchart(as.bn.fit(Ex5.postInt$result,including.evidence = TRUE)$Smoke, main="Smoke", xlab="Posterintervention Distribution") # Example 5
        }
        else if ((input$example=="Effect of Smoking on Forced Expiratory Volume")&(input$var2=="height")){
            bn.fit.barchart(as.bn.fit(Ex5.postInt$result,including.evidence = TRUE)$Height, main="Height", xlab="Posterintervention Distribution") # Example 5
        }
        else if ((input$example=="Effect of Smoking on Forced Expiratory Volume")&(input$var2=="fev")){
            bn.fit.barchart(as.bn.fit(Ex5.postInt$result,including.evidence = TRUE)$FEV, main="FEV", xlab="Posterintervention Distribution") # Example 5
        }
    }) 
    
    output$postIntM<-renderPrint({
        if ((input$example=="Sex as a Cause of Pregnancy")&(input$var2=="pregnancy")){
            querygrain(Ex1.postInt$result, nodes="Pregnancy")$Pregnancy
        }
        
        else if ((input$example=="Color of Children's Shoes")&(input$var2=="color")){
            querygrain(Ex2.postInt$result, nodes="Color")$Color # Example 2
        }
        
        else if ((input$example=="Efficacy of Medication Treatment")&(input$var2=="recovery")){
            querygrain(Ex3.postInt$result, nodes="Recovery")$Recovery # Example 3
        }
        
        else if ((input$example=="Should I Switch?")&(input$var2=="host")){
            querygrain(Ex4.postInt$result, nodes="Host")$Host # Example 4
        }
        
        else if ((input$example=="Effect of Smoking on Forced Expiratory Volume")&(input$var2=="fev")){
            querygrain(Ex5.postInt$result, nodes="FEV")$FEV # Example 5
        }
        
    })
    
    output$downloadfile0 <- downloadHandler(
      filename <- function() {
        paste("TheShinyWebApplicationInstruction", "pdf", sep=".")
      },
      
      content <- function(file) {
        file.copy("TheShinyWebApplicationInstruction.pdf", file)
      },
      # contentType = "application/R"
    )
    
    output$downloadfile <- downloadHandler(
      filename <- function() {
        paste("SampleRCode_JSDSE", "R", sep=".")
      },
      
      content <- function(file) {
        file.copy("SampleRCode_JSDSE.R", file)
      },
      contentType = "application/R"
    )

}

# Run the application 
shinyApp(ui = ui, server = server)
