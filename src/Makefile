ANDROID_OUT=../android/src/main/jniLibs
ANDROID_SDK=$(HOME)/Library/Android/sdk
NDK_BIN=$(ANDROID_SDK)/ndk/23.1.7779620/toolchains/llvm/prebuilt/darwin-x86_64/bin
LIB_NAME=libsum

android-armv7a:
	CGO_ENABLED=1 \
	GOOS=android \
	GOARCH=arm \
	GOARM=7 \
	CC=$(NDK_BIN)/armv7a-linux-androideabi21-clang \
	go build -buildmode=c-shared -o $(ANDROID_OUT)/armeabi-v7a/${LIB_NAME}.so .

android-arm64:
	CGO_ENABLED=1 \
	GOOS=android \
	GOARCH=arm64 \
	CC=$(NDK_BIN)/aarch64-linux-android21-clang \
	go build -buildmode=c-shared -o $(ANDROID_OUT)/arm64-v8a/${LIB_NAME}.so .

android-x86:
	CGO_ENABLED=1 \
	GOOS=android \
	GOARCH=386 \
	CC=$(NDK_BIN)/i686-linux-android21-clang \
	go build -buildmode=c-shared -o $(ANDROID_OUT)/x86/${LIB_NAME}.so .

android-x86_64:
	CGO_ENABLED=1 \
	GOOS=android \
	GOARCH=amd64 \
	CC=$(NDK_BIN)/x86_64-linux-android21-clang \
	go build -buildmode=c-shared -o $(ANDROID_OUT)/x86_64/${LIB_NAME}.so .

ios-x86_64-sim:
	GOARCH=amd64 \
	SDK=iphonesimulator \
	LIB_NAME=${LIB_NAME} \
	./build_ios.sh

ios-arm64-sim:
	GOARCH=arm64 \
	SDK=iphonesimulator \
	LIB_NAME=${LIB_NAME} \
	./build_ios.sh

ios-arm64:
	GOARCH=arm64 \
	SDK=iphoneos \
	LIB_NAME=${LIB_NAME} \
	./build_ios.sh

android: android-armv7a android-arm64 android-x86 android-x86_64

ios: ios-x86_64-sim ios-arm64-sim ios-arm64
	lipo \
    -create \
    ${LIB_NAME}_arm64_iphonesimulator.a \
    ${LIB_NAME}_amd64_iphonesimulator.a \
    -output ${LIB_NAME}_iphonesimulator.a
	rm ${LIB_NAME}_arm64_iphonesimulator.*
	rm ${LIB_NAME}_amd64_iphonesimulator.*

	mkdir -p ios-arm64
	mkdir -p ios-simulator
	mv ./${LIB_NAME}_arm64_iphoneos.a ./ios-arm64/${LIB_NAME}.a
	cp ./${LIB_NAME}_arm64_iphoneos.h ./ios-arm64/${LIB_NAME}.h
	mv ./${LIB_NAME}_iphonesimulator.a ./ios-simulator/${LIB_NAME}.a
	mv ./${LIB_NAME}_arm64_iphoneos.h ./ios-simulator/${LIB_NAME}.h

	xcodebuild -create-xcframework \
			-output ${LIB_NAME}.xcframework \
			-library ios-arm64/${LIB_NAME}.a \
			-headers ios-arm64/${LIB_NAME}.h \
			-library ios-simulator/${LIB_NAME}.a \
			-headers ios-simulator/${LIB_NAME}.h
	rm -rf ios-arm64
	rm -rf ios-arm64-simulator
	rm -rf ios-simulator
	rm -rf ../ios/${LIB_NAME}.xcframework
	mv ${LIB_NAME}.xcframework ../ios/

macos:
	CGO_ENABLED=1 \
	GOOS=darwin \
	GOARCH=arm64 \
	SDK=macos \
	go build -trimpath -buildmode=c-shared -o ${LIB_NAME}_arm64.dylib .
	CGO_ENABLED=1 \
	GOOS=darwin \
	GOARCH=amd64 \
	SDK=macos \
	go build -trimpath -buildmode=c-shared -o ${LIB_NAME}_amd64.dylib .
	lipo \
		-create \
		${LIB_NAME}_arm64.dylib \
		${LIB_NAME}_amd64.dylib \
		-output ${LIB_NAME}.dylib
	install_name_tool -id "@rpath/libsum.dylib" libsum.dylib
	mv ${LIB_NAME}.dylib ../macos/${LIB_NAME}.dylib
	rm ${LIB_NAME}_*.h
	rm ${LIB_NAME}_*.dylib

windows:
	CGO_ENABLED=1 \
	GOOS=windows \
	GOARCH=amd64 \
	go build -trimpath -buildmode=c-shared -o ./../lib_cache/Windows/AMD64/${LIB_NAME}.dll .

linux:
	CGO_ENABLED=1 \
	GOOS=linux \
	GOARCH=amd64 \
	go build -trimpath -buildmode=c-shared -o ./../lib_cache/Linux/x86_64/${LIB_NAME}.so .

web:
	GOOS=js GOARCH=wasm go build -o ../lib_cache/web/${LIB_NAME}.wasm .
	cp "$(shell go env GOROOT)/lib/wasm/wasm_exec.js" ../lib_cache/web/
