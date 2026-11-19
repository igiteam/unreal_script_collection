class AdvGFxUI_EndStats extends AdvGFxUI_Stats
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
    local AdvUIManager UIManager;
    local WorldInfo WorldInfo;
    local AdvTypes.ELevelID LevelID;

    // End:0x20A
    if(!bContinueBlock)
    {
        bContinueBlock = true;
        WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
        LevelID = GetNextLevel();
        // End:0x85
        if(int(LevelID) != int(0))
        {
            ButtonAliases.AddItem('TarotCards');                        
        }
        else
        {
            AdvPlayerController(GetPC()).ReturnToMainMenu(false);
        }
        ButtonAliases.AddItem('MainMenu');        
        // End:0x145
        if((int(LevelID) != int(0)) && (int(WorldInfo.NetMode) == int(NM_Standalone)) || int(WorldInfo.NetMode) == int(NM_ListenServer))
        {
            ButtonAliases.AddItem('NextLevel');            
        }
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        UIManager.ShowUIMessage('FinishMenu', LevelCompletedTitle, LevelCompletedBody, ButtonAliases, OnLevelMessageFinish, Class'Engine.Engine'.static.GetEngine().GamePlayers[0],, 10,, false,,, true);
    }
    //return;    
}

function bool OnLevelMessageFinish(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    switch(SelectedInputAlias)
    {
        // End:0x22
        case 'TarotCards':
            // End:0x7A
            break;
        // End:0x3E
        case 'NextLevel':
            // End:0x3E
            if(StartNextLevel())
            {
                // End:0x7A
                break;
            }
        // End:0x77
        case 'MainMenu':
            AdvPlayerController(GetPC()).ReturnToMainMenu(false);
            // End:0x7A
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
    // End:0x3E
    if(bDiscardNonOwnerInput && GetLP().ControllerId != ControllerId)
    {
        return true;
    }
    // End:0xC1
    if((int(InputEvent) == int(0)) && !Class'AdvFrontEnd'.static.IsDirectionalInput(ButtonName))
    {
        // End:0xB5
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
    local AdvGRI PKGRI;

    PKGRI = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    super.UpdateStatistics();
    GameTimeValueTF.SetText("" $ (ConvertSecondsToTimeString(PKGRI.GameplayTime)));
    //return;    
}

static function AdvTypes.ELevelID GetNextLevel()
{
    local AdvTypes.ELevelID SelectedLevelID;
    local AdvGRI_SP GRI;

    GRI = AdvGRI_SP(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    SelectedLevelID = Class'AdvPlayerController'.static.ComputeNextLevelIDForCurrentLevel(byte(GRI.ChapterNum));
    return SelectedLevelID;
    //return ReturnValue;    
}

static function bool StartNextLevel()
{
    local AdvTypes.ELevelID SelectedLevelID;
    local AdvPlayerController PC;

    SelectedLevelID = GetNextLevel();
    // End:0x1D5
    if(int(SelectedLevelID) != int(0))
    {
        PC = AdvPlayerController(Class'Engine.WorldInfo'.static.GetWorldInfo().GetALocalPlayerController());
        PC.ClientShowLevelLoadingMovieByChapter(int(SelectedLevelID));
        Class'Engine.WorldInfo'.static.GetWorldInfo().ServerTravel((((((("ADVGame_P?loadcheckpoint=0?chapter=" $ string(int(SelectedLevelID))) $ "?PuzzleDifficultyLevel=") $ string(int(PC.GetPuzzleDifficultyLevel()))) $ "?FightDifficultyLevel=") $ string(int(PC.GetFightDifficultyLevel()))) $ "?gamepad=") $ ((PC.PlayerInput.bUsingGamepad) ? "1" : "0"));        
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
    bDiscardNonOwnerInput=true
    bCaptureInput=true
}