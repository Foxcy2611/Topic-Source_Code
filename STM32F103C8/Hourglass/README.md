# ⏳ Digital LED Hourglass (STM32 + MPU6050)

![C](https://img.shields.io/badge/Language-C-blue.svg)
![MCU](https://img.shields.io/badge/MCU-STM32F103-brightgreen.svg)
![Build](https://img.shields.io/badge/Build-Makefile%20%7C%20WSL-orange.svg)

> Dự án mô phỏng đồng hồ cát vật lý trên 2 khối LED ma trận 8x8. Sử dụng cảm biến gia tốc MPU6050 để tính toán góc nghiêng của bo mạch, từ đó điều khiển hướng rơi và tốc độ chảy của các "hạt cát" LED bằng thuật toán mô phỏng vật lý chân thực.

## 🌟 Tính năng chính

- **Mô phỏng trọng lực:** Đọc dữ liệu thô (raw data) từ trục X, Y, Z của MPU6050 qua I2C để xác định góc nghiêng.
- **Thuật toán "cát rơi":** Xử lý ma trận điểm ảnh để các hạt LED tự do lấp đầy khoảng trống bên dưới, trượt qua nhau khi có vật cản.
- **Giao diện LED mượt mà:** Quét 2 màn hình LED Matrix 8x8 tốc độ cao, không giật lag.
- **Môi trường phát triển độc lập:** Không phụ thuộc IDE, build hoàn toàn bằng `Makefile` trên môi trường WSL (Ubuntu).

## 🛠 Phần cứng sử dụng

- Vi điều khiển: **STM32F103C8T6** (Blue Pill)
- Cảm biến: **MPU6050** (Gia tốc kế 3 trục & Con quay hồi chuyển)
- Hiển thị: **2 x LED Matrix 8x8** (Sử dụng IC MAX7219)
- Debug/Nạp code: **ST-Link v2**

## 📂 Cấu trúc dự án

Dự án được tổ chức theo chuẩn thư viện SPL (Standard Peripheral Library), biên dịch Native trên WSL:

```text
Native WSL Build/
|
├── Makefile                  # Trình quản lý biên dịch
|
├── app/                      # [Lớp ứng dụng]
|   ├── inc/                  # - hourglass_logic.h, led_matrix.h, mpu6050.h
|   └── src/                  # - main.c, hourglass_logic.c, led_matrix.c, mpu6050.c
|
├── drivers/                  # [Lớp điều khiển hệ thống & Ngoại vi]
|   ├── inc/                  # - stm32f10x_conf.h, stm32f10x_it.h
|   └── src/                  # - stm32f10x_it.c (Xử lý ngắt), system_stm32f10x.c
|
├── lib/                      # [Thư viện gốc của VENDOR]
|   ├── cmsis/                # - Lõi ARM (core_cm3.h, stm32f10x.h)
|   └── spl/                  # - Thư viện chuẩn ngoại vi (GPIO, I2C, SPI...)
|
└── system/                   # [Lớp Startup & Linker]
    ├── startup.s             # - File Assembly khởi động
    └── stm32_f103c8.ld       # - Linker Script phân bổ bộ nhớ
