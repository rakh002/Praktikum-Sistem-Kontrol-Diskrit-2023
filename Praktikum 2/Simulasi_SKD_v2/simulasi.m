
clc, clear control delay a2d, warning off

%% variable (unit) [additional information]
% 
% > simulation time
% t     : time (second or millisecond)
% tr    : time resolution (second or millisecond) [simulation
% time resolution]
% te    : time end (second or millisecond) [simulation duration]
% > flow variable
% v     : velocity (percent)
% vm    : velocity measured (percent)
% x     : position (percent)
% xm    : position measured (percent)
% sp    : set poin (percent)
% u     : input (percent) [for open loop]
% mv    : manipulated variable (percent)
% imv   : implemented mv (percent)
% dmv   : delayed mv (percent)
% sistem parameter
% tdlay : time delay (second or millisecond) [FOPDT dead time]
% gain  : gain () [FOP gain]
% tau   : time constant (second or millisecond [FOP time constant]
% control parameter
% ts    : time sampling (second or millisecond)
% kp    : proporsional gain ()
% ti    : time integral (second or millisecond)
% td    : time derivative (second or millisecond)


%% nilai awal
tr = 1;
te = 1000;
v = 0;
vm = 0;
imv = 0;
sp = 50;
u = sp;
tdlay = 37;
gain = 0.839;
tau = 54;
ts = 10;

% P - Ziegler Nichols
%kp = 1*tau/gain/tdlay;
%ti = 999999999999999999999999999999999999;
%td = 0;

% PI - Ziegler Nichols
%kp = 0.9*tau/gain/tdlay;
%ti = tdlay/0.3;
%td = 0;

% PID - Ziegler Nichols
%kp = 1.2*tau/gain/tdlay;
%ti = 2*tdlay;
%td = 0.5*tdlay;

% P - Cohen Coon
%kp = tau*(1+tdlay/(3*tau))/gain/tdlay;
%ti = 999999999999999999999999999999999999;
%td = 0;

% PI - Cohen Coon
%kp = tau*(0.9+tdlay/(12*tau))/gain/tdlay; 
%ti = tdlay*(30+3*(tdlay/tau))/(9+20*(tdlay/tau));
%td = 0;
 
% PID - Cohen Coon
%kp = tau*(4/3+tdlay/(4*tau))/gain/tdlay; 
%ti = tdlay*(32+6*(tdlay/tau))/(13+8*(tdlay/tau));
%td = tdlay*4/(11+2*(tdlay/tau));

sampling = true;
t_dis_ol = [];
iu_dis_ol = [];
vm_dis_ol = [];
xm_dis_ol = [];

t_con_ol = [];
du_con_ol = [];
v_con_ol = [];
x_con_ol = [];
%% open loop
for t=0:tr:te
    
    if sampling
        iu = d2a(u);
        t_dis_ol(end+1) = t;
        iu_dis_ol(end+1) = iu;
        vm_dis_ol(end+1) = vm;
        xm_dis_ol(end+1) = xm;
    end

    du = delay(iu,t,tr,tdlay);
    [x, v]= integrate(tr,x,v,du,gain,tau);
    [vm,sampling] = a2d(t,ts,v);
    [xm, sampling] = a2d(t,ts,x);

    t_con_ol(end+1) = t;
    du_con_ol(end+1) = du;
    v_con_ol(end+1) = v;
    x_con_ol(end+1) = x;
end

clear delay a2d
% Define time parameters
t_start = 0;
t_step = tr;
t_end = te;

% Initialize arrays to store data
t_dis_cl = [];
mv_dis_cl = [];
imv_dis_cl = [];
vm_dis_cl = [];
xm_dis_cl = [];
t_con_cl = [];
dmv_con_cl = [];
v_con_cl = [];
x_con_cl = [];

%% closed loop
for t=0:tr:te
    if sampling
        mv = control(sp,vm,kp,ti,td,ts);
        imv = d2a(mv);
        t_dis_cl(end+1) = t;
        mv_dis_cl(end+1) = mv;
        imv_dis_cl(end+1) = imv;
        vm_dis_cl(end+1) = vm;
        xm_dis_ol(end+1) = xm;
    end

    dmv = delay(imv,t,tr,tdlay);
    [x, v]= integrate(tr,x,v,dmv,gain,tau);
    [vm,sampling] = a2d(t,ts,v);
    [xm, sampling] = a2d(t,ts,x);

    t_con_cl(end+1) = t;
    dmv_con_cl(end+1) = dmv;
    v_con_cl(end+1) = v;
    x_con_cl(end+1) = x;
    
end

%% Grafik
figure(2)
hold off
plot([t_con_ol(1) t_con_ol(end)],[u u],'r-.')
hold on
plot(t_con_ol,x_con_ol,'b--')
plot(t_con_cl,x_con_cl,'g--')
stairs(t_dis_ol,xm_dis_ol,'b-')
stairs(t_dis_cl,xm_dis_cl,'g-')
legend('set point/input','open loop','closed loop')

figure(3)
hold off
plot([t_con_ol(1) t_con_ol(end)],[sp sp],'r-.')
hold on
plot(t_con_cl,x_con_cl,'g--')
stairs(t_dis_cl,xm_dis_cl,'g-')
stairs(t_dis_cl,imv_dis_cl,'m-')
plot(t_con_cl,dmv_con_cl,'c--')
legend('set point','output','output measured','input','delayed input')

figure(4)
hold off
stairs(t_dis_cl(2:end),mv_dis_cl(2:end),'k-.')
hold on
stairs(t_dis_cl,imv_dis_cl,'m-')
plot(t_con_cl,dmv_con_cl,'c--')
legend('manipulated variable','implemented mv','delayed mv')