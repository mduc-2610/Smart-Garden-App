#include "DHT.h"
#include <WiFi.h>
#include <HTTPClient.h>
#include <Arduino_JSON.h>
#include <WebServer.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 32



#define RELAY_PUMP_PIN 25
#define MOISTURE_SENSOR_1_PIN 34
#define MOISTURE_SENSOR_2_PIN 35
#define LIGHT_SENSOR_PIN 26
#define HUMID_TEMP_SENSOR_PIN 27
#define RELAY_VALVE_1_PIN 5
#define RELAY_VALVE_2_PIN 18
#define DHTTYPE DHT11
#define LED_PIN 21

String server_base_url = "https://8zdnvn-3000.csb.app";

DHT dht(HUMID_TEMP_SENSOR_PIN, DHTTYPE);
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1);

enum State {
  ON,
  OFF
};

class ControlDevice {
protected:
  State m_state;
  int m_control_pin;
  String m_device_name;

public:
  ControlDevice(String device_name, int pin, State state)
    : m_device_name(device_name), m_control_pin(pin), m_state(state) {}

  virtual void set_device_state(State state) = 0;

  State get_device_state() const {
    return m_state;
  }
};

class Pump : public ControlDevice {
public:
  Pump(String device_name, int pin, State state)
    : ControlDevice(device_name, pin, state) {
    set_device_state(state);
  }

  void set_device_state(State state) override {
    m_state = state;
    digitalWrite(m_control_pin, (state == ON) ? LOW : HIGH);
    Serial.println(state == ON ? "Bật " + m_device_name : "Tắt " + m_device_name);
  }
};

class Valve : public ControlDevice {
public:
  Valve(String device_name, int pin, State state)
    : ControlDevice(device_name, pin, state) {
    set_device_state(state);
  }

  void set_device_state(State state) override {
    m_state = state;
    digitalWrite(m_control_pin, (state == ON) ? HIGH : LOW);
    Serial.println(state == ON ? "Đóng " + m_device_name : "Mở " + m_device_name);
  }
};

WebServer server(80);

class App {
private:
  bool isAutoValve_1{ true };
  bool isAutoValve_2{ true };
  bool isAutoLed{ true };

  Pump pump{ "Máy bơm", RELAY_PUMP_PIN, OFF };
  Valve valve_1{ "Van 1", RELAY_VALVE_1_PIN, OFF };
  Valve valve_2{ "Van 2", RELAY_VALVE_2_PIN, OFF };
  String plant_1_id{};
  String plant_2_id{};
  const char* ssid = "IpDuc";
  const char* password = "80808080";
  bool is_auto{ true };

public:
  App() {}



  void init() {
      Serial.begin(115200);
    Wire.begin();
    delay(100);
    
    if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
        Serial.println(F("SSD1306 allocation failed"));
        while (1) {
            delay(1000);  // Add delay in infinite loop
            Serial.println("Display init failed - check connections");
        }
    }

    displaySensorData();



