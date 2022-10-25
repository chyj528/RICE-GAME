function [U_opt,x_opt,scc_opt] = solve_swm_problem(Params,x0,xuv_guess,problem_horizon,t_sim)
%% Set parameters
N = Params.N;
T = problem_horizon;
nx = length(x0);
nu = 2;
nv = 2;

%% Construct bounds for control decisions

u_LB = zeros(nu*N,T);
u_UB = ones(nu*N,T);

x_LB = zeros(nx, T+1);
x_LB(6+N:5+2*N, :) = -inf; % no lower bound on objective 
x_UB = inf*ones(nx, T+1); % no upper bound on states 

%x_UB(1,:) = 3*ones(1,:); % temperature constraint T < 2

v_LB = -inf*ones(nv*N, T);
v_UB =  inf*ones(nv*N, T); 

xuv_LB = [x_LB(:); u_LB(:);v_LB(:)];
xuv_UB = [x_UB(:); u_UB(:);v_UB(:)];

%% NLP
% Allocate CASADI variables
addpath('/Users/chyj528/Documents/MATLAB/casadi/casadi-osx-matlabR2015a-v3.5.5')
import casadi.*

x      = SX.sym('x', nx, T+1); % states + value 
u      = SX.sym('u', nu*N,T); % inputs
v      = SX.sym('v', nv*N, T); % variables of interest, i.e. emissions & consumption
eq_con = SX.sym('eq_con', nx + nv*N, T+1); % (nx) * (T+1) constraints for the dynamics and variables of interest

% Rice dynamics
for  t = 1:T
    if  t == 1
       eq_con(1:nx,1) = x(1:nx,1) - x0(1:nx); 
    end
    % equality constraints for dynamics(1:nx)
    [ft, ht] = rice_dynamics(x(:,t),u(:,t),v(:,t),t+t_sim-1,Params);
    eq_con(1:nx,t+1) = x(1:nx,t+1) - ft; 
     % equality constraints assigning emmissions and consumption 
    eq_con(nx+1:end, t) = (v(:,t) - ht);
    % equality constraints assigning emmissions and consumption 
     if t == T
     eq_con(nx+1:end, t+1) = zeros(nv*N,1);    % dummy constraint at i = N+1
     end
end

% Objective
obj = Params.scale1' * x(6+N:5+2*N,end);

% define nlp variables
nlp = struct('x', [x(:);u(:);v(:)], 'f', obj, 'g', eq_con(:));

% options for IPOPT
opts = struct;
opts.ipopt.max_iter    = 3000;
opts.ipopt.print_level = 3;%0,3
opts.print_time        = 0;
opts.ipopt.acceptable_tol =1e-12;
opts.ipopt.acceptable_obj_change_tol = 1e-12;
opts.ipopt.mu_strategy                 = 'adaptive';

% create IPOPT solver object
solver = nlpsol('solver', 'ipopt', nlp);

% solve the NLP
tic

lbg = zeros(nx + nv*N, T+1);
ubg = zeros(nx + nv*N, T+1); 

res = solver( 'x0' , xuv_guess,...      % solution guess
              'lbx', xuv_LB,...         % lower bound on x
              'ubx', xuv_UB,...         % upper bound on x
              'lbg', 0,...              % lower bound on g
              'ubg', 0);                % upper bound on g
t_NLP = toc;

x_res = full(res.x);

v_opt = x_res(end-length(v(:))+1:end);
v_opt = reshape(v_opt, nv*N, T);

U_opt = x_res(end-length(v(:))-length(u(:))+1:end-length(v(:)));
U_opt = reshape(U_opt, nu*N, T);

x_opt = x_res(1:end-length(v(:))-length(u(:)));
x_opt = reshape(x_opt, nx, T+1);

%% Marginals and Social Cost of Carbon
lam  = full(res.lam_g);
lam  = reshape(lam, nx + nv*N, T+1);
lamE = zeros(N, T);
lamC = zeros(N, T);
SCC = zeros(N, T);
for i = 1:N
    lamE(i,:) = lam(nx + i,1:end-1);
    lamC(i,:) = lam(nx + i+N,1:end-1);
    scc_opt(i,:) = -1000*[lamE(i,1:end)]./[lamC(i,1:end)];
end
