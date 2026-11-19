class AdvGFxUI_Menu_SurvivalPlayerSkin extends AdvGFxUI_Menu_Base
    config(UI);

const SKIN_TILE_NUM = 7;

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
var array<FamilyInfoToPackageName> CategoryElements;
var FamilyInfoToPackageName LastSelectedSkin;
var int LastSelectedSkinIndex;
var int PlayerLevel;
var array<AdvUIDataMultiSkinProvider> SkinProviderList;
var transient AdvPreGameGRI GRI;
var GFxObject TimeToStartTF;

function bool Start(optional bool StartPaused = false)
{
    local FamilyInfoToPackageName CurrentSkin, PlayerSkin;
    local int PlayerSkinIndex, PlayerXP, I;
    local array<UDKUIResourceDataProvider> ProviderList;
    local GFxObject PlayerLevelTF, PlayerXPTF, LevelMC;

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
    // End:0x1F3
    foreach Class'AdvCharacterStore'.default.FamilyInfosToPackages(CurrentSkin)
    {
        // End:0x1F2
        if(CurrentSkin.bAvailableInSurvival && CurrentSkin.bVisibleInMenu || Class'AdvGFxUI_Menu_MultiPlayerSkin'.static.CheckIfSkinIsAccessibleInDLC(CurrentSkin, AdvPlayerController(GetPC())))
        {
            CategoryElements.AddItem(CurrentSkin);            
        }        
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
    SkinLeftTF = ButtonsMC.GetObject("iconClassLeftTF");
    SkinRightTF = ButtonsMC.GetObject("iconClassRightTF");
    TimeToStartTF = ButtonsMC.GetObject("timetostartTF");
    GroupOptionStepper = GFxClikWidget(ButtonsMC.GetObject("skinchange", Class'GFxUI.GFxClikWidget'));
    SkinOptionStepper = GFxClikWidget(ButtonsMC.GetObject("skinchange2", Class'GFxUI.GFxClikWidget'));
    GroupLabelTF.SetVisible(false);
    GroupOptionStepper.SetVisible(false);
    // End:0x801
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        SkinOptionStepper.SetBool("visible", false);
        BackBtn.SetBool("visible", false);
        SaveBtn.SetBool("visible", false);
        SkinLeftTF.SetBool("html", true);
        SkinRightTF.SetBool("html", true);
        SkinLeftTF.SetString("htmlText", Localize("ControllerFont" $ ((AdvPlayerController(GetPC()).IsPCGamepadMode()) ? "_XBOX" : Class'AdvFrontEnd'.static.GetLocKeySuffix()), "Controller_LeftTrigger", "ADVGame"));
        SkinRightTF.SetString("htmlText", Localize("ControllerFont" $ ((AdvPlayerController(GetPC()).IsPCGamepadMode()) ? "_XBOX" : Class'AdvFrontEnd'.static.GetLocKeySuffix()), "Controller_RightTrigger", "ADVGame"));
    }
    SkinList = ButtonsMC.GetObject("SkinList");
    I = 0;
    J0x840:

    // End:0x993 [Loop If]
    if(I < 7)
    {
        SkinTile[I] = SkinList.GetObject("tile" $ string(I));
        SkinUILoader[I] = GFxClikWidget(SkinTile[I].GetObject("SkinTileMC").GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
        SkinUnlockTF[I] = SkinTile[I].GetObject("unlockTF");
        SkinUnlockTF[I].SetVisible(false);
        I++;
        // [Loop Continue]
        goto J0x840;
    }
    UpdateSkinOptionStepperDataProvider();
    PlayerSkin = Class'AdvCharacterStore'.default.FamilyInfosToPackages[AdvPlayerController(GetPC()).GetPlayerCharacterSV()];
    PlayerSkinIndex = CategoryElements.Find('FamilyInfoPath', PlayerSkin.FamilyInfoPath);    
    SkinOptionStepper.SetFloat("selectedIndex", float(PlayerSkinIndex));
    TitleTF.SetText(TitleString);
    LevelMC = ButtonsMC.GetObject("levelMC");
    PlayerLevelTF = ButtonsMC.GetObject("playerlevelTF");
    TitleTF = ButtonsMC.GetObject("nickTF");
    PlayerXPTF = ButtonsMC.GetObject("playerxpTF");
    LevelMC.SetVisible(false);
    PlayerLevelTF.SetVisible(false);
    TitleTF.SetVisible(false);
    PlayerXPTF.SetVisible(false);
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

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');    
    ButtonAliases.AddItem('GenericBack');    
    // End:0x7C
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        ButtonAliases.AddItem('PartyDetails');        
    }
    Frontend.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function UpdateSkinOptionStepperDataProvider()
{
    local int ListCounter;
    local GFxObject DataProvider, TempObj;
    local FamilyInfoToPackageName CurrentSkin;

    ListCounter = 0;
    DataProvider = CreateArray();
    // End:0xB1
    foreach CategoryElements(CurrentSkin)
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
    local int I, K;

    I = 0;
    J0x0B:

    // End:0xF4 [Loop If]
    if(I < 7)
    {
        K = (LastSelectedSkinIndex + I) - FFloor(7.0000000 / 2.0000000);
        // End:0xB6
        if((K >= 0) && K < CategoryElements.Length)
        {
            SetSkinTexture(I, CategoryElements[K].IconPath);            
        }
        else
        {
            SetSkinTexture(I, "UI_AdvCommon.Textures.Blank");
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
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
    LastSelectedSkin = CategoryElements[SelectionIndex];
    // End:0x179
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
    Class'AdvUIManager'.static.ShowUIMessage('PauseOptionConfirm', Localize("AdvGFxUI_Menu_MultiPlayerSkin", "SkinSelectionDiscard_Title", "AdvGame"), Localize("AdvGFxUI_Menu_MultiPlayerSkin", "SkinSelectionBody", "AdvGame"), ButtonAliases, OnExitOptionSelected, GetLP(),,,, false,,, true);
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

    Index = Class'AdvCharacterStore'.default.FamilyInfosToPackages.Find('FamilyInfoPath', LastSelectedSkin.FamilyInfoPath);    
    AdvPlayerController(GetPC()).SetPlayerCharacterSV(Index);
    AdvPlayerController(GetPC()).ClientSaveAllPlayerData();
    Action = "back";
    PlayCloseAnimation();
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
                    bTransitionResult = Frontend.OpenMultiSurvivalScreen();
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
        Frontend.CloseSurvivalSkinScreen();
    }
    Action = "";
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    local byte SelectionIndex;
    local EventData ev;

    // End:0x28C
    if(GetPC().WorldInfo.IsConsoleBuild(0) || GetPC().PlayerInput.bUsingGamepad)
    {
        // End:0x28C
        if((int(InputEvent) == int(0)) && ControllerId == GetLP().ControllerId)
        {
            // End:0x16B
            if(ButtonName == 'XboxTypeS_RightTrigger')
            {
                SelectionIndex = byte(SkinOptionStepper.GetFloat("selectedIndex"));
                // End:0x130
                if(int(SelectionIndex) < (CategoryElements.Length - 1))
                {
                    SelectionIndex++;
                }
                SkinOptionStepper.SetFloat("selectedIndex", float(SelectionIndex));
                return true;
            }
            // End:0x216
            if(ButtonName == 'XboxTypeS_LeftTrigger')
            {
                SelectionIndex = byte(SkinOptionStepper.GetFloat("selectedIndex"));
                // End:0x1DB
                if(int(SelectionIndex) != int(0))
                {
                    SelectionIndex--;
                }
                SkinOptionStepper.SetFloat("selectedIndex", float(SelectionIndex));
                return true;
            }
            // End:0x251
            if(ButtonName == 'XboxTypeS_B')
            {
                // End:0x24F
                if(!bIsPlayingCloseAnimation)
                {
                    OnBack(ev);
                }
                return true;
            }
            // End:0x28C
            if(ButtonName == 'XboxTypeS_A')
            {
                // End:0x28A
                if(!bIsPlayingCloseAnimation)
                {
                    OnSave(ev);
                }
                return true;
            }
        }
    }
    // End:0x2D6
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
    TitleString="Survival Skin"
    MovieInfoPath="UI_AdvUI.AdvPlayerSkin"
}