library("dplyr")
library("reshape")
library("ggplot2")
library("dendextend")
library("colorspace")
setwd("/Users/lyn/Final_Project/Step3. Data analysis")
samples1<-read.csv("/Users/lyn/Final_Project/Step3. Data analysis/patient_sample.csv", header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, row.names = 2)
genes1<-read.csv("/Users/lyn/Final_Project/TCGA_AML_mRNA_data_for_analysis.csv", header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, row.names = 2)
genes1<-genes1[,-1]
samples1<-samples1[,-1]

#color bottom branches by apoc2 high/low status.
APOC2<-genes1["ENSG00000234906",]
genes1["APOC2",]<-APOC2
quantile(APOC2)
highexpression<-which(APOC2 > 0.4639374)

lowexpression<-which(APOC2 <= 0.05992213 )
mediumexpression<-which(APOC2<=0.4639374 & APOC2>0.05992213)

genes1["APOC2",]<-replace(genes1["APOC2",], (highexpression), "HIGH")
genes1["APOC2",]<-replace(genes1["APOC2",], (lowexpression), "LOW")
genes1["APOC2",]<-replace(genes1["APOC2",], (mediumexpression), "MEDIUM")
genes1<-genes1[-"APOC2",]

#Hiercarchical Clusting#
genes1_transsample_all<-t(genes1)
colorCodes<- c(HIGH ="red", LOW = "green", MEDIUM = "orange")
groupCodes<- genes1_transsample_all[,"APOC2"]
clusters1 <- hclust(dist(genes1_transsample_all))
plot(clusters1)

#Log transform the data#
library("dendextend")
dend <-as.dendrogram(clusters1)
dend <-rotate(dend, 1:93)
dend <-color_branches(dend, k=3)
par(cex=0.5)#reduces font#
labels_colors(dend)<- colorCodes[genes1_transsample_all[,"APOC2"]][order.dendrogram(dend)]
p<-plot(dend)





