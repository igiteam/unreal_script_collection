class AdvGFxUI_Menu_MultiPlayerSkin extends AdvGFxUI_Menu_Base
    config(UI);

const SKIN_TILE_NUM = 7;

struct CategoryElements
{
    var array<FamilyInfoToPackageName> Elements;

    structdefaultproperties
    {
        Elements=none
    }
};

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxObject GroupLabelTF;
var GFxObject SkinLabelTF;
var GFxObject DescTF;
var GFxObject GroupLeftTF;
var GFxObject GroupRightTF;
var GFxObject SkinLeftTF;
var GFxObject SkinRightTF;
var GFxClikWidget BackBtn;
var GFxClikWidget SaveBtn;
var GFxClikWidget GroupOptionStepper;
var GFxClikWidget SkinOptionStepper;
var GFxObject SkinList;
var GFxObject SkinTile[7];
var GFxObject SkinUnlockTF[7];
var GFxClikWidget SkinUILoader[7];
var const localized string TitleString;
var const localized string GroupString;
var const localized string SkinSelectionDiscard_Title;
var const localized string SkinSelectionBody;
var AdvCharacterStore.ESkinCategory CurrentCategory;
var CategoryElements Categories[ESkinCategory];
var FamilyInfoToPackageName LastSelectedSkin;
var int LastSelectedSkinIndex;
var int PlayerLevel;
var array<AdvUIDataMultiSkinProvider> SkinProviderList;
var transient AdvPreGameGRI GRI;
var GFxObject TimeToStartTF;

static function bool CheckIfSkinIsAccessibleInDLC(const out FamilyInfoToPackageName FInfo, AdvPlayerController PC)
{
    // End:0x1DD
    if((((((FInfo.FamilyInfoPath == "AdvGameContent.AdvFamilyInfo_MP_ArmageddonMummy") || FInfo.FamilyInfoPath == "AdvGameContent.AdvFamilyInfo_MP_Devastator") || FInfo.FamilyInfoPath == "AdvGameContent.AdvFamilyInfo_MP_Devastator_01") || FInfo.FamilyInfoPath == "AdvGameContent.AdvFamilyInfo_MP_Mercenary_02") || FInfo.FamilyInfoPath == "AdvGameContent.AdvFamilyInfo_MP_Mummy") || FInfo.FamilyInfoPath == "AdvGameContent.AdvFamilyInfo_MP_Mummy_02")
    {
        return false;
    }
    return ((FInfo.DLCIndex > 0) ? int(PC.IsDLCInstalled(byte(FInfo.DLCIndex))) == int(1) : true);
    return false;
    //return ReturnValue;    
}

