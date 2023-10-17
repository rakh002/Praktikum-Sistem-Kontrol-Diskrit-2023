function y = first_order_process(ts,ypast,u,gain,tau)
    dydt = (u*gain - ypast) / tau;
    y = ypast + (dydt * ts);
end