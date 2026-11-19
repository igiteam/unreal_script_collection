class TurokGameUISCManager extends TurokUISceneControllerManager
    native;

var protected int mFirstTemporaryIndex;

function SetGlobalState()
{
    local int Index;

    Index = 0;
    SCNames[Index] = "BusyScreen";
    SCObjects[Index] = new (self) Class'TurokEngine.TurokFEBusyScreen';
    ++Index;
    SCNames[Index] = "DebugMainMenu";
    SCObjects[Index] = new (self) Class'TurokFEDebugMainMenu';
    ++Index;
    SCNames[Index] = "DebugOptionsMenu";
    SCObjects[Index] = new (self) Class'TurokFEDebugOptionsMenu';
    ++Index;
    SCNames[Index] = "DebugMPMenu";
    SCObjects[Index] = new (self) Class'TurokFEDebugMPMenu';
    ++Index;
    SCNames[Index] = "DebugSubmenu01";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu01';
    ++Index;
    SCNames[Index] = "DebugSubmenu02";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu02';
    ++Index;
    SCNames[Index] = "DebugSubmenu03";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu03';
    ++Index;
    SCNames[Index] = "DebugSubmenu04";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu04';
    ++Index;
    SCNames[Index] = "DebugSubmenu05";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu05';
    ++Index;
    SCNames[Index] = "DebugSubmenu06";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu06';
    ++Index;
    SCNames[Index] = "DebugSubmenu07";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu07';
    ++Index;
    SCNames[Index] = "DebugSubmenu08";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu08';
    ++Index;
    SCNames[Index] = "DebugSubmenu09";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu09';
    ++Index;
    SCNames[Index] = "DebugSubmenu10";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu10';
    ++Index;
    SCNames[Index] = "DebugSubmenu11";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu11';
    ++Index;
    SCNames[Index] = "DebugSubmenu12";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu12';
    ++Index;
    SCNames[Index] = "DebugSubmenu13";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu13';
    ++Index;
    SCNames[Index] = "DebugSubmenu14";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu14';
    ++Index;
    SCNames[Index] = "DebugSubmenu15";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu15';
    ++Index;
    SCNames[Index] = "DebugSubmenu16";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu16';
    ++Index;
    SCNames[Index] = "DebugSubmenu17";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu17';
    ++Index;
    SCNames[Index] = "DebugSubmenu18";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu18';
    ++Index;
    SCNames[Index] = "DebugSubmenu19";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu19';
    ++Index;
    SCNames[Index] = "DebugSubmenu20";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu20';
    ++Index;
    SCNames[Index] = "DebugSubmenu21";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu21';
    ++Index;
    SCNames[Index] = "DebugSubmenu22";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu22';
    ++Index;
    SCNames[Index] = "DebugSubmenu23";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu23';
    ++Index;
    SCNames[Index] = "DebugSubmenu24";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu24';
    ++Index;
    SCNames[Index] = "DebugSubmenu25";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu25';
    ++Index;
    SCNames[Index] = "DebugSubmenu26";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu26';
    ++Index;
    SCNames[Index] = "DebugSubmenu27";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu27';
    ++Index;
    SCNames[Index] = "DebugSubmenu28";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu28';
    ++Index;
    SCNames[Index] = "DebugSubmenu29";
    SCObjects[Index] = new (self) Class'TurokFEDebugSubmenu29';
    ++Index;
    SCNames[Index] = "TestScene";
    SCObjects[Index] = new (self) Class'TurokFEDebugTest';
    ++Index;
    SCNames[Index] = "LocalizationTest";
    SCObjects[Index] = new (self) Class'TurokFELocalizationTest';
    ++Index;
    mFirstTemporaryIndex = Index;
    //return;    
}

