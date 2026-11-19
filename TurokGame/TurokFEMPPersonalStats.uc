class TurokFEMPPersonalStats extends TurokFEPostGameStats
    native;

const NUM_TABLE_BG_IMAGES = 5;
const NUM_ROW_HIGHLIGHT_IMAGES = 3;

var protected int mPrevRow;
var protected array mStatDescriptions;
var protected @NULL mLeaderboardReader;
var protected const array kDisplayStats;
var protected const array kCTFStats;
var protected const array kWargameStats;
var private @NULL mRankIconInformation;
var @NULL ScreenTitle;
var @NULL PositionTitle;
var @NULL GamerTagTitle;
var @NULL RankTitle;
var @NULL PlayerTitleTitle;
var @NULL PositionData;
var @NULL GamerTagData;
var @NULL RankData;
var @NULL PlayerTitleData;
var @NULL SelectedStatBlurb;
var @NULL ScreenTitleBG;
var @NULL TableTitleBG;
var @NULL TableBG[5];
var @NULL RowHighlight[3];
var float mFirstRowOffset;
var @NULL TheMenu;

// Export UTurokFEMPPersonalStats::execInitialize(FFrame&, void* const)
native function Initialize(@NULL pScene, @NULL pSceneClient);

event SCInitialized()
{
    super(TurokFEMultiplayerScreen).SCInitialized();
    SetupRankHeader();
    SetupTable();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(2, 675426377);
    TheMenu = TurokUIMenu(Scene.FindChild(name("PCOptionsMenu"), true));
    TheMenu.SetItemDelegate(0, OnSave);
    TheMenu.SetItemDelegate(1, OnCancel);
    TheMenu.PostSetupInitialize();
    TheMenu.StartFadeIn();
    //return;    
}

event SCTick(float DeltaTime)
{
    local int I;

    super(TurokFEMultiplayerScreen).SCTick(DeltaTime);
    // End:0x4D
    if((ScreenTitle != none) && ScreenTitle.ScriptCtrl != none)
    {
        ScreenTitle.ScriptCtrl.Tick(ScreenTitle);
    }
    // End:0x8F
    if((ScreenTitleBG != none) && ScreenTitleBG.ScriptCtrl != none)
    {
        ScreenTitleBG.ScriptCtrl.Tick(ScreenTitle);
    }
    // End:0xD1
    if((PositionTitle != none) && PositionTitle.ScriptCtrl != none)
    {
        PositionTitle.ScriptCtrl.Tick(PositionTitle);
    }
    // End:0x113
    if((GamerTagTitle != none) && GamerTagTitle.ScriptCtrl != none)
    {
        GamerTagTitle.ScriptCtrl.Tick(GamerTagTitle);
    }
    // End:0x155
    if((RankTitle != none) && RankTitle.ScriptCtrl != none)
    {
        RankTitle.ScriptCtrl.Tick(RankTitle);
    }
    // End:0x197
    if((PlayerTitleTitle != none) && PlayerTitleTitle.ScriptCtrl != none)
    {
        PlayerTitleTitle.ScriptCtrl.Tick(PlayerTitleTitle);
    }
    // End:0x1D9
    if((PositionData != none) && PositionData.ScriptCtrl != none)
    {
        PositionData.ScriptCtrl.Tick(PositionData);
    }
    // End:0x21B
    if((GamerTagData != none) && GamerTagData.ScriptCtrl != none)
    {
        GamerTagData.ScriptCtrl.Tick(GamerTagData);
    }
    // End:0x25D
    if((RankData != none) && RankData.ScriptCtrl != none)
    {
        RankData.ScriptCtrl.Tick(RankData);
    }
    // End:0x29F
    if((PlayerTitleData != none) && PlayerTitleData.ScriptCtrl != none)
    {
        PlayerTitleData.ScriptCtrl.Tick(PlayerTitleData);
    }
    // End:0x2E1
    if((TableTitleBG != none) && TableTitleBG.ScriptCtrl != none)
    {
        TableTitleBG.ScriptCtrl.Tick(TableTitleBG);
    }
    // End:0x2FF
    if(TheTable != none)
    {
        TheTable.Tick();
    }
    // End:0x341
    if((SelectedStatBlurb != none) && SelectedStatBlurb.ScriptCtrl != none)
    {
        SelectedStatBlurb.ScriptCtrl.Tick(SelectedStatBlurb);
    }
    I = 0;
    J0x348:

    // End:0x3B8 [Loop If]
    if(I < 5)
    {
        // End:0x3AE
        if((TableBG[I] != none) && TableBG[I].ScriptCtrl != none)
        {
            TableBG[I].ScriptCtrl.Tick(TableBG[I]);
        }
        I++;
        // [Loop Continue]
        goto J0x348;
    }
    I = 0;
    J0x3BF:

    // End:0x42F [Loop If]
    if(I < 3)
    {
        // End:0x425
        if((RowHighlight[I] != none) && RowHighlight[I].ScriptCtrl != none)
        {
            RowHighlight[I].ScriptCtrl.Tick(RowHighlight[I]);
        }
        I++;
        // [Loop Continue]
        goto J0x3BF;
    }
    //return;    
}