function bool Start(optional bool StartPaused = false)
{
    local FamilyInfoToPackageName CurrentSkin, PlayerSkin;
    local int PlayerSkinIndex, PlayerSkinCategoryIndex, PlayerXP;
    local array<int> LevelThresholds;
    local int I;
    local array<UDKUIResourceDataProvider> ProviderList;
    local ASDisplayInfo displayInfo;
    local GFxObject PlayerLevelTF, PlayerXPTF, LevelMC, XPmaskMC;

    super.Start(StartPaused);
    Advance(0.0000000);
    AdvPlayerController(GetPC()).ProfileSettings.GetProfileSettingValueInt(36, PlayerXP);
    PlayerLevel = Class'AdvPRI'.static.CalculatePlayerLevel(PlayerXP);
    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'AdvUIDataMultiSkinProvider', ProviderList);
    I = 0;
    J0xDF:

    // End:0x12E [Loop If]
    if(I < ProviderList.Length)
    {
        SkinProviderList.AddItem(AdvUIDataMultiSkinProvider(ProviderList[I]));        
        I++;
        // [Loop Continue]
        goto J0xDF;
    }
    // End:0x1EE
    foreach Class'AdvCharacterStore'.default.FamilyInfosToPackages(CurrentSkin)
    {
        // End:0x1ED
        if(CurrentSkin.bVisibleInMenu || CheckIfSkinIsAccessibleInDLC(CurrentSkin, AdvPlayerController(GetPC())))
        {
            Categories[int(CurrentSkin.SkinCategory)].Elements.AddItem(CurrentSkin);            
        }        
    }    
    I = 0;
    J0x1FA:

    // End:0x25C [Loop If]
    if(I < 4)
    {        
        Categories[I].Elements.Sort(CompareSkinStructure);        
        I++;
        // [Loop Continue]
        goto J0x1FA;
    }
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    SaveBtn = GFxClikWidget(ButtonsMC.GetObject("save_btn", Class'GFxUI.GFxClikWidget'));
    SaveBtn.SetString("label", Select);
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    TitleTF = TitleMC.GetObject("textField");
    GroupLabelTF = ButtonsMC.GetObject("skinTF");
    SkinLabelTF = ButtonsMC.GetObject("classTF");
    GroupLeftTF = ButtonsMC.GetObject("iconSkinLeftTF");
    GroupRightTF = ButtonsMC.GetObject("iconSkinRightTF");
    SkinLeftTF = ButtonsMC.GetObject("iconClassLeftTF");
    SkinRightTF = ButtonsMC.GetObject("iconClassRightTF");
    TimeToStartTF = ButtonsMC.GetObject("timetostartTF");
    GroupOptionStepper = GFxClikWidget(ButtonsMC.GetObject("skinchange", Class'GFxUI.GFxClikWidget'));
    SkinOptionStepper = GFxClikWidget(ButtonsMC.GetObject("skinchange2", Class'GFxUI.GFxClikWidget'));
    // End:0xA88
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        GroupOptionStepper.SetBool("visible", false);
        SkinOptionStepper.SetBool("visible", false);
        BackBtn.SetBool("visible", false);
        SaveBtn.SetBool("visible", false);
        GroupLeftTF.SetBool("html", true);
        GroupRightTF.SetBool("html", true);
        SkinLeftTF.SetBool("html", true);
        SkinRightTF.SetBool("html", true);
        GroupLeftTF.SetString("htmlText", Localize("ControllerFont" $ ((AdvPlayerController(GetPC()).IsPCGamepadMode()) ? "_XBOX" : Class'AdvFrontEnd'.static.GetLocKeySuffix()), "Controller_LeftBumper", "ADVGame"));
        GroupRightTF.SetString("htmlText", Localize("ControllerFont" $ ((AdvPlayerController(GetPC()).IsPCGamepadMode()) ? "_XBOX" : Class'AdvFrontEnd'.static.GetLocKeySuffix()), "Controller_RightBumper", "ADVGame"));
        SkinLeftTF.SetString("htmlText", Localize("ControllerFont" $ ((AdvPlayerController(GetPC()).IsPCGamepadMode()) ? "_XBOX" : Class'AdvFrontEnd'.static.GetLocKeySuffix()), "Controller_LeftTrigger", "ADVGame"));
        SkinRightTF.SetString("htmlText", Localize("ControllerFont" $ ((AdvPlayerController(GetPC()).IsPCGamepadMode()) ? "_XBOX" : Class'AdvFrontEnd'.static.GetLocKeySuffix()), "Controller_RightTrigger", "ADVGame"));
    }
    SkinList = ButtonsMC.GetObject("SkinList");
    I = 0;
    J0xAC7:

    // End:0xBF0 [Loop If]
    if(I < 7)
    {
        SkinTile[I] = SkinList.GetObject("tile" $ string(I));
        SkinUILoader[I] = GFxClikWidget(SkinTile[I].GetObject("SkinTileMC").GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
        SkinUnlockTF[I] = SkinTile[I].GetObject("unlockTF");
        I++;
        // [Loop Continue]
        goto J0xAC7;
    }
    UpdateGroupOptionStepperDataProvider();
    UpdateSkinOptionStepperDataProvider();
    PlayerSkin = Class'AdvCharacterStore'.default.FamilyInfosToPackages[AdvPlayerController(GetPC()).GetPlayerCharacterMP()];
    PlayerSkinCategoryIndex = int(PlayerSkin.SkinCategory);
    PlayerSkinIndex = Categories[int(PlayerSkin.SkinCategory)].Elements.Find('FamilyInfoPath', PlayerSkin.FamilyInfoPath);    
    GroupOptionStepper.SetFloat("selectedIndex", float(PlayerSkinCategoryIndex));
    SkinOptionStepper.SetFloat("selectedIndex", float(PlayerSkinIndex));
    TitleTF.SetText(TitleString);
    LevelMC = ButtonsMC.GetObject("levelMC");
    LevelThresholds = Class'AdvClassInfo_MP_Base'.default.LevelThresholds;
    displayInfo.hasXScale = true;
    // End:0xE92
    if(PlayerLevel < LevelThresholds.Length)
    {
        displayInfo.XScale = (float(PlayerXP - LevelThresholds[PlayerLevel - 1]) / float(LevelThresholds[PlayerLevel] - LevelThresholds[PlayerLevel - 1])) * 100.0000000;        
    }
    else
    {
        displayInfo.XScale = 100.0000000;
    }
    XPmaskMC = LevelMC.GetObject("xpmaskMC");
    XPmaskMC.SetDisplayInfo(displayInfo);
    PlayerLevelTF = ButtonsMC.GetObject("playerlevelTF");
    TitleTF = ButtonsMC.GetObject("nickTF");
    PlayerXPTF = ButtonsMC.GetObject("playerxpTF");
    PlayerLevelTF.SetText(((Repl(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "PlayerLevelStr", "ADVGame"), "`l", string(PlayerLevel)) @ " [") @ (Localize("AdvGFxUI_Menu_MultiPlayerSettings", ("PlayerLevelString[" $ string(Class'AdvGFxUI_Menu_MultiPlayerSettings'.static.GetRankGroupNumber(PlayerLevel))) $ "]", "ADVGame"))) @ "]");
    TitleTF.SetText(GetPC().PlayerReplicationInfo.PlayerName);
    // End:0x11AA
    if(Class'AdvClassInfo_MP_Base'.default.LevelThresholds.Length == PlayerLevel)
    {
        PlayerXPTF.SetText(Repl(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "PlayerXPStr", "ADVGame"), "`x", string(PlayerXP)));        
    }
    else
    {
        PlayerXPTF.SetText((Repl(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "PlayerXPStr", "ADVGame"), "`x", string(PlayerXP)) @ "/") @ string(LevelThresholds[PlayerLevel]));
    }
    return true;
    //return ReturnValue;    
}

