function [parameters] = InitializeParameters_ADNI()

%% Data parameters
parameters.data.path = fullfile('..','data','ADNI_data','');
parameters.data.label = ''; 
parameters.data.name = [parameters.data.label, '.txt'];
parameters.data.numofgene = []; % Set to empty array [] to initialize as latent data dimension
parameters.data.normalize = 1; % if 1 then standarized
parameters.data.validationType = 'Kfold';% or 'Synthetic', 'Kfold'; %One of 'Kfold', 
parameters.data.randomize = 1;

%% Cross Validation Parameters
parameters.cross.NTestA = 1;
parameters.cross.NTestB = 1;


%% K-fold parameters
parameters.Kfold = 1; %If parameters.data.generealization is set to 1,


%% Semi-synthetic data realization parameters
parameters.synthetic.functionTransform = 30; %if 'id';
parameters.synthetic.NKLTerms = 54; % KL Truncation for generating Semisynthetic Data
parameters.synthetic.Ars = [150, 450, 1500, 10000];
parameters.synthetic.Brs = [100, 100, 100, 100];
parameters.synthetic.NTest = 10000;


%% MultiLevel parameters
parameters.snapshots.k1 = 5; % KL Truncation for Class A
parameters.multilevel.l = 5; % level for classifier (was 8)
parameters.multilevel.chooseTrunc = false;
parameters.multilevel.nested = 1; % if 0 then non nested, if 1 nesting is 0-l, if 2 nesting is l-max(l), 
parameters.multilevel.svmonly = 1; % if 1 then SVM only, if 0 then multilevel, if 2 then Trajan's Multilevel, 
parameters.multilevel.splitTraining = true; %if True, then Training A data is split into ML-filter subset and SVM training subset
parameters.multilevel.eigentag = 'smallest'; %if 'largest', uses principal eigenspace, if 'smallest' uses terminal eigenspace
parameters.multilevel.concentration = 1;
parameters.multilevel.Mres = 20:20:140;
parameters.multilevel.splitfirst = true;

%% Baseline performance parameters
parameters.misc.MachineList = ["SVM_Radial", "Bag", "LogitBoost", "RUSBoost"];


%% Assorted parameters
parameters.parallel.on = 1;% if 1 the use parloop 
parameters.gpuarray.on = 0;
parameters.svm.kernal = true; % if 1 then use SVM with kernal, else use linear boundary 
parameters.snapshots.controlRand = false;

%% Transform Parameters (can mostly ignore)
parameters.transform.ComputeTransform = false;
parameters.transform.createPlots = false; 

if strcmp(parameters.data.validationType, 'Synthetic')
    parameters.data.nk = size(parameters.synthetic.Brs, 2); % num of simulations 
    assert(length(parameters.synthetic.Brs) == length(parameters.synthetic.Ars),...
        'parameters.snapshots.Ars and parameters.snapshots.Brs must have the same number of elements')
else 
    parameters.data.nk = 1;
end


if parameters.parallel.on == 1
    %Initialize Parallel
    parameters.parallel.numofproc = maxNumCompThreads;
    parpool(parameters.parallel.numofproc);
end







end
