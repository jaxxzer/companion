rm -rf *.sh
wget https://raw.githubusercontent.com/jaxxzer/companion/setup/scripts/setup.sh
wget https://raw.githubusercontent.com/jaxxzer/companion/setup/scripts/setup-system-files.sh
wget https://raw.githubusercontent.com/jaxxzer/companion/setup/scripts/setup-raspbian.sh
wget https://raw.githubusercontent.com/jaxxzer/companion/setup/scripts/bash-helpers.sh
chmod +x *.sh
./setup.sh

sudo apt -yq update && sudo apt -yq install npm git libv4l-dev
git clone --depth 1 -b setup https://github.com/jaxxzer/companion /home/pi/companion
cd companion/br-webui/
npm install


notes:
npm from apt: 8.11.1

npm install result:
$ npm install
(node:5011) [DEP0022] DeprecationWarning: os.tmpDir() is deprecated. Use os.tmpdir() instead.
 
> v4l2camera@1.0.4 install /home/pi/companion/br-webui/node_modules/v4l2camera
> node-gyp rebuild

make: Entering directory '/home/pi/companion/br-webui/node_modules/v4l2camera/build'
  CC(target) Release/obj.target/v4l2camera/capture.o
  CXX(target) Release/obj.target/v4l2camera/v4l2camera.o
../v4l2camera.cc: In lambda function:
../v4l2camera.cc:300:47: warning: ‘v8::Local<v8::Value> Nan::Callback::Call(v8::Local<v8::Object>, int, v8::Local<v8::Value>*) const’ is deprecated [-Wdeprecated-declarations]
       data->callback->Call(thisObj, 0, nullptr);
                                               ^
