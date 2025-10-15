function parameters = MethodOfEllipsoids_18(Datas, parameters, methods)

%x = ismember(parameters.multilevel.svmonly, [0,2]);
%x(2) = isempty(parameters.snapshots.k1);
%if ~x, return, end

if ~parameters.multilevel.chooseTrunc, return, end


%% Prep data
for C = 'AB'
    parameters.data.(C) = size(Datas.rawdata.([C 'Data']), 2);
end
%Datas = InScriptPrepData(Datas, parameters, methods);

parameters.data.i = 1;
parameters.data.j = 1;
Datas = methods.all.prepdata(Datas, parameters);


%Get a list of truncation parameters for class A
%Truncations = GetTruncations(parameters);
Truncations = GetTruncations(Datas, parameters, methods);



%Initialize Array of wrongly misplaced points
Record = Inf;
P = parameters.data.numofgene;
M = length(Truncations);
N = parameters.data.numofgene - min(Truncations);
WrongPoints = nan(max(Truncations),N);
WrongPoints2 = WrongPoints;
SepCrit = WrongPoints;

%Initialize Datas for Projection Onto AMA
parameters.snapshots.k1 = min(Truncations);


%parfor ima = Truncations
for ima = Truncations(:)'
    parameters.snapshots.k1 = ima;
    D2 = ProjectOntoAMA(Datas, parameters,methods);
    fprintf('Testing Truncation %d of %d \n', ima, max(Truncations));
    
%     D2 = Datas;
%     for C = 'AB', for set = ["CovTraining", "Machine", "Testing"]
%             D2.(C).(set) = Datas.(C).(set)(1:end-ima,:);
%     end, end

    D2 = ProjectOntoT(D2, parameters, methods);
    %Mres = parameters.data.numofgene - ima;

    W = WrongPoints(ima,:);
    W2 = WrongPoints2(ima,:);
    SC = SepCrit(ima,:);

    

    NFeatures = size(D2.A.Machine,1);

    parfor imres = 1:NFeatures
    %for imres = 38:NFeatures
        switch parameters.multilevel.eigentag
            case 'largest'
                iFeatures = (NFeatures - imres + 1):NFeatures;
            case 'smallest'
                iFeatures = 1:imres;
        end

        [W(imres), SC(imres)] = IdentifyMisplaced(D2, parameters, iFeatures);
    end


    WrongPoints(ima,:) = W;
    %WrongPoints2(ima,:) = W2;
    SepCrit(ima,:) = SC;

%     if any(W == 0)
%         WrongPoints = WrongPoints(1:ima,:);
%         SepCrit = SepCrit(1:ima,:);
%         break
%     end

end
fprintf('\n');

parameters = plotHeatMap1(WrongPoints, SepCrit, parameters);
%plotHeatMap1(WrongPoints2, parameters);
%parameters = plotHeatMap2(SepCrit, parameters);



end

%==========================================================================
function Truncations = GetTruncations(Datas, parameters, methods)

% parameters.snapshots.k1 = size(Datas.A.CovTraining, 2);
% 
% p = methods.Multi.snapshots(Datas.A.CovTraining, parameters, methods, parameters.snapshots.k1);

[~,S] = mysvd(Datas.A.CovTraining);

EV = cumsum(S) / sum(S);
Truncations1 = find(EV < 0.95);
%Truncations1 = find(EV < 0.95 & EV > 0.75);

EV2 = 1 - S / max(S);
Truncations2 = find(EV2 < 0.95);

%Truncations = intersect(Truncations1, Truncations2);
Truncations = Truncations1;

if isempty(Truncations)
    Truncations = 1:length(EV);
end

end
%==========================================================================


