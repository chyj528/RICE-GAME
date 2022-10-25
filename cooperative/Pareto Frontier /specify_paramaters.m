% RICE Dynamic Game
% BaseYear 2020
% Stepsize 5
function Params = specify_paramaters(N,T)
%% Exogenous Variables (for sure)
% 2020, 2025, 2030, ...
Params = load('exogenous_states_long.mat');

%% Regions and Time Steps
Params.N = N;
Params.regions = {'US','EU','Japan','Russia','Eurasia','China','India','MidEast','Africa','LatAm','OHI','OthAsia'};
Params.T = T;
Params.BaseYear = 2020;
Params.Stepsize = 5;
Params.EndYear = 2020 + Params.Stepsize * (Params.T -1);
Params.years = Params.BaseYear:Params.Stepsize:Params.EndYear;

%% Initial conditions T_AT, T_LO, M_AT, M_UP, M_LO, K_1, ..., K_N
% Set initial conditions in year 2020 (has been set the initial conditions in 2020)
Params.x0 = [1.15; 0.05;979; 485; 1741;
    36.5866;37.1065;9.6045;4.9639;2.6137;28.4730;11.9416;14.4644;6.8100;17.4942;11.6094;11.0887];

%% Paramaters for Carbon Dynamics (for sure)
Params.zeta_M = [0.88,0.196,0;0.12,0.797,0.001465116279070;0,0.007,0.998534883720930];
Params.xi_M =  [5*0.272727272727273; 0; 0];

%% Paramaters for Temperature Dynamics (for sure)
Params.M_AT_Base = 588;        
Params.eta = 3.6813; 
Params.phi_T = [0.871810629032258,0.008844;0.025,0.975];
Params.xi_T = [0.1005; 0];

%% Paramaters for Damage Functions (no change for sure)
Params.a1 = 0.01*[0;0;0;0;0;0.079;0.439;0.278;0.341;0.061;0;0.176];
Params.a2 = 0.01*[0.141;0.159;0.162;0.115;0.130;0.126;0.169;0.159;0.198;0.135;0.156;0.173];
Params.a3 = 2*ones(12,1);

%% Paramaters for Economy
% Welfare function (for sure)
Params.rho = 0.015*ones(12,1);
Params.alpha = 1.45*ones(12,1);

% Abatement: backprice starting from 2020 (for sure)
Params.pb = [1051;1635;1635;701;701;817;1284;1167;1284;1518;1284;1401];
Params.theta2 = 2.6*ones(12,1);
Params.deltapb = 0.025*ones(12,1);
% Calculate backprice
Params.backprice = zeros(N,Params.T);
Params.backprice(:,1) = Params.pb;
for t = 2:Params.T
    Params.backprice(:,t) = Params.backprice(:,t-1).*(1-Params.deltapb);
end
% Calculate theta1
for i = 1:Params.N
    for t = 1:Params.T
        Params.theta1(i,t) = Params.sigma(i,t) * Params.backprice(i,t)/(1000*Params.theta2(i));
    end
end

% Gross output and Capital (for sure)
Params.gamma = 0.3*ones(12,1);
Params.deltaK = 0.1*ones(12,1);
Params.scale1 = [0.201;0.103;0.130;0.030;0.008;0.004;0.002;0.015599;0.001300;0.015678;0.118744; 0.00308 ];
Params.scale2 = [-3520.132;-2063.156;-554.972;-90.960;-10.465;-49.389;28.627;-256.711;28.239;-238.927;-701.063; 11.80 ];


