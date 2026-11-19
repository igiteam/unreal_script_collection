class PKGFxUI_Menu_Options_ControlsXboxCustom extends PKGFxUI_Menu_Options_Base
    config(UI);

var GFxObject CustomWeaponsKontener;
var transient array<byte> ActiveCustom1;
var transient array<byte> ActiveCustom2;
var transient bool bCustomChanged;
var GFxClikWidget Custom1List;
var GFxClikWidget Custom2List;
var transient int LastSelectedCustom1Index;
var transient int LastSelectedCustom2Index;

function bool Start(optional bool StartPaused = false)
{
    local PKPlayerController PC;

    super.Start(StartPaused);
    Advance(0.0000000);
    PC = PKPlayerController(GetPC());
    CustomWeaponsKontener = ButtonsMC.GetObject("weapons");
    Custom1List = GFxClikWidget(CustomWeaponsKontener.GetObject("custom1", Class'GFxUI.GFxClikWidget'));
    Custom2List = GFxClikWidget(CustomWeaponsKontener.GetObject("custom2", Class'GFxUI.GFxClikWidget'));
    ActiveCustom1.Remove(0, ActiveCustom1.Length);
    ActiveCustom2.Remove(0, ActiveCustom2.Length);
    PC.ProfileSettings.GetProfileSettingValueBlob(77, ActiveCustom1);
    PC.ProfileSettings.GetProfileSettingValueBlob(78, ActiveCustom2);
    // End:0x200
    if(ActiveCustom1.Length == 0)
    {
        PKPlayerInput(PC.PlayerInput).GetDefaultCustom1Weapons(ActiveCustom1);
    }
    // End:0x256
    if(ActiveCustom2.Length == 0)
    {
        PKPlayerInput(PC.PlayerInput).GetDefaultCustom2Weapons(ActiveCustom2);
    }
    bCustomChanged = false;
    CustomWeaponsKontener.GetObject("custom1TF").SetText(Class'PKGFxUI_Menu_Options_Controls'.default.Custom1Text);
    CustomWeaponsKontener.GetObject("custom2TF").SetText(Class'PKGFxUI_Menu_Options_Controls'.default.Custom2Text);
    HeaderTitleTF.SetText(Class'PKGFxUI_Menu_Options_ControlsXbox'.default.CustomWeapString);
    UpdateCustom1WeaponDataProvider();
    UpdateCustom2WeaponDataProvider();
    Custom1List.SetFloat("selectedIndex", 0.0000000);
    Custom2List.SetFloat("selectedIndex", 0.0000000);
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

function OnBack(EventData ev)
{
    // End:0x2B
    if(bHasChanges)
    {
        ShowDiscardWarning(OnBackSelect);        
    }
    else
    {
        OnBackSelect(none, 'GenericYes', LocalPlayerOwnerIndex);
    }
    //return;    
}

function bool OnBackSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x31
    if(SelectedInputAlias == 'GenericYes')
    {
        Action = "back";
        PlayCloseAnimation();
    }
    return true;
    //return ReturnValue;    
}

function OnSaveBtn(EventData ev)
{
    Action = "save";
    PlayCloseAnimation();
    //return;    
}

function UpdateCustom1WeaponDataProvider()
{
    local int I, ListCounter;
    local GFxObject DataProvider, TempObj;

    ListCounter = 0;
    DataProvider = CreateArray();
    I = 0;
    J0x2A:

    // End:0xE5 [Loop If]
    if(I < ActiveCustom1.Length)
    {
        TempObj = CreateObject("Object");
        TempObj.SetString("label", GetLocalizedTextForEWeaponFireMode(ActiveCustom1[I]));
        DataProvider.SetElementObject(ListCounter++, TempObj);
        I++;
        // [Loop Continue]
        goto J0x2A;
    }
    Custom1List.SetObject("dataProvider", DataProvider);
    LastSelectedCustom1Index = -1;
    //return;    
}

function UpdateCustom2WeaponDataProvider()
{
    local int I, ListCounter;
    local GFxObject DataProvider, TempObj;

    ListCounter = 0;
    DataProvider = CreateArray();
    I = 0;
    J0x2A:

    // End:0xE5 [Loop If]
    if(I < ActiveCustom2.Length)
    {
        TempObj = CreateObject("Object");
        TempObj.SetString("label", GetLocalizedTextForEWeaponFireMode(ActiveCustom2[I]));
        DataProvider.SetElementObject(ListCounter++, TempObj);
        I++;
        // [Loop Continue]
        goto J0x2A;
    }
    Custom2List.SetObject("dataProvider", DataProvider);
    LastSelectedCustom2Index = -1;
    //return;    
}

