

void sensor_setup() {
  pinMode(PinTachometer, INPUT);
  pinMode(PinPotensiometer, INPUT);
}

float sample_velocity_percentage() {
  return (float) analogRead(PinTachometer) * 100 / MaxTachometer;
}

float sample_position_percentage() {
  return (float) analogRead(PinPotensiometer) * 100 / 1023;
}

float smooth_pin(int Pin, byte SizeRead) {
  unsigned int TotalRead = 0;
  for (byte i = 0; i < SizeRead; i++) {
    TotalRead += analogRead(Pin);
  }
  return (float) TotalRead / SizeRead;
}

float smooth_velocity_percentage() {
  return smooth_pin(PinTachometer, samplingWindow) * 100 / MaxTachometer;
}

float smooth_position_percentage() {
  return smooth_pin(PinPotensiometer, samplingWindow) * 100 / 1023;
}
