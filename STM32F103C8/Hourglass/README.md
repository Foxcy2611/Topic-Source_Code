# ⏳ Digital LED Hourglass (STM32 + MPU6050)

![C](https://img.shields.io/badge/Language-C-blue.svg)
![MCU](https://img.shields.io/badge/MCU-STM32F103-brightgreen.svg)

> A physical hourglass simulation project on two 8x8 LED matrices. It uses an MPU6050 accelerometer to calculate the board's tilt angle, thereby controlling the falling direction and flow rate of the LED "sand grains" using a realistic physical simulation algorithm.

## 🌟 Key Features

- **Gravity Simulation:** Reads raw data from the X, Y, and Z axes of the MPU6050 via I2C to determine the tilt angle.
- **"Falling Sand" Algorithm:** Processes the pixel matrix to allow LED grains to freely fill the empty spaces below and slide past each other when encountering obstacles.
- **Smooth LED Interface:** Scans the two 8x8 LED Matrices at high speed without lagging.
- **Development Environment:** The project is developed using the Keil C IDE.

## 🛠 Hardware Used

- Microcontroller: **STM32F103C8T6** (Blue Pill)
- Sensor: **MPU6050** (3-axis Accelerometer & Gyroscope)
- Display: **2 x 8x8 LED Matrix** (Using MAX7219 IC)
- Debug/Programmer: **ST-Link v2**

## 📂 Project Structure

The project is organized using the SPL (Standard Peripheral Library):

```text
Hourglass/
|
├── main.c                    # Main entry point
|
├── DELAY/
|   ├── delay.c               # Delay library written using the Timer peripheral
|   └── delay.h
|
├── MAX7219/                  # Custom library to control the LED matrix
|   ├── max7219.c
|   └── max7219.h
|
├── MPU6050/                  # Custom library to fetch rotation axis values
|   ├── Mpu6050.c
|   └── mpu6050.h
|
├── UART/                     # Library for debugging, printing rotation angle values
|   ├── uart.c
|   └── uart.h
|
└── CONTROL/                  # The brain of the project, falling sand processing algorithm
    ├── control_matrix.c
    └── control_matrix.h
