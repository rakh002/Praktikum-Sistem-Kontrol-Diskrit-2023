int serial(int SerialRead) {
  if (Serial.available() > 0) {
    Serial.println('\t');
    String StringSerial = Serial.readStringUntil('\n');
    SerialRead = StringSerial.toInt();
    if (SerialRead > 100) return 100;
    else if (SerialRead < -100) return -100;
  }
  return SerialRead;
}
