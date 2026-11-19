class TurokFEMultiplayerStats extends TurokFEPostGameStats
    abstract
    native;

const MAX_TABLE_ROWS = 16;

enum eStatsSortType
{
    SST_Ascending,                  // 0
    SST_Descending,                 // 1
    SST_MAX                         // 2
};

var protected @NULL TitleImage;
var protected @NULL TitleText;
var protected @NULL BGImage[4];
var protected @NULL TableBG[8];
var protected @NULL ColumnHighlight[3];
var protected @NULL RowHighlight[3];
var protected @NULL DeadOrDisconnectIcons[16];
var protected @NULL mDisconnectIconTexture;
var protected @NULL TeamIcons[2];
var protected @NULL TeamNames[2];
var protected @NULL BattleRatingText[2];
var protected @NULL Stat1Text[2];
var protected @NULL Stat2Text[2];
var protected @NULL Stat3Text[2];
var protected @NULL Stat4Text[2];
var protected @NULL Stat5Text[2];
var protected @NULL Stat6Text[2];
var protected @NULL TeamInfoSeparator;
var protected @NULL TeamInfoBG;
var protected @NULL mSpeakingTexture;
var protected @NULL mMuteTexture;
var int mVoiceIconColumnIndex;
var int mDeadOrDisconnectIconColumnIndex;
var protected int mPrevColumn;
var protected int mPrevRow;
var protected bool mAllowColumnScroll;
var protected bool mAllowRowScroll;
var protected bool mSortedByTeam;
var protected byte mSortOrder;
var protected float mRowHighlightPosY;
var protected float mRowHighlightSpacing;
var int mDebugNumPlayers;
var @NULL TheMenu;

// Export UTurokFEMultiplayerStats::execInitialize(FFrame&, void* const)
native function Initialize(@NULL pScene, @NULL pSceneClient);

event SCCleanUpOnExit()
{
    local int I;

    // End:0x22
    if(TitleImage != none)
    {
        TitleImage.ScriptCtrl = none;
        TitleImage = none;
    }
    // End:0x44
    if(TitleText != none)
    {
        TitleText.ScriptCtrl = none;
        TitleText = none;
    }
    // End:0x66
    if(TeamInfoSeparator != none)
    {
        TeamInfoSeparator.ScriptCtrl = none;
        TeamInfoSeparator = none;
    }
    // End:0x88
    if(TeamInfoBG != none)
    {
        TeamInfoBG.ScriptCtrl = none;
        TeamInfoBG = none;
    }
    I = 0;
    J0x8F:

    // End:0xD9 [Loop If]
    if(I < 4)
    {
        // End:0xCF
        if(BGImage[I] != none)
        {
            BGImage[I].ScriptCtrl = none;
            BGImage[I] = none;
        }
        I++;
        // [Loop Continue]
        goto J0x8F;
    }
    I = 0;
    J0xE0:

    // End:0x12A [Loop If]
    if(I < 8)
    {
        // End:0x120
        if(TableBG[I] != none)
        {
            TableBG[I].ScriptCtrl = none;
            TableBG[I] = none;
        }
        I++;
        // [Loop Continue]
        goto J0xE0;
    }
    I = 0;
    J0x131:

    // End:0x31B [Loop If]
    if(I < 2)
    {
        // End:0x171
        if(TeamIcons[I] != none)
        {
            TeamIcons[I].ScriptCtrl = none;
            TeamIcons[I] = none;
        }
        // End:0x1A5
        if(TeamNames[I] != none)
        {
            TeamNames[I].ScriptCtrl = none;
            TeamNames[I] = none;
        }
        // End:0x1D9
        if(BattleRatingText[I] != none)
        {
            BattleRatingText[I].ScriptCtrl = none;
            BattleRatingText[I] = none;
        }
        // End:0x20D
        if(Stat1Text[I] != none)
        {
            Stat1Text[I].ScriptCtrl = none;
            Stat1Text[I] = none;
        }
        // End:0x241
        if(Stat2Text[I] != none)
        {
            Stat2Text[I].ScriptCtrl = none;
            Stat2Text[I] = none;
        }
        // End:0x275
        if(Stat3Text[I] != none)
        {
            Stat3Text[I].ScriptCtrl = none;
            Stat3Text[I] = none;
        }
        // End:0x2A9
        if(Stat4Text[I] != none)
        {
            Stat4Text[I].ScriptCtrl = none;
            Stat4Text[I] = none;
        }
        // End:0x2DD
        if(Stat5Text[I] != none)
        {
            Stat5Text[I].ScriptCtrl = none;
            Stat5Text[I] = none;
        }
        // End:0x311
        if(Stat6Text[I] != none)
        {
            Stat6Text[I].ScriptCtrl = none;
            Stat6Text[I] = none;
        }
        I++;
        // [Loop Continue]
        goto J0x131;
    }
    I = 0;
    J0x322:

    // End:0x3A0 [Loop If]
    if(I < 3)
    {
        // End:0x362
        if(ColumnHighlight[I] != none)
        {
            ColumnHighlight[I].ScriptCtrl = none;
            ColumnHighlight[I] = none;
        }
        // End:0x396
        if(RowHighlight[I] != none)
        {
            RowHighlight[I].ScriptCtrl = none;
            RowHighlight[I] = none;
        }
        I++;
        // [Loop Continue]
        goto J0x322;
    }
    TheTable.Deinitialize();
    TheTable = none;
    super.SCCleanUpOnExit();
    //return;    
}

