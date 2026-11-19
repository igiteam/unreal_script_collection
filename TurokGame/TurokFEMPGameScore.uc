class TurokFEMPGameScore extends TurokFEMultiplayerStats
    native;

enum CommonGameScoreColumns
{
    CGSC_RANK,                      // 0
    CGSC_LEVEL,                     // 1
    CGSC_VOICE,                     // 2
    CGSC_NAME,                      // 3
    CGSC_BATTLE_RATING,             // 4
    CGSC_MAX                        // 5
};

enum TDMGameScoreColumns
{
    TDMGSC_KILLS,                   // 0
    TDMGSC_ASSISTS,                 // 1
    TDMGSC_DEATHS,                  // 2
    TDMGSC_FRIENDLYFIREKILLS,       // 3
    TDMGSC_ACCURACY,                // 4
    TDMGSC_SCORE,                   // 5
    TDMGSC_MAX                      // 6
};

enum DMGameScoreColumns
{
    DMGSC_KILLS,                    // 0
    DMGSC_ASSISTS,                  // 1
    DMGSC_DEATHS,                   // 2
    DMGSC_SUICIDES,                 // 3
    DMGSC_ACCURACY,                 // 4
    DMGSC_SCORE,                    // 5
    DMGSC_MAX                       // 6
};

enum CTFGameScoreColumns
{
    CTFGSC_KILLS,                   // 0
    CTFGSC_ASSISTS,                 // 1
    CTFGSC_DEATHS,                  // 2
    CTFGSC_ACTS,                    // 3
    CTFGSC_POINTS,                  // 4
    CTFGSC_FLAGS,                   // 5
    CTFGSC_MAX                      // 6
};

enum WGScoreColumns
{
    WGSC_KILLS,                     // 0
    WGSC_ASSISTS,                   // 1
    WGSC_DEATHS,                    // 2
    WGSC_ACCURACY,                  // 3
    WGSC_ACTS,                      // 4
    WGSC_POINTS,                    // 5
    WGSC_MAX                        // 6
};

var @NULL mWolfpackTeamTex;
var @NULL mWhiskeyTeamTex;

// Export UTurokFEMPGameScore::execInitialize(FFrame&, void* const)
native function Initialize(@NULL pScene, @NULL pSceneClient);

// Export UTurokFEMPGameScore::execRefreshPlayers(FFrame&, void* const)
protected native function RefreshPlayers();

// Export UTurokFEMPGameScore::execRefreshTeams(FFrame&, void* const)
protected native function RefreshTeams(bool ShowTeamInfo);

// Export UTurokFEMPGameScore::execSortTeamDataByColumn(FFrame&, void* const)
protected native function SortTeamDataByColumn(int column);

// Export UTurokFEMPGameScore::execGetNextScreen(FFrame&, void* const)
protected native function string GetNextScreen();

// Export UTurokFEMPGameScore::execGetPrevScreen(FFrame&, void* const)
protected native function string GetPrevScreen();

// Export UTurokFEMPGameScore::execGetDefaultSelectedColumn(FFrame&, void* const)
protected native function int GetDefaultSelectedColumn(byte GamePlayMode);

protected event SetupTitle()
{
    local string Title;
    local @NULL GameResults;
    local int GamePlayModeId;
    local @NULL GamePlayMode;
    local float img_x, img_width, img_spacing;

    super.SetupTitle();
    // End:0xA4
    if(Class'Engine.Engine'.static.GetTurokNet().GetLobby() != none)
    {
        GameResults = Class'Engine.Engine'.static.GetTurokNet().GetLobby().GetGameResults();
        GamePlayModeId = GameResults.GetGamePlayModeId();
        Class'Engine.TurokOnlineGameSettings'.static.GetGamePlayModeById(GamePlayModeId, GamePlayMode);
        Title = Class'TurokEngine.TurokUI'.static.GetLocalizedString(GamePlayMode.NameHash);
    }
    TitleText.SetValue(Title);
    // End:0xCC
    if(Class'Engine.Engine'.static.IsPC())
    {
        return;
    }
    img_x = Class'TurokEngine.TurokUI'.static.GetPosX(RightTrigger);
    img_width = Class'TurokEngine.TurokUI'.static.GetWidth(RightTrigger);
    // End:0x15B
    if(Class'TurokEngine.TurokUI'.static.IsSD())
    {
        // End:0x14D
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
        // End:0x189
        if(Class'TurokEngine.TurokUI'.static.GetEngine().IsPS3())
        {
            img_spacing = 2.0000000;            
        }
        else
        {
            img_spacing = -28.0000000;
        }
    }
    Class'TurokEngine.TurokUI'.static.SetPosX(TitleText, (img_x + img_width) + img_spacing);
    //return;    
}

protected function SetupTeamInfo()
{
    local int I;

    super.SetupTeamInfo();
    I = 0;
    J0x0D:

    // End:0x22A [Loop If]
    if(I < 2)
    {
        TeamIcons[I] = UIImage(Scene.FindChild(name("TeamIcon_" $ string(I)), true));
        TeamNames[I] = UILabel(Scene.FindChild(name("TeamName_" $ string(I)), true));
        BattleRatingText[I] = UILabel(Scene.FindChild(name("TeamBattleRating_" $ string(I)), true));
        Stat1Text[I] = UILabel(Scene.FindChild(name("TeamAccuracy_" $ string(I)), true));
        Stat2Text[I] = UILabel(Scene.FindChild(name("TeamKills_" $ string(I)), true));
        Stat3Text[I] = UILabel(Scene.FindChild(name("TeamAssists_" $ string(I)), true));
        Stat4Text[I] = UILabel(Scene.FindChild(name("TeamDeaths_" $ string(I)), true));
        Stat5Text[I] = UILabel(Scene.FindChild(name("TeamKillDeath_" $ string(I)), true));
        Stat6Text[I] = UILabel(Scene.FindChild(name("TeamScore_" $ string(I)), true));
        I++;
        // [Loop Continue]
        goto J0x0D;
    }
    TeamInfoSeparator = UIImage(Scene.FindChild(name("TeamInfoSeparator"), true));
    TeamInfoBG = UIImage(Scene.FindChild(name("TeamInfoBG"), true));
    //return;    
}

defaultproperties
{
    mWolfpackTeamTex=Texture2D'TurokFEStats.BlueTeamBoxes'
    mWhiskeyTeamTex=Texture2D'TurokFEStats.RedBlueTeamBoxes'
    mAllowColumnScroll=true
    mAllowRowScroll=true
    mRowHighlightPosY=34.0000000
    mRowHighlightSpacing=24.4000000
    SceneName="TurokFEStats.GameScore.GameScore"
}