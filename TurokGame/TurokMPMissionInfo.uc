class TurokMPMissionInfo extends Actor
    native
    placeable
    hidecategories(Navigation,Object)
    autoexpandcategories(Multiplayer);

var(Multiplayer) private const string DM_ObjectiveTitle;
var(Multiplayer) private const string DM_ObjectiveText;
var(Multiplayer) private const string DM_Name;
var(Multiplayer) private const string TeamDM_ObjectiveTitle;
var(Multiplayer) private const string TeamDM_ObjectiveText;
var(Multiplayer) private const string TeamDM_Name;
var(Multiplayer) private const string CTF_ObjectiveTitle;
var(Multiplayer) private const string CTF_ObjectiveText;
var(Multiplayer) private const string CTF_Name;
var(Multiplayer) private const string Assault_Attack_ObjectiveTitle;
var(Multiplayer) private const string Assault_Attack_ObjectiveText;
var(Multiplayer) private const string Assault_Attack_Name;
var(Multiplayer) private const string Assault_Defend_ObjectiveTitle;
var(Multiplayer) private const string Assault_Defend_ObjectiveText;
var(Multiplayer) private const string Assault_Defend_Name;
var(Multiplayer) private const string Wargame_Team0_ObjectiveTitle;
var(Multiplayer) private const string Wargame_Team0_ObjectiveText;
var(Multiplayer) private const string Wargame_Team1_ObjectiveTitle;
var(Multiplayer) private const string Wargame_Team1_ObjectiveText;
var(Multiplayer) private const string Wargame_Name;
var(Multiplayer) private const bool mCanToggleOnWargameObjectiveIndicator;
var(Multiplayer) private const bool mCanToggleOnWargameObjectiveText;
var(Multiplayer) private const string Coop_Name;
var(Multiplayer) private const editinline @NULL mMissionAudio;

function OnSetWargameObjective(@NULL Action)
{
    // End:0x64
    if(TurokWarGame(WorldInfo.Game) != none)
    {
        TurokWarGame(WorldInfo.Game).SetWargameObjective(Action.mObjectiveTeamID, Action.mObjectiveTarget, Action.mObjectiveHashID);
    }
    //return;    
}

simulated function bool CanToggleOnWargameObjectiveIndicator()
{
    return mCanToggleOnWargameObjectiveIndicator;
    //return ReturnValue;    
}

simulated function bool CanToggleOnWargameObjectiveText()
{
    return mCanToggleOnWargameObjectiveText;
    //return ReturnValue;    
}

