class AdvGFxUI_Menu_DifficultyMenu extends AdvGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxObject PuzzleTF;
var GFxObject FightTF;
var GFxClikWidget StartBtn;
var GFxClikWidget PuzzleBtn;
var GFxClikWidget FightBtn;
var GFxClikWidget PuzzleEasyBtn;
var GFxClikWidget PuzzleMediumBtn;
var GFxClikWidget PuzzleHardBtn;
var GFxClikWidget FightEasyBtn;
var GFxClikWidget FightMediumBtn;
var GFxClikWidget FightHardBtn;
var GFxClikWidget BackBtn;
var const localized string TitleString;
var const localized string StartString;
var const localized string PuzzleString;
var const localized string FightString;
var EvilTypesNative.EDifficultyLevel PuzzleDifficulty;
var EvilTypesNative.EDifficultyLevel FightDifficulty;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    PuzzleTF = ButtonsMC.GetObject("puzzle_tf");
    FightTF = ButtonsMC.GetObject("fight_tf");
    StartBtn = GFxClikWidget(ButtonsMC.GetObject("start_btn", Class'GFxUI.GFxClikWidget'));
    PuzzleBtn = GFxClikWidget(ButtonsMC.GetObject("puzzle_btn", Class'GFxUI.GFxClikWidget'));
    FightBtn = GFxClikWidget(ButtonsMC.GetObject("fight_btn", Class'GFxUI.GFxClikWidget'));
    PuzzleEasyBtn = GFxClikWidget(ButtonsMC.GetObject("puzzle_d").GetObject("easy_btn", Class'GFxUI.GFxClikWidget'));
    PuzzleMediumBtn = GFxClikWidget(ButtonsMC.GetObject("puzzle_d").GetObject("medium_btn", Class'GFxUI.GFxClikWidget'));
    PuzzleHardBtn = GFxClikWidget(ButtonsMC.GetObject("puzzle_d").GetObject("hard_btn", Class'GFxUI.GFxClikWidget'));
    FightEasyBtn = GFxClikWidget(ButtonsMC.GetObject("fight_d").GetObject("easy_btn", Class'GFxUI.GFxClikWidget'));
    FightMediumBtn = GFxClikWidget(ButtonsMC.GetObject("fight_d").GetObject("medium_btn", Class'GFxUI.GFxClikWidget'));
    FightHardBtn = GFxClikWidget(ButtonsMC.GetObject("fight_d").GetObject("hard_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x568
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    TitleTF.SetText(TitleString);
    PuzzleDifficulty = 1;
    FightDifficulty = 1;
    PuzzleTF.SetText(PuzzleString);
    FightTF.SetText(FightString);
    StartBtn.SetString("label", StartString);
    PuzzleBtn.SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(1).default.DifficultyName);
    FightBtn.SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(1).default.DifficultyName);
    PuzzleEasyBtn.SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(0).default.DifficultyName);
    PuzzleMediumBtn.SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(1).default.DifficultyName);
    PuzzleHardBtn.SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(2).default.DifficultyName);
    FightEasyBtn.SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(0).default.DifficultyName);
    FightMediumBtn.SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(1).default.DifficultyName);
    FightHardBtn.SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(2).default.DifficultyName);
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');    
    ButtonAliases.AddItem('GenericBack');    
    Frontend.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function OnBack(EventData ev)
{
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function OnStartBtn(EventData ev)
{
    Action = "start";
    PlayCloseAnimation();
    //return;    
}

function OnPuzzleEasyBtn(optional int ControllerIdx)
{
    PuzzleDifficulty = 0;
    PuzzleBtn.SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(0).default.DifficultyName);
    //return;    
}

function OnPuzzleMediumBtn(optional int ControllerIdx)
{
    PuzzleDifficulty = 1;
    PuzzleBtn.SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(1).default.DifficultyName);
    //return;    
}

function OnPuzzleHardBtn(optional int ControllerIdx)
{
    PuzzleDifficulty = 2;
    PuzzleBtn.SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(2).default.DifficultyName);
    //return;    
}

function OnFightEasyBtn(optional int ControllerIdx)
{
    FightDifficulty = 0;
    FightBtn.SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(0).default.DifficultyName);
    //return;    
}

function OnFightMediumBtn(optional int ControllerIdx)
{
    FightDifficulty = 1;
    FightBtn.SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(1).default.DifficultyName);
    //return;    
}

function OnFightHardBtn(optional int ControllerIdx)
{
    FightDifficulty = 2;
    FightBtn.SetString("label", Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(2).default.DifficultyName);
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0xCC
        case "back":
            // End:0x73
            if(int(GetMenuGame().SelectedLevelID) == int(0))
            {
                bTransitionResult = Frontend.OpenCampaignScreen();                
            }
            else
            {
                bTransitionResult = Frontend.OpenMapSelectScreen();
            }
            // End:0xC9
            if(bTransitionResult)
            {
                Frontend.CloseDifficultyScreen();
            }
            // End:0x21C
            break;
        // End:0x216
        case "start":
            GetMenuGame().SelectedPuzzleDifficultyLevel = int(PuzzleDifficulty);
            GetMenuGame().SelectedFightDifficultyLevel = int(FightDifficulty);
            // End:0x1AA
            if(int(GetMenuGame().SelectedLevelID) == int(0))
            {
                // End:0x188
                if(bDemoMode)
                {
                    GetMenuGame().SelectedLevelID = 15;                    
                }
                else
                {
                    GetMenuGame().SelectedLevelID = 1;
                }
            }
            Frontend.Close();
            Frontend = none;
            GetMenuGame().CreateSPGame(GetMenuGame().SelectedLevelID);
            // End:0x21C
            break;
        // End:0xFFFF
        default:
            // End:0x21C
            break;
            break;
    }
    Action = "";
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x53
    if(GetLP().ControllerId == ControllerId)
    {
        return super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    TitleString="Difficulty"
    StartString="Start Game"
    PuzzleString="Puzzle Difficulty"
    FightString="Combat Difficulty"
    MovieInfoPath="UI_AdvUI.AdvDifficultyMenu"
}