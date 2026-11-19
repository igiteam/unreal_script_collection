class PKGFxUI_Menu_MultiPlayerSettings extends PKGFxUI_Menu_Base
    config(UI);

var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxObject ButtonsMC;
var GFxObject SkinChangeMC;
var GFxObject NickTxtMC;
var GFxClikWidget SaveBaton;
var GFxClikWidget BackBtn;
var GFxClikWidget PlayerModelNameSlider;
var GFxObject PlayerModelNameProvider;
var GFxClikWidget SkinChangeSlider;
var const localized string TitleString;
var const localized string SkinChangeString;
var const localized string NickChangeString;
var const localized string SaveSettingsString;
var const localized array<localized string> PlayerModelName;
var array<SkeletalMeshActor> PlayerModels;
var transient int LastSelectedIndex;

function bool Start(optional bool StartPaused = false)
{
    SetupPlayerModels();
    super.Start(StartPaused);
    Advance(0.0000000);
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    TitleTF.SetText(TitleString);
    ButtonsMC = MenuMC.GetObject("buttons");
    SaveBaton = GFxClikWidget(ButtonsMC.GetObject("saveMe", Class'GFxUI.GFxClikWidget'));
    SaveBaton.SetString("label", SaveSettingsString);
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x23F
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        BackBtn.SetBool("visible", false);
    }
    PlayerModelNameSlider = GFxClikWidget(ButtonsMC.GetObject("skinchange", Class'GFxUI.GFxClikWidget'));
    UpdatePlayerModelNameDataProvider();
    SkinChangeMC = ButtonsMC.GetObject("skintxt");
    SkinChangeMC.SetText(SkinChangeString);
    NickTxtMC = ButtonsMC.GetObject("nicktxt");
    NickTxtMC.SetText(NickChangeString);
    LastSelectedIndex = 0;
    ShowPlayerModel();
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

function Cleanup()
{
    local SkeletalMeshActor sma;
    local string Tag;

    // End:0xDA
    foreach GetPC().AllActors(Class'Engine.SkeletalMeshActor', sma)
    {
        Tag = string(sma.Tag);
        // End:0x9D
        if(InStr(Tag, "PlayerModel") >= 0)
        {
            sma.SetHidden(true);
            // End:0xD9
            continue;
        }
        // End:0xD9
        if(InStr(Tag, "Statue") >= 0)
        {
            sma.SetHidden(false);
        }        
    }    
    //return;    
}

function SetupPlayerModels()
{
    local SkeletalMeshActor sma;
    local int Index;
    local string Tag;

    // End:0x26
    if(PlayerModels.Length > 0)
    {
        PlayerModels.Remove(0, PlayerModels.Length);
    }
    PlayerModels.Add(4);
    // End:0x154
    foreach GetPC().AllActors(Class'Engine.SkeletalMeshActor', sma)
    {
        Tag = string(sma.Tag);
        // End:0x117
        if(InStr(Tag, "PlayerModel") >= 0)
        {
            Index = int(Mid(Tag, Len("PlayerModel"))) - 1;
            PlayerModels[Index] = sma;
            sma.SetHidden(true);
            // End:0x153
            continue;
        }
        // End:0x153
        if(InStr(Tag, "Statue") >= 0)
        {
            sma.SetHidden(true);
        }        
    }    
    //return;    
}

