class AdvGFxUI_Menu_SaveMenu extends AdvGFxUI_Menu_Options_Base
    config(UI);

enum eSaveMenuWhatToDoNext
{
    SMWTDN_JustClose,               // 0
    SMWTDM_OpenAdventureMenu,       // 1
    eSaveMenuWhatToDoNext_MAX       // 2
};

struct TSaveSlotMC
{
    var GFxObject SlotMC;
    var GFxObject NameTF;
    var GFxObject DateTF;
    var GFxObject DescTF;
    var GFxObject DifficultyTF;
    var GFxObject Difficulty2TF;
    var GFxClikWidget SaveBtn;

    structdefaultproperties
    {
        SlotMC=none
        NameTF=none
        DateTF=none
        DescTF=none
        DifficultyTF=none
        Difficulty2TF=none
        SaveBtn=none
    }
};

var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxObject SaveMC;
var GFxClikWidget AcceptBtn;
var AdvGFxUI_Menu_SaveMenu.eSaveMenuWhatToDoNext ActionAfterClose;
var TSaveSlotMC SaveSlotsMC[3];
var const localized string TitleString;
var const localized string EmptySlotString;
var const localized string DateFormat;
var const localized string ShortDateFormat;
var const localized string NumericDateFormat;
var array<UTUIDataProvider_MapInfo> LocalMapList;
var AdvEngine CachedAdvEngine;

function Init(optional LocalPlayer Player)
{
    super.Init(Player);
    //return;    
}

function bool Start(optional bool StartPaused = false)
{
    local int I, LatestUsedSlotIndex;

    super(AdvGFxUI_Menu_Base).Start(StartPaused);
    Advance(0.0000000);
    CachedAdvEngine = AdvEngine(Class'AdvEngine'.static.GetEngine());
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    SaveMC = ButtonsMC.GetObject("saveBtnMC");
    I = 0;
    J0x133:

    // End:0x4A9 [Loop If]
    if(I < 3)
    {
        SaveSlotsMC[I].SlotMC = SaveMC.GetObject("save" $ string(I + 1));
        SaveSlotsMC[I].NameTF = SaveSlotsMC[I].SlotMC.GetObject("mapnameTF");
        SaveSlotsMC[I].DateTF = SaveSlotsMC[I].SlotMC.GetObject("dateTF");
        SaveSlotsMC[I].DescTF = SaveSlotsMC[I].SlotMC.GetObject("descTF");
        SaveSlotsMC[I].DifficultyTF = SaveSlotsMC[I].SlotMC.GetObject("difficultyTF");
        SaveSlotsMC[I].Difficulty2TF = SaveSlotsMC[I].SlotMC.GetObject("difficulty2TF");
        SaveSlotsMC[I].SaveBtn = GFxClikWidget(SaveSlotsMC[I].SlotMC.GetObject("Button", Class'GFxUI.GFxClikWidget'));
        SaveSlotsMC[I].SaveBtn.SetString("label", string(I + 1));
        I++;
        // [Loop Continue]
        goto J0x133;
    }
    AcceptBtn = GFxClikWidget(ButtonsMC.GetObject("accept_btn", Class'GFxUI.GFxClikWidget'));
    AcceptBtn.SetBool("visible", false);
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x61F
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    TitleTF.SetText(TitleString);
    // End:0x67B
    if(Frontend != none)
    {
        RootMC.GotoAndStopI(2);        
    }
    else
    {
        UpdateFooter();
    }
    PrepareMapList();
    I = 0;
    J0x69A:

    // End:0x6CB [Loop If]
    if(I < 3)
    {
        FillSaveSlotWithMapInformation(I);
        I++;
        // [Loop Continue]
        goto J0x69A;
    }
    CachedAdvEngine.SelectedSaveSlot = 0;
    LatestUsedSlotIndex = Class'AdvFrontEnd'.static.GetLatestSaveSlotIndex();
    // End:0x795
    if(LatestUsedSlotIndex != -1)
    {
        SaveSlotsMC[LatestUsedSlotIndex].SaveBtn.SetBool("focused", true);
        CachedAdvEngine.SelectedSaveSlot = LatestUsedSlotIndex;
    }
    return true;
    //return ReturnValue;    
}

function PrepareMapList()
{
    local int I;
    local array<UDKUIResourceDataProvider> ProviderList;

    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
    I = 0;
    J0x3C:

    // End:0x8B [Loop If]
    if(I < ProviderList.Length)
    {
        LocalMapList.AddItem(UTUIDataProvider_MapInfo(ProviderList[I]));        
        I++;
        // [Loop Continue]
        goto J0x3C;
    }
    //return;    
}

