function [methods] = InitializeMethods_ADNI()

% methods for both baseline models and multilevel model
methods.all.initialization = @InitializeParameters_ADNI;%@InitializeComp_GCM; %  % Initialization for GCM dataset
methods.all.filefunc = @filefunc;
methods.all.readcancerData = @readData; %@readDatafirst; 
methods.all.Datasize = @Datasize;
methods.all.parloopoff = @parloopoff;
methods.all.normalizedata = @standarized2;
methods.all.prepdata = @SplitTraining2; %@SplitTrainingfirst;@SplitTraining2;
methods.all.selectgene = @selectgene;
methods.all.SVMmodel = @fitcsvm; 
methods.all.SVMpredict = @predict;
methods.all.iniresults = @InitializeResults2;
methods.all.wipeTraining = @wipeTraining;
methods.all.ComputeAccuracyAndPrecision = @FinalizeResults;
methods.all.predict = @CompPredictAUC2;
methods.all.covariance = @UpdateCovariance;



methods.transform.transposeClasses = @transposeClasses;
methods.transform.tree = @ChebSep3Optimization; %function which finds 'optimal' transformation and returns transformed data
methods.transform.fillMethods = @fillTransformMethods;
methods.transform.createPlot = {@ScreePlots, @OptimizeTruncationAndResidualDimension};


% method for baseline models
methods.SVMonly.procdata = @SVMonlyProcData; 
methods.SVMonly.CompSVMonly = @CompMiscMachines2; 
methods.SVMonly.SVMonlyProcRealData = @SVMonlyProcRealData;
methods.SVMonly.Prep = @svmprepdata2;
methods.SVMonly.parallel = @CompSVMonlyKfoldParallel;
methods.SVMonly.noparallel = @CompSVMonlyKfoldNoParallel;
methods.SVMonly.machine = @CompMultiConstructMachine;
methods.SVMonly.fitSVM = @FitSVMNormalize;

methods.misc.Comp = @CompMiscMachines2;
methods.misc.CompSub = @CompMiscMachines2Sub;
methods.misc.prep = @MiscMachinePrep;
methods.misc.SVM_Linear = @(X,Y) fitSVMPosterior(fitcsvm(X,Y));
methods.misc.SVM_Radial = @(X,Y) fitSVMPosterior(fitcsvm(X,Y, ...
                                                    'KernelFunction', 'RBF', 'KernelScale', 'auto'));                                                                                                                                                     
methods.misc.LogitBoost = @(X,Y) fitcensemble(X,Y,'Method','LogitBoost');
methods.misc.RUSBoost = @(X,Y) fitcensemble(X,Y,'Method','RUSBoost');
methods.misc.Bag = @(X,Y) fitcensemble(X,Y,'Method','Bag');
methods.misc.CNN = @(X,Y) ConstructCNN(X,Y);
methods.misc.predict = @CompPredictAUC2;


% method for multilevel model
methods.Multi.CompMulti = @CompMulti;
methods.Multi.snapshots = @snapshots1;   
methods.Multi.snapshotssub = @snapshotssub; 
methods.Multi.generateData=@snapshotsgendata;
methods.Multi.dsgnmatrix = @DesignMatrix;
methods.Multi.dsgnmatrixsub = @DesignMatrixsub;
methods.Multi.PrepDataRealization = @PrepDataRealization;
methods.Multi.multilevel = @multilevel;   
methods.Multi.multilevelsub = @multilevelsub;   
methods.Multi.Getcoeff = @GetCoeff;    
methods.Multi.plotcoeff = @plotcoeff;
methods.Multi.nesteddatasvm =  @nesteddatasvm;
methods.Multi.nesteddatasvmsub1 = @MLFeatureExtraction; %@nesteddatasvmsub1;
methods.Multi.nesteddatasvmsub2 = @MLFeatureExtraction; %@nesteddatasvmsub2;
methods.Multi.datatrain = @datatrain;
methods.Multi.datatrainsub1 = @datatrainsub1;
methods.Multi.datatrainsub2 = @datatrainsub2;
methods.Multi.datasvm = @datasvm;
methods.Multi.datasvmsub1 = @datasvmsub1;
methods.Multi.datasvmsub2 = @datasvmsub2;
methods.Multi.parallel = @CompMultiKfoldParallel;
methods.Multi.noparallel = @CompMultiKfoldNoParallel;
methods.Multi.orthonormal_basis = @orthonormal_basis;
methods.Multi.Filter = @CompMultiConstructFilter;
methods.Multi.predict = @CompMultiPredict;
methods.Multi.machine = @CompMultiConstructMachine;
methods.Multi.nested = @MultiLevelNested;
methods.Multi.dataGeneralization = @CompMultiSemiSynthetic;


methods.Multi2.CompMulti = @CompMultiTrajan;
methods.Multi2.Kfold = @CompMultiTrajanKfold;
methods.Multi2.ChooseTruncations = @MethodOfEllipsoids_18; %@MethodOfEllipsoids; %
methods.Multi2.InitializeResults = [];
methods.Multi2.ConstructResidualSubspace = @ResidSubspace2;
methods.Multi2.SepFilter = @SepFilter3;
methods.Multi2.SplitTraining = @SplitTraining;
methods.Multi2.CloseFilter = @ConstructOptimalBasis;
methods.Multi2.svd = @mysvd2;
methods.Multi2.isTallMatrix = @(X) size(X,1) >= 3*size(X,2) && max(size(X)) > 1000;

methods.Ellipsoids.GetTruncations = @GetTruncations_24;
methods.Ellipsoids.ComputeSC = @ComputeSeparationCriterion;
methods.Ellipsoids.IdentifyMisplaced = @IdentifyMisplaced2;
methods.Ellipsoids.plotHeatMap1 = @plotHeatMap1;
