#!/usr/bin/env bash

# Copyright 2018 Uber Technologies, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex

mkdir -p out
rm -rf h3c

# Clone the core C repo and check out the appropriate tag
git clone https://github.com/uber/h3.git h3c
pushd h3c
git pull origin master --tags
git checkout "v$(cat ../H3_VERSION)"

# Get canonical list of functions the lib should expose
./scripts/binding_functions.sh && cp binding-functions ../out

# Get the list of defined functions the lib actually needs to bind
bound_functions=`node ../build/print-bindings.js`

pushd src/h3lib/lib
# Copy size exports into C code
cp ../../../../build/sizes.h ../include
cp ../../../../build/sizes.c .
# Compile with emscripten
emcc -O3 -I ../include *.c -o libh3.js -DH3_HAVE_VLA -s SINGLE_FILE=1 -s USE_SDL=0 -s INVOKE_RUN=0 -s EXPORT_NAME="'libh3'" -s MODULARIZE=1 -s NO_FILESYSTEM=1 -s NODEJS_CATCH_EXIT=0 -s TOTAL_MEMORY=33554432 -s ALLOW_MEMORY_GROWTH=1 -s WARN_UNALIGNED=1 -s EXPORTED_FUNCTIONS=$bound_functions -s EXTRA_EXPORTED_RUNTIME_METHODS='["cwrap", "getValue", "setValue", "getTempRet0"]' --memory-init-file 0
cp libh3.js ../../../../out/libh3.js
cat << EOF >> ../../../../out/libh3.js
const instantiate = WebAssembly.instantiate;
module.exports = new Promise((resolve, reject) => {
  let h3
  WebAssembly.instantiate = (...args) => new Promise((resolve2, reject2) => {
    instantiate(...args).then((result) => {
      resolve2(result)
      // Regression in latest Emscripten drops these methods, re-attach to the object with proper names
      Object.keys(h3.asmLibraryArg)
        .filter(k => typeof h3.asmLibraryArg[k] === 'function')
        .forEach((k) => {
          h3[h3.asmLibraryArg[k].name] = h3.asmLibraryArg[k];
        });
      // Promise resolution doesn't like a `then` function that self resolves, infinite loop starts
      delete h3.then
      resolve(h3)
      WebAssembly.instantiate = instantiate
    }, (e) => {
      reject(e)
      WebAssembly.instantiate = instantiate
      reject2(e)
    })
  })
  h3 = libh3()
})
EOF
popd
popd
