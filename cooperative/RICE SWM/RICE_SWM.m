clc
clear all
close all

%% Specify # of regions, # of time steps
% # of regions involved in the RICE model; do not change
N = 12; 
% # of time steps; modify to your setting;
T = 120; 

% specify paramaters
Params = specify_paramaters(N,T); 

% initial condition T_AT, T_LO, M_AT, M_UP, M_LO, K_i
x0 = Params.x0; 
% add social welfare J to states
x0 = [x0;zeros(N,1)]; 

problem_horizon = T;

t_sim = 1; % for global social welfare equilibrium, default: t_sim =1
%% Try a guess
xuv_guess = try_a_guess(Params,problem_horizon);

%% SWM
[U_opt,x_opt,scc_opt] = solve_swm_problem(Params,x0,xuv_guess,problem_horizon,t_sim);

truncated_step = 120;
Plotstepsize = 100;
plot_results(U_opt,x_opt,scc_opt, truncated_step,Params,Plotstepsize);

clearvars -except U_opt x_opt scc_opt;
save('./results/SWM_opt.mat');

