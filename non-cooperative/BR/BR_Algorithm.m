clc
clear all
close all
% import casadi name space
addpath('/Users/chyj528/Documents/MATLAB/casadi/casadi-osx-matlabR2015a-v3.5.5')
import casadi.*

%% load cooperative solution
load('../data/cooperative_solution.mat');
Uc = cooperative_solution;

%% specify paramaters
[r,c] = size(Uc);
N = r/2;
T = c;
Params = specify_paramaters(N,T); 
% initial condition T_AT, T_LO, M_AT, M_UP, M_LO, K_i
x0 = Params.x0; 
x0 = [x0;zeros(N,1)]; 

%% Initialize BR Algorithm
problem_horizon = T;
niteration = 20;
U_br = zeros(2*N,T,niteration);
U_br(:,:,1) = Uc;
t_sim = 0; % in BR Algorithm, default: t_sim = 0
%% BR Algorithm 
for k = 1:niteration
    for i = 1:N
        [U_i_opt,x_opt] = solve_ith_problem(i,Params,U_br(:,:,k),x0,problem_horizon,t_sim);
        U_br(i,:,k+1) = U_i_opt(1,:);
        U_br(i+N,:,k+1) = U_i_opt(2,:);  
    end
end