event SCCleanUpOnExit()
{
    ScreenTitle.ScriptCtrl = none;
    ScreenTitleBG.ScriptCtrl = none;
    PositionTitle.ScriptCtrl = none;
    GamerTagTitle.ScriptCtrl = none;
    RankTitle.ScriptCtrl = none;
    PlayerTitleTitle.ScriptCtrl = none;
    PositionData.ScriptCtrl = none;
    GamerTagData.ScriptCtrl = none;
    RankData.ScriptCtrl = none;
    PlayerTitleData.ScriptCtrl = none;
    TableTitleBG.ScriptCtrl = none;
    SelectedStatBlurb.ScriptCtrl = none;
    // End:0xDE
    if(TheTable != none)
    {
        TheTable.Deinitialize();
    }
    // End:0x103
    if(mLeaderboardReader != none)
    {
        mLeaderboardReader.Deinitialize();
        mLeaderboardReader = none;
    }
    mRankIconInformation = none;
    super.SCCleanUpOnExit();
    //return;    
}

// Export UTurokFEMPPersonalStats::execProcessInput(FFrame&, void* const)
native function bool ProcessInput(int ControllerId, name Key, byte Event, float AmountDepressed);

event bool SCInputKey_Multiplayer(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    // End:0x3F
    if((ProcessInput(ControllerId, Key, Event, AmountDepressed)) == false)
    {
        return super(TurokFEMultiplayerScreen).SCInputKey_Multiplayer(ControllerId, Key, Event, AmountDepressed);
    }
    return true;
    //return ReturnValue;    
}

event SetupScreenTitle()
{
    local float img_x, img_width, img_spacing;

    ScreenTitle = UILabel(Scene.FindChild(name("TitleText")));
    // End:0x13B
    if(!Class'Engine.Engine'.static.IsPC())
    {
        // End:0x13B
        if(ScreenTitle != none)
        {
            img_x = Class'TurokEngine.TurokUI'.static.GetPosX(RightTrigger);
            img_width = Class'TurokEngine.TurokUI'.static.GetWidth(RightTrigger);
            // End:0xD6
            if(Class'TurokEngine.TurokUI'.static.IsSD())
            {
                // End:0xC8
                if(Class'TurokEngine.TurokUI'.static.GetEngine().IsPS3())
                {
                    img_spacing = 0.0000000;                    
                }
                else
                {
                    img_spacing = -28.0000000;
                }                
            }
            else
            {
                // End:0x104
                if(Class'TurokEngine.TurokUI'.static.GetEngine().IsPS3())
                {
                    img_spacing = 2.0000000;                    
                }
                else
                {
                    img_spacing = -28.0000000;
                }
            }
            Class'TurokEngine.TurokUI'.static.SetPosX(ScreenTitle, (img_x + img_width) + img_spacing);
        }
    }
    ScreenTitleBG = UIImage(Scene.FindChild(name("TitleBG")));
    // End:0x16C
    if(ScreenTitle != none)
    {
    }
    //return;    
}

