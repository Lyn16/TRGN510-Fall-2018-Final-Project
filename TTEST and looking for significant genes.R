#TTest for each gene and APOC2#

setwd("/Users/lyn/Final_Project/Step3. Data analysis")
genes1<-read.csv("/Users/lyn/Final_Project/TCGA_AML_mRNA_data_for_analysis.csv", header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, row.names = 2)
genes1<-genes1[,-1]
genes1_trans<-t(genes1)

APOC2<-genes1["ENSG00000234906",]
genes1["APOC2",]<-APOC2
quantile(APOC2)
highexpression<-which(APOC2 > 0.4639374)
lowexpression<-which(APOC2 <= 0.05992213 )
mediumexpression<-which(APOC2<=0.4639374 & APOC2>0.05992213)

genes1<-genes1[-54714,]#exclude the additional apoc2 colunm#

# for TTest#
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
result

#save the TTEST result#
write.csv(result, file ="/Users/lyn/Final_Project/TTEST_result.csv")
genesselected<-read.csv("/Users/lyn/Final_Project/TTEST_result.csv", header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, row.names = 1)
rownames(genesselected)<-rownames(genes1)
colnames(genesselected)<-c("statistic_value","p_value")

#looking for genes that p-value<0.05#
p_value<-genesselected[,2]
significantgenes<-which(p_value<0.05)
significantgenes_id<-rownames(genesselected[significantgenes,])
tableforpathwayanalysis<-genesselected[significantgenes_id,]
tableforpathwayanalysis1<-tableforpathwayanalysis[order(tableforpathwayanalysis[,2]),]

#select the top 100 and put into IPA#
write.csv(tableforpathwayanalysis1, file = "/Users/lyn/Final_Project/TTEST_result_significantgenes.csv")
write(significantgenes_id, file ="/Users/lyn/Final_Project/significantgenes_id.txt")
