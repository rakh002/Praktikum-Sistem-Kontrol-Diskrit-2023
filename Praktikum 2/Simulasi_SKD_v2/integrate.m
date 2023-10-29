function [x,v] = integrate(ts,xpast,vpast,u,gain,tau)
    dydt = (u*gain - vpast) / tau;
    v = vpast + (dydt * ts);
    x = xpast + v*ts + 0.5*(dydt)*ts^2;
end