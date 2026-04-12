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

### 2. a
