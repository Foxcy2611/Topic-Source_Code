import subprocess
import re
from datetime import datetime
import time 
import sys

#Logic D7

def read_uart_headless():
    print("📡 Đang ra lệnh đo UART (115200 baud) trên chân D7 trong 60 giây...")
    print("🔴 CHỈ HIỂN THỊ THỜI GIAN THU 1 BẢN TIN... Bấm Ctrl+C để dừng\n")
    
    cmd = [
        "sigrok-cli", 
        "-d", "fx2lafw",
        "--config", "samplerate=16M", 
        "--time", "60s",
        "-C", "D7", 
        "-P", "uart:baudrate=115200:tx=D7:format=hex",
        "-A", "uart=tx-data"
    ]

    filename = "uart_log.txt"
    start_time_str = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    with open(filename, "a", encoding="utf-8") as file:
        file.write(f"\n[{start_time_str}] BẮT ĐẦU PHIÊN ĐO UART (115200 Baud):\n")
        file.write(f"{'GÓI TIN':<8} | {'ĐỘ DÀI':<8} | {'THỜI GIAN THU':<15} | HEX DATA (TX)\n")
        file.write("-" * 65 + "\n")

    packet_count = 0  
    current_chunk = []
    
    TIMEOUT_NS = 50_000_000  # Khoảng lặng 50ms 
    last_byte_time_ns = 0    
    packet_start_ns = 0      

    def flush_packet():
        nonlocal packet_count, current_chunk, packet_start_ns, last_byte_time_ns
        
        if len(current_chunk) > 0:
            # Tính thời gian từ byte đầu đến byte cuối của gói
            duration_ms = (last_byte_time_ns - packet_start_ns) / 1_000_000.0
            
            byte_count = len(current_chunk)
            hex_str = " ".join(current_chunk)
            
            # In ra Terminal siêu gọn
            print(f"👉 Packet #{packet_count:<4} | Dài: {byte_count:02d} | Thu mất: {duration_ms:>6.3f} ms | [ {hex_str} ]")
            
            with open(filename, "a", encoding="utf-8") as file:
                file.write(f"#{packet_count:<7} | {byte_count:<8} | {duration_ms:>8.3f} ms    | {hex_str}\n")
            
            current_chunk = []
            packet_count += 1

    try:
        process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        for line in iter(process.stdout.readline, ''):
            line = line.strip()
            if not line: continue
            
            match = re.search(r'([0-9a-fA-F]{2})$', line)
            if match:
                hex_val = f"0x{match.group(1).upper()}"
                now_ns = time.perf_counter_ns()
                
                if len(current_chunk) > 0 and (now_ns - last_byte_time_ns) > TIMEOUT_NS:
                    flush_packet()

                if len(current_chunk) == 0:
                    packet_start_ns = now_ns
                    
                current_chunk.append(hex_val)
                last_byte_time_ns = now_ns

        process.stdout.close()
        process.wait() 
        
        if len(current_chunk) > 0:
            flush_packet()

    except KeyboardInterrupt:
        print(f"\n🛑 Đã dừng thủ công! Bắt được {packet_count} gói tin.")
        process.terminate()

if __name__ == "__main__":
    read_uart_headless()
