class TurokFEStatsLeaderboards extends TurokUISceneController
    native;

const kMaxVisibleEntries = 10;
const kTableRowNum = 11;
const kMaxNumRowsRead = 30;
const kNullFieldText = "--";

enum eFEStatsLeaderboardColumns
{
    FESLC_RANK_POSITION,            // 0
    FESLC_NAME,                     // 1
    FESLC_POINTS,                   // 2
    FESLC_MISC,                     // 3
    FESLC_MAX                       // 4
};

struct native LeaderboardInfo
{
    var byte mType;
    var int mTitleStringHash;
    var int mRatedColumnHeaderHash;
    var int mMiscColumnHeaderHash;

    structdefaultproperties
    {
        mType=0
        mTitleStringHash=0
        mRatedColumnHeaderHash=0
        mMiscColumnHeaderHash=0
    }
};

var private byte mLeaderboard;
var private @NULL mLeaderboardReader;
var private bool mBlockInput;
var private int mRefreshedSelectedPosition;
var private const array kLeaderboards;
var private const array kRankIconTextures;
var private const array kListModeStringHashes;
var private @NULL mRankIconInformation;
var @NULL TitleText;
var @NULL GameTypeText;
var @NULL GameTypeLeftArrow;
var @NULL GameTypeRightArrow;
var @NULL PositionTitle;
var @NULL GamerTagTitle;
var @NULL PointsTitle;
var @NULL LocaleTitle;
var @NULL PositionData;
var @NULL GamerTagData;
var @NULL PointsData;
var @NULL LocaleData;
var @NULL PlayerInfoBG;
var @NULL RankImage;
var @NULL RankImageDevice;
var @NULL TheTable;
var @NULL HighlightBar[3];
var @NULL TableDeviceImages[11];
var @NULL BGImage;
var @NULL mOverlayEdges[2];
var @NULL mGamertag;

// Export UTurokFEStatsLeaderboards::execGoBackScreen(FFrame&, void* const)
protected native function GoBackScreen();

// Export UTurokFEStatsLeaderboards::execScrollLeaderboardType(FFrame&, void* const)
protected native function ScrollLeaderboardType(int Dir);

// Export UTurokFEStatsLeaderboards::execToggleLeaderboardMode(FFrame&, void* const)
protected native function ToggleLeaderboardMode();

// Export UTurokFEStatsLeaderboards::execViewGamerCard(FFrame&, void* const)
protected native function ViewGamerCard();

// Export UTurokFEStatsLeaderboards::execRefreshTitle(FFrame&, void* const)
protected native function RefreshTitle();

// Export UTurokFEStatsLeaderboards::execRefreshLocalPlayer(FFrame&, void* const)
protected native function RefreshLocalPlayer();

// Export UTurokFEStatsLeaderboards::execRefreshTable(FFrame&, void* const)
protected native function RefreshTable();

// Export UTurokFEStatsLeaderboards::execCheckForDataRead(FFrame&, void* const)
protected native function CheckForDataRead(int Dir);

// Export UTurokFEStatsLeaderboards::execReadPrevDataSet(FFrame&, void* const)
protected native function ReadPrevDataSet(int SelectedRank, int NumRows);

// Export UTurokFEStatsLeaderboards::execReadNextDataSet(FFrame&, void* const)
protected native function ReadNextDataSet(int SelectedRank, int NumRows);

// Export UTurokFEStatsLeaderboards::execSetLeaderboard(FFrame&, void* const)
protected native function SetLeaderboard(byte Type);

// Export UTurokFEStatsLeaderboards::execGetLeaderboardInfo(FFrame&, void* const)
protected native function GetLeaderboardInfo(byte Type, out @NULL Info);

// Export UTurokFEStatsLeaderboards::execGetRankIconTextureString(FFrame&, void* const)
protected native function string GetRankIconTextureString(int Rank);

// Export UTurokFEStatsLeaderboards::execRefreshTableRankIcons(FFrame&, void* const)
protected native function RefreshTableRankIcons();

// Export UTurokFEStatsLeaderboards::execOnReadStatsCompleted(FFrame&, void* const)
native function OnReadStatsCompleted(bool success);

event SCInitialized()
{
    InitTitle();
    InitPlayerInfo();
    InitTable();
    InitHelpBar();
    InitBG();
    mRankIconInformation = new Class'TurokRankInformation';
    //return;    
}

event SCTick(float DeltaTime)
{
    TickTitle();
    TickPlayerInfo();
    TickTable();
    TickHelpBar();
    TickBG();
    mGamertag.Tick();
    //return;    
}

