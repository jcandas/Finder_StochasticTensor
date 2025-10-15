function Truncations = GetTruncations_24(Datas,parameters,field,N)

%returns the indices of the quinquagintiles of the eigenvalues of X*X';


narginchk(3,4)
if nargin == 3, N = 50; end

p = (1:N)/N;

Truncations = [];

figure
for C = 'AB'

    %Center the data
    MC = mean(Datas.(C).(field), 2);
    XC =  Datas.(C).(field) - MC;

    %Find the squared distance of each point from its mean
    switch parameters.multilevel.eigentag
        case 'smallest'
            distsq = cumsum(XC.^2,1, 'forward');
            distsqn = distsq ./ distsq(end,:); %Normalize
            quanttag = 'last';
        case 'largest' 
            distsq = cumsum(XC.^2,1, 'reverse');
            distsqn = distsq ./ distsq(1,:); %Normalize
            quanttag = 'first';
    end

    
    

    %Find the (100*p)th percentile of each row
    pile = quantile(distsq, parameters.multilevel.concentration, 2);
    %nzeros = max([parameters.data.A - size(XC,1), 0]);
    %zpad = zeros(1,nzeros);
    %S = [pile(:) ; zpad(:)];

    %Find the (100*p)th percentile of each row
    EV = quantile(distsqn, parameters.multilevel.concentration, 2);
    %opad = ones(1,nzeros);
    %EV = [EV(:); opad(:)];

     subplot(2,1,1), plot(pile, 'LineWidth', 2), hold on, xlabel('Number of Features'), ylabel('l2 Norm')
                    title(sprintf('%0.3gth Percentile', 100*parameters.multilevel.concentration))
                    legend({'A', 'B'}), set(gca, 'YGrid', 'on')

    subplot(2,1,2), plot(EV, 'LineWidth', 2), hold on, xlabel('Number of Features'), ylabel('Normalized l2 Norm')
                    title('Normalized Cumsum'), legend({'A', 'B'}), set(gca, 'YGrid', 'on')


    

    %Find quantiles of normalized cumsum explained variance   
    keep = true;
    %while keep
        myquantile = @(p) find( EV(:)' <= p, 1, quanttag);
        newTruncs = arrayfun(myquantile, p, 'UniformOutput', false);
        newTruncs = [newTruncs{:}];
        uTruncs = unique(newTruncs);
        % lTrunc = length(uTruncs);
        % EV = log(EV + eps); 
        % EV = EV + min(EV); 
        % EV = EV / max(EV);
        % keep = lTrunc < min([6, length(EV)]);
    %end 

   

    Truncations = [Truncations, uTruncs];

end 

Truncations = unique(Truncations);
close all


% if length(Truncations) < 6
%     S = log(S);
%     EV = cumsum(S) / sum(S);
%     myquantile = @(p) find( EV(:)' >= p, 1, 'last');
%     Truncations = arrayfun(myquantile, p);
% end


% for C = 'AB'
%     NC = size(Datas.(C).CovTraining,2);
%     meanC = mean(Datas.(C).CovTraining,2);
%     XC = 1/sqrt(NC - 1)*(Datas.(C).CovTraining - meanC);
%     [UC, SC] = mysvd(XC);
% 
%     eigendata.(['Evec' C]) = UC;
%     eigendata.(['Eval' C]) = SC;
% end
% 
% 
% methods.Ellipsoids.ComputeSC(eigendata);
end