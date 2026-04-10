import subprocess
import time
from datetime import datetime

# PA1 - D5

def read_dht11_headless():
    print("📡 Đang ra lệnh đo DHT11 (4MHz) trên chân D5 trong 60 giây...")
    print("🔴 CHỈ HIỂN THỊ THỜI GIAN THU 1 BẢN TIN... Bấm Ctrl+C để dừng\n")
    
    cmd = [
        "sigrok-cli", 
        "-d", "fx2lafw",
        "--config", "samplerate=4M", 
        "--time", "60s",
        "-C", "D5", 
        "-P", "am230x:sda=D5:device=dht11",
        "-A", "am230x=humidity:temperature:checksum"
    ]

    filename = "dht11_log.txt"
    start_time_str = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    with open(filename, "a", encoding="utf-8") as file:
        file.write(f"\n[{start_time_str}] BẮT ĐẦU PHIÊN ĐO DHT11 (Chân D5):\n")
        file.write(f"{'GÓI TIN':<8} | {'THỜI GIAN THU':<15} | {'NHIỆT ĐỘ':<10} | {'ĐỘ ẨM':<10} | TRẠNG THÁI\n")
        file.write("-" * 75 + "\n")

    packet_count = 0  
    temp_val = "N/A"
    humi_val = "N/A"
    checksum_val = "N/A"
    has_data = False
    
    TIMEOUT_NS = 50_000_000  # 50ms 
    last_byte_time_ns = 0    
    packet_start_ns = 0      

    def flush_packet():
        nonlocal packet_count, temp_val, humi_val, checksum_val, has_data
        nonlocal packet_start_ns, last_byte_time_ns
        
        # Tính thời gian từ dòng log đầu tiên đến dòng log cuối cùng của gói
        duration_ms = (last_byte_time_ns - packet_start_ns) / 1_000_000.0

        print(f"👉 Packet #{packet_count:<4} | Thu mất: {duration_ms:>6.3f} ms | 🌡️ {temp_val:<8} | 💧 {humi_val:<8} | 🔐 {checksum_val}")
        
        with open(filename, "a", encoding="utf-8") as file:
            file.write(f"#{packet_count:<7} | {duration_ms:>8.3f} ms    | {temp_val:<10} | {humi_val:<10} | {checksum_val}\n")
            
        temp_val = "N/A"
        humi_val = "N/A"
        checksum_val = "N/A"
        packet_count += 1
        has_data = False

    try:
        process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        for line in iter(process.stdout.readline, ''):
            line = line.strip()
            if not line: continue
            
            if "am230x" in line.lower():
                now_ns = time.perf_counter_ns()
                
                if has_data and (now_ns - last_byte_time_ns) > TIMEOUT_NS:
                    flush_packet()
                
                if not has_data:
                    packet_start_ns = now_ns
                    has_data = True
                
                val = line.split(':', 1)[-1].strip()
                if "temperature" in line.lower():
                    temp_val = val
                elif "humidity" in line.lower():
                    humi_val = val
                elif "checksum" in line.lower():
                    checksum_val = val
                    
                last_byte_time_ns = now_ns

        process.stdout.close()
        process.wait() 
        
        if has_data:
            flush_packet()

    except KeyboardInterrupt:
        print(f"\n🛑 Đã dừng thủ công! Bắt được {packet_count} gói tin.")
        process.terminate()

if __name__ == "__main__":
    read_dht11_headless()
