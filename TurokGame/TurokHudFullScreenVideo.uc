class TurokHudFullScreenVideo extends TurokHudElement
    transient
    native;

var @NULL mVideoAction;
var bool mVideoIsPlaying;

function Draw()
{
    // End:0x16
    if(mVideoIsPlaying == true)
    {
        DrawNative();
    }
    //return;    
}

function Reset()
{
    StopVideo();
    //return;    
}

// Export UTurokHudFullScreenVideo::execStartVideo(FFrame&, void* const)
native function StartVideo(@NULL Action);

// Export UTurokHudFullScreenVideo::execStopVideo(FFrame&, void* const)
native function StopVideo();

// Export UTurokHudFullScreenVideo::execDrawNative(FFrame&, void* const)
native function DrawNative();