// Export UTurokFEMultiplayerStats::execReJigHighlightScripts(FFrame&, void* const)
native function ReJigHighlightScripts(const int kRowIndex, bool bIsLocalPlayer, bool bIsDead);

// Export UTurokFEMultiplayerStats::execProcessInput(FFrame&, void* const)
native function bool ProcessInput(int ControllerId, name Key, byte Event, float AmountDepressed);

event bool SCInputKey_Multiplayer(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    // End:0x23
    if(ProcessInput(ControllerId, Key, Event, AmountDepressed))
    {
        return true;
    }
    return super(TurokFEMultiplayerScreen).SCInputKey_Multiplayer(ControllerId, Key, Event, AmountDepressed);
    //return ReturnValue;    
}

// Export UTurokFEMultiplayerStats::execSetRankIcon(FFrame&, void* const)
protected native function SetRankIcon();

protected event PositionRowHighlight()
{
    local float row_pos_y;

    // End:0xFA
    if((((mAllowRowScroll && RowHighlight[0] != none) && RowHighlight[1] != none) && RowHighlight[2] != none) && TheTable.GetNumDataRows() > 0)
    {
        // End:0x65
        if(mIsRankedGame)
        {
            SetRankIcon();
        }
        mPrevRow = TheTable.GetSelectedRowIndex();
        row_pos_y = mRowHighlightPosY + (mRowHighlightSpacing * float(mPrevRow));
        Class'TurokEngine.TurokUI'.static.SetPosY(RowHighlight[0], row_pos_y);
        Class'TurokEngine.TurokUI'.static.SetPosY(RowHighlight[1], row_pos_y);
        Class'TurokEngine.TurokUI'.static.SetPosY(RowHighlight[2], row_pos_y);
    }
    //return;    
}

protected event PositionColumnHighlight()
{
    local float col_pos_x, col_width;
    local @NULL Heading;

    // End:0x1CD
    if(((mAllowColumnScroll && ColumnHighlight[0] != none) && ColumnHighlight[1] != none) && ColumnHighlight[2] != none)
    {
        mPrevColumn = TheTable.GetSelectedColumnIndex();
        // End:0x162
        if(TheTable.GetSelectedColumn().bHasHeading)
        {
            Heading = TheTable.GetSelectedColumn().Heading;
            col_width = Class'TurokEngine.TurokUI'.static.GetLabelWidth(Heading);
            // End:0x132
            if(int(Heading.StringRenderComponent.TextAlignmentHorizontal) == int(1))
            {
                col_pos_x = (Class'TurokEngine.TurokUI'.static.GetPosX(TheTable.GetSelectedColumn()) + (Class'TurokEngine.TurokUI'.static.GetWidth(Heading) * 0.5000000)) - (col_width * 0.5000000);                
            }
            else
            {
                col_pos_x = Class'TurokEngine.TurokUI'.static.GetPosX(TheTable.GetSelectedColumn());
            }            
        }
        else
        {
            col_width = Class'TurokEngine.TurokUI'.static.GetWidth(TheTable.GetSelectedColumn());
        }
        Class'TurokEngine.TurokUI'.static.SetPosX(ColumnHighlight[1], col_pos_x);
        Class'TurokEngine.TurokUI'.static.SetWidth(ColumnHighlight[1], col_width);
    }
    //return;    
}

