# ⏳ Đồng Hồ Cát Điện Tử LED (STM32 + MPU6050)

![C](https://img.shields.io/badge/Language-C-blue.svg)
![MCU](https://img.shields.io/badge/MCU-STM32F103-brightgreen.svg)

> Dự án mô phỏng đồng hồ cát vật lý trên 2 khối LED ma trận 8x8. Sử dụng cảm biến gia tốc MPU6050 để tính toán góc nghiêng của bo mạch, từ đó điều khiển hướng rơi và tốc độ chảy của các "hạt cát" LED bằng thuật toán mô phỏng vật lý chân thực.

## 🌟 Tính năng chính

- **Mô phỏng trọng lực:** Đọc dữ liệu thô (raw data) từ trục X, Y, và Z của MPU6050 qua I2C để xác định góc nghiêng.
- **Thuật toán "cát rơi":** Xử lý ma trận điểm ảnh để các hạt LED tự do lấp đầy khoảng trống bên dưới, trượt qua nhau khi có vật cản.
- **Giao diện LED mượt mà:** Quét 2 màn hình LED Matrix 8x8 ở tốc độ cao, không giật lag.
- **Môi trường phát triển:** Dự án được phát triển sử dụng phần mềm IDE Keil C.

## 🛠 Phần cứng sử dụng

- Vi điều khiển: **STM32F103C8T6** (Blue Pill)
- Cảm biến: **MPU6050** (Gia tốc kế 3 trục & Con quay hồi chuyển)
- Hiển thị: **2 x LED Matrix 8x8** (Sử dụng IC MAX7219)
- Debug/Nạp code: **ST-Link v2**

## 📂 Cấu trúc dự án

Dự án được tổ chức theo chuẩn thư viện SPL (Standard Peripheral Library):

```text
Hourglass/
|
├── main.c                    # File thực thi chính của chương trình
|
├── DELAY/
|   ├── delay.c               # Thư viện tạo trễ (delay) được viết bằng ngoại vi Timer
|   └── delay.h
|
├── MAX7219/                  # Thư viện tùy chỉnh để điều khiển LED ma trận
|   ├── max7219.c
|   └── max7219.h
|
├── MPU6050/                  # Thư viện để lấy các giá trị góc quay từ cảm biến
|   ├── Mpu6050.c
|   └── mpu6050.h
|
├── UART/                     # Thư viện dùng để debug, in ra các giá trị góc quay
|   ├── uart.c
|   └── uart.h
|
└── CONTROL/                  # "Bộ não" của dự án, chứa thuật toán xử lý hạt cát rơi
    ├── control_matrix.c
    └── control_matrix.h
```
