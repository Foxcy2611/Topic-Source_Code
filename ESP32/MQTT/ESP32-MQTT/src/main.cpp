#include <Arduino.h>
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <DHT.h>

// 1. Define chân DHT11
#define DHT_PIN 13
#define DHT_TYPE DHT11
#define LED_PIN 14

// 2. Thông tin WIFI
const char* ssid = "Phuong Thuy 2";
const char* password = "colamthimoicoan";

// 3. Thông tin MQTT HiveMQ
const char* mqtt_URL = "31bcdc67fe6b433dab43faffbb1d8990.s1.eu.hivemq.cloud";
const int mqtt_PORT = 8883;

// 4. Thông tin User MQTT
const char* mqtt_user = "MQTT_Send";
const char* mqtt_pass = "ESP32_topic";

// 5. Topic để gửi dữ liệu
const char* topic_pub = "ptit/sensor/tmp";
const char* topic_sub = "ptit/control/led";
DHT dht(DHT_PIN, DHT_TYPE);
WiFiClientSecure espClient;
PubSubClient client(espClient);

unsigned long lastMsg = 0;

void setup_wifi(){
  delay(10);
  Serial.println();
  Serial.print("Dang ket noi WiFi: ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi da ket noi!");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}

void reconnect() {
  // Lặp lại cho đến khi kết nối lại được
  while (!client.connected()) {
    Serial.print("Dang ket noi MQTT...");
    
    // Tạo một ID ngẫu nhiên để không bị đá connection
    String clientId = "ESP32Client-";
    clientId += String(random(0xffff), HEX);

    // Thử kết nối
    if (client.connect(clientId.c_str(), mqtt_user, mqtt_pass)) {
      Serial.println("Da ket noi!");

      client.subscribe(topic_sub);
      Serial.println("Da dang ky topic: ptit/control/led");

    } else {
      Serial.print("Loi, rc=");
      Serial.print(client.state());
      Serial.println(" thu lai sau 5 giay");
      delay(5000);
    }
  }
}

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Co tin nhan tu topic: ");
  Serial.println(topic);

  Serial.print("Noi dung: ");
  String message = "";
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  Serial.println(message);

  // Xử lý bật tắt đèn
  if (message == "1" || message == "on") {
    digitalWrite(LED_PIN, HIGH); // Bật đèn (Lưu ý: 1 số mạch ESP32 logic ngược thì là tắt)
    Serial.println("-> DA BAT DEN");
  } 
  else if (message == "0" || message == "off") {
    digitalWrite(LED_PIN, LOW);  // Tắt đèn
    Serial.println("-> DA TAT DEN");
  }
}

void setup(){
  Serial.begin(115200);
  dht.begin();
  setup_wifi();
  pinMode(LED_PIN, OUTPUT);
  // Cấu hình SSL (Quan trọng cho HiveMQ Cloud)
  // setInsecure nó giúp bỏ qua bước check chứng chỉ CA phức tạp
  espClient.setInsecure();
  client.setServer(mqtt_URL, mqtt_PORT);
  // Kích hoạt hàm Callback
  client.setCallback(callback);
}

void loop(){
  if(!client.connected()){
    reconnect();
  }
  client.loop();

  unsigned long now = millis();
  
  if(now - lastMsg > 2000){
    lastMsg = now;

    float t = dht.readTemperature();
    float h = dht.readHumidity();

    if(isnan(h) || isnan(t)){
      Serial.println("Loi doc cam bien DHT!");
      return;
    }

    String payload = "{\"temp\": " + String(t) + ", \"hum\": " + String(h) + "}";  
    // Serial.print("Dang gui: ");
    // Serial.println(payload);

    client.publish(topic_pub, payload.c_str());
  }
}