class PKGFxUI_SurvivalComplete extends PKGfxMoviePlayer
    config(UI);

var GFxObject RootMC;
var GFxObject MenuMC;
var GFxObject InfoMC;
var GFxObject TitleMC;
var GFxObject ContinueMC;
var GFxObject ContinueTF;
var GFxObject TitleTF;
var GFxObject NameTF;
var GFxObject DescTF;
var GFxObject GoldTF;
var GFxObject KursorMC;
var transient bool bContinueBlock;
var transient bool bIsMenuPPOverrideOn;
var const localized string TitleString;
//var delegate<OnCloseComplete> __OnCloseComplete__Delegate;

simulated function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    MenuMC = RootMC.GetObject("menu");
    TitleMC = MenuMC.GetObject("title");
    InfoMC = MenuMC.GetObject("info");
    ContinueMC = MenuMC.GetObject("clicker");
    TitleTF = TitleMC.GetObject("textField");
    NameTF = InfoMC.GetObject("name_tf");
    DescTF = InfoMC.GetObject("info_tf");
    GoldTF = InfoMC.GetObject("gold_tf");
    ContinueTF = ContinueMC.GetObject("clicker_mc").GetObject("click_tf");
    KursorMC = RootMC.GetObject("kursor");
    KursorMC.SetVisible(false);
    TitleTF.SetText(TitleString);
    ContinueTF.SetText(Localize("PKGFxUI_Stats", "ReturnToMainMenuLabel", "PKHDGame"));
    NameTF.SetText(Localize("PKGFxUI_Menu_SurvivalSP", "TitleString", "PKHDGame"));
    bContinueBlock = true;
    PlayOpenAnimation();
    return true;
    //return ReturnValue;    
}

function SetTexts(int LevelIndex, bool bCompleted, int Kills, int AdditionalScore, int DescriptionIndex)
{
    DescTF.SetText(Localize("PKGFxUI_Menu_SurvivalSP", ("SVDescription[" $ string(DescriptionIndex)) $ "]", "PKHDGame"));
    TitleTF.SetText(Localize("PKGFxUI_Menu_SurvivalSP", ((bCompleted) ? "ChallengeCompleted" : "ChallengeFailed"), "PKHDGame"));
    // End:0x1C5
    if(bCompleted)
    {
        GoldTF.SetText(((((((Localize("PKGFxUI_Menu_Leaderboard", "TXTEnemiesKilled", "PKHDGame")) $ ":") @ string(Kills)) @ " + ") @ (Localize("PKGFxUI_Menu_Leaderboard", "TxtScore", "PKHDGame"))) $ ":") @ string(AdditionalScore));        
    }
    else
    {
        GoldTF.SetText(((Localize("PKGFxUI_Menu_Leaderboard", "TXTEnemiesKilled", "PKHDGame")) $ ":") @ string(Kills));
    }
    //return;    
}

function PlayOpenAnimation()
{
    local PKPostProcessManager PP;

    MenuMC.GotoAndPlay("open");
    PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
    // End:0xA2
    if(PP != none)
    {
        PP.SetMenuOverride(true, 0.4000000);
        bIsMenuPPOverrideOn = true;
    }
    //return;    
}

function PlayCloseAnimation()
{
    local PKPostProcessManager PP;

    MenuMC.GotoAndPlay("close");
    // End:0xB0
    if(bIsMenuPPOverrideOn)
    {
        PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
        // End:0xB0
        if(PP != none)
        {
            PP.SetMenuOverride(false, 0.4000000);
            bIsMenuPPOverrideOn = false;
        }
    }
    //return;    
}

function OnOpenAnimationComplete()
{
    bContinueBlock = false;
    //return;    
}

function OnCloseAnimationComplete()
{
    PKPlayerController(GetPC()).ReturnToMainMenu(false);
    OnCloseComplete();
    //return;    
}

delegate OnCloseComplete()
{
    //return;    
}

function OnContinue()
{
    // End:0x25
    if(!bContinueBlock)
    {
        bContinueBlock = true;
        PlayCloseAnimation();
    }
    //return;    
}

function SetOnCloseCompleteDelegate(delegate<OnCloseComplete> InDelegate)
{
    __OnCloseComplete__Delegate = InDelegate;
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x2F
    if(int(InputEvent) == int(0))
    {
        // End:0x2D
        if(!bContinueBlock)
        {
            OnContinue();
        }
        return true;
    }
    return super(GFxMoviePlayer).FilterButtonInput(ControllerId, ButtonName, InputEvent);
    //return ReturnValue;    
}

event OnClose()
{
    local PKPostProcessManager PP;

    super(GFxMoviePlayer).OnClose();
    // End:0x94
    if(bIsMenuPPOverrideOn)
    {
        PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
        // End:0x94
        if(PP != none)
        {
            PP.SetMenuOverride(false, 0.0000000, false);
            bIsMenuPPOverrideOn = false;
        }
    }
    //return;    
}

defaultproperties
{
    bContinueBlock=true
    TitleString="Solo Survival Map Completed"
    MovieInfo=SwfMovie'PKHD_UI.PKSurvivalComplete'
    bCaptureInput=true
    bHideLesserMovies=true
    Priority=80
}