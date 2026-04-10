/* 1. Điểm bắt đầu của chương trình */
ENTRY(Reset_Handler)

/* 2. Đỉnh Stack: Nằm ở cuối RAM (0x20000000 + 20K = 0x20005000) */
_estack = 0x20005000;

/* 3. Khai báo tài nguyên bộ nhớ STM32F103C8T6 */
MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 64K
    RAM   (xrw) : ORIGIN = 0x20000000, LENGTH = 20K
}

/* 4. Phân lô các Section */
SECTIONS
{
    /* Bảng Vector ngắt: Phải nằm đầu tiên trong FLASH */
    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector)) 
        /* KEEP để Linker không tự ý xóa đi do tưởng là code thừa */
        . = ALIGN(4);
    } > FLASH

    /* Code thực thi (.text) và Hằng số (.rodata): Ở lại FLASH */
    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.text.*)
        *(.rodata)
        *(.rodata.*)
        . = ALIGN(4);
    } > FLASH

    /* Cắm cờ: Lưu địa chỉ bắt đầu của .data nằm trên FLASH*/
    _la_data = LOADADDR(.data);

    /* Biến toàn cục CÓ khởi tạo (.data): Lưu ở FLASH nhưng khi chạy phải kéo về RAM */
    .data :
    {
        . = ALIGN(4);
        _sdata = .;        /* Cắm cờ: Bắt đầu vùng .data ở RAM */
        *(.data)
        *(.data.*)
        . = ALIGN(4);
        _edata = .;        /* Cắm cờ: Kết thúc vùng .data ở RAM */
    } > RAM AT > FLASH

    /* Biến toàn cục KHÔNG khởi tạo (.bss): Linker chỉ giữ chỗ trên RAM */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;         /* Cắm cờ: Bắt đầu vùng .bss ở RAM */
        *(.bss)
        *(.bss.*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;         /* Cắm cờ: Kết thúc vùng .bss ở RAM */
    } > RAM
}