protected function CloseMenu()
{
    local int I;

    // End:0x3F
    if((TitleImage != none) && TitleImage.ScriptCtrl != none)
    {
        Class'TurokEngine.TurokUI'.static.PlayScript(TitleImage, "exit");
    }
    // End:0x7E
    if((TitleText != none) && TitleText.ScriptCtrl != none)
    {
        Class'TurokEngine.TurokUI'.static.PlayScript(TitleText, "exit");
    }
    // End:0xBD
    if((TeamInfoSeparator != none) && TeamInfoSeparator.ScriptCtrl != none)
    {
        Class'TurokEngine.TurokUI'.static.PlayScript(TeamInfoSeparator, "exit");
    }
    // End:0xFC
    if((TeamInfoBG != none) && TeamInfoBG.ScriptCtrl != none)
    {
        Class'TurokEngine.TurokUI'.static.PlayScript(TeamInfoBG, "exit");
    }
    I = 0;
    J0x103:

    // End:0x16A [Loop If]
    if(I < 4)
    {
        // End:0x160
        if((BGImage[I] != none) && BGImage[I].ScriptCtrl != none)
        {
            Class'TurokEngine.TurokUI'.static.PlayScript(BGImage[I], "exit");
        }
        I++;
        // [Loop Continue]
        goto J0x103;
    }
    I = 0;
    J0x171:

    // End:0x1D8 [Loop If]
    if(I < 8)
    {
        // End:0x1CE
        if((TableBG[I] != none) && TableBG[I].ScriptCtrl != none)
        {
            Class'TurokEngine.TurokUI'.static.PlayScript(TableBG[I], "exit");
        }
        I++;
        // [Loop Continue]
        goto J0x171;
    }
    I = 0;
    J0x1DF:

    // End:0x4CE [Loop If]
    if(I < 2)
    {
        // End:0x23C
        if((TeamIcons[I] != none) && TeamIcons[I].ScriptCtrl != none)
        {
            Class'TurokEngine.TurokUI'.static.PlayScript(TeamIcons[I], "exit");
        }
        // End:0x28D
        if((TeamNames[I] != none) && TeamNames[I].ScriptCtrl != none)
        {
            Class'TurokEngine.TurokUI'.static.PlayScript(TeamNames[I], "exit");
        }
        // End:0x2DE
        if((BattleRatingText[I] != none) && BattleRatingText[I].ScriptCtrl != none)
        {
            Class'TurokEngine.TurokUI'.static.PlayScript(BattleRatingText[I], "exit");
        }
        // End:0x32F
        if((Stat1Text[I] != none) && Stat1Text[I].ScriptCtrl != none)
        {
            Class'TurokEngine.TurokUI'.static.PlayScript(Stat1Text[I], "exit");
        }
        // End:0x380
        if((Stat2Text[I] != none) && Stat2Text[I].ScriptCtrl != none)
        {
            Class'TurokEngine.TurokUI'.static.PlayScript(Stat2Text[I], "exit");
        }
        // End:0x3D1
        if((Stat3Text[I] != none) && Stat3Text[I].ScriptCtrl != none)
        {
            Class'TurokEngine.TurokUI'.static.PlayScript(Stat3Text[I], "exit");
        }
        // End:0x422
        if((Stat4Text[I] != none) && Stat4Text[I].ScriptCtrl != none)
        {
            Class'TurokEngine.TurokUI'.static.PlayScript(Stat4Text[I], "exit");
        }
        // End:0x473
        if((Stat5Text[I] != none) && Stat5Text[I].ScriptCtrl != none)
        {
            Class'TurokEngine.TurokUI'.static.PlayScript(Stat5Text[I], "exit");
        }
        // End:0x4C4
        if((Stat6Text[I] != none) && Stat6Text[I].ScriptCtrl != none)
        {
            Class'TurokEngine.TurokUI'.static.PlayScript(Stat6Text[I], "exit");
        }
        I++;
        // [Loop Continue]
        goto J0x1DF;
    }
    I = 0;
    J0x4D5:

    // End:0x58D [Loop If]
    if(I < 3)
    {
        // End:0x532
        if((ColumnHighlight[I] != none) && ColumnHighlight[I].ScriptCtrl != none)
        {
            Class'TurokEngine.TurokUI'.static.PlayScript(ColumnHighlight[I], "exit");
        }
        // End:0x583
        if((RowHighlight[I] != none) && RowHighlight[I].ScriptCtrl != none)
        {
            Class'TurokEngine.TurokUI'.static.PlayScript(RowHighlight[I], "exit");
        }
        I++;
        // [Loop Continue]
        goto J0x4D5;
    }
    TheTable.StartFadeOut();
    super.CloseMenu();
    //return;    
}

