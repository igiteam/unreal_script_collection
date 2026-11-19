class MOHAMultiplayerController extends MOHAPlayerController
    native
    nativereplication
    config(Game)
    hidecategories(Navigation);

const MAX_WEAPON_TYPE_SP = 25;
const MAX_SP_MISSIONS = 7;
const MAX_SP_MEDALS = 6;
const MAX_HUD_NOTIFICATIONS = 8;
const NUM_MP_MAPS = 6;
const NUM_MP_AWARDS = 19;
const NUM_WEAPON_CLASSES = 7;
const MAX_RIVALS = 8;
const NUM_WEAPON_EXP_LEVELS = 3;
const NUM_MP_MEDALS = 15;
const NUM_MP_WEAPON_UPGRADES = 4;
const MAX_MISSION_SKILL_DROPS = 5;
const MAX_UPGRADEABLE_WEAPONS_SP = 16;
const NUM_XBLACH_UPGRADED_WEAPONS = 5;
const NUM_KILL_TIMES_TO_TRACK = 5;
const NUM_CONSECUTIVE_HEADSHOT_XBLACH = 10;
const MAX_DIFFICULTIES = 3;
const MAX_HUD_RENDERMODES = 4;
const MAX_SP_CHEAT_FLAGS = 7;
const WIDESCREEN_ASPECT_RATIO = 1.7777f;
const WIDESCREEN_INVERSE_ASPECT_RATIO = 0.5625f;
const MAX_HEALTH_DROPPED_PICKUPS = 1;
const MAX_HEALTH_DROPPED_PICKUPS_MP = 10;

enum MPTextWindowTypes
{
    MP_TEXT_WINDOW_TYPE_GENERIC,    // 0
    MP_TEXT_WINDOW_TYPE_KILLED_BY,  // 1
    MP_TEXT_WINDOW_TYPE_ARMED,      // 2
    MP_TEXT_WINDOW_TYPE_UNARMED,    // 3
    MP_TEXT_WINDOW_TYPE_AWARD,      // 4
    MP_TEXT_WINDOW_TYPE_MAX         // 5
};

enum MPFlagMessagesEnums
{
    MP_FlagMessage_Neutralizing,    // 0
    MP_FlagMessage_VictimNeutralizing,// 1
    MP_FlagMessage_Contention,      // 2
    MP_FlagMessage_TwoSoldiersRequired,// 3
    MP_FlagMessage_Controlled,      // 4
    MP_FlagMessage_Capturing,       // 5
    MP_FlagMessage_MAX              // 6
};

enum EPlasmaPlayerStats
{
    MPSTAT_RANK_POINTS,             // 0
    MPSTAT_RANK_POINTS_FLOOR,       // 1
    MPSTAT_FINISH_FIRST,            // 2
    MPSTAT_FINISH_SECOND,           // 3
    MPSTAT_FINISH_THIRD,            // 4
    MPSTAT_KILLSTREAK,              // 5
    MPSTAT_DEATHSTREAK,             // 6
    MPSTAT_ACTIVE_NOTKS_STREAK,     // 7
    MPSTAT_AIRBORNE_MELEE_KILLS,    // 8
    MPSTAT_MELEE_DEATHS,            // 9
    MPSTAT_W_GRENADE_THROWN,        // 10
    MPSTAT_W_GRENADE_KILLS,         // 11
    MPSTAT_W_GRENADE_DEATHS,        // 12
    MPSTAT_UNIT_DISTINGUISHED,      // 13
    MPSTAT_UNIT_MERITORIOUS,        // 14
    MPSTAT_EOM_ACCURATE,            // 15
    MPSTAT_EOM_DEADLIEST,           // 16
    MPSTAT_EOM_HEADSHOTS,           // 17
    MPSTAT_EOM_KILLSTREAK,          // 18
    MPSTAT_EOM_OBJECTIVE,           // 19
    MPSTAT_EOM_USELESS,             // 20
    MPSTAT_EOM_DEATHSTREAK,         // 21
    MPSTAT_EOM_SUICIDAL,            // 22
    MPSTAT_EOM_RIFLE,               // 23
    MPSTAT_EOM_SMG,                 // 24
    MPSTAT_EOM_AUTO,                // 25
    MPSTAT_EOM_SNIPER,              // 26
    MPSTAT_EOM_ATANK,               // 27
    MPSTAT_GAME_TIME,               // 28
    MPSTAT_GAME_GAMES,              // 29
    MPSTAT_GAME_WINS,               // 30
    MPSTAT_GAME_LOSSES,             // 31
    MPSTAT_GAME_SCORE,              // 32
    MPSTAT_GAME_HIGHSCORE,          // 33
    MPSTAT_GAME_OBJPTS,             // 34
    MPSTAT_GAME_TEAMPTS,            // 35
    MPSTAT_GAME_KILLS,              // 36
    MPSTAT_GAME_DEATHS,             // 37
    MPSTAT_GAME_SUICIDES,           // 38
    MPSTAT_GAME_TEAMKILLS,          // 39
    MPSTAT_GAME_KILLASST,           // 40
    MPSTAT_GAME_BESTRANK,           // 41
    MPSTAT_MAX                      // 42
};

enum EPlasmaWeaponStats
{
    MPWSTAT_TIME,                   // 0
    MPWSTAT_HITS,                   // 1
    MPWSTAT_SHOTS,                  // 2
    MPWSTAT_KILLS,                  // 3
    MPWSTAT_MELEE_KILLS,            // 4
    MPWSTAT_DEATHS,                 // 5
    MPWSTAT_MELEE_DEATHS,           // 6
    MPWSTAT_HITS_HEAD,              // 7
    MPWSTAT_HITS_RARM,              // 8
    MPWSTAT_HITS_LARM,              // 9
    MPWSTAT_HITS_TORSO,             // 10
    MPWSTAT_HITS_CROTCH,            // 11
    MPWSTAT_HITS_LLEG,              // 12
    MPWSTAT_HITS_RLEG,              // 13
    MPWSTAT_MAX                     // 14
};

enum ESpawnType
{
    SPAWN_IN_AIR,                   // 0
    SPAWN_ON_GROUND,                // 1
    SPAWN_TYPE_NOT_SET,             // 2
    SPAWN_MAX                       // 3
};

struct native transient ClaimHitInfo
{
    var init Vector ShooteeLocation;
    var init int ShooteeID;
    var init int ShooteeBoneID;

    structdefaultproperties
    {
        ShooteeLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        ShooteeID=0
        ShooteeBoneID=0
    }
};

struct native sPopupInfo
{
    var string PlayerName;
    var MOHAMultiplayerGameInfo.E_MPSTATS_MEDAL_AWARDS AwardType;
    var Texture2D Image;
    var float Timer;
    var SoundCue Sound;

    structdefaultproperties
    {
        PlayerName=""
        AwardType=0
        Image=none
        Timer=0.0000000
        Sound=none
    }
};

var array<sPopupInfo> m_Popups;
var config array<config Color> MessageColor;
var config int MessageLifeTime;
var config int MessageFadeTime;
var config float BlackFadeInDelay;
var config float BlackFadeInTime;
var config float BlackPlaneFadeInDelay;
var(Game) config float LookThroughStartSpotNotAirborne;
var(Game) config float LookThroughStartSpotTimeAxis;
var(Game) config float LookThroughStartSpotTimeAllied;
var config float CinematicAdditionalWaitTime;
var config int m_MaxPopupTimer;
var config bool EnablePushToTalk;
var bool m_bJumpedEventFired;
var bool bTeamSelected;
var bool bHasSetDesiredPawn;
var bool m_bInWaitingState;
var bool m_bLevelLoaded;
var bool bHasInitiallySpawned;
var export editinline AudioComponent MedalAudioComponent;
var MPPlayerStats m_MPPlayerStats;
var int m_iLowestHealthThisLife;
var MPObjective m_ObjectiveInFocus;
var MPObjective m_ObjectiveInUse;
var float m_iObjectiveTimer;
var int m_iCinematicActorIndex;
var int m_iCinematicActorMeshIndex;
var class<MOHAPawn> m_DesiredPawnClass;
var MOHAIncludeClass.EWeaponSelection m_DesiredWeapon;
var MOHAIncludeClass.EWeaponType m_ePrimaryWeaponType;
var MOHAIncludeClass.EWeaponType m_eSecondaryWeaponType;
var const MOHAPlayerReplicationInfo.EMPWeapons MPWeaponIndexes[25];
var MOHAMultiplayerController.ESpawnType SpawnType;
var array<MultiplayerCinematicActor> CinematicITPActors;
var UIScene WeaponSelectScene;
var UIScene TeamSelectScene;
var UIScene TeamSelectConsoleScene;
var name ChangeTeamTag;
var name ChangeTeamConsoleTag;
var name ChangeWeaponTag;
var int m_iCurrentAmmoCount;
var int m_iReserveAmmoCount;
var float m_fTimeToRespawn;
var int m_iCachedTimeToRespawn;
var float m_GrenadeThrowStrength;
var transient bool m_bDisplayedRespawnTimer;
var transient bool bShouldUseStartSpot;
var transient bool bOverPlaneSpawnLimit;
var int m_PreGameTimer;
var const localized string ActivateObjectiveMsg;
var const localized string WaitingForPlayersMessage;
var const localized string WaitingForRedeployMessage;
var const localized string MessageRedeployBlocked;
var const localized string MessageCanNotSwitchTeams;
var const localized string MessageKillAssistReceived;
var const localized string MessageDeserted;
var const localized string MessageSuicide;
var const localized string MessageKilled;
var const localized string MessageKilledBySniper;
var const localized string MessageKilledByGrenade;
var const localized string MessageKilledByAntiTank;
var const localized string MessageKilledBySMG;
var const localized string MessageKilledByFallDamage;
var const localized string MessageKilledByRifle;
var const localized string MessageKilledByAutoRifle;
var const localized string MessageKilledByMelee;
var const localized string MessageKilledByPistolMelee;
var const localized string MessageKilledByInAirMelee;
var const localized string MessageKilledByPistolInAir;
var const localized string MessageKilledBySniperInAir;
var const localized string MessageKilledByGrenadeInAir;
var const localized string MessageKilledByAntiTankInAir;
var const localized string MessageKilledBySMGInAir;
var const localized string MessageKilledByPistolMeleeInAir;
var const localized string MessageKilledByMeleeInAir;
var const localized string MessageKilledByAutoRifleInAir;
var const localized string MessageKilledByRifleInAir;
var const localized string MessageTeamKilled;
var const localized string SuddenDeathMessage;
var const localized string TimeRunningOutMessage;
var const localized string MessagesForFlags[6];
var SoundRiotMixSelect DeathSoundMixSelect;
var SoundCue MPDeathSoundCue_Allied;
var SoundCue MPDeathSoundCue_Axis;
var SoundRiotMixSelect RoundOverMixSelect;
var MOHAMultiplayerPawn KillerPawn;
var transient MOHAMultiplayerPawn CachedPawnForKillerPawn;
var const localized string MOHAVoiceChatStrings[25];
var const localized string MOHAVoiceTeamString;
var const float SanityValueForDistanceOnHurtRadius;
var const PlasmaSingleStatUpdate MPPlayerStats[EPlasmaPlayerStats];
var const PlasmaSingleStatUpdate MPWeaponStats[EPlasmaWeaponStats];
var const PlasmaSingleStatUpdate MPWeaponClassStat;
var const string WeaponNames[12];
var const string WeaponClassNames[9];
var const string ModeAbbr[3];
var const string TeamNames[2];
var const string MapAbbr[6];
var const array<int> ScoreDelta;
var const array<float> LossFactor;
var const array<float> WinFactor;
var const array<int> RankThresholds;
var MOHAWhizManager ClientWhizManager;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetDirty
        m_ePrimaryWeaponType, m_eSecondaryWeaponType, 
        m_fTimeToRespawn, m_iCurrentAmmoCount, 
        m_iReserveAmmoCount;
}

// Export UMOHAMultiplayerController::execAreUniqueNetIdsEqual(FFrame&, void* const)
native function bool AreUniqueNetIdsEqual(UniqueNetId FirstNetId, UniqueNetId SecondNetId);

// Export UMOHAMultiplayerController::execSetUniqueNetIdFromPlayer(FFrame&, void* const)
native function SetUniqueNetIdFromPlayer();

