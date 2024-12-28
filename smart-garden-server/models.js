const mongoose = require("mongoose");

const Dht11Schema = new mongoose.Schema({
  temperature: Number,
  humidity: Number,
  created_at: { type: Date, default: Date.now },
});
const Dht11 = mongoose.model("Dht11", Dht11Schema);

const LightSchema = new mongoose.Schema({
  is_light: Boolean,
  created_at: { type: Date, default: Date.now },
});
const Light = mongoose.model("Light", LightSchema);

const PlantSchema = new mongoose.Schema({
  name: String,
  description: String,
  created_at: { type: Date, default: Date.now },
  is_auto: Boolean,
  water_days_per_week: Number,
  plant_days: Number,
  light_percent_per_day: Number,
  start_time: { type: String, default: "00:00" },
  image_url: { type: String },
  valve: { type: Number },
  duration_time: {
    type: String,
    default: "00:15:00",
    required: true,
    validate: {
      validator: function (v) {
        return /^([01]?[0-9]|2[0-3]):([0-5]?[0-9]):([0-5]?[0-9])$/.test(v);
      },
      message: (props) =>
        `${props.value} is not a valid duration format (HH:mm:ss)!`,
    },
  },
  watering_days: {
    monday: { type: Boolean, default: false },
    tuesday: { type: Boolean, default: false },
    wednesday: { type: Boolean, default: false },
    thursday: { type: Boolean, default: false },
    friday: { type: Boolean, default: false },
    saturday: { type: Boolean, default: false },
    sunday: { type: Boolean, default: false },
  },
});
const Plant = mongoose.model("Plant", PlantSchema);

// PlantSchema.methods.shouldPumpBeRunning = function () {
//   if (!this.is_auto || !this.pump_settings.is_active) {
//     return false;
//   }

//   const now = new Date();
//   const currentDay = now.toLocaleString("en-US", { weekday: "long" });

//   // Check if pumping is scheduled for current day
//   if (!this.pump_settings.days_of_week.includes(currentDay)) {
//     return false;
//   }

//   // Parse start time
//   const [startHour, startMinute] = this.pump_settings.start_time
//     .split(":")
//     .map(Number);
//   const startTime = new Date(now);
//   startTime.setHours(startHour, startMinute, 0);

//   // Calculate end time
//   const endTime = new Date(startTime);
//   endTime.setMinutes(
//     endTime.getMinutes() + this.pump_settings.duration_minutes
//   );

//   // Check if current time is within pump duration
//   return now >= startTime && now < endTime;
// };

const MoistureSchema = new mongoose.Schema({
  plant_id: { type: mongoose.Schema.Types.ObjectId, ref: "Plant" },
  moisture: Number,
  created_at: { type: Date, default: Date.now },
});
const Moisture = mongoose.model("Moisture", MoistureSchema);

const ValveSchema = new mongoose.Schema({
  plant_id: { type: mongoose.Schema.Types.ObjectId, ref: "Plant" },
  is_open: Boolean,
  created_at: { type: Date, default: Date.now },
});
const Valve = mongoose.model("Valve", ValveSchema);

module.exports = { Dht11, Light, Plant, Moisture: Moisture, Valve };
