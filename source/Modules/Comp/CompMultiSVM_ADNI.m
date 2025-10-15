clc;
%clear all;
close all;
delete(gcp('nocreate'))


% initialize parameters
methods = InitializeMethods_ADNI();
[parameters] =  methods.all.initialization();


B{1} = cellfun( @(s) sprintf('Plasma_M12_%s', s), {'ADCN', 'ADLMCI', 'CNLMCI'}, 'UniformOutput', false); %Data set
B{2} = {true}; %Balance/Unbalanced
B{3} = {true}; %Use Kernel
B{4} = {'smallest'}; %Eigenspace
B{5} = {1,0};%1-base 0-mos DO NOT CHANGE ORDER


[C5, C4, C3, C2, C1] = ndgrid(B{5}, B{4}, B{3}, B{2}, B{1});
% Flatten each grid and combine into matrix D in original parameter order
D = [C1(:), C2(:), C3(:), C4(:), C5(:)];


for irow = 1:size(D,1)

    parameters.data.label = D{irow,1};
    parameters.data.name = [D{irow,1} '.txt'];
    parameters.multilevel.splitTraining = D{irow,2};
    parameters.svm.kernal = D{irow,3};  
    parameters.multilevel.eigentag = D{irow,4};
    parameters.multilevel.svmonly = D{irow,5};
    if parameters.multilevel.svmonly == 1 
        parameters.multilevel.splitTraining = 0;
    else
        parameters.multilevel.splitTraining = 1;
    end
    
    
 tic;
 for k = 1:parameters.data.nk
     t1 = toc;

     % Read Data
     parameters.data.currentiter=k; 
     [Datas, parameters] = methods.all.readcancerData(parameters, methods);     
      %Initialize truncations if need be
     parameters = methods.Multi2.ChooseTruncations(Datas, parameters, methods);
      % Create results structure
     [results] = methods.all.iniresults(parameters);
    
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
      
     results.creation_time = duration(0,0,t2 - t1, 'Format', 'hh:mm:ss');


     parameters = filefunc(parameters, methods);
    
     % Define directory path
     save_dir = fullfile('..', 'results', 'ADNI_final_test');

     % Create folder if it doesn't exist
     if ~exist(save_dir, 'dir')
         mkdir(save_dir);
     end
     

     if mod(irow, 2) == 1  % odd
        rbase = results;
        outputresult = sprintf('ModelComparisonResult_%s%s_%s.mat', parameters.data.typeA, parameters.data.typeB,'baseline');
     else  % even
        rmos = results;
        outputresult = sprintf('ModelComparisonResult_%s%s_%s.mat', parameters.data.typeA, parameters.data.typeB,'multilevel');

        plotModelComparison(rmos, rbase);
        outputplot = sprintf('ModelComparisonPlot_%s%s.pdf', parameters.data.typeA, parameters.data.typeB);
        save_path = fullfile(save_dir, outputplot);
        exportgraphics(gcf, save_path, 'ContentType', 'vector');
     end

     % Save variables
     save_path = fullfile(save_dir, outputresult);
     save(save_path, 'parameters', 'results', 'Datas');

 end

end
 