%==========================================================================
function [wrong, sc] = IdentifyMisplaced(Datas, parameters, iFeatures)

        nargoutchk(1,3);

        for C = 'AB', for set = ["Machine", "Testing"]
                Datas.(C).(set) = Datas.(C).(set)(iFeatures,:);
        end, end

               %% Get info on the principal axes of each Class
        for C = 'AB' 
            NC = 1/ sqrt( size(Datas.(C).Machine,2) - 1);
            MC = mean(Datas.(C).Machine, 2);
            XC = NC * (Datas.(C).Machine - MC);
            [E.(C).UC, E.(C).SC] = mysvd(XC); 
            eigendata.(['Eval' C]) = E.(C).SC;
            eigendata.(['Evec' C]) = E.(C).UC;
            E.(C).center = MC;
        end 

        %% Drop axes corresponding to sufficiently small singular values
        LSV = max([E.A.SC; E.B.SC]); %Largest Singular Value
        scaleFactor = 1/sqrt(max([size(E.A.UC,2), size(E.B.UC,2)]));
        zeroThresh = LSV * scaleFactor * eps;
        for C = 'AB'
            isSuffLarge = E.(C).SC >= zeroThresh;
            SC = E.(C).SC(isSuffLarge);
            UC = E.(C).UC(:,isSuffLarge);

            %% Transform into isotropic data
            
            if ~isempty(SC)
                E.(C).Kinv = (SC.^(-0.5) .* UC');
                YC = E.(C).Kinv * (Datas.(C).Machine - MC); 
                rC = sum(YC.^2, 1);
                E.(C).radius = quantile(rC, parameters.multilevel.concentration);
            elseif isempty(SC)
                E.(C).Kinv = 1;
                E.(C).radius = zeroThresh;
            end

            
           
        end

        %CM = nan(2,2); %Confusion matrix
        CM = nan(2,4);
        classes = 'AB';
        wrong = 0;

        for C = 'AB'
            
            X = [Datas.(C).Machine, Datas.(C).Testing];
            
           
            EllipseDistance = nan(2, size(X,2)); %First Row: Inside class A, Second Row, Inside Class B

            for D = 'AB'

                Y = E.(D).Kinv * (X - E.(D).center); %Transform data
               
                EllipseDistance('AB' == D,:) = sum(Y.^2,1);

            end

            predicted = EllipseDistance(1,:) > EllipseDistance(2,:);
            actual = C == 'A';
            wrong = wrong + sum(predicted ~= actual);

        end
       
        [~,sc,~,~] = ComputeSeparationCriterion(eigendata);


end
%==========================================================================

%==========================================================================
function parameters = plotHeatMap1(WrongPoints, SepCrit, parameters)

mysurf = @(x) surf(x, 'EdgeColor','none','FaceAlpha',0.7);
myimagesc = @(x) imagesc(x, 'FaceAlpha', 0.7);




%Obtain Best Truncation MA 
RecordWP = min(WrongPoints, [], 'all');
%title(sprintf('Misclassification Rate = %d', RecordWP))


imin = find(WrongPoints == RecordWP);

%SepCrit2 = SepCrit(imin);

RecordSepCrit = min(SepCrit(imin));
[BestMA, BestMres] = find(SepCrit == RecordSepCrit);

% SC = SepCrit(BestMA,:);
% figure('Name', 'Best Separation Criterion')
% plot(SC, 'LineWidth', 3), hold on
% scatter(BestMres, SC(BestMres), 40, 'r', 'filled')
% %ylim([0,100])
% title(sprintf('Min SC: %0.3e,\n MA = %d, Mres = %d', RecordSepCrit, BestMA, BestMres))
% allMres = [allMres, BestMres];

%Plot Heat Map corresponding to the number of misplaced points for each MA,
figure('Name', 'In Wrong Ellipsoid'), 
h = imagesc(WrongPoints); 
%h = mysurf(WrongPoints);
J = jet; 
colormap(J), colorbar
xlabel('Mres'), ylabel('MA')
h.AlphaData = ~isnan(WrongPoints);
title(sprintf('Best Misclassification: %0.4f,\nMA = %d, Mres = %d', RecordWP, BestMA(end), BestMres(end)))


figure('Name', 'Separation Criterion')
mysurf(SepCrit)
xlabel('Mres'), ylabel('MA')
%zlim([0,100])
title('Separation Criterion')
view(135,20)

parameters.snapshots.k1 = BestMA;
allMres = [parameters.multilevel.Mres(:) ; BestMres(:) ; parameters.data.numofgene - BestMA];
parameters.multilevel.Mres = sort(unique(allMres));

end
%==========================================================================

%==========================================================================
function parameters = plotHeatMap2(SepCrit, parameters)
%Plot Heat Map corresponding to the number of misplaced points for each MA,
%Mres
figure('Name', 'Separation Criterion'), 
h = imagesc(SepCrit); 
J = jet; 
colormap(J), colorbar
xlabel('Mres'), ylabel('MA')
h.AlphaData = ~isnan(SepCrit);


%Obtain Best Mres

% WP = WrongPoints(parameters.snapshots.k1,:);
% [Record] = min(WP);
% Mres = find(WP == Record);
%SC = SepCrit(parameters.snapshots.k1, Mres);
SC = SepCrit(parameters.snapshots.k1,:);

[m, imin] = min(SC);
%imres = Mres(imin);
figure('Name', 'Separation Criterion 2')
%plot(SepCrit(parameters.snapshots.k1,:), 'LineWidth', 3);
plot(SC, 'LineWidth', 3);
hold on
scatter(imin, m, 50, 'r', 'filled');
title(sprintf('Mres = %d', imin));

Mres = [parameters.multilevel.Mres,...
    imin,...
    parameters.data.numofgene - parameters.snapshots.k1];


parameters.multilevel.Mres = sort(unique(Mres));
end
%==========================================================================