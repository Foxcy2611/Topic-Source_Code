import subprocess
import re
from datetime import datetime
import time 
import sys

#Logic: CLK - PA5 - D0 ; CS - PA4 - D2 ; MOSI - PA7 - D1
def read_spi_headless():
    print("📡 Đang ra lệnh đo SPI (16MHz) trong 60 giây...")
    print("🔴 ĐANG DÙNG CƠ CHẾ TIMEOUT TỰ ĐỘNG BẮT GÓI TIN ĐỘ DÀI ĐỘNG... (Bấm Ctrl+C để dừng)\n")
    
    cmd = [
        "sigrok-cli", 
        "-d", "fx2lafw",
        "--config", "samplerate=16M", 
        "--time", "60s",
        "-C", "D0,D1,D2", 
        "-P", "spi:clk=D0:mosi=D1:cs=D2",
        "-A", "spi=mosi-data"
    ]

    filename = "spi_log.txt"
    start_time_str = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    with open(filename, "a", encoding="utf-8") as file:
        file.write(f"\n[{start_time_str}] BẮT ĐẦU PHIÊN ĐO SPI (ĐỘ DÀI ĐỘNG):\n")
        file.write(f"{'GÓI TIN':<8} | {'ĐỘ DÀI':<8} | {'T/G GỬI':<12} | HEX DATA\n")
        file.write("-" * 65 + "\n")

    packet_count = 0  
    current_chunk = []
    
    # --- CÁC BIẾN CHO CƠ CHẾ TIMEOUT ---
    TIMEOUT_NS = 50_000_000  # Quy định khoảng lặng 50ms (50 triệu nano-giây)
    last_byte_time_ns = 0    # Thời điểm nhận được byte gần nhất
    packet_start_ns = 0      # Thời điểm nhận byte đầu tiên của gói

    try:
        process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        for line in iter(process.stdout.readline, ''):
            line = line.strip()
            if not line: continue
            
            match = re.search(r'([0-9a-fA-F]{2})\b', line)
            if match:
                hex_val = f"0x{match.group(1).upper()}"
                now_ns = time.perf_counter_ns()
                
                # NẾU CÓ KHOẢNG LẶNG > 50ms -> CHỐT ĐƠN GÓI TIN CŨ!
                if len(current_chunk) > 0 and (now_ns - last_byte_time_ns) > TIMEOUT_NS:
                    # Tính thời gian từ byte đầu đến byte cuối của gói vừa chốt
                    duration_ms = (last_byte_time_ns - packet_start_ns) / 1_000_000.0
                    hex_str = " ".join(current_chunk)
                    byte_count = len(current_chunk)
                    
                    # In kết quả
                    print(f"👉 Packet #{packet_count:<4} | Dài: {byte_count} byte | Gui mat: {duration_ms:>6.3f} ms | Data: [ {hex_str} ]")
                    
                    with open(filename, "a", encoding="utf-8") as file:
                        file.write(f"#{packet_count:<7} | {byte_count} byte | {duration_ms:>8.3f} ms | {hex_str}\n")
                    
                    # Reset rổ để chuẩn bị cho gói mới
                    current_chunk = []
                    packet_count += 1

                # Nếu rổ đang trống, đây chính là byte đầu tiên của gói tin mới
                if len(current_chunk) == 0:
                    packet_start_ns = now_ns
                    
                # Gắp byte vào rổ và cập nhật thời gian
                current_chunk.append(hex_val)
                last_byte_time_ns = now_ns

        process.stdout.close()
        process.wait() 

    except KeyboardInterrupt:
        print(f"\n🛑 Đã dừng thủ công! Bắt được {packet_count} gói tin.")
        process.terminate()

if __name__ == "__main__":
    read_spi_headless()
