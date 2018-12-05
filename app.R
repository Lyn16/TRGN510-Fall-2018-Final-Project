#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#install all the packages#
library("shiny")
library("markdown")
library("reshape")
library("ggplot2")
library("dendextend")
library("colorspace")
library("dendextend")
library("plotly")
library("dplyr")
library("RColorBrewer")
library("gplots")

#setwd("/Users/lyn/Final_Project")
samples1<-read.csv("patient_sample.csv",  header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, row.names = 2)
genes1<-read.csv("TCGA_AML_mRNA_data_for_analysis.csv", header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, row.names = 2)
#samples1<-read.csv("/Users/lyn/Final_Project/Step3. Data analysis/patient_sample.csv", header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, row.names = 2)
#genes1<-read.csv("/Users/lyn/Final_Project/TCGA_AML_mRNA_data_for_analysis.csv", header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, row.names = 2)
genes1<-genes1[,-1]
samples1<-samples1[,-1]

#tidy the genes1 table#
APOC2_1<-genes1["ENSG00000234906",]
APOC2<-genes1["APOC2_1",]
genes2<-rbind(genes1, APOC2)
highexpression<-which(APOC2_1 > 0.4639374)
lowexpression<-which(APOC2_1 <= 0.05992213 )
mediumexpression<-which(APOC2_1<=0.4639374 & APOC2_1>0.05992213)
genes2["APOC2",]<-replace(genes2["APOC2",], (highexpression), "HIGH")
genes2["APOC2",]<-replace(genes2["APOC2",], (lowexpression), "LOW")
genes2["APOC2",]<-replace(genes2["APOC2",], (mediumexpression), "MEDIUM")
genes2_transsample_all<-t(genes2)

#tidy the samples1 table#
APOC2_expression_level<-as.data.frame(genes2_transsample_all[,"APOC2"])
colnames(APOC2_expression_level)<-"APOC2_levels"
APOC2_expression_value<-as.data.frame(genes2_transsample_all[,"ENSG00000234906"])
colnames(APOC2_expression_value)<-"APOC2_expression"
sample_apoc2_levels<-APOC2_expression_level
sample_apoc2_value<-APOC2_expression_value
samples1_apoc2_levels<-cbind(samples1,sample_apoc2_levels)
samples1<-cbind(samples1_apoc2_levels, sample_apoc2_value)

#important input content#
headerNames<-colnames(samples1)

#HC use table cluster1#
colorCodes<- c(HIGH ="red", LOW = "green", MEDIUM = "orange")
groupCodes<- genes2_transsample_all[,"APOC2"]
clusters1 <- hclust(dist(genes2_transsample_all))

#PCA use table#
genes1.log<-log2(genes1+0.0005565771)
pca1<- prcomp(genes1.log,center = TRUE,scale. = TRUE)
pcadf1<-data.frame(pca1$rotation)
samples1$patients<-rownames(samples1)
pcadf1$patients<-rownames(pcadf1)
samples1_pca<-inner_join(samples1,pcadf1,by="patients")

#heatmap generate table#
#conduct TTEST to find out significant genes#
highexpression_patients<-genes1[highexpression]
lowexpression_patients<-genes1[lowexpression]
lowexpression_patients_transpose<-t(lowexpression_patients)
highexpression_patients_transpose<-t(highexpression_patients)
tableforttest<-cbind(lowexpression_patients_transpose, highexpression_patients_transpose)

result<-array(0,dim=c(54713,2))
for (i in 1:54713){
  result[i,1]<-t.test(tableforttest[,i]-tableforttest[,i+54713])$statistic
  result[i,2]<-t.test(tableforttest[,i]-tableforttest[,i+54713])$p.value
}

#result
genesselected<-as.data.frame(result)
rownames(genesselected)<-rownames(genes1)
colnames(genesselected)<-c("statistic_value","p_value")

#Looking for gene that p-value<0.05
p_value<-genesselected[,2]
significantgenes<-which(p_value<0.05)
significantgenes_id<-rownames(genesselected[significantgenes,])
tableforpathwayanalysis<-genesselected[significantgenes_id,]
tableforpathwayanalysis1<-tableforpathwayanalysis[order(tableforpathwayanalysis[,"p_value"]),]


