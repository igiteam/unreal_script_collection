class AdvGFxUI_Menu_MultiMenuGametype extends AdvGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxObject PlaylistDescription;
var GFxClikWidget CustomBtn;
var GFxClikWidget BackBtn;
var GFxClikWidget PlaylistList;
var array<GFxClikWidget> PlaylistButtons;
var const localized string TitleString;
var const localized string SurvivalTitleString;
var const localized string CustomString;
var int SelectedButtonIdx;
var array<OnlinePlaylistProvider> PlaylistArray;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    PlaylistList = GFxClikWidget(ButtonsMC.GetObject("ScrollingList", Class'GFxUI.GFxClikWidget'));
    PlaylistDescription = ButtonsMC.GetObject("textField");
    PlaylistDescription.SetText(" ");
    BackBtn.SetString("label", back);
    // End:0x269
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    UpdatePlaylistList();
    return true;
    //return ReturnValue;    
}

function UpdatePlaylistList()
{
    local GFxObject DataProvider, TempObj;
    local int I, ListCounter;
    local OnlinePlaylistProvider AdvProvider;
    local array<UIResourceDataProvider> Providers;
    local name ProviderTag;
    local UIDataStore_OnlinePlaylists PlaylistDS;
    local int SelectedIndex;

    // End:0x75
    if(int(GetMenuGame().MultiGameModeSelected) == int(3))
    {
        ProviderTag = name("PlaylistsSurvival");
        TitleTF.SetText(SurvivalTitleString);        
    }
    else
    {
        ProviderTag = name("PlaylistsUnranked");
        TitleTF.SetText(TitleString);
    }
    PlaylistDS = UIDataStore_OnlinePlaylists(Class'Engine.UIRoot'.static.StaticResolveDataStore(Class'IpDrv.UIDataStore_OnlinePlaylists'.default.Tag));
    // End:0x14E
    if(PlaylistDS != none)
    {
        PlaylistDS.GetResourceProviders(ProviderTag, Providers);
    }
    DataProvider = CreateArray();
    I = 0;
    J0x16D:

    // End:0x29B [Loop If]
    if(I < Providers.Length)
    {
        AdvProvider = OnlinePlaylistProvider(Providers[I]);
        // End:0x28D
        if((AdvProvider != none) && AdvProvider.DisplayName != "")
        {
            PlaylistArray.AddItem(AdvProvider);            
            TempObj = CreateObject("Object");
            TempObj.SetString("label", AdvProvider.DisplayName);
            DataProvider.SetElementObject(ListCounter++, TempObj);
        }
        I++;
        // [Loop Continue]
        goto J0x16D;
    }
    PlaylistList.SetObject("dataProvider", DataProvider);
    SelectedIndex = int(PlaylistList.GetFloat("selectedIndex"));
    OnListChange(SelectedIndex);
    //return;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');    
    ButtonAliases.AddItem('GenericBack');    
    AddNATStatus(ButtonAliases);
    Frontend.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function OnBack(EventData ev)
{
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function OnCustomBtn(EventData ev)
{
    Action = "custommatch";
    PlayCloseAnimation();
    //return;    
}

function OnListSelect(int Index)
{
    local AdvOnlinePlaylistProvider AdvProvider;
    local AdvPartyGRI GRI;

    GRI = AdvPartyGRI(GetMenuGRI());
    // End:0x43
    if(GRI.ConnectingPlayerCount > 0)
    {
        return;
    }
    // End:0x10B
    if(PlaylistArray.Length > Index)
    {
        AdvProvider = AdvOnlinePlaylistProvider(PlaylistArray[Index]);
        // End:0x10B
        if(AdvProvider != none)
        {
            // End:0x10B
            if(AdvPlayerController(GetPC()).CheckPlaylistAndDisplayError(AdvProvider.PlaylistId))
            {
                Action = "Playlist";
                SelectedButtonIdx = Index;
                PlayCloseAnimation();
            }
        }
    }
    //return;    
}

function OnListChange(int Index)
{
    OnListOver(Index);
    //return;    
}

function OnListOver(int Index)
{
    local AdvOnlinePlaylistProvider AdvProvider;
    local string Description;
    local int IntValue;
    local OnlinePlaylistManager PlaylistMan;
    local array<int> AvailableGameTypes;
    local AdvGameSettingsCommon PlaylistSettings;

    // End:0x218
    if((Index >= 0) && Index < PlaylistArray.Length)
    {
        AdvProvider = AdvOnlinePlaylistProvider(PlaylistArray[Index]);
        // End:0x218
        if(AdvProvider != none)
        {
            Description = AdvProvider.PlaylistDescription;
            PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
            PlaylistMan.GetAvailableGameTypes(AdvProvider.PlaylistId, AvailableGameTypes);
            PlaylistSettings = AdvGameSettingsCommon(PlaylistMan.GetGameSettings(AdvProvider.PlaylistId, AvailableGameTypes[0]));
            // End:0x1D3
            if(PlaylistSettings.GetIntProperty(PlaylistSettings.268435706, IntValue))
            {
                Description = Repl(Description, "`t", "" $ string(IntValue));                
            }
            else
            {
                Description = Repl(Description, "`t", "");
            }
            PlaylistDescription.SetText(Description);
        }
    }
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;
    local AdvPartyGRI GRI;
    local int PlaylistId;

    GRI = AdvPartyGRI(GetMenuGRI());
    switch(Action)
    {
        // End:0xBD
        case "back":
            // End:0x90
            if(int(GetMenuGame().MultiGameModeSelected) == int(3))
            {
                bTransitionResult = Frontend.OpenMultiSurvivalScreen();                
            }
            else
            {
                bTransitionResult = Frontend.OpenMultiMenuScreen();
            }
            // End:0x252
            break;
        // End:0x20F
        case "Playlist":
            // End:0x20C
            if(SelectedButtonIdx != -1)
            {
                AdvLocalPlayer(GetLP()).bRestoreUsingGamepad = GetPC().PlayerInput.bUsingGamepad;
                PlaylistId = PlaylistArray[SelectedButtonIdx].PlaylistId;
                GRI.SetPlaylist(PlaylistId);
                // End:0x1E0
                if(int(GRI.Role) == int(ROLE_Authority))
                {
                    GRI.SetLobbyState(3);
                }
                bTransitionResult = Frontend.HandleCompetitiveMatchModeSelection(0, false);
            }
            // End:0x252
            break;
        // End:0x24C
        case "custommatch":
            bTransitionResult = Frontend.OpenMultiCustomSearchScreen();
            // End:0x252
            break;
        // End:0xFFFF
        default:
            // End:0x252
            break;
            break;
    }
    // End:0x27E
    if(bTransitionResult)
    {
        Frontend.CloseMultiMenuGametypeScreen();
    }
    Action = "";
    SelectedButtonIdx = -1;
    //return;    
}

defaultproperties
{
    TitleString="Multiplayer"
    SurvivalTitleString="Survival"
    CustomString="Custom Search"
    SelectedButtonIdx=-1
    MovieInfoPath="UI_AdvUI.AdvMultiMenuXbox"
}