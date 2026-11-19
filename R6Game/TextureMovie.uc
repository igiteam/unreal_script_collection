class TextureMovie extends Texture
    native
    noexport
    hidecategories(Object);

var native const noexport Pointer FTexture2DVfTable;
var native const int ResourceIndex;
var native const int UpdateHint;
var native const int SizeX;
var native const int SizeY;
var native const byte Format;
var native const int SizeZ;
var native const int NumMips;
var native const int CurrentMips;
var native const noexport Pointer FTickableObjectVfTable;
var() Texture.TextureAddress AddressX;
var() Texture.TextureAddress AddressY;
var deprecated bool ClampX;
var deprecated bool ClampY;
var const class<CodecMovie> DecoderClass;
var const transient CodecMovie Decoder;
var const transient float TimeIntoMovie;
var const transient float TimeSinceLastFrame;
var const bool Paused;
var const bool Stopped;
var() bool Looping;
var() bool AutoPlay;
var native const array<byte> CurrentFrame;
var() name Filename;
var() bool m_bPlayFromMemory;
var transient bool bOverloadPause;
var transient int iTickLoad;
var const int m_uiCodecSizeX;
var const int m_uiCodecSizeY;
var() bool m_bAutoUpdate;

// Export UTextureMovie::execPlay(FFrame&, void* const)
native function Play();

// Export UTextureMovie::execPause(FFrame&, void* const)
native function Pause();

// Export UTextureMovie::execStop(FFrame&, void* const)
native function Stop();

// Export UTextureMovie::execSetLooping(FFrame&, void* const)
native function SetLooping(bool bLoop);

defaultproperties
{
    DecoderClass=Class'CodecMovieFallback'
    Stopped=true
    SRGB=false
    NeverStream=true
}