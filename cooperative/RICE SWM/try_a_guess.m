function [xuv_guess] = try_a_guess(Params,problem_horizon)
N = Params.N;
T = problem_horizon;
x0 = Params.x0; 
x0 = [x0;zeros(N,1)];
nx = length(x0); % # of states
nu = 2; % # of inputs for each region at each time step
nv = 2; % for SCC computaion: eimission and consumption

%% Try a guess
% Set correct dimensions for x,u,v
x_guess = ones(nx, T+1);
u_guess = 0.5*ones(nu*N,T);
v_guess = ones(nv*N,T);

for t = 1:T
    if t==1
        x_guess(:,1) = x0(:);
    end
    [ft, ht] = test_rice_dynamics(x_guess(:,t),u_guess(:,t),t,Params);
    x_guess(:,t+1) = ft;
    v_guess(:, t) = ht;
end

xuv_guess = [x_guess(:);u_guess(:);v_guess(:)];