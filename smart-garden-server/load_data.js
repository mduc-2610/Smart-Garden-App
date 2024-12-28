const mongoose = require("mongoose");
const { Plant } = require("./models"); 

async function insertDummyPlants() {
  try {
    await Plant.deleteMany({});
    console.log("Cleared all existing plants from the database.");

    const plants = await Plant.insertMany([
      {
        name: "Xuong rong",
        description: "Robust and dramatic, with no leaves",
        is_auto: true,
        valve: 1,
        water_days_per_week: 4,
        plant_days: 12,
        image_url:
          "https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?q=80&w=2449&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        light_percent_per_day: 65,
        duration_time: "00:01:00",
        start_time: "08:00 AM",
      },
      {
        name: "Sen da",
        description: "Elegant and lush",
        is_auto: true,
        valve: 2,
        water_days_per_week: 3,
        plant_days: 10,
        image_url:
          "https://images.unsplash.com/photo-1509423350716-97f9360b4e09?q=80&w=2535&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        light_percent_per_day: 70,
        duration_time: "00:01:00",
        start_time: "08:00 AM",
      },
    ]);

    console.log("Inserted plants:", plants);
  } catch (err) {
    console.error("Error inserting plants:", err.message);
  } finally {
    mongoose.connection.close(); 
  }
}

mongoose
  .connect(
    "mongodb+srv://hieu:hieu123456789@cluster0.2vwr5.mongodb.net/test?retryWrites=true&w=majority",
    {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    }
  )
  .then(() => {
    console.log("MongoDB connected");
    insertDummyPlants();
  })
  .catch((err) => console.error("MongoDB connection error:", err));
