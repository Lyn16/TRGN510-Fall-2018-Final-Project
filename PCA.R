library("dplyr")
library("reshape")
library("ggplot2")
library("dendextend")
library("colorspace")
library("RColorBrewer")
library("plotly")

setwd("/Users/lyn/Final_Project/Step3. Data analysis")
samples1<-read.csv("/Users/lyn/Final_Project/Step3. Data analysis/patient_sample.csv", header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, row.names = 2)
genes1<-read.csv("/Users/lyn/Final_Project/TCGA_AML_mRNA_data_for_analysis.csv", header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, row.names = 2)
genes1<-genes1[,-1]
samples1<-samples1[,-1]

#add apoc2 expression levels and value to the table#
APOC2_expression_level<-as.data.frame(genes1_transsample_all[,"APOC2"])
colnames(APOC2_expression_level)<-"APOC2_levels"
APOC2_expression_value<-as.data.frame(genes1_transsample_all[,"ENSG00000234906"])
colnames(APOC2_expression_value)<-"APOC2_expression"
sample_apoc2_levels<-APOC2_expression_level
sample_apoc2_value<-APOC2_expression_value
samples1_apoc2_levels<-cbind(samples1,sample_apoc2_levels)
samples1<-cbind(samples1_apoc2_levels, sample_apoc2_value)

#PCA#
min(genes1[genes1>0])
genes1.log<-log2(genes1+0.0005565771)
pca1<- prcomp(genes1.log,center = TRUE,scale. = TRUE)

#make it an interactive 3D chart#
pcadf1<-data.frame(pca1$rotation)
samples1$patients<-rownames(samples1)
pcadf1$patients<-rownames(pcadf1)
samples1_pca<-inner_join(samples1,pcadf1,by="patients")
pcaplot<-plot_ly(samples1_pca, x = ~PC1, y = ~PC2, z = ~PC3,marker = list(symbol = 'circle', sizemode = 'diameter'), sizes = ~APOC2_expression, color = ~APOC2_levels, colors = ("Spectral"))%>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'PC1'),
                      yaxis = list(title = 'PC2'),
                      zaxis = list(title = 'PC3')))
pcaplot

#make it a 2D chart, Change the size according to the expression value#
samples1_pca$APOC2_expression = as.numeric(levels(samples1_pca$APOC2_expression))[samples1_pca$APOC2_expression]
ggplot(samples1_pca, aes(x = PC2, y = PC3, col = APOC2_levels))+
  geom_point(aes(color = APOC2_levels,shape = APOC2_levels, size = APOC2_expression))+
  scale_color_manual(values = c("#ff6666","#004d99","#000000"))+
  scale_shape_manual(values = c(19,19,1))+
  scale_size_continuous(range = c(4,12))+
  theme_classic()

    
