BTOUCH=/Developer/MonoTouch/usr/bin/btouch-native
SMCS=/Developer/MonoTouch/usr/bin/smcs
XBUILD=/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild

POD_NAME=StackBluriOS
PROJECT_NAME=$(POD_NAME).XamariniOS

PROJECT_ROOT=$(PROJECT_NAME)
PROJECT=$(PROJECT_ROOT)/$(PROJECT_NAME).csproj
LIB_NAME=$(PROJECT_ROOT)/lib$(POD_NAME).a
LIB_NAME_I386=$(PROJECT_ROOT)/lib$(POD_NAME)-i386.a
LIB_NAME_ARMV7=$(PROJECT_ROOT)/lib$(POD_NAME)-armv7.a
LIB_NAME_ARMV7S=$(PROJECT_ROOT)/lib$(POD_NAME)-armv7s.a
LIB_NAME_ARM64=$(PROJECT_ROOT)/lib$(POD_NAME)-arm64.a
DLL_NAME=$(PROJECT_NAME).dll
PDB_NAME=$(PROJECT_NAME).pdb

PODS_PROJECT_ROOT=$(PROJECT_ROOT)/Pods
PODS_PROJECT=$(PODS_PROJECT_ROOT)/Pods.xcodeproj
PODS_TARGET=$(POD_NAME)

all: $(DLL_NAME)
	
package: $(DLL_NAME)
	nuget pack Package.nuspec

$(PODS_PROJECT):
	cd $(PROJECT_ROOT) && pod install

$(LIB_NAME_I386): $(PODS_PROJECT)
	$(XBUILD) -project $(PODS_PROJECT) -target $(PODS_TARGET) -sdk iphonesimulator -configuration Release clean build
	-mv $(PROJECT_ROOT)/build/Release-iphonesimulator/$(PODS_TARGET)/lib$(PODS_TARGET).a $@

$(LIB_NAME_ARMV7): $(PODS_PROJECT)
	$(XBUILD) -project $(PODS_PROJECT) -target $(PODS_TARGET) -sdk iphoneos -arch armv7 -configuration Release clean build
	-mv $(PROJECT_ROOT)/build/Release-iphoneos/$(PODS_TARGET)/lib$(PODS_TARGET).a $@
	
$(LIB_NAME_ARMV7S): $(PODS_PROJECT)
	$(XBUILD) -project $(PODS_PROJECT) -target $(PODS_TARGET) -sdk iphoneos -arch armv7s -configuration Release clean build
	-mv $(PROJECT_ROOT)/build/Release-iphoneos/$(PODS_TARGET)/lib$(PODS_TARGET).a $@

$(LIB_NAME_ARM64): $(PODS_PROJECT)
	$(XBUILD) -project $(PODS_PROJECT) -target $(PODS_TARGET) -sdk iphoneos -arch arm64 -configuration Release clean build
	-mv $(PROJECT_ROOT)/build/Release-iphoneos/$(PODS_TARGET)/lib$(PODS_TARGET).a $@

$(LIB_NAME): $(LIB_NAME_I386) $(LIB_NAME_ARMV7) $(LIB_NAME_ARMV7S) $(LIB_NAME_ARM64)
	lipo -create -output $@ $^

$(DLL_NAME): $(LIB_NAME)
	msbuild /p:Configuration=Release $(PROJECT)
	cp $(PROJECT_ROOT)/bin/Release/$(DLL_NAME) $(DLL_NAME)
	cp $(PROJECT_ROOT)/bin/Release/$(PDB_NAME) $(PDB_NAME)

clean:
	-cd $(PROJECT_ROOT) && rm -rf bin obj *.a *.dll
	cd $(PROJECT_ROOT) && rm -rf Pods