protected event ToggleSortOrder()
{
    // End:0x1B
    if(int(mSortOrder) == int(0))
    {
        mSortOrder = 1;        
    }
    else
    {
        // End:0x33
        if(int(mSortOrder) == int(1))
        {
            mSortOrder = 0;
        }
    }
    //return;    
}

// Export UTurokFEMultiplayerStats::execInitializeData(FFrame&, void* const)
protected native function InitializeData();

// Export UTurokFEMultiplayerStats::execSortDataByColumn(FFrame&, void* const)
protected native function SortDataByColumn(int column);

// Export UTurokFEMultiplayerStats::execSortTeamDataByColumn(FFrame&, void* const)
protected native function SortTeamDataByColumn(int column);

// Export UTurokFEMultiplayerStats::execRefreshPlayers(FFrame&, void* const)
protected native function RefreshPlayers();

// Export UTurokFEMultiplayerStats::execRefreshTeams(FFrame&, void* const)
protected native function RefreshTeams(bool ShowTeamInfo);

// Export UTurokFEMultiplayerStats::execSetDeathAndDisconnectIcons(FFrame&, void* const)
protected native function SetDeathAndDisconnectIcons();

// Export UTurokFEMultiplayerStats::execGetDefaultSelectedColumn(FFrame&, void* const)
protected native function int GetDefaultSelectedColumn(byte GamePlayMode);

protected event SetupTitle()
{
    TitleImage = UIImage(Scene.FindChild(name("TitleBG"), true));
    TitleText = UILabel(Scene.FindChild(name("TitleText"), true));
    TheMenu = TurokUIMenu(Scene.FindChild(name("PCOptionsMenu"), true));
    TheMenu.SetItemDelegate(0, OnSave);
    TheMenu.SetItemDelegate(1, OnCancel);
    TheMenu.PostSetupInitialize();
    TheMenu.StartFadeIn();
    //return;    
}

// Export UTurokFEMultiplayerStats::execASyncLoadBackgroundImages(FFrame&, void* const)
native function ASyncLoadBackgroundImages();

protected event SetupBGImages()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x53 [Loop If]
    if(I < 4)
    {
        BGImage[I] = UIImage(Scene.FindChild(name("BGImage_" $ string(I)), true));
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    I = 0;
    J0x5A:

    // End:0xA6 [Loop If]
    if(I < 8)
    {
        TableBG[I] = UIImage(Scene.FindChild(name("TableBG_" $ string(I)), true));
        I++;
        // [Loop Continue]
        goto J0x5A;
    }
    ASyncLoadBackgroundImages();
    //return;    
}

