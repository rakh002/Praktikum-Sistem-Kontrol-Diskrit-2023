function [t_zoh,y_zoh,dydt_zoh,zoh_flag] = zoh_forward(ts_zoh,t,y,dydt)
    persistent t_update
    persistent y_hold
    persistent dydt_hold

    t_zoh = t;
    y_zoh = 0;
    dydt_zoh = 0;
    zoh_flag = false;

    if t == 0
        t_update = t + ts_zoh;
        y_hold = y;
        dydt_hold = dydt;
        y_zoh = y_hold;
        dydt_zoh = dydt_hold;
    elseif t <= t_update
        y_zoh = y_hold;
        dydt_zoh = dydt_hold;
    elseif t >= t_update
        y_hold = y;
        dydt_hold = dydt;
        y_zoh = y_hold;
        dydt_zoh = dydt_hold;
        t_update = t_update + ts_zoh;
        zoh_flag = true;
    end
end