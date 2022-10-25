% clear all;close all;
load('../../cooperative/RICE SWM/results/SWM_opt.mat','U_opt');
for i = 1:12
    %% examine Uc vs U_br
    figure
    plot(U_fb(i,1:120),'-o');hold on
    plot(U_opt(i,1:120),'-o');
end
legend