function parameters = GetCoeff(Datas, parameters)

% get number of data points in the A and B training sets
Anum = size(Datas.A.Training, 2);
Bnum = size(Datas.B.Training, 2);

if Bnum == 0 | Anum == 0, dbstop, end

AC = zeros(parameters.Training.dsgnmatrix.origin.numofpoints, Anum+1); %the mm-th col is the level of coeff 
BC = zeros(parameters.Training.dsgnmatrix.origin.numofpoints, Bnum+1); %the mm-th col is the level of coeff 

%[tC, tlevelcoeff, tdcoeffs, tccoeffs] = Coeffhbtrans(tnum, tC, Datas.A.Training, results.Training.origin.multilevel.multileveltree, results.Training.origin.multilevel.ind, results.Training.origin.multilevel.datacell, results.Training.origin.multilevel.datalevel);
% test
[AC, Alevelcoeff, Adcoeffs, Accoeffs] = Coeffhbtrans(Anum, AC, ...
                                            Datas.A.Training, ...
                                            parameters.Training.origin.multilevel.multileveltree, ...
                                            parameters.Training.origin.multilevel.ind, ...
                                            parameters.Training.origin.multilevel.datacell, ...
                                            parameters.Training.origin.multilevel.datalevel);

[BC, Blevelcoeff, Bdcoeffs, Bccoeffs] = Coeffhbtrans(Bnum, BC, ...
                                            Datas.B.Training, ...
                                            parameters.Training.origin.multilevel.multileveltree, ...
                                            parameters.Training.origin.multilevel.ind, ...
                                            parameters.Training.origin.multilevel.datacell, ...
                                            parameters.Training.origin.multilevel.datalevel);


%ttotalerror = Testchange(tC, tdcoeffs, tccoeffs, results.Training.origin.multilevel.multileveltree, results.Training.origin.multilevel.ind, results.Training.origin.multilevel.datacell, results.Training.origin.multilevel.datalevel, parameters.Training.dsgnmatrix.origin.numofpoints);
%ntotalerror = Testchange(nC, ndcoeffs, nccoeffs, results.Training.origin.multilevel.multileveltree, results.Training.origin.multilevel.ind, results.Training.origin.multilevel.datacell, results.Training.origin.multilevel.datalevel, parameters.Training.dsgnmatrix.origin.numofpoints);


parameters.Training.A.C = AC;
parameters.Training.B.C = BC;
parameters.Training.A.levelcoeff = Alevelcoeff;
parameters.Training.B.levelcoeff = Blevelcoeff;
%parameters.Training.A.totalerror = ttotalerror;
%parameters.Training.B.totalerror = ntotalerror;

% switch parameters.multilevel.nested
%     case 0 %No Change
%     case 1 %Select Levels > l
%     case 2 %Select Levels < l
% end


Anum = size(Datas.A.Testing,2);
Bnum = size(Datas.B.Testing,2);

AC = zeros(parameters.Training.dsgnmatrix.origin.numofpoints, Anum+1); %the mm-th col is the level of coeff 
BC = zeros(parameters.Training.dsgnmatrix.origin.numofpoints, Bnum+1); %the mm-th col is the level of coeff 

[AC, Alevelcoeff, Adcoeffs, Accoeffs] = Coeffhbtrans(Anum, AC, ...
                                            Datas.A.Testing, ...
                                            parameters.Training.origin.multilevel.multileveltree, ...
                                            parameters.Training.origin.multilevel.ind, ...
                                            parameters.Training.origin.multilevel.datacell, ...
                                            parameters.Training.origin.multilevel.datalevel);
[BC, Blevelcoeff, Bdcoeffs, Bccoeffs] = Coeffhbtrans(Bnum, BC, ...
                                            Datas.B.Testing, ...
                                            parameters.Training.origin.multilevel.multileveltree, ...
                                            parameters.Training.origin.multilevel.ind, ...
                                            parameters.Training.origin.multilevel.datacell, ...
                                            parameters.Training.origin.multilevel.datalevel);


parameters.Testing.A.C = AC;
parameters.Testing.B.C = BC;
parameters.Testing.A.levelcoeff = Alevelcoeff;
parameters.Testing.B.levelcoeff = Blevelcoeff;

%% Get dimensions of residual subspace
% if 0 then non nested, 
% if 1 nesting is 0-l, 
% if 2 nesting is l-max(l)

AC = AC >= 0; AC = AC(:)';
switch parameters.multilevel.nested
    case 0
        fun = @(l) sum(AC == l);
    case 1 
        fun = @(l) sum(AC <= l);
        %Select Levels > l;
    case 2 %Select Levels < l
        fun = @(l) sum(AC >= l);
end
parameters.multilevel.Mres = arrayfun(fun, 0:parameters.multilevel.l);



