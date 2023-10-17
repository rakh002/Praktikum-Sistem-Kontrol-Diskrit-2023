clc, clear, warning off

% Identifikasi Sistem
Gain = 0.7;
Tau = 0.2;
DeadTime = 0.02; % can't be zero

% Masukan Simulasi Open dan Close Loop
SetPoint = 75;
InputOpenLoop = SetPoint;

% Waktu
K = 5; % Faktor pengali untuk memperpanjang atau memperpendek durasi simulasi
if Tau>DeadTime
    FinalTime = K*Tau;
    SimulationSampling = DeadTime/5;
else
    FinalTime = K*DeadTime;
    SimulationSampling = Tau/5;
end
df = round(FinalTime/SimulationSampling);
if mod(FinalTime,SimulationSampling) ~= 0
    FinalTime = df*SimulationSampling;
end
dlay = ceil(DeadTime/SimulationSampling);
t(1:df+1) = 0:SimulationSampling:FinalTime;

% Kontrol
% Controller Design : Ziegler Nichols FOPDT
Type = 3; % 1:P, 2:PI, 3:PID, otherwise:Your Parameter Control
switch Type
    case 1
        % Proportional Controller
        Kp = Tau/Gain/DeadTime;
        Ki = 0;
        Kd = 0;
    case 2
        % Proportional–Integral Controller
        Kp = 0.9*Tau/Gain/DeadTime;
        Ti = 3*DeadTime;
        Ki = Kp/Ti;
        Kd = 0;
    case 3
        % Proportional–Integral–Derivative Controller
        Kp = 1.2*Tau/Gain/DeadTime;
        Ti = 2*DeadTime;
        Td = 0.5*DeadTime;
        Ki = Kp/Ti;
        Kd = Kp*Td;
    otherwise
        % Custom Control Parameter
        Kp = 0;
        Ki = 0;
        Kd = 0;
end

% Error
Error = 0;
LastError = 0;
RateError = 0;
AccumulationError(1:df-dlay) = 0;
ManipulatedVariable(1:df-dlay) = 0;

% Simulasi
Velocity1(1:df+1) = 0;
Velocity2(1:df+1) = 0;
Final = 0;

% Open Loop
for i = dlay+1:df
    Final = Gain*InputOpenLoop; 
    dv1dt = (Final - Velocity1(i))/Tau;
    Velocity1(i+1)  = Velocity1(i) + dv1dt*SimulationSampling;
end

% Closed Loop
for i = 1:df-dlay
    Error = SetPoint - Velocity2(i);
    if i == 1
        %AccumulationError(i) = Error * TimeSampling; % ZOH
        AccumulationError(i) = (Error + LastError)/2 * SimulationSampling; % Tustin
    else
        %AccumulationError(i) = AccumulationError(i-1) + Error * TimeSampling; % ZOH
        AccumulationError(i) = AccumulationError(i-1) + (Error + LastError)/2 * SimulationSampling; % Tustin
    end
    RateError = (Error - LastError)/SimulationSampling;
    LastError = Error;

    Mp = Kp * Error;
    Mi = Ki * AccumulationError(i);
    Md = Kd * RateError;
       
    ManipulatedVariable(i) = Mp + Mi + Md;
    Final = Gain*ManipulatedVariable(i);
    dv2dt = (Final - Velocity2(i+dlay)) / Tau;
    Velocity2(i+dlay+1) = Velocity2(i+dlay) + (dv2dt * SimulationSampling);
end

figure(1)
axis([0 FinalTime min([Velocity1 Velocity2]) max([Velocity1 Velocity2])]);
stairs(t,Velocity1,'r'); hold on; %red
stairs(t,Velocity2,'b'); hold off; %blue
title(['Kecepatan pada SP = ' num2str(SetPoint) ', Kp = ' num2str(Kp) ', Ki = ' num2str(Ki) ', Kd = ' num2str(Kd) ])

figure(2)
stairs(t(1:end-dlay-1),ManipulatedVariable,'b');
title(['MV pada SP = ' num2str(SetPoint) ', Kp = ' num2str(Kp) ', Ki = ' num2str(Ki) ', Kd = ' num2str(Kd) ])

figure(3)
stairs(t(1:end-dlay-1),AccumulationError,'b');
title(['Akumulasi error pada SP = ' num2str(SetPoint) ', Kp = ' num2str(Kp) ', Ki = ' num2str(Ki) ', Kd = ' num2str(Kd) ])
