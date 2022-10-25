function zoomplot(developed_opt,developing_opt)
close all
% Create a figure with a sine wave with random noise on it:
h1 = figure;
hold on;
scatter(developed_opt/(10^4),developing_opt/(10^4),'o','LineWidth',2)
grid on;
xlabel('Developed Countries （ \times 10^4 trillion USD )','Interpreter','tex','fontsize',14,'FontWeight','bold');
ylabel('Developing Countries （ \times 10^4 trillion USD )','Interpreter','tex','fontsize',14,'FontWeight','bold');
% It is important to set the figure size and limits BEFORE running
% MagInset!

% xlim([-7 2]);
% ylim([12 14.5]);
a1 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a1,'fontsize',12,'FontWeight','bold');
set(h1, 'Position',[105   647   560   420]);
% Once happy with your figure, add an inset:
MagInset(h1, -1, [2.925 2.94 14.3 14.45], [2.8 2.9 12.5 14], {'NW','NW';'SE','SE'});
a1 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a1,'fontsize',12,'FontWeight','bold');
