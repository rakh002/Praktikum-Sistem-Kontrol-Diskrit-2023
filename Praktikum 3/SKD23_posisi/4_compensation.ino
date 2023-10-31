float deadzoneCompensator(float inputSerial){
  float inputCompensated;
  if(inputSerial < 0){
    inputCompensated = (minimumTerdeteksiNegatif)+((inputSerial-(0))/((-100)-0))*((-100)-(minimumTerdeteksiNegatif));
    
  }
  else if (inputSerial > 0){
    inputCompensated = (minimumTerdeteksiPositif)+((inputSerial-(0))/((100)-0))*((100)-(minimumTerdeteksiPositif));
  }
  else if (inputSerial == 0){
    inputCompensated = 0;
  }
  return inputCompensated;
}