function SetFEState()
{
    local int Index;

    Index = mFirstTemporaryIndex;
    ClearState();
    SCNames[Index] = "MainMenu";
    SCObjects[Index] = new (self) Class'TurokFEMainMenu';
    ++Index;
    SCNames[Index] = "BootFlowLogoVideo";
    SCObjects[Index] = new (self) Class'TurokFEBootFlowLogoVideo';
    ++Index;
    SCNames[Index] = "BootFlowUnrealLogo";
    SCObjects[Index] = new (self) Class'TurokFEBootFlowUnrealLogo';
    ++Index;
    SCNames[Index] = "BootFlowESRB";
    SCObjects[Index] = new (self) Class'TurokFEBootFlowESRB';
    ++Index;
    SCNames[Index] = "BootFlowBVGLogo";
    SCObjects[Index] = new (self) Class'TurokFEBootFlowBVGLogo';
    ++Index;
    SCNames[Index] = "BootFlowPressStart";
    SCObjects[Index] = new (self) Class'TurokFEBootFlowPressStart';
    ++Index;
    SCNames[Index] = "BootFlowIntro";
    SCObjects[Index] = new (self) Class'TurokFEBootFlowIntro';
    ++Index;
    SCNames[Index] = "DemoLoopMovie";
    SCObjects[Index] = new (self) Class'TurokFEDemoLoop';
    ++Index;
    SCNames[Index] = "Lobby";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerLobby';
    ++Index;
    SCNames[Index] = "MatchLaunch";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerMatchLaunch';
    ++Index;
    SCNames[Index] = "MatchMaking";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerMatchMaking';
    ++Index;
    SCNames[Index] = "PS3FriendInviteOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerPS3FriendInviteOverlay';
    ++Index;
    SCNames[Index] = "LobbyModeOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerLobbyModeOverlay';
    ++Index;
    SCNames[Index] = "GameModeOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerGameModeOverlay';
    ++Index;
    SCNames[Index] = "GamePlayModeOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerGamePlayModeOverlay';
    ++Index;
    SCNames[Index] = "ScoreOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerScoreOverlay';
    ++Index;
    SCNames[Index] = "TimeOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerTimeOverlay';
    ++Index;
    SCNames[Index] = "LivesOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerLivesOverlay';
    ++Index;
    SCNames[Index] = "TeamLivesOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerTeamLivesOverlay';
    ++Index;
    SCNames[Index] = "MapOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerSelectMapOverlay';
    ++Index;
    SCNames[Index] = "MultiAdvancedOptions";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerAdvancedOptions';
    ++Index;
    SCNames[Index] = "SelectWeaponSet";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerSelectWeaponSet';
    ++Index;
    SCNames[Index] = "DifficultyOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerDifficultyOverlay';
    ++Index;
    SCNames[Index] = "SelectTeamOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerSelectTeamOverlay';
    ++Index;
    SCNames[Index] = "JoinLanGame";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerJoinLanGame';
    ++Index;
    SCNames[Index] = "PostGameStatsGameScore";
    SCObjects[Index] = new (self) Class'TurokFEMPGameScore';
    ++Index;
    SCNames[Index] = "PostGameStatsKills";
    SCObjects[Index] = new (self) Class'TurokFEMPKills';
    ++Index;
    SCNames[Index] = "PostGameStatsPersonalStats";
    SCObjects[Index] = new (self) Class'TurokFEMPPersonalStats';
    ++Index;
    SCNames[Index] = "PersonalMultiplayer";
    SCObjects[Index] = new (self) Class'TurokFEStatsPersonalMultiplayer';
    ++Index;
    SCNames[Index] = "OptionsController";
    SCObjects[Index] = new (self) Class'TurokFEOptionsController';
    ++Index;
    SCNames[Index] = "OptionsControlsPC";
    SCObjects[Index] = new (self) Class'TurokFEOptionsControlsPC';
    ++Index;
    SCNames[Index] = "OptionsControllerPS3";
    SCObjects[Index] = new (self) Class'TurokFEOptionsControllerPS3';
    ++Index;
    SCNames[Index] = "OptionsAdvanced";
    SCObjects[Index] = new (self) Class'TurokFEOptionsAdvanced';
    ++Index;
    SCNames[Index] = "OptionsAudio";
    SCObjects[Index] = new (self) Class'TurokFEOptionsAudio';
    ++Index;
    SCNames[Index] = "OptionsVideo";
    SCObjects[Index] = new (self) Class'TurokFEOptionsVideo';
    ++Index;
    SCNames[Index] = "OptionsProfile";
    SCObjects[Index] = new (self) Class'TurokFEOptionsProfile';
    ++Index;
    SCNames[Index] = "ProfileSelect";
    SCObjects[Index] = new (self) Class'TurokFEProfileSelectProfileOverlay';
    ++Index;
    SCNames[Index] = "KeyBindingDialog";
    SCObjects[Index] = new (self) Class'TurokEngine.TurokUIKeyBindingDialog';
    ++Index;
    SCNames[Index] = "Dialog";
    SCObjects[Index] = new (self) Class'TurokEngine.TurokUIDialog';
    ++Index;
    SCNames[Index] = "HelpBar";
    SCObjects[Index] = new (self) Class'TurokEngine.TurokUIHelpBar';
    ++Index;
    SCNames[Index] = "InviteNotification";
    SCObjects[Index] = new (self) Class'TurokEngine.TurokUIInviteNotification';
    ++Index;
    SCNames[Index] = "PS3Patch";
    SCObjects[Index] = new (self) Class'TurokPS3PatchOverlay';
    ++Index;
    SCNames[Index] = "LoadMission";
    SCObjects[Index] = new (self) Class'TurokFELoadMissionMenu';
    ++Index;
    SCNames[Index] = "Credits";
    SCObjects[Index] = new (self) Class'TurokFEExtrasCredits';
    ++Index;
    SCNames[Index] = "Achievements";
    SCObjects[Index] = new (self) Class'TurokFEStatsAchievements';
    ++Index;
    SCNames[Index] = "Leaderboards";
    SCObjects[Index] = new (self) Class'TurokFEStatsLeaderboards';
    ++Index;
    SCNames[Index] = "PressPauseMenu";
    SCObjects[Index] = new (self) Class'TurokFEPressDemoPause';
    ++Index;
    SCNames[Index] = "StringTestBed";
    SCObjects[Index] = new (self) Class'StringTestBed';
    ++Index;
    SetControllerMap();
    //return;    
}

