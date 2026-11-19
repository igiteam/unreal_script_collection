class PKGFxUI_Busy extends PKGfxMoviePlayer
    config(UI);

var GFxObject RootMC;

simulated function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    MovieInfo=SwfMovie'PKHD_UI.ui_loading'
    bCaptureInput=true
}