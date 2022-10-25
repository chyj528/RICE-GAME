function [U_i_opt,x_opt] = solve_ith_problem(i,Params,U_observe,x0,problem_horizon,t_sim)

N = Params.N;
T = problem_horizon;
nx = length(x0); % # of states
nu = 2;

%% Try a guess

% Set correct dimensions for x,u (now:only u_i is a variable)
x_guess = ones(nx, T+1);
u_guess = 0.5*ones(nu,T); % for u_i = [s_i mu_i]

% try one u 

U_observe(i,:) = u_guess(1,:);
U_observe(i+N,:) = u_guess(2,:);

u_guess = U_observe;
for t = 1:T
    if t==1
        x_guess(:,1) = x0(:);
    end
    [ft, ht] = test_rice_dynamics(x_guess(:,t),u_guess(:,t),t+t_sim,Params);
    x_guess(:,t+1) = ft;
    v_guess(:, t) = ht;
end


xu_guess = [x_guess(:);U_observe(i,:)';U_observe(i+N,:)'];

%%  Construct Bounds for variables
% Bounds for u_i
u_LB = zeros(nu,T);
u_UB = ones(nu,T);

% Bounds for x 
x_LB = zeros(nx, T+1);
x_LB(6+N:5+2*N, :) = -inf; % no lower bound on objective 
x_UB = inf*ones(nx, T+1); % no upper bound on states 
%x_UB(1,:) = 2.42; 

xu_LB = [x_LB(:); u_LB(:);];
xu_UB = [x_UB(:); u_UB(:);];

% Allocate CASADI variables
addpath('/Users/chyj528/Documents/MATLAB/casadi/casadi-osx-matlabR2015a-v3.5.5')
import casadi.*

x      = SX.sym('x', nx, T+1); % states + welfare
u      = SX.sym('u', nu,T); % u_i
eq_con = SX.sym('eq_con', nx, T+1); % system dynamics


% Constraint of RICE Dynamics for Player i

for t = 1:T
    if t == 1
        eq_con(1:nx,1) = x(1:nx,1) - x0(1:nx);
    end
    % given player i's observation, equality constraints for dynamics(1:nx)
    [ft] = ith_rice_dynamics(i,x(:,t),u(:,t),U_observe(:,t),t+t_sim,Params);
    eq_con(1:nx,t+1) = x(1:nx,t+1) - ft; 
end

% define objective
obj = x(5+N+i,end);

% define nlp variables
nlp = struct('x', [x(:);u(:);], 'f', obj, 'g', eq_con(:)); 

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

lbg = zeros(nx, T+1);
ubg = zeros(nx, T+1); 

res = solver( 'x0' , xu_guess,...      % solution guess
              'lbx', xu_LB,...         % lower bound on x
              'ubx', xu_UB,...         % upper bound on x
              'lbg', 0,...              % lower bound on g
              'ubg', 0);                % upper bound on g
t_NLP = toc;

x_res = full(res.x);
U_i_opt = x_res(end - length(u(:))+1:end);
U_i_opt = reshape(U_i_opt,nu,T);

x_opt = x_res(1:end-length(u(:)));
x_opt = reshape(x_opt, nx, T+1);