event bool NotifyConnectionLost(optional string Reason = "")
{
    local MOHAUIInteraction UI;
    local WorldInfo WI;
    local Plasma P;
    local int I;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
    // End:0x323
    if(((!P.VoluntaryQuit && !P.InviteAccepted) && MOHAGameReplicationInfo(WI.GRI).RoundStatus != 2) && P.GetGame() != none)
    {
        UI = MOHAUIInteraction(GetUIController());
        // End:0x323
        if(UI.GetStateName() != 'ConnectionLostAlert')
        {
            // End:0x2A4
            if(P.GetGame() != none)
            {
                I = 0;
                J0xE9:

                // End:0x2A4 [Loop If]
                if(I < WI.GRI.PRIArray.Length)
                {
                    // End:0x29A
                    if(AreUniqueNetIdsEqual(WI.GRI.PRIArray[I].UniqueId, P.HostId))
                    {
                        WI.GRI.PRIArray[I].Score -= float(2);
                        WI.GRI.PRIArray[I].Deaths += float(1);
                        MOHAPlayerReplicationInfo(WI.GRI.PRIArray[I]).m_iTeamPoints -= 2;
                        MOHAPlayerReplicationInfo(WI.GRI.PRIArray[I]).MP_Suicides += 1;
                        WI.GRI.PRIArray[I].bIsInactive = true;
                        WI.GRI.InactivePRIArray.AddItem(WI.GRI.PRIArray[I]);
                        WI.GRI.RemovePRI(WI.GRI.PRIArray[I]);
                        // [Explicit Break]
                        goto J0x2A4;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0xE9;
                }
            }
            J0x2A4:

            // End:0x2E7
            if(Len(Reason) > 0)
            {
                UI.OpenAlert(UI.ConnectionLostTitle, Reason, 2, 'ConnectionLostAlert');                
            }
            else
            {
                UI.OpenAlert(UI.ConnectionLostTitle, P.InGameStatusString, 2, 'ConnectionLostAlert');
            }
        }
    }
    return true;
    //return ReturnValue;    
}

// Export UMOHAMultiplayerController::execClaimToImpact(FFrame&, void* const)
native function ClaimToImpact(const out ClaimHitInfo Claim, out ImpactInfo Impact);

// Export UMOHAMultiplayerController::execCheckandActivateSoundSpace(FFrame&, void* const)
native final function CheckandActivateSoundSpace(Pawn P);

simulated function float GetFireAxis()
{
    // End:0x2C
    if((PlayerInput == none) || !PlayerInput.IsA('MOHAPlayerInput'))
    {
        return 1.0000000;
    }
    return ((!bFireTriggeredByMouse) ? MOHAPlayerInput(PlayerInput).RawFireDown : 1.0000000);
    //return ReturnValue;    
}

reliable client simulated function StartDeathSound()
{
    // End:0x5F
    if(IsLocalPlayerController())
    {
        DeathSoundMixSelect.Activate();
        // End:0x50
        if(MOHAPlayerReplicationInfo(PlayerReplicationInfo).Team.TeamIndex == 1)
        {
            ClientPlaySound(MPDeathSoundCue_Axis);            
        }
        else
        {
            ClientPlaySound(MPDeathSoundCue_Allied);
        }
    }
    //return;    
}

reliable client simulated function EndDeathSound()
{
    DeathSoundMixSelect.DeActivate();
    //return;    
}

reliable client simulated function StartRoundOverSound()
{
    RoundOverMixSelect.Activate();
    //return;    
}

reliable client simulated function EndRoundOverSound()
{
    RoundOverMixSelect.DeActivate();
    //return;    
}

reliable client simulated function ClientStartDyingFull()
{
    // End:0x28
    if(PostProcessComponent.DoubleVisionEffect == none)
    {
        PostProcessComponent.Init(self);
    }
    PostProcessComponent.Reset();
    PostProcessComponent.startDyingFull();
    //return;    
}

reliable client simulated event PlasmaGameManagerPlayer GetPlasmaPlayer()
{
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    return P.GetGame().GetLocalPlayer();
    //return ReturnValue;    
}

reliable client simulated function ClientSetKillerPawnFromPlayerID(int InPlayerID)
{
    local MOHAMultiplayerPawn P;

    // End:0x4E
    foreach WorldInfo.AllPawns(Class'MOHAMultiplayerPawn', P)
    {
        // End:0x4D
        if(P.PlayerReplicationInfo.PlayerID == InPlayerID)
        {
            KillerPawn = P;            
            return;
        }        
    }    
    //return;    
}

reliable client simulated function ClientSetKillerPawn(MOHAMultiplayerPawn inKillerPawn)
{
    KillerPawn = inKillerPawn;
    //return;    
}

simulated function SetGrenadeThrowStrength(float ThrowStrength)
{
    m_GrenadeThrowStrength = ThrowStrength;
    //return;    
}

reliable client simulated function ClientServerKicked(bool bTeamKillKick, optional string Reason)
{
    local Plasma P;
    local MOHAUIInteraction UI;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    P.VoluntaryQuit = true;
    P.GetGame().LeaveGame();
    MOHAGameReplicationInfo(WorldInfo.GRI).RoundStatus = 2;
    UI = MOHAUIInteraction(GetUIController());
    // End:0xDC
    if(UI.GetStateName() != 'ConnectionLostAlert')
    {
        UI.OpenAlert(UI.KickedFromGameTitle, Reason, 2, 'ConnectionLostAlert');
        P.CancelInvite();
    }
    //return;    
}

reliable client simulated event TeamReplicated()
{
    ClientOpenWeaponMenu();
    //return;    
}

function PlasmaKick()
{
    local Plasma P;
    local PlasmaGameManagerHostedPlayer hostedPlayer;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    hostedPlayer = (((P != none) && P.GetHostedGame() != none) ? P.GetHostedGame().GetHostedPlayerByUserId(PlayerReplicationInfo.UniqueId) : none);
    // End:0x97
    if(hostedPlayer != none)
    {
        hostedPlayer.Kick(4);
    }
    //return;    
}

function SchedulePlasmaKick()
{
    SetTimer(2.0000000, false, 'PlasmaKick');
    //return;    
}

function HandleServerRestart()
{
    Pawn.Destroy();
    GotoState('DeadWaitingForRespawn');
    ClientResetClientsGameTime();
    ClientBlackOut();
    m_MPPlayerStats.ResetStatsPerMatch();
    MOHAPlayerReplicationInfo(PlayerReplicationInfo).ClearStatsForServerRestart();
    //return;    
}

reliable client simulated function ClientResetClientsGameTime()
{
    MOHAGameReplicationInfo(WorldInfo.GRI).ResetRoundStartTime();
    //return;    
}

reliable client simulated function ClientSetStatLifeTimeValues(StatsLifeTime inStatsLifeTime, byte in_m_MedalsAwardedArray[19], int Position, int winningTeamIndex, int RankScore)
{
    local int I;
    local Plasma P;
    local bool bIsThisRankedGame;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    bIsThisRankedGame = P.isRanked();
    MOHAPlayerReplicationInfo(PlayerReplicationInfo).m_bInRankedGame = bIsThisRankedGame;
    MOHAPlayerReplicationInfo(PlayerReplicationInfo).m_oStatsLifeTime = inStatsLifeTime;
    I = 0;
    J0x6E:

    // End:0xF6 [Loop If]
    if(I < 6)
    {
        MOHAPlayerReplicationInfo(PlayerReplicationInfo).m_oStatsLifeTime.MapProgress[I] = inStatsLifeTime.MapProgress[I];
        MOHAPlayerReplicationInfo(PlayerReplicationInfo).m_oStatsLifeTime.MapFirstPlace[I] = inStatsLifeTime.MapFirstPlace[I];
        I++;
        // [Loop Continue]
        goto J0x6E;
    }
    I = 0;
    J0xFD:

    // End:0x138 [Loop If]
    if(I < 19)
    {
        MOHAPlayerReplicationInfo(PlayerReplicationInfo).m_MedalsAwardedArray[I] = in_m_MedalsAwardedArray[I];
        I++;
        // [Loop Continue]
        goto J0xFD;
    }
    m_MPPlayerStats.UpdatePlasmaWithLifeTimeStats(Position, winningTeamIndex, RankScore);
    //return;    
}

reliable server function ServerSetStatLifeTimeValues(StatsLifeTime inStatsLifeTime, byte in_m_MedalsAwardedArray[19])
{
    local int I;
    local Plasma P;
    local bool bIsThisRankedGame;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    bIsThisRankedGame = P.isRanked();
    MOHAPlayerReplicationInfo(PlayerReplicationInfo).m_bInRankedGame = bIsThisRankedGame;
    MOHAPlayerReplicationInfo(PlayerReplicationInfo).m_oStatsLifeTime = inStatsLifeTime;
    I = 0;
    J0x6E:

    // End:0xF6 [Loop If]
    if(I < 6)
    {
        MOHAPlayerReplicationInfo(PlayerReplicationInfo).m_oStatsLifeTime.MapProgress[I] = inStatsLifeTime.MapProgress[I];
        MOHAPlayerReplicationInfo(PlayerReplicationInfo).m_oStatsLifeTime.MapFirstPlace[I] = inStatsLifeTime.MapFirstPlace[I];
        I++;
        // [Loop Continue]
        goto J0x6E;
    }
    I = 0;
    J0xFD:

    // End:0x138 [Loop If]
    if(I < 19)
    {
        MOHAPlayerReplicationInfo(PlayerReplicationInfo).m_MedalsAwardedArray[I] = in_m_MedalsAwardedArray[I];
        I++;
        // [Loop Continue]
        goto J0xFD;
    }
    I = 0;
    J0x13F:

    // End:0x16E [Loop If]
    if(I <= 8)
    {
        m_MPPlayerStats.CheckAndSetForWeaponUpgrade(I, true);
        I++;
        // [Loop Continue]
        goto J0x13F;
    }
    //return;    
}

simulated event Class WeaponTypeToMPClass(MOHAIncludeClass.EWeaponType EWeaponType)
{
    return none;
    //return ReturnValue;    
}

function bool PlayerCanSwitchWeapons()
{
    // End:0x32
    if((MOHAHUD_MP(myHUD) != none) && MOHAHUD_MP(myHUD).VoiceChatMenuOpen() == true)
    {
        return false;
    }
    return super.PlayerCanSwitchWeapons();
    //return ReturnValue;    
}

function InitPlayerReplicationInfo()
{
    local Plasma P;

    super(Controller).InitPlayerReplicationInfo();
    // End:0xC5
    if(IsLocalPlayerController())
    {
        P = Class'Plasma.Plasma'.static.GetPlasma();
        // End:0xC5
        if(P != none)
        {
            PlayerReplicationInfo.UniqueId = P.GetGame().GetLocalPlayer().GetUserId();
            PlayerReplicationInfo.SetPlayerName(P.GetGame().GetPlayerByUserId(PlayerReplicationInfo.UniqueId).GetName());
        }
    }
    //return;    
}

event InitUniquePlayerId()
{
    local UniqueNetId oldNetId;
    local Plasma P;

    oldNetId = PlayerReplicationInfo.UniqueId;
    super(PlayerController).InitUniquePlayerId();
    // End:0x3C
    if(!AreUniqueNetIdsEqual(PlayerReplicationInfo.UniqueId, oldNetId))
    {
    }
    m_MPPlayerStats.GetLifetimeStats();
    // End:0x104
    if(IsLocalPlayerController())
    {
        P = Class'Plasma.Plasma'.static.GetPlasma();
        // End:0x104
        if(P != none)
        {
            PlayerReplicationInfo.SetPlayerName(P.GetGame().GetPlayerByUserId(PlayerReplicationInfo.UniqueId).GetName());
            MOHAMultiplayerGameInfo(WorldInfo.Game).Voip.PlayerJoins(MOHAPlayerReplicationInfo(PlayerReplicationInfo));
        }
    }
    //return;    
}

reliable server function ServerSetUniquePlayerId(UniqueNetId UniqueId, bool bWasInvited)
{
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x3B
    if(!AreUniqueNetIdsEqual(PlayerReplicationInfo.UniqueId, UniqueId))
    {
    }
    super(PlayerController).ServerSetUniquePlayerId(UniqueId, bWasInvited);
    // End:0xD2
    if(P != none)
    {
        PlayerReplicationInfo.SetPlayerName(P.GetGame().GetPlayerByUserId(UniqueId).GetName());
        MOHAMultiplayerGameInfo(WorldInfo.Game).Voip.PlayerJoins(MOHAPlayerReplicationInfo(PlayerReplicationInfo));
    }
    //return;    
}

reliable server event ServerSetDesiredPawnClass(MOHAIncludeClass.EWeaponSelection DesiredNextSpawnWeapon)
{
    m_DesiredWeapon = DesiredNextSpawnWeapon;
    //return;    
}

reliable client simulated function ShowPopup(MOHAMultiplayerGameInfo.E_MPSTATS_MEDAL_AWARDS AwardType, string PlayerName, Texture2D Image, optional SoundCue Sound)
{
    local sPopupInfo PopUp;

    PopUp.PlayerName = PlayerName;
    PopUp.AwardType = AwardType;
    PopUp.Image = Image;
    PopUp.Timer = 0.0000000;
    PopUp.Sound = Sound;
    m_Popups[m_Popups.Length] = PopUp;
    // End:0xCF
    if(m_Popups.Length == 1)
    {
        ServerSendTeamClientAwardMessage(m_Popups[0].AwardType, m_Popups[0].PlayerName);
        PlayMedalAudio(m_Popups[0].Sound);
    }
    //return;    
}

simulated function UpdatePopup(float DeltaTime)
{
    // End:0x9C
    if(m_Popups.Length > 0)
    {
        m_Popups[0].Timer += DeltaTime;
        // End:0x9C
        if(m_Popups[0].Timer > float(m_MaxPopupTimer))
        {
            m_Popups.Remove(0, 1);
            // End:0x9C
            if(m_Popups.Length > 0)
            {
                ServerSendTeamClientAwardMessage(m_Popups[0].AwardType, m_Popups[0].PlayerName);
                PlayMedalAudio(m_Popups[0].Sound);
            }
        }
    }
    //return;    
}

simulated function PlayMedalAudio(SoundCue Sound)
{
    // End:0x11
    if(!IsLocalPlayerController())
    {
        return;
    }
    // End:0x4A
    if(Sound != none)
    {
        // End:0x4A
        if(MedalAudioComponent != none)
        {
            MedalAudioComponent.SoundCue = Sound;
            MedalAudioComponent.Play();
        }
    }
    //return;    
}

simulated function ImpactToClaim(const out ImpactInfo Impact, out ClaimHitInfo Claim)
{
    local MOHAMultiplayerPawn MPHitActor;

    Claim.ShooteeLocation = Impact.HitActor.Location;
    MPHitActor = MOHAMultiplayerPawn(Impact.HitActor);
    // End:0x4F
    if(MPHitActor == none)
    {
        return;
    }
    Claim.ShooteeID = MPHitActor.PlayerID;
    Claim.ShooteeBoneID = MPHitActor.Mesh.MatchRefBone(Impact.HitInfo.BoneName);
    //return;    
}

reliable server function ServerClaimInstantHit(ClaimHitInfo Hit)
{
    local EALASmallArms Arms;
    local MOHAMultiplayerPawn MPPawn, HitMPPawn;
    local ImpactInfo Impact;
    local bool bAddHitStat;

    Arms = EALASmallArms(Pawn.Weapon);
    ClaimToImpact(Hit, Impact);
    MPPawn = MOHAMultiplayerPawn(Pawn);
    // End:0x13E
    if((MPPawn != none) && Impact.HitActor != none)
    {
        HitMPPawn = MOHAMultiplayerPawn(Impact.HitActor);
        bAddHitStat = ((HitMPPawn != none) && MOHAPlayerReplicationInfo(PlayerReplicationInfo).Team.TeamIndex != HitMPPawn.GetTeamIndex()) && !HitMPPawn.IsInState('Dying');
        Arms.ApplyDamage(Pawn.Weapon.CurrentFireMode, Impact);
        // End:0x13E
        if(bAddHitStat)
        {
            m_MPPlayerStats.StatAddHitLocation(HitMPPawn.m_oHealthInfo.LastHitLocation);
        }
    }
    //return;    
}

reliable server function ServerSendTeamClientAwardMessage(MOHAMultiplayerGameInfo.E_MPSTATS_MEDAL_AWARDS AwardType, coerce string PlayerName)
{
    local MOHAMultiplayerController P;

    // End:0x76
    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', P)
    {
        // End:0x75
        if(P.PlayerReplicationInfo.Team.TeamIndex == PlayerReplicationInfo.Team.TeamIndex)
        {
            P.ClientAwardMessage(AwardType, PlayerName);
        }        
    }    
    //return;    
}

reliable server function ServerSendTeamClientMessage(coerce string S, optional name Type, optional float MsgLifeTime)
{
    local MOHAMultiplayerController P;

    // End:0x7D
    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', P)
    {
        // End:0x7C
        if(P.PlayerReplicationInfo.Team.TeamIndex == PlayerReplicationInfo.Team.TeamIndex)
        {
            P.ClientMessage(S, Type, MsgLifeTime);
        }        
    }    
    //return;    
}

reliable server function ServerSendMOHAVoiceChatMessage(int commandIndex, SoundCue Sound, bool bTeamOnly)
{
    local MOHAMultiplayerController P;

    // End:0x9C
    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', P)
    {
        // End:0x9B
        if(!bTeamOnly || P.PlayerReplicationInfo.Team.TeamIndex == PlayerReplicationInfo.Team.TeamIndex)
        {
            P.ClientMOHAVoiceChatMessage(commandIndex, MOHAPlayerReplicationInfo(PlayerReplicationInfo).PlayerName, Sound, bTeamOnly);
        }        
    }    
    //return;    
}

function SetPendingAdjustment()
{
    local MOHAPawn MOHAPawn;
    local editinline MOHAAirdropComponent AirdropComponent;
    local Rotator AngularVelocity;

    MOHAPawn = MOHAPawn(Pawn);
    // End:0x1AC
    if(int(MOHAPawn.Physics) == int(11))
    {
        AirdropComponent = MOHAPawn.AirdropComponent;
        PendingAdjustment.newPhysics = Pawn.Physics;
        PendingAdjustment.NewVel = (AirdropComponent.AirdropCurrentPendulumPosition - AirdropComponent.AirdropLastPendulumPosition) / AirdropComponent.AirdropLastDeltaTime;
        PendingAdjustment.NewLoc = Pawn.Location;
        PendingAdjustment.NewFloorPitch = Rotator(AirdropComponent.AirdropCurrentPendulumNormal).Pitch;
        PendingAdjustment.NewFloorYaw = Rotator(AirdropComponent.AirdropCurrentPendulumNormal).Yaw;
        AngularVelocity = Normalize(Rotator(AirdropComponent.AirdropCurrentPlayerLocalPosition >> rot(16384, 0, 0)) - Rotator(AirdropComponent.AirdropCurrentPlayerPreviousLocalPosition >> rot(16384, 0, 0))) / AirdropComponent.AirdropLastDeltaTime;
        PendingAdjustment.NewAngularPitchVel = AngularVelocity.Pitch;
        PendingAdjustment.NewAngularYawVel = AngularVelocity.Yaw;        
    }
    else
    {
        super(PlayerController).SetPendingAdjustment();
    }
    //return;    
}

unreliable client simulated function ClientAdjustPosition(bool bGoodMove, float TimeStamp, name NewState, Actor.EPhysics newPhysics, Vector NewLocation, Vector NewVelocity, optional int NewFloorPitch, optional int NewFloorYaw, optional int NewAngularPitchVel, optional int NewAngularYawVel)
{
    local Vector NewParachuteNormal, NewParachuteVelocity, PrevFloor, PrevVelocity;
    local MOHAPawn MOHAPawn;
    local editinline MOHAAirdropComponent AirdropComponent;
    local Vector NewFloor;
    local Rotator newAngularVel, previousNormal;

    // End:0x1E
    if(bGoodMove)
    {
        AckGoodMove(TimeStamp);
        return;
    }
    // End:0x5A
    if(((Pawn != none) && NewFloorPitch == 0) && NewFloorYaw == 0)
    {
        NewFloor = Pawn.Floor;        
    }
    else
    {
        NewFloor = Vector((rot(1, 0, 0) * float(NewFloorPitch)) + (rot(0, 1, 0) * float(NewFloorYaw)));
    }
    // End:0xC6
    if(Pawn != none)
    {
        PrevFloor = Pawn.Floor;
        PrevVelocity = Pawn.Velocity;
    }
    // End:0x2FC
    if(NewState != GetStateName())
    {
        // End:0x159
        if(NewState == 'AirDropLanding')
        {
            // End:0x116
            if((GetStateName() == 'PlayerWalking') || GetStateName() == 'AirDropLanded')
            {
                NewState = GetStateName();                
            }
            else
            {
                GotoState('AirDropLanding');
                // End:0x156
                if(!Pawn.IsInState('AirDropLanding'))
                {
                    Pawn.GotoState('AirDropLanding');
                }
            }            
        }
        else
        {
            // End:0x1E9
            if(NewState == 'Airdrop')
            {
                GotoState('Airdrop');
                // End:0x1E6
                if((!Pawn.IsInState('AirDropControlledFall') && !Pawn.IsInState('AirDropControlledFlare')) && !Pawn.IsInState('AirDropDeployChute'))
                {
                    Pawn.GotoState('AirDropControlledFall');
                }                
            }
            else
            {
                // End:0x279
                if(NewState == 'AirDropDeployChute')
                {
                    GotoState('AirDropDeployChute');
                    // End:0x276
                    if((!Pawn.IsInState('AirDropControlledFall') && !Pawn.IsInState('AirDropControlledFlare')) && !Pawn.IsInState('AirDropDeployChute'))
                    {
                        Pawn.GotoState('AirDropDeployChute');
                    }                    
                }
                else
                {
                    // End:0x2FC
                    if(NewState == 'AirDropLanded')
                    {
                        // End:0x2BC
                        if((GetStateName() == 'PlayerWalking') || GetStateName() == 'AirDropLanded')
                        {
                            NewState = GetStateName();                            
                        }
                        else
                        {
                            GotoState('AirDropLanded');
                            // End:0x2FC
                            if(!Pawn.IsInState('AirDropLanded'))
                            {
                                Pawn.GotoState('AirDropLanded');
                            }
                        }
                    }
                }
            }
        }
    }
    // End:0x3B6
    if((Pawn != none) && int(newPhysics) != int(Pawn.Physics))
    {
        // End:0x3B6
        if((int(newPhysics) == int(1)) && int(Pawn.Physics) == int(2))
        {
            // End:0x3B6
            if((Pawn.IsInState('JumpStart') || Pawn.IsInState('JumpIdle')) || Pawn.IsInState('JumpEnd'))
            {
                Pawn.GotoState('Idle');
            }
        }
    }
    // End:0x3F2
    if(int(newPhysics) == int(11))
    {
        NewParachuteNormal = NewFloor;
        NewFloor = PrevFloor;
        NewParachuteVelocity = NewVelocity;
        NewVelocity = PrevVelocity;
    }
    super(PlayerController).ClientAdjustPosition(bGoodMove, TimeStamp, NewState, newPhysics, NewLocation, NewVelocity, NewFloorPitch, NewFloorYaw, NewAngularPitchVel, NewAngularYawVel);
    // End:0x5AF
    if(int(newPhysics) == int(11))
    {
        MOHAPawn = MOHAPawn(Pawn);
        AirdropComponent = MOHAPawn.AirdropComponent;
        AirdropComponent.AirdropCurrentPendulumNormal = NewParachuteNormal;
        AirdropComponent.AirdropCurrentPendulumPosition = MOHAPawn.Location + (NewParachuteNormal * AirdropComponent.AirdropCurrentPendulumLength);
        AirdropComponent.AirdropLastPendulumPosition = AirdropComponent.AirdropCurrentPendulumPosition + (-NewParachuteVelocity * AirdropComponent.AirdropLastDeltaTime);
        AirdropComponent.AirdropCurrentPlayerLocalPosition = -NewParachuteNormal * AirdropComponent.AirdropCurrentPendulumLength;
        newAngularVel = (rot(1, 0, 0) * float(NewAngularPitchVel)) + (rot(0, 1, 0) * float(NewAngularYawVel));
        previousNormal = Rotator(AirdropComponent.AirdropCurrentPlayerLocalPosition >> rot(16384, 0, 0)) - (newAngularVel * AirdropComponent.AirdropLastDeltaTime);
        AirdropComponent.AirdropCurrentPlayerPreviousLocalPosition = (Vector(previousNormal) >> rot(-16384, 0, 0)) * AirdropComponent.AirdropCurrentPendulumLength;
    }
    //return;    
}

simulated function CreatePlayerStats()
{
    m_MPPlayerStats = new Class'MPPlayerStats';
    m_MPPlayerStats.SetOwnerController(self);
    m_MPPlayerStats.Init();
    MedalAudioComponent = WorldInfo.CreateAudioComponent(m_MPPlayerStats.MedalAudio[0], false, false);
    AttachComponent(MedalAudioComponent);
    //return;    
}

exec function VoicePress()
{
    local PlasmaGameManagerGame G;

    // End:0x5E
    if(EnablePushToTalk && IsLocalPlayerController())
    {
        G = Class'Plasma.Plasma'.static.GetPlasma().GetGame();
        // End:0x5E
        if(G != none)
        {
            G.SetSendingVoiceEnabled(true);
        }
    }
    //return;    
}

exec function VoiceRelease()
{
    local PlasmaGameManagerGame G;

    // End:0x5E
    if(EnablePushToTalk && IsLocalPlayerController())
    {
        G = Class'Plasma.Plasma'.static.GetPlasma().GetGame();
        // End:0x5E
        if(G != none)
        {
            G.SetSendingVoiceEnabled(false);
        }
    }
    //return;    
}

exec function TypeInConsole(string What)
{
    // End:0x44
    if(LocalPlayer(Player) != none)
    {
        LocalPlayer(Player).ViewportClient.ViewportConsole.StartTyping(What $ " ");
    }
    //return;    
}

reliable client simulated function ClientFadeIn(float fDelay, float fFadeTime)
{
    PostProcessComponent.Reset();
    MOHAHUD_MP(myHUD).FadeIn(fDelay, fFadeTime);
    MOHAHUD_MP(myHUD).SetBlack(false);
    //return;    
}

reliable client simulated function ClientBlackOut()
{
    MOHAHUD_MP(myHUD).FadeOut(0.0000000, 0.0000000);
    MOHAHUD_MP(myHUD).SetBlack(true);
    //return;    
}

reliable server function ServerPreReStartPlayer()
{
    local float fLookThroughStartSpotTime;

    // End:0x1B
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        return;
    }
    fLookThroughStartSpotTime = 1.5000000;
    // End:0x95
    if((WorldInfo.Game != none) && WorldInfo.Game.IsA('AirborneTeamGameInfo'))
    {
        // End:0x87
        if(PlayerReplicationInfo.Team.TeamIndex == 0)
        {
            fLookThroughStartSpotTime = LookThroughStartSpotTimeAllied;            
        }
        else
        {
            fLookThroughStartSpotTime = LookThroughStartSpotTimeAxis;
        }        
    }
    else
    {
        fLookThroughStartSpotTime = LookThroughStartSpotNotAirborne;
    }
    m_fTimeToRespawn = fLookThroughStartSpotTime;
    SetTimer(fLookThroughStartSpotTime, false, 'ServerRestartPlayer');
    GotoState('DeadRespawning');
    // End:0xED
    if(bShouldUseStartSpot == false)
    {
        ClientFadeIn(0.2500000, 0.2500000);
    }
    ClientKillAndPurgeScoreBoard();
    MOHAMultiplayerGameInfo(WorldInfo.Game).PreRestartPlayer(self);
    //return;    
}

