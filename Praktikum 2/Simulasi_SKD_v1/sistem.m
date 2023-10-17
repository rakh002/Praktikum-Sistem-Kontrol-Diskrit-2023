function [t,y,u,dydt] = sistem(t,ts,ypast,u,gain,tau,td)
    
    if u >= 100
        u = 100;
    elseif u <= -100
        u = -100;
    end

    dydt = (u*gain - ypast) / tau;
    y = ypast + (dydt * ts);
    if t<td
        y = 0;
    end
    t = t + ts;
end