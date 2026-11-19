class PKGFxUI_Menu_DifficultyMenuCoop extends PKGFxUI_Menu_DifficultyMenu
    config(UI);

var GFxObject TraumaInfo2TF;
var GFxObject Player1TF;
var GFxObject Player2TF;
var GFxClikWidget Daydream2Btn;
var GFxClikWidget Insomnia2Btn;
var GFxClikWidget Nightmare2Btn;
var GFxClikWidget Trauma2Btn;
var PKTypes.EDifficultyLevel DifficultyIdx[2];
var byte DifficultySelected[2];

function bool Start(optional bool StartPaused = false)
{
    super(PKGFxUI_Menu_Base).Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = ButtonsMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    TraumaInfoTF = ButtonsMC.GetObject("trauma_info").GetObject("textField");
    DaydreamBtn = GFxClikWidget(ButtonsMC.GetObject("daydream_btn", Class'GFxUI.GFxClikWidget'));
    InsomniaBtn = GFxClikWidget(ButtonsMC.GetObject("insomnia_btn", Class'GFxUI.GFxClikWidget'));
    NightmareBtn = GFxClikWidget(ButtonsMC.GetObject("nightmare_btn", Class'GFxUI.GFxClikWidget'));
    TraumaBtn = GFxClikWidget(ButtonsMC.GetObject("trauma_btn", Class'GFxUI.GFxClikWidget'));
    TraumaInfo2TF = ButtonsMC.GetObject("trauma_info2").GetObject("textField");
    Player1TF = ButtonsMC.GetObject("player1");
    Player2TF = ButtonsMC.GetObject("player2");
    Daydream2Btn = GFxClikWidget(ButtonsMC.GetObject("daydream_btn2", Class'GFxUI.GFxClikWidget'));
    Insomnia2Btn = GFxClikWidget(ButtonsMC.GetObject("insomnia_btn2", Class'GFxUI.GFxClikWidget'));
    Nightmare2Btn = GFxClikWidget(ButtonsMC.GetObject("nightmare_btn2", Class'GFxUI.GFxClikWidget'));
    Trauma2Btn = GFxClikWidget(ButtonsMC.GetObject("trauma_btn2", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x4FC
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
    TraumaInfo2TF.SetText(TraumaInfoString);
    Daydream2Btn.SetString("label", DaydreamString);
    Insomnia2Btn.SetString("label", InsomniaString);
    Nightmare2Btn.SetString("label", NightmareString);
    Trauma2Btn.SetString("label", TraumaString);
    // End:0x8FF
    if(Class'Engine.Engine'.static.GetEngine().GamePlayers[0].ControllerId > Class'Engine.Engine'.static.GetEngine().GamePlayers[1].ControllerId)
    {
        Player1TF.SetText(GetMenuGame().FindPlayerControllerByControllerId(Class'Engine.Engine'.static.GetEngine().GamePlayers[1].ControllerId).PlayerReplicationInfo.PlayerName);
        Player2TF.SetText(GetMenuGame().FindPlayerControllerByControllerId(Class'Engine.Engine'.static.GetEngine().GamePlayers[0].ControllerId).PlayerReplicationInfo.PlayerName);        
    }
    else
    {
        Player1TF.SetText(GetMenuGame().FindPlayerControllerByControllerId(Class'Engine.Engine'.static.GetEngine().GamePlayers[0].ControllerId).PlayerReplicationInfo.PlayerName);
        Player2TF.SetText(GetMenuGame().FindPlayerControllerByControllerId(Class'Engine.Engine'.static.GetEngine().GamePlayers[1].ControllerId).PlayerReplicationInfo.PlayerName);
    }
    UpdateAllowedDifficulty();
    DifficultySelected[0] = 0;
    DifficultySelected[1] = 0;
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

    super.UpdateAllowedDifficulty();
    PC = PKPlayerController(GetPC());
    bTraumaUnlocked = PC.IsTraumaUnlocked();
    Trauma2Btn.SetBool("disabled", !bTraumaUnlocked);
    ButtonsMC.GetObject("trauma_info2").SetVisible(!bTraumaUnlocked);
    //return;    
}

function OnDaydreamBtn(optional int ControllerIdx)
{
    DifficultySelected[ControllerIdx] = 1;
    DifficultyIdx[ControllerIdx] = 0;
    // End:0x76
    if((int(DifficultySelected[0]) == int(1)) && int(DifficultySelected[1]) == int(1))
    {
        Action = "start";
        PlayCloseAnimation();
    }
    //return;    
}

function OnInsomniaBtn(optional int ControllerIdx)
{
    DifficultySelected[ControllerIdx] = 1;
    DifficultyIdx[ControllerIdx] = 1;
    // End:0x76
    if((int(DifficultySelected[0]) == int(1)) && int(DifficultySelected[1]) == int(1))
    {
        Action = "start";
        PlayCloseAnimation();
    }
    //return;    
}

function OnNightmareBtn(optional int ControllerIdx)
{
    DifficultySelected[ControllerIdx] = 1;
    DifficultyIdx[ControllerIdx] = 2;
    // End:0x76
    if((int(DifficultySelected[0]) == int(1)) && int(DifficultySelected[1]) == int(1))
    {
        Action = "start";
        PlayCloseAnimation();
    }
    //return;    
}

function OnTraumaBtn(optional int ControllerIdx)
{
    DifficultySelected[ControllerIdx] = 1;
    DifficultyIdx[ControllerIdx] = 3;
    // End:0x76
    if((int(DifficultySelected[0]) == int(1)) && int(DifficultySelected[1]) == int(1))
    {
        Action = "start";
        PlayCloseAnimation();
    }
    //return;    
}

function OnCloseAnimationComplete()
{
    switch(Action)
    {
        // End:0x60
        case "back":
            // End:0x5D
            if(FrontEnd.OpenMapSelectScreen())
            {
                FrontEnd.CloseDifficultyScreen();
            }
            // End:0x1E6
            break;
        // End:0x1E0
        case "start":
            GetMenuGame().FindPlayerControllerByControllerId(0).SetDifficulty(DifficultyIdx[0]);
            GetMenuGame().FindPlayerControllerByControllerId(1).SetDifficulty(DifficultyIdx[1]);
            GetMenuGame().SetSplitCoopPlayerDifficulty(DifficultyIdx[1]);
            // End:0x19E
            if(GetMenuGame().bPublicGameSelected)
            {
                GetMenuGame().CreateCoopGame(GetMenuGame().SelectedLevelID, GetMenuGame().bLANSelected);                
            }
            else
            {
                GetMenuGame().CreateSPGame(GetMenuGame().SelectedLevelID);
            }
            // End:0x1E6
            break;
        // End:0xFFFF
        default:
            // End:0x1E6
            break;
            break;
    }
    Action = "";
    //return;    
}

defaultproperties
{
    bDisplayPartyWindow=true
    MovieInfo=SwfMovie'PKHD_UI.PKDifficultyMenuCoop'
}