
import bodyParser = require("body-parser");
import weatherRouter from "./routes/weather";
export * from "./greeter";
import * as express from "express";
const app: express.Application = express();

app.use(bodyParser.json({type: "application/json"}));

// register routes to listen to and expose
app.use("/api/weather", weatherRouter);

// initialize the webserver
const port = process.env.PORT || "8080";
app.listen(port, () => {
    // tslint:disable-next-line:no-console
    console.info(`App listening on port ${port}!`);
});
