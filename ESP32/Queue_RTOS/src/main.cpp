#include <Arduino.h>
#include <ESP32Servo.h>

QueueHandle_t angleQueue;

const int led_pin = 12;
const int servo_pin = 13;
const int pot_pin = 14; // Chân cắm biến trở (GPIO 34 là chân chỉ đọc ADC rất tốt trên ESP32)

void TaskBlinkLed(void *pvParameters){
    pinMode(led_pin, OUTPUT);

    while(1){
        digitalWrite(led_pin, HIGH);
        vTaskDelay(500 / portTICK_PERIOD_MS);
        digitalWrite(led_pin, LOW);
        vTaskDelay(500 / portTICK_PERIOD_MS);
    }
}

void TaskReadADC(void *pvParameters){
  analogReadResolution(12);
  
  // Tạo một biến lưu lại góc trước đó để so sánh
  int lastAngle = -1; 

  while(1){
    int adcValue = analogRead(pot_pin);
    int targetAngle = map(adcValue, 0, 4095, 0, 180);

    if(targetAngle < 0) targetAngle = 0;
    if(targetAngle > 180) targetAngle = 180;


    // Chỉ cập nhật góc nếu sai số lớn hơn hoặc bằng 2 độ
    if (abs(targetAngle - lastAngle) >= 2) {
      lastAngle = targetAngle; // Lưu lại góc mới
      
      Serial.printf("ADC: %d -> Goc Servo: %d\n", adcValue, targetAngle);
      xQueueSend(angleQueue, &targetAngle, 0);
    }

    vTaskDelay(50 / portTICK_PERIOD_MS);
  }
}

void TaskSpinServo(void *pvParameters){
  // Setup PWM Timer để xung xuất ra mượt, không bị rung
  ESP32PWM::allocateTimer(0);
  ESP32PWM::allocateTimer(1);
  ESP32PWM::allocateTimer(2);
  ESP32PWM::allocateTimer(3);

  Servo sv;
  sv.setPeriodHertz(50); // Cố định tần số 50Hz chuẩn cho Servo
  sv.attach(servo_pin, 500, 2400); // Setup min/max pulse width để servo không bị khựng ở 2 đầu biên

  int targetQueue = 0;

  while(1){
    if(xQueueReceive(angleQueue, &targetQueue, portMAX_DELAY) == pdPASS){
      sv.write(targetQueue);
    }
  }
}

void setup(){
  Serial.begin(115200);
  vTaskDelay(1000 / portTICK_PERIOD_MS); 

  angleQueue = xQueueCreate(5, sizeof(int));

  if(angleQueue != NULL){

    xTaskCreate(
      TaskReadADC, 
      "Read_ADC", 
      2048, 
      NULL, 
      2, 
      NULL
    ); 

    xTaskCreate(
      TaskSpinServo,
      "Spin_Servo", 
      2048, 
      NULL, 
      3, 
      NULL
    );

    xTaskCreate(
      TaskBlinkLed, 
      "Blink_led",
      1024,
      NULL, 
      1, 
      NULL
    );
  }
}

void loop(){

}