# 🚀 Template Dự Án Firmware cho STM32F103 (Native WSL)

![MCU](https://img.shields.io/badge/MCU-STM32F103C8-brightgreen.svg)
![Build](https://img.shields.io/badge/Build-Makefile-orange.svg)
![OS](https://img.shields.io/badge/Environment-WSL%20Ubuntu-blue.svg)

## 🌟 Tổng quan
- Dự án này cung cấp một môi trường phát triển độc lập, tách biệt hoàn toàn khỏi các IDE truyền thống.
- Bằng cách thiết lập hệ thống template và tổ chức cấu trúc thư mục trên Visual Studio Code, chúng ta tạo ra một quy trình phát triển (viết code, biên dịch, gỡ lỗi và nạp) mạnh mẽ dành riêng cho vi điều khiển STM32F103C8.
- **Không cần Keil C hay STM32CubeIDE.** Mọi thao tác Build, Debug và Flash code đều được thực hiện thông qua command line.

## 🛠 Môi trường Phát triển
Hệ thống được thiết kế để chạy trên môi trường sau:
- **OS:** Windows 11
- **Editor:** Visual Studio Code (VS Code)
- **Core Environment:** WSL (Ubuntu)
- **Compiler:** GNU Arm Embedded Toolchain
- **Debug/Flash:** OpenOCD / ST-Link

---

## 📂 Cấu trúc Dự án

```text
Native WSL Build/
│
├── Makefile                  # Trình quản lý biên dịch toàn bộ dự án
│
├── app/                      # [Lớp Ứng dụng & Thư viện tự viết]
│   ├── inc/                  # - main.h + các thư viện .h tự cấu hình
│   └── src/                  # - main.c + các thư viện .c tự viết
│
├── drivers/                  # [Lớp Điều khiển Hệ thống]
│   ├── inc/                  # - stm32f10x_conf.h (Cấu hình ngoại vi).
│   │                         # - stm32f10x_it.h (Khai báo ngắt).
│   └── src/                  # - stm32f10x_it.c (Nơi viết các trình phục vụ ngắt - ISR).
│                             # - system_stm32f10x.c (Cấu hình Clock cho chip).
│                             # - Note: Đây là "bộ khung" giúp Chip và thư viện SPL hiểu nhau.
│
├── lib/                      # [Lớp Thư viện Gốc - VENDOR]
│   ├── cmsis/                # - Thư viện lõi ARM (core_cm3.h, stm32f10x.h).
│   └── spl/                  # - Thư viện ngoại vi chuẩn của hãng (GPIO, RCC, UART...).
│       ├── inc/ 
│       └── src/ 
│                             # - Note: Chỉ Đọc (ReadOnly), không sửa đổi code trong này.
│
├── system/                   # [Lớp Khởi động & Cấu hình bộ nhớ]
│   ├── startup.s             # - File Assembly khởi động (Vector Table).
│   ├── stm32_f103c8.ld       # - Linker Script (Phân bổ RAM/ROM).
│   └── STM32F103.svd         # - File SVD hỗ trợ xem thanh ghi (Registers) khi Debug.
│
└── build/                    # [OUTPUT] - Thư mục chứa các file đầu ra như .hex, .bin, .elf.
```

---

## ⚙️ Hướng dẫn Cài đặt Môi trường

### 1. Cài đặt WSL trên Windows
Mở **PowerShell** (Run as Administrator) và chạy lệnh:
```bash
wsl --install
wsl --install -d Ubuntu
```

### 2. Thiết lập VS Code với WSL
- Cài đặt Extension **WSL** (của Microsoft) trong VS Code.
- Nhấn tổ hợp phím `Ctrl + Shift + P`, gõ và chọn **"WSL: Reopen Folder in WSL"** để làm việc trực tiếp trên nền Ubuntu.

### 3. Cài đặt Toolchain (Trên Terminal của WSL)
Bộ công cụ này bao gồm trình biên dịch C/C++ cho chip ARM (bare-metal), các công cụ kiểm tra file `.bin`/`.elf` và trình gỡ lỗi (gdb).
```bash
sudo apt update
sudo apt install gcc-arm-none-eabi binutils-arm-none-eabi gdb-multiarch make -y
```

### 4. Chia sẻ ST-Link từ Windows vào WSL (USB/IP)

Do WSL là một máy ảo, nó không tự động nhận các thiết bị cắm vào cổng USB của Windows. Ta cần dùng công cụ ép Windows chuyển tín hiệu USB vào WSL.

**A. Trên Windows PowerShell (Run as Administrator):**
Cài đặt công cụ `usbipd`:
```bash
winget install --interactive --exact dorssel.usbipd-win
```
*(Khởi động lại máy tính nếu đây là lần đầu bạn cài đặt).*

**B. Trên Terminal của WSL (Ubuntu):**
Cài đặt các gói hỗ trợ quản lý USB và công cụ nạp/gỡ lỗi (ST-Link, OpenOCD):
```bash
sudo apt update
sudo apt install usbutils linux-tools-generic hwdata libusb-1.0-0-dev -y
sudo update-alternatives --install /usr/local/bin/usbip usbip /usr/lib/linux-tools/*-generic/usbip 20
sudo apt install stlink-tools openocd -y
```

**C. Gắn mạch nạp ST-Link vào WSL:**
Quay lại **Windows PowerShell (Admin)**, chạy lệnh sau để tìm Bus ID của ST-Link:
```bash
usbipd list
```
Ghi nhớ `<busid>` của thiết bị "ST-Link Debug" (ví dụ: `2-1`) và tiến hành bind/attach:
```bash
usbipd bind --busid <busid>
usbipd attach --wsl --busid <busid>
```
*⚠️ Lưu ý quan trọng: Sau khi chạy lệnh này, các IDE trên Windows (như Keil C) sẽ không tìm thấy ST-Link nữa do nó đã bị "chiếm dụng" bởi WSL.* **D. Kiểm tra kết nối:**
Trở lại **Terminal của WSL**, gõ lệnh sau để đảm bảo WSL đã nhận được chip:
```bash
st-info --probe
```
*(Nếu terminal in ra thông số chip STM32F103, chúc mừng bạn đã thiết lập thành công!)*

> 💡 **Mẹo nhỏ:** Để trả lại ST-Link về cho Windows (nếu muốn quay lại dùng Keil C), mở Windows PowerShell và chạy lệnh: `usbipd detach --busid <busid>`.

---
*Các cấu hình biên dịch chi tiết (Compiler flags, đường dẫn thư viện...) đã được thiết lập sẵn trong file `Makefile`. Vui lòng xem mã nguồn dự án để biết thêm chi tiết.*
