# 🎨 Ứng Dụng QML/C++ Hiện Đại

![Qt](https://img.shields.io/badge/Qt-6.x%20%7C%205.x-41CD52.svg?logo=qt&logoColor=white)
![Language](https://img.shields.io/badge/Language-C++%20%7C%20QML%20%7C%20JS-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Cross--Platform-lightgrey.svg)

## 📖 Tổng quan
Dự án này được xây dựng sử dụng **Qt** và **QML** nhằm tạo ra một giao diện người dùng hiện đại, trực quan và có khả năng mở rộng linh hoạt. QML đóng vai trò là ngôn ngữ khai báo giao diện của Qt, cho phép thiết kế nhanh các UI mượt mà bằng cú pháp ngắn gọn, kết hợp hoàn hảo với JavaScript để xử lý logic ở phía frontend.

## 🎯 Mục tiêu dự án
- **Triển khai đa nền tảng (Cross-Platform):** Viết code một lần, biên dịch và chạy trên mọi nền tảng (Windows, Linux, macOS, Android, iOS và Nhúng - Embedded Linux).
- **UI/UX mượt mà:** Sử dụng QML để thiết kế giao diện tốc độ cao, có hỗ trợ tăng tốc phần cứng (hardware-accelerated) và dễ dàng tùy biến.
- **Hiệu năng cao:** Kết hợp **Backend C++** mạnh mẽ (đảm nhiệm tính toán nặng, xử lý đa luồng và kết nối dữ liệu thô) với **Frontend QML** gọn nhẹ để tận dụng tối đa sức mạnh của framework Qt.

## 🛠 Công nghệ sử dụng
- **Framework chính:** Qt 6.x (hoặc Qt 5.x)
- **Frontend (Giao diện):** QML, JavaScript
- **Backend (Logic lõi):** C++ (Chuẩn C++17/C++20)
- **Hệ thống Build:** CMake (Khuyên dùng) / qmake

## 📂 Cấu trúc dự án

Để duy trì một kiến trúc mã nguồn sạch sẽ (Clean Architecture), phần logic nghiệp vụ viết bằng C++ và phần định nghĩa giao diện QML được chia tách vô cùng nghiêm ngặt:

```text
QML_Project_Template/
│
├── CMakeLists.txt            # File cấu hình biên dịch CMake
│
├── src/                      # [Lớp Backend C++]
│   ├── main.cpp              # Điểm bắt đầu của ứng dụng, khởi tạo QQmlApplicationEngine
│   ├── backend.cpp           # Xử lý logic lõi (Signals/Slots, Q_INVOKABLE)
│   └── backend.h             # File header C++ chứa các định nghĩa Q_PROPERTY
│
├── qml/                      # [Lớp Frontend QML]
│   ├── main.qml              # Cửa sổ ứng dụng chính và điều hướng (routing)
│   ├── components/           # Các thành phần UI tự viết dùng chung (Nút bấm, Thẻ, Thanh trượt)
│   ├── views/                # Các màn hình/trang riêng biệt của ứng dụng
│   └── assets/               # Tài nguyên tĩnh (Hình ảnh, Font chữ, Icons)
│
└── qml.qrc                   # File gom tài nguyên Qt (đóng gói QML/assets vào file chạy nhị phân)
```

## ⚙️ Hướng dẫn Build (Bằng CMake)

### Yêu cầu hệ thống:
Đảm bảo máy tính của bạn đã cài đặt bộ Qt SDK, công cụ CMake và một trình biên dịch C++ tương thích (MSVC/MinGW trên Windows, hoặc GCC trên Linux).

### Các bước biên dịch (Qua Command Line/Terminal):
1. Clone dự án về máy:
   ```bash
   git clone [https://github.com/yourusername/your-qml-project.git](https://github.com/yourusername/your-qml-project.git)
   cd your-qml-project
   ```
2. Tạo thư mục chứa file build:
   ```bash
   mkdir build && cd build
   ```
3. Sinh các file cấu hình biên dịch:
   ```bash
   cmake ..
   ```
4. Tiến hành biên dịch (Compile):
   ```bash
   cmake --build .
   ```
5. Chạy file thực thi (Executable) vừa được tạo ra trong thư mục `build`.
