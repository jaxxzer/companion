var express = require('express');
var app = express();
var path = require("path");
const child_process = require('child_process');

var COMPANION_DIR = "../.."

var server = app.listen(2770, function() {
    var host = server.address().address;
    var port = server.address().port;
    console.log("App running at http://%s:%s", host, port);
});

app.get('/', function(req, res) {
    res.sendFile(path.join(__dirname + "/test-query-screens.html"));
});

app.get("/screen", function(req, res) {
    var user = "";
    if (req.query.user) {
        user = "--user=" + req.query.user;
    }
    console.log("got request for screens on user:" + req.query.user);
    
    var result = child_process.execSync("python3 " + COMPANION_DIR + "/tools/query-screens.py --indent=2 " + user);
    res.setHeader('Content-Type', 'application/json');
    res.send(result.toString());
});
