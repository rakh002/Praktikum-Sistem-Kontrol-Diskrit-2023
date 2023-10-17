function y = d2a(u)
    if u >= 100
        y = 100;
    elseif u <= -100
        y = -100;
    else
        y = u;
    end
end