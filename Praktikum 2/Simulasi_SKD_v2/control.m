function y = control(set_poin,feedback,kp,ti,td,ts_zoh)
    persistent acc_error
    persistent last_error
    
    if isempty(acc_error)
        acc_error = 0;
        last_error = 0;
    end

    error = set_poin - feedback;
    % acc_error = acc_error + error*ts_zoh; %zoh
    acc_error = acc_error + (error+last_error)*ts_zoh/2; %tustin
    dedt = (error - last_error)/ts_zoh;
    last_error = error;

    y = kp*(error + td*dedt + (1/ti)*acc_error);
end