class AdvGFxUI_Menu_Options_ControlsXboxCustom extends AdvGFxUI_Menu_Options_Base
    config(UI);

var GFxObject CustomWeaponsKontener;
var transient array<byte> ActiveCustom1;
var transient array<byte> ActiveCustom2;
var transient bool bCustomChanged;
var transient array<byte> VisibleCustom1;
var transient array<byte> VisibleCustom2;
var transient array<byte> LockedCustom1;
var transient array<byte> LockedCustom2;
var GFxClikWidget Custom1List;
var GFxClikWidget Custom2List;
var transient int LastSelectedCustom1Index;
var transient int LastSelectedCustom2Index;

function bool Start(optional bool StartPaused = false)
{
    local AdvPlayerController PC;

    super.Start(StartPaused);
    Advance(0.0000000);
    PC = AdvPlayerController(GetPC());
    CustomWeaponsKontener = ButtonsMC.GetObject("weapons");
    Custom1List = GFxClikWidget(CustomWeaponsKontener.GetObject("custom1", Class'GFxUI.GFxClikWidget'));
    Custom2List = GFxClikWidget(CustomWeaponsKontener.GetObject("custom2", Class'GFxUI.GFxClikWidget'));
    ActiveCustom1.Remove(0, ActiveCustom1.Length);    
    ActiveCustom2.Remove(0, ActiveCustom2.Length);    
    PC.ProfileSettings.GetProfileSettingValueBlob(77, ActiveCustom1);
    PC.ProfileSettings.GetProfileSettingValueBlob(78, ActiveCustom2);
    bCustomChanged = false;
    VisibleCustom1.Remove(0, VisibleCustom1.Length);    
    LockedCustom1.Remove(0, LockedCustom1.Length);    
    VisibleCustom2.Remove(0, VisibleCustom2.Length);    
    LockedCustom2.Remove(0, LockedCustom2.Length);    
    CustomWeaponsKontener.GetObject("custom1TF").SetText(Class'AdvGFxUI_Menu_Options_Controls'.default.Custom1Text);
    CustomWeaponsKontener.GetObject("custom2TF").SetText(Class'AdvGFxUI_Menu_Options_Controls'.default.Custom2Text);
    HeaderTitleTF.SetText(Class'AdvGFxUI_Menu_Options_ControlsXbox'.default.CustomWeapString);
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
    Frontend.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function OnBack(EventData ev)
{
    // End:0x2B
    if(bHasChanges)
    {
        ShowSaveWarning(OnBackSelect);        
    }
    else
    {
        OnBackSelect(none, 'GenericNo', LocalPlayerOwnerIndex);
    }
    //return;    
}

function bool OnBackSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x25
    if(SelectedInputAlias == 'GenericYes')
    {
        SaveSettingsToProfile();        
    }
    else
    {
        DiscardChanges();
    }
    Action = "back";
    PlayCloseAnimation();
    return true;
    //return ReturnValue;    
}

function OnReset(EventData ev)
{
    ShowResetWarning(OnResetSelect);
    //return;    
}

function bool OnResetSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x21
    if(SelectedInputAlias == 'GenericYes')
    {
        ResetToDefaults();
    }
    ResetBtn.SetBool("focused", false);
    ResetBtn.SetBool("focused", true);
    return true;
    //return ReturnValue;    
}

function UpdateCustom1WeaponDataProvider()
{
    local int I, ListCounter;
    local GFxObject DataProvider, TempObj;

    ListCounter = 0;
    DataProvider = CreateArray();
    I = 0;
    J0x2A:

    // End:0xA1 [Loop If]
    if(I < VisibleCustom1.Length)
    {
        TempObj = CreateObject("Object");
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

    // End:0xA1 [Loop If]
    if(I < VisibleCustom2.Length)
    {
        TempObj = CreateObject("Object");
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
            EWFM = VisibleCustom1[LastSelectedCustom1Index];
            VisibleCustom1.InsertItem(SelectedIndex, EWFM);            
            VisibleCustom1.Remove(LastSelectedCustom1Index + 1, 1);                        
        }
        else
        {
            EWFM = VisibleCustom1[LastSelectedCustom1Index];
            VisibleCustom1.InsertItem(SelectedIndex + 1, EWFM);            
            VisibleCustom1.Remove(LastSelectedCustom1Index, 1);            
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
            EWFM = VisibleCustom2[LastSelectedCustom2Index];
            VisibleCustom2.InsertItem(SelectedIndex, EWFM);            
            VisibleCustom2.Remove(LastSelectedCustom2Index + 1, 1);                        
        }
        else
        {
            EWFM = VisibleCustom2[LastSelectedCustom2Index];
            VisibleCustom2.InsertItem(SelectedIndex + 1, EWFM);            
            VisibleCustom2.Remove(LastSelectedCustom2Index, 1);            
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
        // End:0x1F
        case "back":
            // End:0x25
            break;
        // End:0xFFFF
        default:
            // End:0x25
            break;
            break;
    }
    // End:0x78
    if(Frontend != none)
    {
        // End:0x75
        if(Frontend.OpenOptionsControlsXboxScreen())
        {
            Frontend.CloseOptionsControlsXboxCustomScreen();
        }        
    }
    else
    {
        // End:0x2AC
        if(ParentMenu != none)
        {
            ParentMenu.OptionsMenu = new Class'AdvGFxUI_Menu_Options_ControlsXbox';
            ParentMenu.OptionsMenu.SetPriority(69);
            // End:0x19A
            if(AdvGRI(GetPC().WorldInfo.GRI).IsPureSinglePlayerGame() || Class'Engine.Engine'.static.IsSplitScreen())
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
    local AdvPlayerController PC;
    local bool bProfileChanged;
    local int I;

    PC = AdvPlayerController(GetPC());
    bProfileChanged = InForceSave;
    ActiveCustom1.Remove(0, ActiveCustom1.Length);    
    I = 0;
    J0x58:

    // End:0x9E [Loop If]
    if(I < VisibleCustom1.Length)
    {
        ActiveCustom1.AddItem(VisibleCustom1[I]);        
        I++;
        // [Loop Continue]
        goto J0x58;
    }
    I = 0;
    J0xA9:

    // End:0xEF [Loop If]
    if(I < LockedCustom1.Length)
    {
        ActiveCustom1.AddItem(LockedCustom1[I]);        
        I++;
        // [Loop Continue]
        goto J0xA9;
    }
    ActiveCustom2.Remove(0, ActiveCustom2.Length);    
    I = 0;
    J0x110:

    // End:0x156 [Loop If]
    if(I < VisibleCustom2.Length)
    {
        ActiveCustom2.AddItem(VisibleCustom2[I]);        
        I++;
        // [Loop Continue]
        goto J0x110;
    }
    I = 0;
    J0x161:

    // End:0x1A7 [Loop If]
    if(I < LockedCustom2.Length)
    {
        ActiveCustom2.AddItem(LockedCustom2[I]);        
        I++;
        // [Loop Continue]
        goto J0x161;
    }
    PC.ProfileSettings.SetProfileSettingValueBlob(77, ActiveCustom1);
    PC.ProfileSettings.SetProfileSettingValueBlob(78, ActiveCustom2);
    // End:0x253
    if(bProfileChanged)
    {
        PC.ClientSaveAllPlayerData(true);
    }
    //return;    
}
