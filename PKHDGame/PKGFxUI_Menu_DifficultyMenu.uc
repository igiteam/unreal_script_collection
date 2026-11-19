class PKGFxUI_Menu_DifficultyMenu extends PKGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxObject TraumaInfoTF;
var GFxClikWidget DaydreamBtn;
var GFxClikWidget InsomniaBtn;
var GFxClikWidget NightmareBtn;
var GFxClikWidget TraumaBtn;
var GFxClikWidget BackBtn;
var const localized string TitleString;
var const localized string DaydreamString;
var const localized string InsomniaString;
var const localized string NightmareString;
var const localized string TraumaString;
var const localized string TraumaInfoString;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    TraumaInfoTF = ButtonsMC.GetObject("trauma_info").GetObject("textField");
    DaydreamBtn = GFxClikWidget(ButtonsMC.GetObject("daydream_btn", Class'GFxUI.GFxClikWidget'));
    InsomniaBtn = GFxClikWidget(ButtonsMC.GetObject("insomnia_btn", Class'GFxUI.GFxClikWidget'));
    NightmareBtn = GFxClikWidget(ButtonsMC.GetObject("nightmare_btn", Class'GFxUI.GFxClikWidget'));
    TraumaBtn = GFxClikWidget(ButtonsMC.GetObject("trauma_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x315
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        BackBtn.SetBool("visible", false);
    }
    TitleTF.SetText(TitleString);
    TraumaInfoTF.SetText(TraumaInfoString);
    DaydreamBtn.SetString("label", DaydreamString);
    InsomniaBtn.SetString("label", InsomniaString);
    NightmareBtn.SetString("label", NightmareString);
    TraumaBtn.SetString("label", TraumaString);
    UpdateAllowedDifficulty();
    UpdatePartyWindowShouldDisplay();
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');
    ButtonAliases.AddItem('GenericBack');
    FrontEnd.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function UpdateAllowedDifficulty()
{
    local PKPlayerController PC;
    local bool bTraumaUnlocked;

    PC = PKPlayerController(GetPC());
    bTraumaUnlocked = PC.IsTraumaUnlocked();
    TraumaBtn.SetBool("disabled", !bTraumaUnlocked);
    ButtonsMC.GetObject("trauma_info").SetVisible(!bTraumaUnlocked);
    //return;    
}

function UpdatePartyWindowShouldDisplay()
{
    // End:0x9A
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        // End:0x9A
        if(((GetMenuGame()) != none) && int(GetMenuGame().MultiGameModeSelected) == int(5))
        {
            bCanOpenPartyMenu = true;
            bCanOpenChangePartyType = true;
            bDisplayPartyWindow = true;
        }
    }
    //return;    
}

function OnBack(EventData ev)
{
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function OnDaydreamBtn(optional int ControllerIdx)
{
    Action = "daydream";
    PlayCloseAnimation();
    //return;    
}

function OnInsomniaBtn(optional int ControllerIdx)
{
    Action = "insomnia";
    PlayCloseAnimation();
    //return;    
}

function OnNightmareBtn(optional int ControllerIdx)
{
    Action = "nightmare";
    PlayCloseAnimation();
    //return;    
}

function OnTraumaBtn(optional int ControllerIdx)
{
    Action = "trauma";
    PlayCloseAnimation();
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bBack;
    local PKTypes.EDifficultyLevel DifficultyIdx;

    bBack = false;
    switch(Action)
    {
        // End:0x78
        case "back":
            // End:0x69
            if(FrontEnd.OpenMapSelectScreen())
            {
                FrontEnd.CloseDifficultyScreen();
            }
            bBack = true;
            // End:0xED
            break;
        // End:0x94
        case "daydream":
            DifficultyIdx = 0;
            // End:0xED
            break;
        // End:0xB0
        case "insomnia":
            DifficultyIdx = 1;
            // End:0xED
            break;
        // End:0xCD
        case "nightmare":
            DifficultyIdx = 2;
            // End:0xED
            break;
        // End:0xE7
        case "trauma":
            DifficultyIdx = 3;
            // End:0xED
            break;
        // End:0xFFFF
        default:
            // End:0xED
            break;
            break;
    }
    PKPlayerController(GetPC()).SetDifficulty(DifficultyIdx);
    // End:0x21C
    if(!bBack)
    {
        FrontEnd.Close();
        FrontEnd = none;
        // End:0x1DD
        if(GetMenuGame().bPublicGameSelected)
        {
            GetMenuGame().CreateCoopGame(GetMenuGame().SelectedLevelID, GetMenuGame().bLANSelected);            
        }
        else
        {
            GetMenuGame().CreateSPGame(GetMenuGame().SelectedLevelID);
        }
    }
    Action = "";
    //return;    
}

defaultproperties
{
    TitleString="Difficulty"
    DaydreamString="Daydream"
    InsomniaString="Insomnia"
    NightmareString="Nightmare"
    TraumaString="Trauma"
    TraumaInfoString="Mode locked: Finish Nightmare to unlock"
    MovieInfo=SwfMovie'PKHD_UI.PKDifficultyMenu'
}