reliable server function ServerPreReStartPlayerAndWait()
{
    // End:0x1B
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        return;
    }
    ClientStartDyingFull();
    ClientKillAndPurgeScoreBoard();
    ClientFadeIn(0.2500000, 0.2500000);
    MOHAMultiplayerGameInfo(WorldInfo.Game).PreRestartPlayer(self);
    //return;    
}

reliable server function ServerResetRestartAtttempt()
{
    ClientShowRedeployBlockedMessage();
    bShouldUseStartSpot = false;
    MOHATeamPlayerStart(StartSpot).bUsedAsStartPoint = false;
    ServerPreReStartPlayer();
    //return;    
}

function Reset()
{
    super(PlayerController).Reset();
    // End:0x1F
    if(!bHasSetDesiredPawn)
    {
        GotoState('WeaponSelect');
    }
    //return;    
}

private final simulated function MOHAIncludeClass.MilitaryRank GetRankStat()
{
    local Plasma P;
    local float Rank;
    local int I;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    Rank = P.GetStatValue("RANK_POINTS");
    I = 0;
    J0x46:

    // End:0x7F [Loop If]
    if(I < RankThresholds.Length)
    {
        // End:0x75
        if(Rank < float(RankThresholds[I]))
        {
            return byte(I);
        }
        I++;
        // [Loop Continue]
        goto J0x46;
    }
    return 19;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    super.PostBeginPlay();
    MOHAPlayerReplicationInfo(PlayerReplicationInfo).m_bInRankedGame = P.isRanked();
    MOHAPlayerReplicationInfo(PlayerReplicationInfo).SetRank(GetRankStat());
    // End:0x8E
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        ClientWhizManager = new Class'MOHAWhizManager';
    }
    UpdateCinematicActorList();
    // End:0xAD
    if(m_MPPlayerStats == none)
    {
        CreatePlayerStats();
    }
    //return;    
}

simulated event ReceivedPlayer()
{
    local Plasma P;

    super(PlayerController).ReceivedPlayer();
    P = Class'Plasma.Plasma'.static.GetPlasma();
    SetUniqueNetIdFromPlayer();
    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0xB5
    if(P != none)
    {
        PlayerReplicationInfo.SetPlayerName(P.GetGame().GetPlayerByUserId(PlayerReplicationInfo.UniqueId).GetName());
        MOHAPlayerReplicationInfo(PlayerReplicationInfo).SetXUID();
    }
    // End:0x13A
    if(IsLocalPlayerController())
    {
        P.SetGetGameSummaryDelegate(OnGetGameSummary);
        P.SetSubmitPlayerTrueSkillDelegate(OnSubmitPlayerTrueSkill);
        P.LevelLoadComplete();
        // End:0x13A
        if(!EnablePushToTalk)
        {
            P.GetGame().SetSendingVoiceEnabled(true);
        }
    }
    //return;    
}

event Destroyed()
{
    // End:0x88
    if(IsLocalPlayerController())
    {
        Class'Plasma.Plasma'.static.GetPlasma().SetGetGameSummaryDelegate(None);
        Class'Plasma.Plasma'.static.GetPlasma().SetSubmitPlayerTrueSkillDelegate(None);
        PostProcessComponent.Reset();
        ForceFeedbackManager.PauseWaveform(true);
    }
    super.Destroyed();
    //return;    
}

event PostLoadGame()
{
    super(Object).PostLoadGame();
    // End:0x1B
    if(m_MPPlayerStats == none)
    {
        CreatePlayerStats();
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x98
    if(VarName == 'PlayerReplicationInfo')
    {
        // End:0x37
        if(m_MPPlayerStats != none)
        {
            m_MPPlayerStats.PRI = MOHAPlayerReplicationInfo(PlayerReplicationInfo);
        }
        // End:0x70
        if(!MOHAPlayerReplicationInfo(PlayerReplicationInfo).bUniqueIdInitialized)
        {
            InitUniquePlayerId();
            MOHAPlayerReplicationInfo(PlayerReplicationInfo).bUniqueIdInitialized = true;
        }
        MOHAPlayerReplicationInfo(PlayerReplicationInfo).SetRank(GetRankStat());
        UpdateCinematicActorList();
    }
    super(PlayerController).ReplicatedEvent(VarName);
    //return;    
}

function bool IsPlayingCinematic()
{
    return false;
    //return ReturnValue;    
}

simulated function PlayerExitsPlaneSequenceEventActivate()
{
    local array<SequenceObject> AllSeqEvents;
    local Sequence GameSeq;
    local int I;
    local SeqEvent_PlayerExitsPlane PEPEvent;
    local array<int> PlayerEventImpulse;

    PlayerEventImpulse.Insert(0, 2);
    PlayerEventImpulse[0] = 0;
    // End:0x24
    if(LocalPlayer(Player) == none)
    {
        return;
    }
    GameSeq = WorldInfo.GetGameSequence();
    // End:0xB7
    if(GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_PlayerExitsPlane', true, AllSeqEvents);
        I = 0;
        J0x65:

        // End:0xB7 [Loop If]
        if(I < AllSeqEvents.Length)
        {
            PEPEvent = SeqEvent_PlayerExitsPlane(AllSeqEvents[I]);
            PlayerEventImpulse[1] = 2;
            PEPEvent.CheckActivate(self, self, false, PlayerEventImpulse);
            I++;
            // [Loop Continue]
            goto J0x65;
        }
    }
    //return;    
}

simulated function PlayerEntersPlaneMPSequenceEventActivate()
{
    local array<SequenceObject> AllSeqEvents;
    local Sequence GameSeq;
    local int I;
    local SeqEvent_PlayerEntersPlaneMP PEPEvent;
    local array<int> PlayerEventImpulse;

    PlayerEventImpulse[0] = 0;
    // End:0x1B
    if(LocalPlayer(Player) == none)
    {
        return;
    }
    GameSeq = WorldInfo.GetGameSequence();
    // End:0xA4
    if(GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_PlayerEntersPlaneMP', true, AllSeqEvents);
        I = 0;
        J0x5C:

        // End:0xA4 [Loop If]
        if(I < AllSeqEvents.Length)
        {
            PEPEvent = SeqEvent_PlayerEntersPlaneMP(AllSeqEvents[I]);
            PEPEvent.CheckActivate(self, self, false, PlayerEventImpulse);
            I++;
            // [Loop Continue]
            goto J0x5C;
        }
    }
    //return;    
}

reliable client simulated function SetClientRotation(Rotator InRotation)
{
    self.SetRotation(InRotation);
    //return;    
}

event CheckCinematicStatus()
{
    //return;    
}

function SetITPMeshIndices(int ITPActorIndex, int ITPMeshIndex)
{
    m_iCinematicActorIndex = ITPActorIndex;
    m_iCinematicActorMeshIndex = ITPMeshIndex;
    //return;    
}

simulated function UpdateITPVisibility(int ITPActorIndex, int ITPMeshIndex)
{
    // End:0x4E
    if(((ITPActorIndex >= 0) && ITPActorIndex < CinematicITPActors.Length) && CinematicITPActors[ITPActorIndex] != none)
    {
        CinematicITPActors[ITPActorIndex].SetOtherMeshSeat(ITPMeshIndex);
    }
    //return;    
}

simulated function UpdateCinematicActorList()
{
    local MultiplayerCinematicActor MCA;
    local int I, J;

    CinematicITPActors.Length = 0;
    // End:0x2B
    foreach DynamicActors(Class'MultiplayerCinematicActor', MCA)
    {
        CinematicITPActors[CinematicITPActors.Length] = MCA;        
    }    
    I = 0;
    J0x33:

    // End:0xD3 [Loop If]
    if(I < CinematicITPActors.Length)
    {
        J = 0;
        J0x4A:

        // End:0xC9 [Loop If]
        if(J < I)
        {
            // End:0xBF
            if(CinematicITPActors[I].iCinematicActorNumber < CinematicITPActors[J].iCinematicActorNumber)
            {
                MCA = CinematicITPActors[I];
                CinematicITPActors[I] = CinematicITPActors[J];
                CinematicITPActors[J] = MCA;
            }
            ++J;
            // [Loop Continue]
            goto J0x4A;
        }
        ++I;
        // [Loop Continue]
        goto J0x33;
    }
    //return;    
}

event SetDesiredTeam(int DesiredTeam, bool bFinal)
{
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x42
    if(P.isRanked())
    {
        // End:0x40
        if(bFinal)
        {
            bTeamSelected = true;
        }
        return;
    }
    // End:0x61
    if((bTeamSelected == true) && bFinal != true)
    {
        return;        
    }
    else
    {
        // End:0xBF
        if((((DesiredTeam > 0) && DesiredTeam < 2) && PlayerReplicationInfo.Team.TeamIndex != DesiredTeam) && bFinal == true)
        {
            ServerClearWeaponState();
            ClientClearWeaponState();
        }
    }
    // End:0xD3
    if(bFinal == true)
    {
        bTeamSelected = true;
    }
    // End:0x111
    if(((DesiredTeam < 0) || DesiredTeam > 1) || PlayerReplicationInfo.Team.TeamIndex == DesiredTeam)
    {        
    }
    else
    {
        SwitchTeam();
    }
    //return;    
}

reliable server function ServerClearWeaponState()
{
    m_DesiredWeapon = 0;
    GotoState('WeaponSelect');
    //return;    
}

reliable client simulated function ClientClearWeaponState()
{
    m_DesiredWeapon = 0;
    //return;    
}

reliable server function ServerSetHasInitiallySpawned(bool hasSpawned)
{
    bHasInitiallySpawned = hasSpawned;
    //return;    
}

reliable client simulated function ClientSetHasInitiallySpawned(bool hasSpawned)
{
    bHasInitiallySpawned = hasSpawned;
    //return;    
}

reliable server function ServerCheckPurpleHeart()
{
    m_MPPlayerStats.CheckMedalPurpleHeart(m_iLowestHealthThisLife);
    //return;    
}

reliable server function ServerChangeTeam(int N)
{
    local int oldDeathNum;
    local Vector pLoc;
    local Rotator pRot;

    // End:0x3D
    if((PlayerReplicationInfo.Team == none) || PlayerReplicationInfo.Team.TeamIndex == 1)
    {
        N = 0;        
    }
    else
    {
        N = 1;
    }
    // End:0x7D
    if(MOHAMultiplayerGameInfo(WorldInfo.Game).CanSwitchTeam(self, N) == false)
    {
        ClientShowCantSwitchTeamMessage();
        return;
    }
    MOHAPlayerReplicationInfo(PlayerReplicationInfo).m_bHasSwitchedTeams = true;
    WorldInfo.Game.ChangeTeam(self, N, true);
    oldDeathNum = int(PlayerReplicationInfo.Deaths);
    // End:0xEA
    if(Pawn != none)
    {
        Pawn.PlayerChangedTeam();
    }
    PlayerReplicationInfo.Deaths = float(oldDeathNum);
    m_MPPlayerStats.m_bHasSwitchedTeams = true;
    ServerClearWeaponState();
    ClientClearWeaponState();
    // End:0x155
    if(Pawn != none)
    {
        Pawn.GetActorEyesViewPoint(pLoc, pRot);
        SetLocation(pLoc);
    }
    ClientOpenWeaponMenu();
    // End:0x1A7
    if(WorldInfo.Game != none)
    {
        MOHAMultiplayerGameInfo(WorldInfo.Game).Voip.PlayerSwitchesTeams(MOHAPlayerReplicationInfo(PlayerReplicationInfo));
    }
    //return;    
}

reliable server function ServerSuicide()
{
    super(PlayerController).ServerSuicide();
    m_MPPlayerStats.StatAddTeamPoint(-2);
    m_MPPlayerStats.StatAddSuicide();
    //return;    
}

reliable client simulated function ClientReturnToShell()
{
    ConsoleCommand("open ?closed?game=MOHAGame.MOHAGameInfo");
    //return;    
}

simulated function SimulatedAddEndOfRoundStats(bool bOnWinningTeam, int iPosition)
{
    m_MPPlayerStats.AddEndOfRoundStats(bOnWinningTeam, iPosition);
    //return;    
}

reliable client simulated function clientStartDyingEffect()
{
    Class'Engine.TriggerVolume_SoundSpace'.static.ResetSoundSpaces();
    PostProcessComponent.Reset();
    PostProcessComponent.startDying();
    //return;    
}

reliable client simulated function LookAtKillerPawn()
{
    //return;    
}

reliable client simulated function ClientClearStateOnDeath()
{
    WorldInfo.GameModified_TurnOnDOF = 0;
    ToggleCursor(true);
    // End:0x40
    if(myHUD != none)
    {
        MOHAHUD(myHUD).SetRenderMode(0);
    }
    ResetCursor();
    //return;    
}

function PawnDied(Pawn P)
{
    local bool bMyPawn;
    local float fRespawnWaitTime, fRespawnInStartSpotTime, fLookAtKillerTime;
    local Vector pLoc;
    local Rotator pRot;

    bMyPawn = P == Pawn;
    fRespawnWaitTime = 5.0000000;
    fLookAtKillerTime = 2.0000000;
    ClientSetSpawnInAir(2);
    // End:0x137
    if((P != none) && P.IsA('MOHAMultiplayerPawn'))
    {
        fLookAtKillerTime = MOHAMultiplayerPawn(P).LookAtKillerTime;
        // End:0x113
        if((WorldInfo.Game != none) && WorldInfo.Game.IsA('AirborneTeamGameInfo'))
        {
            // End:0xEC
            if(PlayerReplicationInfo.Team.TeamIndex == 0)
            {
                fRespawnWaitTime = MOHAMultiplayerPawn(P).RespawnWaitTimeAllied;
                fRespawnInStartSpotTime = LookThroughStartSpotTimeAllied;                
            }
            else
            {
                fRespawnWaitTime = MOHAMultiplayerPawn(P).RespawnWaitTimeAxis;
                fRespawnInStartSpotTime = LookThroughStartSpotTimeAxis;
            }            
        }
        else
        {
            fRespawnWaitTime = MOHAMultiplayerPawn(P).RespawnWaitTimeNotAirborne;
            fRespawnInStartSpotTime = LookThroughStartSpotNotAirborne;
        }
    }
    // End:0x1AA
    if((Pawn != none) && bMyPawn)
    {
        Pawn.GetActorEyesViewPoint(pLoc, pRot);
        SetLocation(pLoc);
        CachedPawnForKillerPawn = MOHAMultiplayerPawn(Pawn);
        ClientSetViewTarget(Pawn, 0.1000000);
        SetViewTarget(Pawn, 0.1000000);
    }
    ClientClearStateOnDeath();
    super.PawnDied(P);
    // End:0x236
    if(bMyPawn)
    {
        m_fTimeToRespawn = fRespawnWaitTime + fRespawnInStartSpotTime;
        // End:0x236
        if(int(WorldInfo.NetMode) != int(NM_Client))
        {
            SetTimer(fRespawnWaitTime, false, 'RequestRespawn');
            SetTimer(fRespawnWaitTime - fLookAtKillerTime, false, 'LookAtKillerPawn');
            clientStartDyingEffect();
            StartDeathSound();
        }
    }
    // End:0x293
    if((int(WorldInfo.NetMode) != int(NM_Client)) && WorldInfo.Game.IsA('ObjectiveGameInfo'))
    {
        ObjectiveGameInfo(WorldInfo.Game).RemoveControllerFromFlags(self);
    }
    //return;    
}

function RequestRespawn()
{
    //return;    
}

function CheckObjectiveTrigger()
{
    // End:0x1F
    if(m_ObjectiveInFocus != none)
    {
        m_ObjectiveInFocus.Trigger(self);
    }
    //return;    
}

simulated function myDrawHUD(HUD H)
{
    local Canvas Canvas;
    local Vector WorldLocation, ScreenLocation;
    local MOHAHUD MytempHUD;
    local string PawnName;
    local float XL, YL;
    local Color displayColor;
    local MOHAPlayerReplicationInfo mPRI;
    local MOHAIncludeClass.MilitaryRank Rank;
    local Texture2D RankIcon;
    local int PosX, PosY, EnemyTeamNum;

    // End:0x0D
    if(KillerPawn == none)
    {
        return;
    }
    Canvas = H.Canvas;
    MytempHUD = MOHAHUD(H);
    MytempHUD.SetMultiplayerFont();
    EnemyTeamNum = int(KillerPawn.GetTeamNum());
    // End:0xCF
    if(PlayerReplicationInfo.Team.TeamIndex == EnemyTeamNum)
    {
        displayColor.R = 0;
        displayColor.G = byte(255);
        displayColor.B = 0;
        displayColor.A = byte(255);        
    }
    else
    {
        displayColor.R = byte(255);
        displayColor.G = 0;
        displayColor.B = 0;
        displayColor.A = byte(255);
    }
    // End:0x38B
    if(MOHAPlayerReplicationInfo(KillerPawn.PlayerReplicationInfo) != none)
    {
        WorldLocation = KillerPawn.Location;
        WorldLocation.Z += 85.0000000;
        ScreenLocation = Canvas.Project(WorldLocation);
        // End:0x38B
        if(ScreenLocation.Z < 1.0000000)
        {
            mPRI = MOHAPlayerReplicationInfo(KillerPawn.PlayerReplicationInfo);
            PawnName = mPRI.PlayerName;
            Canvas.SetDrawColor(displayColor.R, displayColor.G, displayColor.B);
            Canvas.__NFUN_464__(PawnName, XL, YL);
            PosX = int(ScreenLocation.X - (XL / float(2)));
            PosY = int((ScreenLocation.Y - (20.0000000 * 0.6000000)) - float(16));
            Canvas.SetPos(float(PosX), float(PosY));
            Canvas.SetClip(float(Canvas.SizeX), float(Canvas.SizeY));
            Canvas.__NFUN_469__(PawnName);
            // End:0x38B
            if(MOHAPlayerReplicationInfo(PlayerReplicationInfo).m_bInRankedGame)
            {
                Rank = mPRI.m_eMilitaryRank;
                RankIcon = KillerPawn.GetRankIcon(Rank, EnemyTeamNum);
                // End:0x38B
                if(RankIcon != none)
                {
                    PosY -= 20;
                    PosX = int(ScreenLocation.X - float(20 / 2));
                    MytempHUD.DrawIcon(RankIcon, float(PosX), float(PosY), 20.0000000, 20.0000000, 0.0000000, 0.0000000, 32.0000000, 32.0000000);
                }
            }
        }
    }
    //return;    
}

simulated function ShowFinalScoreBoard()
{
    myHUD.SetbShowScores(false, true);
    myHUD.SpawnScoreBoard(MOHAGameReplicationInfo(WorldInfo.GRI).PostGameScoreBoardType);
    myHUD.SetbShowScores(true);
    //return;    
}

function DeployChute(bool bOpenChute)
{
    //return;    
}

event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
{
    MOHAMultiplayerPawn(Pawn).Landed(HitNormal, FloorActor);
    // End:0x6A
    if(WorldInfo.Game != none)
    {
        MOHAMultiplayerGameInfo(WorldInfo.Game).Voip.PlayerLands(MOHAPlayerReplicationInfo(PlayerReplicationInfo));
    }
    return true;
    //return ReturnValue;    
}

function bool IsAirdroping()
{
    return false;
    //return ReturnValue;    
}

reliable client simulated function ClientLand()
{
    DoLanding();
    //return;    
}

function DoLanding()
{
    MOHAMultiplayerPawn(Pawn).AirDrop_LandingEvent();
    GotoState('AirDropLanding');
    //return;    
}

simulated event CheckAirdropChuteStatus()
{
    //return;    
}

reliable server function ControllerServerSetLandingType(MOHAPlayerPawn.EAirDropLandingType eLandingType)
{
    MOHAMultiplayerPawn(Pawn).ServerSetLandingType(eLandingType);
    //return;    
}

simulated function SetCurrentExperience(optional EALAWeapon ExpWeapon)
{
    super.SetCurrentExperience(ExpWeapon);
    m_MPPlayerStats.SetCurrentWeaponExperience(playerStats.GetCurrentWeaponExpComponent());
    //return;    
}

reliable client simulated function ClientResetStatsPerMatch()
{
    PlayerReplicationInfo.Reset();
    //return;    
}

reliable client simulated function ShowKillKillAssistMessage()
{
    ClientMessage(MessageKillAssistReceived);
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos, out int foundBase)
{
    local MOHAMultiplayerController P;

    super.DisplayDebug(HUD, out_YL, out_YPos, foundBase);
    // End:0x69
    if(Pawn != none)
    {
        HUD.Canvas.__NFUN_465__("Pawn Physics:" $ string(Pawn.Physics), true);
        out_YPos += out_YL;
    }
    HUD.Canvas.__NFUN_465__("Controller Physics:" $ string(Physics), true);
    out_YPos += out_YL;
    // End:0x1FA
    if((Pawn != none) && Pawn.IsA('MOHAPlayerPawn'))
    {
        HUD.Canvas.__NFUN_465__("Current Activity: " $ string(MOHAPlayerPawn(Pawn).CurrentActivity), true);
        HUD.Canvas.__NFUN_465__("Current Upper Body Activity: " $ string(MOHAMultiplayerPawn(Pawn).eCurrentUpperBodyActivity), true);
        HUD.Canvas.__NFUN_465__("Current Lower Body Activity: " $ string(MOHAMultiplayerPawn(Pawn).eCurrentLowerBodyActivity), true);
        HUD.Canvas.__NFUN_465__("Ladder State: " $ string(MOHAMultiplayerPawn(Pawn).LadderState), true);
        out_YPos += (out_YL * float(4));
    }
    // End:0x26C
    if(((Pawn != none) && Pawn.InvManager != none) && HUD.ShouldDisplayDebug('Inventory'))
    {
        Pawn.InvManager.DisplayDebug(HUD, out_YL, out_YPos, foundBase);
    }
    // End:0x2D4
    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', P)
    {
        HUD.Canvas.__NFUN_465__((string(P) $ " is in state ") $ string(P.GetStateName()));
        out_YPos += out_YL;        
    }    
    //return;    
}

exec function PrintControllerStates()
{
    local MOHAMultiplayerController P;

    // End:0x1D
    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', P)
    {        
    }    
    //return;    
}

exec function PrintPawnStates()
{
    local MOHAMultiplayerPawn P;

    // End:0x1F
    foreach WorldInfo.AllPawns(Class'MOHAMultiplayerPawn', P)
    {        
    }    
    //return;    
}

exec function SetFootLocking(bool bOn)
{
    local MOHAMultiplayerPawn P;

    // End:0x37
    foreach WorldInfo.AllPawns(Class'MOHAMultiplayerPawn', P)
    {
        P.bMeshAdj_DynamicDisable = !bOn;        
    }    
    //return;    
}

exec function PrintControllerAndPawnStates()
{
    PrintControllerStates();
    PrintPawnStates();
    //return;    
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum, optional Actor DamageCauser)
{
    // End:0x2D
    if(m_iLowestHealthThisLife > Pawn.Health)
    {
        m_iLowestHealthThisLife = Pawn.Health;
    }
    super(PlayerController).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum, DamageCauser);
    UpdatePostProcessEffects(DamageType, Damage, DamageCauser);
    CameraShakeHitReaction(InstigatedBy, Damage);
    //return;    
}

