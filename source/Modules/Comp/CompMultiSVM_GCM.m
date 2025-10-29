clc;
%clear all;
close all;
delete(gcp('nocreate'))

% initialize parameters
methods = InitializeMethods_GCM;
[parameters] =  methods.all.initialization();

B{1} = {true}; %Balance/Unbalanced
B{2} = {true}; %Use Kernel
B{3} = {'smallest'}; %Eigenspace
B{4} = {1,0}; %Classification Algorithm 1:SVMonly 0:MOS DO NOT CHANGE ORDER
B{5} = {15,18,20}; %sin

[C5, C4, C3, C2, C1] = ndgrid(B{1}, B{2}, B{3}, B{4}, B{5});
D = [C1(:), C2(:), C3(:), C4(:), C5(:)];



for irowGCM = 1:size(D,1)
 tic;

 parameters.synthetic.functionTransform = D{irowGCM,1};
 parameters.multilevel.svmonly = D{irowGCM,2};
 parameters.multilevel.eigentag = D{irowGCM,3};
 parameters.svm.kernal = D{irowGCM,4};
 if parameters.multilevel.svmonly == 1 
     parameters.multilevel.splitTraining = 0;
 else
     parameters.multilevel.splitTraining = 1;
 end

 % parameters.multilevel.splitTraining = D{irowGCM,5};
 
 if mod(irowGCM, 2) == 1  % odd
     rbase_list = {}; %list of 3 sample sizes
 else
     rmos_list = {}; %list of 3 sample sizes
 end

 

 for k = 1:parameters.data.nk
      t1 = toc;

      % Read Data
      parameters.data.currentiter=k; 
     
      [Datas, parameters] = methods.all.readcancerData(parameters, methods);     
      %-------debug flip raw  delete middle------------
      %Datas.rawdata.AData = fliplr(Datas.rawdata.AData);
      %Datas.rawdata.AData(:,10000:20000-parameters.synthetic.Ars(k)-1) = [];
      %Datas.rawdata.BData = fliplr(Datas.rawdata.BData);
      %---------------------------------

      %Initialize truncations if need be
      if parameters.multilevel.chooseTrunc
      parameters = methods.Multi2.ChooseTruncations(Datas, parameters, methods);
      return
      end

      % Create results structure
      [results] = methods.all.iniresults(parameters);


     
     % Data size
     % update parameters.data.n to number of simulated data points
     [parameters] = methods.all.Datasize(Datas, parameters);

     %Plot Data if handles are there
      if parameters.transform.createPlots
      if ~isempty(methods.transform.createPlot)
          for i = 1:length(methods.transform.createPlot)
              plotHandle = methods.transform.createPlot{i};
              plotHandle(Datas, parameters, methods);
          end
          return
      end
      end

     %Generate random genes
     
     % select random genes
     [Datas] = methods.all.selectgene(Datas, parameters.data.numofgene, parameters.data.B);


     
     switch parameters.multilevel.svmonly 
         case 1
         %SVM Only
         results = methods.SVMonly.CompSVMonly(methods, Datas, parameters, results);
         case 0
         % Multilevel Method with SVM
         results = methods.Multi.CompMulti(methods, Datas, parameters, results);
         parameters = ResidDimensionForMOLS(Datas, parameters, methods);
         case 2
         %Trajan's Multilevel Method with SVM
         results = methods.Multi2.CompMulti(Datas, parameters, methods, results);
             
     end

     
     results = methods.all.ComputeAccuracyAndPrecision(Datas, parameters, methods, results);

     t2 = toc;
      
     results.run_time = duration(0,0,t2 - t1, 'Format', 'hh:mm:ss');
     results.creation_time = datetime;
     

     parameters = filefunc(parameters, methods);
  
     % Define directory path
     save_dir = fullfile('..', 'results', 'GCMResults');

     % Create folder if it doesn't exist
     if ~exist(save_dir, 'dir')
         mkdir(save_dir);
     end
     

     if mod(irowGCM, 2) == 1  % odd
        rbase_list{k} = results;
        outputresult = sprintf('ModelComparisonResult_sin%d_%s_k%d.mat', parameters.synthetic.functionTransform,'baseline',k);
     else  % even
        rmos_list{k} = results;
        outputresult = sprintf('ModelComparisonResult_sin%d_%s_k%d.mat', parameters.synthetic.functionTransform,'multilevel',k);
     end

     save_path = fullfile(save_dir, outputresult);
     save(save_path, 'parameters', 'results', 'Datas');

 end

 if mod(irowGCM,2) == 1
     continue
 else
    plotModelComparisonGCM(rmos_list, rbase_list);
    outputplot1 = sprintf('ModelComparisonPlot_sin%d.pdf', parameters.synthetic.functionTransform);
    save_path1 = fullfile(save_dir, outputplot1);
    exportgraphics(gcf, save_path1, 'ContentType', 'vector');

    plotSampleComparisonGCM(rmos_list, rbase_list);
    outputplot2 = sprintf('SampleComparisonPlot_sin%d.pdf', parameters.synthetic.functionTransform);
    save_path2 = fullfile(save_dir, outputplot2);
    exportgraphics(gcf, save_path2, 'ContentType', 'vector');
 end


 end

 

