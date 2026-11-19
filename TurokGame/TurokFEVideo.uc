class TurokFEVideo extends Object
    native;

enum eOptionsVideoAntialiasing
{
    OVA_OFF,                        // 0
    OVA_2X,                         // 1
    OVA_4X,                         // 2
    OVA_8X,                         // 3
    OVA_16X,                        // 4
    OVA_MAX                         // 5
};

enum eOptionsVideoFiltering
{
    OVF_BILINEAR,                   // 0
    OVF_TRILINEAR,                  // 1
    OVF_ANISOTROPIC2X,              // 2
    OVF_ANISOTROPIC4X,              // 3
    OVF_ANISOTROPIC8X,              // 4
    OVF_ANISOTROPIC16X,             // 5
    OVF_MAX                         // 6
};

enum eOptionsVideoQuality
{
    OVQ_LOW,                        // 0
    OVQ_MEDIUM,                     // 1
    OVQ_HIGH,                       // 2
    OVQ_MAX                         // 3
};

var int resolution;
var bool fullscreen;
var bool vsync;
var float Gamma;
var byte antialiasing;
var byte filtering;
var byte texture_quality;
var byte world_detail;

// Export UTurokFEVideo::execGetResolution(FFrame&, void* const)
native function int GetResolution(optional bool bUseBaseSetting);

// Export UTurokFEVideo::execSetResolution(FFrame&, void* const)
native function SetResolution(int Value);

// Export UTurokFEVideo::execGetFullScreen(FFrame&, void* const)
native function bool GetFullScreen(optional bool bUseBaseSetting);

// Export UTurokFEVideo::execSetFullScreen(FFrame&, void* const)
native function SetFullScreen(bool Value);

// Export UTurokFEVideo::execGetGamma(FFrame&, void* const)
native function float GetGamma();

// Export UTurokFEVideo::execSetGamma(FFrame&, void* const)
native function SetGamma(float Value);

// Export UTurokFEVideo::execGetAntialiasing(FFrame&, void* const)
native function byte GetAntialiasing();

// Export UTurokFEVideo::execSetAntialiasing(FFrame&, void* const)
native function SetAntialiasing(byte Value);

// Export UTurokFEVideo::execGetVSync(FFrame&, void* const)
native function bool GetVSync();

// Export UTurokFEVideo::execSetVSync(FFrame&, void* const)
native function SetVSync(bool Value);

// Export UTurokFEVideo::execGetFiltering(FFrame&, void* const)
native function byte GetFiltering();

// Export UTurokFEVideo::execSetFiltering(FFrame&, void* const)
native function SetFiltering(byte Value);

// Export UTurokFEVideo::execGetTextureQuality(FFrame&, void* const)
native function byte GetTextureQuality();

// Export UTurokFEVideo::execSetTextureQuality(FFrame&, void* const)
native function SetTextureQuality(byte Value);

// Export UTurokFEVideo::execGetWorldDetail(FFrame&, void* const)
native function byte GetWorldDetail();

// Export UTurokFEVideo::execSetWorldDetail(FFrame&, void* const)
native function SetWorldDetail(byte Value);

defaultproperties
{
    vsync=true
    Gamma=1.0000000
    texture_quality=1
    world_detail=1
}