function OnSave2Btn(EventData ev)
{
    local int SelectedIndex;

    SelectedIndex = int(PlayerModelNameSlider.GetFloat("selectedIndex"));
    PKPlayerController(GetPC()).SetPlayerCharacterMP(SelectedIndex);
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function ShowPlayerModel()
{
    local int SelectedIndex;
    local SkeletalMeshActor sma;

    SelectedIndex = int(PlayerModelNameSlider.GetFloat("selectedIndex"));
    // End:0x72
    foreach PlayerModels(sma)
    {
        sma.SetHidden(true);        
    }    
    PlayerModels[SelectedIndex].SetHidden(false);
    //return;    
}

function OnSkinSwitch(EventData ev)
{
    local int CurrentSelectedIndex;
    local PKPlayerController PKPC;
    local int Direction;

    CurrentSelectedIndex = int(PlayerModelNameSlider.GetFloat("selectedIndex"));
    PKPC = PKPlayerController(GetPC());
    // End:0x7C
    if(CurrentSelectedIndex == LastSelectedIndex)
    {
        Direction = 0;        
    }
    else
    {
        // End:0xA1
        if(CurrentSelectedIndex > LastSelectedIndex)
        {
            Direction = 1;            
        }
        else
        {
            Direction = -1;
        }
    }
    // End:0x1AF
    if(((CurrentSelectedIndex == 16) || CurrentSelectedIndex == 17) && int(PKPC.IsDLCInstalled(11)) == int(0))
    {
        // End:0x157
        if(Direction == 1)
        {
            CurrentSelectedIndex = 15;
            PlayerModelNameSlider.SetFloat("selectedIndex", float(CurrentSelectedIndex));            
        }
        else
        {
            // End:0x1AF
            if(Direction == -1)
            {
                CurrentSelectedIndex = 15;
                PlayerModelNameSlider.SetFloat("selectedIndex", float(CurrentSelectedIndex));
            }
        }
    }
    // End:0x2AE
    if(((CurrentSelectedIndex == 14) || CurrentSelectedIndex == 15) && int(PKPC.IsDLCInstalled(8)) == int(0))
    {
        // End:0x256
        if(Direction == 1)
        {
            CurrentSelectedIndex = 16;
            PlayerModelNameSlider.SetFloat("selectedIndex", float(CurrentSelectedIndex));            
        }
        else
        {
            // End:0x2AE
            if(Direction == -1)
            {
                CurrentSelectedIndex = 13;
                PlayerModelNameSlider.SetFloat("selectedIndex", float(CurrentSelectedIndex));
            }
        }
    }
    // End:0x39B
    if((CurrentSelectedIndex == 12) && int(PKPC.IsDLCInstalled(2)) == int(0))
    {
        // End:0x343
        if(Direction == 1)
        {
            CurrentSelectedIndex = 13;
            PlayerModelNameSlider.SetFloat("selectedIndex", float(CurrentSelectedIndex));            
        }
        else
        {
            // End:0x39B
            if(Direction == -1)
            {
                CurrentSelectedIndex = 11;
                PlayerModelNameSlider.SetFloat("selectedIndex", float(CurrentSelectedIndex));
            }
        }
    }
    // End:0x488
    if((CurrentSelectedIndex == 10) && int(PKPC.IsDLCInstalled(3)) == int(0))
    {
        // End:0x430
        if(Direction == 1)
        {
            CurrentSelectedIndex = 11;
            PlayerModelNameSlider.SetFloat("selectedIndex", float(CurrentSelectedIndex));            
        }
        else
        {
            // End:0x488
            if(Direction == -1)
            {
                CurrentSelectedIndex = 9;
                PlayerModelNameSlider.SetFloat("selectedIndex", float(CurrentSelectedIndex));
            }
        }
    }
    ShowPlayerModel();
    LastSelectedIndex = CurrentSelectedIndex;
    //return;    
}

function OnBack(EventData ev)
{
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function UpdatePlayerModelNameDataProvider()
{
    local int I, ListCounter;
    local GFxObject DataProvider, TempObj;

    ListCounter = 0;
    DataProvider = CreateArray();
    I = 0;
    J0x2A:

    // End:0x105 [Loop If]
    if(I < Class'PKGFxUI_Menu_MultiPlayerSettings'.default.PlayerModelName.Length)
    {
        TempObj = CreateObject("Object");
        TempObj.SetString("label", Class'PKGFxUI_Menu_MultiPlayerSettings'.default.PlayerModelName[I]);
        DataProvider.SetElementObject(ListCounter++, TempObj);
        I++;
        // [Loop Continue]
        goto J0x2A;
    }
    PlayerModelNameSlider.SetObject("dataProvider", DataProvider);
    PlayerModelNameProvider = PlayerModelNameSlider.GetObject("dataProvider");
    PlayerModelNameSlider.SetFloat("selectedIndex", float(PKPlayerController(GetPC()).GetPlayerCharacterMP()));
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0xBA
        case "back":
            // End:0x83
            if(GetPC().WorldInfo.IsConsoleBuild(0))
            {
                bTransitionResult = FrontEnd.OpenMultiMenuXboxScreen();                
            }
            else
            {
                bTransitionResult = FrontEnd.OpenMultiMenuScreen();
            }
            Cleanup();
            // End:0xC0
            break;
        // End:0xFFFF
        default:
            // End:0xC0
            break;
            break;
    }
    // End:0xEC
    if(bTransitionResult)
    {
        FrontEnd.CloseMultiPlayerSettingsScreen();
    }
    Action = "";
    //return;    
}

defaultproperties
{
    TitleString="Player Settings"
    SkinChangeString="Appearance"
    NickChangeString="Nickname"
    SaveSettingsString="Save settings"
    PlayerModelName[0]="Daniel"
    PlayerModelName[1]="Eve"
    PlayerModelName[2]="Evil Monk"
    PlayerModelName[3]="Hell Angel"
    PlayerModelName[4]="Black Demon"
    PlayerModelName[5]="Sadocommando"
    PlayerModelName[6]="Samurai"
    PlayerModelName[7]="Skeleton Soldier"
    PlayerModelName[8]="Banshee"
    PlayerModelName[9]="Sensei"
    PlayerModelName[10]="Grim Reaper"
    PlayerModelName[11]="Pinokio"
    PlayerModelName[12]="Microgiant"
    PlayerModelName[13]="Devil Monk"
    PlayerModelName[14]="White Demon"
    PlayerModelName[15]="Assassin Greed"
    PlayerModelName[16]="Leper"
    PlayerModelName[17]="Walking Dead"
    MovieInfo=SwfMovie'PKHD_UI.PKPlayerSettings'
}