event SCCleanUpOnExit()
{
    local int I;

    // End:0x25
    if(mLeaderboardReader != none)
    {
        mLeaderboardReader.Deinitialize();
        mLeaderboardReader = none;
    }
    mRankIconInformation = none;
    CleanUpTitle();
    CleanUpPlayerInfo();
    CleanUpTable();
    CleanUpHelpBar();
    CleanUpBG();
    SceneClient = none;
    I = 0;
    J0x6C:

    // End:0xA8 [Loop If]
    if(I < 2)
    {
        mOverlayEdges[I].Stop();
        mOverlayEdges[I] = none;
        ++I;
        // [Loop Continue]
        goto J0x6C;
    }
    mGamertag = none;
    //return;    
}

// Export UTurokFEStatsLeaderboards::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

function InitTitle()
{
    TitleText = UILabel(Scene.FindChild(name("TitleText")));
    // End:0x33
    if(TitleText != none)
    {
    }
    GameTypeText = UILabel(Scene.FindChild(name("GameTypeText")));
    // End:0x69
    if(GameTypeText != none)
    {
    }
    GameTypeLeftArrow = UIImage(Scene.FindChild(name("GameTypeLeftArrow")));
    // End:0xE4
    if(GameTypeLeftArrow != none)
    {
        Class'TurokEngine.TurokUI'.static.InitScriptCtrl(GameTypeLeftArrow);
        // End:0xE4
        if(GameTypeLeftArrow.GetScriptCtrl() != none)
        {
            AddBlinkScript(GameTypeLeftArrow);
        }
    }
    GameTypeRightArrow = UIImage(Scene.FindChild(name("GameTypeRightArrow")));
    // End:0x160
    if(GameTypeRightArrow != none)
    {
        Class'TurokEngine.TurokUI'.static.InitScriptCtrl(GameTypeRightArrow);
        // End:0x160
        if(GameTypeRightArrow.GetScriptCtrl() != none)
        {
            AddBlinkScript(GameTypeRightArrow);
        }
    }
    //return;    
}

function InitPlayerInfo()
{
    PositionTitle = UILabel(Scene.FindChild(name("PositionTitle")));
    // End:0x37
    if(PositionTitle != none)
    {
    }
    GamerTagTitle = UILabel(Scene.FindChild(name("GamerTagTitle")));
    // End:0x6E
    if(GamerTagTitle != none)
    {
    }
    PointsTitle = UILabel(Scene.FindChild(name("PointsTitle")));
    // End:0xA3
    if(PointsTitle != none)
    {
    }
    LocaleTitle = UILabel(Scene.FindChild(name("LocaleTitle")));
    // End:0xD8
    if(LocaleTitle != none)
    {
    }
    PositionData = UILabel(Scene.FindChild(name("PositionData")));
    // End:0x10E
    if(PositionData != none)
    {
    }
    GamerTagData = UILabel(Scene.FindChild(name("GamerTagData")));
    // End:0x144
    if(GamerTagData != none)
    {
    }
    PointsData = UILabel(Scene.FindChild(name("PointsData")));
    // End:0x178
    if(PointsData != none)
    {
    }
    LocaleData = UILabel(Scene.FindChild(name("LocaleData")));
    // End:0x1AC
    if(LocaleData != none)
    {
    }
    PlayerInfoBG = UIImage(Scene.FindChild(name("PlayerInfoBG")));
    // End:0x1E2
    if(PlayerInfoBG != none)
    {
    }
    RankImage = UIImage(Scene.FindChild(name("RankImage")));
    // End:0x215
    if(RankImage != none)
    {
    }
    RankImageDevice = UIImage(Scene.FindChild(name("RankImageDevice"), true));
    // End:0x24E
    if(RankImageDevice != none)
    {
    }
    //return;    
}

function AddBlinkScript(@NULL obj)
{
    local @NULL script, the_color;

    the_color.R = 0;
    the_color.G = 0;
    the_color.B = 0;
    the_color.A = byte(255);
    // End:0x114
    if((obj != none) && obj.ScriptCtrl != none)
    {
        script = Class'TurokEngine.TurokUI'.static.AddScript(obj, "blink");
        // End:0x114
        if(script != none)
        {
            script.AddColorKey(0.0000000, the_color);
            the_color.R = byte(255);
            the_color.G = byte(255);
            the_color.B = byte(255);
            script.AddColorKey(0.3300000, the_color);
        }
    }
    //return;    
}

