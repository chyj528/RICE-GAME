clc
clear all
close all
% import casadi name space
addpath('/Users/chyj528/Documents/MATLAB/casadi/casadi-osx-matlabR2015a-v3.5.5')
import casadi.*

%% Specify # of regions, # of time steps
% # of regions involved in the RICE model; do not change
N = 12; 
% # of time steps; modify to your setting;
T = 120; 

% specify paramaters
Params = specify_paramaters(N,T); 

% initial condition T_AT, T_LO, M_AT, M_UP, M_LO, K_i
x0 = Params.x0; % dimension: 5+N (17)
% add social welfare J to states
x0 = [x0;zeros(N,1)]; % dimension: 5+2*N (29)

nx = length(x0); % # of states
nu = 2; % # of inputs for each region at each time step
nv = 2; % for SCC computaion: eimission and consumption

%% Try a guess

% Set correct dimensions for x,u,v
x_guess = ones(nx, T+1);
u_guess = ones(nu*N,T);
v_guess = ones(nv*N,T);

% try one u
for i = 1:N  
    u_guess(i,:) = [0 0.5*ones(1,T-3) 0 0];
    u_guess(i+N,:) = [0.5*ones(1,T)];
end


for t = 1:T
    if t==1
        x_guess(:,1) = x0(:);
    end
    [ft, ht] = test_rice_dynamics(x_guess(:,t),u_guess(:,t),t,Params);
    x_guess(:,t+1) = ft;
    v_guess(:, t) = ht;
end

J_guess = -sum(x_guess(18:29,end))

xuv_guess = [x_guess(:);u_guess(:);v_guess(:)];

%% Weighed Overall Social Welfare Optimization

% Construct bounds for control decisions

u_LB = zeros(nu*N,T);
u_UB = ones(nu*N,T);

x_LB = zeros(nx, T+1);
x_LB(6+N:5+2*N, :) = -inf; % no lower bound on objective 
x_UB = inf*ones(nx, T+1); % no upper bound on states 

%x_UB(1,1:11) = 3*ones(1,11); % T < 2


v_LB = -inf*ones(nv*N, T);
v_UB =  inf*ones(nv*N, T); 

xuv_LB = [x_LB(:); u_LB(:);v_LB(:)];
xuv_UB = [x_UB(:); u_UB(:);v_UB(:)];

% allocate CASADI variables
x      = SX.sym('x', nx, T+1); % states + value 
u      = SX.sym('u', nu*N,T); % inputs
v      = SX.sym('v', nv*N, T); % variables of interest, i.e. emissions & consumption
eq_con = SX.sym('eq_con', nx + nv*N, T+1); % (nx) * (T+1) constraints for the dynamics and variables of interest

% rice dynamics

for  t = 1:T
    if  t == 1
       eq_con(1:nx,1) = x(1:nx,1) - x0(1:nx); 
    end
    % equality constraints for dynamics(1:nx)
    
    [ft, ht] = rice_dynamics(x(:,t),u(:,t),v(:,t),t,Params);
    eq_con(1:nx,t+1) = x(1:nx,t+1) - ft; 
    
     % equality constraints assigning emmissions and consumption 
    eq_con(nx+1:end, t) = (v(:,t) - ht);
    
    % equality constraints assigning emmissions and consumption 
     if t == T
     eq_con(nx+1:end, t+1) = zeros(nv*N,1);    % dummy constraint at i = N+1
    end
    
end

cnt = 0;
iterations = 1/1000;
developed_opt = [];
developing_opt = [];
T_AT_c = []
c_range = 0:iterations:1;
for c = c_range
    cnt = cnt +1;
    % define the objective=
    developed = x(5+N+1,end) + x(5+N+2,end) + x(5+N+3,end) + x(5+N+11,end);
    developing = sum(x(6+N:5+2*N,end)) - developed;
    obj = c*developed + (1-c)*developing;

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


    lbg = zeros(nx + nv*N, T+1);
    ubg = zeros(nx + nv*N, T+1); 

    res = solver( 'x0' , xuv_guess,...      % solution guess
                  'lbx', xuv_LB,...         % lower bound on x
                  'ubx', xuv_UB,...         % upper bound on x
                  'lbg', 0,...              % lower bound on g
                  'ubg', 0);                % upper bound on g

    x_res = full(res.x);

    v_opt = x_res(end-length(v(:))+1:end);
    v_opt = reshape(v_opt, nv*N, T);

    u_opt = x_res(end-length(v(:))-length(u(:))+1:end-length(v(:)));
    u_opt = reshape(u_opt, nu*N, T);

    x_opt = x_res(1:end-length(v(:))-length(u(:)));
    x_opt = reshape(x_opt, nx, T+1);


    developed_opt(cnt) = -(x_opt(5+N+1,end) + x_opt(5+N+2,end) + x_opt(5+N+3,end) + x_opt(5+N+11,end));
    developing_opt(cnt) = -sum(x_opt(6+N:5+2*N,end)) - developed_opt(cnt);
    T_AT_c(cnt) = x_opt(1,end);
end
clear_list = {'eq_con','fi','hi','i','lbg','nlp','nu','nv','nx', ...
    'obj','opts','solver','t_NLP','u','u_guess','u_LB', ...
    'u_UB','ubg','v','v_guess','v_LB','v_UB',                                                                             'x_guess','x_LB','x_UB', ...
    'xuv_guess','xuv_LB','xuv_UB'};
clear(clear_list{:});

 %plot_results(u_opt,x_opt, geo_Params)
 mini = min(developed_opt/(10^4));
 maxi = max(developed_opt/(10^4));
figure(1);
zoomplot(developed_opt,developing_opt);
f2 = figure(2);
set(f2,'Position',[583,536,515,265]);
scatter(c_range,T_AT_c,'LineWidth',2);
a1 = get(gca,'XTickLabel');
set(gca,'XTickLabel',a1,'fontsize',12,'FontWeight','bold');
xlabel('$p$','Interpreter','latex','fontsize',16,'FontWeight','bold');
ylabel('$\bf T^{\rm \bf AT}(119)$','Interpreter','latex','fontsize',14,'FontWeight','bold');
grid on;
 