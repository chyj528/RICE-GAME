[r,c] = size(U_br(:,:,end));
N = r/2;
T = c;
% N = 12;
% T = 40;
Params = specify_paramaters(N,T); 
% initial condition T_AT, T_LO, M_AT, M_UP, M_LO, K_i
x0 = Params.x0; % dimension: 5+N (17)
% add social welfare J to states
x0 = [x0;zeros(N,1)]; % dimension: 5+2*N (29)

nx = length(x0); % # of states
nu = 2;

%% Try a guess

% Set correct dimensions for x,u (now:only u_i is a variable)
x_guess = ones(nx, T+1);
u_guess = U_br(:,:,end); % for u_i = [s_i mu_i]
%u_guess = u_opt(:,1:T);
%u_guess(1:N,:) = ones(N,T);


% try one u 

for t = 1:T
    if t==1
        x_guess(:,1) = x0(:);
    end
    [ft, ht] = test_rice_dynamics(x_guess(:,t),u_guess(:,t),t,Params);
    x_guess(:,t+1) = ft;
    v_guess(:, t) = ht;
end
x_br_opt = x_guess
plot(x_guess(1,:))