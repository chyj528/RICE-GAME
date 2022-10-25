clc;close all;clear all;
%% Set parameters; 
N = 12;
T = 180; % set large T to ensure parameters are enough
Params = specify_paramaters(N,T); 
x0 = Params.x0; 
x0 = [x0;zeros(N,1)]; 
%% Input
T_simulation = 2;
T_prediction = 10;
problem_horizon = T_prediction;
%% Initialize
U_rhw = zeros(2*N,T_simulation);
x_rhw = x0*ones(1,T_simulation + 1);
t_sim = 1;

%% Try a guess
xuv_guess = try_a_guess(Params,problem_horizon);

%% MPC-RICE

while t_sim <=T_simulation
    % observe x(t_sim)
    % solve swm problem with T_prediction
    [U_opt,x_opt,~] = solve_swm_problem(Params,x0,xuv_guess,problem_horizon,t_sim);
    U_rhw(:,t_sim) = U_opt(:,1);
    %[x(:,t_sim+1), ~] = test_rice_dynamics(x(:,t_sim),U_rhw(:,t_sim),t_sim,Params);
    x0 = x_opt(:,2);
    x_rhw(:,t_sim + 1) = x_opt(:,2);
    t_sim = t_sim + 1;
end

filename = 'rh_' + string(T_prediction) + '.mat';
clearvars -except U_rhw x_rhw filename
save('./results/' + filename);