function SetFEState_SD()
{
    local int Index;

    Index = mFirstTemporaryIndex;
    ClearState();
    SCNames[Index] = "MainMenu";
    SCObjects[Index] = new (self) Class'TurokFEMainMenu_SD';
    ++Index;
    SCNames[Index] = "BootFlowLogoVideo";
    SCObjects[Index] = new (self) Class'TurokFEBootFlowLogoVideo_SD';
    ++Index;
    SCNames[Index] = "BootFlowUnrealLogo";
    SCObjects[Index] = new (self) Class'TurokFEBootFlowUnrealLogo_SD';
    ++Index;
    SCNames[Index] = "BootFlowBVGLogo";
    SCObjects[Index] = new (self) Class'TurokFEBootFlowBVGLogo_SD';
    ++Index;
    SCNames[Index] = "BootFlowPressStart";
    SCObjects[Index] = new (self) Class'TurokFEBootFlowPressStart_SD';
    ++Index;
    SCNames[Index] = "BootFlowIntro";
    SCObjects[Index] = new (self) Class'TurokFEBootFlowIntro_SD';
    ++Index;
    SCNames[Index] = "DemoLoopMovie";
    SCObjects[Index] = new (self) Class'TurokFEDemoLoop_SD';
    ++Index;
    SCNames[Index] = "Lobby";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerLobby_SD';
    ++Index;
    SCNames[Index] = "MatchLaunch";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerMatchLaunch_SD';
    ++Index;
    SCNames[Index] = "MatchMaking";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerMatchMaking_SD';
    ++Index;
    SCNames[Index] = "PS3FriendInviteOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerPS3FriendInviteOverlay_SD';
    ++Index;
    SCNames[Index] = "LobbyModeOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerLobbyModeOverlay_SD';
    ++Index;
    SCNames[Index] = "GameModeOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerGameModeOverlay_SD';
    ++Index;
    SCNames[Index] = "GamePlayModeOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerGamePlayModeOverlay_SD';
    ++Index;
    SCNames[Index] = "ScoreOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerScoreOverlay_SD';
    ++Index;
    SCNames[Index] = "TimeOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerTimeOverlay_SD';
    ++Index;
    SCNames[Index] = "LivesOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerLivesOverlay_SD';
    ++Index;
    SCNames[Index] = "TeamLivesOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerTeamLivesOverlay_SD';
    ++Index;
    SCNames[Index] = "MapOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerSelectMapOverlay_SD';
    ++Index;
    SCNames[Index] = "MultiAdvancedOptions";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerAdvancedOptions_SD';
    ++Index;
    SCNames[Index] = "SelectWeaponSet";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerSelectWeaponSet_SD';
    ++Index;
    SCNames[Index] = "DifficultyOverlay";
    SCObjects[Index] = new (self) Class'TurokFEMultiplayerDifficultyOverlay_SD';
    ++Index;
    SCNames[Index] = "PostGameStatsGameScore";
    SCObjects[Index] = new (self) Class'TurokFEMPGameScore_SD';
    ++Index;
    SCNames[Index] = "PostGameStatsKills";
    SCObjects[Index] = new (self) Class'TurokFEMPKills_SD';
    ++Index;
    SCNames[Index] = "PostGameStatsPersonalStats";
    SCObjects[Index] = new (self) Class'TurokFEMPPersonalStats_SD';
    ++Index;
    SCNames[Index] = "OptionsController";
    SCObjects[Index] = new (self) Class'TurokFEOptionsController_SD';
    ++Index;
    SCNames[Index] = "OptionsControllerPS3";
    SCObjects[Index] = new (self) Class'TurokFEOptionsControllerPS3_SD';
    ++Index;
    SCNames[Index] = "OptionsAdvanced";
    SCObjects[Index] = new (self) Class'TurokFEOptionsAdvanced_SD';
    ++Index;
    SCNames[Index] = "Dialog";
    SCObjects[Index] = new (self) Class'TurokEngine.TurokUIDialog_SD';
    ++Index;
    SCNames[Index] = "HelpBar";
    SCObjects[Index] = new (self) Class'TurokEngine.TurokUIHelpBar_SD';
    ++Index;
    SCNames[Index] = "InviteNotification";
    SCObjects[Index] = new (self) Class'TurokEngine.TurokUIInviteNotification';
    ++Index;
    SCNames[Index] = "PS3Patch";
    SCObjects[Index] = new (self) Class'TurokPS3PatchOverlay_SD';
    ++Index;
    SCNames[Index] = "LoadMission";
    SCObjects[Index] = new (self) Class'TurokFELoadMissionMenu_SD';
    ++Index;
    SCNames[Index] = "Credits";
    SCObjects[Index] = new (self) Class'TurokFEExtrasCredits_SD';
    ++Index;
    SCNames[Index] = "Achievements";
    SCObjects[Index] = new (self) Class'TurokFEStatsAchievements_SD';
    ++Index;
    SCNames[Index] = "Leaderboards";
    SCObjects[Index] = new (self) Class'TurokFEStatsLeaderboards_SD';
    ++Index;
    SCNames[Index] = "PersonalMultiplayer";
    SCObjects[Index] = new (self) Class'TurokFEStatsPersonalMultiplayer_SD';
    ++Index;
    SCNames[Index] = "PressPauseMenu";
    SCObjects[Index] = new (self) Class'TurokFEPressDemoPause';
    ++Index;
    SCNames[Index] = "StringTestBed";
    SCObjects[Index] = new (self) Class'StringTestBed';
    ++Index;
    SetControllerMap();
    //return;    
}

