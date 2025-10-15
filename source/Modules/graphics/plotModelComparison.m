function plotModelComparison(rmos, rbase)
% plotModelComparison - Plots accuracy vs level and ROC curves using result structs
%
% Inputs:
%   rmos  - struct containing results for MOS-KL
%   rbase - struct containing results for baseline models: SVM, RF, GB, RUS

% Define method styles
methodNames = {'MOS-KL + SVM RBF', 'SVM RBF', 'Random Forest', 'Gradient Boosting', 'RUS Boost'};
colors = {
    [143 188 143]/255, ...
    [143 188 143]/255, ...
    [1 0.5 0.2], ...
    [30 144 255]/255, ...
    [119 136 153]/255
};
lineStyles = {'-', '--', '--', '--', '--'};
markers = {'o', '', '', '', ''};

% Determine levels (assume 0:(n-1) where n = length of rmos.accuracy)
num_levels = length(rmos.accuracy);
levels = 0:(num_levels - 1);

% --- Build Accuracy Matrix ---
% Replicate baseline accuracies to match MOS-KL length
acc_mos = rmos.accuracy;
acc_svm  = repmat(rbase.accuracy(1), 1, num_levels);
acc_rf = repmat(rbase.accuracy(2), 1, num_levels);
acc_gb  = repmat(rbase.accuracy(3), 1, num_levels);
acc_rus = repmat(rbase.accuracy(4), 1, num_levels);

acc_all = [
    acc_mos;
    acc_svm;
    acc_rf;
    acc_gb;
    acc_rus
];

% --- Build ROC Matrix ---
rocs = {
    rmos.ROCs{6},      % MOS-KL
    rbase.ROCs{1},       % SVM
    rbase.ROCs{2},       % RF
    rbase.ROCs{3},       % GB
    rbase.ROCs{4}        % RUS
};

% --- Begin Plotting ---
figure('Position', [100, 100, 1200, 500], 'Color', 'white');

% ----- Left plot: Accuracy vs Level -----
subplot(1,2,1);
hold on;
for i = 1:size(acc_all,1)
    if i == 1
        plot(levels, acc_all(i,:), [lineStyles{i}, markers{i}], 'Color', colors{i}, ...
            'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', [1 1 1], ...
            'MarkerEdgeColor', colors{i}, 'DisplayName', methodNames{i});
    else
        yline(acc_all(i,1), lineStyles{i}, 'Color', colors{i}, ...
            'LineWidth', 2, 'DisplayName', methodNames{i});
    end
end

ylim([0 1])
axis square
legend('Location','southwest','Interpreter','latex','FontSize',15)
grid on;
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.025 .025] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'XGrid'       , 'off'     , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'YTick'       , 0:0.1:1   , ...
  'XTick'       , 0:1:5     , ...
  'LineWidth'   , 1         );
ax = gca;
ax.FontSize = 11;
ylabel('Overall Accuracy','Interpreter','latex','FontSize',16)
xlabel('\emph{Level}','Interpreter','latex','FontSize',16)
%set(gca, 'XGrid', 'off', 'YGrid', 'on');
%set(gca, 'GridLineStyle', '-', 'GridColor', [0.85, 0.85, 0.85],'GridAlpha',1);

% ----- Right plot: ROC Curve -----
subplot(1,2,2); hold on;
for i = 1:length(rocs)
    plot(rocs{i}(:,1), rocs{i}(:,2), lineStyles{i}, ...
        'Color', colors{i}, 'LineWidth', 2, ...
        'DisplayName', methodNames{i});
end
xlim([0 1]); ylim([0 1]);
axis square
grid on;
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.025 .025] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'XGrid'       , 'off'     , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'YTick'       , 0:0.1:1   , ...
  'LineWidth'   , 1         );
ax = gca;
ax.FontSize = 11;
ylabel('True Positive Rate','Interpreter','latex','FontSize',16)
xlabel('\emph{False Positive Rate}','Interpreter','latex','FontSize',16)
%set(gca, 'XGrid', 'off', 'YGrid', 'on');
%set(gca, 'GridLineStyle', '-', 'GridColor', [0.85, 0.85, 0.85],'GridAlpha',1);

%exportgraphics(gcf, 'CNLMCI.pdf', 'ContentType', 'vector');
%set(gcf, 'PaperSize', [13 5]);
%set(gcf, 'PaperPosition', [0 0 13 5]);
%print(gcf, '-dpdf', 'adcn.pdf')

%set(gcf,'Units','inches');
%screenposition = get(gcf,'Position');
%set(gcf,...
%    'PaperPosition',[0 0 screenposition(3:4)],...
%    'PaperSize',[screenposition(3:4)]);
%print -dpdf -painters epsFig

end
