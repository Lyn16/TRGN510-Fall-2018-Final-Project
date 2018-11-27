#Incase the ttest is not proper, i also conduct a nonparametric analysis#

#Mann Whitney U test for each gene according to the apoc2 expression level(top25% and bottom25%)#
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
genes1<-genes1[-54714,]


# for Mann Whitney U test#
highexpression_patients<-genes1[highexpression]
lowexpression_patients<-genes1[lowexpression]
lowexpression_patients_transpose<-t(lowexpression_patients)
highexpression_patients_transpose<-t(highexpression_patients)
tableforutest<-cbind(lowexpression_patients_transpose, highexpression_patients_transpose)

result<-array(0,dim=c(54713,2))

for (i in 1:54713){
  result[i,1]<-wilcox.test(tableforutest[,i], tableforutest[,i+54713], paired = FALSE)$statistic
  result[i,2]<-wilcox.test(tableforutest[,i], tableforutest[,i+54713], paired = FALSE)$p.value
}
result

#note for the difference between TTEST and Mann Whitney U test#
#If you had enough data, you could probably still use a t-test, despite the non-normality, but what constitutes 'enough' is generally ambiguous. (In your case, it's clear that your data are too non-normal / you have nowhere near 'enough' data to ignore that.) People believe that the Mann-Whitney U-test is a test for differences of means (or maybe medians) with non-normal data, but it's not true.
#The t-test and the Mann-Whitney U-test are testing different null hypotheses. The t-test tests if the samples are drawn from populations with the same mean. The Mann-Whitney U-test checks if one is stochastically greater (as just discussed). You need to use a test that assesses what you are trying to figure out.

write.csv(result, file ="/Users/lyn/Final_Project/Nonparametrictest_result.csv")
genesselected1<-read.csv("/Users/lyn/Final_Project/Nonparametrictest_result.csv", header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, row.names = 1)
rownames(genesselected1)<-rownames(genes1)
colnames(genesselected1)<-c("statistic_value","p_value")

#looking for genes that p-value<0.05#
p_value<-genesselected1[,2]
significantgenes<-which(p_value<0.05)
significantgenes_id<-rownames(genesselected1[significantgenes,])
tableforpathwayanalysis_Nonparametric<-genesselected1[significantgenes_id,]
tableforpathwayanalysis_Nonparametric1<-tableforpathwayanalysis_Nonparametric[order(tableforpathwayanalysis_Nonparametric[,2]),]

write.csv(tableforpathwayanalysis_Nonparametric1, file = "/Users/lyn/Final_Project/Nonparametric_result_significantgenes.csv")
write(significantgenes_id, file ="/Users/lyn/Final_Project/Nonparametric_significantgenes_id.txt")


