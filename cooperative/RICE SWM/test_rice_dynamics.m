function [f, h] = test_rice_dynamics(x,u,t,Params)
%% Unpack parameters
N = Params.N;

% Temperature Dynamics
phi_T = Params.phi_T;
xi_T = Params.xi_T;

eta = Params.eta;
M_AT_Base = Params.M_AT_Base;

zeta_M = Params.zeta_M;
xi_M = Params.xi_M;
 
% Welfare function
rho = Params.rho;
alpha = Params.alpha; 

% Gross output and Capital
gamma = Params.gamma; 
deltaK = Params.deltaK;

% Damages
a1 = Params.a1; 
a2 = Params.a2; 
a3 = Params.a3; 

% Abatement
pb = Params.pb; 
theta2 = Params.theta2; 
deltapb = Params.deltapb;

% Exogenous Variables
A = Params.A;    % N*T
L = Params.L;    % N*T
sigma = Params.sigma;    % N*T
E_land = Params.E_land;  % N*T
theta1 = Params.theta1;
F_EX = Params.F_EX;      % T*1


%% States
T_AT = x(1); 
T_LO = x(2);
T = [T_AT; T_LO];

M_AT = x(3);
M_UP = x(4);
M_LO = x(5);

M = [M_AT; M_UP; M_LO];

K = x(6:5+N);   % x(6) - x(17)

J = x(6+N:5+2*N);   % x(18) - x(29)

%% Control decisions
mu = u(1:N);    % Mitigation rate u(1) - u(12)
s = u(N+1:2*N); % Saving rate u(13) - u(24)

%% Dynamics
% Economy
for i = 1:N
    % Abatement cost as fraction of output
    abatement(i) = theta1(i,t) * (mu(i)^theta2(i));
    % Climate Damage
    damage(i) = 1 - a1(i) * T_AT  - a2(i) * (T_AT^a3(i));
    % Gross output
    Y(i) = A(i,t)*(K(i)^gamma(i))*((L(i,t)/1000)^(1-gamma(i))) ;
    % Industrial emissions
    E_ind(i) = sigma(i,t)*(1-mu(i))*Y(i);
    % E rhs
    E_rhs(i) = E_ind(i) + E_land(i,t);
    % Net output net of abatement cost and climate damage
    Q(i) = damage(i)*(1 - abatement(i))*Y(i);
    % Investment
    I(i) = s(i)*Q(i);
    % Consumption rhs
    C_rhs(i) = (1-s(i))*Q(i); 
end


M_next = zeta_M * M + xi_M * sum(E_rhs);

Radiative_Forcing = eta*log(M_next(1)/M_AT_Base)/log(2) + F_EX(t+1);

T_next = phi_T * T + xi_T * Radiative_Forcing;

for i = 1:N
    K_next(i) = (1 - deltaK(i))^10 * K(i) + 10 * I(i);
    J_next(i) = J(i)  - L(i,t)*(((1000/L(i,t)*C_rhs(i))^(1-alpha(i))-1)/(1-alpha(i)))/((1+rho(i))^(10*(t-1)));
end

    
f = [T_next;M_next;K_next';J_next';];

h = [E_rhs';C_rhs';]; 





