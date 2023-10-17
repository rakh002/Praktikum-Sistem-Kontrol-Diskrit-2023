function [y,flag] = a2d(t,ts_a2d,u)
    persistent t_a2d
    persistent y_hold

    flag = false;
    
    if isempty(t_a2d)
        t_a2d = t + ts_a2d;
        y_hold = u;
        flag = true;
    end

    if t >= t_a2d
        t_a2d = t_a2d + ts_a2d;
        y_hold = u;
        flag = true;
    end

    y = y_hold;
end