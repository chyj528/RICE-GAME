clear;clc;close all;

%% Initialize Parameters, Cooperative Solutions
%% load cooperative solution
load('../data/cooperative_solution.mat');
Uc = cooperative_solution;

[r,c] = size(Uc);
N = r/2;
T = c;
Params = specify_paramaters(N,200); 
x0 = Params.x0; 
x0 = [x0;zeros(N,1)]; 
%% Input: Simulation Horizon; Prediction Horizon
T_simulation = 120;
T_prediction = 5;
problem_horizon = T_prediction;

%% Initialize
U_fb = zeros(2*N,T_simulation);
U_fb(:,1) = Uc(:,1);
%U_fb(:,1) = 0.5*ones(2*N,1);
U_assume = zeros(2*N,T_prediction);
x_fb = x0*ones(1,T_simulation + 1);
t_sim = 1;
%x = ones(length(x0),T_simulation + 1);
%x(:,1) = x0;

%% Decentralized Receding Horizon Planning
while t_sim <= T_simulation
    % find initial state of the following receding horizon optimization problem
    [x_fb(:,t_sim+1), ~] = test_rice_dynamics(x_fb(:,t_sim),U_fb(:,t_sim),t_sim,Params);
    x0 = x_fb(:,t_sim+1);
    % assume all player j \neq i continue to play U_{-i}^{fb}(t)
    U_assume = U_fb(:,t_sim)*ones(1,T_prediction); % 2N*1 1*T_prediction --> 2N * T_prediction
    
    for i = 1:N
        [U_i_opt,x_opt] = solve_ith_problem(i,Params,U_assume,x0,problem_horizon,t_sim);
        U_fb(i,t_sim+1) = U_i_opt(1,1);
        U_fb(i+N,t_sim+1) = U_i_opt(2,1); % U_i^{fb}(t+1) = u_i^{drh}(t+1)
    end
    %x(:,t_sim + 2) = x_opt(:,2);
    t_sim = t_sim + 1;
    if mod(t_sim,10) == 0
        save('./results/DRH_T'+string(T_prediction)+'.mat');
    end
end