function SetMaxAmmoCount(class<EALAAmmoInventoryClass> AmmoClass, int newAmmoCount)
{
    // End:0x51
    if((Pawn != none) && MOHAInventoryManager(Pawn.InvManager) != none)
    {
        MOHAInventoryManager(Pawn.InvManager).SetMaxAmmoCount(AmmoClass, newAmmoCount);
    }
    //return;    
}

reliable server function ServerSetMaxAmmoCount(class<EALAAmmoInventoryClass> AmmoClass, int newAmmoCount)
{
    SetMaxAmmoCount(AmmoClass, newAmmoCount);
    //return;    
}

reliable client simulated function ClientSetMaxAmmoCount(class<EALAAmmoInventoryClass> AmmoClass, int newAmmoCount)
{
    SetMaxAmmoCount(AmmoClass, newAmmoCount);
    //return;    
}

simulated function NotifyPickupAmmoClass(MOHAPlayerPawn.EPickupType PickupType, class<EALAAmmoInventoryClass> AmmoClass)
{
    ClientNotifyPickupAmmoClass(PickupType, AmmoClass);
    //return;    
}

unreliable client simulated function ClientNotifyPickupAmmoClass(MOHAPlayerPawn.EPickupType PickupType, class<EALAAmmoInventoryClass> AmmoClass)
{
    NotifyPickupAmmoClass(PickupType, AmmoClass);
    //return;    
}

simulated function NotifyPickupFailureAmmoClass(MOHAPlayerPawn.EPickupType PickupType, class<EALAAmmoInventoryClass> AmmoClass)
{
    ClientNotifyPickupFailureAmmoClass(PickupType, AmmoClass);
    //return;    
}

unreliable client simulated function ClientNotifyPickupFailureAmmoClass(MOHAPlayerPawn.EPickupType PickupType, class<EALAAmmoInventoryClass> AmmoClass)
{
    NotifyPickupFailureAmmoClass(PickupType, AmmoClass);
    //return;    
}

simulated function NotifyPickup(MOHAPlayerPawn.EPickupType PickupType, optional string PickupName)
{
    ClientNotifyPickup(PickupType, PickupName);
    //return;    
}

unreliable client simulated function ClientNotifyPickup(MOHAPlayerPawn.EPickupType PickupType, optional string PickupName)
{
    NotifyPickup(PickupType, PickupName);
    //return;    
}

function UpdatePostProcessEffects(class<DamageType> DamageType, int Damage, optional Actor DamageCauser)
{
    local float fDistToDamageCauser;

    // End:0x49
    if(ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType'))
    {
        fDistToDamageCauser = ((DamageCauser != none) ? VSize(DamageCauser.Location - Pawn.Location) : 0.0000000);
    }
    ClientPostProcessEffects(DamageType, fDistToDamageCauser);
    //return;    
}

reliable server function ServerHurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float DamageMomentum, Vector HurtOrigin)
{
    // End:0x65
    if(((HurtOrigin - Pawn.Location) Dot (HurtOrigin - Pawn.Location)) < SanityValueForDistanceOnHurtRadius)
    {
        Pawn.HurtRadius(DamageAmount, DamageRadius, DamageType, DamageMomentum, HurtOrigin);
    }
    //return;    
}

unreliable server function ServerMeleeKick()
{
    //return;    
}

exec function Pause()
{
    //return;    
}

exec function StartAltFire(optional byte FireModeNum)
{
    // End:0x30
    if((MOHAPlayerPawn(Pawn) != none) && MOHAPlayerPawn(Pawn).IsIronsightsActive())
    {
        return;
    }
    super.StartAltFire(FireModeNum);
    //return;    
}

reliable client simulated function ClientPostProcessEffects(class<DamageType> DamageType, optional float fDistToDamageCauser)
{
    local float fEffectTime;

    // End:0x4F
    if(ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType'))
    {
        fEffectTime = PostProcessComponent.startExplosion(fDistToDamageCauser);
        MOHAPlayerPawn(Pawn).StartShellShock(fEffectTime);        
    }
    else
    {
        // End:0x75
        if(ClassIsChildOf(DamageType, Class'MOHAMeleeDamageType'))
        {
            PostProcessComponent.startMeleeHit();            
        }
        else
        {
            // End:0x98
            if(ClassIsChildOf(DamageType, Class'MOHABulletDamageType'))
            {
                PostProcessComponent.startBulletHit();
            }
        }
    }
    //return;    
}

simulated function AddHit()
{
    m_MPPlayerStats.StatAddHit();
    //return;    
}

exec function ConsoleReload(optional byte FireModeNum)
{
    // End:0x17
    if(m_ObjectiveInFocus == none)
    {
        Reload(FireModeNum);
    }
    //return;    
}

exec function FlareChuteEnd(optional byte FireModeNum)
{
    UseRelease();
    //return;    
}

exec function UseRelease()
{
    StopObjTimer();
    //return;    
}

reliable server function ServerTriggerRelease()
{
    bDemoChargeUseRelease = true;
    m_iObjectiveTimer = -1.0000000;
    //return;    
}

simulated function StopObjTimer()
{
    ServerTriggerRelease();
    bDemoChargeUseRelease = true;
    m_iObjectiveTimer = -1.0000000;
    //return;    
}

function bool PerformedUseAction()
{
    // End:0x0F
    if(CSATriggerInteracted())
    {
        return true;
    }
    return TriggerInteracted();
    //return ReturnValue;    
}

function WeaponCSAHoldTimeExpired()
{
    super.WeaponCSAHoldTimeExpired();
    // End:0x29
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        ServerUse();
    }
    //return;    
}

reliable server function ServerTriggerInteracted()
{
    GotoState('PlayerUsingMPObjective');
    m_iObjectiveTimer = 0.0000000;
    bDemoChargeUseRelease = false;
    Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    //return;    
}

simulated function bool TriggerInteracted()
{
    // End:0x70
    if((m_ObjectiveInFocus != none) && m_ObjectiveInFocus.CanTrigger(PlayerReplicationInfo.Team.TeamIndex))
    {
        m_ObjectiveInUse = m_ObjectiveInFocus;
        bDemoChargeUseRelease = false;
        GotoState('PlayerUsingMPObjective');
        ServerTriggerInteracted();
        m_iObjectiveTimer = 0.0000000;
    }
    return false;
    //return ReturnValue;    
}

event CheckObjectiveStatus(float DeltaTime)
{
    //return;    
}

function int GetBombTimerLeft()
{
    local int TimeLeft;

    // End:0x0D
    if(m_ObjectiveInFocus == none)
    {
        return 0;
    }
    TimeLeft = int((m_ObjectiveInFocus.GetArmHoldTime() - m_iObjectiveTimer) + float(1));
    // End:0x46
    if(TimeLeft < 0)
    {
        TimeLeft = 0;
    }
    return TimeLeft;
    //return ReturnValue;    
}

exec function StartFire(optional byte FireModeNum)
{
    super.StartFire(FireModeNum);
    //return;    
}

function NotifyWeaponFired(Weapon W, byte FireMode)
{
    super.NotifyWeaponFired(W, FireMode);
    // End:0x22
    if(EALAGrenade(W) != none)
    {
        return;
    }
    m_MPPlayerStats.StatAddShotFired();
    //return;    
}

simulated function DetectObjectives()
{
    local MPObjective T;
    local int AnimIndex;

    // End:0x41
    if((((Pawn == none) || Pawn.Health <= 0) || IsSpectating()) || IsAirdroping())
    {
        return;
    }
    m_ObjectiveInFocus = none;
    // End:0x139
    foreach DynamicActors(Class'MPObjective', T)
    {
        // End:0x138
        if(int(T.ObjectiveState) != int(2))
        {
            // End:0x138
            if((VSize(Pawn.Location - T.Location) < T.RadiusToCheck) && T.CanTrigger(PlayerReplicationInfo.Team.TeamIndex))
            {
                m_ObjectiveInFocus = T;
                AnimIndex = int(m_ObjectiveInFocus.AnimationType) * 2;
                // End:0x115
                if(m_ObjectiveInFocus.IsInArmedMode())
                {
                    AnimIndex++;
                }
                MOHAMultiplayerPawn(Pawn).m_oMPObjective.m_iMPObjectiveType = AnimIndex;
            }
        }        
    }    
    //return;    
}

simulated event MPObjectiveTouch(MPObjective MPObjectiveToUse)
{
    local int AnimIndex;

    m_ObjectiveInFocus = MPObjectiveToUse;
    AnimIndex = int(m_ObjectiveInFocus.AnimationType) * 2;
    // End:0x42
    if(m_ObjectiveInFocus.IsInArmedMode())
    {
        AnimIndex++;
    }
    MOHAMultiplayerPawn(Pawn).m_oMPObjective.m_iMPObjectiveType = AnimIndex;
    //return;    
}

simulated event MPObjectiveClear()
{
    m_ObjectiveInFocus = none;
    //return;    
}

event PlayerTick(float DeltaTime)
{
    super.PlayerTick(DeltaTime);
    UpdatePopup(DeltaTime);
    // End:0x3D
    if(ClientWhizManager != none)
    {
        ClientWhizManager.Update(DeltaTime);
    }
    //return;    
}

reliable client simulated function ClientSetSpawnInAir(MOHAMultiplayerController.ESpawnType SType)
{
    SpawnType = SType;
    //return;    
}

event ClientOpenTeamMenu()
{
    local Plasma P;
    local UIInteraction UIController;

    UIController = GetUIController();
    // End:0x124
    if(UIController != none)
    {
        P = Class'Plasma.Plasma'.static.GetPlasma();
        // End:0x90
        if((P != none) && P.isRanked())
        {
            // End:0x8D
            if(UIController.FindSceneByTag(WeaponSelectScene.SceneTag) == none)
            {
                UIController.OpenScene(WeaponSelectScene);
            }            
        }
        else
        {
            // End:0xEA
            if(WorldInfo.GetPlatform() == 'PC')
            {
                // End:0xE7
                if(UIController.FindSceneByTag(TeamSelectScene.SceneTag) == none)
                {
                    UIController.OpenScene(TeamSelectScene);
                }                
            }
            else
            {
                // End:0x124
                if(UIController.FindSceneByTag(TeamSelectConsoleScene.SceneTag) == none)
                {
                    UIController.OpenScene(TeamSelectConsoleScene);
                }
            }
        }
    }
    //return;    
}

event ClientOpenWeaponMenu()
{
    local UIInteraction UIController;

    // End:0x8F
    if(bHasInitiallySpawned)
    {
        // End:0x8F
        if((int(m_DesiredWeapon) == int(0)) || MOHAGameReplicationInfo(WorldInfo.GRI).RoundStatus == 3)
        {
            UIController = GetUIController();
            // End:0x8F
            if(UIController != none)
            {
                // End:0x8F
                if(UIController.FindSceneByTag(WeaponSelectScene.SceneTag) == none)
                {
                    UIController.OpenScene(WeaponSelectScene);
                }
            }
        }
    }
    //return;    
}

function EnterStartState()
{
    // End:0x33
    if((int(WorldInfo.NetMode) != int(NM_Client)) && int(Role) == int(ROLE_Authority))
    {
        super(PlayerController).EnterStartState();
        return;
    }
    // End:0xE0
    if((int(SpawnType) == int(0)) || ((WorldInfo.Game != none) && WorldInfo.Game.IsA('AirborneTeamGameInfo')) && PlayerReplicationInfo.Team.TeamIndex == 0)
    {
        // End:0xDD
        if((MOHAMultiplayerPawn(Pawn) != none) && MOHAMultiplayerPawn(Pawn).AirdropParachuteMesh == none)
        {
            MOHAMultiplayerPawn(Pawn).AirDrop_DeployChuteEvent();
        }        
    }
    else
    {
        super(PlayerController).EnterStartState();
    }
    //return;    
}

reliable client simulated function ClientKillAndPurgeScoreBoard()
{
    local UIInteraction UIController;
    local UIScene ChangeTeam, ChangeTeamConsole, ChangeWeapon;

    myHUD.SetbShowScores(false);
    UIController = GetUIController();
    // End:0xDA
    if(UIController != none)
    {
        ChangeTeam = UIController.FindSceneByTag(ChangeTeamTag);
        // End:0x66
        if(ChangeTeam != none)
        {
            UIController.CloseScene(ChangeTeam);
        }
        ChangeTeamConsole = UIController.FindSceneByTag(ChangeTeamConsoleTag);
        // End:0xA0
        if(ChangeTeamConsole != none)
        {
            UIController.CloseScene(ChangeTeamConsole);
        }
        ChangeWeapon = UIController.FindSceneByTag(ChangeWeaponTag);
        // End:0xDA
        if(ChangeWeapon != none)
        {
            UIController.CloseScene(ChangeWeapon);
        }
    }
    //return;    
}

