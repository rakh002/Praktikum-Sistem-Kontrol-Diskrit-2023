unsigned long Time, StartTime, LastTime;
unsigned int TimeSampling = 100, DeltaTime;
int InputSerial = 0;
float Motor = 0.0;
float Poten1, Poten2, Tacho1, Tacho2;

void setup() {
  general_setup();
  sensor_setup();
  actuator_setup();
  print_header();
  StartTime = millis();
  LastTime = StartTime;
}

void loop() {
  // put your main code here, to run repeatedly:
  InputSerial = serial(InputSerial);
  Time = millis();
  if (Time - LastTime >= TimeSampling) {
    DeltaTime = Time - LastTime;
    LastTime = Time;
    Motor = run_motor((float) InputSerial);
    Poten1 = sample_position_percentage();
    Poten2 = smooth_position_percentage();
    Tacho1 = sample_velocity_percentage();
    Tacho2 = smooth_velocity_percentage();
    Serial.print(Time - StartTime - TimeSampling);
    Serial.print("\t");
    Serial.print(DeltaTime);
    Serial.print("\t");
    Serial.print(InputSerial);
    Serial.print("\t");
    Serial.print(Motor);
    Serial.print("\t");
    Serial.print(Poten1);
    Serial.print("\t");
    Serial.print(Poten2);
    Serial.print("\t");
    Serial.print(Tacho1);
    Serial.print("\t");
    Serial.println(Tacho2);
  }
}

void print_header() {
  Serial.println("Time\tDelta\tInput\tMotor\tPos 1\tPos 2\tKec 1\tKec 2");
}
