# 🚀 STM32 Custom UART Bootloader

![C](https://img.shields.io/badge/Language-C-blue.svg)
![MCU](https://img.shields.io/badge/MCU-STM32F10x-brightgreen.svg)
![Protocol](https://img.shields.io/badge/Protocol-UART%20%7C%20Serial-orange.svg)

> Hệ thống Bootloader tùy chỉnh cho phép cập nhật Firmware (Application) trực tiếp thông qua giao tiếp UART (cổng COM) mà không cần sử dụng mạch nạp chuyên dụng như ST-Link/J-Link. 

## 🌟 Tính năng chính

- **Nạp code qua Serial:** Nhận file `.bin` trực tiếp từ máy tính thông qua cáp chuyển đổi USB-to-UART (CP2102, CH340, PL2303...).
- **Quản lý Flash linh hoạt:** Tự động xóa (Erase) các sector cần thiết và ghi (Program) dữ liệu mới vào phân vùng Application một cách an toàn.
- **Tự động Jump (Chuyển hướng):** Xác thực tính hợp lệ của Firmware mới và thực hiện lệnh `Jump to Application` an toàn bằng cách trỏ tới hàm Reset Handler của App.
- **Host Tool tích hợp:** Đi kèm script Python nhỏ gọn trên PC để đọc file `.bin` và truyền theo các gói tin (packets) xuống vi điều khiển.

## 🗺️ Bản đồ bộ nhớ (Memory Map)

Bộ nhớ Flash của STM32 được chia làm 2 phần. Bạn cần cấu hình file Linker Script (`.ld`) của từng project cho khớp với bảng sau:

| Phân vùng | Địa chỉ bắt đầu | Kích thước | Chức năng |
| :--- | :---: | :---: | :--- |
| **Bootloader** | `0x08000000` | `16 KB` | Chạy đầu tiên. Lắng nghe UART, ghi Flash và Jump tới App. |
| **Application** | `0x08004000` | `48 KB` | Chương trình thực thi chính. |

## 📂 Cấu trúc dự án

```text
UART_Bootloader_System/
|
├── 1_Host_Tool/                 # [Công cụ chạy trên PC]
|   ├── flasher.py               # Script Python gửi file .bin qua cổng COM
|   └── requirements.txt         # (pyserial...)
|
├── 2_Bootloader/                # [Nằm ở 0x08000000]
|   ├── Makefile                 # Cấu hình biên dịch Bootloader
|   ├── stm32_flash.ld           # Linker script: FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 16K
|   ├── inc/bootloader.h         # Định nghĩa các tập lệnh Command (ACK, NACK, WRITE, JUMP...)
|   └── src/bootloader.c         # Xử lý luồng nhận UART và ghi Flash nội
|
└── 3_Application/               # [Nằm ở 0x08004000]
    ├── Makefile                 # Cấu hình biên dịch App
    ├── stm32_flash.ld           # Linker script: FLASH (rx) : ORIGIN = 0x08004000, LENGTH = 48K
    └── src/main.c               # Code ứng dụng chính (nháy LED, đọc cảm biến...)
