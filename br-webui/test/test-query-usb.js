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
    res.sendFile(path.join(__dirname + "/test-query-usb.html"));
});

app.get("/udevadm", function(req, res) {
    var pattern = "";
    if (req.query.pattern) {
        pattern = "--pattern=" + req.query.pattern;
    }
    console.log("got request for query:" + req.query.pattern);
    
    var result = child_process.execSync("python3 " + COMPANION_DIR + "/tools/query-usb.py --indent=2 " + pattern);
    res.setHeader('Content-Type', 'application/json');
    res.send(result.toString());
});
