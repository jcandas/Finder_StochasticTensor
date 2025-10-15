function Datas = ProjectOntoAMA(Datas, parameters, methods)

%% Construct a Basis of AMA_Perp using the multilevel tree method and project the Class A and B machine data onto this basis

    NA = size(Datas.A.CovTraining,2);
    %XA = 1/sqrt(NA - 1)*Datas.A.CovTraining;
    XA = Datas.A.CovTraining;

    ProjectOnto = @(X,Y,Z,P) Coeffhbtrans(X, Y, Z, ...
                            P.Training.origin.multilevel.multileveltree, ...
                            P.Training.origin.multilevel.ind, ...
                            P.Training.origin.multilevel.datacell, ...
                            P.Training.origin.multilevel.datalevel);
    
    m = size(XA);
    if ~methods.Multi2.isTallMatrix(XA) %m(2) >= 0.5*m(1)
        [U,~,~] = svd(XA);
        U(:,1:parameters.snapshots.k1) = [];
        U = fliplr(U);
        %SFA = U'*XA; %SFA = Semi-Filtered A;
        %SFB = U'*XB;

        for C = 'AB', for set = ["CovTraining", "Machine", "Testing"]
            if C == 'A' && strcmp(set, "CovTraining"), continue, end
            Datas.(C).(set) = U'*Datas.(C).(set);
        end, end


    else
        p2 = parameters;
        NA = size(Datas.A.CovTraining,2);
        %XA = 1/sqrt(NA - 1)*Datas.A.CovTraining;
        p2.snapshots.k1 = NA;
        %p2.Training.origin = methods.Multi.snapshots(XA, p2, methods, NA);  
        p2.Training.origin = methods.Multi.snapshots(Datas.A.CovTraining, p2, methods, p2.snapshots.k1);  
        p2 = methods.Multi.dsgnmatrix(methods, p2);
        p2 = methods.Multi.multilevel(methods, p2);
        
        %AC = zeros(p2.Training.dsgnmatrix.origin.numofpoints, NA+1); %the mm-th col is the level of coeff 
        %BC = zeros(p2.Training.dsgnmatrix.origin.numofpoints, NB+1); %the mm-th col is the level of coeff 

        for C = 'AB', for set = ["CovTraining", "Machine", "Testing"]

                %if C == 'A' && strcmp(set, "CovTraining"), continue, end

                NC = size(Datas.(C).(set),2);
                ZC = zeros(p2.Training.dsgnmatrix.origin.numofpoints, NC+1);
                [Datas.(C).(set), LC, ~,~] = ProjectOnto(NC, ZC, Datas.(C).(set), p2);
                E = p2.Training.origin.snapshots.eigenfunction; E(end,:) = []; E = flipud(E);
                Datas.(C).(set)(LC == -1, :) =  E * Datas.(C).(set);
                Datas.(C).(set)(end - parameters.snapshots.k1 + 1:end,:) = [];
                Datas.(C).(set)(:,end) = [];

        end, end



end