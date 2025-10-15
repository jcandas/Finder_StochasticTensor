function results = CompMiscMachines2(methods, Datas, parameters, results)

I = max(parameters.data.NAvals);
for l = 1:length(parameters.misc.MachineList)
    tic; t1 = toc;
    array = results.array(:,:,l,:,:);
    parameters.misc.iMachine = l;
switch parameters.parallel.on 
    case true

        parfor i = parameters.data.NAvals
            parameters2 = parameters;
            parameters2.data.i = i;
            fprintf('Testing Batch %d of %d\n', i, I);
            array(i,:,:,:,:) = methods.misc.CompSub(Datas, parameters2, methods, results);
        end

    case false
        for i = parameters.data.NAvals
            parameters2 = parameters;
            parameters2.data.i = i;
            fprintf('Testing Batch %d of %d\n', i, I);
            array(i,:,:,:,:) = methods.misc.CompSub(Datas, parameters2, methods, results);
        end
end
    t2 = toc;
    results.array(:,:,l,:,:) = array;
    results.DimRunTime(l) = t2 - t1;
end
end
