#include <Arduino.h>

// 1. Khai báo Handle cho Mutex
SemaphoreHandle_t serialMutex;

// ---------------------------------------------------------
// Task 1: Muốn in chữ "A" liên tục
// ---------------------------------------------------------
void TaskPrintA(void *pvParameters) {
  while(1) {
    // Xin chìa khóa Mutex. 
    // portMAX_DELAY: Nếu Task khác đang giữ chìa, tôi sẽ đứng đợi (ngủ) tới khi nào có thì thôi.
    if (xSemaphoreTake(serialMutex, portMAX_DELAY) == pdTRUE) {
      
      // --- Vùng an toàn (Critical Section) ---
      // Khi đã vào đây, chắc chắn 100% không Task nào khác được phép dùng Serial
      Serial.print("Task 1 dang chay: ");
      Serial.println("AAAAA");
      
      // Dùng xong BẮT BUỘC PHẢI TRẢ CHÌA KHÓA. Nếu quên, toàn bộ hệ thống sẽ tắc nghẽn vĩnh viễn (Deadlock).
      xSemaphoreGive(serialMutex);
    }
    
    vTaskDelay(100 / portTICK_PERIOD_MS);
  }
}

// ---------------------------------------------------------
// Task 2: Muốn in chữ "B" liên tục
// ---------------------------------------------------------
void TaskPrintB(void *pvParameters) {
  while(1) {
    if (xSemaphoreTake(serialMutex, portMAX_DELAY) == pdTRUE) {
      // --- Vùng an toàn ---
      Serial.print("Task 2 dang chay: ");
      Serial.println("BBBBB");
      
      // Trả khóa
      xSemaphoreGive(serialMutex);
    }
    
    vTaskDelay(100 / portTICK_PERIOD_MS);
  }
}

void setup() {
  Serial.begin(115200);
  
  // 2. TẠO MUTEX TRƯỚC KHI TẠO TASK
  serialMutex = xSemaphoreCreateMutex();

  if (serialMutex != NULL) {
    xTaskCreate(TaskPrintA, "Print_A", 2048, NULL, 1, NULL);
    xTaskCreate(TaskPrintB, "Print_B", 2048, NULL, 1, NULL);
  }
}

void loop() {}