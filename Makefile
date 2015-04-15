BIN_DIR=Capture/bin
OBJ_DIR=Capture/obj
LIB_DIR=Capture/lib
OUTPUT_DIR=$(BIN_DIR)/Debug
TARGET_DLL=$(OUTPUT_DIR)/Capture.dll

FRAMEWORK_VERSION=v4.0.30319
FRAMEWORK_ARCH=64

MSBUILD=C:\Windows\Microsoft.NET\Framework$(FRAMEWORK_ARCH)\$(FRAMEWORK_VERSION)\msbuild.exe
MSBUILD_OPTIONS=/m

NUGET=depends/nuget.exe
NUGET_URL=http://storage.googleapis.com/bundlecamp-static/ScreenshotToolLibs/NuGet.exe
NUGET_INSTALL_OPTIONS=-o depends

SHARPDX_VERSION=2.6.3
SHARPDX_PACKAGES=SharpDX.D3DCompiler SharpDX.Direct3D9 SharpDX.Direct3D10 SharpDX.Direct3D11 SharpDX.Direct3D11.Effects SharpDX.DXGI
SHARPDX_PLATFORM=DirectX11-Signed-net40

WGET_BINARY=depends/wget.exe
WGET=$(WGET_BINARY) -qO

7ZIP=depends/7z/x64/7za.exe
UNZIP=$(7ZIP) -y x

EASYHOOK_ZIP=EasyHook-2.7.5558.0-Binaries.zip
EASYHOOK_URL=http://storage.googleapis.com/bundlecamp-static/ScreenshotToolLibs/EasyHook-2.7.5558.0-Binaries.zip
EASYHOOK_DIR=depends/EasyHook
EASYHOOK_PREFIX=$(EASYHOOK_DIR)/NetFX4.0
EASYHOOK_DLLS=$(EASYHOOK_PREFIX)/EasyHook.dll $(EASYHOOK_PREFIX)/EasyHook64.dll $(EASYHOOK_PREFIX)/EasyHook32.dll

all: clean $(TARGET_DLL)

clean:
	rm -rf $(BIN_DIR)/* $(OBJ_DIR)/* $(LIB_DIR)/*

SharpDX%: 
	mkdir -p depends
	$(NUGET) install $(NUGET_INSTALL_OPTIONS) $@

$(EASYHOOK_ZIP):
	$(WGET) depends/$(EASYHOOK_ZIP) $(EASYHOOK_URL)

$(EASYHOOK_PREFIX): $(EASYHOOK_ZIP)
	mkdir -pv $(EASYHOOK_DIR)
	cd $(EASYHOOK_DIR) && ../../$(UNZIP) ../$(EASYHOOK_ZIP)

$(EASYHOOK_DLLS): $(EASYHOOK_PREFIX)

$(NUGET):
	mkdir -pv depends
	$(WGET) $(NUGET) $(NUGET_URL)
	chmod +x $(NUGET)

depends: $(NUGET) $(SHARPDX_PACKAGES) $(EASYHOOK_DLLS)

$(TARGET_DLL): depends
	$(MSBUILD) $(MSBUILD_OPTIONS) ./Direct3DHook.sln