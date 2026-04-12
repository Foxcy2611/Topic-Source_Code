# 🚀 STM32 Custom UART Bootloader

![C](https://img.shields.io/badge/Language-C-blue.svg)
![MCU](https://img.shields.io/badge/MCU-STM32F10x-brightgreen.svg)
![IDE](https://img.shields.io/badge/IDE-Keil%20uVision%205-red.svg)
![Editor](https://img.shields.io/badge/Editor-VS%20Code-blue.svg)

> Hệ thống Bootloader tùy chỉnh cho phép cập nhật Firmware (Application) trực tiếp thông qua giao tiếp UART (cổng COM) mà không cần sử dụng mạch nạp chuyên dụng như ST-Link/J-Link. Dự án được biên dịch hoàn toàn trên môi trường Keil C, kết hợp VS Code để tối ưu quá trình viết code.

## 🌟 Tính năng chính

- **Nạp code qua Serial:** Nhận file `.bin` trực tiếp từ máy tính thông qua cáp chuyển đổi USB-to-UART (CP2102, CH340, PL2303...).
- **Quản lý Flash linh hoạt:** Tự động xóa (Erase) và ghi (Program) dữ liệu mới vào phân vùng Application một cách an toàn.
- **Tự động Jump (Chuyển hướng):** Xác thực tính hợp lệ của Firmware mới và thực hiện lệnh `Jump to Application`.
- **Host Tool Python:** Đi kèm script tự động hóa quá trình truyền file từ PC xuống vi điều khiển.

## 🗺️ Bản đồ bộ nhớ (Memory Map)

Bộ nhớ Flash của STM32 được chia làm 2 phần. Cấu hình này được thiết lập trực tiếp trong mục **Options for Target** của Keil C:

| Phân vùng | Địa chỉ bắt đầu | Kích thước | Chức năng |
| :--- | :---: | :---: | :--- |
| **Bootloader** | `0x08000000` | `0x4000` (16KB) | Chạy đầu tiên. Lắng nghe UART, ghi Flash và Jump tới App. |
| **Application** | `0x08004000` | `0xC000` (48KB) | Chương trình thực thi chính. |

*(Lưu ý: Kích thước 48KB ở trên là tính cho chip dòng C8T6 có 64KB Flash. Có thể thay đổi nếu bạn dùng chip khác).*

## 📂 Cấu trúc dự án

```text
UART_Bootloader_System/
|
├── 1_Host_Tool/                 # [Công cụ chạy trên PC]
|   ├── flasher.py               # Script Python gửi file .bin qua cổng COM
|   └── requirements.txt         # (Chứa package pyserial)
|
├── 2_Bootloader/                # [Nằm ở 0x08000000]
|   ├── Bootloader.uvprojx       # File project Keil C
|   ├── inc/bootloader.h         # Tập lệnh Command (ACK, NACK, WRITE, JUMP...)
|   └── src/bootloader.c         # Xử lý luồng nhận UART và ghi Flash nội
|
└── 3_Application/               # [Nằm ở 0x08004000]
    ├── Application.uvprojx      # File project Keil C
    └── src/main.c               # Code ứng dụng chính
```

## ⚙️ Hướng dẫn Cấu hình Keil C & Nạp Code

*Mẹo: Bạn có thể mở thư mục gốc bằng VS Code để viết code nhanh hơn, sau đó chỉ mở file `.uvprojx` bằng Keil C để Compile.*

### Bước 1: Cấu hình và nạp Bootloader
1. Mở project `2_Bootloader/Bootloader.uvprojx` bằng Keil C.
2. Nhấn `Alt + F7` (Options for Target) -> Tab **Target**.
   - Mục **IROM1**: Start = `0x8000000`, Size = `0x4000`.
3. Nhấn **F7** để Build và dùng ST-Link nạp (nhấn **F8**) vào mạch. **Đây là lần duy nhất bạn cần dùng đến ST-Link.**

### Bước 2: Cấu hình Application & Sinh file .bin
1. Mở project `3_Application/Application.uvprojx` bằng Keil C.
2. **Dịch Vector Ngắt:** Mở file `system_stm32f10x.c`, tìm `#define VECT_TAB_OFFSET` và đổi thành:
   ```c
   #define VECT_TAB_OFFSET  0x4000 /* Vector Table base offset field. */
   ```
3. **Cấu hình ROM:** Nhấn `Alt + F7` -> Tab **Target**.
   - Mục **IROM1**: Start = `0x8004000`, Size = `0xC000`.
4. **Cấu hình sinh file .bin (Rất quan trọng):**
   - Chuyển sang Tab **User**.
   - Tích vào ô **Run #1** ở mục *After Build/Rebuild*.
   - Nhập chính xác lệnh sau vào ô trống để Keil chuyển đổi file `.axf` sang `.bin`:
     ```text
     $K\ARM\ARMCC\bin\fromelf.exe --bin --output=@L.bin !L
     ```
5. Nhấn Build (**F7**). Lúc này trong thư mục `Objects` (hoặc Output) của project sẽ xuất hiện file `Application.bin`.

### Bước 3: Nạp Firmware qua UART
1. Mở Terminal (CMD hoặc PowerShell) trên PC và cài đặt thư viện cần thiết:
   ```bash
   pip install pyserial
   ```
2. Kết nối chân TX/RX của STM32 với máy tính qua module USB-to-UART (Chú ý nối chéo TX vào RX và ngược lại).
3. Nhấn nút **Reset** trên board, mạch sẽ đi vào chế độ Bootloader chờ nhận lệnh.
4. Chạy script nạp (thay `COM3` bằng cổng thực tế hiển thị trong Device Manager của bạn):
   ```bash
   python 1_Host_Tool/flasher.py --port COM3 --baud 115200 --file 3_Application/Objects/Application.bin
   ```
5. Đợi tool báo nạp thành công, hệ thống sẽ tự động Jump sang Application và chạy chương trình mới!