function int CompareSkinStructure(FamilyInfoToPackageName A, FamilyInfoToPackageName B)
{
    // End:0x42
    if(A.UnlockLevel == B.UnlockLevel)
    {
        return 0;        
    }
    else
    {
        // End:0x88
        if(A.UnlockLevel > B.UnlockLevel)
        {
            return -1;            
        }
        else
        {
            return 1;
        }
    }
    //return ReturnValue;    
}

function bool SkinIsUnlocked(int SkinIndex)
{
    return PlayerLevel >= Categories[int(CurrentCategory)].Elements[SkinIndex].UnlockLevel;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    // End:0x2C
    if(SkinIsUnlocked(LastSelectedSkinIndex))
    {
        ButtonAliases.AddItem('GenericSelect');        
    }
    ButtonAliases.AddItem('GenericBack');    
    // End:0x92
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        ButtonAliases.AddItem('PartyDetails');        
    }
    Frontend.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function UpdateGroupOptionStepperDataProvider()
{
    local int I, ListCounter;
    local GFxObject DataProvider, TempObj;

    ListCounter = 0;
    DataProvider = CreateArray();
    I = 0;
    J0x2A:

    // End:0x10E [Loop If]
    if(I < 4)
    {
        TempObj = CreateObject("Object");
        TempObj.SetString("label", Localize("AdvCharacterStore", Class'AdvCharacterStore'.default.SkinCategory[I], "AdvGame"));
        DataProvider.SetElementObject(ListCounter++, TempObj);
        I++;
        // [Loop Continue]
        goto J0x2A;
    }
    GroupOptionStepper.SetObject("dataProvider", DataProvider);
    //return;    
}

function UpdateSkinOptionStepperDataProvider()
{
    local int ListCounter;
    local GFxObject DataProvider, TempObj;
    local FamilyInfoToPackageName CurrentSkin;

    ListCounter = 0;
    DataProvider = CreateArray();
    // End:0xD0
    foreach Categories[int(CurrentCategory)].Elements(CurrentSkin)
    {
        TempObj = CreateObject("Object");
        TempObj.SetString("label", "");
        DataProvider.SetElementObject(ListCounter++, TempObj);        
    }    
    SkinOptionStepper.SetObject("dataProvider", DataProvider);
    SkinOptionStepper.SetFloat("selectedIndex", 0.0000000);
    //return;    
}

