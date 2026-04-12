#include <Arduino.h>
#include <ESP32Servo.h>

const int led_pin = 12;
const int servo_pin = 13;

TaskHandle_t ledTask;
TaskHandle_t servoTask;

void TaskBlinkLed(void *pvParameters){
    pinMode(led_pin, OUTPUT);

    while(1){
        digitalWrite(led_pin, HIGH);
        vTaskDelay(500 / portTICK_PERIOD_MS);
        digitalWrite(led_pin, LOW);
        vTaskDelay(500 / portTICK_PERIOD_MS);
    }
}

void TaskSpinServo(void *pvParameters){
    Servo sv;
    sv.attach(servo_pin);

    while(1){
        sv.write(0);
        vTaskDelay(500 / portTICK_PERIOD_MS);
        sv.write(90);
        vTaskDelay(500 / portTICK_PERIOD_MS);
        sv.write(180);
        vTaskDelay(500 / portTICK_PERIOD_MS);
        sv.write(90);  
        vTaskDelay(500 / portTICK_PERIOD_MS);
    }
}

void setup(){
    xTaskCreate (
        TaskBlinkLed,
        "Blink_LED",
        2048,           
        NULL,
        2,
        &ledTask
    );

    xTaskCreate(
        TaskSpinServo,
        "Spin_Servo",
        2048,          
        NULL,
        3, 
        &servoTask
    );
}

void loop(){

}