function SetInGameState()
{
    local int Index;

    Index = mFirstTemporaryIndex;
    ClearState();
    SCNames[Index] = "ControllerPulled";
    SCObjects[Index] = new (self) Class'TurokFEControllerPulled';
    ++Index;
    SCNames[Index] = "PauseMenu";
    SCObjects[Index] = new (self) Class'TurokFEPauseMenu';
    ++Index;
    SCNames[Index] = "PauseMenuMP";
    SCObjects[Index] = new (self) Class'TurokFEPauseMenuMP';
    ++Index;
    SCNames[Index] = "OptionsAudio";
    SCObjects[Index] = new (self) Class'TurokFEOptionsAudio';
    ++Index;
    SCNames[Index] = "OptionsAdvanced";
    SCObjects[Index] = new (self) Class'TurokFEOptionsAdvanced';
    ++Index;
    SCNames[Index] = "OptionsControlsPC";
    SCObjects[Index] = new (self) Class'TurokFEOptionsControlsPC';
    ++Index;
    SCNames[Index] = "KeyBindingDialog";
    SCObjects[Index] = new (self) Class'TurokEngine.TurokUIKeyBindingDialog';
    ++Index;
    SCNames[Index] = "HelpBar";
    SCObjects[Index] = new (self) Class'TurokEngine.TurokUIHelpBar';
    ++Index;
    SCNames[Index] = "PauseOptionsController";
    SCObjects[Index] = new (self) Class'TurokFEPauseOptionsController';
    ++Index;
    SCNames[Index] = "PauseOptionsControllerPS3";
    SCObjects[Index] = new (self) Class'TurokFEPauseOptionsControllerPS3';
    ++Index;
    SCNames[Index] = "PauseOptionsAdvanced";
    SCObjects[Index] = new (self) Class'TurokFEPauseOptionsAdvanced';
    ++Index;
    SCNames[Index] = "Dialog";
    SCObjects[Index] = new (self) Class'TurokEngine.TurokUIDialog';
    ++Index;
    SCNames[Index] = "LoadMission";
    SCObjects[Index] = new (self) Class'TurokFELoadMissionMenu';
    ++Index;
    SCNames[Index] = "LoadProgress";
    SCObjects[Index] = new (self) Class'TurokFELoadProgressMenu';
    ++Index;
    SCNames[Index] = "EndGameCredits";
    SCObjects[Index] = new (self) Class'TurokFEEndGameCredits';
    ++Index;
    SetControllerMap();
    //return;    
}