function UpdateSkinTiles()
{
    local int I, K, UnlockLevel;
    local string UnlockString;

    I = 0;
    J0x0B:

    // End:0x240 [Loop If]
    if(I < 7)
    {
        K = (LastSelectedSkinIndex + I) - FFloor(7.0000000 / 2.0000000);
        // End:0x1EC
        if((K >= 0) && K < Categories[int(CurrentCategory)].Elements.Length)
        {
            SetSkinTexture(I, Categories[int(CurrentCategory)].Elements[K].IconPath);
            UnlockLevel = Categories[int(CurrentCategory)].Elements[K].UnlockLevel;
            UnlockString = Repl(Localize("AdvGFxUI_Menu_MultiPlayerSettings", "UnlockStr", "AdvGame"), "`l", string(UnlockLevel));
            // End:0x1CC
            if(SkinIsUnlocked(K))
            {
                SetSkinLockedState(I, false, "");                
            }
            else
            {
                SetSkinLockedState(I, true, UnlockString);
            }            
        }
        else
        {
            SetSkinTexture(I, "UI_AdvCommon.Textures.Blank");
            SetSkinLockedState(I, false, "");
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    UpdateSaveAbility();
    //return;    
}

function UpdateSaveAbility()
{
    // End:0x75
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        UpdateFooter();        
    }
    else
    {
        // End:0xB8
        if(SkinIsUnlocked(LastSelectedSkinIndex))
        {
            SaveBtn.SetBool("disabled", false);            
        }
        else
        {
            SaveBtn.SetBool("disabled", true);
        }
    }
    //return;    
}

function SetSkinTexture(int Index, string TexPath)
{
    // End:0x55
    if(Index < 7)
    {
        SkinUILoader[Index].SetString("source", "img://" $ TexPath);
    }
    //return;    
}

function SetSkinLockedState(int Index, bool bIsLocked, string LockedText)
{
    // End:0x8B
    if(Index < 7)
    {
        SkinTile[Index].GotoAndStop(((bIsLocked) ? "locked" : "normal"));
        SkinUnlockTF[Index].SetText(LockedText);
    }
    //return;    
}

function OnSkinSwitch(EventData ev)
{
    local byte SelectionIndex;

    SelectionIndex = byte(GroupOptionStepper.GetFloat("selectedIndex"));
    CurrentCategory = SelectionIndex;
    UpdateSkinOptionStepperDataProvider();
    // End:0x12F
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        GroupLabelTF.SetText(Localize("AdvCharacterStore", Class'AdvCharacterStore'.default.SkinCategory[int(SelectionIndex)], "AdvGame"));
    }
    //return;    
}

function OnSkinSwitch2(EventData ev)
{
    local int SelectionIndex;

    SelectionIndex = int(SkinOptionStepper.GetFloat("selectedIndex"));
    // End:0x79
    if(SelectionIndex > LastSelectedSkinIndex)
    {
        SkinList.GotoAndPlay("next");        
    }
    else
    {
        // End:0xB5
        if(SelectionIndex < LastSelectedSkinIndex)
        {
            SkinList.GotoAndPlay("prev");
        }
    }
    LastSelectedSkinIndex = SelectionIndex;
    UpdateSkinTiles();
    LastSelectedSkin = Categories[int(CurrentCategory)].Elements[SelectionIndex];
    // End:0x198
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        SkinLabelTF.SetText("");
    }
    //return;    
}

function OnBack(EventData ev)
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericYes');    
    ButtonAliases.AddItem('GenericNo');    
    Class'AdvUIManager'.static.ShowUIMessage('PauseOptionConfirm', SkinSelectionDiscard_Title, SkinSelectionBody, ButtonAliases, OnExitOptionSelected, GetLP(),,,, false,,, true);
    //return;    
}

