class PKGFxUI_EndStats extends PKGFxUI_Stats
    config(UI);

var const localized string LevelCompletedTitle;
var const localized string LevelCompletedBody;

simulated function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    return true;
    //return ReturnValue;    
}

function PlayOpenAnimation()
{
    RootMC.GotoAndStop("endstats");
    StatsMC.GotoAndPlay("endstats");
    ContinueMC.GotoAndStop("hide");
    //return;    
}

function PlayCloseAnimation()
{
    //return;    
}

function OnOpenAnimationComplete()
{
    ContinueMC.GotoAndPlay("loop");
    bContinueBlock = false;
    //return;    
}

function OnNextLine()
{
    PlaySoundFromTheme('NextLine');
    //return;    
}

function OnContinue()
{
    local array<name> ButtonAliases;
    local PKUIManager UIManager;
    local WorldInfo WorldInfo;
    local PKTypes.ELevelID levelid;

    // End:0x208
    if(!bContinueBlock)
    {
        bContinueBlock = true;
        WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
        levelid = GetNextLevel();
        // End:0x85
        if(int(levelid) != int(0))
        {
            ButtonAliases.AddItem('TarotCards');            
        }
        else
        {
            PKPlayerController(GetPC()).ReturnToMainMenu(false);
        }
        ButtonAliases.AddItem('MainMenu');
        // End:0x145
        if((int(levelid) != int(0)) && (int(WorldInfo.NetMode) == int(NM_Standalone)) || int(WorldInfo.NetMode) == int(NM_ListenServer))
        {
            ButtonAliases.AddItem('NextLevel');
        }
        UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
        UIManager.ShowUIMessage('FinishMenu', LevelCompletedTitle, LevelCompletedBody, ButtonAliases, OnLevelMessageFinish, Class'Engine.Engine'.static.GetEngine().GamePlayers[0],,,, false);
    }
    //return;    
}

function bool OnLevelMessageFinish(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    switch(SelectedInputAlias)
    {
        // End:0x6C
        case 'TarotCards':
            PainGFxHudWrapper(GetPC().myHUD).ShowTarotMenu(true);
            Close();
            // End:0xC4
            break;
        // End:0x88
        case 'NextLevel':
            // End:0x88
            if(StartNextLevel())
            {
                // End:0xC4
                break;
            }
        // End:0xC1
        case 'MainMenu':
            PKPlayerController(GetPC()).ReturnToMainMenu(false);
            // End:0xC4
            break;
        // End:0xFFFF
        default:
            break;
    }
    return true;
    //return ReturnValue;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x54
    if(int(InputEvent) == int(0))
    {
        // End:0x48
        if(bContinueBlock)
        {
            StatsMC.GotoAndStop("end");            
        }
        else
        {
            OnContinue();
        }
        return true;
    }
    return super(GFxMoviePlayer).FilterButtonInput(ControllerId, ButtonName, InputEvent);
    //return ReturnValue;    
}

simulated function UpdateStatistics()
{
    local PainGRI PKGRI;

    PKGRI = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    super.UpdateStatistics();
    GameTimeValueTF.SetText("" $ (ConvertSecondsToTimeString(PKGRI.GameplayTime)));
    //return;    
}

static function PKTypes.ELevelID GetNextLevel()
{
    local PKTypes.ELevelID SelectedLevelID;
    local PainGRI_SP GRI;

    GRI = PainGRI_SP(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    SelectedLevelID = Class'PKPlayerController'.static.ComputeNextLevelIDForCurrentLevel(byte(GRI.ChapterNum));
    return SelectedLevelID;
    //return ReturnValue;    
}

static function bool StartNextLevel()
{
    local PKTypes.ELevelID SelectedLevelID;

    SelectedLevelID = GetNextLevel();
    // End:0x153
    if(int(SelectedLevelID) != int(0))
    {
        // End:0xE4
        if(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI.IsCoopMultiplayerGame())
        {
            Class'Engine.WorldInfo'.static.GetWorldInfo().ServerTravel("PKHDGame_P?loadcheckpoint=0?chapter=" $ string(int(SelectedLevelID)));            
        }
        else
        {
            Class'Engine.WorldInfo'.static.GetWorldInfo().ServerTravel("PKHDGame_P?loadcheckpoint=0?chapter=" $ string(int(SelectedLevelID)));
        }        
    }
    else
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    LevelCompletedTitle="Level Completed"
    LevelCompletedBody="What to do next?"
    bContinueBlock=true
    bAllowFocus=true
    bCaptureInput=true
    SoundThemes=/* Array type was not detected. */
}