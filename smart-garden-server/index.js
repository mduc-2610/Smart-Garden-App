const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const cors = require("cors");
const { Dht11, Light, Plant, Moisture, Valve } = require("./models");

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(cors());

const paginateResults = async (model, req, customQuery = {}) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.page_size) || 10;
  const skip = (page - 1) * limit;

  const order = req.query.order === "asc" ? 1 : -1; 

  const total = await model.countDocuments(customQuery);
  const data = await model
    .find(customQuery)
    .skip(skip)
    .limit(limit)
    .sort({ createdAt: order }); 
  const pages = Math.ceil(total / limit);
  const next =
    page < pages
      ? `${req.baseUrl}?page=${page + 1}&page_size=${limit}&order=${
          req.query.order || "desc"
        }`
      : null;
  const previous =
    page > 1
      ? `${req.baseUrl}?page=${page - 1}&page_size=${limit}&order=${
          req.query.order || "desc"
        }`
      : null;

  return {
    count: total,
    next,
    previous,
    results: data,
  };
};

mongoose
  .connect(
    "mongodb+srv://hieu:hieu123456789@cluster0.2vwr5.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0",
    {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    }
  )
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.error("MongoDB connection error:", err));

app.post("/api/dht11", async (req, res) => {
  const data = new Dht11(req.body);
  if (data.humidity == null || data.temperature == null) {
    return res.status(400).send("Error");
  }

  try {
    await data.save();
    res.status(201).send(data);
  } catch (error) {
    res.status(400).send("error");
  }
});
app.post("/api/moisture", async (req, res) => {
  const data = new Moisture(req.body);
  if (data.plant_id == null || data.moisture == null) {
    return res.status(400).send("Error");
  }

  try {
    await data.save();
    res.status(201).send(data);
  } catch (error) {
    res.status(400).send("error");
  }
});

app.post("/api/light", async (req, res) => {
  const data = new Moisture(req.body);
  if (data.is_light == null) {
    return res.status(400).send("Error");
  }

  try {
    await data.save();
    res.status(201).send(data);
  } catch (error) {
    res.status(400).send("error");
  }
});

app.get("/api/dht11", async (req, res) => {
  try {
    const { date, start_time, end_time } = req.query;
    let query = {};

    if (date) {
      const startDate = new Date(date);
      const endDate = new Date(date);

      const startHour = start_time ? parseInt(start_time, 10) : 0;
      const endHour = end_time ? parseInt(end_time, 10) : 23;

      startDate.setHours(startHour, 0, 0, 0);
      endDate.setHours(endHour, 59, 59, 999);

      query = {
        created_at: {
          $gte: startDate,
          $lte: endDate,
        },
      };
    }

    console.log("Query:", JSON.stringify(query, null, 2)); 
    console.log("Date range:", {
      start: query.created_at?.$gte?.toISOString(),
      end: query.created_at?.$lte?.toISOString(),
    });

    const paginatedData = await paginateResults(Dht11, req, query);
    res.status(200).send(paginatedData);
  } catch (error) {
    console.error("Error fetching DHT11 data:", error);
    res.status(500).send({
      error: "An error occurred while fetching data.",
      details: error.message,
    });
  }
});

app.get("/api/latest-dht11", async (req, res) => {
  try {
    const latestData = await Dht11.findOne().sort({ createdAt: -1 });

    if (!latestData) {
      return res.status(404).send({ message: "No data found" });
    }

    res.status(200).send(latestData);
  } catch (error) {
    console.error("Error fetching latest DHT11 data:", error);
    res.status(500).send({
      error: "An error occurred while fetching the latest data.",
      details: error.message,
    });
  }
});

app.get("/api/light", async (req, res) => {
  try {
    const paginatedData = await paginateResults(Light, req);
    res.status(200).send(paginatedData);
  } catch (error) {
    res.status(500).send(error);
  }
});

app.get("/api/plant", async (req, res) => {
  try {
    const paginatedData = await paginateResults(Plant, req);
    res.status(200).send(paginatedData);
  } catch (error) {
    res.status(500).send(error);
  }
});

app.get("/api/plant/:id", async (req, res) => {
  try {
    const plant = await Plant.findById(req.params.id);

    if (!plant) {
      return res.status(404).send({ message: "Plant not found" });
    }

    res.status(200).send(plant);
  } catch (error) {
    if (error.name === "CastError") {
      return res.status(400).send({ message: "Invalid plant ID format" });
    }
    res.status(500).send(error);
  }
});

app.put("/api/plant/:id", async (req, res) => {
  const { id } = req.params;
  const updatedData = req.body;

  try {
    const updatedPlant = await Plant.findByIdAndUpdate(id, updatedData, {
      new: true,
      runValidators: true,
    });

    if (!updatedPlant) {
      return res.status(404).send({ message: "Plant not found" });
    }

    res.status(200).send(updatedPlant);
  } catch (error) {
    if (error.name === "ValidationError") {
      return res.status(400).send({ message: error.message });
    }
    res.status(500).send(error);
  }
});

app.patch("/api/plant/:id", async (req, res) => {
  const { id } = req.params;
  const updatedFields = req.body;

  try {
    const updatedPlant = await Plant.findByIdAndUpdate(
      id,
      { $set: updatedFields },
      {
        new: true,
        runValidators: true,
      }
    );

    if (!updatedPlant) {
      return res.status(404).send({ message: "Plant not found" });
    }

    res.status(200).send(updatedPlant);
  } catch (error) {
    if (error.name === "ValidationError") {
      return res.status(400).send({ message: error.message });
    }
    res.status(500).send(error);
  }
});

app.get("/api/moisture", async (req, res) => {
  try {
    const { date, start_time, end_time, plant_id } = req.query;
    let query = {};

    if (plant_id) {
      query.plant_id = plant_id;
    }

    if (date) {
      const startDate = new Date(date);
      const endDate = new Date(date);

      const startHour = start_time ? parseInt(start_time, 10) : 0;
      const endHour = end_time ? parseInt(end_time, 10) : 23;

      startDate.setHours(startHour, 0, 0, 0);
      endDate.setHours(endHour, 59, 59, 999);

      query.created_at = {
        $gte: startDate,
        $lte: endDate,
      };
    }

    console.log("Query:", JSON.stringify(query, null, 2));
    console.log("Date range:", {
      start: query.created_at?.$gte?.toISOString(),
      end: query.created_at?.$lte?.toISOString(),
      plant_id: query.plant_id,
    });

    const paginatedData = await paginateResults(Moisture, req, query);
    res.status(200).send(paginatedData);
  } catch (error) {
    console.error("Error fetching moisture data:", error);
    res.status(500).send({
      error: "An error occurred while fetching data.",
      details: error.message,
    });
  }
});

app.get("/api/valve", async (req, res) => {
  try {
    const paginatedData = await paginateResults(Valve, req);
    res.status(200).send(paginatedData);
  } catch (error) {
    res.status(500).send(error);
  }
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