function bool OnExitOptionSelected(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
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

function OnSave(EventData ev)
{
    local int Index;

    // End:0xDE
    if(SkinIsUnlocked(LastSelectedSkinIndex))
    {
        Index = Class'AdvCharacterStore'.default.FamilyInfosToPackages.Find('FamilyInfoPath', LastSelectedSkin.FamilyInfoPath);        
        AdvPlayerController(GetPC()).SetPlayerCharacterMP(Index);
        AdvPlayerController(GetPC()).ClientSaveAllPlayerData();
        Action = "back";
        PlayCloseAnimation();
    }
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x126
        case "back":
            // End:0x8E
            if(Frontend.bPreGameLobby && AdvFrontEndParty(Frontend) != none)
            {
                bTransitionResult = AdvFrontEndParty(Frontend).OpenClientLobbyScreen();                
            }
            else
            {
                // End:0xF9
                if(((GetMenuGame()) == none) || GetMenuGRI().IsInPregameLobby())
                {
                    bTransitionResult = AdvFrontEndParty(Frontend).OpenPregameLobbyScreen();                    
                }
                else
                {
                    bTransitionResult = Frontend.OpenMultiMenuScreen();
                }
            }
            // End:0x12C
            break;
        // End:0xFFFF
        default:
            // End:0x12C
            break;
            break;
    }
    // End:0x158
    if(bTransitionResult)
    {
        Frontend.CloseMultiPlayerSkinScreen();
    }
    Action = "";
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    local byte SelectionIndex;
    local EventData ev;

    // End:0x402
    if(GetPC().WorldInfo.IsConsoleBuild(0) || GetPC().PlayerInput.bUsingGamepad)
    {
        // End:0x402
        if((int(InputEvent) == int(0)) && ControllerId == GetLP().ControllerId)
        {
            // End:0x18A
            if(ButtonName == 'XboxTypeS_RightTrigger')
            {
                SelectionIndex = byte(SkinOptionStepper.GetFloat("selectedIndex"));
                // End:0x14F
                if(int(SelectionIndex) < (Categories[int(CurrentCategory)].Elements.Length - 1))
                {
                    SelectionIndex++;
                }
                SkinOptionStepper.SetFloat("selectedIndex", float(SelectionIndex));
                return true;
            }
            // End:0x235
            if(ButtonName == 'XboxTypeS_LeftTrigger')
            {
                SelectionIndex = byte(SkinOptionStepper.GetFloat("selectedIndex"));
                // End:0x1FA
                if(int(SelectionIndex) != int(0))
                {
                    SelectionIndex--;
                }
                SkinOptionStepper.SetFloat("selectedIndex", float(SelectionIndex));
                return true;
            }
            // End:0x2E1
            if(ButtonName == 'XboxTypeS_RightShoulder')
            {
                SelectionIndex = byte(GroupOptionStepper.GetFloat("selectedIndex"));
                // End:0x2A6
                if(int(SelectionIndex) < (4 - 1))
                {
                    SelectionIndex++;
                }
                GroupOptionStepper.SetFloat("selectedIndex", float(SelectionIndex));
                return true;
            }
            // End:0x38C
            if(ButtonName == 'XboxTypeS_LeftShoulder')
            {
                SelectionIndex = byte(GroupOptionStepper.GetFloat("selectedIndex"));
                // End:0x351
                if(int(SelectionIndex) != int(0))
                {
                    SelectionIndex--;
                }
                GroupOptionStepper.SetFloat("selectedIndex", float(SelectionIndex));
                return true;
            }
            // End:0x3C7
            if(ButtonName == 'XboxTypeS_B')
            {
                // End:0x3C5
                if(!bIsPlayingCloseAnimation)
                {
                    OnBack(ev);
                }
                return true;
            }
            // End:0x402
            if(ButtonName == 'XboxTypeS_A')
            {
                // End:0x400
                if(!bIsPlayingCloseAnimation)
                {
                    OnSave(ev);
                }
                return true;
            }
        }
    }
    // End:0x44C
    if(Frontend != none)
    {
        return Frontend.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    }
    return false;
    //return ReturnValue;    
}

function SetDelegates()
{
    GRI = AdvPreGameGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0xCA
    if(GRI != none)
    {
        GRI.__OnLobbyStateChanged__Delegate = LobbyStateChanged;
        GRI.__OnSelectionCountdownTick__Delegate = SelectionCountdownTick;
        LobbyStateChanged();
        SelectionCountdownTick();
    }
    //return;    
}

function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    // End:0x2C
    if(GRI == none)
    {
        SetDelegates();
    }
    //return;    
}

simulated function LobbyStateChanged()
{
    switch(GRI.PreGameLobbyState)
    {
        // End:0x2D
        case 0:
        // End:0x73
        case 1:
            TimeToStartTF.SetText(Class'AdvGFxUI_Menu_PregameLobby'.default.PreparingGameString);
            // End:0x150
            break;
        // End:0xB9
        case 2:
            TimeToStartTF.SetText(Class'AdvGFxUI_Menu_PregameLobby'.default.WaitingForPlayersString);
            // End:0x150
            break;
        // End:0xC1
        case 4:
            // End:0x150
            break;
        // End:0xC6
        case 5:
        // End:0x10C
        case 6:
            TimeToStartTF.SetText(Class'AdvGFxUI_Menu_PregameLobby'.default.StartingGameString);
            // End:0x150
            break;
        // End:0xFFFF
        default:
            TimeToStartTF.SetText(Class'AdvGFxUI_Menu_PregameLobby'.default.PreparingGameString);
            // End:0x150
            break;
            break;
    }
    //return;    
}

simulated function SelectionCountdownTick()
{
    local string Time;

    // End:0xD0
    if(int(GRI.PreGameLobbyState) == int(4))
    {
        // End:0x7F
        if(int(GRI.RemainingGameVoteSeconds) > int(0))
        {
            Time = string(GRI.RemainingGameVoteSeconds);            
        }
        else
        {
            Time = Class'AdvGFxUI_Menu_PregameLobby'.default.StartingGameString;
        }
        TimeToStartTF.SetText(Time);
    }
    //return;    
}

defaultproperties
{
    TitleString="Multiplayer Skin"
    GroupString="Category"
    SkinSelectionDiscard_Title="Discard changes"
    SkinSelectionBody="Your choice will be lost. Do you want to continue?"
    MovieInfoPath="UI_AdvUI.AdvPlayerSkin"
}