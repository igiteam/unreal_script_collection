class TurokFEMPKills extends TurokFEMultiplayerStats
    native;

const kT_KillsStats = -1674803927;

enum eMPKillsColumns
{
    MPKC_RANK,                      // 0
    MPKC_LEVEL,                     // 1
    MPKC_VOICE,                     // 2
    MPKC_NAME,                      // 3
    MPKC_TIMES_KILLED,              // 4
    MPKC_STEALTH_KILLS,             // 5
    MPKC_KILLED_BY,                 // 6
    MPKC_STEALTH_KILLED_BY,         // 7
    MPKC_MAX                        // 8
};

// Export UTurokFEMPKills::execInitialize(FFrame&, void* const)
native function Initialize(@NULL pScene, @NULL pSceneClient);

// Export UTurokFEMPKills::execRefreshPlayers(FFrame&, void* const)
protected native function RefreshPlayers();

// Export UTurokFEMPKills::execRefreshTeams(FFrame&, void* const)
protected native function RefreshTeams(bool ShowTeamInfo);

// Export UTurokFEMPKills::execSortDataByColumn(FFrame&, void* const)
protected native function SortDataByColumn(int column);

// Export UTurokFEMPKills::execSortTeamDataByColumn(FFrame&, void* const)
protected native function SortTeamDataByColumn(int column);

// Export UTurokFEMPKills::execGetNextScreen(FFrame&, void* const)
protected native function string GetNextScreen();

// Export UTurokFEMPKills::execGetPrevScreen(FFrame&, void* const)
protected native function string GetPrevScreen();

// Export UTurokFEMPKills::execGetDefaultSelectedColumn(FFrame&, void* const)
protected native function int GetDefaultSelectedColumn(byte GamePlayMode);

protected event SetupTitle()
{
    local string the_title, player_name;
    local @NULL player_results;
    local float img_x, img_width, img_spacing;

    super.SetupTitle();
    // End:0x6C
    if(Class'Engine.Engine'.static.GetTurokNet().GetLobby() != none)
    {
        player_results = Class'Engine.Engine'.static.GetTurokNet().GetLobby().GetGameResults().GetLocalPlayerResults();
        player_name = player_results.mName;
    }
    the_title = (Class'TurokEngine.TurokUI'.static.GetLocalizedString(-1674803927) $ " - ") $ player_name;
    TitleText.SetValue(the_title);
    // End:0xC0
    if(Class'Engine.Engine'.static.IsPC())
    {
        return;
    }
    img_x = Class'TurokEngine.TurokUI'.static.GetPosX(RightTrigger);
    img_width = Class'TurokEngine.TurokUI'.static.GetWidth(RightTrigger);
    // End:0x14F
    if(Class'TurokEngine.TurokUI'.static.IsSD())
    {
        // End:0x141
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
        // End:0x17D
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

    I = 0;
    J0x07:

    // End:0x1FF [Loop If]
    if(I < 2)
    {
        TeamIcons[I] = UIImage(Scene.FindChild(name("TeamIcon_" $ string(I)), true));
        TeamNames[I] = UILabel(Scene.FindChild(name("TeamName_" $ string(I)), true));
        BattleRatingText[I] = UILabel(Scene.FindChild(name("TeamBattleRating_" $ string(I)), true));
        Stat1Text[I] = UILabel(Scene.FindChild(name("TeamAccuracy_" $ string(I)), true));
        Stat2Text[I] = UILabel(Scene.FindChild(name("TeamTimesKilled_" $ string(I)), true));
        Stat3Text[I] = UILabel(Scene.FindChild(name("TeamStealthKills_" $ string(I)), true));
        Stat4Text[I] = UILabel(Scene.FindChild(name("TeamKilledBy_" $ string(I)), true));
        Stat5Text[I] = UILabel(Scene.FindChild(name("TeamStealthKilledBy_" $ string(I)), true));
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    TeamInfoSeparator = UIImage(Scene.FindChild(name("TeamInfoSeparator"), true));
    TeamInfoBG = UIImage(Scene.FindChild(name("TeamInfoBG"), true));
    //return;    
}

defaultproperties
{
    mAllowColumnScroll=true
    mAllowRowScroll=true
    mRowHighlightPosY=34.0000000
    mRowHighlightSpacing=24.4000000
    SceneName="TurokFEStats.Kills.Kills"
}