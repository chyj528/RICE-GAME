% clear all;close all;
% U1 = load('./results/U_BR_K_20.mat');
% U2 = load('./results/T_120_K_20.mat');
% 
% load('../../cooperative/RICE SWM/results/SWM_opt.mat','U_opt');
% Uc = U_opt;
for i = 1:12
    %% examine Uc vs U_br
    subplot(3,4,i)
    plot(U1.U_fb(i,:,2));hold on
    plot(U2.U_fb(i,:,2));hold on
    plot(Uc(i,:))
end
legend