function InitTable()
{
    local int I;

    TheTable = TurokUITable(Scene.FindChild(name("TheTable")));
    // End:0x5B
    if(TheTable != none)
    {
        TheTable.PostSetupInitialize();
        TheTable.Refresh();
    }
    I = 0;
    J0x62:

    // End:0xC4 [Loop If]
    if(I < 3)
    {
        HighlightBar[I] = UIImage(Scene.FindChild(name("RowHighlight_" $ string(I))));
        // End:0xBA
        if(HighlightBar[I] != none)
        {
        }
        ++I;
        // [Loop Continue]
        goto J0x62;
    }
    I = 0;
    J0xCB:

    // End:0x12B [Loop If]
    if(I < 11)
    {
        TableDeviceImages[I] = UIImage(Scene.FindChild(name("DeviceImage" $ string(I)), true));
        // End:0x121
        if(TableDeviceImages[I] != none)
        {
        }
        ++I;
        // [Loop Continue]
        goto J0xCB;
    }
    SetHighlightBarPos();
    //return;    
}

function InitHelpBar()
{
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(2, 675426377);
    //return;    
}

function InitBG()
{
    BGImage = UIImage(Scene.FindChild(name("BGImage")));
    // End:0x31
    if(BGImage != none)
    {
    }
    //return;    
}

function CleanUpObject(@NULL obj)
{
    // End:0x22
    if(obj != none)
    {
        obj.ScriptCtrl = none;
        obj = none;
    }
    //return;    
}

function CleanUpTitle()
{
    CleanUpObject(TitleText);
    CleanUpObject(GameTypeText);
    CleanUpObject(GameTypeLeftArrow);
    CleanUpObject(GameTypeRightArrow);
    //return;    
}

function CleanUpPlayerInfo()
{
    CleanUpObject(PositionTitle);
    CleanUpObject(GamerTagTitle);
    CleanUpObject(PointsTitle);
    CleanUpObject(LocaleTitle);
    CleanUpObject(PositionData);
    CleanUpObject(GamerTagData);
    CleanUpObject(PointsData);
    CleanUpObject(LocaleData);
    CleanUpObject(PlayerInfoBG);
    CleanUpObject(RankImage);
    CleanUpObject(RankImageDevice);
    //return;    
}

function CleanUpTable()
{
    local int I;

    // End:0x1E
    if(TheTable != none)
    {
        TheTable.Deinitialize();
    }
    I = 0;
    J0x25:

    // End:0x50 [Loop If]
    if(I < 3)
    {
        CleanUpObject(HighlightBar[I]);
        I++;
        // [Loop Continue]
        goto J0x25;
    }
    I = 0;
    J0x57:

    // End:0x82 [Loop If]
    if(I < 11)
    {
        CleanUpObject(TableDeviceImages[I]);
        ++I;
        // [Loop Continue]
        goto J0x57;
    }
    //return;    
}

function CleanUpHelpBar()
{
    //return;    
}

function CleanUpBG()
{
    CleanUpObject(BGImage);
    //return;    
}

function TickScriptCtrl(@NULL obj)
{
    // End:0x42
    if((obj != none) && obj.ScriptCtrl != none)
    {
        obj.ScriptCtrl.Tick(obj);
    }
    //return;    
}

function TickTitle()
{
    TickScriptCtrl(TitleText);
    TickScriptCtrl(GameTypeText);
    TickScriptCtrl(GameTypeLeftArrow);
    TickScriptCtrl(GameTypeRightArrow);
    //return;    
}

function TickPlayerInfo()
{
    TickScriptCtrl(PositionTitle);
    TickScriptCtrl(GamerTagTitle);
    TickScriptCtrl(PointsTitle);
    TickScriptCtrl(LocaleTitle);
    TickScriptCtrl(PositionData);
    TickScriptCtrl(GamerTagData);
    TickScriptCtrl(PointsData);
    TickScriptCtrl(LocaleData);
    TickScriptCtrl(PlayerInfoBG);
    TickScriptCtrl(RankImage);
    //return;    
}

function TickTable()
{
    local int I;

    // End:0x1E
    if(TheTable != none)
    {
        TheTable.Tick();
    }
    I = 0;
    J0x25:

    // End:0x50 [Loop If]
    if(I < 3)
    {
        TickScriptCtrl(HighlightBar[I]);
        I++;
        // [Loop Continue]
        goto J0x25;
    }
    I = 0;
    J0x57:

    // End:0x82 [Loop If]
    if(I < 11)
    {
        TickScriptCtrl(TableDeviceImages[I]);
        ++I;
        // [Loop Continue]
        goto J0x57;
    }
    //return;    
}

function TickHelpBar()
{
    //return;    
}

function TickBG()
{
    TickScriptCtrl(BGImage);
    //return;    
}

// Export UTurokFEStatsLeaderboards::execSetHighlightBarPos(FFrame&, void* const)
protected native function SetHighlightBarPos();

defaultproperties
{
    kLeaderboards=/* Array type was not detected. */
    kListModeStringHashes=/* Array type was not detected. */
    SceneName="TurokFEStats.Leaderboards.Leaderboards"
}