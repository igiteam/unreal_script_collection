class AdvGFxUI_MenuBg extends AdvGfxMoviePlayer
    config(UI);

var GFxObject RootMC;
var GFxObject BgMC;
var AdvFrontEnd Frontend;

function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    BgMC = RootMC.GetObject("bgMC");
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    MovieInfoPath="UI_AdvUI.AdvBg"
    bAllowFocus=false
    Priority=1
}