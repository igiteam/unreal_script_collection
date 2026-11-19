class PKGFxUI_UGCDownloadTracker extends PKGfxMoviePlayer
    config(UI);

var GFxObject RootMC;
var GFxObject PauseMC;
var GFxObject MenuMC;
var GFxObject MapNameTF;
var GFxObject percentTF;
var bool bInFrontendMode;
var bool bCloseAlreadyPlayed;

simulated function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    PauseMC = RootMC.GetObject("pausemenu");
    MenuMC = PauseMC.GetObject("menu");
    MapNameTF = MenuMC.GetObject("mapnameTF");
    percentTF = MenuMC.GetObject("percentTF");
    return true;
    //return ReturnValue;    
}

simulated function Setup(bool InbInFrontendMode, optional string UGCName)
{
    bInFrontendMode = InbInFrontendMode;
    // End:0x75
    if(bInFrontendMode == false)
    {
        MapNameTF.SetText(UGCName);
        percentTF.SetText("100%");
    }
    bCloseAlreadyPlayed = false;
    PlayOpenAnimation();
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local PKEngine Eng;
    local OnlineSubsystemSteamworks steam;
    local string UGCName;
    local int Percentage;

    Eng = PKEngine(Class'PKEngine'.static.GetEngine());
    steam = OnlineSubsystemSteamworks(Eng.GetOnlineSubsystem());
    super(UTGFxTweenableMoviePlayer).Tick(DeltaTime);
    // End:0x15D
    if(bInFrontendMode)
    {
        // End:0x147
        if(steam.CheckIsUGCIsDownloading() > 0)
        {
            steam.GetUGCDownloadProgress(UGCName, Percentage);
            MapNameTF.SetText(UGCName);
            percentTF.SetText(("Downloading: " $ string(Percentage)) $ "%");            
        }
        else
        {
            PlayCloseAnimation();
            bCloseAlreadyPlayed = true;
        }
    }
    //return;    
}

function PlayOpenAnimation()
{
    bCloseAlreadyPlayed = false;
    PauseMC.GotoAndPlay("open");
    //return;    
}

function PlayCloseAnimation()
{
    // End:0x0F
    if(bCloseAlreadyPlayed)
    {
        return;
    }
    bCloseAlreadyPlayed = true;
    PauseMC.GotoAndPlay("close");
    //return;    
}

defaultproperties
{
    MovieInfo=SwfMovie'PKHD_UI.PKSteamWorkshop'
    bAllowFocus=false
    Priority=3
}