# Define UI for application that draws graphs#
ui <- fluidPage(
       navbarPage("Final Project",
                 #The bar for HC#
                 tabPanel("Hierarchical Clustering",
                          sidebarLayout(
                            sidebarPanel(
                              numericInput("num", label = h3("Numeric input"), value = 3)
                              
                            ),
                            mainPanel(
                              plotOutput('plot')
                            )
                          )
                 ),
                 #The bar for PCA#
                 tabPanel("PCA",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput('colorbased', 'Color Based On', c("None"=FALSE,headerNames),headerNames[2])
                              
                            ),
                            mainPanel(
                             plotlyOutput('PCAplot')
                             )
                             )
                             ),
                #The bar for Heatmap1 and 2#
                  navbarMenu("Heatmaps",
                            #Heatmap1#
                             tabPanel("Heatmap1", 
                                     sidebarLayout(
                                       sidebarPanel(
                                         sliderInput("genenumbers1", label = h3("Selected genes number"), min = 0, 
                                                     max = 200, value = 50)
                                       
                                     ),
                              mainPanel(
                               plotlyOutput('heatmap1')
                              )
                              )
                              ),      
                            #Heatmap2#
                            tabPanel("Heatmap2", 
                                     sidebarLayout(
                                       sidebarPanel(
                                         sliderInput("genenumbers2", label = h3("Selected genes number"), min = 0, 
                                                     max = 200, value = 50)
                                         
                                       ),
                               mainPanel(
                                plotOutput('heatmap2')
                               )
                               )
                               )
                  )
))
                            
# Define server logic required to draw graphs#


server <- function(input, output, session) {

  output$plot <- renderPlot({
    par(mar = c(5.1, 4.1, 3, 3))
    dend <-as.dendrogram(clusters1)
    dend <-rotate(dend, 1:93)
    dend <-color_branches(dend, k=input$num)
    par(cex=0.5)#reduces font#
    labels_colors(dend)<- colorCodes[genes2_transsample_all[,"APOC2"]][order.dendrogram(dend)]
    plot(dend)
  })
 
   output$PCAplot <- renderPlotly({
       plot_ly(samples1_pca, x = ~PC1, y = ~PC2, z = ~PC3, marker = list(symbol = 'circle', sizemode = 'diameter'), sizes = ~APOC2_expression, color = ~get(input$colorbased), colors = c("Spectral"))%>%
       add_markers() %>%
       layout(scene = list(xaxis = list(title = 'PC1'),
                           yaxis = list(title = 'PC2'),
                           zaxis = list(title = 'PC3')))
  })
  
   output$heatmap1 <- renderPlotly({
     #choose number of genes that participate in the analysis, for example,1:100#
     genes1_selected<-genes1[rownames(tableforpathwayanalysis1[1:input$genenumbers1,]),]
     genes1_selected1<-genes1_selected[,colnames(highexpression_patients)]
     genes1_selected2<-genes1_selected[,colnames(lowexpression_patients)]
     genes1_selected_table<-cbind(genes1_selected1, genes1_selected2)
     genes1_selected_table_transpose<-t(genes1_selected_table)
     #normalize the distribution of the dataset#
     #min(genes1_selected_table_transpose[genes1_selected_table_transpose>0])
     genes1_selected_table_transpose.log<-log2(genes1_selected_table_transpose+0.003231274)
     median_value<-median(genes1_selected_table_transpose.log)
     melted_corr <- melt(genes1_selected_table_transpose.log)
     
     p<-ggplot(data = melted_corr, mapping = aes(x = X1,
                                                y = X2,
                                                fill = value))+
      geom_tile() +
      xlab(label = "patients") +
      ylab(label = "Genes") +
      scale_fill_gradient2(low="green", mid="white", high="red", midpoint=median_value) +
      theme(axis.title.y = element_blank(),
            axis.text.y = element_text(size = 2.5, vjust = 0.5),
            axis.text.x = element_text(angle = 90, size = 5, vjust = 0.5))
    ggplotly(p)
  })
   
   output$heatmap2 <- renderPlot({
     par(mar = c(6, 6, 0.5, 0.5),cex=0.3)
     genes1_selected<-genes1[rownames(tableforpathwayanalysis1[1:input$genenumbers2,]),]
     genes1_selected1<-genes1_selected[,colnames(highexpression_patients)]
     genes1_selected2<-genes1_selected[,colnames(lowexpression_patients)]
     genes1_selected_table<-cbind(genes1_selected1, genes1_selected2)
     genes1_selected_table_transpose<-t(genes1_selected_table)
     genes1_selected_table.log<-log2(genes1_selected_table+0.006068098)
     genes2<-as.matrix(sapply(genes1_selected_table, as.numeric))
     rownames(genes2)<-rownames(genes1_selected_table)
     colfunc<-colorRampPalette(c("green", "red"))
     heatmap.2(genes2,col=colfunc(15), scale = "row", trace  = "none")
   })
}
# Run the application 
shinyApp(ui = ui, server = server)


