
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
kp = 1.2*tau/gain/tdlay;
ti = 2*tdlay;
td = 0.5*tdlay;
ki = kp/ti;
kd = kp*td;

sampling = true;
t_dis_ol = [];
iu_dis_ol = [];
vm_dis_ol = [];

t_con_ol = [];
du_con_ol = [];
v_con_ol = [];

%% open loop
for t=0:tr:te
    if sampling
        iu = d2a(u);
        t_dis_ol(end+1) = t;
        iu_dis_ol(end+1) = iu;
        vm_dis_ol(end+1) = vm;
    end

    du = delay(iu,t,tr,tdlay);
    v = first_order_process(tr,v,du,gain,tau);
    [vm,sampling] = a2d(t,ts,v);

    t_con_ol(end+1) = t;
    du_con_ol(end+1) = du;
    v_con_ol(end+1) = v;
end

clear delay a2d
v = 0;
vm = 0;
sampling = true;
t_dis_cl = [];
mv_dis_cl = [];
imv_dis_cl = [];
vm_dis_cl = [];

t_con_cl = [];
dmv_con_cl = [];
v_con_cl = [];

%% closed loop
for t=0:tr:te
    if sampling
        mv = control(sp,vm,kp,ti,td,ts);
        imv = d2a(mv);
        t_dis_cl(end+1) = t;
        mv_dis_cl(end+1) = mv;
        imv_dis_cl(end+1) = imv;
        vm_dis_cl(end+1) = vm;
    end

    dmv = delay(imv,t,tr,tdlay);
    v = first_order_process(tr,v,dmv,gain,tau);
    [vm,sampling] = a2d(t,ts,v);

    t_con_cl(end+1) = t;
    dmv_con_cl(end+1) = dmv;
    v_con_cl(end+1) = v;
end

%% Grafik
figure(1)
hold off
plot([t_con_ol(1) t_con_ol(end)],[u u],'r-.')
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
plot(t_con_cl,v_con_cl,'g--')
stairs(t_dis_cl,vm_dis_cl,'g-')
stairs(t_dis_cl,imv_dis_cl,'m-')
plot(t_con_cl,dmv_con_cl,'c--')
legend('set point','output','output measured','input','delayed input')

figure(3)
hold off
stairs(t_dis_cl(2:end),mv_dis_cl(2:end),'k-.')
hold on
stairs(t_dis_cl,imv_dis_cl,'m-')
plot(t_con_cl,dmv_con_cl,'c--')
legend('manipulated variable','implemented mv','delayed mv')