## Firmware project template for STM32F103

## Overview
* This project is a completely separate IDE from the typical IDEs used.
* By designing, building a template system, and classification on VSC, we can create an IDE for the STM32F103C8.
* No Keil C or STM32CubeIDE are needed; we can completely build, debug, and flash code.

## Project's Programming Environment
In this project, we developed using the following environments, separate from typical IDEs.
* OS: Window 11
* Visual Studio Code
* WSL (Ubuntu)
* GNU Arm Embedded Toolchain
* OpenOCD / ST-Link for debugging

## Project Diagram

```text
Native WSL Build/
│
├── Makefile                  # Project Manager
│
├── app/                      # [Project layer and code libraries]
│   ├── inc/                  # - main.h + custom-written .h libraries
│   └── src/                  # - main.c + custom-written .c libraries
│
├── drivers/                  # [System control layer]
│   ├── inc/                  # - stm32f10x_conf.h (Peripheral configuration).
│   │                         # - stm32f10x_it.h (Interrupt declaration).
│   └── src/                  # - stm32f10x_it.c (Where interrupt handling code - ISR is written).
│                             # - system_stm32f10x.c (Clock configuration for the chip).
│                             # - Note: This is the "framework" that helps the chip and SPL code understand each other..
│
├── lib/                      # [Original Library Floor - VENDOR]
│   ├── cmsis/                # - ARM Core Library (core_cm3.h, stm32f10x.h).
│   └── spl/                  # - Standard external library of the manufacturer (GPIO, RCC, UART...).
│       ├── inc/ 
│       └── src/ 
│                             # - Note: ReadOnly
│
├── system/                   # [Startup floor]
│   ├── startup.s             # - File Assembly.
│   └── stm32_f103c8.ld       # - Linker Script.
│   └── STM32F103.svd         # - File for checking registers during debugging.
│
└── build/                    # [OUTPUT] - The .hex and .bin files are located here.
```

## Setup for Work

### 1. Install WSL on Window

`` bash
wsl --install
wsl --install -d Ubuntu
``

### 2. Setup WSL on VSC
* Install extension WSL
* Ctrl + Shift + P
* Reopen on WSL

### 3. Install Toolchain 
This toolkit includes a C/C++ compiler for ARM bare-metal, tools for inspecting .bin and .elf files, and debugging tools.
`` bash
sudo apt install gcc-arm-none-eabi binutils-arm-none-eabi gdb-multiarch make -y
``
### 4. Setting up a USB (ST-Link) connection over a virtual network (USB/IP)
Open PowerShell (Run as Administrator), install usbipd
`` bash
winget install --interactive --exact dorssel.usbipd-win
``
(Restart your computer if this is the first time installing.)

Setup on Windows
* Install the USB control toolkit.
`` bash
sudo apt update
sudo apt install usbutils -y
``

* Install drivers and overclock using the usbipd command.
`` bash
sudo apt install linux-tools-generic hwdata -y
sudo update-alternatives --install /usr/local/bin/usbip usbip /usr/lib/linux-tools/*-generic/usbip 20
sudo apt install libusb-1.0-0-dev -y
``
  
* Install the Loading and Debugging Toolkit (ST-Link).
`` bash
sudo apt install stlink-tools openocd -y
``

* Grant permission for ST-Link to be used at WSL.
Once you successfully grant permission, standard IDEs (Keil C, etc.) will no longer be able to detect the St-Link connection signal.
`` bash
usbipd list
usbipd bind --busid <busid>
usbipd attach --wsl --busid <busid>
``

Check by
`` bash
st-info --probe
``

## The rest has been edited; see the project for more details.



