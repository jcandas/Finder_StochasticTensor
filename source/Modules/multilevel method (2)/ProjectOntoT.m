function Datas = ProjectOntoT(Datas, parameters, methods)

%% Construct a Basis of R^(P-MA) using the multilevel tree method and project the Semi-Filtered Class A and B machine data onto this basis
    
% NA = size(Datas.A.Machine, 2);
% NB = size(Datas.B.CovTraining, 2);

NB = size(Datas.B.CovTraining,2);
%XB = 1/sqrt(NB - 1)*(Datas.B.CovTraining - mean(Datas.B.CovTraining,2));
XB = Datas.B.CovTraining;

ProjectOnto = @(X,Y,Z,P) Coeffhbtrans(X, Y, Z, ...
                        P.Training.origin.multilevel.multileveltree, ...
                        P.Training.origin.multilevel.ind, ...
                        P.Training.origin.multilevel.datacell, ...
                        P.Training.origin.multilevel.datalevel);

m = size(XB);
    if ~methods.Multi2.isTallMatrix(XB) %m(2) >= 0.5*m(1)
        [T,~,~] = svd(XB - mean(XB,2));
        T = fliplr(T);

        for C = 'AB', for set = ["Machine", "Testing"]
                Datas.(C).set = T'*Datas.(C).(set);
        end, end

    else
        p3 = parameters;
        p3.snapshots.k1 = min( [m(1), m(2)-1] );
        p3.Training.origin = methods.Multi.snapshots(XB, p3, methods, p3.snapshots.k1);
        p3 = methods.Multi.dsgnmatrix(methods, p3);
        p3 = methods.Multi.multilevel(methods, p3);
        
        for C = 'AB', for set = ["Machine", "Testing"]

          NC = size(Datas.(C).(set),2);
          ZC = zeros(p3.Training.dsgnmatrix.origin.numofpoints, NC + 1);
          [Datas.(C).(set), LC, ~,~] = ProjectOnto(NC, ZC, Datas.(C).(set), p3);
          Datas.(C).(set)(LC < 0, :) =  p3.Training.origin.snapshots.eigenfunction(end-1:-1:1,:) * Datas.(C).(set);
          Datas.(C).(set)(:,end) = [];
        end, end


    end

end
 