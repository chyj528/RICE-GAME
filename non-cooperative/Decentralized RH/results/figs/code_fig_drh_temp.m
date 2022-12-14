function createfigure(X1, YMatrix1)
%CREATEFIGURE(X1, YMatrix1)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 21-Oct-2022 12:32:18

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'LineWidth',2,'LineStyle','none','Parent',axes1);
set(plot1(1),'DisplayName','T=120','Marker','o');
set(plot1(2),'DisplayName','BR:K=20','Marker','v');
set(plot1(3),'DisplayName','DRH:T_{pre}=20','Marker','>');
set(plot1(4),'DisplayName','DRH:T_{pre}=10','Marker','+');
set(plot1(5),'DisplayName','DRH:T_{pre}=5','Marker','*');

% Create ylabel
ylabel('$\bf T^{\rm \bf AT}$','FontWeight','bold','Interpreter','latex');

% Create xlabel
xlabel('Years','FontWeight','bold');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[2020 2620]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0.5 8.5]);
box(axes1,'on');
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'FontSize',18,'FontWeight','bold','XTick',...
    [2020 2170 2320 2470 2620],'XTickLabel',...
    {'2020','2170','2320','2470','2620'},'YTick',[0.5 2.5 4.5 6.5 8.5]);
% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Location','eastoutside','FontSize',17);