protected event bool IsTeamGame()
{
    local @NULL GameResults, WorldInfo;

    // End:0x7E
    if(Class'Engine.Engine'.static.GetTurokNet().GetLobby() != none)
    {
        GameResults = Class'Engine.Engine'.static.GetTurokNet().GetLobby().GetGameResults();
        // End:0x7B
        if((GameResults.GetGameClass() != none) && ClassIsChildOf(GameResults.GetGameClass(), Class'TurokTeamGame'))
        {
            return true;
        }        
    }
    else
    {
        WorldInfo = Class'TurokEngine.TurokUI'.static.GetEngine().GetCurrentWorldInfo();
        // DebugMode: 0
        assert((WorldInfo != none) && WorldInfo.GRI != none);
        // End:0xE7
        if(class<TurokTeamGame>(WorldInfo.GRI.GameClass) != none)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

protected event bool IsCoopGame()
{
    local @NULL GameResults, WorldInfo;

    // End:0x7D
    if(Class'Engine.Engine'.static.GetTurokNet().GetLobby() != none)
    {
        GameResults = Class'Engine.Engine'.static.GetTurokNet().GetLobby().GetGameResults();
        // End:0x7A
        if((GameResults.GetGameClass() != none) && GameResults.GetGameClass() == Class'TurokCoopGame')
        {
            return true;
        }        
    }
    else
    {
        WorldInfo = Class'TurokEngine.TurokUI'.static.GetEngine().GetCurrentWorldInfo();
        // DebugMode: 0
        assert((WorldInfo != none) && WorldInfo.GRI != none);
        // End:0xE6
        if(class<TurokCoopGame>(WorldInfo.GRI.GameClass) != none)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

protected event SetupTeamInfo()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x218 [Loop If]
    if(I < 2)
    {
        TeamIcons[I] = UIImage(Scene.FindChild(name("TeamIcon_" $ string(I)), true));
        TeamNames[I] = UILabel(Scene.FindChild(name("TeamName_" $ string(I)), true));
        BattleRatingText[I] = UILabel(Scene.FindChild(name("TeamBattleRating_" $ string(I)), true));
        Stat1Text[I] = UILabel(Scene.FindChild(name("TeamAccuracy_" $ string(I)), true));
        Stat2Text[I] = UILabel(Scene.FindChild(name("TeamIcon_" $ string(I)), true));
        Stat3Text[I] = UILabel(Scene.FindChild(name("TeamIcon_" $ string(I)), true));
        Stat4Text[I] = UILabel(Scene.FindChild(name("TeamIcon_" $ string(I)), true));
        Stat5Text[I] = UILabel(Scene.FindChild(name("TeamIcon_" $ string(I)), true));
        Stat6Text[I] = UILabel(Scene.FindChild(name("TeamIcon_" $ string(I)), true));
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    TeamInfoSeparator = UIImage(Scene.FindChild(name("TeamInfoSeparator"), true));
    TeamInfoBG = UIImage(Scene.FindChild(name("TeamInfoBG"), true));
    //return;    
}

// Export UTurokFEMultiplayerStats::execHideTeamIcon(FFrame&, void* const)
native function HideTeamIcon();

// Export UTurokFEMultiplayerStats::execSetNonRankedGame(FFrame&, void* const)
native function SetNonRankedGame();

// Export UTurokFEMultiplayerStats::execOnSave(FFrame&, void* const)
native function OnSave();

// Export UTurokFEMultiplayerStats::execOnCancel(FFrame&, void* const)
native function OnCancel();

defaultproperties
{
    mDisconnectIconTexture=Texture2D'TurokFEMultiplayer.DisconnectedIcon'
    mSpeakingTexture=Texture2D'TurokFEMultiplayer.SpeechBubble'
    mMuteTexture=Texture2D'TurokFEMultiplayer.NoSpeechBubble'
    mPrevColumn=-1
    mPrevRow=-1
    mSortedByTeam=true
    mSortOrder=1
    mRowHighlightPosY=21.0000000
    mRowHighlightSpacing=25.4000000
    mDebugNumPlayers=5
}