reliable client simulated function ClientRespawn()
{
    SetCameraMode('FirstPerson');
    // End:0x31
    if(Pawn != none)
    {
        SetViewTarget(Pawn);        
    }
    else
    {
        SetViewTarget(self);
    }
    ClientKillAndPurgeScoreBoard();
    MOHAHUD_MP(myHUD).UpdateCompassTeam();
    PostProcessComponent.stopDying();
    EndDeathSound();
    Class'Engine.TriggerVolume_SoundSpace'.static.ResetSoundSpaces();
    CheckandActivateSoundSpace(Pawn);
    ClientFadeIn(BlackFadeInDelay, BlackFadeInTime);
    MOHAHUD_MP(myHUD).SetupHudForITPandDead(false);
    //return;    
}

reliable client simulated function ClientSetFlagMessage(MOHAMultiplayerController.MPFlagMessagesEnums messageIndex)
{
    ClientSetSpawnText(MessagesForFlags[int(messageIndex)]);
    //return;    
}

reliable client simulated function ClientDesertedMessage(coerce string deserterName, optional name Type, optional float MsgLifeTime)
{
    local array<string> LocalizedStringVars;
    local string printStr;

    LocalizedStringVars[0] = deserterName;
    printStr = Class'Engine.FormattedString'.static.FormatLocalizedStringVars(MessageDeserted, LocalizedStringVars);
    ClientMessage(printStr, Type, MsgLifeTime);
    //return;    
}

reliable client simulated function ClientSuicideMessage(coerce string suicideName, optional name Type, optional float MsgLifeTime)
{
    local array<string> LocalizedStringVars;
    local string printStr;

    LocalizedStringVars[0] = suicideName;
    printStr = Class'Engine.FormattedString'.static.FormatLocalizedStringVars(MessageSuicide, LocalizedStringVars);
    ClientMessage(printStr, Type, MsgLifeTime);
    //return;    
}

reliable client simulated function ClientKilledMessage(coerce string KillerName, coerce string KilleeName, optional name Type, optional float MsgLifeTime)
{
    local array<string> LocalizedStringVars;
    local string printStr;

    LocalizedStringVars[0] = KillerName;
    LocalizedStringVars[1] = KilleeName;
    printStr = Class'Engine.FormattedString'.static.FormatLocalizedStringVars(MessageKilled, LocalizedStringVars);
    ClientMessage(printStr, Type, MsgLifeTime);
    //return;    
}

reliable client simulated function ClientTeamKilledMessage(coerce string KillerName, coerce string KilleeName, optional name Type, optional float MsgLifeTime)
{
    local array<string> LocalizedStringVars;
    local string printStr;

    LocalizedStringVars[0] = KillerName;
    LocalizedStringVars[1] = KilleeName;
    printStr = Class'Engine.FormattedString'.static.FormatLocalizedStringVars(MessageTeamKilled, LocalizedStringVars);
    ClientMessage(printStr, Type, MsgLifeTime);
    //return;    
}

reliable client simulated function ClientAwardMessage(MOHAMultiplayerGameInfo.E_MPSTATS_MEDAL_AWARDS AwardType, coerce string PlayerName)
{
    local array<string> LocalizedStringVars;
    local string printStr;

    LocalizedStringVars[0] = PlayerName;
    printStr = Class'Engine.FormattedString'.static.FormatLocalizedStringVars(m_MPPlayerStats.GetAwardMedalMessageText(AwardType), LocalizedStringVars);
    ClientMessage(printStr, 'award', float(m_MaxPopupTimer));
    //return;    
}

reliable client simulated function ClientShowCantSwitchTeamMessage()
{
    ClientMessage(MessageCanNotSwitchTeams);
    //return;    
}

reliable client simulated function ClientShowRedeployBlockedMessage()
{
    ClientMessage(MessageRedeployBlocked);
    //return;    
}

reliable client simulated function ClientClearGameMessage()
{
    ClientSetGameText("", 0.0000000);
    //return;    
}

reliable client simulated function ClientShowSuddenDeathMessage()
{
    ClientSetGameText(SuddenDeathMessage, 0.0000000);
    //return;    
}

reliable client simulated function ClientShowTimeRunningOutMessage()
{
    ClientSetGameText(TimeRunningOutMessage, 0.0000000);
    //return;    
}

reliable client simulated event ClientSeqActMPTextMessage(coerce string Message, name MessageName, MOHAMultiplayerController.MPTextWindowTypes Type)
{
    Message = GetLocalizedStr(Message, string(MessageName), "Message", "Objectives");
    ClientMPTextWindowMessage(Message, Type);
    //return;    
}