function OnCustom1Select(EventData ev)
{
    local int SelectedIndex;
    local byte EWFM;

    LastSelectedCustom2Index = -1;
    SelectedIndex = int(Custom1List.GetFloat("selectedIndex"));
    // End:0x15C
    if((LastSelectedCustom1Index > -1) && LastSelectedCustom1Index != SelectedIndex)
    {
        // End:0xE3
        if(LastSelectedCustom1Index > SelectedIndex)
        {
            EWFM = ActiveCustom1[LastSelectedCustom1Index];
            ActiveCustom1.InsertItem(SelectedIndex, EWFM);
            ActiveCustom1.Remove(LastSelectedCustom1Index + 1, 1);            
        }
        else
        {
            EWFM = ActiveCustom1[LastSelectedCustom1Index];
            ActiveCustom1.InsertItem(SelectedIndex + 1, EWFM);
            ActiveCustom1.Remove(LastSelectedCustom1Index, 1);
        }
        bCustomChanged = true;
        UpdateCustom1WeaponDataProvider();
        bHasChanges = true;        
    }
    else
    {
        LastSelectedCustom1Index = SelectedIndex;
    }
    //return;    
}

function OnCustom2Select(EventData ev)
{
    local int SelectedIndex;
    local byte EWFM;

    LastSelectedCustom1Index = -1;
    SelectedIndex = int(Custom2List.GetFloat("selectedIndex"));
    // End:0x15C
    if((LastSelectedCustom2Index > -1) && LastSelectedCustom2Index != SelectedIndex)
    {
        // End:0xE3
        if(LastSelectedCustom2Index > SelectedIndex)
        {
            EWFM = ActiveCustom2[LastSelectedCustom2Index];
            ActiveCustom2.InsertItem(SelectedIndex, EWFM);
            ActiveCustom2.Remove(LastSelectedCustom2Index + 1, 1);            
        }
        else
        {
            EWFM = ActiveCustom2[LastSelectedCustom2Index];
            ActiveCustom2.InsertItem(SelectedIndex + 1, EWFM);
            ActiveCustom2.Remove(LastSelectedCustom2Index, 1);
        }
        bCustomChanged = true;
        UpdateCustom2WeaponDataProvider();
        bHasChanges = true;        
    }
    else
    {
        LastSelectedCustom2Index = SelectedIndex;
    }
    //return;    
}

function OnCloseAnimationComplete()
{
    local float X, Y;

    switch(Action)
    {
        // End:0x29
        case "back":
            DiscardChanges();
            // End:0x4F
            break;
        // End:0x49
        case "save":
            SaveSettingsToProfile(bCustomChanged);
            // End:0x4F
            break;
        // End:0xFFFF
        default:
            // End:0x4F
            break;
            break;
    }
    // End:0xA2
    if(FrontEnd != none)
    {
        // End:0x9F
        if(FrontEnd.OpenOptionsControlsXboxScreen())
        {
            FrontEnd.CloseOptionsControlsXboxCustomScreen();
        }        
    }
    else
    {
        // End:0x36F
        if(ParentMenu != none)
        {
            ParentMenu.OptionsMenu = new Class'PKGFxUI_Menu_Options_ControlsXbox';
            ParentMenu.OptionsMenu.SetPriority(69);
            // End:0x25D
            if((PainGRI(GetPC().WorldInfo.GRI).IsPureSinglePlayerGame() || Class'Engine.Engine'.static.IsSplitScreen()) || PainGRI(GetPC().WorldInfo.GRI).IsCoopMultiplayerGame() && int(GetPC().WorldInfo.NetMode) == int(NM_ListenServer))
            {
                ParentMenu.OptionsMenu.bPauseGameWhileActive = true;
            }
            ParentMenu.OptionsMenu.ParentMenu = ParentMenu;
            ParentMenu.OptionsMenu.Init(GetLP());
            KursorMC.GetPosition(X, Y);
            ParentMenu.OptionsMenu.KursorMC.SetPosition(X, Y);
            Close();
        }
    }
    Action = "";
    //return;    
}

function SaveSettingsToProfile(optional bool InForceSave = false)
{
    local PKPlayerController PC;
    local bool bProfileChanged;

    PC = PKPlayerController(GetPC());
    bProfileChanged = InForceSave;
    PC.ProfileSettings.SetProfileSettingValueBlob(77, ActiveCustom1);
    PC.ProfileSettings.SetProfileSettingValueBlob(78, ActiveCustom2);
    // End:0xE3
    if(bProfileChanged)
    {
        PC.ClientSaveAllPlayerData(true);
    }
    //return;    
}

static function string GetLocalizedTextForEWeaponFireMode(PKTypes.EWeaponFireMode WeapFireMode)
{
    return Localize("FriendlyWeaponNames", string(GetEnum(Enum'PKTypes.EWeaponFireMode', int(WeapFireMode))), "PKHDGame");
    //return ReturnValue;    
}

defaultproperties
{
    MovieInfo=SwfMovie'PKHD_UI.PKSpecialFire'
}