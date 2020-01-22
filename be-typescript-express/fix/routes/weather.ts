import {Request, Response, Router} from "express";
const weatherRouter: Router = Router();

weatherRouter.post("/", (req, res) => {
    // handle request here
    res.sendStatus(200);
});
weatherRouter.get("/", (req, res) => {
    // handle request here
    res.send("You are my sunshine!");
});

export default weatherRouter;
