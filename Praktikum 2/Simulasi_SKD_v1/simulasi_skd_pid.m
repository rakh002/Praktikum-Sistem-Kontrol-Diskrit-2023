clc, clear, warning off


%% sistem kontinu
% nilai awal
t = 0 ;
y = 0 ;
dydt = 0;
u = 1;

gain = 0.512;
tau = 0.132;
tdelay = 0.022; %second

ts = 0.0001; %second
timeend = 0.5;

% zoh
ts_zoh = 0.01;

set_poin = 10;

% kp_dis = 1.2*tau/gain/tdelay;
% ti_dis = 2*tdelay;
% td_dis = 0.5*tdelay;
% ki = kp_dis/ti_dis;
% kd = kp_dis*td_dis;

kp_dis = 13.5051;
ti_dis = 0.0456; %second
td_dis = 0.0011;

t_data = [];
y_data = [];
u_data = [];
dydt_data = [];

t_dis = [];
y_dis = [];
u_dis = [];
dydt_dis = [];

for i=0:ts:timeend
    [t_now,y_now,u_now,dydt_now] = sistem(t,ts,y,u,gain,tau,tdelay);
    
    [t_zoh,y_zoh,dydt_zoh,zoh_flag] = zoh_forward(ts_zoh,t,y,dydt);

    if zoh_flag
        u = pid_diskrit(y_zoh,set_poin,kp_dis,ti_dis,td_dis,ts_zoh);
        
        t_dis(end+1) = t_zoh;
        y_dis(end+1) = y_zoh;
        u_dis(end+1) = u;
        dydt_dis(end+1) = dydt_zoh;

    end
    
    t_data(end+1) = t;
    y_data(end+1) = y;
    u_data(end+1) = u_now;
    dydt_data(end+1) = dydt;

    t = t_now;
    dydt =t_now;
    y = y_now;
end

subplot(3,1,1)
plot(t_data,y_data)
line([t_data(1) t_data(end)],[set_poin set_poin],'Color','r','LineStyle','--')
legend('sistem kontinu','set poin')

subplot(3,1,2)
stairs(t_dis,y_dis)
line([t_data(1) t_data(end)],[set_poin set_poin],'Color','r','LineStyle','--')
legend('sistem diskrit','set poin')

subplot(3,1,3)
stairs(t_dis,u_dis)
hold on
plot(t_data,u_data,'--r')
hold off
legend('mv ideal','mv terimplementasi')






