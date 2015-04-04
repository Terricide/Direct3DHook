FRAMEWORK_VERSION=v4.0.30319
FRAMEWORK_ARCH=64

MSBUILD=C:\Windows\Microsoft.NET\Framework$(FRAMEWORK_ARCH)\$(FRAMEWORK_VERSION)\msbuild.exe
MSBUILD_OPTIONS=/m

NUGET=nuget
NUGET_INSTALL_OPTIONS=-o depends

SHARPDX_VERSION=2.6.3
SHARPDX_PACKAGES=SharpDX.D3DCompiler SharpDX.Direct3D9 SharpDX.Direct3D10 SharpDX.Direct3D11 SharpDX.Direct3D11.Effects SharpDX.DXGI
SHARPDX_PLATFORM=DirectX11-Signed-net40

UNZIP=7z -y x
WGET=curl -sL

EASYHOOK_ZIP=EasyHook-2.7.5558.0-Binaries.zip
EASYHOOK_URL=http://bit.ly/1FuD3cj

all: clean bin

clean:
	rm -rf Capture/bin/* Capture/obj/*

SharpDX%: 
	mkdir -p depends
	$(NUGET) install $(NUGET_INSTALL_OPTIONS) $@

$(EASYHOOK_ZIP):
	$(WGET) http://bit.ly/1FuD3cj > depends/$(EASYHOOK_ZIP)

EasyHook: $(EASYHOOK_ZIP)
	mkdir -p depends/EasyHook
	cd depends/EasyHook && $(UNZIP) ../$(EASYHOOK_ZIP)

depends: $(SHARPDX_PACKAGES) EasyHook

Direct3DHook.sln: depends

bin: Direct3DHook.sln
	$(MSBUILD) $(MSBUILD_OPTIONS) ./Direct3DHook.sln