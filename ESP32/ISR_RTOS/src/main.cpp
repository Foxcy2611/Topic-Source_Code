#include <Arduino.h>

// 1. Khai báo "Chuông báo cháy" (Binary Semaphore)
SemaphoreHandle_t chuongBaoChay;

const int PIN_NGAT = 0; // Chân cắm nút nhấn hoặc chân INT của cảm biến

// ---------------------------------------------------------
// HÀM NGẮT (ISR) - NGƯỜI BẤM CHUÔNG
// ---------------------------------------------------------
// IRAM_ATTR đưa hàm này vào RAM để ESP32 phản ứng cực nhanh
void IRAM_ATTR isrXuLyNgat() {
  
  // Biến này để FreeRTOS tự đánh giá xem có cần "bẻ lái" CPU không
  BaseType_t xCanChuyenTaskNgay = pdFALSE;

  // BẤM CHUÔNG: Bắn Semaphore ra từ trong hàm ngắt
  xSemaphoreGiveFromISR(chuongBaoChay, &xCanChuyenTaskNgay);

  // BẺ LÁI CPU: Nếu Task cứu hỏa đang ưu tiên cao hơn Task hiện tại,
  // ép CPU nhảy sang Task cứu hỏa ngay lập tức.
  if (xCanChuyenTaskNgay == pdTRUE) {
    portYIELD_FROM_ISR();
  }
}

// ---------------------------------------------------------
// TASK LÍNH CỨU HỎA - LÀM VIỆC NẶNG
// ---------------------------------------------------------
void TaskLinhCuuHoa(void *pvParameters) {
  while(1) {
    // NGỦ ĐÔNG CHỜ CHUÔNG
    // Lệnh này block Task lại hoàn toàn, chiếm 0% CPU
    if (xSemaphoreTake(chuongBaoChay, portMAX_DELAY) == pdTRUE) {
      
      // --- VÙNG LÀM VIỆC NẶNG ---
      // Chỉ khi Ngắt xảy ra, đoạn code này mới được chạy
      Serial.println("\n[CẢNH BÁO] Phát hiện tín hiệu Ngắt!");
      Serial.println("[TASK] Bắt đầu đọc dữ liệu I2C/SPI phức tạp...");
      
      // Giả lập tốn 2 giây để xử lý xong công việc
      vTaskDelay(2000 / portTICK_PERIOD_MS); 
      
      Serial.println("[TASK] Đã xử lý xong. Quay về ngủ chờ báo động tiếp theo.");
    }
  }
}

// ---------------------------------------------------------
// TASK CHỚP LED - VIỆC RÂU RIA
// ---------------------------------------------------------
void TaskChopLed(void *pvParameters) {
  pinMode(2, OUTPUT);
  while(1) {
    digitalWrite(2, !digitalRead(2));
    vTaskDelay(500 / portTICK_PERIOD_MS);
  }
}

void setup() {
  Serial.begin(115200);
  pinMode(PIN_NGAT, INPUT_PULLUP);

  // 2. KHỞI TẠO CHUÔNG BÁO CHÁY
  chuongBaoChay = xSemaphoreCreateBinary();

  if (chuongBaoChay != NULL) {
    
    // Gắn phần cứng: Khi điện áp chân số 0 sụt xuống GND (FALLING) thì gọi ISR
    attachInterrupt(digitalPinToInterrupt(PIN_NGAT), isrXuLyNgat, FALLING);

    // Tạo Task. Lưu ý: Task cứu hỏa cho mức ưu tiên (Priority) = 3, cao hơn Task LED (Priority = 1)
    xTaskCreate(TaskLinhCuuHoa, "Cuu_Hoa", 2048, NULL, 3, NULL);
    xTaskCreate(TaskChopLed, "Chop_Led", 1024, NULL, 1, NULL);
  }
}

void loop() {}