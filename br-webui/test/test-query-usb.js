var express = require('express');
var app = express();
const child_process = require('child_process');
app.use(express.static('public'));
console.log("starting test server");

var COMPANION_DIR = "../.."
var server = app.listen(2770, function() {
	var host = server.address().address;
	var port = server.address().port;
	console.log("App running at http://%s:%s", host, port);
	
	var cmd = child_process.exec('git describe --tags', function(error, stdout, stderr) {
		console.log('Companion version: ', stdout);
	});
	
	var cmd = child_process.exec('git rev-parse HEAD', function(error, stdout, stderr) {
		console.log('Git revision: ', stdout);
	});
});


app.get("/udevadm", function(req, res) {
    var pattern = "";
    if (req.query.pattern) {
        pattern = "--pattern=" + req.query.pattern;
	}
	
	var result = child_process.execSync("python3 " + COMPANION_DIR + "/tools/query-usb.py --indent=2 " + pattern);

	res.send(result.toString());
});
