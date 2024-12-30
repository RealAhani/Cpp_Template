#  allways first build the desktop version for creating compile_commands.json
cmake --preset "arm64-v8a"
cmake --build --preset "arm64-v8a"

cmake --preset "armeabi-v7a"
cmake --build --preset "armeabi-v7a"

cmake --preset "x86_64"
cmake --build --preset "x86_64"

cmake --preset "x86"
cmake --build --preset "x86"

cmake --preset "Build-App"
cmake --build --preset "Build-App"
rm -rf ./build/Darwin/Other/Android/Build-App

adb install -r ./build/Darwin/Other/Android/App/bin/game.final.apk