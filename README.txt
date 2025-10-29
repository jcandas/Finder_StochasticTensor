Below is the step by step instruction to reproduce the results as shown in the paper:
    "STOCHASTIC TENSOR SPACE FEATURE THEORY WITH APPLICATIONS TO ROBUST MACHINE LEARNING"

================== Step 1. Get access to confidential ADNI data ==================

      Visit the source website https://ida.loni.usc.edu/login.jsp?project=ADNI.

      Complete the data use agreement and submit your application.

      Once approved, you'll receive login credentials for the ADNI Image & Data Archive (IDA).

================== Step 2. Download plasma data ==================================

      Choose 'select study' to be ADNI. In the "Search & Download" dropdown menu, select "Study Files".

      In the sidebar on the left, choose "Biospecimen" -> "Biospecimen Results".

      Find and download "Biomarkers Consortium Plasma Proteomics Project RBM Multiplex Data and Primer (Zip file)" 
      
      From the folder, extract "adni_plasma_qc_multiplex_11Nov2010.csv" and save to /Finder_StochasticTensor-main/data

================== Step 3. Download phenotype data ==================================

      Also in the "Search & Download" section, find "ADNIMERGE - Packages for R" and download "ADNIMERGE_0.0.1.tar.gz".

      run the following code in R:

        install.packages("Hmisc")
        install.packages("ADNIMERGE_0.0.1.tar.gz", repos = NULL, type = "source")
        library(ADNIMERGE)
        data("adnimerge")
        m12 <- subset(adnimerge, VISCODE=='m12')
        bl <- subset(adnimerge, VISCODE=='bl')
        write.csv(m12, "/Finder_StochasticTensor-main/data/adni_phenotype_m12.csv", quote = F, row.names = F)
        write.csv(bl, "/Finder_StochasticTensor-main/data/adni_phenotype_bl.csv", quote = F, row.names = F)
  
================== Step 4. Generate the data =====================================
      
      Now we have original data ready for use:
        "/Finder_StochasticTensor-main/data/adni_plasma_qc_multiplex_11Nov2010.csv"
        "/Finder_StochasticTensor-main/data/adni_phenotype_m12.csv"

      Go to  /Finder_StochasticTensor-main/source and type paths
      Type PrepADNI in the command windown
      The binary datasets will be stored in /Finder_StochasticTensor-main/data/ADNI_data

================== Step 5. Get the ADNI results ======================================


      Type CompMultiSVM_ADNI in the command window
      You can check results in /Finder_StochasticTensor-main/results/ADNIResults including the following:

	    ModelComparisonResult_{pair}_{method}.mat:  Runtime, AUC, ROC, accuracy and precision
        ModelComparisonPlot_{pair}.pdf: the plots that compare model performance in the paper


================== Step 6. Get the GCM results ========================================

      GCM data is available in the /Finder_StochasticTensor-main/data/Tan_data-2, you can directly use it
	  Type CompMultiSVM_GCM in the command window
      You can check results in /Finder_StochasticTensor-main/results/GCMResults including the following:

        ModelComparisonResult_{sin_transform_param}_{method}_{unbalance_param}.mat:  Runtime, AUC, ROC, accuracy and precision
        ModelComparisonPlot_{sin_transform_param}.pdf: the plots that compare model performance in the paper appendix
        SampleComparisonPlot_{sin_transform_param}.pdf: the plots that compare model performance on unbalanced data in the paper appendix




  



