function [results, Datas, parameters] = CompMultiSemiSynthetic(Datas,parameters,methods,results,l)

if parameters.data.generealization == 0
    return
end

% -Generate Data



if parameters.data.generealization == 1
   

    results.correct_B = 0;
    results.correct_A = 0;
    results.wrong_B = 0;
    results.wrong_A = 0;

    %parameters.data.i = 1:(parameters.snapshots.Ars - parameters.data.Kfold);  %Indexes A Testing Data
    %parameters.data.j = 1:(parameters.snapshots.Brs - parameters.data.Kfold);  %Indexes B Testing Data

    parameters.data.i = 1:parameters.data.Kfold;  %Indexes A Testing Data
    parameters.data.j = 1:parameters.data.Kfold;  %Indexes B Testing Data

    if l == 0
    %% Split into Training and Testing
    Datas = methods.all.prepdata(Datas, parameters);
    %% -Construct Transformation on Training Data
    Datas = methods.transform.tree(Datas, parameters, methods);
     %% - Construct Multi Level Filter
    [Datas, parameters] = methods.Multi.Filter(Datas, parameters, methods);
    end

   

    %% Construct Machine
    [Datas, parameters] = methods.Multi.machine(Datas, parameters, methods,l);

    %% Wipe Training Data
    %[Datas, parameters] = methods.all.wipeTraining(Datas, parameters);

    %% Predict class value using transformed data
    results = methods.Multi.predict(Datas, parameters, methods, results);

    %% Set istransformed to true to save time
    %parameters.transform.istransformed = true;

    
end


% -Apply Transformation To Training And Validation
% - Construct Machine
% - Do predictions, get results. 
