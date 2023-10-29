function x = position(ts,v,xpast)
    conversion_factor = 0.001;

    dydt = v*conversion_factor; %konversi kecepatan
    x = xpast + dydt*ts;
    if x > 100
        x = x-100;
    end
end