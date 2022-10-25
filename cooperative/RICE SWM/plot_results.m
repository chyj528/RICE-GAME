function plot_results(u, x, SCC, truncated_step,Params,Plotstepsize)


[nu, T] = size(u);
N           = Params.N;
BaseYear    = Params.BaseYear;
Stepsize = Params.Stepsize;
EndYear = BaseYear + (truncated_step)*Stepsize;
years = BaseYear:Stepsize:EndYear;
regions = {'US','EU','Japan','Russia','Eurasia','China','India','MidEast','Africa','LatAm','OHI','OthAsia'};
% -------------------------------------------------------------------------
%% Control Inputs of Regions
mpdc12 = distinguishable_colors(24);
f1=figure(1);
%title('Optimal Control Desicions of All Regions');
set(f1,'Position',[311,368,1151,363]);
for i = 1:N
    plot(years(1:truncated_step),u(i,1:truncated_step),'-o','LineWidth',2,'Color',mpdc12(2*i,:)), hold on
end
xlim([BaseYear EndYear]);
xticks(BaseYear:Plotstepsize:EndYear);
xlabel('Years','fontsize',16,'FontWeight','bold');
ylabel('Emission-reduction rate','fontsize',16,'FontWeight','bold');
a1 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a1,'fontsize',16,'FontWeight','bold');
legend(regions);
legend('Location','eastoutside',fontsize = 16);
hold on

f2=figure(2);
set(f2,'Position',[311,368,1151,363]);
for i = 1:N
    plot(years(1:truncated_step),u(i+N,1:truncated_step),'-o','LineWidth',2,'Color',mpdc12(2*i,:)), hold on
end
xlim([BaseYear EndYear]);
xticks(BaseYear:Plotstepsize:EndYear);
xlabel('Years','fontsize',16,'FontWeight','bold');
%ylim([0.15 0.3]);
ylabel('Saving rate','fontsize',16,'FontWeight','bold');
a1 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a1,'fontsize',16,'FontWeight','bold');
legend(regions);
legend('Location','eastoutside',fontsize = 16);
hold on

% 
% % -------------------------------------------------------------------------
% %% Plot Endogenous States
% 
f3 = figure(3);
%title('Temperature Deviation');
set(f3,'Position',[858,422,506,264]);

plot(years(1:truncated_step),x(1,1:truncated_step),'-o','LineWidth',2,'Color',[0 0.4470 0.7410]);
xlim([BaseYear EndYear]);
xticks(BaseYear:Plotstepsize:EndYear);
xlabel('Years','fontsize',16,'FontWeight','bold');
ylabel('$\bf T^{\rm \bf AT}$','Interpreter','latex','fontsize',16,'FontWeight','bold');
a1 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a1,'fontsize',16,'FontWeight','bold');
hold on
% 
% % subplot(2,1,2), 
% % stem(years(1:truncated_step),x(2,1:truncated_step),'LineWidth',2);
% % xlim([BaseYear EndYear]);
% % xticks(BaseYear:Plotstepsize:EndYear);
% % xlabel('Years','fontsize',16,'FontWeight','bold');
% % ylabel('$\bf T^{\rm \bf LO}$','Interpreter','latex','fontsize',16,'FontWeight','bold');
% % a1 = get(gca,'XTickLabel');
% % set(gca,'XTickLabel',a1,'fontsize',16,'FontWeight','bold');
% % hold on
% 
% 
% % figure(3),title('Carbon Mass')
% % subplot(3,1,1) 
% % stem(years(1:truncated_step),x(3,1:truncated_step),'LineWidth',2), ylabel('$\bf M^{\rm \bf AT}$','Interpreter','latex'), xlabel('years'), hold on
% % temp = axis; axis([BaseYear EndYear temp(3) temp(4)]);
% % 
% % subplot(3,1,2) 
% % stem(years(1:truncated_step),x(4,1:truncated_step),'LineWidth',2), ylabel('$\bf M^{\rm \bf UP}$','Interpreter','latex'), xlabel('years'), hold on
% % temp = axis; axis([BaseYear EndYear temp(3) temp(4)]);
% % 
% % subplot(3,1,3) 
% % stem(years(1:truncated_step),x(5,1:truncated_step),'LineWidth',2), ylabel('$\bf M^{\rm \bf LO}$','Interpreter','latex'), xlabel('years'), hold on
% % temp = axis; axis([BaseYear EndYear temp(3) temp(4)]);
% 
% 
% % figure(4), title('Social Welfare of All regions')
% % for i = 1:N
% %     plot(years(1:truncated_step),-x(5+N+i,1:truncated_step),'-o','LineWidth',2,'Color',mpdc12(2*i,:)), hold on
% % end
% % xlim([BaseYear EndYear]);
% % xticks(BaseYear:Plotstepsize:EndYear);
% % xlabel('Years','fontsize',16,'FontWeight','bold');
% % ylabel('Social Welfare','fontsize',16,'FontWeight','bold');
% % a1 = get(gca,'XTickLabel');
% % set(gca,'XTickLabel',a1,'fontsize',16,'FontWeight','bold');
% % legend(regions);
% % legend('Location','eastoutside',fontsize = 12);
% % hold on
% 
% 
% % -------------------------------------------------------------------------
%Plot Social Cost of Carbon

mpdc12 = distinguishable_colors(24);
f4=figure(4);
set(f4,'Position',[311,368,1151,363]);
for i = 1:N
    plot(years(1:truncated_step),SCC(i,1:truncated_step),'-o','LineWidth',2,'Color',mpdc12(2*i,:)), hold on
end
xlim([BaseYear EndYear]);
xticks(BaseYear:Plotstepsize:EndYear);
xlabel('Years','fontsize',16,'FontWeight','bold');
ylabel('Carbon prices ( USD/GtC )','fontsize',16,'FontWeight','bold');
a1 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a1,'fontsize',16,'FontWeight','bold');
legend(regions);
legend('Location','eastoutside',fontsize = 16);
hold on
% display('============================================================')
% format long; display(['Optimal Welfare:   ', num2str(J)])      
% display('============================================================')