function SetInGameState_SD()
{
    local int Index;

    Index = mFirstTemporaryIndex;
    ClearState();
    SCNames[Index] = "ControllerPulled";
    SCObjects[Index] = new (self) Class'TurokFEControllerPulledSD';
    ++Index;
    SCNames[Index] = "PauseMenu";
    SCObjects[Index] = new (self) Class'TurokFEPauseMenu_SD';
    ++Index;
    SCNames[Index] = "PauseMenuMP";
    SCObjects[Index] = new (self) Class'TurokFEPauseMenuMP_SD';
    ++Index;
    SCNames[Index] = "PauseOptionsController";
    SCObjects[Index] = new (self) Class'TurokFEPauseOptionsController_SD';
    ++Index;
    SCNames[Index] = "PauseOptionsControllerPS3";
    SCObjects[Index] = new (self) Class'TurokFEPauseOptionsControllerPS3_SD';
    ++Index;
    SCNames[Index] = "PauseOptionsAdvanced";
    SCObjects[Index] = new (self) Class'TurokFEPauseOptionsAdvanced_SD';
    ++Index;
    SCNames[Index] = "Dialog";
    SCObjects[Index] = new (self) Class'TurokEngine.TurokUIDialog_SD';
    ++Index;
    SCNames[Index] = "LoadMission";
    SCObjects[Index] = new (self) Class'TurokFELoadMissionMenu';
    ++Index;
    SCNames[Index] = "LoadProgress";
    SCObjects[Index] = new (self) Class'TurokFELoadProgressMenu';
    ++Index;
    SCNames[Index] = "EndGameCredits";
    SCObjects[Index] = new (self) Class'TurokFEEndGameCredits';
    ++Index;
    SetControllerMap();
    //return;    
}

