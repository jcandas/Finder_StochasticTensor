function Datas = ResidSubspace2(Datas, parameters, methods)

Datas = ProjectOntoAMA(Datas, parameters, methods);
Datas = ProjectOntoT(Datas, parameters, methods);

    %Estimate Class A Covariance Matrix

    %% Construct a Basis of AMA_Perp using the multilevel tree method and project the Class A and B machine data onto this basis

%     NA = size(Datas.A.CovTraining,2);
%     XA = 1/sqrt(NA - 1)*Datas.A.CovTraining;
% 
%     ProjectOnto = @(X,Y,Z,P) Coeffhbtrans(X, Y, Z, ...
%                             P.Training.origin.multilevel.multileveltree, ...
%                             P.Training.origin.multilevel.ind, ...
%                             P.Training.origin.multilevel.datacell, ...
%                             P.Training.origin.multilevel.datalevel);
% 
%     
%     m = size(XA);
%     if m(2) >= 2*m(1)
%         [U,~,~] = svd(XA);
%         U(:,1:parameters.snapshots.k1) = [];
%         SFA = U'*XA; %SFA = Semi-Filtered A;
%         SFB = U'*XB;
%     else
%         p2 = parameters;
%         p2.Training.origin = methods.Multi.snapshots(XA, p2, methods, p2.snapshots.k1);
%         p2 = methods.Multi.dsgnmatrix(methods, p2);
%         p2 = methods.Multi.multilevel(methods, p2);
%         
%         AC = zeros(p2.Training.dsgnmatrix.origin.numofpoints, NA+1); %the mm-th col is the level of coeff 
%         BC = zeros(p2.Training.dsgnmatrix.origin.numofpoints, NB+1); %the mm-th col is the level of coeff 
% 
% 
% 
%         [Datas.A.Machine, AL,~,~] = ProjectOnto(NA, AC, Datas.A.Machine, p2);
%         [Datas.B.CovTraining, BLF,~,~] = ProjectOnto(NA, AC, Datas.B.Machine,p2);
%         [Datas.B.Machine,BLM,~,~] = ProjectOnto(NB, BC, Datas.B.Machine,p2);
% 
% %         Datas.A.Machine = Datas.A.Machine(AL >= 0, 1:end-1);
% %         Datas.B.CovTraining = Datas.B.CovTraining(BLF >= 0, 1:end-1);
% %         Datas.B.Machine = Datas.B.Machine(BLM >= 0, 1:end-1);
% 
%         Datas.A.Machine(AL < 0,end) = [];
%         Datas.B.CovTraining(BLF < 0,end) = [];
%         Datas.B.Machine(BLM < 0,end) = [];
% 
% 
%     end
% 
% %% Construct a Basis of R^(P-MA) using the multilevel tree method and project the Semi-Filtered Class A and B machine data onto this basis
%     
% NA = size(Datas.A.Machine, 2);
% NB = size(Datas.B.CovTraining, 2);
% 
% NB = size(Datas.B.CovTraining,2);
% XB = 1/sqrt(NB - 1)*(Datas.B.CovTraining - mean(Datas.B.CovTraining,2));
% 
% m = size(XB);
%     if m(2) >= 2*m(1)
%         [T,~,~] = svd(XB);
%         Datas.A.Machine = T'*Datas.A.Machine; %FA = Filtered A;
%         Datas.B.Machine = T'*Datas.B.Machine; %FB = Filtered B;
%     else
%         p3 = parameters;
%         p3.snapshots.k1 = min( [m(1), m(2)-1] );
%         p3.Training.origin = methods.Multi.snapshots(XB, p3, methods, p3.snapshots.k1);
%         p3 = methods.Multi.dsgnmatrix(methods, p3);
%         p3 = methods.Multi.multilevel(methods, p3);
%         
%         AC = zeros(p3.Training.dsgnmatrix.origin.numofpoints, NA+1); %the mm-th col is the level of coeff 
%         BC = zeros(p3.Training.dsgnmatrix.origin.numofpoints, NB+1); %the mm-th col is the level of coeff 
% 
%         [Datas.A.Machine,AL,~,~] = ProjectOnto(NA,AC,Datas.A.Machine,p3);
%         [Datas.B.Machine,BL,~,~] = ProjectOnto(NB,BC,Datas.B.Machine,p3);
% 
%         Datas.A.Machine(AL < 0,:) = p3.Training.origin.snapshots.eigenfunction * Datas.A.Machine;
%         Datas.B.Machine(BL < 0,:) = p3.Training.origin.snapshots.eigenfunction * Datas.B.Machine;
% 
%         Datas.A.Machine(:,end) = [];
%         Datas.B.Machine(:,end) = [];
% 
% 
%     end
 
    

end