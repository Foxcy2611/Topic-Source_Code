#include <Arduino.h>
#include <Wire.h>
#include <ESP32Servo.h>
#include <LiquidCrystal_I2C.h>

const int Btr_Pin = 34;

const int Ser_Pin = 4;

const int Lcd_Sda = 21;
const int Lcd_Scl = 22;

const int Btn_Pin = 0;

LiquidCrystal_I2C lcd(0x27, 16, 2);
Servo myServo;

QueueHandle_t angleQueue; // queue
SemaphoreHandle_t btnSemaphore; // Binary Semaphore -> Tạo tiếng phát súng
SemaphoreHandle_t serialMutex; // Mutex

volatile bool isLocked = false;

void IRAM_ATTR isrButtonPress(){
  BaseType_t xChangeTask = pdFALSE;

  // Phát ra tiếng súng, gọi task xử lý ngắt dậy
  xSemaphoreGiveFromISR(btnSemaphore, &xChangeTask);

  if(xChangeTask == pdTRUE){
    portYIELD_FROM_ISR();
  }
}

// Task này đọc biến trở quy đổi
void TaskReadPotentiometer(void *pvParameters){
  int portValue = 0; // Giá trị đo ADC
  int targetAngle = 0; // Giá trị quy đổi từ ADC

  while(1){
    portValue = analogRead(Btr_Pin);

    targetAngle = map(portValue, 0, 4095, 0, 180);

    xQueueSend(angleQueue, &targetAngle, 0);

    vTaskDelay(50 / portTICK_PERIOD_MS);
  }
}

// Task xử lý nút nhấn
void TaskButtonHandler(){
  while (1){
    // Ngủ sâu, chờ tín hiệu gửi đến
    if(xSemaphoreTake(btnSemaphore,portMAX_DELAY) == pdTRUE){
      // Đảo khóa
      isLocked = ! isLocked;

      // Dùng mutex để in ra màn hình Serial an toàn
      if(xSemaphoreTake(serialMutex, portMAX_DELAY) == pdTRUE){
        if(isLocked){
          Serial.println("[SYSTEM] Xac dinh vi tri Servo");
        } else {
          Serial.println("[SYSTEM] Da khoa vi tri Servo");
        }

        xSemaphoreGive(serialMutex);
      } 

      vTaskDelay(50 / portTICK_PERIOD_MS);
    }
  }
}

void TaskServoAndLCD(){
  myServo.attach(Ser_Pin);
  lcd.init();
  lcd.backlight();

  int receivedAngle = 0; // Góc nhận được
  int currentAngle = -1; // Góc hiện tại => Lọc nhiễu, tránh servo quay các góc nhỏ liên tục (1-2 độ)

  while(1){
    if(xQueueReceive(angleQueue, &receivedAngle, portMAX_DELAY) == pdPASS){
      if(! isLocked){

        if((receivedAngle - currentAngle) > 2){
          myServo.write(receivedAngle);
          currentAngle = receivedAngle;
        }

      }

      lcd.setCursor(0, 0);
      lcd.print("Goc quay: ");
      lcd.print(receivedAngle);
      lcd.print(" do ");

      lcd.setCursor(0, 1);
      
      if(isLocked){
        lcd.print("LOCKED");
      } else {
        lcd.print("FREE");
      }
    }
  }
}

void setup(){
  Serial.begin(115200);

  angleQueue = xQueueCreate(5, sizeof(int));
  btnSemaphore = xSemaphoreCreateBinary();
  serialMutex = xSemaphoreCreateMutex();

  attachInterrupt(digitalPinToInterrupt(Btn_Pin), isrButtonPress, FALLING);

  // 3. Khởi tạo các Task chạy song song
    if (angleQueue != NULL && btnSemaphore != NULL && serialMutex != NULL) {
        
        // Task đọc Biến trở chạy tà tà (Priority 1)
        xTaskCreate(TaskReadPotentiometer, "Read_Pot", 2048, NULL, 1, NULL);
        
        // Task điều khiển Cơ khí và Màn hình ưu tiên trung bình (Priority 2)
        xTaskCreate(TaskServoAndLCD, "Servo_LCD", 4096, NULL, 2, NULL);
        
        // Task xử lý Ngắt khẩn cấp bắt buộc phải có độ ưu tiên cao nhất (Priority 3)
        xTaskCreate(TaskButtonHandler, "Button_Task", 2048, NULL, 3, NULL);
}