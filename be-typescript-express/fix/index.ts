export * from "./greeter";
import * as express from "express";
import {Application} from "express";
import bodyParser = require("body-parser");
import weatherRouter from "./routes/weather";
const app: Application = express();

app.use(bodyParser.json({type: "application/json"}));

// register routes to listen to and expose
app.use("/api/weather", weatherRouter);

// initialize the webserver
const port = process.env.PORT || "8080";
app.listen(port, () => {
    console.info(`App listening on port ${port}!`);
});