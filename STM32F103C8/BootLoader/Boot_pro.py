import serial
import time
import sys
import os
import math

# --- CẤU HÌNH ---
PORT = 'COM8'          # Cổng COM 
BAUD = 115200
PAGE_SIZE = 1024       # STM32F103 Page Size = 1KB
CHUNK_SIZE = 128       # Gói tin nạp 128 bytes

# --- GIAO THỨC (PROTOCOL) ---
FRAME_HEADER = 0xAA
FRAME_STOP   = 0xBB
CMD_ERASE    = 0x01
CMD_WRITE    = 0x02
CMD_READ     = 0x03
CMD_JUMP     = 0x04

ACK          = 0x06
NACK         = 0x15

class BootloaderTool:
    def __init__(self, port, baud):
        try:
            # Timeout 2s để chờ các lệnh lâu như Erase
            self.ser = serial.Serial(port, baud, timeout=2.0)
            print(f"[INIT] Da ket noi {port} @ {baud}")
        except Exception as e:
            print(f"[LOI] Khong mo duoc cong COM: {e}")
            sys.exit(1)

    def calculate_crc(self, cmd, length, payload):
        crc = cmd + length
        for b in payload:
            crc += b
        return crc & 0xFF

    def int_to_bytes(self, val, num_bytes):
        res = []
        for i in range(num_bytes):
            res.append((val >> (8*i)) & 0xFF)
        return res

    def send_packet(self, cmd, payload, verbose=True):
        # Luôn xóa buffer nhận trước khi gửi lệnh mới để tránh đọc phải rác cũ
        self.ser.reset_input_buffer()

        length = len(payload)
        crc = self.calculate_crc(cmd, length, payload)
        packet = [FRAME_HEADER, cmd, length] + payload + [crc, FRAME_STOP]
        
        self.ser.write(bytearray(packet))
        
        # Đợi phản hồi
        resp = self.ser.read(1)
        if not resp:
            if verbose: print(f" -> [TIMEOUT] Khong co phan hoi lenh {cmd:02X}")
            return False
        
        if resp[0] == ACK:
            return True
        elif resp[0] == NACK:
            if verbose: print(f" -> [NACK] Chip bao loi (CRC sai hoac Flash loi)")
            return False
        else:
            if verbose: print(f" -> [???] Nhan duoc byte la: {resp[0]:02X}")
            return False

    # --- TÍNH NĂNG 1: XÓA FLASH ---
    def auto_erase(self, start_addr, data_len):
        num_pages = math.ceil(data_len / PAGE_SIZE)
        print(f"\n[1/2] DANG XOA FLASH ({num_pages} trang)...")
        
        for i in range(num_pages):
            page_addr = start_addr + (i * PAGE_SIZE)
            payload = self.int_to_bytes(page_addr, 4)
            
            print(f" -> Erasing Page {i+1}/{num_pages} @ {hex(page_addr)}...", end="")
            success = self.send_packet(CMD_ERASE, payload, verbose=False)
            
            if success:
                print(" [OK]")
                # Nghỉ nhẹ 50ms để Flash kịp nguội/xóa cờ bận
                time.sleep(0.05) 
            else:
                print(" [FAIL]")
                return False
        return True

    # --- TÍNH NĂNG 2: NẠP FIRMWARE (Cốt lõi) ---
    def flash_process(self, filename, start_addr):
        if not os.path.exists(filename):
            print(f"Loi: Khong tim thay file '{filename}'")
            return

        with open(filename, "rb") as f:
            file_data = f.read()
        
        file_len = len(file_data)
        if file_len == 0: return

        # BƯỚC A: XÓA FLASH
        if not self.auto_erase(start_addr, file_len):
            print("Xoa Flash that bai -> HUY NAP.")
            return

        # BƯỚC B: GHI DATA
        print(f"\n[2/2] DANG NAP FIRMWARE...")
        total_packets = math.ceil(file_len / CHUNK_SIZE)
        current_addr = start_addr
        start_time = time.time()

        for i in range(total_packets):
            offset = i * CHUNK_SIZE
            chunk = file_data[offset : offset + CHUNK_SIZE]
            
            payload = self.int_to_bytes(current_addr, 4) + list(chunk)
            
            success = self.send_packet(CMD_WRITE, payload, verbose=False)
            
            percent = ((i + 1) / total_packets) * 100
            print(f"\r -> Writing: {percent:.1f}% | Pkt: {i+1}/{total_packets}", end="")
            
            if not success:
                print(f"\n[LOI] Ghi that bai tai goi thu {i+1}!")
                return

            current_addr += len(chunk)

        duration = time.time() - start_time
        print(f"\n\n[THANH CONG] Nap xong trong {duration:.2f}s!")
        
        # Auto Jump sau khi nạp xong
        print(" -> Tu dong Jump to App...")
        self.send_packet(CMD_JUMP, self.int_to_bytes(start_addr, 4))

    # --- TÍNH NĂNG 3: SEAMLESS UPDATE (OTA - Chức năng mới) ---
    def task_seamless_update(self):
        print("\n--- CHE DO CAP NHAT TU DONG (OTA) ---")
        filename = input("Nhap ten file .bin: ").strip().replace('"', '')
        
        addr_input = input("Start App Address (Enter=08004000): ").strip()
        start_addr = 0x08004000 if addr_input == "" else int(addr_input.replace("0x", ""), 16)

        # 1. Gửi lệnh Reset cho App
        print("\n[OTA 1/3] Gui lenh Reset App (0x99)...")
        self.ser.write(bytes([0x99])) # Gửi byte thô 0x99
        
        # 2. Chờ STM32 khởi động lại vào Bootloader
        print("[OTA 2/3] Dang cho Chip khoi dong lai (2s)...")
        time.sleep(2.0) 
        
        # Quan trọng: Xóa rác trong buffer (vì Bootloader khởi động sẽ gửi lời chào)
        self.ser.reset_input_buffer()

        # 3. Bắt đầu nạp
        print("[OTA 3/3] Bat dau quy trinh nap...")
        self.flash_process(filename, start_addr)

    # --- TÍNH NĂNG CŨ: Nạp thủ công (Nếu Chip đang ở Bootloader sẵn) ---
    def task_manual_flash(self):
        filename = input("\nNhap ten file .bin: ").strip().replace('"', '')
        addr_input = input("Start App Address (Enter=08004000): ").strip()
        start_addr = 0x08004000 if addr_input == "" else int(addr_input.replace("0x", ""), 16)
        
        self.flash_process(filename, start_addr)

    # --- TÍNH NĂNG READ ---
    def task_read(self):
        try:
            addr_str = input("Read Addr (Hex): ").replace("0x", "")
            address = int(addr_str, 16)
            size = int(input("Len (Dec): "))
            
            payload = self.int_to_bytes(address, 4) + self.int_to_bytes(size, 2)
            
            if self.send_packet(CMD_READ, payload):
                print(f" -> Reading {size} bytes...")
                data = self.ser.read(size)
                if len(data) == size:
                    print(f" -> DATA (Hex): {data.hex().upper()}")
                else:
                    print(f" -> [LOI] Thieu du lieu ({len(data)}/{size})")
        except:
            print("Loi nhap lieu.")

# --- MENU CHÍNH ---
if __name__ == "__main__":
    tool = BootloaderTool(PORT, BAUD)
    
    while True:
        print("\n=== TOOL NAP BOOTLOADER V_OTA ===")
        print("1. OTA UPDATE (App -> Reset -> Boot -> Flash)")
        print("2. Manual Flash (Chip da o Bootloader)")
        print("3. Read Memory")
        print("4. Jump Only")
        print("0. Thoat")
        
        c = input("Chon chuc nang: ")
        if c == '1':
            tool.task_seamless_update()
        elif c == '2':
            tool.task_manual_flash()
        elif c == '3':
            tool.task_read()
        elif c == '4':
            addr = input("Address (Enter=08004000): ")
            addr = 0x08004000 if addr == "" else int(addr, 16)
            tool.send_packet(CMD_JUMP, tool.int_to_bytes(addr, 4))
            print("Jump sent.")
        elif c == '0':
            break