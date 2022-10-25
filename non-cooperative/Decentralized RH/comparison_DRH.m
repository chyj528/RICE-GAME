%% Load Data
clear all;close all;
DRH_T5 = load('./results/DRH_T5.mat');
DRH_T10 = load('./results/DRH_T10.mat');
DRH_T20 = load('./results/DRH_T20.mat');
BR_K20 = load('../BR/results/BR_K_20.mat');


Uc = load('../../cooperative/RICE SWM/results/SWM_opt.mat');

N = 12;
T = 121;
truncated_step = length(DRH_T20.U_fb);
Params = specify_paramaters(N,T); 
BaseYear    = Params.BaseYear;
Stepsize = Params.Stepsize;
EndYear = BaseYear + (truncated_step-1)*Stepsize +5;
years = BaseYear:Stepsize:EndYear;
regions = {'US','EU','Japan','Russia','Eurasia','China','India','MidEast','Africa','LatAm','OHI','OthAsia'};

%% Comparison: Emission_reduction Rate
f1 = figure(1);
set(f1,'Position',[264,84,1475,821]); % compare 4
set(gca, 'LooseInset', get(gca,'TightInset'))
mpdc12 = distinguishable_colors(24);
for i = 1:N
    subplot(4,3,i) 
    plot(years(1:truncated_step),Uc.U_opt(i,1:truncated_step),'o','LineWidth',2), hold on
    plot(years(1:truncated_step),BR_K20.U_br(i,1:truncated_step,end),'v','LineWidth',2), hold on
    plot(years(1:truncated_step),DRH_T20.U_fb(i,1:truncated_step),'>','LineWidth',2), hold on
    plot(years(1:truncated_step),DRH_T10.U_fb(i,1:truncated_step,end),'+','LineWidth',2), hold on
    plot(years(1:truncated_step),DRH_T5.U_fb(i,1:truncated_step),'*','LineWidth',2), hold on
    subtitle(string(regions(i)),'fontsize',18,'FontWeight','bold');
    xlim([BaseYear EndYear]);
    xticks(BaseYear:150:EndYear);
    ylim([0 1]);
    yticks(0:0.25:1);
    a1 = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a1,'fontsize',18,'FontWeight','bold');
    if i == N
        lgd = legend({'T=120','BR:K=20','DRH:T_{pre}=20','DRH:T_{pre}=10','DRH:T_{pre}=5'},'NumColumns',5,'fontsize',18);
        set(lgd,'Position',[0.460278416997444,0.952338611449449,0.442033898305085,0.042630937880633]); 
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
set(f2,'Position',[766,422,695,264]);
plot(years(1:truncated_step),Uc.x_opt(1,1:truncated_step),'o','LineWidth',2);hold on
plot(years(1:truncated_step),BR_K20.x_br_opt(1,1:truncated_step),'v','LineWidth',2);hold on
plot(years(1:truncated_step),DRH_T20.x_fb(1,1:truncated_step),'>','LineWidth',2), hold on
plot(years(1:truncated_step),DRH_T10.x_fb(1,1:truncated_step,end),'+','LineWidth',2), hold on
plot(years(1:truncated_step),DRH_T5.x_fb(1,1:truncated_step),'*','LineWidth',2), hold on
lgd = legend({'T=120','BR:K=20','DRH:T_{pre}=20','DRH:T_{pre}=10','DRH:T_{pre}=5'},'NumColumns',1,'Location','eastoutside','fontsize',17);
ylim([0.5 8.5]);
yticks(0.5:2:8.5);
xlim([BaseYear EndYear]);
xticks(BaseYear:150:EndYear);
xlabel('Years','fontsize',18,'FontWeight','bold');
ylabel('$\bf T^{\rm \bf AT}$','Interpreter','latex','fontsize',18,'FontWeight','bold');
a1 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a1,'fontsize',18,'FontWeight','bold');

