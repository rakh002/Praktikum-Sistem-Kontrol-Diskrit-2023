#define PID_SUM_MAX 10

// Parameter PID
float pid_kp = 1.2;
float pid_ki = pid_kp/(0.0035*1000);
float pid_kd = pid_kp*(0*1000);

float pid_error;
float pid_sum;
float pid_lasterror;

float pid_p;
float pid_i;
float pid_d;

void pidSetup() {
  pid_sum = 0;
  pid_error = 0;
  pid_lasterror = 0;
  pid_p = 0;
  pid_i = 0;
  pid_d = 0;
}

float pidControl(float sv, float pv) {
  pid_error = sv - pv;
  pid_p = pid_kp*pid_error;  
  pid_sum += pid_error;
  pid_i = pid_ki*pid_sum;
  pid_d = pid_kd*(pid_error - pid_lasterror)/(TimeSampling);

  pid_lasterror = pid_error;
  return (pid_p) + (pid_i) + (pid_d);
}