protected function SetupRankHeader()
{
    local int I;

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
    RankTitle = UILabel(Scene.FindChild(name("RankTitle")));
    // End:0xA1
    if(RankTitle != none)
    {
    }
    PlayerTitleTitle = UILabel(Scene.FindChild(name("TitleTitle")));
    // End:0xD5
    if(PlayerTitleTitle != none)
    {
    }
    PositionData = UILabel(Scene.FindChild(name("PositionData")));
    // End:0x10B
    if(PositionData != none)
    {
    }
    GamerTagData = UILabel(Scene.FindChild(name("GamerTagData")));
    // End:0x141
    if(GamerTagData != none)
    {
    }
    RankData = UILabel(Scene.FindChild(name("RankData")));
    // End:0x173
    if(RankData != none)
    {
    }
    PlayerTitleData = UILabel(Scene.FindChild(name("TitleData")));
    // End:0x1A6
    if(PlayerTitleData != none)
    {
    }
    TableTitleBG = UIImage(Scene.FindChild(name("StatsTableTitleBG")));
    // End:0x1E1
    if(TableTitleBG != none)
    {
    }
    I = 0;
    J0x1E8:

    // End:0x245 [Loop If]
    if(I < 5)
    {
        TableBG[I] = UIImage(Scene.FindChild(name("TableBG_" $ string(I))));
        // End:0x23B
        if(TableBG[I] != none)
        {
        }
        I++;
        // [Loop Continue]
        goto J0x1E8;
    }
    //return;    
}

protected function SetupTable()
{
    local int I;

    TheTable = TurokUITable(Scene.FindChild(name("TheTable")));
    // End:0x52
    if(TheTable != none)
    {
        UpdateStatData();
        TheTable.PostSetupInitialize();
    }
    SelectedStatBlurb = UILabel(Scene.FindChild(name("StatsBlurb")));
    // End:0x86
    if(SelectedStatBlurb != none)
    {
    }
    I = 0;
    J0x8D:

    // End:0xEF [Loop If]
    if(I < 3)
    {
        RowHighlight[I] = UIImage(Scene.FindChild(name("RowHighlight_" $ string(I))));
        // End:0xE5
        if(RowHighlight[I] != none)
        {
        }
        I++;
        // [Loop Continue]
        goto J0x8D;
    }
    PositionRowHighlight();
    //return;    
}

// Export UTurokFEMPPersonalStats::execPositionRowHighlight(FFrame&, void* const)
protected native function PositionRowHighlight();

// Export UTurokFEMPPersonalStats::execShowPlayerRank(FFrame&, void* const)
protected native function ShowPlayerRank(bool Enabled);

// Export UTurokFEMPPersonalStats::execUpdateRankData(FFrame&, void* const)
protected native function UpdateRankData();

// Export UTurokFEMPPersonalStats::execUpdateStatData(FFrame&, void* const)
protected native function UpdateStatData();

// Export UTurokFEMPPersonalStats::execUpdateStatDescription(FFrame&, void* const)
protected native function UpdateStatDescription();

// Export UTurokFEMPPersonalStats::execGetNextScreen(FFrame&, void* const)
protected native function string GetNextScreen();

// Export UTurokFEMPPersonalStats::execGetPrevScreen(FFrame&, void* const)
protected native function string GetPrevScreen();

// Export UTurokFEMPPersonalStats::execOnReadStatsCompleted(FFrame&, void* const)
native function OnReadStatsCompleted(bool success);

// Export UTurokFEMPPersonalStats::execOnSave(FFrame&, void* const)
native function OnSave();

// Export UTurokFEMPPersonalStats::execOnCancel(FFrame&, void* const)
native function OnCancel();

defaultproperties
{
    mPrevRow=-1
    kDisplayStats=/* Array type was not detected. */
    kCTFStats=/* Array type was not detected. */
    kWargameStats=/* Array type was not detected. */
    mFirstRowOffset=21.0000000
    SceneName="TurokFEStats.PersonalMP.PersonalMP"
}