function int GetLocalMapListIndexForChapterNum(int ChapterNum)
{
    local int Result, Index;
    local UTUIDataProvider_MapInfo ItMapInfo;

    Result = -1;
    // End:0xC0
    if(ChapterNum < Class'EvilGame.EvilTypesNative'.default.ChapterLevelNames.Length)
    {
        // End:0xBF
        foreach LocalMapList(ItMapInfo, Index)
        {
            // End:0xBE
            if(Class'EvilGame.EvilTypesNative'.default.ChapterLevelNames[ChapterNum] == name(ItMapInfo.MapName))
            {
                Result = Index;                
            }
            else
            {                
            }
        }        
    }
    return Result;
    //return ReturnValue;    
}

function string GetLocalizedMapNameForChapterNum(int ChapterNum)
{
    local string localizedMapName;
    local int LocalMapListIndex;

    LocalMapListIndex = GetLocalMapListIndexForChapterNum(ChapterNum);
    // End:0x65
    if(LocalMapListIndex != -1)
    {
        localizedMapName = LocalMapList[LocalMapListIndex].FriendlyName;        
    }
    else
    {
        localizedMapName = Localize("FrontEndStrings", "DLCLabel", "ADVGame");
    }
    return localizedMapName;
    //return ReturnValue;    
}

function string GetNumericDateString(int Slot)
{
    local string DateString;
    local int Year, Month, Day;

    Year = CachedAdvEngine.SaveSlotData[Slot].Year;
    Month = CachedAdvEngine.SaveSlotData[Slot].Month;
    Day = CachedAdvEngine.SaveSlotData[Slot].Day;
    DateString = Repl(NumericDateFormat, "*y", string(Year));
    DateString = Repl(DateString, "*m", ((Month < 10) ? "0" $ string(Month) : string(Month)));
    return Repl(DateString, "*d", ((Day < 10) ? "0" $ string(Day) : string(Day)));
    //return ReturnValue;    
}

function string ConvertSecondsSinceMidnightToString(int Slot)
{
    local string ResultTime;
    local int SecondsSinceMidnight, Hour, Min;

    SecondsSinceMidnight = CachedAdvEngine.SaveSlotData[Slot].SecondsSinceMidnight;
    Hour = SecondsSinceMidnight / 3600;
    SecondsSinceMidnight -= (Hour * 3600);
    Min = (SecondsSinceMidnight / 60) % 60;
    SecondsSinceMidnight -= (Min * 60);
    ResultTime = ((Hour > 9) ? "" $ string(Hour) : "0" $ string(Hour)) $ ":";    
    ResultTime $= ((Min > 9) ? "" $ string(Min) : "0" $ string(Min));
    return ResultTime;
    //return ReturnValue;    
}

function string ConvertGameplayTimeToString(int Seconds)
{
    local string Result;

    Result = Class'AdvGFxUI_Scoreboard'.static.FormatTime(Seconds);
    return Result;
    //return ReturnValue;    
}