    Serial.print("Connecting to WiFi");
    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
    }

    Serial.println("Connected to WiFi!");
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());
    pinMode(RELAY_PUMP_PIN, OUTPUT);
    pinMode(RELAY_VALVE_1_PIN, OUTPUT);
    pinMode(RELAY_VALVE_2_PIN, OUTPUT);
    pinMode(LIGHT_SENSOR_PIN, INPUT);
    pinMode(LED_PIN, OUTPUT);

    pump.set_device_state(OFF);
    valve_1.set_device_state(OFF);
    valve_2.set_device_state(ON);
    dht.begin();
    get_plant_data();
    server.on("/api/esp/light", HTTP_GET, [this]() {
      JSONVar data;
      data["is_light"] = get_light_value() == 1 ? true : false;
      server.send(200, "application/json", JSON.stringify(data));
    });



    server.on("/api/esp/valve/auto", HTTP_GET, [this]() {
      JSONVar data;
      data["valve_1"] = isAutoValve_1;
      data["valve_2"] = isAutoValve_2;
      server.send(200, "application/json", JSON.stringify(data));
    });
    server.on("/api/esp/led/auto", HTTP_GET, [this]() {
      JSONVar data;

      data["led"] = isAutoLed;
      server.send(200, "application/json", JSON.stringify(data));
    });

    server.on("/api/esp/valve", HTTP_GET, [this]() {
      JSONVar data;

      data["valve_1"] = bool(valve_1.get_device_state());
      data["valve_2"] = bool(valve_2.get_device_state());

      server.send(200, "application/json", JSON.stringify(data));
    });

    server.on("/api/esp/valve/auto", HTTP_POST, [this]() {
      String body = server.arg("plain");
      Serial.println(body);

      JSONVar jsonData = JSON.parse(body);
      if (JSON.typeof(jsonData) == "undefined") {
        server.send(400, "text/plain", "Invalid JSON");
        return;
      }

      bool van_1_auto = jsonData["valve_1"];
      bool van_2_auto = jsonData["valve_2"];
      //bool led_auto = jsonData["led"];
      // Serial.println(van_1_auto + " " + van_2_auto + " " +led_auto);
      isAutoValve_1 = van_1_auto;
      isAutoValve_2 = van_2_auto;
      //isAutoLed = led_auto;
      JSONVar data;

      data["valve_1"] = isAutoValve_1;
      data["valve_2"] = isAutoValve_2;
      //data["led"] = isAutoLed;
      server.send(200, "application/json", JSON.stringify(data));
    });

    server.on("/api/esp/led/auto", HTTP_POST, [this]() {
      String body = server.arg("plain");
      Serial.println(body);

      JSONVar jsonData = JSON.parse(body);
      if (JSON.typeof(jsonData) == "undefined") {
        server.send(400, "text/plain", "Invalid JSON");
        return;
      }


      bool led_auto = jsonData["led"];
      // Serial.println(van_1_auto + " " + van_2_auto + " " +led_auto);
      // isAutoValve_1 = van_1_auto;
      // isAutoValve_2 = van_2_auto;
      //isAutoLed = led_auto;
      JSONVar data;

      // data["valve_1"] = isAutoValve_1;
      // data["valve_2"] = isAutoValve_2;
      data["led"] = isAutoLed;
      isAutoLed = led_auto;
      server.send(200, "application/json", JSON.stringify(data));
    });

    server.on("/api/esp/valve", HTTP_POST, [this]() {
      String body = server.arg("plain");
      Serial.println(body);

      JSONVar jsonData = JSON.parse(body);
      if (JSON.typeof(jsonData) == "undefined") {
        server.send(400, "text/plain", "Invalid JSON");
        return;
      }
      bool valve_1_ = bool(jsonData["valve_1"]);
      bool valve_2_ = bool(jsonData["valve_2"]);
      Serial.println(valve_1_);
      Serial.println(valve_2_);

      if (valve_1_) {
        valve_1.set_device_state(OFF);
      } else {
        valve_1.set_device_state(ON);
      }
      if (valve_2_) {

        valve_2.set_device_state(OFF);
      } else {
        valve_2.set_device_state(ON);
      }

      if (valve_1_ || valve_2_) {
        pump.set_device_state(ON);
      } else {
        pump.set_device_state(OFF);
      }

      // if (value_1_ == "true" && valve_1_duration.toInt() > 0){
      //       valve_1.set_device_state(OFF);
      // }
      // if ()

      server.send(200, "application/json", JSON.stringify(jsonData));
    });


    server.on("/api/esp/light", HTTP_POST, [this]() {
      String body = server.arg("plain");
      Serial.println(body);

      JSONVar jsonData = JSON.parse(body);
      if (JSON.typeof(jsonData) == "undefined") {
        server.send(400, "text/plain", "Invalid JSON");
        return;
      }


      bool is_light = jsonData["is_light"];
      if (is_light == false) digitalWrite(LED_PIN, LOW);
      else digitalWrite(LED_PIN, HIGH);
      Serial.println(is_light);


      server.send(200, "application/json", body);  // Thêm dòng này để gửi phản hồi
    });
    server.begin();  // Bắt đầu server
  }

  void displaySensorData() {
    static int x = 10;
    Serial.println("display@@");
    display.clearDisplay();
    display.setTextSize(1);
    display.setTextColor(SSD1306_WHITE);
    display.setCursor(0, 0);
    display.print(F("Moisture 1: "));
    display.println(String(x++));
    display.setTextColor(SSD1306_BLACK, SSD1306_WHITE);
    display.println(3.141592);
    display.setTextSize(1);
    display.setTextColor(SSD1306_WHITE);
    display.print(F("0x"));
    display.println(0xDEADBEEF, HEX);
    display.display();
    // Remove the delay(2000)
  }


  void get_plant_data() {
    if (WiFi.status() == WL_CONNECTED) {
      HTTPClient http;
      http.begin("https://8zdnvn-3000.csb.app/api/plant");
      int httpResponseCode = http.GET();

      if (httpResponseCode > 0) {
        if (httpResponseCode > 0) {
          String response = http.getString();
          Serial.println(httpResponseCode);

          JSONVar jsonData = JSON.parse(response);
          if (JSON.typeof(jsonData) != "undefined") {
            plant_1_id = String(jsonData["results"][0]["_id"]);
            plant_2_id = String(jsonData["results"][1]["_id"]);
            isAutoValve_1 = bool(jsonData["results"][0]["is_auto"]);
            isAutoValve_2 = bool(jsonData["results"][1]["is_auto"]);

            Serial.print("Plant 1 ID: ");
            Serial.println(plant_1_id);
            Serial.print("Plant 2 ID: ");
            Serial.println(plant_2_id);
          } else {
            Serial.println("Failed to parse JSON");
          }
        } else {
          Serial.print("Error on sending GET: ");
          Serial.println(httpResponseCode);
        }
        http.end();
      } else {
        Serial.println("WiFi not connected");
      }
    }
  }
  void run() {

    server.handleClient();
    displaySensorData();

    bool is_valve_1_open{ false };
    bool is_valve_2_open{ false };
    if (isAutoValve_1) {
      is_valve_1_open = monitorMoisture(MOISTURE_SENSOR_1_PIN, valve_1);
    }

    if (isAutoValve_2) {
      is_valve_2_open = monitorMoisture(MOISTURE_SENSOR_2_PIN, valve_2);
    }

    if (isAutoValve_1 || isAutoValve_2) {
      if (is_valve_1_open || is_valve_2_open) {
        pump.set_device_state(ON);
      } else {
        pump.set_device_state(OFF);
      }
    }
    if (isAutoLed) {
      if (get_light_value() == 1) {
        digitalWrite(LED_PIN, HIGH);
      } else {
        digitalWrite(LED_PIN, LOW);
      }
    }
    //displaySensorData();
    // testdrawtriangle();
    //  clearScreenRed();
    //testdrawchar();
    //send_data();
    //print_info();
    delay(1000);
  }


  bool
  monitorMoisture(int sensor_pin, ControlDevice& valve) {
    int moisture_value = get_moisture_value(sensor_pin);

    if (moisture_value < 20) {
      valve.set_device_state(OFF);
      return true;
    } else if (moisture_value >= 30) {
      valve.set_device_state(ON);
      return false;
    }
  }

  int get_moisture_value(int pin) {
    int sensorAnalog = analogRead(pin);
    return (100 - ((sensorAnalog / 4095.0) * 100));
  }
  float get_temperature() {
    return dht.readTemperature();
  }

  float get_humidity() {
    return dht.readHumidity();
  }

  bool get_light_value() {
    return digitalRead(LIGHT_SENSOR_PIN) == 1 ? true : false;
  }

  void send_data() {
    if (WiFi.status() == WL_CONNECTED) {
      HTTPClient http;
      send_dht11(http);
      send_light(http);
      send_moisture(http, plant_1_id, get_moisture_value(MOISTURE_SENSOR_1_PIN));
      send_moisture(http, plant_2_id, get_moisture_value(MOISTURE_SENSOR_2_PIN));
      http.end();
    }
  }

  void send_dht11(HTTPClient& http) {
    http.begin(server_base_url + "/api/dht11");  // Địa chỉ API của bạn
    http.addHeader("Content-Type", "application/json");

    JSONVar dht_data;
    dht_data["temperature"] = get_temperature();
    dht_data["humidity"] = get_humidity();

    int httpResponseCode = http.POST(JSON.stringify(dht_data));

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println(httpResponseCode);
      Serial.println(response);
    } else {
      Serial.print("Error on sending POST: ");
      Serial.println(httpResponseCode);
    }
  }

  // void send_dht11(HTTPClient& http) {
  //   http.begin(server_base_url + "/api/");  // Địa chỉ API của bạn
  //   http.addHeader("Content-Type", "application/json");

  //   JSONVar dht_data;
  //   dht_data["temperature"] = get_temperature();
  //   dht_data["humidity"] = get_humidity();

  //   int httpResponseCode = http.POST(JSON.stringify(dht_data));

  //   // Kiểm tra mã phản hồi
  //   if (httpResponseCode > 0) {
  //     String response = http.getString();
  //     Serial.println(httpResponseCode);  // In ra mã phản hồi
  //     Serial.println(response);          // In ra phản hồi từ server
  //   } else {
  //     Serial.print("Error on sending POST: ");
  //     Serial.println(httpResponseCode);
  //   }
  // }
  void send_light(HTTPClient& http) {
    http.begin(server_base_url + "/api/light");
    http.addHeader("Content-Type", "application/json");

    JSONVar light_data;
    light_data["is_light"] = get_light_value();

    int httpResponseCode = http.POST(JSON.stringify(light_data));

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println(httpResponseCode);
      Serial.println(response);
    } else {
      Serial.print("Error on sending POST: ");
      Serial.println(httpResponseCode);
    }
  }

  void send_moisture(HTTPClient& http, String plant_id, float moisture) {
    http.begin(server_base_url + "/api/moisture");
    http.addHeader("Content-Type", "application/json");

    JSONVar moisture_data;
    moisture_data["plant_id"] = plant_id;
    moisture_data["moisture"] = moisture;

    int httpResponseCode = http.POST(JSON.stringify(moisture_data));

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println(httpResponseCode);
      Serial.println(response);
    } else {
      Serial.print("Error on sending POST: ");
      Serial.println(httpResponseCode);
    }
  }

  void send_plant(HTTPClient& http, String name, String description, bool is_auto) {
    http.begin(server_base_url + "/api/plant");
    http.addHeader("Content-Type", "application/json");

    JSONVar plant_data;
    plant_data["name"] = name;
    plant_data["description"] = description;
    plant_data["is_auto"] = is_auto;

    int httpResponseCode = http.POST(JSON.stringify(plant_data));

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println(httpResponseCode);
      Serial.println(response);
    } else {
      Serial.print("Error on sending POST: ");
      Serial.println(httpResponseCode);
    }
  }

  void send_valve(HTTPClient& http, String plant_id, bool is_open) {
    http.begin(server_base_url + "/api/valve");
    http.addHeader("Content-Type", "application/json");

    JSONVar valve_data;
    valve_data["plant_id"] = plant_id;
    valve_data["is_open"] = is_open;

    int httpResponseCode = http.POST(JSON.stringify(valve_data));

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println(httpResponseCode);
      Serial.println(response);
    } else {
      Serial.print("Error on sending POST: ");
      Serial.println(httpResponseCode);
    }
  }

  void print_info() {
    Serial.print("Moisture Sensor 1: ");
    Serial.println(get_moisture_value(MOISTURE_SENSOR_1_PIN));

    Serial.print("Moisture Sensor 2: ");
    Serial.println(get_moisture_value(MOISTURE_SENSOR_2_PIN));

    Serial.print("Temp: ");
    Serial.println(get_temperature());

    Serial.print("Humidity: ");
    Serial.println(get_humidity());

    Serial.print("Light value: ");
    Serial.println(get_light_value());
  }
};

App app{};

void setup() {
  app.init();
}


void loop() {

  app.run();
}