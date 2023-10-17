function u = pid_diskrit(y_zoh,set_poin,kp_dis,ti_dis,td_dis,ts_zoh)
    persistent int_error
    persistent last_error
    
    if isempty(int_error)
        int_error = 0;
        last_error = 0;
    end

    error = set_poin - y_zoh;
    % int_error = int_error + error*ts_zoh; %zoh
    int_error = int_error + (error+last_error)*ts_zoh/2; %tustin
    dedt = (error - last_error)/ts_zoh;
    last_error = error;

    u = kp_dis*(error + td_dis*dedt + (1/ti_dis)*int_error);

end