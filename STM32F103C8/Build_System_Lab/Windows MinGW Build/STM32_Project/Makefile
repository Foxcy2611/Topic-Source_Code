TARGET = main
BUILD_DIR = build

PREFIX = arm-none-eabi-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size

CPU = -mcpu=cortex-m3
FPU = 
FLOAT-ABI = 
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# Mức độ tối ưu (O0 để dễ debug) [cite: 157]
OPT = -O0

C_SOURCES =  \
$(wildcard Core/src/*.c) \
$(wildcard Drivers/STM32F10x_StdPeriph_Driver/src/*.c) \
Drivers/CMSIS/CM3/CoreSupport/core_cm3.c

ASM_SOURCES = startup.s

C_INCLUDES =  \
-ICore/inc \
-IDrivers/CMSIS/CM3/CoreSupport \
-IDrivers/CMSIS/CM3/DeviceSupport/ST/STM32F10x \
-IDrivers/STM32F10x_StdPeriph_Driver/inc

AS_DEFS = 
C_DEFS =  \
-DSTM32F10X_MD \
-DUSE_STDPERIPH_DRIVER

ASFLAGS = $(MCU) $(AS_DEFS) $(OPT) -Wall -fdata-sections -ffunction-sections
CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

LDSCRIPT = linker.ld
LDFLAGS = $(MCU) -T$(LDSCRIPT) --specs=nosys.specs -Wl,-Map=$(BUILD_DIR)/$(TARGET).map -Wl,--gc-sections


all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex size

OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(ASFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@

$(BUILD_DIR)/$(TARGET).hex: $(BUILD_DIR)/$(TARGET).elf
	$(CP) -O ihex $< $@

size: $(BUILD_DIR)/$(TARGET).elf
	$(SZ) $<

$(BUILD_DIR):
	mkdir $@

clean:
	rm -rf $(BUILD_DIR)