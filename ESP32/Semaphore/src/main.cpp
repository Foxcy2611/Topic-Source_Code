#include <Arduino.h>

// 1. Khai báo Handle cho Semaphore đếm
SemaphoreHandle_t roomCapacitySemaphore;

// Giả lập danh sách thẻ RFID của các thành viên trong nhóm
const char* listTheRFID[] = {"Chiến", "Hùng", "Huy", "Long", "Khách_Lạ"};

// ---------------------------------------------------------
// TASK 1: Giả lập có người quẹt thẻ RFID-RC522 muốn VÀO phòng
// ---------------------------------------------------------
void TaskQuetTheVao(void *pvParameters) {
  while(1) {
    // Giả lập ngẫu nhiên cứ 2-4 giây lại có một người quẹt thẻ vào
    vTaskDelay(random(2000, 4000) / portTICK_PERIOD_MS);
    
    // Chọn ngẫu nhiên 1 người trong danh sách để quẹt thẻ
    int randomPerson = random(0, 5);
    Serial.printf("--> [%s] vừa quẹt thẻ RC522 xin VÀO phòng...\n", listTheRFID[randomPerson]);

    // XIN CHỖ TRỐNG (Take Semaphore)
    // Lệnh này chờ tối đa 1000ms. Nếu hết 1000ms mà không lấy được chỗ (Semaphore = 0), nó sẽ báo lỗi.
    if (xSemaphoreTake(roomCapacitySemaphore, 1000 / portTICK_PERIOD_MS) == pdTRUE) {
      
      // Hàm uxSemaphoreGetCount giúp kiểm tra xem Semaphore đang còn giá trị bao nhiêu
      int choTrong = uxSemaphoreGetCount(roomCapacitySemaphore);
      Serial.printf("    [MỞ CỬA] %s đã vào thành công. Phòng còn %d chỗ trống.\n", listTheRFID[randomPerson], choTrong);
      
    } else {
      Serial.printf("    [TỪ CHỐI] Tít tít! Phòng đang đầy (đã đủ 3 người). %s phải đứng chờ!\n", listTheRFID[randomPerson]);
    }
  }
}

// ---------------------------------------------------------
// TASK 2: Giả lập có người bên trong quẹt thẻ RA khỏi phòng
// ---------------------------------------------------------
void TaskQuetTheRa(void *pvParameters) {
  while(1) {
    // Giả lập thời gian ở trong phòng làm việc khá lâu (7-12 giây) mới có người ra
    vTaskDelay(random(7000, 12000) / portTICK_PERIOD_MS);
    
    // Kiểm tra: Nếu phòng đang không trống hoàn toàn (có người bên trong)
    if (uxSemaphoreGetCount(roomCapacitySemaphore) < 3) { 
        
        // TRẢ LẠI 1 CHỖ TRỐNG (Give Semaphore)
        xSemaphoreGive(roomCapacitySemaphore);
        
        int choTrong = uxSemaphoreGetCount(roomCapacitySemaphore);
        Serial.printf("<-- [ĐI RA] Một người vừa quẹt thẻ RA khỏi phòng. Phòng trống thêm, hiện có %d chỗ.\n", choTrong);
    }
  }
}

void setup() {
  Serial.begin(115200);
  Serial.println("\n--- KHỞI ĐỘNG HỆ THỐNG ACCESS CONTROL ---");
  Serial.println("Quy tắc: Phòng lab chỉ chứa tối đa 3 người cùng lúc.\n");

  // 2. TẠO SEMAPHORE ĐẾM
  // Tham số 1: Sức chứa tối đa (Max Count) = 3
  // Tham số 2: Số chỗ trống ban đầu (Initial Count) = 3 (Phòng đang trống hoàn toàn)
  roomCapacitySemaphore = xSemaphoreCreateCounting(3, 3);

  if (roomCapacitySemaphore != NULL) {
    // Cho hai Task chạy song song với cùng mức ưu tiên
    xTaskCreate(TaskQuetTheVao, "Gate_In",  2048, NULL, 2, NULL);
    xTaskCreate(TaskQuetTheRa,  "Gate_Out", 2048, NULL, 2, NULL);
  }
}

void loop() {}