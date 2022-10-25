%% Load Data
clear all;close all;
BR = load('./results/BR_K_20.mat');
%U2 = load('./results/T_120_K_20.mat');

Uc = load('../../cooperative/RICE SWM/results/SWM_opt.mat');
%Uc = U_opt;

N = 12;
T = 121;
truncated_step = length(BR.U_br);
Params = specify_paramaters(N,T); 
BaseYear    = Params.BaseYear;
Stepsize = Params.Stepsize;
EndYear = BaseYear + (truncated_step-1)*Stepsize +5;
years = BaseYear:Stepsize:EndYear;
regions = {'US','EU','Japan','Russia','Eurasia','China','India','MidEast','Africa','LatAm','OHI','OthAsia'};

% %% Comparison: Emission_reduction Rate
% f1 = figure(1);
% set(f1,'Position',[270,1,1213,821]); % compare 4
% set(gca, 'LooseInset', get(gca,'TightInset'))
% mpdc12 = distinguishable_colors(24);
% for i = 1:N
%     subplot(4,3,i) 
%     plot(years(1:truncated_step),Uc.U_opt(i,1:truncated_step),'o','LineWidth',2), hold on
%     plot(years(1:truncated_step),BR.U_br(i,1:truncated_step,end),'v','LineWidth',2), hold on
%     subtitle(string(regions(i)),'fontsize',18,'FontWeight','bold');
%     xlim([BaseYear EndYear]);
%     xticks(BaseYear:150:EndYear);
%     ylim([0 1]);
%     yticks(0:0.25:1);
%     a1 = get(gca,'XTickLabel');
%     set(gca,'XTickLabel',a1,'fontsize',18,'FontWeight','bold');
%     if i == N
%         lgd = legend({'T=120','Iteration K'},'NumColumns',2,'Location','eastoutside','fontsize',18);
%         set(lgd,'Position',[0.720487731346232,0.953654080389768,0.184666117065128,0.04]); 
%     end
% end
% 
% han=axes(f1,'visible','off'); 
% han.Title.Visible='on';
% han.XLabel.Visible='on';
% han.YLabel.Visible='on';
% x = xlabel('Years','fontsize',18,'FontWeight','bold');
% y = ylabel('Emission-reduction Rate','fontsize',18,'FontWeight','bold');
% set(y, 'Units', 'Normalized', 'Position', [-0.06, 0.5, 0]);
% 
% set(x, 'Units', 'Normalized', 'Position', [0.5, -0.05, 0]);
% 
% 
% %% Comparison: Temperature
% f2 = figure(2);
% set(f2,'Position',[858,422,613,264]);
% plot(years(1:truncated_step),Uc.x_opt(1,1:truncated_step),'-o','LineWidth',2);hold on
% plot(years(1:truncated_step),BR.x_br_opt(1,1:truncated_step),'-v','LineWidth',2);hold on
% 
% legend({'T=120','Iteration K'},'NumColumns',1,'Location','eastoutside');
% ylim([0.5 6.5]);
% yticks(0.5:2:6.5);
% xlim([BaseYear EndYear]);
% xticks(BaseYear:150:EndYear);
% xlabel('Years','fontsize',18,'FontWeight','bold');
% ylabel('$\bf T^{\rm \bf AT}$','Interpreter','latex','fontsize',18,'FontWeight','bold');
% a1 = get(gca,'XTickLabel');
% set(gca,'XTickLabel',a1,'fontsize',18,'FontWeight','bold');

%% Plot norm(U_br(:,:,k+1) - U_br(:,:,k)) vs k 

a = zeros(12,20);
K = 21;
iterations = 1:K;
for k = 1:K-1
    for i = 1:12
        a(i,k) = norm(BR.U_br(i,:,k+1) - BR.U_br(i,:,k)); 
    end
end

f3 = figure(3);
set(f3,'Position',[226,23,791,821]);
set(gca, 'LooseInset', get(gca,'TightInset'))
for i = 1:N
    subplot(4,3,i) 
    plot(iterations(1:end-1),a(i,1:end),'-o','LineWidth',2), hold on
    subtitle(string(regions(i)),'fontsize',18,'FontWeight','bold');
    a1 = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a1,'fontsize',18,'FontWeight','bold');
    ylim([0 6]);
    yticks(0:2:6);
    xlim([1 20]);
    xticks(1:4:20);
end

han=axes(f3,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
x = xlabel('Iterations','fontsize',18,'FontWeight','bold');
y = ylabel('$\bf {\boldmath||U^{(k+1)}_{i} - U^{(k)}_{i}||}$','Interpreter','latex','fontsize',18,'FontWeight','bold');
set(y, 'Units', 'Normalized', 'Position', [-0.05, 0.5, 0]);
set(x, 'Units', 'Normalized', 'Position', [0.5, -0.05, 0]);

for i = 1:N
    createaxes(f3, i, iterations(2:6), a(i,2:6));
end