function FillSaveSlotWithMapInformation(int Slot)
{
    local class<EvilDifficultySettings> DiffPuzzleSettings, DiffFightSettings;
    local int DLCIndex;

    SaveSlotsMC[Slot].NameTF.SetText("");
    SaveSlotsMC[Slot].DateTF.SetText("");
    // End:0x286
    if(CachedAdvEngine.SaveSlotData[Slot].bIsCorrupted)
    {
        DLCIndex = Class'AdvEngine'.static.ConvertLidEnumToDLCIndex(CachedAdvEngine.SaveSlotData[Slot].HeaderData.ChapterNum);
        // End:0x202
        if((DLCIndex > 0) && !CachedAdvEngine.UserHasDLC(DLCIndex, GetAdvPC()))
        {
            SaveSlotsMC[Slot].NameTF.SetText(Localize("MessageBoxErrorStrings", "PlaylistRequiresDLC_Title", "ADVGame"));            
        }
        else
        {
            SaveSlotsMC[Slot].NameTF.SetText(Localize("MessageBoxErrorStrings", "SaveDataCorrupted_Title", "ADVGame"));
        }        
    }
    else
    {
        // End:0x632
        if(CachedAdvEngine.SaveSlotData[Slot].bContainsData)
        {
            DiffPuzzleSettings = Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(CachedAdvEngine.SaveSlotData[Slot].HeaderData.Difficulty);
            DiffFightSettings = Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(CachedAdvEngine.SaveSlotData[Slot].HeaderData.DifficultyOther);
            SaveSlotsMC[Slot].NameTF.SetText(GetLocalizedMapNameForChapterNum(int(CachedAdvEngine.SaveSlotData[Slot].HeaderData.ChapterNum)));
            SaveSlotsMC[Slot].DateTF.SetText((ConvertSecondsSinceMidnightToString(Slot)) @ (GetNumericDateString(Slot)));
            SaveSlotsMC[Slot].DifficultyTF.SetText(((Localize("AdvGFxUI_Menu_DifficultyMenu", "FightString", "ADVGame")) $ ":") @ DiffFightSettings.default.DifficultyName);
            SaveSlotsMC[Slot].Difficulty2TF.SetText(((Localize("AdvGFxUI_Menu_DifficultyMenu", "PuzzleString", "ADVGame")) $ ":") @ DiffPuzzleSettings.default.DifficultyName);
            SaveSlotsMC[Slot].DescTF.SetText("");            
        }
        else
        {
            SaveSlotsMC[Slot].NameTF.SetText(EmptySlotString);
        }
    }
    //return;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');    
    ButtonAliases.AddItem('GenericBack');    
    // End:0x7B
    if(Frontend != none)
    {
        Frontend.footer.FooterUpdate(ButtonAliases);        
    }
    else
    {
        // End:0xC7
        if(ParentMenu != none)
        {
            ParentMenu.footer.FooterUpdate(ButtonAliases);
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

function OnAcceptBtn(EventData ev)
{
    //return;    
}

function OnSave1(EventData ev)
{
    CachedAdvEngine.SelectedSaveSlot = 0;
    // End:0x2F
    if(CheckIfCheckpointIsCorruptedOrWithoutDLC())
    {
        return;
    }
    Action = "accept";
    PlayCloseAnimation();
    //return;    
}

function OnSave2(EventData ev)
{
    CachedAdvEngine.SelectedSaveSlot = 1;
    // End:0x2F
    if(CheckIfCheckpointIsCorruptedOrWithoutDLC())
    {
        return;
    }
    Action = "accept";
    PlayCloseAnimation();
    //return;    
}

function OnSave3(EventData ev)
{
    CachedAdvEngine.SelectedSaveSlot = 2;
    // End:0x30
    if(CheckIfCheckpointIsCorruptedOrWithoutDLC())
    {
        return;
    }
    Action = "accept";
    PlayCloseAnimation();
    //return;    
}

function bool CheckIfCheckpointIsCorruptedOrWithoutDLC()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local int DLCIndex;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x2DB
    if(CachedAdvEngine.SaveSlotData[CachedAdvEngine.SelectedSaveSlot].bIsCorrupted)
    {
        DLCIndex = Class'AdvEngine'.static.ConvertLidEnumToDLCIndex(CachedAdvEngine.SaveSlotData[CachedAdvEngine.SelectedSaveSlot].HeaderData.ChapterNum);
        // End:0x246
        if(DLCIndex == -1)
        {
            ButtonAliases.AddItem('AcceptDelete');            
            ButtonAliases.AddItem('GenericCancel');            
            UIManager.ShowUIMessage('NoStorageDevice', "<Strings:ADVGame.MessageBoxErrorStrings.ErrorLoadingSaveGame_Title>", "<Strings:ADVGame.MessageBoxErrorStrings.ErrorLoadingSaveGameDelete_Message>", ButtonAliases, Frontend.OnCheckpointCorrupted);            
        }
        else
        {
            // End:0x2D9
            if((DLCIndex != -1) && !CachedAdvEngine.UserHasDLC(DLCIndex, GetAdvPC()))
            {
                Frontend.MissingDLCIndex = DLCIndex;
                Frontend.ShowMarketPlaceOnCheckPointCorrupted();
            }
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function OnCloseAnimationComplete()
{
    local float X, Y;
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x93
        case "accept":
            Frontend.PrepareCheckpointSystem(AdvPlayerController(GetPC()));
            Frontend.OpenCampaignScreen();
            Frontend.CloseSaveScreen();
            return;
            // End:0xA5
            break;
        // End:0x9F
        case "back":
            // End:0xA5
            break;
        // End:0xFFFF
        default:
            // End:0xA5
            break;
            break;
    }
    // End:0x14E
    if(Frontend != none)
    {
        // End:0xF5
        if(int(ActionAfterClose) == int(1))
        {
            bTransitionResult = Frontend.OpenMainMenu();            
        }
        else
        {
            bTransitionResult = Frontend.OpenOptionsScreen();
        }
        // End:0x14B
        if(bTransitionResult)
        {
            Frontend.CloseSaveScreen();
        }        
    }
    else
    {
        // End:0x3A1
        if(ParentMenu != none)
        {
            ParentMenu.OptionsMenu = new Class'AdvGFxUI_Menu_OptionsMenu';
            ParentMenu.OptionsMenu.SetPriority(69);
            // End:0x270
            if(AdvGRI(GetPC().WorldInfo.GRI).IsPureSinglePlayerGame() || Class'Engine.Engine'.static.IsSplitScreen())
            {
                ParentMenu.OptionsMenu.bPauseGameWhileActive = true;
            }
            ParentMenu.OptionsMenu.ParentMenu = ParentMenu;
            ParentMenu.OptionsMenu.Init(GetLP());
            KursorMC.GetPosition(X, Y);
            ParentMenu.OptionsMenu.KursorMC.SetPosition(X, Y);
            ParentMenu.UpdateFooter();
            Close();
        }
    }
    Action = "";
    //return;    
}

defaultproperties
{
    TitleString="Select save slot"
    EmptySlotString="Empty"
    DateFormat="*m *d, *y"
    ShortDateFormat="*m *d"
    NumericDateFormat="*m/*d/*y"
    MovieInfoPath="UI_AdvUI.AdvSaveSlot"
}