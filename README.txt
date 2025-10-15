Below is the step by step instruction to reproduce the results as shown in the paper.

Step 1. Get access to confidential ADNI data

      Visit the source website https://ida.loni.usc.edu/login.jsp?project=ADNI.

      Complete the data use agreement and submit your application.

      Once approved, you'll receive login credentials for the ADNI Image & Data Archive (IDA).

Step 2. Download plasma data

      Choose 'select study' to be ADNI. In the "Search & Download" dropdown menu, select "Study Files".

      In the sidebar on the left, choose "Biospecimen" -> "Biospecimen Results".

      Find and download "Biomarkers Consortium Plasma Proteomics Project RBM Multiplex Data and Primer (Zip file)" 
      
      From the folder, extract "adni_plasma_qc_multiplex_11Nov2010.csv" and save to /yourfolder

Step 3. Download phenotype data

      Also in the "Search & Download" section, find "ADNIMERGE - Packages for R" and download "ADNIMERGE_0.0.1.tar.gz".

      run the following code in R:

        install.packages("Hmisc")
        install.packages("/your/path/to/ADNIMERGE_0.0.1.tar.gz", repos = NULL, type = "source")
        library(ADNIMERGE)
        data("adnimerge")
        m12 <- subset(adnimerge, VISCODE=='m12')
        bl <- subset(adnimerge, VISCODE=='bl')
        write.csv(m12, "/yourfolder/adni_phenotype_m12.csv", quote = F, row.names = F)
        write.csv(bl, "/yourfolder/adni_phenotype_bl.csv", quote = F, row.names = F)
  
Step 4. Generate the data
      
      Now we have original data ready for use:
        "/yourfolder/adni_plasma_qc_multiplex_11Nov2010.csv"
        "/yourfolder/adni_phenotype_m12.csv"

      Open /yourpath/TensorStochasticMachineLearning/source/Modules/PrepADNI.m, 
      and change file paths for plasma and phenotype to your data location. 
      Then run PrepADNI.m. The binary datasets will be stored in /source/ADNI_data

Step 5. Run the model
      
      Go to /yourpath/TensorStochasticMachineLearning/source and type paths

      To get results of ADNI data, 
      type and run CompMultiSVM_ADNI

      To get results of GCM Data,
      type and run CompMultiSVM_GCM

Step 6. Check the results

      The results including table of accuracy, precison and AUC, and plots in the paper will be stored in 
      /yourpath/TensorStochasticMachineLearning/results/



  



