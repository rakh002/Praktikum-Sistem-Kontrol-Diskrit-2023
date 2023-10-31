
clc, clear control delay a2d, warning on

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
% xm    : position measured (precent)
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
x = 0;
xm = 0;
sp = 75;
u = sp;
tdlay = 37;
gain = 0.8388;
tau = 54;
ts = 10;
% kp = 2;
% ti = 10000000000000000000000000000000000000000000000000000;
% td = 0;
% ki = kp/ti;
% kd = kp*td;

% Controller Design : Ziegler Nichols FOPDT
Type = 2; % 1:P, 2:PI, 3:PID, otherwise:Your Parameter Control
switch Type
    case 1
        % Proportional Controller
        kp = tau/gain/tdlay;
        ti = 10000000000000000000000000000000000;
        td = 0;
        ki = 0;
        kd = kp*td;
    case 2
        % Proportional–Integral Controller
        kp = 0.9*tau/gain/tdlay
        ti = tdlay/0.3
        ki = kp/ti
        td = 0;
        kd = 0;
    case 3
        % Proportional–Integral–Derivative Controller
        kp = 1.2*tau/gain/tdlay
        ti = 2*tdlay
        td = 0.5*tdlay
        ki = kp/ti
        kd = kp*td
    otherwise
        % Custom Control Parameter
        kp = 1;
        ti = 1000000000000000000;
        ki = kp/ti;
        td = 0.1;
        ki = 0;
        kd = 0.1;
end

sampling = true;
t_dis_ol = [];
iu_dis_ol = [];
vm_dis_ol = [];
xm_dis_ol = [];

t_con_ol = [];
du_con_ol = [];
v_con_ol = [];
x_con_ol = [];

%% open loop - step response
for t=0:tr:te
    
    if sampling
        iu = d2a(u);
        t_dis_ol(end+1) = t;
        iu_dis_ol(end+1) = iu;
        vm_dis_ol(end+1) = vm;
        xm_dis_ol(end+1) = xm;
    end

    du = delay(iu,t,tr,tdlay);
    v = first_order_process(tr,v,du,gain,tau);
    x = position(ts,v,x);
    [vm,sampling] = a2d(t,ts,v);
    xm = x;

    t_con_ol(end+1) = t;
    du_con_ol(end+1) = du;
    v_con_ol(end+1) = v;
    x_con_ol(end+1) = x;
end

clear delay a2d
x=0;
xm=0;
v = 0;
vm = 0;
sampling = true;
t_dis_impulse = [];
iu_dis_impulse = [];
vm_dis_impulse = [];
xm_dis_impulse = [];

t_con_impulse = [];
du_con_impulse = [];
v_con_impulse = [];
x_con_impulse = [];

%% open loop - impulse response

for t=0:tr:te
    
    if t<10
        u = sp;
    else
        u = 0;
    end

    if sampling
        iu = d2a(u);
        t_dis_impulse(end+1) = t;
        iu_dis_impulse(end+1) = iu;
        vm_dis_impulse(end+1) = vm;
        xm_dis_impulse(end+1) = xm;
    end

    du = delay(iu,t,tr,tdlay);
    v = first_order_process(tr,v,du,gain,tau);
    x = position(ts,v,x);
    [vm,sampling] = a2d(t,ts,v);
    xm = x;

    t_con_impulse(end+1) = t;
    du_con_impulse(end+1) = du;
    v_con_impulse(end+1) = v;
    x_con_impulse(end+1) = x;
end

clear delay a2d
u = sp; %set kembali nilai u sebagai step untuk cl
x=0;
xm=0;
v = 0;
vm = 0;
sampling = true;
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
        mv = control(sp,xm,kp,ti,td,ts);
        imv = d2a(mv);
        t_dis_cl(end+1) = t;
        mv_dis_cl(end+1) = mv;
        imv_dis_cl(end+1) = imv;
        vm_dis_cl(end+1) = vm;
        xm_dis_cl(end+1) = xm;
    end

    dmv = delay(imv,t,tr,tdlay);
    v = first_order_process(tr,v,dmv,gain,tau);
    x = position(ts,v,x);
    [vm,sampling] = a2d(t,ts,v);
    xm = x;

    t_con_cl(end+1) = t;
    dmv_con_cl(end+1) = dmv;
    v_con_cl(end+1) = v;
    x_con_cl(end+1) = x;
end

%% Grafik
figure(1)
hold off
plot([t_con_ol(1) t_con_ol(end)],[sp sp],'r-.')
hold on
plot(t_con_ol,v_con_ol,'b--')
plot(t_con_cl,v_con_cl,'g--')
stairs(t_dis_ol,vm_dis_ol,'b-')
stairs(t_dis_cl,vm_dis_cl,'g-')
legend('set point/input','open loop','closed loop')

figure(2)
hold off
plot([t_con_ol(1) t_con_ol(end)],[sp sp],'r-.')
hold on
plot(t_con_ol,v_con_impulse,'b--')
stairs(t_dis_ol,vm_dis_impulse,'b-')
legend('set point/input','open loop')

figure(3)
hold off
plot([t_con_ol(1) t_con_ol(end)],[sp sp],'r-.')
hold on
plot(t_con_ol,x_con_ol,'b--')
plot(t_con_cl,x_con_cl,'g--')
stairs(t_dis_ol,xm_dis_ol,'b-')
stairs(t_dis_cl,xm_dis_cl,'g-')
legend('set point/input','open loop','closed loop')

figure(4)
hold off
plot([t_con_ol(1) t_con_ol(end)],[sp sp],'r-.')
hold on
plot(t_con_ol,x_con_impulse,'b--')
stairs(t_dis_ol,xm_dis_impulse,'b-')
legend('set point/input','open loop')

figure(5)
hold off
plot([t_con_ol(1) t_con_ol(end)],[sp sp],'r-.')
hold on
plot(t_con_cl,v_con_cl,'g--')
stairs(t_dis_cl,vm_dis_cl,'g-')
stairs(t_dis_cl,imv_dis_cl,'m-')
plot(t_con_cl,dmv_con_cl,'c--')
legend('set point','output','output measured','input','delayed input')

figure(6)
hold off
stairs(t_dis_cl(2:end),mv_dis_cl(2:end),'k-.')
hold on
stairs(t_dis_cl,imv_dis_cl,'m-')
plot(t_con_cl,dmv_con_cl,'c--')
legend('manipulated variable','implemented mv','delayed mv')