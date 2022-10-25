function [f, h] = rice_dynamics(x,u,v,t,Params)
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

%% CasADi settings
addpath('/Users/chyj528/Documents/MATLAB/casadi/casadi-osx-matlabR2015a-v3.5.5')
import casadi.*

abatement      = SX.sym('abatement', N,1);
damage     = SX.sym('damage', N,1);
Y     = SX.sym('Y', N,1);
E_ind     = SX.sym('E_ind', N,1);

E_rhs = SX.sym('E_rhs', N,1);

Q     = SX.sym('Q', N,1);
I     = SX.sym('I', N,1);

C_rhs     = SX.sym('C_rhs', N,1);

T_next = SX.sym('T_next', N,1);
M_next = SX.sym('M_next', N,1);
K_next = SX.sym('K_next', N,1);
J_next = SX.sym('J_next', N,1);

E = SX.sym('E',N, 1);
C = SX.sym('C', N,1);

for i = 1:N
    E(i)   = v(i); % Emission
    C(i) = v(i+N); % Consumption
end

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


M_next = zeta_M * M + xi_M * sum(E);

Radiative_Forcing = eta*log(M_AT/M_AT_Base)/log(2) + F_EX(t+1);

T_next = phi_T * T + xi_T * Radiative_Forcing;

for i = 1:N
    K_next(i) = (1 - deltaK(i))^5 * K(i) + 5 * I(i);
    J_next(i) = J(i)  - L(i,t)*(((1000/L(i,t)*C(i))^(1-alpha(i))-1)/(1-alpha(i)))/((1+rho(i))^(5 * (t-1)));
end

    
f = [T_next;M_next;K_next;J_next;];

h = [E_rhs;C_rhs;]; 





