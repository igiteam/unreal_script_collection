class MovieMaterial extends RenderedMaterial
	native
	noexport
	transient;
	
var string	Filename;
var int		AudioTrack;

var int Width;
var int Height;

var bool bLoop;
var const bool InLoopDelegate;
var const bool bDone;
var const bool DelayFlush;
var const bool DoReset;
var const bool Started;
var const bool VolumeChanged;

var const int TextureInterface;
var const int Dummy1; // got a double here for CurrentFrame for DirectShow
var const int Dummy2;

var float SoundVolume;

delegate OnLoop();

native function StopMovie();
native function ResetMovie();
native function UpdateMovieVolume(float volume);
native function bool ReadFailed();


// Decompiled with UE Explorer.
defaultproperties
{
    bLoop=true
    SoundVolume=0.9000000
    MaterialFlag=256
}