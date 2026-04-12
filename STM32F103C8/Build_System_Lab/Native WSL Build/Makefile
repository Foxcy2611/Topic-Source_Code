# ==========================================
# MAKEFILE CHO STM32 BARE-METAL - TRÙM VT01 (V2)
# ==========================================

TARGET = stm32_project
BUILD_DIR = build

CC = arm-none-eabi-gcc
AS = arm-none-eabi-gcc -x assembler-with-cpp
CP = arm-none-eabi-objcopy
SZ = arm-none-eabi-size

CPU = -mcpu=cortex-m3
FPU = 
FLOAT-ABI = -mfloat-abi=soft
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

C_DEFS =  \
-DSTM32F10X_MD \
-DUSE_STDPERIPH_DRIVER

C_SOURCES =  \
$(wildcard app/src/*.c) \
$(wildcard drivers/src/*.c) \
$(wildcard lib/spl/src/*.c) \
$(wildcard lib/cmsis/src/*.c) \
$(wildcard modules/src/*.c)

ASM_SOURCES =  \
system/startup.s

C_INCLUDES =  \
-Iapp/inc \
-Idrivers/inc \
-Ilib/cmsis/inc \
-Ilib/spl/inc \
-Imodules/inc

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) -O0 -g3 -Wall -fdata-sections -ffunction-sections

LDSCRIPT = system/linker.ld

LDFLAGS = $(MCU) -T$(LDSCRIPT) -specs=nano.specs -Wl,--gc-sections

# ==========================================
# CÁC RULE BIÊN DỊCH (BẢN V2 CHỐNG LỖI WSL)
# ==========================================

all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

# Tự động tạo danh sách file .o (Giữ nguyên cấu trúc thư mục)
OBJECTS = $(addprefix $(BUILD_DIR)/, $(C_SOURCES:.c=.o))
OBJECTS += $(addprefix $(BUILD_DIR)/, $(ASM_SOURCES:.s=.o))

# Rule build C
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

# Rule build ASM
$(BUILD_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) $(LDSCRIPT)
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf
	$(CP) -O ihex $< $@

$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf
	$(CP) -O binary -S $< $@

clean:
	-rm -fR $(BUILD_DIR)

flash: $(BUILD_DIR)/$(TARGET).elf
	openocd -f interface/stlink.cfg -f target/stm32f1x.cfg -c "program $< verify reset exit"

.PHONY: all clean flash