simulated function PlayGameStartSpeech(int playerTeamID, @NULL HUD)
{
    // End:0xA6
    if(((HUD != none) && HUD.mSoundController != none) && mMissionAudio != none)
    {
        switch(playerTeamID)
        {
            // End:0x6C
            case 0:
                HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWCGameStartSoundCue());
                // End:0xA6
                break;
            // End:0xA3
            case 1:
                HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWPGameStartSoundCue());
                // End:0xA6
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

simulated function PlayRivalKilledSpeech(int playerTeamID, @NULL HUD)
{
    // End:0xB3
    if(((HUD != none) && HUD.mSoundController != none) && mMissionAudio != none)
    {
        switch(playerTeamID)
        {
            // End:0x3A
            case 255:
            // End:0x75
            case 0:
                HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWCRivalKilledSoundCue(), 1.0000000);
                // End:0xB3
                break;
            // End:0xB0
            case 1:
                HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWPRivalKilledSoundCue(), 1.0000000);
                // End:0xB3
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

simulated function PlayLowTeamLivesSpeech(int playerTeamID, @NULL HUD)
{
    // End:0xAE
    if(((HUD != none) && HUD.mSoundController != none) && mMissionAudio != none)
    {
        switch(playerTeamID)
        {
            // End:0x70
            case 0:
                HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWCLowTeamLivesSoundCue(), 1.0000000);
                // End:0xAE
                break;
            // End:0xAB
            case 1:
                HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWPLowTeamLivesSoundCue(), 1.0000000);
                // End:0xAE
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

simulated function PlayMedSecSpeech(int playerTeamID, @NULL HUD)
{
    // End:0xB3
    if(((HUD != none) && HUD.mSoundController != none) && mMissionAudio != none)
    {
        switch(playerTeamID)
        {
            // End:0x3A
            case 255:
            // End:0x75
            case 0:
                HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWCMedTimeSoundCue(), 3.0000000);
                // End:0xB3
                break;
            // End:0xB0
            case 1:
                HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWPMedTimeSoundCue(), 3.0000000);
                // End:0xB3
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

simulated function PlayLowSecSpeech(int playerTeamID, @NULL HUD)
{
    // End:0xB3
    if(((HUD != none) && HUD.mSoundController != none) && mMissionAudio != none)
    {
        switch(playerTeamID)
        {
            // End:0x3A
            case 255:
            // End:0x75
            case 0:
                HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWCLowTimeSoundCue(), 3.0000000);
                // End:0xB3
                break;
            // End:0xB0
            case 1:
                HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWPLowTimeSoundCue(), 3.0000000);
                // End:0xB3
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

simulated function Play60SecsSpeech(int playerTeamID, @NULL HUD)
{
    // End:0xB3
    if(((HUD != none) && HUD.mSoundController != none) && mMissionAudio != none)
    {
        switch(playerTeamID)
        {
            // End:0x3A
            case 255:
            // End:0x75
            case 0:
                HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWC60SecondSoundCue(), 1.0000000);
                // End:0xB3
                break;
            // End:0xB0
            case 1:
                HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWP60SecondSoundCue(), 1.0000000);
                // End:0xB3
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

simulated function Play30SecsSpeech(int playerTeamID, @NULL HUD)
{
    // End:0xB3
    if(((HUD != none) && HUD.mSoundController != none) && mMissionAudio != none)
    {
        switch(playerTeamID)
        {
            // End:0x3A
            case 255:
            // End:0x75
            case 0:
                HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWC30SecondSoundCue(), 1.0000000);
                // End:0xB3
                break;
            // End:0xB0
            case 1:
                HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWP30SecondSoundCue(), 1.0000000);
                // End:0xB3
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

simulated event bool GetObjectiveStrings(int TeamNum, out int TitleHashID, out int TextHashID)
{
    local @NULL Localization;
    local class<Class> gameInfoClass;
    local @NULL AssaultGRI, CoopGRI, WarGRI, obj;
    local int I;

    Localization = Class'TurokEngine.TurokUI'.static.GetEngine().GetLocalization();
    gameInfoClass = WorldInfo.GetGameClass();
    switch(gameInfoClass)
    {
        // End:0x8D
        case Class'TurokDMGame':
            TitleHashID = Localization.HashAHashString(DM_ObjectiveTitle);
            TextHashID = Localization.HashAHashString(DM_ObjectiveText);
            return true;
        // End:0xEC
        case Class'TurokTeamDMGame':
            // DebugMode: 0
            assert((TeamNum == 0) || TeamNum == 1);
            TitleHashID = Localization.HashAHashString(TeamDM_ObjectiveTitle);
            TextHashID = Localization.HashAHashString(TeamDM_ObjectiveText);
            return true;
        // End:0x14B
        case Class'TurokCTFGame':
            // DebugMode: 0
            assert((TeamNum == 0) || TeamNum == 1);
            TitleHashID = Localization.HashAHashString(CTF_ObjectiveTitle);
            TextHashID = Localization.HashAHashString(CTF_ObjectiveText);
            return true;
        // End:0x228
        case Class'TurokAssaultGame':
            // DebugMode: 0
            assert((TeamNum == 0) || TeamNum == 1);
            AssaultGRI = TurokFlagGameReplicationInfo(WorldInfo.GRI);
            // DebugMode: 0
            assert(AssaultGRI != none);
            // End:0x1EA
            if(int(AssaultGRI.mCurrPrimaryTeamIndex) == TeamNum)
            {
                TitleHashID = Localization.HashAHashString(Assault_Defend_ObjectiveTitle);
                TextHashID = Localization.HashAHashString(Assault_Defend_ObjectiveText);                
            }
            else
            {
                TitleHashID = Localization.HashAHashString(Assault_Attack_ObjectiveTitle);
                TextHashID = Localization.HashAHashString(Assault_Attack_ObjectiveText);
            }
            return true;
        // End:0x37A
        case Class'TurokWarGame':
            // DebugMode: 0
            assert((TeamNum == 0) || TeamNum == 1);
            // End:0x293
            if(TeamNum == 0)
            {
                TitleHashID = Localization.HashAHashString(Wargame_Team0_ObjectiveTitle);
                TextHashID = Localization.HashAHashString(Wargame_Team0_ObjectiveText);                
            }
            else
            {
                TitleHashID = Localization.HashAHashString(Wargame_Team1_ObjectiveTitle);
                TextHashID = Localization.HashAHashString(Wargame_Team1_ObjectiveText);
            }
            WarGRI = TurokWarGameReplicationInfo(WorldInfo.GRI);
            I = 0;
            J0x2EF:

            // End:0x378 [Loop If]
            if(I < WarGRI.mIndicatorsNum)
            {
                obj = TurokMPObjectiveIndicator(WarGRI.mIndicators[I]);
                // End:0x36E
                if((obj != none) && int(obj.GetTeamNum()) == TeamNum)
                {
                    TextHashID = obj.GetObjectiveHashID();
                    // [Explicit Break]
                    goto J0x378;
                }
                ++I;
                // [Loop Continue]
                goto J0x2EF;
            }
            J0x378:

            return true;
        // End:0x3F4
        case Class'TurokCoopGame':
            CoopGRI = TurokCoopGameReplicationInfo(WorldInfo.GRI);
            // DebugMode: 0
            assert(CoopGRI != none);
            // End:0x3F2
            if((CoopGRI.GetCurrentCoopGoal() != none) && CoopGRI.GetCurrentCoopGoal().GetObjectiveStrings(TitleHashID, TextHashID))
            {
                return true;
            }
            return false;
        // End:0xFFFF
        default:
            return false;
            break;
    }
    //return ReturnValue;    
}

simulated function CommunicateWinLossInfo(bool GameOver, int playerTeamID, @NULL HUD, @NULL winLossText)
{
    local @NULL GRI, Localization, coopGoal, SpeechCue;
    local string winnerName;
    local byte winnerTeam;
    local int gameHashID;
    local @NULL net, Lobby, LobbyPlayer;

    Localization = Class'TurokEngine.TurokUI'.static.GetEngine().GetLocalization();
    GRI = TurokMPGameReplicationInfo(WorldInfo.GRI);
    // DebugMode: 0
    assert(GRI != none);
    switch(WorldInfo.GetGameClass())
    {
        // End:0x146
        case Class'TurokAssaultGame':
            winnerTeam = GRI.GetWinningTeam();
            // DebugMode: 0
            assert((int(winnerTeam) == 0) || int(winnerTeam) == 1);
            winnerName = GRI.GetLocalizedTeamName(winnerTeam);
            // End:0x112
            if(int(TurokFlagGameReplicationInfo(GRI).mCurrPrimaryTeamIndex) == int(winnerTeam))
            {
                // End:0x108
                if(GameOver)
                {
                    gameHashID = Localization.HashAHashString(Assault_Defend_Name);                    
                }
                else
                {
                    gameHashID = 0;
                }                
            }
            else
            {
                // End:0x13C
                if(GameOver)
                {
                    gameHashID = Localization.HashAHashString(Assault_Attack_Name);                    
                }
                else
                {
                    gameHashID = 0;
                }
            }
            // End:0x3F1
            break;
        // End:0x1C3
        case Class'TurokTeamDMGame':
            winnerTeam = GRI.GetWinningTeam();
            // DebugMode: 0
            assert((int(winnerTeam) == 0) || int(winnerTeam) == 1);
            winnerName = GRI.GetLocalizedTeamName(winnerTeam);
            gameHashID = Localization.HashAHashString(TeamDM_Name);
            // End:0x3F1
            break;
        // End:0x240
        case Class'TurokCoopGame':
            winnerTeam = GRI.GetWinningTeam();
            // DebugMode: 0
            assert((int(winnerTeam) == 0) || int(winnerTeam) == 1);
            winnerName = GRI.GetLocalizedTeamName(winnerTeam);
            gameHashID = Localization.HashAHashString(Coop_Name);
            // End:0x3F1
            break;
        // End:0x2BD
        case Class'TurokCTFGame':
            winnerTeam = GRI.GetWinningTeam();
            // DebugMode: 0
            assert((int(winnerTeam) == 0) || int(winnerTeam) == 1);
            winnerName = GRI.GetLocalizedTeamName(winnerTeam);
            gameHashID = Localization.HashAHashString(CTF_Name);
            // End:0x3F1
            break;
        // End:0x33A
        case Class'TurokWarGame':
            winnerTeam = GRI.GetWinningTeam();
            // DebugMode: 0
            assert((int(winnerTeam) == 0) || int(winnerTeam) == 1);
            winnerName = GRI.GetLocalizedTeamName(winnerTeam);
            gameHashID = Localization.HashAHashString(Wargame_Name);
            // End:0x3F1
            break;
        // End:0x3EE
        case Class'TurokDMGame':
            net = Class'Engine.Engine'.static.GetTurokNet();
            // End:0x3C3
            if(net != none)
            {
                Lobby = net.GetLobby();
                // End:0x3C3
                if((Lobby != none) && Lobby.GetOnlinePlayerByUniqueID(GRI.GetWinningPlayer(), LobbyPlayer))
                {
                    winnerName = LobbyPlayer.NickName;
                }
            }
            gameHashID = Localization.HashAHashString(DM_Name);
            winnerTeam = byte(255);
            // End:0x3F1
            break;
        // End:0xFFFF
        default:
            break;
    }
    winLossText.Set(GRI.GetWinningReason(), GameOver, winnerTeam, winnerName, gameHashID);
    // End:0x611
    if(((GameOver && HUD != none) && HUD.mSoundController != none) && mMissionAudio != none)
    {
        switch(WorldInfo.GetGameClass())
        {
            // End:0x482
            case Class'TurokAssaultGame':
            // End:0x48A
            case Class'TurokTeamDMGame':
            // End:0x492
            case Class'TurokCTFGame':
            // End:0x589
            case Class'TurokWarGame':
                // End:0x518
                if(int(winnerTeam) == 1)
                {
                    // End:0x4E5
                    if(playerTeamID == 0)
                    {
                        HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWCLoseGameSoundCue());                        
                    }
                    else
                    {
                        HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWPWinsGameSoundCue());
                    }                    
                }
                else
                {
                    // End:0x556
                    if(playerTeamID == 0)
                    {
                        HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWCWinsGameSoundCue());                        
                    }
                    else
                    {
                        HUD.mSoundController.PlayQueuedSound(mMissionAudio.GetWPLoseGameSoundCue());
                    }
                }
                // End:0x611
                break;
            // End:0x60E
            case Class'TurokCoopGame':
                coopGoal = TurokCoopGameReplicationInfo(GRI).GetCurrentCoopGoal();
                // End:0x60B
                if(((coopGoal != none) && coopGoal.GetWinLossSpeech(winnerTeam, SpeechCue)) && SpeechCue != none)
                {
                    HUD.mSoundController.PlayQueuedSound(SpeechCue);
                }
                // End:0x611
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

defaultproperties
{
    DM_ObjectiveTitle="M_UnrankedMultiGameName_Deathmatch"
    DM_ObjectiveText="H_MissionDM_Default"
    DM_Name="M_GameTypeDeathMatch"
    TeamDM_ObjectiveTitle="M_UnrankedMultiGameName_TeamDeathmatch"
    TeamDM_ObjectiveText="H_MissionTDM_Default"
    TeamDM_Name="M_GameTypeTeamDeathMatch"
    CTF_ObjectiveTitle="M_UnrankedMultiGameName_CTF"
    CTF_ObjectiveText="H_MissionCTF_Default"
    CTF_Name="M_GameTypeCTF"
    Assault_Attack_ObjectiveTitle="M_UnrankedMultiGameName_AssaultCTF"
    Assault_Attack_ObjectiveText="H_MissionAssault_Assault"
    Assault_Attack_Name="M_GameTypeAssault"
    Assault_Defend_ObjectiveTitle="M_UnrankedMultiGameName_AssaultCTF"
    Assault_Defend_ObjectiveText="H_MissionAssault_Defense"
    Assault_Defend_Name="M_GameTypeAssault"
    Wargame_Team0_ObjectiveTitle="T_ObjectiveHudTitle"
    Wargame_Team0_ObjectiveText="M_None"
    Wargame_Team1_ObjectiveTitle="T_ObjectiveHudTitle"
    Wargame_Team1_ObjectiveText="M_None"
    Wargame_Name="M_GameTypeWar"
    mCanToggleOnWargameObjectiveIndicator=true
    mCanToggleOnWargameObjectiveText=true
    Coop_Name="M_GameTypeCoop"
    bStatic=true
    bHidden=true
    bNoDelete=true
    bMovable=false
    // Reference: SpriteComponent'Default__TurokMPMissionInfo.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'EngineResources.S_Note'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
}