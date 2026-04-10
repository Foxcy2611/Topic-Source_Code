.syntax unified
  .cpu cortex-m3
  .thumb

/* =========================================================================
   1. KHAI BÁO BIẾN TỪ LINKER SCRIPT & HÀM BÊN NGOÀI
   ========================================================================= */
  .global _estack // Đỉnh stack
  .global _sdata // Bắt đầu vùng data của RAM
  .global _edata // Kết thúc vùng data của RAM
  .global _la_data // Địa chỉ nguồn trong FL để copy data khởi tạo vào Ram
  .global _sbss // Bắt đầu vùng bss của RAM
  .global _ebss // Kết thúc vùng bss của RAM

  /* Import hàm SystemInit (CMSIS) và hàm main */
  .global SystemInit
  .global main

/* =========================================================================
   2. BẢNG VECTOR NGẮT (VECTOR TABLE)
   ========================================================================= */
  .section .isr_vector, "a", %progbits
  .type g_pfnVectors, %object
  .size g_pfnVectors, .-g_pfnVectors

g_pfnVectors:
  .word _estack                 /* Đỉnh Stack */
  .word Reset_Handler           /* Reset Handler */
  .word NMI_Handler             /* NMI Handler */
  .word HardFault_Handler       /* Hard Fault Handler */
  .word MemManage_Handler       /* MPU Fault Handler */
  .word BusFault_Handler        /* Bus Fault Handler */
  .word UsageFault_Handler      /* Usage Fault Handler */
  .word 0                       /* Reserved */
  .word 0                       /* Reserved */
  .word 0                       /* Reserved */
  .word 0                       /* Reserved */
  .word SVC_Handler             /* SVCall Handler */
  .word DebugMon_Handler        /* Debug Monitor Handler */
  .word 0                       /* Reserved */
  .word PendSV_Handler          /* PendSV Handler */
  .word SysTick_Handler         /* SysTick Handler */

  /* Các ngắt ngoại vi STM32F103 */
  .word WWDG_IRQHandler
  .word PVD_IRQHandler
  .word TAMPER_IRQHandler
  .word RTC_IRQHandler
  .word FLASH_IRQHandler
  .word RCC_IRQHandler
  .word EXTI0_IRQHandler
  .word EXTI1_IRQHandler
  .word EXTI2_IRQHandler
  .word EXTI3_IRQHandler
  .word EXTI4_IRQHandler
  .word DMA1_Channel1_IRQHandler
  /* ... (Khai báo thêm các ngắt UART, SPI, I2C nếu project cần) ... */

/* =========================================================================
   3. HÀM RESET_HANDLER: ĐÃ TỐI ƯU GỌI SYSTEMINIT ĐẦU TIÊN
   ========================================================================= */
  .section .text.Reset_Handler /* Tạo 1 section tên là .text.Reset_Handler */
  .weak Reset_Handler 
  /* Khai báo dạng weak - Liên kết yếu: 
  + Nếu không có định nghĩa khác cho R_H thì nó dùng luôn 
  + Nếu có viết 1 hàm R_H riêng, thì nó ghi đè lên weak này
  => Phục vụ tự ý viết 1 hàm R_H riêng
  */
  .type Reset_Handler, %function /* Loại hàm */

Reset_Handler:
  /* Setup Stack Pointer ban đầu (đề phòng) */
  ldr sp, =_estack

  /* --- ÉP XUNG LÊN 72MHZ NGAY LẬP TỨC --- */
  /* Gọi SystemInit cấu hình Clock trước để các bước dọn dẹp sau chạy nhanh hơn */
  bl SystemInit

  /* --- BƯỚC A: Copy data từ Flash sang RAM --- */
  ldr r0, =_sdata /* R0: Địa chỉ bắt đầu của .data ở RAM */
  ldr r1, =_edata /* R1: Địa chỉ kết thúc của .data ở RAM */
  ldr r2, =_la_data /* R2: Địa chỉ bắt đầu vùng .data ở Flash cũ */

CopyDataInit:
  cmp r0, r1 /* Check copy xong chưa: R0 sẽ run cho đến khi R0 = R1 */
  beq ZeroBssInit /* Rồi thì sang BSS */
  ldr r3, [r2], #4  /* Lấy data từ R2 nạp vào thanh ghi R3 */
  str r3, [r0], #4 /* Lấy data từ R3 nạp vào R0 */
  b CopyDataInit

  /* --- BƯỚC B: Dọn rác vùng BSS (điền toàn số 0) --- */
ZeroBssInit:
  ldr r0, =_sbss
  ldr r1, =_ebss
  mov r2, #0

FillZeroBss:
  cmp r0, r1
  beq CallMain
  str r2, [r0], #4
  b FillZeroBss

  /* --- BƯỚC C: Chạy vào Main --- */
CallMain:
  bl main         /* Chính thức nhảy vào code C của bạn */

LoopForever:
  b LoopForever   /* Bẫy an toàn: Nếu main() lỡ bị thoát, kẹt lại ở đây */

  .size Reset_Handler, .-Reset_Handler

/* =========================================================================
   4. DEFAULT HANDLER & WEAK ALIAS: LƯỚI AN TOÀN CHO NGẮT
   ========================================================================= */
  .section .text.Default_Handler
  .type Default_Handler, %function

Default_Handler:
  b Default_Handler  /* Vòng lặp vô hạn báo lỗi */

  .size Default_Handler, .-Default_Handler

  /* Gán liên kết yếu cho các ngắt */
  .weak NMI_Handler
  .thumb_set NMI_Handler, Default_Handler

  .weak HardFault_Handler
  .thumb_set HardFault_Handler, Default_Handler

  .weak SysTick_Handler
  .thumb_set SysTick_Handler, Default_Handler

  .weak EXTI0_IRQHandler
  .thumb_set EXTI0_IRQHandler, Default_Handler

  /* Thêm các thumb_set tương ứng cho các ngắt khai báo ở Vector Table */
  /*
    Công thức chung: .weak A_Handler
                     .thumb_set A_Handler, Default_Handler
    
    Khai báo dạng weak, để định nghĩa lại hàm A_Handler
    .thumb_set cho biết A_Handler sẽ được set cùng địa chỉ vs Default_Handler 
    và CPU sẽ gọi Default_Handler thay vì gọi A_Handler

    Default_Handler giống như một cái "Phòng chờ chung" của tòa nhà. 
    Bất kỳ vị khách nào (Ngắt) đến gõ cửa mà chủ nhà (bạn) không có hàm tiếp đón riêng, 
    thì bảo vệ sẽ lùa hết vào cái phòng chờ đó ngồi vĩnh viễn,
    cấm không cho chạy rông phá hoại trong tòa nhà!
  */