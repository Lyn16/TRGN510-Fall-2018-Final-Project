# TRGN510-Fall-2018-Final-Project
Final project
## Project Description:
Acute Myeloid Leukemia (AML) is a devastating hematologic malignancy that affects the hematopoietic stem cells. Less than 30% of patients with AML achieve 5-year overall survival (OS), highlighting the urgent need to identify new therapeutic targets. We analyzed gene expression datasets (GSE1159, GSE7186, GSE13159, GSE13164, GSE995, GSE31174 and TCGA) for genes that are differently overexpressed in AML. We also found in patient samples that APOC2 was consistently upregulated in AML compared with healthy PBMCs (peripheral blood mononuclear cells). Our in vivo and in vitro experiments also show that APOC2 expression level is associated with the cell proliferation, cell migration, and the cell apoptosis. The aim of this project is to look through 3 different high-quality cohorts and conduct analysis with the data to 

  1.	Study the downstream signaling pathway that are activated/inhibited by the APOC2 expression alternation and associated with the phenotypes we found out.

  2.	Look at the APOC2 gene upstream genomic alternation in AML to see if it’s associated with the MLL rearrangement.
  
## Datasets:
  ### TCGA (200 cases)(START WITH THIS DATASET)
    Repositories
    Data Category：Transcriptome profiling data
       screem condition: 
            cases: program:TCGA; Project:TCGA-LAML; Disease Type: Myeloid Leukemia
            files: Transcriptome Profiling; RNA-Seq; HTSeq-FPKM
https://portal.gdc.cancer.gov/repository?filters=%7B%22op%22%3A%22and%22%2C%22content%22%3A%5B%7B%22op%22%3A%22in%22%2C%22content%22%3A%7B%22field%22%3A%22files.data_category%22%2C%22value%22%3A%5B%22Biospecimen%22%2C%22Clinical%22%2C%22Combined%20Nucleotide%20Variation%22%2C%22Copy%20Number%20Variation%22%2C%22DNA%20Methylation%22%2C%22Raw%20Sequencing%20Data%22%2C%22Simple%20Nucleotide%20Variation%22%2C%22Transcriptome%20Profiling%22%5D%7D%7D%2C%7B%22op%22%3A%22in%22%2C%22content%22%3A%7B%22field%22%3A%22files.data_type%22%2C%22value%22%3A%5B%22Gene%20Expression%20Quantification%22%5D%7D%7D%2C%7B%22op%22%3A%22in%22%2C%22content%22%3A%7B%22field%22%3A%22files.experimental_strategy%22%2C%22value%22%3A%5B%22RNA-Seq%22%5D%7D%7D%5D%7D

## Proposed Analysis

DC: You need to identify and label your samples based on expression level of APOC.  

  ### 1.	Hierarchical clustering ON SAMPLES (GROUPS THAT YOU DIDN'T EXIST)
  (Compare Top 25% of APOC2 expression level population with Bottom 25% APOC2 expression level population.)
    (1). To study the downstream signaling pathway that are activated/inhibited by the APOC2 expression alternation in AML.
    (2). To look at the APOC2 gene upstream genomic alternation in AML.

  ### 2.	Conduct a PCA for each dataset to show that some components control the expression level of APOC2 
   (Group setting: Top 25% of APOC2 expression level population; bottom 25% APOC2 expression level population; The rest of the population.) change color according to several classification.
   
   above HERE - IS QC TO MAKE SURE THERE ARE NO ARTIFACTS, REMOVE OR ADJUST FOR ANY (ETHNCIITY, OR SOMETHING ELSE, AND TAKE REMAINING SAMPLES INTO SUPERVISED TTEST

  ### 3.	T-test (volcano plot - or heatmap of most differentially genes.  TOP GENES HERE COULD GO TO IPA)
   (Second level UI: enter or choose different genes)
    (1). To associate the APOC2 expression alternation with other genes in dataset, using T-test. (also tried Mann Whitney U test, but get a even larger data pool )
    (2). Use heatmap to show the most differentially gene, and go to IPA
    
## Plans for the Week 11/26/18-12/1/18
    (1). Put all the element above in a shiny app.
    (2). If there is enough time, i will add a dendrogram along with heatmap (I gave up the volcano plot part).

## List for all the materials in this respository.
    (1). A markdown file  for all the steps and figures of this final project.
    (2). A R script for the shiny app.
    (3). Three python file for the process to make the downloaded data can be used for analysis.
    (4). HTML address for the markdown page:
    (5). HTML address for the shiny app:
    
   
   
