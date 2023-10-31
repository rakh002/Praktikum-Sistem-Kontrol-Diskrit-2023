

void setup() {
  general_setup();
  sensor_setup();
  actuator_setup();
  print_header();
  StartTime = millis();
  LastTimeSampling = StartTime;
  LastTimeInput = StartTime;
  InputSerial = 0;
}

void loop() {
  // put your main code here, to run repeatedly:
  
  Time = millis();
  //InputSerial = serial(InputSerial);
  
  if (Time - LastTimeInput >= WaktuInput) {

    LastTimeInput = Time;
    Motor = run_motor(0);
    delay(1000);
    InputSerial = InputSerial + 5;
    
  }
  
  if (Time - LastTimeSampling >= TimeSampling) {
    DeltaTime = Time - LastTimeSampling;
    LastTimeSampling = Time;
    InputCompensated = deadzoneCompensator(InputSerial);
    Motor = run_motor((float) InputCompensated);
    
    Tacho1 = analogRead(PinTachometer);
    Tacho2 = sample_velocity_percentage();
    Tacho3 = smooth_velocity_percentage();
    
    Serial.print(InputSerial);
    Serial.print("\t");
    Serial.print(Tacho2);
    Serial.print("\t");
    Serial.println(Tacho3);
  }
}

void print_header() {
  Serial.println("Input\tKec 2\tKec 3");
}
