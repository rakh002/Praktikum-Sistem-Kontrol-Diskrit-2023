#define PID_SUM_MAX 10

//Parameter PID
////ZN
//PID
//float pid_kp = 2.108919;
//float pid_ki = pid_kp/(0.072907*1000);
//float pid_kd = pid_kp*(0.018227*1000);
////PI
//float pid_kp = 1.58169;
//float pid_ki = pid_kp/(0.01203*1000);
//float pid_kd = 0;
////P
//float pid_kp = 1.757433;
//float pid_ki = 0;
//float pid_kd = 0;
////=================//
////CC
////PID
//float pid_kp = 2.641281;
//float pid_ki = pid_kp/(0.071357*1000);
//float pid_kd = pid_kp*(0.011800389*1000);
////PI
//float pid_kp = 1.681035;
//float pid_ki = pid_kp/(0.051748*1000);
//float pid_kd = 0;
////P
float pid_kp = 2.154816;
float pid_ki = 0;
float pid_kd = 0;
//===============//
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