In file included from ../v4l2camera.cc:3:0:
../node_modules/nan/nan.h:1652:3: note: declared here
   Call(v8::Local<v8::Object> target
   ^~~~
../v4l2camera.cc: In lambda function:
../v4l2camera.cc:321:61: warning: ‘v8::Local<v8::Value> Nan::Callback::Call(v8::Local<v8::Object>, int, v8::Local<v8::Value>*) const’ is deprecated [-Wdeprecated-declarations]
       data->callback->Call(thisObj, args.size(), args.data());
                                                             ^
In file included from ../v4l2camera.cc:3:0:
../node_modules/nan/nan.h:1652:3: note: declared here
   Call(v8::Local<v8::Object> target
   ^~~~
  SOLINK_MODULE(target) Release/obj.target/v4l2camera.node
  COPY Release/v4l2camera.node
make: Leaving directory '/home/pi/companion/br-webui/node_modules/v4l2camera/build'
-
> nodegit@0.23.0 install /home/pi/companion/br-webui/node_modules/nodegit
> node lifecycleScripts/preinstall && node lifecycleScripts/install

[nodegit] Running pre-install script
[nodegit] npm@2 installed, pre-loading required packages
[nodegit] ERROR - Could not finish preinstall
{ Error: Command failed: npm install --ignore-scripts
(node:5126) [DEP0022] DeprecationWarning: os.tmpDir() is deprecated. Use os.tmpdir() instead.
npm WARN deprecated babel-preset-es2015@6.24.1: 🙌  Thanks for using Babel: we recommend using babel-preset-env now: please read babeljs.io/env to update! 
npm WARN optional dep failed, continuing fsevents@1.2.4
npm ERR! error rolling back Error: ENOTEMPTY: directory not empty, rmdir '/home/pi/companion/br-webui/node_modules/nodegit/node_modules/cheerio/node_modules/htmlparser2/node_modules/domhandler/test/cases'
npm ERR! error rolling back  cheerio@1.0.0-rc.2 { Error: ENOTEMPTY: directory not empty, rmdir '/home/pi/companion/br-webui/node_modules/nodegit/node_modules/cheerio/node_modules/htmlparser2/node_modules/domhandler/test/cases'
npm ERR! error rolling back   errno: -39,
npm ERR! error rolling back   code: 'ENOTEMPTY',
npm ERR! error rolling back   syscall: 'rmdir',
npm ERR! error rolling back   path: '/home/pi/companion/br-webui/node_modules/nodegit/node_modules/cheerio/node_modules/htmlparser2/node_modules/domhandler/test/cases' }
npm ERR! Error: Method Not Allowed
npm ERR!     at errorResponse (/usr/share/npm/lib/cache/add-named.js:260:10)
npm ERR!     at /usr/share/npm/lib/cache/add-named.js:203:12
npm ERR!     at saved (/usr/share/npm/node_modules/npm-registry-client/lib/get.js:167:7)
npm ERR!     at FSReqWrap.oncomplete (fs.js:135:15)
npm ERR! If you need help, you may report this *entire* log,
npm ERR! including the npm and node versions, at:
npm ERR!     <http://github.com/npm/npm/issues>

npm ERR! System Linux 4.14.79-v7+
npm ERR! command "/usr/bin/node" "/usr/bin/npm" "install" "--ignore-scripts"
npm ERR! cwd /home/pi/companion/br-webui/node_modules/nodegit
npm ERR! node -v v8.11.1
npm ERR! npm -v 1.4.21
npm ERR! code E405
npm ERR! tar.unpack untar error /home/pi/.npm/readable-stream/3.1.1/package.tgz
npm ERR! error rolling back Error: ENOTEMPTY: directory not empty, rmdir '/home/pi/companion/br-webui/node_modules/nodegit/node_modules/cheerio/node_modules/htmlparser2/node_modules/domhandler/test/cases'
npm ERR! error rolling back  htmlparser2@3.10.0 { Error: ENOTEMPTY: directory not empty, rmdir '/home/pi/companion/br-webui/node_modules/nodegit/node_modules/cheerio/node_modules/htmlparser2/node_modules/domhandler/test/cases'
npm ERR! error rolling back   errno: -39,
npm ERR! error rolling back   code: 'ENOTEMPTY',
npm ERR! error rolling back   syscall: 'rmdir',
npm ERR! error rolling back   path: '/home/pi/companion/br-webui/node_modules/nodegit/node_modules/cheerio/node_modules/htmlparser2/node_modules/domhandler/test/cases' }
npm ERR! 
npm ERR! Additional logging details can be found in:
npm ERR!     /home/pi/companion/br-webui/node_modules/nodegit/npm-debug.log
npm ERR! not ok code 0

    at ChildProcess.exithandler (child_process.js:275:12)
    at emitTwo (events.js:126:13)
    at ChildProcess.emit (events.js:214:7)
    at maybeClose (internal/child_process.js:925:16)
    at Socket.stream.socket.on (internal/child_process.js:346:11)
    at emitOne (events.js:116:13)
    at Socket.emit (events.js:211:7)
    at Pipe._handle.close [as _onclose] (net.js:567:12)
  killed: false,
  code: 1,
  signal: null,
  cmd: 'npm install --ignore-scripts' }
npm WARN This failure might be due to the use of legacy binary "node"
npm WARN For further explanations, please read
/usr/share/doc/nodejs/README.Debian
 
npm ERR! nodegit@0.23.0 install: `node lifecycleScripts/preinstall && node lifecycleScripts/install`
npm ERR! Exit status 1
npm ERR! 
npm ERR! Failed at the nodegit@0.23.0 install script.
npm ERR! This is most likely a problem with the nodegit package,
npm ERR! not with npm itself.
npm ERR! Tell the author that this fails on your system:
npm ERR!     node lifecycleScripts/preinstall && node lifecycleScripts/install
npm ERR! You can get their info via:
npm ERR!     npm owner ls nodegit
npm ERR! There is likely additional logging output above.

npm ERR! System Linux 4.14.79-v7+
npm ERR! command "/usr/bin/node" "/usr/bin/npm" "install"
npm ERR! cwd /home/pi/companion/br-webui
npm ERR! node -v v8.11.1
npm ERR! npm -v 1.4.21
npm ERR! code ELIFECYCLE
npm ERR! 
npm ERR! Additional logging details can be found in:
npm ERR!     /home/pi/companion/br-webui/npm-debug.log
npm ERR! not ok code 0