function ClearState()
{
    // End:0x40
    if(mFirstTemporaryIndex < SCObjects.Length)
    {
        SCObjects.Remove(mFirstTemporaryIndex, SCObjects.Length - mFirstTemporaryIndex);
        SCNames.Remove(mFirstTemporaryIndex, SCNames.Length - mFirstTemporaryIndex);
    }
    ClearMap();
    //return;    
}

// Export UTurokGameUISCManager::execPlayOverlaySound(FFrame&, void* const)
native function PlayOverlaySound(bool bOverlayIsFadingIn);

function ToggleDebugFEAudio()
{
    Class'TurokEngine.TurokUI'.static.GetFEAudio().ToggleDebugFEAudio();
    //return;    
}

function OnWriteProfile(byte ControllerId, bool bSuccessful)
{
    //return;    
}

function AllMaps()
{
    local @NULL db, Profile;
    local int numChapters, lastChapterId;

    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    // End:0xD5
    if(db != none)
    {
        Profile = TurokOnlineProfile(db.GetSignedInProfile());
        // End:0xD5
        if(Profile != none)
        {
            numChapters = Class'TurokEngine.TurokUI'.static.GetEngine().mChapterpointManager.GetNumberOfChapterpoints();
            lastChapterId = Class'TurokEngine.TurokUI'.static.GetEngine().mChapterpointManager.GetChapterpointIdFromIndex(numChapters - 1);
            Profile.SetFurthestReachedLevel_AllDifficulties(lastChapterId);
            db.WriteSignedInProfile(OnWriteProfile);
        }
    }
    //return;    
}

function NoMaps()
{
    local @NULL db, Profile;
    local int firstChapterId;

    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    // End:0xA2
    if(db != none)
    {
        Profile = TurokOnlineProfile(db.GetSignedInProfile());
        // End:0xA2
        if(Profile != none)
        {
            firstChapterId = Class'TurokEngine.TurokUI'.static.GetEngine().mChapterpointManager.GetChapterpointIdFromIndex(0);
            Profile.SetFurthestReachedLevel_AllDifficulties(firstChapterId);
            db.WriteSignedInProfile(OnWriteProfile);
        }
    }
    //return;    
}

function DebugLockHardMode()
{
    local @NULL db, Profile;

    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    // End:0x5B
    if(db != none)
    {
        Profile = TurokOnlineProfile(db.GetSignedInProfile());
        // End:0x5B
        if(Profile != none)
        {
            Profile.SetProfileSettingValueId(64, 0);
        }
    }
    //return;    
}

function DebugUnlockHardMode()
{
    local @NULL db, Profile;

    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    // End:0x5B
    if(db != none)
    {
        Profile = TurokOnlineProfile(db.GetSignedInProfile());
        // End:0x5B
        if(Profile != none)
        {
            Profile.SetProfileSettingValueId(64, 1);
        }
    }
    //return;    
}

defaultproperties
{
    kPostSPGameScreenStack=/* Array type was not detected. */
    kPostMPGameScreenStack=/* Array type was not detected. */
    kPostLanMPGameScreenStack=/* Array type was not detected. */
    kPostSignOutScreenStack=/* Array type was not detected. */
}