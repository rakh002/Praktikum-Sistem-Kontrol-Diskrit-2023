function y = delay(u,t,ts,td)
    persistent delayed

    if isempty(delayed)
        delayed = [];
        for i=0:ts:td
            delayed(end+1) = 0;
        end
    end

    delayed(1:end-1) = delayed(2:end);
    delayed(end) = u;

    y = delayed(1);
end