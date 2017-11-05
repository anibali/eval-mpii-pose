function plotCurveNew(pckAll,range,predidxs,titleName,fname,bSave,rangeLabels)

if (nargin < 7)
    rangeLabels = range(1:2:end);
end

figure(100); clf; hold on;
set(0,'DefaultAxesFontSize',16);
set(0,'DefaultTextFontSize',16);

legendName = cell(length(predidxs),1);

for i = 1:size(pckAll,2)
    p = getExpParamsNew(predidxs(i));
    plot(range,pckAll(:,i)','color',p.colorName,'LineStyle','-','LineWidth',3);
    legendName{i} = p.name;
end

title(titleName);
legend(legendName,'Location','NorthWest');
set(gca,'YLim',[0 100],'xtick',rangeLabels,'ytick',0:10:100);
xlabel('Normalized distance');
ylabel('Detection rate, %');
grid on;

if (bSave)
    % NOTE: The pauses are a workaround for Matlab segfaulting
    print(gcf, '-dpng', [fname '.png']);
    pause(0.5);
    printpdf([fname '.pdf']);
    pause(0.5);
end

end
