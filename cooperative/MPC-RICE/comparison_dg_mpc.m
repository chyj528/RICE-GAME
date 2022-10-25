%% Load Data
clc
clear
close all
SWM = load('../RICE SWM/results/SWM_opt.mat');
rh_10 = load('./results/rh_10.mat');
rh_20 = load('./results/rh_20.mat');
rh_60 = load('./results/rh_60.mat');


N = 12;
T = 121;
truncated_step = length(rh_10.u_mpc);
Params = specify_paramaters(N,T); 
BaseYear    = Params.BaseYear;
Stepsize = Params.Stepsize;
EndYear = BaseYear + (truncated_step-1)*Stepsize +5;
years = BaseYear:Stepsize:EndYear;
regions = {'US','EU','Japan','Russia','Eurasia','China','India','MidEast','Africa','LatAm','OHI','OthAsia'};

%% Comparison: Emission_reduction Rate
f1 = figure(1);
%set(f1,'Position',[440,18,818,780]);
set(f1,'Position',[270,1,968,821]); % compare 4
set(gca, 'LooseInset', get(gca,'TightInset'))
mpdc12 = distinguishable_colors(24);
for i = 1:N
    subplot(4,3,i) 
    plot(years(1:truncated_step),SWM.U_opt(i,1:truncated_step),'o','LineWidth',2), hold on
    plot(years(1:truncated_step),rh_10.u_mpc(i,1:truncated_step),'v','LineWidth',2), hold on
    plot(years(1:truncated_step),rh_20.u_mpc(i,1:truncated_step),'+','LineWidth',2), hold on
    plot(years(1:truncated_step),rh_60.u_mpc(i,1:truncated_step),'x','LineWidth',2), hold on
    subtitle(string(regions(i)),'fontsize',18,'FontWeight','bold');
    xlim([BaseYear EndYear]);
    xticks(BaseYear:150:EndYear);
    ylim([0 1]);
    yticks(0:0.25:1);
    a1 = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a1,'fontsize',18,'FontWeight','bold');
    if i == N
        lgd = legend({'T=120','T_{rh}=10','T_{rh}=20','T_{rh}=60'},'NumColumns',4,'Location','eastoutside','fontsize',18);
        set(lgd,'Position',[0.5,0.95,0.4,0.04]); 
    end
end

han=axes(f1,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
x = xlabel('Years','fontsize',18,'FontWeight','bold');
y = ylabel('Emission-reduction Rate','fontsize',18,'FontWeight','bold');
set(y, 'Units', 'Normalized', 'Position', [-0.06, 0.5, 0]);

set(x, 'Units', 'Normalized', 'Position', [0.5, -0.05, 0]);


%% Comparison: Temperature
f2 = figure(2);
set(f2,'Position',[858,422,506,264]);
plot(years(1:truncated_step),SWM.x_opt(1,1:truncated_step),'-o','LineWidth',2);hold on
plot(years(1:truncated_step),rh_10.x_mpc(1,1:truncated_step),'-v','LineWidth',2);hold on
plot(years(1:truncated_step),rh_20.x_mpc(1,1:truncated_step),'-+','LineWidth',2);hold on
plot(years(1:truncated_step),rh_60.x_mpc(1,1:truncated_step),'-x','LineWidth',2);hold on

legend({'T=120','T_{rh}=10','T_{rh}=20','T_{rh}=60'},'NumColumns',1,'Location','eastoutside');
ylim([1.1 4.5])
xlim([BaseYear EndYear]);
xticks(BaseYear:100:EndYear);
xlabel('Years','fontsize',18,'FontWeight','bold');
ylabel('$\bf T^{\rm \bf AT}$','Interpreter','latex','fontsize',18,'FontWeight','bold');
a1 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a1,'fontsize',18,'FontWeight','bold');
hold on

