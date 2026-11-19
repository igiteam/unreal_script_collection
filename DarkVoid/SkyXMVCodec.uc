class SkyXMVCodec extends CodecMovie
    transient
    native;

enum EXMVState
{
    XMV_PendingInit,                // 0
    XMV_Idle,                       // 1
    XMV_Playing,                    // 2
    XMV_Paused,                     // 3
    XMV_MAX                         // 4
};

struct native XMVDataStruct
{
    var native const transient Pointer XMVInterface;
    var native const transient Pointer RHIInterface;
};

var const transient XMVDataStruct XMVData;
var native const transient SoundRaw Sound;
var const int Width;
var const int Height;
var const float FrameRate;
var const transient bool bLooping;
var const transient bool bPlayOneFrame;
var const string PendingFilename;
var native const transient Pointer PendingFilenameMutex;
var string Filename;
var native const transient ThreadSafeCounter XMVState;