reliable client simulated event ClientMessage(coerce string S, optional name Type, optional float MsgLifeTime)
{
    local MOHAHUD_MP mplayerHUD;
    local Color errColor;
    local bool bShowErrorsInMessageWindow;
    local MOHAMultiplayerController.MPTextWindowTypes ColorType;

    MsgLifeTime = 10.0000000;
    bShowErrorsInMessageWindow = false;
    // End:0x46
    if((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || WorldInfo.GRI == none)
    {
        return;
    }
    mplayerHUD = MOHAHUD_MP(myHUD);
    // End:0x1A8
    if(((Type == 'Error') || Type == 'Warning') && myHUD != none)
    {
        // End:0x1A5
        if(mplayerHUD != none)
        {
            mplayerHUD.AddErrorStringToBuffer(S);
            // End:0x1A5
            if(bShowErrorsInMessageWindow)
            {
                errColor.R = byte(255);
                errColor.G = 0;
                errColor.B = 0;
                errColor.A = byte(255);
                mplayerHUD.hud_message.PushFontColor(errColor);
                mplayerHUD.hud_message.PushFont(Class'Engine.Engine'.static.GetSmallFont());
                mplayerHUD.SetMessageWindowText(S, MsgLifeTime);
                mplayerHUD.hud_message.PopFont();
                mplayerHUD.hud_message.PopFontColor();
            }
        }        
    }
    else
    {
        // End:0x24C
        if(mplayerHUD != none)
        {
            ColorType = 0;
            // End:0x1D9
            if(Type == 'KilledBy')
            {
                ColorType = 1;                
            }
            else
            {
                // End:0x1F7
                if(Type == 'ObjectiveArmed')
                {
                    ColorType = 2;                    
                }
                else
                {
                    // End:0x215
                    if(Type == 'ObjectiveUnarmed')
                    {
                        ColorType = 3;                        
                    }
                    else
                    {
                        // End:0x230
                        if(Type == 'award')
                        {
                            ColorType = 4;
                        }
                    }
                }
            }
            ClientMPTextWindowMessage(S, ColorType, MsgLifeTime);            
        }
        else
        {
            super(PlayerController).ClientMessage(S, Type, MsgLifeTime);
        }
    }
    //return;    
}

reliable client simulated function ClientMOHAVoiceChatMessage(int commandIndex, coerce string PlayerName, SoundCue Sound, bool bTeamOnly)
{
    local string printStr;

    printStr = (PlayerName $ ": ") $ MOHAVoiceChatStrings[commandIndex];
    // End:0x39
    if(bTeamOnly)
    {
        printStr = MOHAVoiceTeamString @ printStr;
    }
    ClientMPTextWindowMessage(printStr, 0);
    PlaySound(Sound);
    //return;    
}

reliable client simulated event ClientMPTextWindowMessage(coerce string S, MOHAMultiplayerController.MPTextWindowTypes Type, optional float MsgLifeTime)
{
    local MOHAHUD_MP mplayerHUD;

    // End:0x32
    if((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || WorldInfo.GRI == none)
    {
        return;
    }
    mplayerHUD = MOHAHUD_MP(myHUD);
    // End:0x5C
    if(MsgLifeTime == float(0))
    {
        MsgLifeTime = float(MessageLifeTime);
    }
    mplayerHUD.hud_message.PushFontColor(MessageColor[int(Type)]);
    mplayerHUD.SetMessageWindowText(S, MsgLifeTime, float(MessageFadeTime));
    mplayerHUD.hud_message.PopFontColor();
    //return;    
}

unreliable client simulated event ClientSetSpawnTextFromWaitingVariables(int NumberOfPlayers, int Time)
{
    // End:0x31
    if((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || WorldInfo.GRI == none)
    {
        return;
    }
    m_PreGameTimer = Time;
    //return;    
}

unreliable client simulated event ClientSetSpawnTextForReDeploy(int Seconds)
{
    local MOHAHUD_MP mplayerHUD;
    local array<string> LocalizedStringVars;
    local string printStr;

    mplayerHUD = MOHAHUD_MP(myHUD);
    LocalizedStringVars[0] = "" $ string(Seconds);
    printStr = Class'Engine.FormattedString'.static.FormatLocalizedStringVars(WaitingForRedeployMessage, LocalizedStringVars);
    mplayerHUD.SetSpawnText(printStr);
    //return;    
}

reliable client simulated event ClientSetGameText(coerce string S, optional float StrongGlowTime)
{
    local MOHAHUD_MP mplayerHUD;

    // End:0x32
    if((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || WorldInfo.GRI == none)
    {
        return;
    }
    mplayerHUD = MOHAHUD_MP(myHUD);
    mplayerHUD.SetGameText(S);
    //return;    
}

reliable client simulated event ClientSetSpawnText(coerce string S, optional float StrongGlowTime)
{
    local MOHAHUD_MP mplayerHUD;

    // End:0x32
    if((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || WorldInfo.GRI == none)
    {
        return;
    }
    mplayerHUD = MOHAHUD_MP(myHUD);
    mplayerHUD.SetSpawnText(S);
    //return;    
}

reliable client simulated event ClientDrawObjectiveText(SeqAct_MPDrawObjectiveText ObjectiveAction)
{
    local MOHAHUD_MP mplayerHUD;

    // End:0x3E
    if(((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || WorldInfo.GRI == none) || ObjectiveAction == none)
    {
        return;
    }
    mplayerHUD = MOHAHUD_MP(myHUD);
    // End:0xB7
    if(PlayerReplicationInfo.Team.TeamIndex == 0)
    {
        mplayerHUD.SetObjectiveText(ObjectiveAction.MessageAllied, ObjectiveAction.MessageTitle, 1.0000000, ObjectiveAction.Duration, 1.0000000);        
    }
    else
    {
        mplayerHUD.SetObjectiveText(ObjectiveAction.MessageAxis, ObjectiveAction.MessageTitle, 1.0000000, ObjectiveAction.Duration, 1.0000000);
    }
    //return;    
}

simulated function bool LookingThruScope()
{
    return (((Pawn != none) && Pawn.IsA('MOHAPlayerPawn')) && MOHAPlayerPawn(Pawn).IsIronsightsActive()) && Pawn.Weapon.IsA('FG43') || Pawn.Weapon.IsA('MOHASniperRifle');
    //return ReturnValue;    
}

reliable server function ServerStartFire(byte FireModeNum)
{
    // End:0x42
    if((Pawn != none) && Pawn.Weapon != none)
    {
        Pawn.Weapon.ServerStartFire(FireModeNum);
    }
    //return;    
}

reliable server function ServerStartFireWithLocation(byte FireModeNum, Vector start_location)
{
    // End:0xB5
    if((Pawn != none) && EALAWeapon(Pawn.Weapon) != none)
    {
        // End:0x6C
        if(EALAGrenade(Pawn.Weapon) != none)
        {
            EALAWeapon(Pawn.Weapon).PhysicalStartFireOverride = vect(0.0000000, 0.0000000, 0.0000000);            
        }
        else
        {
            EALAWeapon(Pawn.Weapon).PhysicalStartFireOverride = start_location / float(10);
        }
        Pawn.Weapon.ServerStartFire(FireModeNum);
    }
    //return;    
}

reliable server function ServerStopFire(byte FireModeNum)
{
    // End:0x42
    if((Pawn != none) && Pawn.Weapon != none)
    {
        Pawn.Weapon.ServerStopFire(FireModeNum);
    }
    //return;    
}

reliable server function ServerStopFireGrenade(byte FireModeNum, optional float GrenadeStrength)
{
    // End:0x4E
    if((Pawn != none) && Pawn.Weapon != none)
    {
        Pawn.Weapon.ServerStopFire(FireModeNum);
        m_GrenadeThrowStrength = GrenadeStrength;
    }
    //return;    
}

reliable server function ServerSetCurrentWeaponType(MOHAIncludeClass.EWeaponType newWeaponType)
{
    local EALAWeapon NewWeapon, W;

    // End:0x82
    if(Pawn != none)
    {
        // End:0x5B
        foreach Pawn.InvManager.InventoryActors(Class'EALAWeapon', W)
        {
            // End:0x5A
            if(int(W.WeaponType) == int(newWeaponType))
            {
                NewWeapon = W;
                // End:0x5B
                break;
            }            
        }        
        MOHAInventoryManager(Pawn.InvManager).ServerSetCurrentWeapon(NewWeapon);
    }
    //return;    
}

function bool CanBeSpectated()
{
    return true;
    //return ReturnValue;    
}

reliable server function ServerBeginSpectating()
{
    GotoState('Spectating');
    //return;    
}

function BeginSpectating()
{
    GotoState('Spectating');
    // End:0x28
    if(int(Role) < int(ROLE_Authority))
    {
        ServerBeginSpectating();
    }
    //return;    
}

reliable client simulated function ClientClimbLadder(MOHAMPLadder L)
{
    MOHAMultiplayerPawn(Pawn).ClimbLadderMP(L);
    //return;    
}

function ServerClimbLadder(MOHAMPLadder L)
{
    ClientClimbLadder(L);
    // End:0x40
    if(!Pawn.IsLocallyControlled())
    {
        MOHAMultiplayerPawn(Pawn).ClimbLadderMP(L);
    }
    //return;    
}

reliable client simulated function ClientExitLadder()
{
    MOHAMultiplayerPawn(Pawn).CleanUpLadder();
    GotoState('PlayerWalking');
    //return;    
}

reliable server function ServerExitLadder()
{
    ClientExitLadder();
    // End:0x44
    if(!Pawn.IsLocallyControlled())
    {
        MOHAMultiplayerPawn(Pawn).CleanUpLadder();
        GotoState('PlayerWalking');
    }
    //return;    
}

function ExitLadder()
{
    ServerExitLadder();
    //return;    
}

simulated function MOHAPlayerReplicationInfo.EMPWeapons GetMPWeaponIndex(int W)
{
    return MPWeaponIndexes[W];
    //return ReturnValue;    
}

reliable client simulated function ClientGrantPlasmaAward(MOHAMultiplayerGameInfo.E_MPSTATS_MEDAL_AWARDS Medal)
{
    local Plasma P;
    local string awardName;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    switch(Medal)
    {
        // End:0x3F
        case 0:
            awardName = "ACH_MP_DS_Cross";
            // End:0x285
            break;
        // End:0x5E
        case 1:
            awardName = "ACH_MP_DS_Medal";
            // End:0x285
            break;
        // End:0x80
        case 2:
            awardName = "ACH_MP_Silver_Star";
            // End:0x285
            break;
        // End:0xA3
        case 3:
            awardName = "ACH_MP_Lgn_of_Merit";
            // End:0x285
            break;
        // End:0xC8
        case 4:
            awardName = "ACH_MP_Soldiers_Medal";
            // End:0x285
            break;
        // End:0xEA
        case 5:
            awardName = "ACH_MP_Bronze_Star";
            // End:0x285
            break;
        // End:0x10D
        case 6:
            awardName = "ACH_MP_Purple_Heart";
            // End:0x285
            break;
        // End:0x130
        case 7:
            awardName = "ACH_MP_WWII_Victory";
            // End:0x285
            break;
        // End:0x14E
        case 8:
            awardName = "ACH_MP_US_Cmpn";
            // End:0x285
            break;
        // End:0x16E
        case 9:
            awardName = "ACH_MP_EAME_Cmpn";
            // End:0x285
            break;
        // End:0x191
        case 10:
            awardName = "ACH_MP_Good_Conduct";
            // End:0x285
            break;
        // End:0x1B2
        case 11:
            awardName = "ACH_MP_Merit_Unit";
            // End:0x285
            break;
        // End:0x1D2
        case 14:
            awardName = "ACH_MP_Prez_Unit";
            // End:0x285
            break;
        // End:0x1F3
        case 12:
            awardName = "ACH_MP_Para_Badge";
            // End:0x285
            break;
        // End:0x216
        case 13:
            awardName = "ACH_MP_Combat_Badge";
            // End:0x285
            break;
        // End:0x238
        case 16:
            awardName = "ACH_MP_Pistol_Whip";
            // End:0x285
            break;
        // End:0x25B
        case 17:
            awardName = "ACH_MP_LittleFriend";
            // End:0x285
            break;
        // End:0x280
        case 18:
            awardName = "ACH_MP_Human_Flak_Gun";
            // End:0x285
            break;
        // End:0xFFFF
        default:
            return;
            break;
    }
    P.GrantAward(PlayerReplicationInfo.UniqueId, awardName);
    //return;    
}

private final simulated function int GetRankScore(MOHAPlayerReplicationInfo epri)
{
    local MOHAPlayerReplicationInfo vs_pri;
    local int winLoss, Score, rankDiff, I;
    local array<MOHAPlayerReplicationInfo> pris;

    WorldInfo.GRI.GetPRIArray(pris, true);
    // End:0x30
    if(pris.Length <= 1)
    {
        return 0;
    }
    Score = 0;
    I = 0;
    J0x3E:

    // End:0x2B6 [Loop If]
    if(I < pris.Length)
    {
        vs_pri = pris[I];
        // End:0x71
        if(vs_pri == epri)
        {
            // [Explicit Continue]
            goto J0x2AC;
        }
        // End:0xA3
        if(!epri.bIsInactive && vs_pri.bIsInactive)
        {
            winLoss = 1;            
        }
        else
        {
            // End:0xD9
            if(epri.bIsInactive && !vs_pri.bIsInactive)
            {
                winLoss = -1;                
            }
            else
            {
                // End:0x118
                if(epri.m_oEndgameScore.Score > vs_pri.m_oEndgameScore.Score)
                {
                    winLoss = 1;                    
                }
                else
                {
                    // End:0x15B
                    if(epri.m_oEndgameScore.Score < vs_pri.m_oEndgameScore.Score)
                    {
                        winLoss = -1;                        
                    }
                    else
                    {
                        // End:0x19A
                        if(epri.m_oEndgameScore.Deaths < vs_pri.m_oEndgameScore.Deaths)
                        {
                            winLoss = 1;                            
                        }
                        else
                        {
                            // End:0x1DD
                            if(epri.m_oEndgameScore.Deaths > vs_pri.m_oEndgameScore.Deaths)
                            {
                                winLoss = -1;                                
                            }
                            else
                            {
                                // End:0x20C
                                if(int(epri.m_eMilitaryRank) < int(vs_pri.m_eMilitaryRank))
                                {
                                    winLoss = 1;                                    
                                }
                                else
                                {
                                    // End:0x23F
                                    if(int(epri.m_eMilitaryRank) > int(vs_pri.m_eMilitaryRank))
                                    {
                                        winLoss = -1;                                        
                                    }
                                    else
                                    {
                                        winLoss = 0;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        rankDiff = int(epri.m_eMilitaryRank) - int(vs_pri.m_eMilitaryRank);
        rankDiff = Min(rankDiff, 5);
        rankDiff = Max(rankDiff, -5);
        Score += (winLoss * ScoreDelta[rankDiff + 5]);
        J0x2AC:

        I++;
        // [Loop Continue]
        goto J0x3E;
    }
    Score /= float(pris.Length - 1);
    // End:0x2F8
    if(Score > 0)
    {
        return int(float(Score) * WinFactor[int(epri.m_eMilitaryRank)]);        
    }
    else
    {
        return int(float(Score) * LossFactor[int(epri.m_eMilitaryRank)]);
    }
    //return ReturnValue;    
}

simulated function int AmIAwardWinner(MOHAPlayerReplicationInfo PRI, MOHAPlayerReplicationInfo.EMatchAwards award)
{
    return (((PRI.m_oEndgameMatchAwards[int(award)].AwardStatValue != 0) && PRI.m_oEndgameMatchAwards[int(award)].AwardStatPlayerID == PRI.PlayerID) ? 1 : 0);
    //return ReturnValue;    
}

simulated event OnSubmitPlayerTrueSkill(PlasmaGameManagerPlayer leavingPlayer, int MaxPlayers)
{
    local MOHAGameReplicationInfo GRI;
    local array<MOHAPlayerReplicationInfo> pris;
    local MOHAPlayerReplicationInfo epri;
    local int Score;
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    GRI = MOHAGameReplicationInfo(WorldInfo.GRI);
    // End:0xCF
    if(leavingPlayer != none)
    {
        Score = MaxPlayers - P.GetGame().GetPlayerCount();
        epri = MOHAPlayerReplicationInfo(GRI.FindPlayerByNetID(leavingPlayer.GetUserId()));
        leavingPlayer.Xb360WriteTrueSkillStat(epri.Team.TeamIndex, Score);        
    }
    else
    {
        GRI.SortPRIArray();
        GRI.GetPRIArray(pris);
        Score = MaxPlayers - 1;
        // End:0x179
        foreach pris(epri)
        {
            Score--;
            P.GetGame().GetPlayerByUserId(epri.UniqueId).Xb360WriteTrueSkillStat(epri.Team.TeamIndex, Score);            
        }        
    }
    //return;    
}

simulated event array<PlasmaTransaction> OnGetGameSummary()
{
    local int I, J, Position;
    local array<MOHAPlayerReplicationInfo> pris;
    local MOHAPlayerReplicationInfo epri;
    local MOHAGameReplicationInfo GRI;
    local Plasma P;
    local PlasmaGuid sid;
    local array<PlasmaTransaction> transList;
    local PlasmaTransaction T;
    local PlasmaGameSummaryAttributes attrs;
    local PlasmaGameSummaryHeader header;
    local PlasmaGameSummaryTeamHeader Team;
    local PlasmaGameSummaryPlayerHeader playerHeader;
    local PlasmaOwner statOwner;
    local array<PlasmaSingleStatUpdate> stats;
    local int winningTeam, winningTeamIndex;
    local PlasmaSingleStatUpdate myPlayerStats[EPlasmaPlayerStats], MyWeaponStats, myWeaponClassStat;
    local string GameTypeTeamMap;
    local int RankScore;
    local MOHAMultiplayerController tempMMPCont;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    sid = P.sessionID;
    GRI = MOHAGameReplicationInfo(WorldInfo.GRI);
    T = P.pgss.StartReport(sid, 0);
    transList[transList.Length] = T;
    header.isClubMatch = false;
    header.isRanked = P.isRanked();
    header.plannedDurationInMS = (GRI.TimeLimit * 60) * 1000;
    header.actualDurationInMS = GRI.ElapsedTime * 1000;
    header.Map = GRI.GetMapAbbr();
    header.mode = GRI.GetModeAbbr();
    T = P.pgss.AddGameSummary(sid, header, attrs);
    transList[transList.Length] = T;
    winningTeam = 2;
    winningTeamIndex = -1;
    // End:0x1D3
    if(GRI.AlliedRoundsWon > GRI.AxisRoundsWon)
    {
        winningTeam = 0;
        winningTeamIndex = 0;        
    }
    else
    {
        // End:0x202
        if(GRI.AxisRoundsWon > GRI.AlliedRoundsWon)
        {
            winningTeam = 1;
            winningTeamIndex = 1;
        }
    }
    attrs.Attributes.Length = 0;
    Team.TeamName = TeamNames[1];
    Team.NumPlayers = GRI.Teams[1].Size;
    Team.Score = int(GRI.Teams[1].Score);
    Team.Position = ((winningTeam != 0) ? 1 : 2);
    T = P.pgss.AddTeamInfo(sid, Team, attrs);
    transList[transList.Length] = T;
    attrs.Attributes.Length = 0;
    Team.TeamName = TeamNames[0];
    Team.NumPlayers = GRI.Teams[0].Size;
    Team.Score = int(GRI.Teams[0].Score);
    Team.Position = ((winningTeam != 1) ? 1 : 2);
    T = P.pgss.AddTeamInfo(sid, Team, attrs);
    transList[transList.Length] = T;
    GRI.SortPRIArray();
    GRI.GetPRIArray(pris, true);
    Position = 0;
    // End:0x13C2
    foreach pris(epri)
    {
        Position++;
        attrs.Attributes.Length = 0;
        playerHeader.userId = epri.UniqueId;
        playerHeader.TeamName = TeamNames[epri.Team.TeamIndex];
        playerHeader.clubId = 0;
        playerHeader.wasHost = int(GRI.Role) == int(ROLE_Authority);
        playerHeader.wasInvited = false;
        playerHeader.playNow = true;
        playerHeader.Position = Position;
        playerHeader.startTimeInMS = 0;
        playerHeader.finishTimeInMS = playerHeader.startTimeInMS + (GRI.ElapsedTime * 1000);
        playerHeader.Score = int(epri.Score);
        // End:0x565
        if(winningTeam == 2)
        {
            playerHeader.Outcome = "Tied";            
        }
        else
        {
            playerHeader.Outcome = ((epri.Team.TeamIndex == winningTeamIndex) ? "Won" : "Lost");
        }
        T = P.pgss.AddPlayerInfo(sid, playerHeader, attrs);
        transList[transList.Length] = T;
        RankScore = GetRankScore(epri);
        // End:0x66D
        foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', tempMMPCont)
        {
            // End:0x66C
            if(tempMMPCont.PlayerReplicationInfo == epri)
            {
                tempMMPCont.ClientSetStatLifeTimeValues(epri.m_oStatsLifeTime, epri.m_MedalsAwardedArray, Position, winningTeamIndex, RankScore);
                // End:0x66D
                break;
            }            
        }        
        // End:0x13C1
        if(P.isRanked())
        {
            statOwner.Type = 0;
            statOwner.Id = epri.UniqueId;
            stats.Length = 0;
            I = 0;
            J0x6C3:

            // End:0x6F0 [Loop If]
            if(I < 42)
            {
                myPlayerStats[I] = MPPlayerStats[I];
                I++;
                // [Loop Continue]
                goto J0x6C3;
            }
            GameTypeTeamMap = (((GRI.GetModeAbbr() $ "_") $ TeamNames[epri.Team.TeamIndex]) $ "_") $ GRI.GetMapAbbr();
            I = 28;
            J0x74F:

            // End:0x7B3 [Loop If]
            if(I <= 41)
            {
                myPlayerStats[I].statName = Repl(myPlayerStats[I].statName, "_TYPE_TEAM_MAP_", ("_" $ GameTypeTeamMap) $ "_");
                I++;
                // [Loop Continue]
                goto J0x74F;
            }
            myPlayerStats[0].statValue = float(RankScore);
            myPlayerStats[5].statValue = float(epri.MP_KillStreak);
            myPlayerStats[6].statValue = float(epri.MP_DeathStreak);
            myPlayerStats[8].statValue = float(epri.MP_AirborneMelees);
            myPlayerStats[9].statValue = float(epri.MP_MeleeDeaths);
            myPlayerStats[10].statValue = float(epri.MP_GrenadesThrown);
            myPlayerStats[11].statValue = float(epri.MP_GrenadesKills);
            myPlayerStats[12].statValue = float(epri.MP_GrenadesDeaths);
            myPlayerStats[15].statValue = float(AmIAwardWinner(epri, 0));
            myPlayerStats[16].statValue = float(AmIAwardWinner(epri, 1));
            myPlayerStats[17].statValue = float(AmIAwardWinner(epri, 2));
            myPlayerStats[18].statValue = float(AmIAwardWinner(epri, 3));
            myPlayerStats[19].statValue = float(AmIAwardWinner(epri, 12));
            myPlayerStats[20].statValue = float(AmIAwardWinner(epri, 20));
            myPlayerStats[21].statValue = float(AmIAwardWinner(epri, 22));
            myPlayerStats[22].statValue = float(AmIAwardWinner(epri, 23));
            myPlayerStats[23].statValue = float(AmIAwardWinner(epri, 4));
            myPlayerStats[24].statValue = float(AmIAwardWinner(epri, 5));
            myPlayerStats[25].statValue = float(AmIAwardWinner(epri, 6));
            myPlayerStats[26].statValue = float(AmIAwardWinner(epri, 7));
            myPlayerStats[27].statValue = float(AmIAwardWinner(epri, 8));
            myPlayerStats[28].statValue = float(GRI.ElapsedTime + epri.m_ElapsedTime);
            myPlayerStats[32].statValue = epri.Score;
            myPlayerStats[33].statValue = epri.Score;
            myPlayerStats[34].statValue = float(epri.m_iObjectivePoints);
            myPlayerStats[35].statValue = float(epri.m_iTeamPoints);
            myPlayerStats[36].statValue = float(epri.Kills);
            myPlayerStats[37].statValue = epri.Deaths;
            myPlayerStats[38].statValue = float(epri.MP_Suicides);
            myPlayerStats[39].statValue = float(epri.MP_TeamKills);
            myPlayerStats[40].statValue = float(epri.MP_KillAssists);
            myPlayerStats[29].statValue = 1.0000000;
            // End:0xC9D
            if(epri.bIsInactive)
            {
                myPlayerStats[31].statValue = 1.0000000;
                // End:0xC9A
                if(epri.MP_TeamKills > 0)
                {
                    myPlayerStats[7].updateType = 5;
                    myPlayerStats[7].statValue = 0.0000000;
                }                
            }
            else
            {
                myPlayerStats[30].statValue = float(((epri.Team.TeamIndex == winningTeamIndex) ? 1 : 0));
                myPlayerStats[31].statValue = float((((epri.Team.TeamIndex == winningTeamIndex) || winningTeam == 2) ? 0 : 1));
                myPlayerStats[41].statValue = float(Position);
                myPlayerStats[2].statValue = float(((Position == 1) ? 1 : 0));
                myPlayerStats[3].statValue = float(((Position == 2) ? 1 : 0));
                myPlayerStats[4].statValue = float(((Position == 3) ? 1 : 0));
                myPlayerStats[13].statValue = float(GRI.DistinguishedUnitAwarded[epri.Team.TeamIndex]);
                myPlayerStats[14].statValue = float(GRI.MeritoriousUnitAwarded[epri.Team.TeamIndex]);
                // End:0xE61
                if(epri.MP_TeamKills > 0)
                {
                    myPlayerStats[7].updateType = 5;
                    myPlayerStats[7].statValue = 0.0000000;                    
                }
                else
                {
                    myPlayerStats[7].updateType = 3;
                    myPlayerStats[7].statValue = 1.0000000;
                }
            }
            I = 0;
            J0xE95:

            // End:0xF02 [Loop If]
            if(I < 42)
            {
                // End:0xEF8
                if((int(myPlayerStats[I].updateType) != int(3)) || myPlayerStats[I].statValue != float(0))
                {
                    stats[stats.Length] = myPlayerStats[I];
                }
                I++;
                // [Loop Continue]
                goto J0xE95;
            }
            I = 0;
            J0xF09:

            // End:0x1298 [Loop If]
            if(I <= 11)
            {
                // End:0x128E
                if(true)
                {
                    J = 0;
                    J0xF20:

                    // End:0xF9A [Loop If]
                    if(J < 14)
                    {
                        MyWeaponStats[J] = MPWeaponStats[J];
                        MyWeaponStats[J].statName = Repl(MyWeaponStats[J].statName, "_WEAPON_", ("_" $ WeaponNames[I]) $ "_");
                        J++;
                        // [Loop Continue]
                        goto J0xF20;
                    }
                    MyWeaponStats[0].statValue = epri.MPStatsWeapons[I].Time;
                    MyWeaponStats[1].statValue = float(epri.MPStatsWeapons[I].Hits);
                    MyWeaponStats[2].statValue = float(epri.MPStatsWeapons[I].Shots);
                    MyWeaponStats[3].statValue = float(epri.MPStatsWeapons[I].Kills);
                    MyWeaponStats[4].statValue = float(epri.MPStatsWeapons[I].MeleeKills);
                    MyWeaponStats[5].statValue = float(epri.MPStatsWeapons[I].Deaths);
                    MyWeaponStats[6].statValue = float(epri.MPStatsWeapons[I].MeleeDeaths);
                    MyWeaponStats[7].statValue = float(epri.MP_Weapon_HitsHead[I]);
                    MyWeaponStats[8].statValue = float(epri.MP_Weapon_HitsRArm[I]);
                    MyWeaponStats[9].statValue = float(epri.MP_Weapon_HitsLArm[I]);
                    MyWeaponStats[10].statValue = float(epri.MP_Weapon_HitsTorso[I]);
                    MyWeaponStats[11].statValue = float(epri.MP_Weapon_HitsCrotch[I]);
                    MyWeaponStats[12].statValue = float(epri.MP_Weapon_HitsLLeg[I]);
                    MyWeaponStats[13].statValue = float(epri.MP_Weapon_HitsRLeg[I]);
                    J = 0;
                    J0x1221:

                    // End:0x128E [Loop If]
                    if(J < 14)
                    {
                        // End:0x1284
                        if((int(MyWeaponStats[J].updateType) != int(3)) || MyWeaponStats[J].statValue != float(0))
                        {
                            stats[stats.Length] = MyWeaponStats[J];
                        }
                        J++;
                        // [Loop Continue]
                        goto J0x1221;
                    }
                }
                I++;
                // [Loop Continue]
                goto J0xF09;
            }
            I = 0;
            J0x129F:

            // End:0x137E [Loop If]
            if(I < 9)
            {
                // End:0x12C0
                if(WeaponClassNames[I] == "")
                {
                    // [Explicit Continue]
                    goto J0x1374;
                }
                // End:0x12E4
                if(epri.GetWeaponClassScore(byte(I), false) == 0)
                {
                    // [Explicit Continue]
                    goto J0x1374;
                }
                myWeaponClassStat = MPWeaponClassStat;
                myWeaponClassStat.statName = Repl(myWeaponClassStat.statName, "_WEAPONCLASS_", ("_" $ WeaponClassNames[I]) $ "_");
                myWeaponClassStat.statValue = float(epri.GetWeaponClassScore(byte(I), false));
                stats[stats.Length] = myWeaponClassStat;
                J0x1374:

                I++;
                // [Loop Continue]
                goto J0x129F;
            }
            T = P.pgss.AddStats(sid, statOwner, stats);
            transList[transList.Length] = T;
        }        
    }    
    T = P.pgss.EndReport(sid);
    transList[transList.Length] = T;
    return transList;
    //return ReturnValue;    
}

auto state WeaponSelect
{
    function bool CanRestartPlayer()
    {
        return false;
        //return ReturnValue;        
    }

    reliable server event ServerSetDesiredPawnClass(MOHAIncludeClass.EWeaponSelection DesiredNextSpawnWeapon)
    {
        super(MOHAMultiplayerController).ServerSetDesiredPawnClass(DesiredNextSpawnWeapon);
        // End:0x45
        if(int(m_DesiredWeapon) != int(0))
        {
            GotoState('PlayerWaiting');
            ClientGotoState('PlayerWaiting');
            bHasSetDesiredPawn = true;
        }
        //return;        
    }
Begin:

    SetCameraMode('Fixed');
    ClientSetCameraMode('Fixed');
    m_bInWaitingState = false;
    bHasSetDesiredPawn = false;
    // End:0x70
    if(myHUD != none)
    {
        MOHAHUD_MP(myHUD).SetTeamIcon(PlayerReplicationInfo.Team.TeamIndex);
    }
    ClientBlackOut();
    stop;        
}

state PlayerWaiting
{
    function RequestRespawnInWaiting()
    {
        // End:0xF5
        if((WorldInfo.Game != none) && !MOHAMultiplayerGameInfo(WorldInfo.Game).IsWaiting())
        {
            // End:0xEB
            if(WorldInfo.Game.IsA('AirborneTeamGameInfo') && AirborneTeamGameInfo(WorldInfo.Game).bPlayingInitialCinematic == true)
            {
                // End:0xDE
                if(AirborneTeamGameInfo(WorldInfo.Game).m_iAirborneTeamIndex == PlayerReplicationInfo.Team.TeamIndex)
                {
                    AirborneTeamGameInfo(WorldInfo.Game).RequestInAirRespawn(self);                    
                }
                else
                {
                    ServerPreReStartPlayerAndWait();
                }                
            }
            else
            {
                ServerPreReStartPlayer();
            }
        }
        //return;        
    }
Begin:

    SetCameraMode('Fixed');
    ClientSetCameraMode('Fixed');
    ServerSetHasInitiallySpawned(true);
    ClientSetHasInitiallySpawned(true);
    PlayerReplicationInfo.bOnlySpectator = false;
    MOHAPlayerReplicationInfo(PlayerReplicationInfo).m_bHasSwitchedTeams = false;
    // End:0x9D
    if(myHUD != none)
    {
        MOHAHUD_MP(myHUD).SetTeamIcon(PlayerReplicationInfo.Team.TeamIndex);
    }
    PlayerReplicationInfo.bOutOfLives = false;
    WorldInfo.Game.bRestartLevel = false;
    m_bInWaitingState = true;
    PostProcessComponent.Reset();
    RequestRespawnInWaiting();
    stop;            
}

state PlayingITPCinematic
{
    function bool IsPlayingCinematic()
    {
        return true;
        //return ReturnValue;        
    }

    function PlayerMove(float DeltaTime, float fRotationDeltaSeconds)
    {
        UpdateRotation(DeltaTime);
        // End:0x52
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));            
        }
        else
        {
            ProcessMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
        }
        // End:0x9C
        if(DeltaTime != 0.0000000)
        {
            bSavedCrouchRequested = false;
            bSavedJumpRequested = false;
        }
        //return;        
    }

    function bool CanBeSpectated()
    {
        return false;
        //return ReturnValue;        
    }

    function SetITPMeshIndices(int ITPActorIndex, int ITPMeshIndex)
    {
        m_iCinematicActorIndex = ITPActorIndex;
        m_iCinematicActorMeshIndex = ITPMeshIndex;
        // End:0xE3
        if(m_iCinematicActorIndex >= 0)
        {
            // End:0x4E
            if((m_iCinematicActorIndex >= CinematicITPActors.Length) || CinematicITPActors[m_iCinematicActorIndex] == none)
            {
                UpdateCinematicActorList();
            }
            // End:0xE3
            if(((m_iCinematicActorIndex >= 0) && m_iCinematicActorIndex < CinematicITPActors.Length) && CinematicITPActors[m_iCinematicActorIndex] != none)
            {
                // End:0xAF
                if(LocalPlayer(Player) == none)
                {
                    CinematicITPActors[m_iCinematicActorIndex].SetOtherMeshSeat(m_iCinematicActorMeshIndex);                    
                }
                else
                {
                    CinematicITPActors[m_iCinematicActorIndex].SetFPMeshSeat(m_iCinematicActorMeshIndex);
                }
                SetViewTarget(CinematicITPActors[m_iCinematicActorIndex]);
            }
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local Rotator identityRot;

        super(Object).BeginState(PreviousStateName);
        SetRotation(identityRot);
        SetCameraMode('Cinematic');
        ClientSetCameraMode('Cinematic');
        ClientKillAndPurgeScoreBoard();
        // End:0x61
        if(IsLocalPlayerController())
        {
            WorldInfo.GameModified_bTurnOffMotionBlur = true;
        }
        SetITPMeshIndices(m_iCinematicActorIndex, m_iCinematicActorMeshIndex);
        // End:0xD9
        if(LocalPlayer(Player) != none)
        {
            MOHAHUD_MP(myHUD).SetupHudForITPandDead(true);
            ClientFadeIn(BlackPlaneFadeInDelay, BlackFadeInTime);
            PostProcessComponent.stopDying();
            EndDeathSound();
            PlayerEntersPlaneMPSequenceEventActivate();
        }
        m_bJumpedEventFired = false;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        // End:0x2F
        if(myHUD != none)
        {
            MOHAHUD_MP(myHUD).SetupHudForITPandDead(false);
        }
        // End:0x57
        if(IsLocalPlayerController())
        {
            WorldInfo.GameModified_bTurnOffMotionBlur = false;
            PlayerExitsPlaneSequenceEventActivate();
        }
        //return;        
    }

    simulated event CheckCinematicStatus()
    {
        // End:0x210
        if(((m_iCinematicActorIndex >= 0) && m_iCinematicActorIndex < CinematicITPActors.Length) && CinematicITPActors[m_iCinematicActorIndex] != none)
        {
            // End:0xF4
            if(int(WorldInfo.NetMode) != int(NM_Client))
            {
                // End:0xF4
                if(int(CinematicITPActors[m_iCinematicActorIndex].CurrentMeshActivities[m_iCinematicActorMeshIndex]) == int(4))
                {
                    // End:0xB0
                    if(WorldInfo.Game.IsA('AirborneTeamGameInfo'))
                    {
                        AirborneTeamGameInfo(WorldInfo.Game).RestartITPPlayer(self);
                    }
                    MOHAMultiplayerPawn(Pawn).AirDrop_DeployChuteEvent();
                    MOHAPlayerReplicationInfo(PlayerReplicationInfo).SetITPMeshIndices(-1, 0);
                    GotoState('AirDropDeployChute');
                }
            }
            // End:0x1F2
            if(((LocalPlayer(Player) != none) && m_bJumpedEventFired == false) && int(CinematicITPActors[m_iCinematicActorIndex].CurrentMeshActivities[m_iCinematicActorMeshIndex]) == int(3))
            {
                // End:0x1F2
                if((CinematicITPActors[m_iCinematicActorIndex].Meshes[m_iCinematicActorMeshIndex] != none) && CinematicITPActors[m_iCinematicActorIndex].Meshes[m_iCinematicActorMeshIndex].Animations.IsA('AnimNodeSequence'))
                {
                    // End:0x1F2
                    if(AnimNodeSequence(CinematicITPActors[m_iCinematicActorIndex].Meshes[m_iCinematicActorMeshIndex].Animations).CurrentTime >= CinematicITPActors[m_iCinematicActorIndex].fExitPlaneTimes[m_iCinematicActorMeshIndex])
                    {
                        m_bJumpedEventFired = true;
                        PlayerExitsPlaneSequenceEventActivate();
                    }
                }
            }
            // End:0x210
            if(IsLocalPlayerController())
            {
                WorldInfo.GameModified_bTurnOffMotionBlur = true;
            }
        }
        //return;        
    }

    simulated function float GetFireAxis()
    {
        return 0.0000000;
        //return ReturnValue;        
    }
Begin:

    stop;                
}

simulated state DeadRespawning extends Dead
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        ClientStartDyingFull();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x2B
        if(myHUD != none)
        {
            myHUD.SetbShowScores(false);
        }
        PostProcessComponent.stopDying();
        EndDeathSound();
        // End:0x66
        if(IsLocalPlayerController())
        {
            WorldInfo.GameModified_bTurnOffMotionBlur = false;
        }
        //return;        
    }
    stop;    
}

simulated state DeadWaitingForRespawn extends Dead
{
    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x2B
        if(myHUD != none)
        {
            myHUD.SetbShowScores(false);
        }
        //return;        
    }

    simulated function DrawHUD(HUD H)
    {
        super(PlayerController).DrawHUD(H);
        myDrawHUD(H);
        //return;        
    }
    stop;    
}

simulated state Dead
{
    reliable client simulated function LookAtKillerPawn()
    {
        // End:0x1F
        if(KillerPawn != none)
        {
            ClientSetViewTarget(KillerPawn, 1.5000000);
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x47
        if(myHUD != none)
        {
            MOHAHUD_MP(myHUD).SetupHudForITPandDead(true);
            MOHAHUD(myHUD).RemoveCSA();
        }
        m_iLowestHealthThisLife = 100;
        MPObjectiveClear();
        // End:0x77
        if(IsLocalPlayerController())
        {
            WorldInfo.GameModified_bTurnOffMotionBlur = true;
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        CleanOutSavedMoves();
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        bPressedJump = false;
        //return;        
    }

    simulated function DrawHUD(HUD H)
    {
        super(PlayerController).DrawHUD(H);
        myDrawHUD(H);
        //return;        
    }

    function RequestRespawn()
    {
        GotoState('DeadWaitingForRespawn');
        ServerPreReStartPlayer();
        //return;        
    }
Begin:

    // End:0x2E
    if(LocalPlayer(Player) != none)
    {
        // End:0x2E
        if(myHUD != none)
        {
            myHUD.PlayerOwnerDied();
        }
    }
    stop;        
}

state RoundEnded
{
    ignores RequestRespawn, StartDeathSound, KilledBy, TakeDamage, Suicide, StartFire, 
	    StartAltFire, FireWeaponAt, Reload, SwitchToBestWeapon, NextWeapon, 
	    SwitchWeapon, SwitchGammon, SwitchStick, SwitchFragGrenade, AimPress, 
	    LoadMG42Weapon;

    simulated function BeginState(name PreviousStateName)
    {
        MOHAPlayerPawn(Pawn).OwnerChangeVisibleMesh(false);
        PostProcessComponent.Reset();
        PostProcessComponent.startDying();
        ClientBlackOut();
        EndDeathSound();
        StartRoundOverSound();
        ClientSetSpawnText("", 0.0000000);
        ClientClearGameMessage();
        // End:0x9C
        if(int(m_DesiredWeapon) == int(0))
        {
            m_DesiredWeapon = 1;
            ServerSetDesiredPawnClass(1);
        }
        super.BeginState(PreviousStateName);
        // End:0x148
        if(myHUD != none)
        {
            // End:0xEB
            if(myHUD.ScoreBoard != none)
            {
                myHUD.ScoreBoard.Destroy();
                myHUD.ScoreBoard = none;
            }
            // End:0x148
            if(int(WorldInfo.NetMode) != int(NM_Client))
            {
                myHUD.SpawnScoreBoard(MOHAGameReplicationInfo(WorldInfo.GRI).PostGameScoreBoardType);
                myHUD.SetbShowScores(true);
            }
        }
        m_iLowestHealthThisLife = 100;
        Interactions[Interactions.Length] = m_oEndGameI;
        m_ObjectiveInFocus = none;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local int I;

        super.EndState(NextStateName);
        I = 0;
        J0x12:

        // End:0x50 [Loop If]
        if(I < Interactions.Length)
        {
            // End:0x46
            if(Interactions[I] == m_oEndGameI)
            {
                Interactions.Remove(I, 1);
                // [Explicit Break]
                goto J0x50;
            }
            I++;
            // [Loop Continue]
            goto J0x12;
        }
        J0x50:

        // End:0xF7
        if(myHUD != none)
        {
            myHUD.SetbShowScores(false, MOHAGameReplicationInfo(WorldInfo.GRI).RoundStatus != 2);
            // End:0xC8
            if(myHUD.ScoreBoard != none)
            {
                myHUD.ScoreBoard.Destroy();
                myHUD.ScoreBoard = none;
            }
            myHUD.SpawnScoreBoard(MOHAGameReplicationInfo(WorldInfo.GRI).InGameScoreBoardType);
        }
        ClientBlackOut();
        EndRoundOverSound();
        //return;        
    }

    reliable server function ServerRestartGame()
    {
        // End:0x50
        if(WorldInfo.Game.PlayerCanRestartGame(self))
        {
            WorldInfo.TimeSeconds = 0.0000000;
            WorldInfo.Game.ResetLevel();
        }
        //return;        
    }

    function bool CanBeSpectated()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function float GetFireAxis()
    {
        return 0.0000000;
        //return ReturnValue;        
    }
    stop;    
}

state Airdrop
{
    unreliable server function ServerMeleeKick()
    {
        // End:0x28
        if(MOHAMultiplayerPawn(Pawn) != none)
        {
            MOHAMultiplayerPawn(Pawn).AirDrop_MeleeEvent();
        }
        //return;        
    }

    event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
    {
        // End:0x42
        if(int(WorldInfo.NetMode) != int(NM_Client))
        {
            DoLanding();
            // End:0x42
            if(Pawn.IsLocallyControlled() == false)
            {
                ClientLand();
            }
        }
        return bUpdating;
        //return ReturnValue;        
    }

    function bool IsAirdroping()
    {
        return true;
        //return ReturnValue;        
    }

    exec function FlareChuteEnd(optional byte FireModeNum)
    {
        super.FlareChuteEnd(FireModeNum);
        //return;        
    }

    simulated function float GetFireAxis()
    {
        return 0.0000000;
        //return ReturnValue;        
    }

    simulated function BeginState(name PrevStateName)
    {
        super.BeginState(PrevStateName);
        // End:0x38
        if((IsLocalPlayerController()) && m_bJumpedEventFired == false)
        {
            m_bJumpedEventFired = true;
            PlayerExitsPlaneSequenceEventActivate();
        }
        //return;        
    }
    stop;    
}

state AirDropDeployChute extends Airdrop
{
    simulated event CheckAirdropChuteStatus()
    {
        // End:0xB9
        if(Pawn != none)
        {
            // End:0xB9
            if(((((Pawn.IsInState('AirDropControlledFall') || Pawn.IsInState('AirDropControlledFlare')) || Pawn.IsInState('AirDropHanging')) || Pawn.IsInState('AirDropCutChute')) || Pawn.IsInState('AirDropFreeFall')) || Pawn.IsInState('AirDropMelee'))
            {
                GotoState('Airdrop');
            }
        }
        //return;        
    }
    stop;    
}

state AirDropLanding
{
    reliable server function ServerTriggerLandingEvent()
    {
        //return;        
    }

    function PlayerMove(float fMoveDeltaSeconds, float fRotationDeltaSeconds)
    {
        // End:0x43
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(fMoveDeltaSeconds, fMoveDeltaSeconds, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));            
        }
        else
        {
            ProcessMove(fMoveDeltaSeconds, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
        }
        // End:0x8D
        if(fMoveDeltaSeconds != 0.0000000)
        {
            bSavedCrouchRequested = false;
            bSavedJumpRequested = false;
        }
        //return;        
    }

    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        // End:0x0D
        if(Pawn == none)
        {
            return;
        }
        // End:0x3B
        if(int(Role) == int(ROLE_Authority))
        {
            Pawn.SetRemoteViewPitch(Rotation.Pitch);
        }
        Pawn.Acceleration = newAccel;
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x5A
        if(((Pawn != none) && int(Pawn.Physics) != int(2)) && int(Pawn.Physics) != int(10))
        {
            Pawn.SetPhysics(1);
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        CleanOutSavedMoves();
        //return;        
    }

    function bool IsAirdroping()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function float GetFireAxis()
    {
        return 0.0000000;
        //return ReturnValue;        
    }
    stop;    
}

state PlayerUsingMPObjective
{
    simulated function BeginState(name PreviousStateName)
    {
        local array<string> LocalizedStringVars;

        // End:0x20
        if(m_ObjectiveInFocus == none)
        {
            GotoState(Pawn.LandMovementState);
            return;
        }
        // End:0x36
        if(m_ObjectiveInUse == none)
        {
            m_ObjectiveInUse = m_ObjectiveInFocus;
        }
        m_ObjectiveInUse.UseObjectiveSpecial(self);
        MOHAMultiplayerPawn(Pawn).MPObjective_Raise();
        // End:0xC5
        if(m_ObjectiveInUse.GetArmHoldTime() > float(0))
        {
            LocalizedStringVars[0] = string(int(m_ObjectiveInFocus.GetArmHoldTime()));
            ClientMessage(Class'Engine.FormattedString'.static.FormatLocalizedStringVars(ActivateObjectiveMsg, LocalizedStringVars));
        }
        //return;        
    }

    simulated function EndState(name NextState)
    {
        m_ObjectiveInUse.StopUseObjectiveSpecial(self);
        MOHAMultiplayerPawn(Pawn).MPObjective_Lower();
        m_iObjectiveTimer = -1.0000000;
        m_ObjectiveInUse = none;
        //return;        
    }

    event CheckObjectiveStatus(float DeltaTime)
    {
        // End:0x0D
        if(Pawn == none)
        {
            return;
        }
        // End:0x81
        if((m_ObjectiveInUse != none) && m_iObjectiveTimer > float(-1))
        {
            m_iObjectiveTimer += DeltaTime;
            // End:0x81
            if(int(WorldInfo.NetMode) != int(NM_Client))
            {
                // End:0x81
                if(m_iObjectiveTimer > m_ObjectiveInUse.GetArmHoldTime())
                {
                    StopObjTimer();
                    CheckObjectiveTrigger();
                }
            }
        }
        // End:0x96
        if(m_ObjectiveInUse == none)
        {
            StopObjTimer();
        }
        // End:0xD6
        if(bDemoChargeUseRelease)
        {
            ClientGotoState(Pawn.LandMovementState);
            GotoState(Pawn.LandMovementState);
            m_iObjectiveTimer = -1.0000000;
        }
        //return;        
    }

    exec function UseRelease()
    {
        StopObjTimer();
        //return;        
    }

    event PlayerTick(float DeltaTime)
    {
        global.PlayerTick(DeltaTime);
        //return;        
    }

    simulated function float GetFireAxis()
    {
        return 0.0000000;
        //return ReturnValue;        
    }

    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }
    stop;    
}

state WaitingForPawn
{
    event EndState(name NextStateName)
    {
        Class'Engine.TriggerVolume_SoundSpace'.static.ResetSoundSpaces();
        CheckandActivateSoundSpace(Pawn);
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state Spectating
{
    exec function Use()
    {
        ServerViewNextPlayer();
        //return;        
    }

    event CheckCinematicStatus()
    {
        // End:0x44
        if(int(WorldInfo.NetMode) != int(NM_Client))
        {
            // End:0x44
            if((ViewTargetPawn == none) || !ViewTargetPawn.bSpectatable)
            {
                ServerViewNextPlayer();
            }
        }
        //return;        
    }

    function Rotator LimitViewRotationPitchAndYaw(Rotator ViewRotation, float ViewPitchMin, float ViewPitchMax, float ViewYawMin, float ViewYawMax)
    {
        return ViewRotation;
        //return ReturnValue;        
    }

    function UpdateRotation(float DeltaTime)
    {
        super(PlayerController).UpdateRotation(DeltaTime);
        //return;        
    }

    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        super(PlayerController).ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        //return;        
    }

    function bool CanBeSpectated()
    {
        return false;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        SetCameraMode('Spectator');
        ClientSetCameraMode('Spectator');
        PlayerReplicationInfo.bIsSpectator = true;
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ViewTargetPawn = none;
        //return;        
    }

    unreliable server function ServerViewNextPlayer()
    {
        local int I, Index;
        local array<PlayerReplicationInfo> PRIArray;
        local Pawn P;

        return;
        // End:0x38
        if(WorldInfo.GRI != none)
        {
            WorldInfo.GRI.GetPRIArray(PRIArray);
        }
        Index = -1;
        // End:0x8F
        if(RealViewTarget != none)
        {
            I = 0;
            J0x55:

            // End:0x8F [Loop If]
            if(I < PRIArray.Length)
            {
                // End:0x85
                if(PRIArray[I] == RealViewTarget)
                {
                    Index = I;
                }
                ++I;
                // [Loop Continue]
                goto J0x55;
            }
        }
        // End:0x180
        if(Index < 0)
        {
            I = 0;
            J0xA1:

            // End:0x17D [Loop If]
            if(I < PRIArray.Length)
            {
                // End:0x173
                if((PRIArray[I].PlayerID != PlayerReplicationInfo.PlayerID) && PlayerReplicationInfo.Team.TeamIndex == PRIArray[I].Team.TeamIndex)
                {
                    P = Class'MOHAPlayerReplicationInfo'.static.GetPawnFromID(PRIArray[I].PlayerID);
                    // End:0x173
                    if(P != none)
                    {
                        SetViewTarget(PRIArray[I]);
                        SetViewTargetPawn(MOHAPawn(P));
                        return;
                    }
                }
                ++I;
                // [Loop Continue]
                goto J0xA1;
            }            
        }
        else
        {
            // End:0x19D
            if(Index >= (PRIArray.Length - 1))
            {
                I = 0;                
            }
            else
            {
                I = Index + 1;
            }
            J0x1AB:

            // End:0x2A3 [Loop If]
            if(I != Index)
            {
                // End:0x27C
                if((PRIArray[I].PlayerID != PlayerReplicationInfo.PlayerID) && PlayerReplicationInfo.Team.TeamIndex == PRIArray[I].Team.TeamIndex)
                {
                    P = Class'MOHAPlayerReplicationInfo'.static.GetPawnFromID(PRIArray[I].PlayerID);
                    // End:0x27C
                    if(P != none)
                    {
                        SetViewTarget(PRIArray[I]);
                        SetViewTargetPawn(MOHAPawn(P));
                        return;
                    }
                }
                // End:0x299
                if(I >= (PRIArray.Length - 1))
                {
                    I = 0;                    
                }
                else
                {
                    I++;
                }
                // [Loop Continue]
                goto J0x1AB;
            }
        }
        //return;        
    }

    function SetViewTargetPawn(MOHAPawn P)
    {
        // End:0x16
        if(P != none)
        {
            ViewTargetPawn = P;
        }
        //return;        
    }
    stop;    
}

state LadderLerp
{
    function PlayerMove(float DeltaTime, float fRotationDeltaSeconds)
    {
        local Vector newAccel;
        local Rotator Rot;

        // End:0x51
        if(((PlayerInput.aForward < float(0)) && MOHAMultiplayerPawn(Pawn) != none) && MOHAMultiplayerPawn(Pawn).CanBreakOut())
        {
            ExitLadder();
            return;
        }
        SetRotation(Pawn.Rotation);
        // End:0x95
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, DeltaTime, newAccel, 0, Rot);            
        }
        else
        {
            ProcessMove(DeltaTime, newAccel, 0, Rot);
        }
        bPressedJump = false;
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        IgnoreLookInput(true);
        //return;        
    }

    function EndState(name NextStateName)
    {
        IgnoreLookInput(false);
        //return;        
    }
    stop;    
}

state PlayerClimbing
{
    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        // End:0x0D
        if(Pawn == none)
        {
            return;
        }
        // End:0x56
        if((int(Role) == int(ROLE_Authority)) && int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            Pawn.SetRemoteViewPitch(Rotation.Pitch);
        }
        // End:0x77
        if(bJumpRequested)
        {
            MOHAMultiplayerPawn(Pawn).LadderJump();
        }
        Pawn.Acceleration = newAccel;
        //return;        
    }

    function PlayerMove(float DeltaTime, float fRotationDeltaSeconds)
    {
        local Vector X, Y, Z, newAccel;
        local Rotator OldRotation, ViewRotation;

        GetAxes(Rotation, X, Y, Z);
        // End:0x4E
        if((MOHAMultiplayerPawn(Pawn) != none) && MOHAMultiplayerPawn(Pawn).OnLadderMP != none)
        {
            newAccel = Vector(Rotation);
        }
        newAccel = (Pawn.AccelRate * Normal(newAccel)) * PlayerInput.aForward;
        ViewRotation = Rotation;
        SetRotation(ViewRotation);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime);
        // End:0xE3
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, DeltaTime, newAccel, 0, OldRotation - Rotation);            
        }
        else
        {
            ProcessMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
        }
        bPressedJump = false;
        //return;        
    }

    event BeginState(name PreviousStateName)
    {
        Pawn.ShouldCrouch(false);
        bPressedJump = false;
        //return;        
    }

    event EndState(name NextStateName)
    {
        // End:0x2F
        if(Pawn != none)
        {
            Pawn.SetRemoteViewPitch(0);
            Pawn.ShouldCrouch(false);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    MessageColor[0]=none
    MessageColor[1]=none
    MessageColor[2]=none
    MessageColor[3]=none
    MessageColor[4]=none
    MessageLifeTime=30
    MessageFadeTime=5
    BlackFadeInTime=1.0000000
    BlackPlaneFadeInDelay=1.0000000
    LookThroughStartSpotNotAirborne=1.5000000
    LookThroughStartSpotTimeAxis=1.5000000
    LookThroughStartSpotTimeAllied=1.0000000
    CinematicAdditionalWaitTime=1.5000000
    m_MaxPopupTimer=4
    m_iLowestHealthThisLife=100
    m_iObjectiveTimer=-1.0000000
    m_iCinematicActorIndex=-1
    m_iCinematicActorMeshIndex=-1
    MPWeaponIndexes[1]=2
    MPWeaponIndexes[3]=3
    MPWeaponIndexes[4]=6
    MPWeaponIndexes[8]=1
    MPWeaponIndexes[9]=10
    MPWeaponIndexes[13]=4
    MPWeaponIndexes[14]=8
    MPWeaponIndexes[17]=7
    MPWeaponIndexes[18]=5
    MPWeaponIndexes[19]=11
    MPWeaponIndexes[20]=9
    SpawnType=2
    ChangeTeamTag="PreGame_ChangeTeamMenu_PC"
    ChangeTeamConsoleTag="PreGame_ChangeTeamMenu_Console"
    ChangeWeaponTag="PreGame_ChangeWeaponMenu"
    m_iCachedTimeToRespawn=-1
    ActivateObjectiveMsg="Hold the 'A' button for %1 seconds to Trigger Objective"
    WaitingForPlayersMessage="Waiting for %1 player(s)... (%2 seconds left)"
    WaitingForRedeployMessage="Waiting for redeploy (%1 seconds)"
    MessageRedeployBlocked="Redeploy Blocked"
    MessageCanNotSwitchTeams="You can't switch teams now!"
    MessageKillAssistReceived="Kill Assist Received"
    MessageDeserted="%1 deserted"
    MessageSuicide="%1 is no more"
    MessageKilled="%1 killed %2"
    MessageKilledBySniper="%1 sniped %2"
    MessageKilledByGrenade="%1 detonated %2"
    MessageKilledByAntiTank="%1 blew up %2"
    MessageKilledBySMG="%1 perforated %2"
    MessageKilledByFallDamage="%1 kissed the dirt"
    MessageKilledByRifle="%1 shot %2"
    MessageKilledByAutoRifle="%1 unloaded into %2"
    MessageKilledByMelee="%1 smacked down %2"
    MessageKilledByPistolMelee="%1 pistol-whipped %2"
    MessageKilledByInAirMelee="%1 fed %2 his boot"
    MessageKilledByPistolInAir="%1 capped %2 out of the sky"
    MessageKilledBySniperInAir="%1 sniped %2 out of the sky"
    MessageKilledByGrenadeInAir="%1 flak-blasted %2 out of the sky"
    MessageKilledByAntiTankInAir="%1 blasted %2 out of the sky"
    MessageKilledBySMGInAir="%1 perforated %2 out of the sky"
    MessageKilledByPistolMeleeInAir="%1 pistol-whipped %2 out of the sky"
    MessageKilledByMeleeInAir="%1 smacked %2 out of the sky"
    MessageKilledByAutoRifleInAir="%1 ripped %2 out of the sky"
    MessageKilledByRifleInAir="%1 shot %2 out of the sky"
    MessageTeamKilled="%1 team killed %2"
    SuddenDeathMessage="Sudden Death!"
    TimeRunningOutMessage="Time is running out."
    MessagesForFlags[0]="Neutralizing Flag"
    MessagesForFlags[1]="Flag being Neutralized"
    MessagesForFlags[2]="Flag in Contention"
    MessagesForFlags[3]="Two Soldiers Required To Take This Flag"
    MessagesForFlags[4]="Flag Controlled\n"
    MessagesForFlags[5]="Capturing Flag"
    MOHAVoiceChatStrings[0]="Move in!"
    MOHAVoiceChatStrings[1]="Fall back!"
    MOHAVoiceChatStrings[2]="Attack right flank!"
    MOHAVoiceChatStrings[3]="Attack left flank!"
    MOHAVoiceChatStrings[4]="Stay together!"
    MOHAVoiceChatStrings[5]="Affirmative"
    MOHAVoiceChatStrings[6]="Negative"
    MOHAVoiceChatStrings[7]="Thank you"
    MOHAVoiceChatStrings[8]="Sorry"
    MOHAVoiceChatStrings[9]="Follow me"
    MOHAVoiceChatStrings[10]="Enemy spotted!"
    MOHAVoiceChatStrings[11]="Sniper spotted!"
    MOHAVoiceChatStrings[12]="AntiArmor spotted"
    MOHAVoiceChatStrings[13]="Enemy above!"
    MOHAVoiceChatStrings[14]="Enemy down!"
    MOHAVoiceChatStrings[15]="We are losing a flag."
    MOHAVoiceChatStrings[16]="Capture the flag."
    MOHAVoiceChatStrings[17]="Defend the flag."
    MOHAVoiceChatStrings[18]="I will defend the flag."
    MOHAVoiceChatStrings[19]="Need help capturing flag."
    MOHAVoiceChatStrings[20]="Is that all you got?"
    MOHAVoiceChatStrings[21]="I think that they are all out of real men!"
    MOHAVoiceChatStrings[22]="They're a bunch of cowards!"
    MOHAVoiceChatStrings[23]="We need tougher opponents!"
    MOHAVoiceChatStrings[24]="I've seen french school girls shoot better!"
    MOHAVoiceTeamString="(TEAM)"
    SanityValueForDistanceOnHurtRadius=7500.0000000
    MPPlayerStats[0]=(updateType=3,statName="RANK_POINTS",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[1]=(updateType=1,statName="RANK_POINTS",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[2]=(updateType=3,statName="FINISH_FIRST",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[3]=(updateType=3,statName="FINISH_SECOND",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[4]=(updateType=3,statName="FINISH_THIRD",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[5]=(updateType=1,statName="KILLSTREAK",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[6]=(updateType=1,statName="DEATHSTREAK",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[7]=(updateType=3,statName="ACTIVE_NOTKS_STREAK",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[8]=(updateType=3,statName="AIRBORNE_MELEE_KILLS",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[9]=(updateType=3,statName="MELEE_DEATHS",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[10]=(updateType=3,statName="W_GRENADE_THROWN",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[11]=(updateType=3,statName="W_GRENADE_KILLS",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[12]=(updateType=3,statName="W_GRENADE_DEATHS",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[13]=(updateType=3,statName="UNIT_DISTINGUISHED",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[14]=(updateType=3,statName="UNIT_MERITORIOUS",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[15]=(updateType=3,statName="EOM_ACCURATE",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[16]=(updateType=3,statName="EOM_DEADLIEST",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[17]=(updateType=3,statName="EOM_HEADSHOTS",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[18]=(updateType=3,statName="EOM_KILLSTREAK",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[19]=(updateType=3,statName="EOM_OBJECTIVE",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[20]=(updateType=3,statName="EOM_USELESS",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[21]=(updateType=3,statName="EOM_DEATHSTREAK",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[22]=(updateType=3,statName="EOM_SUICIDAL",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[23]=(updateType=3,statName="EOM_RIFLE",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[24]=(updateType=3,statName="EOM_SMG",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[25]=(updateType=3,statName="EOM_AUTO",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[26]=(updateType=3,statName="EOM_SNIPER",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[27]=(updateType=3,statName="EOM_ATANK",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[28]=(updateType=3,statName="GAME_TYPE_TEAM_MAP_TIME",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[29]=(updateType=3,statName="GAME_TYPE_TEAM_MAP_GAMES",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[30]=(updateType=3,statName="GAME_TYPE_TEAM_MAP_WINS",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[31]=(updateType=3,statName="GAME_TYPE_TEAM_MAP_LOSSES",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[32]=(updateType=3,statName="GAME_TYPE_TEAM_MAP_SCORE",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[33]=(updateType=1,statName="GAME_TYPE_TEAM_MAP_HIGHSCORE",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[34]=(updateType=3,statName="GAME_TYPE_TEAM_MAP_OBJPTS",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[35]=(updateType=3,statName="GAME_TYPE_TEAM_MAP_TEAMPTS",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[36]=(updateType=3,statName="GAME_TYPE_TEAM_MAP_KILLS",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[37]=(updateType=3,statName="GAME_TYPE_TEAM_MAP_DEATHS",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[38]=(updateType=3,statName="GAME_TYPE_TEAM_MAP_SUICIDES",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[39]=(updateType=3,statName="GAME_TYPE_TEAM_MAP_TEAMKILLS",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[40]=(updateType=3,statName="GAME_TYPE_TEAM_MAP_KILLASST",statValue=0.0000000,StatPeriodFlags=0)
    MPPlayerStats[41]=(updateType=2,statName="GAME_TYPE_TEAM_MAP_BESTRANK",statValue=0.0000000,StatPeriodFlags=0)
    MPWeaponStats[0]=(updateType=3,statName="W_WEAPON_TIME",statValue=0.0000000,StatPeriodFlags=0)
    MPWeaponStats[1]=(updateType=3,statName="W_WEAPON_HITS",statValue=0.0000000,StatPeriodFlags=0)
    MPWeaponStats[2]=(updateType=3,statName="W_WEAPON_SHOTS",statValue=0.0000000,StatPeriodFlags=0)
    MPWeaponStats[3]=(updateType=3,statName="W_WEAPON_KILLS",statValue=0.0000000,StatPeriodFlags=0)
    MPWeaponStats[4]=(updateType=3,statName="W_WEAPON_MELEE_KILLS",statValue=0.0000000,StatPeriodFlags=0)
    MPWeaponStats[5]=(updateType=3,statName="W_WEAPON_DEATHS",statValue=0.0000000,StatPeriodFlags=0)
    MPWeaponStats[6]=(updateType=3,statName="W_WEAPON_MELEE_DEATHS",statValue=0.0000000,StatPeriodFlags=0)
    MPWeaponStats[7]=(updateType=3,statName="W_WEAPON_HITS_HEAD",statValue=0.0000000,StatPeriodFlags=0)
    MPWeaponStats[8]=(updateType=3,statName="W_WEAPON_HITS_RARM",statValue=0.0000000,StatPeriodFlags=0)
    MPWeaponStats[9]=(updateType=3,statName="W_WEAPON_HITS_LARM",statValue=0.0000000,StatPeriodFlags=0)
    MPWeaponStats[10]=(updateType=3,statName="W_WEAPON_HITS_TORSO",statValue=0.0000000,StatPeriodFlags=0)
    MPWeaponStats[11]=(updateType=3,statName="W_WEAPON_HITS_CROTCH",statValue=0.0000000,StatPeriodFlags=0)
    MPWeaponStats[12]=(updateType=3,statName="W_WEAPON_HITS_LLEG",statValue=0.0000000,StatPeriodFlags=0)
    MPWeaponStats[13]=(updateType=3,statName="W_WEAPON_HITS_RLEG",statValue=0.0000000,StatPeriodFlags=0)
    MPWeaponClassStat=(updateType=3,statName="WC_WEAPONCLASS_EXP",statValue=0.0000000,StatPeriodFlags=0)
    WeaponNames[0]="GARAND"
    WeaponNames[1]="K98K"
    WeaponNames[2]="THOMPSON"
    WeaponNames[3]="MP40"
    WeaponNames[4]="BAR"
    WeaponNames[5]="STG44"
    WeaponNames[6]="SPRINGFIELD"
    WeaponNames[7]="G43"
    WeaponNames[8]="BAZOOKA"
    WeaponNames[9]="PANZER"
    WeaponNames[10]="M1911"
    WeaponNames[11]="MAUSER"
    WeaponClassNames[1]="PISTOL"
    WeaponClassNames[2]="RIFLE"
    WeaponClassNames[3]="SMG"
    WeaponClassNames[4]="SNIPER"
    WeaponClassNames[5]="ATANK"
    WeaponClassNames[8]="AUTO"
    ModeAbbr[0]="AB"
    ModeAbbr[1]="DM"
    ModeAbbr[2]="ADM"
    TeamNames[0]="ALLIES"
    TeamNames[1]="AXIS"
    MapAbbr[0]="REM"
    MapAbbr[1]="HNT"
    MapAbbr[2]="VIL"
    MapAbbr[3]="AVA"
    MapAbbr[4]="NEP"
    MapAbbr[5]="HUS"
    ScoreDelta[0]=110
    ScoreDelta[1]=100
    ScoreDelta[2]=90
    ScoreDelta[3]=80
    ScoreDelta[4]=70
    ScoreDelta[5]=60
    ScoreDelta[6]=50
    ScoreDelta[7]=40
    ScoreDelta[8]=30
    ScoreDelta[9]=20
    ScoreDelta[10]=10
    LossFactor[0]=0.1000000
    LossFactor[1]=0.3000000
    LossFactor[2]=0.5000000
    LossFactor[3]=0.7000000
    LossFactor[4]=0.8000000
    LossFactor[5]=0.9000000
    LossFactor[6]=1.0000000
    LossFactor[7]=1.0000000
    LossFactor[8]=1.0000000
    LossFactor[9]=1.0000000
    LossFactor[10]=1.0000000
    LossFactor[11]=1.0000000
    LossFactor[12]=1.0000000
    LossFactor[13]=1.0000000
    LossFactor[14]=1.0000000
    LossFactor[15]=1.0000000
    LossFactor[16]=1.0000000
    LossFactor[17]=1.0000000
    LossFactor[18]=1.0000000
    LossFactor[19]=1.0000000
    WinFactor[0]=1.0000000
    WinFactor[1]=1.0000000
    WinFactor[2]=1.0000000
    WinFactor[3]=1.0000000
    WinFactor[4]=1.0000000
    WinFactor[5]=1.0000000
    WinFactor[6]=1.0000000
    WinFactor[7]=1.0000000
    WinFactor[8]=1.0000000
    WinFactor[9]=1.0000000
    WinFactor[10]=1.0000000
    WinFactor[11]=1.0000000
    WinFactor[12]=1.0000000
    WinFactor[13]=0.9000000
    WinFactor[14]=0.8000000
    WinFactor[15]=0.7000000
    WinFactor[16]=0.5000000
    WinFactor[17]=0.5000000
    WinFactor[18]=0.5000000
    WinFactor[19]=0.5000000
    RankThresholds[0]=30
    RankThresholds[1]=60
    RankThresholds[2]=120
    RankThresholds[3]=180
    RankThresholds[4]=240
    RankThresholds[5]=300
    RankThresholds[6]=400
    RankThresholds[7]=700
    RankThresholds[8]=1000
    RankThresholds[9]=1300
    RankThresholds[10]=1600
    RankThresholds[11]=2000
    RankThresholds[12]=2400
    RankThresholds[13]=2800
    RankThresholds[14]=3200
    RankThresholds[15]=3700
    RankThresholds[16]=4100
    RankThresholds[17]=4500
    RankThresholds[18]=4900
    // Reference: MOHAPlayerStatsComponent'Default__MOHAMultiplayerController.PlayerStatsComponent'
    begin object name=PlayerStatsComponent
    end object
    playerStats=PlayerStatsComponent
    // Reference: MOHAPostProcessComponent'Default__MOHAMultiplayerController.PostProcessComponent0'
    begin object name=PostProcessComponent0
    end object
    PostProcessComponent=PostProcessComponent0
    // Reference: KynapseEntityComponent'Default__MOHAMultiplayerController.KynapsePlayerEnt0'
    begin object name=KynapsePlayerEnt0
    end object
    KynapseEntityComponent=KynapsePlayerEnt0
    // Reference: StimulusComponent'Default__MOHAMultiplayerController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    InGameMenu=UIScene'MP_UI_InGameMenu.InGameMenu'
    CameraClass=Class'MOHAMultiplayerCamera'
    TargetEyeHeight=75.0000000
    SavedMoveClass=Class'MohaSavedMove'
    // Reference: CylinderComponent'Default__MOHAMultiplayerController.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAMultiplayerController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=Stimulus0
    Components[3]=PlayerStatsComponent
    Components[4]=PostProcessComponent0
    bNetOwner=true
    CollisionComponent=CollisionCylinder
}