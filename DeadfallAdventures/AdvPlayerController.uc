class AdvPlayerController extends EvilPlayerController
    native(PC)
    config(Game)
    hidecategories(Navigation);

const GS_USERNAME_MAXLENGTH = 15;
const GS_PASSWORD_MAXLENGTH = 30;
const GS_MESSAGE_MAXLENGTH = 255;
const GS_EMAIL_MAXLENGTH = 50;
const GS_CDKEY_PART_MAXLENGTH = 4;
const CONTEXT_GAME_MODE = 0x0000800B;
const CONTEXT_BOTSKILL = 30;
const CONTEXT_MAPNAME = 31;
const CONTEXT_PURESERVER = 36;
const CONTEXT_LOCKEDSERVER = 37;
const CONTEXT_VSBOTS = 38;
const CONTEXT_CAMPAIGN = 39;
const CONTEXT_FORCERESPAWN = 40;
const CONTEXT_ALLOWKEYBOARD = 41;
const CONTEXT_FULLSERVER = 42;
const CONTEXT_EMPTYSERVER = 43;
const CONTEXT_DEDICATEDSERVER = 44;
const CONTEXT_MAPNAME_CUSTOM = 0;
const CONTEXT_BOTSKILL_NOVICE = 0;
const CONTEXT_BOTSKILL_AVERAGE = 1;
const CONTEXT_BOTSKILL_EXPERIENCED = 2;
const CONTEXT_BOTSKILL_SKILLED = 3;
const CONTEXT_BOTSKILL_ADEPT = 4;
const CONTEXT_BOTSKILL_MASTERFUL = 5;
const CONTEXT_BOTSKILL_INHUMAN = 6;
const CONTEXT_BOTSKILL_GODLIKE = 7;
const CONTEXT_GOALSCORE_5 = 0;
const CONTEXT_GOALSCORE_10 = 1;
const CONTEXT_GOALSCORE_15 = 2;
const CONTEXT_GOALSCORE_20 = 3;
const CONTEXT_GOALSCORE_30 = 4;
const CONTEXT_NUMBOTS = 0;
const CONTEXT_NUMBOTS_1 = 1;
const CONTEXT_NUMBOTS_2 = 2;
const CONTEXT_NUMBOTS_3 = 3;
const CONTEXT_NUMBOTS_4 = 4;
const CONTEXT_NUMBOTS_5 = 5;
const CONTEXT_NUMBOTS_6 = 6;
const CONTEXT_NUMBOTS_7 = 7;
const CONTEXT_NUMBOTS_8 = 8;
const CONTEXT_TIMELIMIT_5 = 0;
const CONTEXT_TIMELIMIT_10 = 1;
const CONTEXT_TIMELIMIT_15 = 2;
const CONTEXT_TIMELIMIT_20 = 3;
const CONTEXT_TIMELIMIT_30 = 4;
const CONTEXT_PURESERVER_NO = 0;
const CONTEXT_PURESERVER_YES = 1;
const CONTEXT_PURESERVER_ANY = 2;
const CONTEXT_QUICKSEARCH_NO = 0;
const CONTEXT_QUICKSEARCH_YES = 1;
const CONTEXT_QUICKSEARCH_ANY = 2;
const CONTEXT_LOCKEDSERVER_NO = 0;
const CONTEXT_LOCKEDSERVER_YES = 1;
const CONTEXT_CAMPAIGN_NO = 0;
const CONTEXT_CAMPAIGN_YES = 1;
const CONTEXT_FORCERESPAWN_NO = 0;
const CONTEXT_FORCERESPAWN_YES = 1;
const CONTEXT_ALLOWKEYBOARD_NO = 0;
const CONTEXT_ALLOWKEYBOARD_YES = 1;
const CONTEXT_ALLOWKEYBOARD_ANY = 2;
const CONTEXT_FULLSERVER_NO = 0;
const CONTEXT_FULLSERVER_YES = 1;
const CONTEXT_EMPTYSERVER_NO = 0;
const CONTEXT_EMPTYSERVER_YES = 1;
const CONTEXT_DEDICATEDSERVER_NO = 0;
const CONTEXT_DEDICATEDSERVER_YES = 1;
const CONTEXT_VSBOTS_NONE = 0;
const CONTEXT_VSBOTS_1_TO_2 = 1;
const CONTEXT_VSBOTS_1_TO_1 = 2;
const CONTEXT_VSBOTS_3_TO_2 = 3;
const CONTEXT_VSBOTS_2_TO_1 = 4;
const CONTEXT_VSBOTS_3_TO_1 = 5;
const CONTEXT_VSBOTS_4_TO_1 = 6;
const PROPERTY_NUMBOTS = 0x100000F7;
const PROPERTY_GOALSCORE = 0x100000F8;
const PROPERTY_TIMELIMIT = 0x100000F9;
const PROPERTY_ROUNDSTOWIN = 0x100000FA;
const PROPERTY_SCOREFORWIN = 0x100000FB;
const PROPERTY_XPFORWIN = 0x100000FC;
const PROPERTY_ADVERTISEDMAPNAME = 0x100000FD;
const PROPERTY_LEADERBOARDRATING = 0x20000004;
const PROPERTY_EPICMUTATORS = 0x10000105;
const PROPERTY_CUSTOMMAPNAME = 0x40000001;
const PROPERTY_CUSTOMGAMEMODE = 0x40000002;
const PROPERTY_SERVERDESCRIPTION = 0x40000003;
const PROPERTY_CUSTOMMUTATORS = 0x40000004;
const PROPERTY_JIP_ALLOWED = 0x40000005;
const QUERY_DM = 0;
const QUERY_TDM = 1;
const QUERY_CTF = 2;
const QUERY_SV = 3;
const QUERY_CUSTOM = 4;
const QUERY_QUICK = 5;
const STATS_VIEW_DM_PLAYER_ALLTIME = 1;
const STATS_VIEW_DM_RANKED_ALLTIME = 2;
const STATS_VIEW_DM_WEAPONS_ALLTIME = 3;
const STATS_VIEW_DM_VEHICLES_ALLTIME = 4;
const STATS_VIEW_DM_VEHICLEWEAPONS_ALLTIME = 5;
const STATS_VIEW_DM_VEHICLES_RANKED_ALLTIME = 6;
const STATS_VIEW_DM_VEHICLEWEAPONS_RANKED_ALLTIME = 7;
const STATS_VIEW_DM_WEAPONS_RANKED_ALLTIME = 8;
const PROPERTY_PLAYLISTID = 0x1000000B;
const PROPERTY_DATACENTERID = 0x1000001F;
const PROPERTY_PLAYLISTMANAGERVERSION = 0x10000020;
const PROPERTY_GAMERLOCALE = 0x1000009E;
const PROPERTY_MATCHXPLEVEL = 0x1000009F;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE1 = 13;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE2 = 14;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE3 = 15;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE4 = 16;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE5 = 17;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE6 = 18;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE7 = 19;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE8 = 20;
const CONTEXT_PARTYSLOT_BLOCKED = 0;
const CONTEXT_PARTYSLOT_WANTS = 1;
const CONTEXT_PARTYSLOT_NEEDS = 2;
const CONTEXT_PARTYSLOT_ANY = 3;
const CONTEXT_PARTYSLOT_1 = 2;
const CONTEXT_PARTYSLOT_2 = 3;
const CONTEXT_PARTYSLOT_3 = 4;
const CONTEXT_PARTYSLOT_4 = 5;
const CONTEXT_PARTYSLOT_5 = 6;
const CONTEXT_MODULOSTEP = 12;
const CONTEXT_MODULOSTEP_MODULOSTEP = 0;
const CONTEXT_MODULOSTEP_MODULOSTEP_1 = 1;
const CONTEXT_MODULOSTEP_MODULOSTEP_2 = 2;
const CONTEXT_MODULOSTEP_MODULOSTEP_3 = 3;
const CONTEXT_MODULOSTEP_MODULOSTEP_4 = 4;
const CONTEXT_MODULOSTEP_MODULOSTEP_5 = 5;
const CONTEXT_MODULOSTEP_MODULOSTEP_6 = 6;
const CONTEXT_MODULOSTEP_MODULOSTEP_7 = 7;
const CONTEXT_MODULOSTEP_MODULOSTEP_8 = 8;
const CONTEXT_MODULOSTEP_MODULOSTEP_9 = 9;
const CONTEXT_MODULOSTEP_MODULOSTEP_ANY = 10;
const MAX_CUSTOM_MESSAGES = 10;

enum EInviteAcceptanceError
{
    eInviteError_NoError,           // 0
    eInviteError_DefaultError,      // 1
    eInviteError_NotEnoughSpaceInPartyInvite,// 2
    eInviteError_NotAllPlayersCanJoinInvite,// 3
    eInviteError_NotEnoughSpaceInGameToJoin,// 4
    eInviteError_GameJIPFailed,     // 5
    eInviteError_GameJIPFailedMissingPlaylistDLC,// 6
    eInviteError_GameJIPFailedMissingPlaylistDLCParty,// 7
    eInviteError_GameJIPFailedMissingMapDLC,// 8
    eInviteError_GameJIPFailedMissingMapDLCParty,// 9
    eInviteError_MismatchedPlaylistVer,// 10
    eInviteError_NotAllowedPlaylist,// 11
    eInviteError_NotAllowedPlaylistLevelTooLow,// 12
    eInviteError_NotAllowedPlaylistPartyLevelTooLow,// 13
    eInviteError_NotAllowedPlaylistLevelTooHigh,// 14
    eInviteError_NotAllowedPlaylistPartyLevelTooHigh,// 15
    eInviteError_MAX                // 16
};

struct native TTreasurePerkPathInfo
{
    var int CurrentLevel;
    var array<int> LevelCost;

    structdefaultproperties
    {
        CurrentLevel=0
        LevelCost=none
    }
};

struct native TTreasurePerkInfo
{
    var string PerkClassName;
    var array<TTreasurePerkPathInfo> PerkPath;

    structdefaultproperties
    {
        PerkClassName=""
        PerkPath=none
    }
};

struct native SHintsType
{
    var config string HintsPrefix;
    var config int HintsCount;

    structdefaultproperties
    {
        HintsPrefix=""
        HintsCount=0
    }
};

struct AmmoStoreRecord
{
    var array<int> Amount;
    var string WeaponClassString;

    structdefaultproperties
    {
        Amount=none
        WeaponClassString=""
    }
};

struct PerkPathRecord
{
    var array<int> Level;

    structdefaultproperties
    {
        Level=none
    }
};

struct ObjectiveIconRecord
{
    var string TargetPathName;
    var string Type;

    structdefaultproperties
    {
        TargetPathName=""
        Type=""
    }
};

struct CheckpointRecord
{
    var Guid SavedGuid;
    var name CheckpointName;
    var Vector Location;
    var Rotator Rotation;
    var string PawnPathName;
    var string PawnClassName;
    var byte TeamIndex;
    var bool bCinematicMode;
    var bool bHidePlayer;
    var bool bAdjustMoveInput;
    var bool bAdjustLookInput;
    var bool bAffectsHUD;
    var array<InventoryRecord> InventoryRecords;
    var array<AmmoStoreRecord> AmmoStoreRecords;
    var int MonstersKilled;
    var int AmmoFound;
    var int BonusItems;
    var int SecretsFound;
    var int PlayerMoneyFound;
    var int DestroyedObjects;
    var int MonsterHitCounter;
    var int ShotsCounter;
    var int StakeShotCounter;
    var int StakeGunHits;
    var int TreasuresCollected;
    var array<int> TreasuresPerTypeCollected;
    var array<int> TreasuresPerTypeAvailable;
    var array<PerkPathRecord> TreasuresPerkPathLevels;
    var array<int> ItemsCount;
    var array<ObjectiveIconRecord> ObjectiveIcons;
    var bool bPlayerGotSomeDamage;
    var EvilTypesNative.EDifficultyLevel PuzzleDifficultyLevel;
    var EvilTypesNative.EDifficultyLevel FightDifficultyLevel;
    var int GRIBonusItemsFromFallenEnemy;
    var int GRIGameplayTime;
    var LevelStatistics CurrentLevelStatistics;
    var int Health;
    var int HealthMax;
    var bool bFlashlightOn;
    var bool bFireModeSwitch;
    var bool bPlayingMusic;
    var bool bPlayingBattleMusic;
    var array<MusicTrackStruct> BattleMusic;
    var array<MusicTrackStruct> AmbientMusic;
    var array<string> BattleCues;
    var array<string> AmbientCues;
    var float MusicPlaybackTime;
    var array<InventoryElement> SavedInventoryElements;

    structdefaultproperties
    {
        SavedGuid=(A=0,B=0,C=0,D=0)
        CheckpointName="None"
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        PawnPathName=""
        PawnClassName=""
        TeamIndex=0
        bCinematicMode=false
        bHidePlayer=false
        bAdjustMoveInput=false
        bAdjustLookInput=false
        bAffectsHUD=false
        InventoryRecords=none
        AmmoStoreRecords=none
        MonstersKilled=0
        AmmoFound=0
        BonusItems=0
        SecretsFound=0
        PlayerMoneyFound=0
        DestroyedObjects=0
        MonsterHitCounter=0
        ShotsCounter=0
        StakeShotCounter=0
        StakeGunHits=0
        TreasuresCollected=0
        TreasuresPerTypeCollected=none
        TreasuresPerTypeAvailable=none
        TreasuresPerkPathLevels=none
        ItemsCount=none
        ObjectiveIcons=none
        bPlayerGotSomeDamage=false
        PuzzleDifficultyLevel=EDifficultyLevel.DL_Low
        FightDifficultyLevel=EDifficultyLevel.DL_Low
        GRIBonusItemsFromFallenEnemy=0
        GRIGameplayTime=0
        CurrentLevelStatistics=(GameplayTime=0,Difficulty=EDifficultyLevel.DL_Low,MonstersKilled=0,GoldFound=0,BonusItems=0,AmmoFound=0,ObjectsDestroyed=0,SecretsFound=0,TotalMonsters=0,TotalAmmo=0,TotalObjects=0,TotalSecrets=0)
        Health=0
        HealthMax=0
        bFlashlightOn=false
        bFireModeSwitch=false
        bPlayingMusic=false
        bPlayingBattleMusic=false
        BattleMusic=none
        AmbientMusic=none
        BattleCues=none
        AmbientCues=none
        MusicPlaybackTime=0.0000000
        SavedInventoryElements=none
    }
};

struct native TObjectiveIconStorage
{
    var Actor Target;
    var string Type;

    structdefaultproperties
    {
        Target=none
        Type=""
    }
};

var AdvPlayerPawnMP MyAdvPlayerPawnMP;
var AdvProfileSettings ProfileSettings;
var AdvPlayerPersistentData PersistentData;
var bool bPersistentDataReadComplete;
var transient bool bHasSigninChanged;
var bool bDeathLocationNotValid;
var() bool bShowSpeedMeter;
var bool bFlashlightOn;
var() config bool bFireModeSwitch;
var transient bool bPlayerGotSomeDamage;
var bool bIsReturningFromMatch;
var bool bIsReturningToMainMenu;
var bool bShowingTutorial;
var transient bool bWinnerOfTheMatch;
var transient bool bLastSprintState;
var bool bDOFActive;
var bool bDeactivateBlock;
var transient bool bMatineeCameraFadeIn;
var transient bool bMatineeCameraFadeActive;
var bool bMatineeAlphaIsReset;
var config bool bStartLevelAfterKeyPress;
var bool bSeamlessTravel;
var bool bCloseLoadingScreen;
var transient bool bWasLocalSystemOrPrivate;
var bool bWritingToLeaderboardsCompleted;
var config bool bHasPreorder;
var const localized string LevelUpMsg;
var AdvGFxHudWrapper AdvHudWrapper;
var int CrosshairIndex;
var transient int CurrentLevelMonsterHitCounter;
var transient int CurrentLevelShotsCount;
var transient int StakeGunShots;
var transient int StakeGunHits;
var UniqueNetId LobbyUID;
var array<byte> QuickActionCustom1;
var array<byte> QuickActionCustom2;
var array<CustomWeaponSelectInfo> CustomWeaponMapping;
var array<string> CustomMessages;
var transient AdvPartyGameSettings NewPartySettings;
var() SoundMode BulletTimeSoundMode;
var int VoiceChannel;
var AdvWeatherEffectActor WeatherEffect;
var private EvilTypesNative.EDifficultyLevel PuzzleDifficultyLevel;
var private EvilTypesNative.EDifficultyLevel FightDifficultyLevel;
var() EvilTypesNative.EDifficultyLevel FocusMaxDifficultyLevel;
var byte DownloadedDLCS[EDLCIdentifiers];
var transient EvilPlayerController.EAlienFxMode actualMode;
var transient EvilPlayerController.EAlienFxLight actualLight;
var SoundCue LastBreathStartCue;
var SoundCue LastBreathEndCue;
var SoundCue LastBreathAmbientCue;
var export editinline AudioComponent LastBreathAmbientComponent;
var SoundCue ExplosionStunStartCue;
var SoundCue ExplosionStunEndCue;
var SoundCue ExplosionStunAmbientCue;
var export editinline AudioComponent ExplosionStunAmbientComponent;
var() float OverrideFOV;
var() float OverrideFOVRate;
var() class<AdvInventoryItem_Base> NotepadFocusTriggerItemClass;
var() float FocusFOV;
var() float FocusFOVRate;
var() float FocusVignetteScale;
var() LinearColor FocusSelDesatExceptionColor;
var() Vector2D FocusSelDesatThresholds;
var() float FocusSelDesatScale;
var transient Rotator MatineeCameraRotation;
var transient Rotator MatineeCameraViewRotation;
var transient float MatineeCameraFadeDuration;
var transient float MatineeCameraFadeStartTime;
var transient TPOV PrevPlayerPOV;
var float MatineeInterpolationAlpha;
var PostProcessSettings AimPPOverride;
var float HostMigrationScore;
var float StartMovingSmoothTime;
var TTreasurePerkInfo TreasurePerks[ETreasureType];
var config string MultiLoadingMovie;
var config string InfoLoadingMovie;
var config string HintsPackage;
var config string HintsSection;
var config SHintsType GeneralHints;
var config SHintsType TrapsHints;
var config SHintsType KillstreakHints;
var config SHintsType AWUHints;
var config SHintsType THHints;
var config SHintsType TTHHints;
var config SHintsType OracleHints;
var config SHintsType CTAHints;
var config SHintsType LMSHints;
var config SHintsType SVHints;
var config SHintsType TrapsSVHints;
var config SHintsType SPHintsInfo;
var config SHintsType SPHintsTips;
var AdvGfxMoviePlayer DEMOHelpScreen;
var class<AdvFocusHighlightComponent> HighlightComponentClass;
var array<TObjectiveIconStorage> ObjectiveIconStorage;
var UniqueNetId HostId;
var AdvPersistentPartyBeaconClient ClientPersistentPartyBeacon;
var PartyBeaconClient PendingJIPClientReservationBeacon;
var OnlineGameSearch PendingJIPGameSearch;
var UniqueNetId InvitePartyHostOwnerId;
var OnlineGameSearchResult InviteFailCache;
var int InviteReplyCounter;
var transient UniqueNetId ReturnToPartyRequestingId;
var delegate<OnWriteStatsAndEndSessionCompleteDelegate> WriteStatsAndEndSessionDelegate;
var transient Color actualColor;
var transient float actualDuration;
var transient float typeMod;
var transient float takeDamageDuration;
var transient float killDuration;
var transient float compassDuration;
var transient float afterPickTreasureDuration;
var transient float criticalHealthDuration;
var transient float criticalHealthDurationModifier;
var transient float afterDeathDuration;
var transient float minBlinkTime;
var transient float impulseBlinkModifier;
var AdvLeaderboard_Read_Base LeaderboardStatsRead;
var class<AdvLeaderboard_Write_Base> LeaderboardStatsWriteClass;
var string DesiredSessionCustomMapName;
var int DLCRequired;
var Vector MoveSmoothLocation;
//var delegate<ProcessFocusHighlight> __ProcessFocusHighlight__Delegate;
//var delegate<OnWriteStatsAndEndSessionCompleteDelegate> __OnWriteStatsAndEndSessionCompleteDelegate__Delegate;
//var delegate<CanUnpause> __CanUnpause__Delegate;
//var delegate<OnDestroyPartyComplete> __OnDestroyPartyComplete__Delegate;

replication
{
    // Pos:0x000
    if(bNetDirty
        MyAdvPlayerPawnMP;
}

function Possess(Pawn inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition);
    MyAdvPlayerPawnMP = AdvPlayerPawnMP(inPawn);
    //return;    
}

// Export UAdvPlayerController::execShouldIgnoreNetworkErrors(FFrame&, void* const)
native function bool ShouldIgnoreNetworkErrors();

function ShowInGameStatsScreen()
{
    // End:0x51
    if(!bCinematicMode && AdvGFxHudWrapper(myHUD) != none)
    {
        AdvGFxHudWrapper(myHUD).ShowInGameStatsScreen();
    }
    //return;    
}

function HideInGameStatsScreen()
{
    // End:0x40
    if(AdvGFxHudWrapper(myHUD) != none)
    {
        AdvGFxHudWrapper(myHUD).HideInGameStatsScreen();
    }
    //return;    
}

exec function ToggleQuickMenu(optional AdvTypes.EInventoryItem SelectedItem = 0, optional bool bFromQuickMenu = false)
{
    // End:0x30
    if(bCinematicMode && int(SelectedItem) != int(0))
    {
        return;
    }
    // End:0x66
    if(MyEvilPawn.IsInState('RidingRailCar') && bFromQuickMenu)
    {
        return;
    }
    // End:0x1AC
    if(((MyEvilPawn.Weapon != none) && MyEvilPawn.Weapon.IsInState('WeaponPuttingDown') || MyEvilPawn.Weapon.IsInState('WeaponAbortEquip')) || (MyEvilPawn.WeaponLeft != none) && MyEvilPawn.WeaponLeft.IsInState('WeaponPuttingDown') || MyEvilPawn.WeaponLeft.IsInState('WeaponAbortEquip'))
    {
        SelectedItem = 0;
    }
    // End:0x227
    if((!PlayerInput.bUsingGamepad && int(SelectedItem) != int(5)) && int(SelectedItem) != int(0))
    {
        Class'AdvGFxUI_InventoryMenu'.static.SelectInventory(SelectedItem, self);
        return;
    }
    // End:0x270
    if(AdvGFxHudWrapper(myHUD) != none)
    {
        AdvGFxHudWrapper(myHUD).ToggleQuickMenu(SelectedItem);
    }
    //return;    
}

delegate ProcessFocusHighlight(Actor A)
{
    //return;    
}

function bool TryDetachingUser()
{
    // End:0x2D
    if(((DetachUserFromBlock()) || DetachUserFromSafe()) || DetachUserFromMirror())
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool TryAttachingUser()
{
    // End:0x2D
    if(((FindDynamicMirror()) || FindMoveableBlock()) || FindSafe())
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool DetachUserFromBlock()
{
    // End:0x1A
    if(AdvChessMovableBlock(Pawn) == none)
    {
        return false;
    }
    // End:0x5D
    if(!bMoveState)
    {
        AdvChessMovableBlock(Pawn).DetachUser();
        DetachmentActions();
        return true;
    }
    return false;
    //return ReturnValue;    
}

exec function ClientCreateWaypoint()
{
    //return;    
}

simulated function DrawHUD(HUD H)
{
    local AdvPlayerPawn TargetPawn;
    local AdvWayPointMPBase Waypoint;
    local string nick;
    local Vector ScreenPos, HitLocation, HitNormal, projStart, X, Y,
	    Z;

    local Rotator CameraRot;
    local int Distance, MaxDisplayDistance, MaxBehindWallDistance;
    local bool bSameTeam, bShowThisPawn, bHasBlessing;
    local float TextWidth, TextHeight, textscale, IconScale;
    local FontRenderInfo FRI;
    local float DisplayedSpeed;
    local int I, PosX, PosY;

    // End:0xE58
    if((class<AdvGameMP_Base>(WorldInfo.GetGameClass()) != none) && (Pawn != none) || (AdvPRI(PlayerReplicationInfo) != none) && AdvPRI(PlayerReplicationInfo).bIsTournamentSpectator)
    {
        H.Canvas.Font = Class'Engine.Engine'.static.GetSubtitleFont();
        // End:0xE57
        foreach DynamicActors(Class'AdvPlayerPawn', TargetPawn)
        {
            // End:0x14D
            if(Pawn != none)
            {
                Distance = int(VSize(Pawn.Location - TargetPawn.Location));
            }
            // End:0xE56
            if(TargetPawn.PlayerReplicationInfo != none)
            {
                bSameTeam = false;
                // End:0x228
                if(PlayerReplicationInfo.Team == TargetPawn.PlayerReplicationInfo.Team)
                {
                    H.Canvas.DrawColor = MakeColor(192, 255, 192, 255);
                    bSameTeam = true;                    
                }
                else
                {
                    H.Canvas.DrawColor = MakeColor(255, 192, 192, 255);
                }
                MaxBehindWallDistance = 1000;
                MaxDisplayDistance = 4000;
                // End:0x334
                if(((Pawn != none) && EvilWeap_Base(Pawn.Weapon) != none) && int(EvilWeap_Base(Pawn.Weapon).GetZoomedState()) > int(1))
                {
                    MaxBehindWallDistance *= 1.5000000;
                    MaxDisplayDistance *= 1.5000000;
                }
                // End:0x4C2
                if(Pawn == none)
                {
                    // End:0x444
                    if(Pawn(ViewTarget) != none)
                    {
                        bShowThisPawn = FastTrace(Pawn(ViewTarget).Location + (vect(0.0000000, 0.0000000, 1.0000000) * Pawn(ViewTarget).CylinderComponent.CollisionHeight), TargetPawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * TargetPawn.CylinderComponent.CollisionHeight));                        
                    }
                    else
                    {
                        bShowThisPawn = FastTrace(Location, TargetPawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * TargetPawn.CylinderComponent.CollisionHeight));
                    }                    
                }
                else
                {
                    // End:0x5F1
                    if(bSameTeam)
                    {
                        bShowThisPawn = ((TargetPawn != Pawn) && Distance < MaxDisplayDistance) && (Distance < MaxBehindWallDistance) || FastTrace(Pawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * Pawn.CylinderComponent.CollisionHeight), TargetPawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * TargetPawn.CylinderComponent.CollisionHeight));                        
                    }
                    else
                    {
                        GetPlayerViewPoint(projStart, CameraRot);
                        GetAxes(CameraRot, X, Y, Z);
                        bShowThisPawn = TraceComponent(HitLocation, HitNormal, TargetPawn.CylinderComponent, projStart + (X * float(MaxDisplayDistance)), projStart) && FastTrace(Pawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * Pawn.CylinderComponent.CollisionHeight), TargetPawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * TargetPawn.CylinderComponent.CollisionHeight));
                    }
                }
                ScreenPos = H.Canvas.Project(TargetPawn.Location + vect(0.0000000, 0.0000000, 60.0000000));
                // End:0xE56
                if(ScreenPos.Z != 0.0000000)
                {
                    textscale = FMax(float(MaxDisplayDistance - Distance) / float(MaxDisplayDistance), 0.5000000);
                    // End:0xC68
                    if(bShowThisPawn)
                    {
                        nick = TargetPawn.PlayerReplicationInfo.PlayerName;
                        H.Canvas.TextSize(nick, TextWidth, TextHeight, textscale, textscale);
                        H.Canvas.SetPos(ScreenPos.X - (TextWidth * 0.5000000), ScreenPos.Y - (TextHeight * 1.2000000));
                        FRI = H.Canvas.CreateFontRenderInfo(true);
                        H.Canvas.DrawText(nick,, textscale, textscale, FRI);
                        // End:0xC65
                        if(AdvPRI(TargetPawn.PlayerReplicationInfo) != none)
                        {
                            bHasBlessing = false;
                            I = 0;
                            J0xA54:

                            // End:0xACD [Loop If]
                            if(I < 7)
                            {
                                // End:0xABF
                                if(AdvPRI(TargetPawn.PlayerReplicationInfo).ActiveBlessings[I] == 1)
                                {
                                    bHasBlessing = true;
                                    // [Explicit Break]
                                    goto J0xACD;
                                }
                                I++;
                                // [Loop Continue]
                                goto J0xA54;
                            }
                            J0xACD:

                            // End:0xC65
                            if(bHasBlessing && Class'AdvBlessingManager'.default.DefaultBlessingIconSmall != none)
                            {
                                H.Canvas.SetPos(ScreenPos.X - ((float(Class'AdvBlessingManager'.default.DefaultBlessingIconSmall.SizeX) * textscale) * 0.5000000), (ScreenPos.Y - (TextHeight * 1.3000000)) - (float(Class'AdvBlessingManager'.default.DefaultBlessingIconSmall.SizeY) * textscale));
                                H.Canvas.DrawTexture(Class'AdvBlessingManager'.default.DefaultBlessingIconSmall, textscale);
                            }
                        }
                        // End:0xE56
                        continue;
                    }
                    // End:0xE56
                    if(bSameTeam && TargetPawn != Pawn)
                    {
                        IconScale = FClamp((7000.0000000 - float(Distance)) / 6000.0000000, 0.2500000, 1.0000000);
                        H.Canvas.DrawColor = MakeColor(255, 255, 255, 255);
                        H.Canvas.SetPos(ScreenPos.X - ((float(Class'AdvGameMP_Base'.default.FriendlyMarkerIcon.SizeX) * IconScale) * 0.5000000), ScreenPos.Y - (float(Class'AdvGameMP_Base'.default.FriendlyMarkerIcon.SizeY) * IconScale));
                        H.Canvas.DrawTexture(Class'AdvGameMP_Base'.default.FriendlyMarkerIcon, IconScale);
                    }
                }
            }            
        }        
    }
    // End:0x1187
    if((PlayerReplicationInfo != none) && AdvTeamInfo(PlayerReplicationInfo.Team) != none)
    {
        Waypoint = AdvTeamInfo(PlayerReplicationInfo.Team).TeamWayPoint;
        // End:0x1187
        if((Waypoint != none) && !FastTrace(Pawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * Pawn.CylinderComponent.CollisionHeight), Waypoint.Location))
        {
            ScreenPos = H.Canvas.Project(Waypoint.Location + vect(0.0000000, 0.0000000, 0.0000000));
            // End:0x1187
            if(ScreenPos.Z != 0.0000000)
            {
                H.Canvas.DrawColor = MakeColor(255, 255, 255, 255);
                H.Canvas.SetPos(ScreenPos.X - (float(Class'AdvGameMP_Base'.default.WaypointIcon.SizeX) * 0.5000000), ScreenPos.Y - float(Class'AdvGameMP_Base'.default.WaypointIcon.SizeY));
                H.Canvas.DrawTexture(Class'AdvGameMP_Base'.default.WaypointIcon, 1.0000000);
            }
        }
    }
    super.DrawHUD(H);
    // End:0x147F
    if((AdvGRI(WorldInfo.GRI) != none) && AdvGRI(WorldInfo.GRI).GameClass.IsA('AdvGameTeamDeathmatch'))
    {
        PosX = 10;
        PosY = 100;
        H.Canvas.Font = Class'Engine.Engine'.static.GetSubtitleFont();
        H.Canvas.SetPos(float(PosX), float(PosY - 20));
        H.Canvas.DrawColor.R = 255;
        H.Canvas.DrawColor.G = 255;
        H.Canvas.DrawColor.B = 255;
        H.Canvas.DrawColor.A = 255;
        H.Canvas.DrawText("Score limit:     " @ string(WorldInfo.GRI.GoalScore));
    }
    // End:0x1930
    if(bShowSpeedMeter)
    {
        DisplayedSpeed = ((MyEvilPawn != none) ? VSize2D(MyEvilPawn.Velocity) : 0.0000000);
        // End:0x17BC
        if(AdvGRI(WorldInfo.GRI) != none)
        {
            H.Canvas.SetPos((H.Canvas.ClipX * 0.5000000) - 33.0000000, H.Canvas.ClipY - float(12));
            H.Canvas.SetDrawColor(128, 128, 128, 255);
            H.Canvas.DrawRect(66.0000000, 12.0000000);
            H.Canvas.SetPos((H.Canvas.ClipX * 0.5000000) - 32.0000000, H.Canvas.ClipY - float(11));
            H.Canvas.SetDrawColor(128, 0, 0, 255);
            H.Canvas.DrawRect((64.0000000 * DisplayedSpeed) / class<ADVGame>(AdvGRI(WorldInfo.GRI).GameClass).default.MaximalBunnyHopSpeed, 10.0000000);
        }
        DisplayedSpeed = 0.0100000 * float(Round(DisplayedSpeed * 100.0000000));
        H.Canvas.SetPos((H.Canvas.ClipX * 0.5000000) - 32.0000000, H.Canvas.ClipY - float(13));
        H.Canvas.Font = Class'Engine.Engine'.static.GetSmallFont();
        H.Canvas.DrawText(string(DisplayedSpeed / float(14 * 4)));
    }
    //return;    
}

function SetPuzzleDifficultyLevel(EvilTypesNative.EDifficultyLevel DifficultyIdx)
{
    // End:0x20
    if(int(DifficultyIdx) >= int(4))
    {
        DifficultyIdx = 1;
    }
    PuzzleDifficultyLevel = DifficultyIdx;
    //return;    
}

function SetFightDifficultyLevel(EvilTypesNative.EDifficultyLevel DifficultyIdx)
{
    // End:0x20
    if(int(DifficultyIdx) >= int(4))
    {
        DifficultyIdx = 1;
    }
    FightDifficultyLevel = DifficultyIdx;
    //return;    
}

function EvilTypesNative.EDifficultyLevel GetPuzzleDifficultyLevel()
{
    return PuzzleDifficultyLevel;
    //return ReturnValue;    
}

function EvilTypesNative.EDifficultyLevel GetFightDifficultyLevel()
{
    return FightDifficultyLevel;
    //return ReturnValue;    
}

final function UpdateDifficultySetting()
{
    local class<EvilDifficultySettings> DiffSettingsClass;
    local AdvPRI MyPRI;
    local int ValueId;
    local bool bCanUpdate;

    // End:0x26
    if(WorldInfo.GRI == none)
    {
        return;
    }
    // End:0x37
    if(ProfileSettings == none)
    {
        return;
    }
    // End:0x1CA
    if(!WorldInfo.GRI.IsMultiplayerGame())
    {
        // End:0xCF
        if(((PlayerReplicationInfo != none) && ProfileSettings != none) && ProfileSettings.GetProfileSettingValueId(35, ValueId))
        {
            bCanUpdate = true;            
        }
        MyPRI = AdvPRI(PlayerReplicationInfo);
        // End:0x1CA
        if(bCanUpdate && MyPRI != none)
        {
            switch(ValueId)
            {
                // End:0x136
                case 0:
                    DiffSettingsClass = Class'EvilGame.EvilDifficultySettings_Low';
                    // End:0x18B
                    break;
                // End:0x150
                case 1:
                    DiffSettingsClass = Class'EvilGame.EvilDifficultySettings_Normal';
                    // End:0x18B
                    break;
                // End:0x16B
                case 2:
                    DiffSettingsClass = Class'EvilGame.EvilDifficultySettings_High';
                    // End:0x18B
                    break;
                // End:0x186
                case 3:
                    DiffSettingsClass = Class'EvilGame.EvilDifficultySettings_VeryHigh';
                    // End:0x18B
                    break;
                // End:0xFFFF
                default:
                    return;
                    break;
            }
            // End:0x1CA
            if(MyPRI.Difficulty != DiffSettingsClass)
            {
                ServerSetDifficulty(DiffSettingsClass);
            }
        }
    }
    //return;    
}

reliable server final function ServerSetDifficulty(class<EvilDifficultySettings> DiffSettings)
{
    local AdvPRI MyPRI, OtherPRI;
    local int I;

    // End:0x297
    if(((WorldInfo.GRI != none) && !WorldInfo.GRI.IsMultiplayerGame()) && !ADVGame(WorldInfo.Game).bURLDifficultyOverride)
    {
        MyPRI = AdvPRI(PlayerReplicationInfo);
        // End:0x297
        if(MyPRI != none)
        {
            MyPRI.Difficulty = DiffSettings;
            MyPRI.Difficulty.static.ApplyDifficultySettings(self);
            I = 0;
            J0x136:

            // End:0x297 [Loop If]
            if(I < WorldInfo.GRI.PRIArray.Length)
            {
                OtherPRI = AdvPRI(WorldInfo.GRI.PRIArray[I]);
                // End:0x289
                if((OtherPRI != none) && AIController(OtherPRI.Owner) != none)
                {
                    OtherPRI.Difficulty = DiffSettings;
                    OtherPRI.Difficulty.static.ApplyDifficultySettings(Controller(OtherPRI.Owner));
                }
                I++;
                // [Loop Continue]
                goto J0x136;
            }
        }
    }
    //return;    
}

function GetPawnInventoryElements(out array<string> Inventory)
{
    local int Idx;
    local EvilWeap_Base Weapon;

    Idx = 0;
    // End:0xC7
    foreach AdvPlayerPawn(Pawn).InvManager.InventoryActors(Class'EvilGame.EvilWeap_Base', Weapon)
    {
        // End:0xC6
        if(Weapon.ShouldSaveBetweenLevels())
        {
            Inventory[Idx] = PathName(Weapon.Class);
            Idx++;
        }        
    }    
    //return;    
}

function GetPawnInventoryElementsAmmo(out array<int> InventoryAmmo)
{
    local int Idx;
    local EvilWeap_Base Weapon, WeaponLeft;

    Idx = 0;
    // End:0x226
    foreach AdvPlayerPawn(Pawn).InvManager.InventoryActors(Class'EvilGame.EvilWeap_Base', Weapon)
    {
        // End:0x225
        if(Weapon.ShouldSaveBetweenLevels())
        {
            // End:0x190
            if((!Weapon.BothHandWeapon && Weapon.OffHandWeaponClass != none) && ClassIsChildOf(Weapon.Class, Class'AdvWeap_Pistol_Base'))
            {
                WeaponLeft = EvilWeap_Base(AdvPlayerPawn(Pawn).FindInventoryType(Weapon.OffHandWeaponClass, true));
                Weapon.AmmoCount += WeaponLeft.AmmoCount;
            }
            InventoryAmmo[Idx] = Weapon.AmmoCount;
            Idx++;
            // End:0x21A
            if(WeaponLeft != none)
            {
                Weapon.AmmoCount -= WeaponLeft.AmmoCount;
            }
            WeaponLeft = none;
        }        
    }    
    //return;    
}

function GetDefaultCustomMessages(out array<string> DefaultMessages)
{
    local int I;

    DefaultMessages.Remove(0, DefaultMessages.Length);    
    DefaultMessages.Length = 10;
    I = 0;
    J0x2E:

    // End:0xA8 [Loop If]
    if(I < 10)
    {
        DefaultMessages[I] = Localize("PKControllerMessages", "DefaultMsgTxt" $ string(I + 1), "ADVGame");
        I++;
        // [Loop Continue]
        goto J0x2E;
    }
    //return;    
}

function bool DetachUserFromSafe()
{
    // End:0x1A
    if(AdvSafeRotator(Pawn) == none)
    {
        return false;
    }
    // End:0x5D
    if(!bMoveState)
    {
        AdvSafeRotator(Pawn).DetachUser();
        DetachmentActions();
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool DetachUserFromMirror()
{
    // End:0x1A
    if(AdvMirrorDynamic(Pawn) == none)
    {
        return false;
    }
    AdvMirrorDynamic(Pawn).DetachUser();
    DetachmentActions();
    return true;
    //return ReturnValue;    
}

function DetachmentActions()
{
    UnPossess();
    Pawn = BasePawn;
    Possess(Pawn, false);
    GotoState('PlayerWalking');
    SetBehindView(false);
    bNoCrosshair = false;
    //return;    
}

function bool FindDynamicMirror()
{
    local AdvMirrorDynamic V, Best;
    local Vector ViewDir, PawnLoc2D, VLoc2D;
    local float NewDot, BestDot, Radius;

    Radius = 100.0000000;
    // End:0x89
    if((AdvMirrorDynamic(Pawn.Base) != none) && AdvMirrorDynamic(Pawn.Base).TryToControl(Pawn))
    {
        return true;
    }
    PawnLoc2D = Pawn.Location;
    PawnLoc2D.Z = 0.0000000;
    ViewDir = Vector(Pawn.Rotation);
    // End:0x244
    foreach Pawn.OverlappingActors(Class'AdvMirrorDynamic', V, Radius)
    {
        VLoc2D = V.Location;
        VLoc2D.Z = 0.0000000;
        NewDot = Normal(VLoc2D - PawnLoc2D) Dot ViewDir;
        // End:0x243
        if((Best == none) || NewDot > BestDot)
        {
            // End:0x243
            if(FastTrace(V.Location, Pawn.Location))
            {
                Best = V;
                BestDot = NewDot;
            }
        }        
    }    
    return (Best != none) && Best.TryToControl(Pawn);
    //return ReturnValue;    
}

function bool FindMoveableBlock()
{
    local AdvChessMovableBlock V, Best;
    local float Radius;

    Radius = 80.0000000;
    // End:0x89
    if((AdvChessMovableBlock(Pawn.Base) != none) && AdvChessMovableBlock(Pawn.Base).TryToControl(Pawn))
    {
        return true;
    }
    // End:0x134
    foreach Pawn.OverlappingActors(Class'AdvChessMovableBlock', V, Radius)
    {
        // End:0x133
        if((Best == none) && FastTrace(V.Location, Pawn.Location))
        {
            Best = V;
            // End:0x134
            break;
        }        
    }    
    return (Best != none) && Best.TryToControl(Pawn);
    //return ReturnValue;    
}

exec function OpenDemoScreen()
{
    // End:0x4B
    if((myHUD == none) || WorldInfo.GRI == none)
    {
        SetTimer(0.0100000, false, 'OpenDemoScreen');        
    }
    else
    {
        AdvGFxHudWrapper(myHUD).OpenDemoScreen();
    }
    //return;    
}

function StopRender()
{
    // End:0x6C
    if(AdvGFxHudWrapper(myHUD).AdvDemoScreen != none)
    {
        AdvEngine(Class'AdvEngine'.static.GetEngine()).SetGameRenderingEnabled(false);
    }
    //return;    
}

function bool FindSafe()
{
    local AdvSafeRotator V, Best;
    local float Radius;

    Radius = 50.0000000;
    // End:0x89
    if((AdvSafeRotator(Pawn.Base) != none) && AdvSafeRotator(Pawn.Base).TryToControl(Pawn))
    {
        return true;
    }
    // End:0x134
    foreach Pawn.OverlappingActors(Class'AdvSafeRotator', V, Radius)
    {
        // End:0x133
        if((Best == none) && FastTrace(V.Location, Pawn.Location))
        {
            Best = V;
            // End:0x134
            break;
        }        
    }    
    return (Best != none) && Best.TryToControl(Pawn);
    //return ReturnValue;    
}

function bool StartPuzzle(AdvPuzzle_Base puz)
{
    // End:0x4B
    if(puz != none)
    {
        BasePawn = Pawn;
        return puz.SetPawn(Pawn);
    }
    return false;
    //return ReturnValue;    
}

exec function Puzzle_Jump()
{
    //return;    
}

function StartSlide(int InitialVel, int CurrentSlopeEnd, float TurningModifier, int GetUp)
{
    Pawn.SetPhysics(2);
    // End:0x166
    if(!IsInState('PlayerSlide'))
    {
        Pawn.SetMovementPhysics();
        PawnLastPos = Pawn.Location;
        SlidingVelocity = TurningModifier;
        SlidingRotation.Pitch = InitialVel;
        SlidingRotation.Roll = CurrentSlopeEnd;
        SlidingRotation.Yaw = GetUp;
        ProcessMove(1.0000000, Vector(Pawn.Rotation), PlayerInput.CheckForDoubleClickMove(0.1000000), rot(0, 0, 0));
        GotoState('PlayerSlide');
    }
    //return;    
}

function StopSlide()
{
    // End:0xE9
    if(IsInState('PlayerSlide'))
    {
        GotoState('PlayerWalking');
        // End:0xAA
        if(((MyEvilPawn != none) && MyEvilPawn.WeaponLeft != none) && MyEvilPawn.WeaponLeft.Class == NotepadFocusTriggerItemClass)
        {
            PushState('NotepadFocus');
        }
        AdvPlayerPawn(Pawn).GetSkeletalMeshComponent().SetHidden(false);
    }
    //return;    
}

function ShowPlayerMaterials(bool bShow)
{
    AdvPlayerPawn(Pawn).ArmsMesh[0].ShowMaterialSection(0, !bShow, 0);
    AdvPlayerPawn(Pawn).ArmsMesh[1].ShowMaterialSection(0, !bShow, 0);
    AdvPlayerPawn(Pawn).Weapon.SetHidden(bShow);
    AdvPlayerPawn(Pawn).WeaponLeft.SetHidden(bShow);
    AdvPlayerPawn(Pawn).SetMeshVisibility(bShow);
    //return;    
}

function HideWeapons()
{
    AdvPlayerPawn(Pawn).QuickHideCurrentWeapon(true,, true);
    AdvPlayerPawn(Pawn).QuickHideCurrentWeapon(true,, false);
    //return;    
}

function RestoreWeapons()
{
    AdvPlayerPawn(Pawn).EndQuickHideCurrentWeapon(false, 0.2000000, true);
    AdvPlayerPawn(Pawn).EndQuickHideCurrentWeapon(false, 0.2000000, false);
    //return;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    local float Rate, BlendInTime, BlendOutTime, WaitingTime;

    super.Landed(HitNormal, FloorActor);
    // End:0x23A
    if(SlidingRotation.Yaw >= 1)
    {
        HideWeapons();
        PlayFallSound();
        WaitingTime = float(SlidingRotation.Yaw);
        WaitingTime = WaitingTime / 10.0000000;
        SlidingRotation.Yaw = 0;
        ShowPlayerMaterials(true);
        AdvPlayerPawn(Pawn).ShowMaterialSectionOnAllLods(0, false);
        AdvPlayerPawn(Pawn).ShowMaterialSectionOnAllLods(1, false);
        AdvPlayerPawn(Pawn).ShowMaterialSectionOnAllLods(2, false);
        SetCinematicMode(true, false, false, true, true, true);
        Rate = 1.0000000;
        BlendInTime = 0.2000000;
        BlendOutTime = 0.2000000;
        AdvPlayerPawn(Pawn).GotoState('GettingUp');
        AdvPlayerPawn(Pawn).FullBodyAnimSlot.PlayCustomAnim('Slide_Fall', Rate, BlendInTime, BlendOutTime,, false);
        SetTimer(WaitingTime, false, 'WaitAfterFall_T');
        PlayerCameraFadeToBlack(0.5000000);
        PlayGetUpSound();
    }
    //return;    
}

function WaitAfterFall_T()
{
    SetTimer(0.1000000, true, 'TestFall_T');
    //return;    
}

function TestFall_T()
{
    local float Rate, BlendInTime, BlendOutTime;

    // End:0x15D
    if(AdvPlayerPawn(Pawn).FullBodyAnimSlot.GetPlayedAnimation() != 'Slide_Fall')
    {
        // End:0x15D
        if(AdvPlayerPawn(Pawn).FullBodyAnimSlot.GetPlayedAnimation() != 'Get_Up')
        {
            Rate = 1.0000000;
            BlendInTime = 0.2000000;
            BlendOutTime = 0.0000000;
            AdvPlayerPawn(Pawn).FullBodyAnimSlot.PlayCustomAnim('Get_Up', Rate, BlendInTime, BlendOutTime,, false);
            SetTimer(0.0000000, true, 'TestFall_T');
            SetTimer(0.1000000, true, 'TestGetUp_T');
            PlayerCameraFadeToNormal(2.0000000);
        }
    }
    //return;    
}

function TestGetUp_T()
{
    local Rotator FinishRotation;

    AdvPlayerPawn(Pawn).bBlendGettingUpCamera = true;
    // End:0x20F
    if(AdvPlayerPawn(Pawn).FullBodyAnimSlot.GetPlayedAnimation() != 'Get_Up')
    {
        AdvPlayerPawn(Pawn).GotoState('Auto');
        AdvPlayerPawn(Pawn).bBlendGettingUpCamera = false;
        FinishRotation = Pawn.GetViewRotation();
        FinishRotation.Pitch = 0;
        FinishRotation.Roll = 0;
        Pawn.SetViewRotation(FinishRotation);
        AdvPlayerPawn(Pawn).ShowMaterialSectionOnAllLods(0, true);
        AdvPlayerPawn(Pawn).ShowMaterialSectionOnAllLods(1, true);
        AdvPlayerPawn(Pawn).ShowMaterialSectionOnAllLods(2, true);
        ShowPlayerMaterials(false);
        SetCinematicMode(false, false, false, true, true, true);
        SetTimer(0.0000000, true, 'TestGetUp_T');
        RestoreWeapons();
    }
    //return;    
}

function PlayerCameraFadeTo(float DeltaTime, float FadeFrom, float FadeTo)
{
    PlayerCamera.bEnableFading = true;
    PlayerCamera.FadeTimeRemaining = DeltaTime;
    PlayerCamera.FadeTime = DeltaTime;
    PlayerCamera.FadeAlpha.X = FadeFrom;
    PlayerCamera.FadeAlpha.Y = FadeTo;
    //return;    
}

function PlayerCameraFadeToBlack(float DeltaTime)
{
    PlayerCameraFadeTo(DeltaTime, 0.0000000, 1.0000000);
    //return;    
}

function PlayerCameraFadeToNormal(float DeltaTime)
{
    PlayerCameraFadeTo(DeltaTime, 1.0000000, 0.0000000);
    //return;    
}

function PlayFallSound()
{
    local SoundCue FallSound;

    FallSound = SoundCue'a_Wolf_CUE.a_Fall_01';
    PlaySound(FallSound);
    //return;    
}

function PlayGetUpSound()
{
    local SoundCue GetUpSound;

    GetUpSound = SoundCue'a_Wolf_CUE.a_Fall_02';
    PlaySound(GetUpSound);
    //return;    
}

function SetTextfield()
{
    //return;    
}

simulated function UpdateWeatherEffects()
{
    Class'AdvWeatherEffectActor'.static.Update(self);
    //return;    
}

simulated function bool PerformedUseAction()
{
    BasePawn = Pawn;
    // End:0x22
    if(TryAttachingUser())
    {
        return true;
    }
    // End:0x73
    if(int(Pawn.Physics) == int(4))
    {
        UTPawn(Pawn).StopFlying();
    }
    // End:0xC1
    if(WorldInfo.Pauser == PlayerReplicationInfo)
    {
        // End:0xBF
        if(int(Role) == int(ROLE_Authority))
        {
            SetPause(false);
        }
        return true;
    }
    // End:0xD2
    if(Pawn == none)
    {
        return true;
    }
    // End:0xE8
    if(int(Role) < int(ROLE_Authority))
    {
        return false;
    }
    // End:0x150
    if((Vehicle(Pawn) != none) && !PlayerInput.bUsingGamepad)
    {
        return Vehicle(Pawn).DriverLeave(false);
    }
    // End:0x15F
    if(FindVehicleToDrive())
    {
        return true;
    }
    // End:0x19D
    if((UsableTrigger != none) && UsableTrigger.UsedBy(Pawn))
    {
        return true;
    }
    return TriggerInteracted();
    //return ReturnValue;    
}

function bool FindVehicleToDrive()
{
    // End:0x1B
    if(CheckIfPlayerCanEnter())
    {
        return super(UTPlayerController).FindVehicleToDrive();        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function bool CheckIfPlayerCanEnter()
{
    local AdvPlayerPawn APP;

    APP = AdvPlayerPawn(Pawn);
    // End:0xC0
    if(((APP.Weapon == none) && APP.WeaponLeft == none) || APP.Weapon.Class == APP.HandsClass)
    {
        return true;
    }
    // End:0x1C2
    if(((APP.WeaponLeft == none) && APP.Weapon != none) && APP.Weapon.IsInState('Active') || APP.Weapon.IsInState('Inactive') && !APP.Weapon.IsInState('QuickHide'))
    {
        return true;
    }
    // End:0x2C4
    if(((APP.Weapon == none) && APP.WeaponLeft != none) && APP.WeaponLeft.IsInState('Active') || APP.WeaponLeft.IsInState('Inactive') && !APP.Weapon.IsInState('QuickHide'))
    {
        return true;
    }
    // End:0x47C
    if((((APP.WeaponLeft != none) && APP.WeaponLeft.IsInState('Active') || APP.WeaponLeft.IsInState('Inactive') && !APP.Weapon.IsInState('QuickHide')) && APP.Weapon != none) && APP.Weapon.IsInState('Active') || APP.Weapon.IsInState('Inactive') && !APP.Weapon.IsInState('QuickHide'))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event PostBeginPlay()
{
    local AdvEngine Eng;
    local GFxObject Cursor;

    super.PostBeginPlay();
    Eng = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x6C
    if(Eng != none)
    {
        Eng.bLoadFromInvite = false;
    }
    UpdateWeatherEffects();
    IterateOverWeaponFireTargets();
    // End:0x165
    if((AdvGFxHudWrapper(myHUD) != none) && AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie) != none)
    {
        Cursor = AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject("_root.HUD.mc_cursor");
        // End:0x165
        if(Cursor != none)
        {
            Cursor.SetVisible(false);
        }
    }
    //return;    
}

event PlayerTick(float DeltaTime)
{
    local EvilWeap_Base W, WL;

    super.PlayerTick(DeltaTime);
    // End:0x70D
    if(MyEvilPawn != none)
    {
        W = EvilWeap_Base(MyEvilPawn.Weapon);
        WL = EvilWeap_Base(MyEvilPawn.WeaponLeft);
        // End:0x1FE
        if(MyEvilPawn.IsSprinting && ((((int(bDuck) == int(1)) || MyEvilPawn.bIsFalling && (WorldInfo.TimeSeconds - MyEvilPawn.FallingStartTime) > 0.1000000) || MyEvilPawn.bIsJumping && (WorldInfo.TimeSeconds - MyEvilPawn.JumpingStartTime) > 0.7000000) || (AdvPRI(PlayerReplicationInfo) != none) && !AdvPRI(PlayerReplicationInfo).bIsAlive) || IsInState('Dead', true))
        {
            SetSprint(false);
        }
        // End:0x3C3
        if(((MyEvilPawn.IsSprinting && (MyEvilPawn.Velocity.X != float(0)) || MyEvilPawn.Velocity.Y != float(0)) && (CameraAnimPlayer != none) && CameraAnimPlayer.bFinished || CameraAnimPlayer.CamAnim != MyEvilPawn.SprintCameraAnim) && ((AdvPRI(PlayerReplicationInfo) != none) && AdvPRI(PlayerReplicationInfo).bIsAlive) || !IsInState('Dead', true))
        {
            MyEvilPawn.Bob = 0.0000000;
            PlayCameraAnim(MyEvilPawn.SprintCameraAnim,,, 0.1000000, 0.1000000, true);
        }
        // End:0x532
        if((!bLastSprintState && MyEvilPawn.IsSprinting && (MyEvilPawn.Velocity.X != float(0)) || MyEvilPawn.Velocity.Y != float(0)) && ((AdvPRI(PlayerReplicationInfo) != none) && AdvPRI(PlayerReplicationInfo).bIsAlive) || !IsInState('Dead', true))
        {
            // End:0x4F5
            if(W != none)
            {
                W.StartSprint();
            }
            // End:0x523
            if(WL != none)
            {
                WL.StartSprint();
            }
            bLastSprintState = true;            
        }
        else
        {
            // End:0x70A
            if(bLastSprintState && !MyEvilPawn.IsSprinting || (MyEvilPawn.Velocity.X == float(0)) && MyEvilPawn.Velocity.Y == float(0))
            {
                // End:0x608
                if(MyEvilPawn.IsSprinting)
                {
                    SetSprint(false);
                }
                // End:0x636
                if(W != none)
                {
                    W.StopSprint();
                }
                // End:0x664
                if(WL != none)
                {
                    WL.StopSprint();
                }
                // End:0x6C1
                if((CameraAnimPlayer != none) && CameraAnimPlayer.CamAnim == MyEvilPawn.SprintCameraAnim)
                {
                    StopCameraAnim();
                }
                MyEvilPawn.Bob = MyEvilPawn.default.Bob;
                bLastSprintState = false;
            }
        }        
    }
    else
    {
        // End:0x783
        if(bLastSprintState)
        {
            // End:0x777
            if((CameraAnimPlayer != none) && CameraAnimPlayer.CamAnim == Class'EvilGame.EvilPawn'.default.SprintCameraAnim)
            {
                StopCameraAnim();
            }
            bLastSprintState = false;
        }
    }
    // End:0x7B7
    if(bDeactivateBlock && !bMoveState)
    {
        bDeactivateBlock = false;
        DetachUserFromBlock();
    }
    CheckForProfileUpdate();
    //return;    
}

function CheckForProfileUpdate()
{
    // End:0xA4
    if((((bProfileSettingsUpdated && ProfileSettings != none) && ProfileSettings.ProfileSettings.Length > 0) && AdvPRI(PlayerReplicationInfo) != none) && AdvGRI(WorldInfo.GRI) != none)
    {
        UpdateLocalCacheOfProfileSettings();
        bProfileSettingsUpdated = false;
    }
    //return;    
}

event TeleportTo(Vector NewLocation, Rotator NewRotation)
{
    // End:0xBA
    if(MyEvilPawn != none)
    {
        // End:0xBA
        if(MyEvilPawn.SetTeleportLocation(NewLocation, true))
        {
            SetRotation(NewRotation);
            ClientSetRotation(NewRotation);
            MyEvilPawn.SetRotation(NewRotation);
            // End:0xBA
            if(!MyEvilPawn.IsRidingRailCar())
            {
                MyEvilPawn.SetPhysics(2);
            }
        }
    }
    //return;    
}

simulated event NotifyProjectileFire(Projectile Proj)
{
    super.NotifyProjectileFire(Proj);
    // End:0xD7
    if(ClassIsChildOf(Proj.Class, Class'AdvProjectile_Grenade_Base') || ClassIsChildOf(Proj.Class, Class'AdvProjectile_Dynamite_Base'))
    {
        // End:0xD7
        if(AdvGFxHudWrapper(myHUD) != none)
        {
            AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).ShowGrenadeIndicator(Proj, true);
        }
    }
    //return;    
}

simulated event NotifyProjectileExplode(Projectile Proj)
{
    super.NotifyProjectileExplode(Proj);
    // End:0xD7
    if(ClassIsChildOf(Proj.Class, Class'AdvProjectile_Grenade_Base') || ClassIsChildOf(Proj.Class, Class'AdvProjectile_Dynamite_Base'))
    {
        // End:0xD7
        if(AdvGFxHudWrapper(myHUD) != none)
        {
            AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).ShowGrenadeIndicator(Proj, false);
        }
    }
    //return;    
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    local int iDam;

    super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    iDam = Clamp(Damage, 0, 250);
    // End:0xE3
    if(((iDam > 0) || bGodMode) && Pawn != none)
    {
        ClientPlayTakeHitAdv(InstigatedBy.Pawn, HitLocation - Pawn.Location, byte(iDam), DamageType);
    }
    SetAlienFxLight(0, 255, 0, 0, 2, 0, takeDamageDuration);
    //return;    
}

unreliable client simulated function ClientPlayTakeHit(Vector HitLoc, byte Damage, class<DamageType> DamageType)
{
    //return;    
}

unreliable client simulated function ClientPlayTakeHitAdv(Pawn InstigatorPawn, Vector HitLoc, byte Damage, class<DamageType> DamageType)
{
    DamageShake(int(Damage), DamageType);
    HitLoc += Pawn.Location;
    // End:0xAD
    if(AdvGFxHudWrapper(myHUD) != none)
    {
        AdvGFxHudWrapper(myHUD).DisplayHitAdv(InstigatorPawn, HitLoc, int(Damage), DamageType);
    }
    //return;    
}

reliable client simulated function ClientPlayLastBreathAmbient()
{
    // End:0x30
    if(LastBreathAmbientComponent == none)
    {
        LastBreathAmbientComponent = GetPooledAudioComponent(LastBreathAmbientCue, self, true, false);
    }
    // End:0x68
    if(LastBreathAmbientComponent != none)
    {
        LastBreathAmbientComponent.FadeIn(0.8000000, 1.0000000);
    }
    // End:0x18F
    if((ExplosionStunAmbientComponent == none) || !ExplosionStunAmbientComponent.IsPlaying())
    {
        // End:0xBF
        if(LastBreathStartCue != none)
        {
            ClientPlaySound(LastBreathStartCue);
        }
        ClientSetSoundMode('LowPass_special');
        // End:0x18F
        if(ProfileSettings != none)
        {
            SetAudioGroupVolume('SFX', ProfileSettings.GetSFXVolume() * 0.2500000);
            SetAudioGroupVolume('Voice', ProfileSettings.GetVoiceVolume() * 0.2500000);
            SetAudioGroupVolume('Music', ProfileSettings.GetMusicVolume() * 0.2500000);
        }
    }
    //return;    
}

reliable client simulated function ClientStopLastBreathAmbient()
{
    // End:0x74
    if((ExplosionStunAmbientComponent == none) || !ExplosionStunAmbientComponent.IsPlaying())
    {
        UpdateVisualAndAudioConfig();
        ClientSetSoundMode('Default');
        // End:0x74
        if(LastBreathEndCue != none)
        {
            ClientPlaySound(LastBreathEndCue);
        }
    }
    // End:0xB7
    if(LastBreathAmbientComponent != none)
    {
        LastBreathAmbientComponent.FadeOut(0.3000000, 0.0000000);
        LastBreathAmbientComponent = none;
    }
    //return;    
}

reliable client simulated function ClientPlayExplosionStunAmbient(float Volume)
{
    local bool bIgnoreStunStartCue;

    bIgnoreStunStartCue = false;
    // End:0x51
    if(ExplosionStunAmbientComponent != none)
    {
        ExplosionStunAmbientComponent.Stop();
        ExplosionStunAmbientComponent = none;
        bIgnoreStunStartCue = true;
    }
    // End:0x81
    if(ExplosionStunAmbientComponent == none)
    {
        ExplosionStunAmbientComponent = GetPooledAudioComponent(ExplosionStunAmbientCue, self, true, false);
    }
    // End:0xBD
    if(ExplosionStunAmbientComponent != none)
    {
        ExplosionStunAmbientComponent.FadeIn(0.8000000, Volume);
    }
    // End:0xCC
    if(bIgnoreStunStartCue)
    {
        return;
    }
    // End:0x271
    if((LastBreathAmbientComponent == none) || !LastBreathAmbientComponent.IsPlaying())
    {
        // End:0x16B
        if(ExplosionStunStartCue != none)
        {
            ExplosionStunStartCue.VolumeMultiplier = ExplosionStunStartCue.default.VolumeMultiplier * Volume;
            ClientPlaySound(ExplosionStunStartCue);
        }
        ClientSetSoundMode('LowPass_special');
        // End:0x271
        if(ProfileSettings != none)
        {
            SetAudioGroupVolume('SFX', ProfileSettings.GetSFXVolume() * FMax(0.8000000 - Volume, 0.1500000));
            SetAudioGroupVolume('Voice', ProfileSettings.GetVoiceVolume() * FMax(0.8000000 - Volume, 0.1500000));
            SetAudioGroupVolume('Music', ProfileSettings.GetMusicVolume() * FMax(0.8000000 - Volume, 0.1500000));
        }
    }
    //return;    
}

reliable client simulated function ClientStopExplosionStunAmbient()
{
    // End:0x5B
    if((LastBreathAmbientComponent == none) || !LastBreathAmbientComponent.IsPlaying())
    {
        SetTimer(1.5000000, false, 'UpdateVisualAndAudioConfig');
        ClientSetSoundMode('Default');
    }
    // End:0x9E
    if(ExplosionStunAmbientComponent != none)
    {
        ExplosionStunAmbientComponent.FadeOut(2.0000000, 0.0000000);
        ExplosionStunAmbientComponent = none;
    }
    //return;    
}

reliable client simulated function ClientSetCinematicMode(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD)
{
    super.ClientSetCinematicMode(bInCinematicMode, bAffectsMovement, bAffectsTurning, bAffectsHUD);
    // End:0x12A
    if(bInCinematicMode)
    {
        GetPlayerHitEffects().StopBloodEffects();
        // End:0x9C
        if((AdvHudWrapper != none) && bAffectsHUD)
        {
            AdvHudWrapper.HideInGameStatsScreen();
        }
        // End:0x11C
        if((int(Role) == int(ROLE_Authority)) && ADVGame(WorldInfo.Game) != none)
        {
            ADVGame(WorldInfo.Game).DisableBulletTime();
        }
        FocusFlashlight(false);        
    }
    else
    {
        // End:0x18C
        if(((AdvHudWrapper != none) && bAffectsHUD) && AdvHudWrapper.IsGamePaused())
        {
            AdvHudWrapper.SetVisibilityForPause(true);
        }
    }
    //return;    
}

function SetCinematicMode(bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons)
{
    // End:0x19
    if(bInCinematicMode)
    {
        ToggleQuickMenu();
    }
    super(PlayerController).SetCinematicMode(bInCinematicMode, bHidePlayer, bAffectsHUD, bAffectsMovement, bAffectsTurning, bAffectsButtons);
    //return;    
}

reliable client simulated function ShowCenterMessageOnHUD(string LocSection, string LocTag, bool bLong)
{
    // End:0x85
    if(AdvGFxHudWrapper(myHUD) != none)
    {
        AdvGFxHudWrapper(myHUD).HudMovie.SetCenterMessageText(Localize(LocSection, LocTag, "ADVGame"), bLong, true);
    }
    //return;    
}

function NotifyChangedWeapon(Weapon PreviousWeapon, Weapon NewWeapon)
{
    // End:0x99
    if(NewWeapon != none)
    {
        // End:0x7D
        if((NewWeapon == MyEvilPawn.WeaponLeft) && NewWeapon.Class == NotepadFocusTriggerItemClass)
        {
            PushState('NotepadFocus');
        }
        super.NotifyChangedWeapon(PreviousWeapon, NewWeapon);
    }
    //return;    
}

exec function Input_A_Released()
{
    //return;    
}

function StartButtonTracing()
{
    // End:0x20
    if(!IsInState('ButtonTracing'))
    {
        GotoState('ButtonTracing');
    }
    //return;    
}

function StopButtonTracing()
{
    // End:0xAA
    if(IsInState('ButtonTracing'))
    {
        GotoState('PlayerWalking');
        // End:0xAA
        if(((MyEvilPawn != none) && MyEvilPawn.WeaponLeft != none) && MyEvilPawn.WeaponLeft.Class == NotepadFocusTriggerItemClass)
        {
            PushState('NotepadFocus');
        }
    }
    //return;    
}

reliable client simulated function NotifyFocusHighlightChanged(Actor A, bool bNewEnabled)
{
    // End:0x1E
    if(int(GetPuzzleDifficultyLevel()) > int(FocusMaxDifficultyLevel))
    {
        return;
    }
    // End:0x51
    if(bNewEnabled)
    {
        // End:0x4E
        if(IsInState('NotepadFocus'))
        {
            EnableHighlights(A);
        }        
    }
    else
    {
        DisableHighlights(A);
    }
    //return;    
}

protected function EnableHighlights(Actor A)
{
    HighlightComponentClass.static.HighlightActor(A, bCinematicMode);
    //return;    
}

protected function DisableHighlights(Actor A)
{
    local editinline AdvFocusHighlightComponent FHC;

    FHC = HighlightComponentClass.static.GetForActor(A);
    // End:0x6A
    if(FHC != none)
    {
        FHC.Dehighlight(bCinematicMode);
    }
    //return;    
}

protected function DisableHighlightsInstant(Actor A)
{
    local editinline AdvFocusHighlightComponent FHC;

    FHC = HighlightComponentClass.static.GetForActor(A);
    // End:0x61
    if(FHC != none)
    {
        FHC.Dehighlight(true);
    }
    //return;    
}

function IterateOverFocusHighligths(delegate<ProcessFocusHighlight> Callback)
{
    local array<Sequence> RS;
    local Sequence Seq;
    local array<SequenceObject> FHL;
    local SequenceObject SO;
    local SeqVar_ObjectList List;
    local Object O;
    local Actor A;

    RS = WorldInfo.GetAllRootSequences();
    // End:0x195
    foreach RS(Seq)
    {
        // End:0x53
        if(Seq == none)
        {
            continue;            
        }
        else
        {
            Seq.FindSeqObjectsByClass(Class'SeqVar_FocusHighlightList', true, FHL);
            // End:0x193
            foreach FHL(SO)
            {
                List = SeqVar_FocusHighlightList(SO);
                // End:0xCB
                if(List == none)
                {
                    continue;                    
                }
                else
                {
                    // End:0x191
                    foreach List.ObjList(O)
                    {
                        A = Actor(O);
                        // End:0x126
                        if(A == none)
                        {
                            continue;                            
                        }
                        else
                        {
                            // End:0x14C
                            if(A.bStatic)
                            {
                                continue;                                
                            }
                            else
                            {
                                // End:0x174
                                if(A.WorldInfo == none)
                                {
                                    continue;                                    
                                }
                                else
                                {
                                    ProcessFocusHighlight(A);                                    
                                }
                            }
                        }
                    }                                        
                }
            }                        
        }
    }    
    //return;    
}

reliable client simulated function ClientIterateOverFocusHighlights()
{
    // End:0x49
    if(IsInState('NotepadFocus') && int(GetPuzzleDifficultyLevel()) <= int(FocusMaxDifficultyLevel))
    {
        IterateOverFocusHighligths(EnableHighlights);
    }
    //return;    
}

reliable client simulated function ClientIterateOverWeaponFireTargets()
{
    IterateOverWeaponFireTargets();
    //return;    
}

simulated function IterateOverWeaponFireTargets()
{
    local array<Sequence> RS;
    local Sequence Seq;
    local array<SequenceObject> FHL;
    local SequenceObject SO;
    local SeqVar_ObjectList List;
    local Object O;
    local Actor A;

    RS = WorldInfo.GetAllRootSequences();
    // End:0x167
    foreach RS(Seq)
    {
        // End:0x53
        if(Seq == none)
        {
            continue;            
        }
        else
        {
            Seq.FindSeqObjectsByClass(Class'SeqVar_WeaponFireTargets', true, FHL);
            // End:0x165
            foreach FHL(SO)
            {
                List = SeqVar_WeaponFireTargets(SO);
                // End:0xCB
                if(List == none)
                {
                    continue;                    
                }
                else
                {
                    // End:0x163
                    foreach List.ObjList(O)
                    {
                        A = Actor(O);
                        // End:0x126
                        if(A == none)
                        {
                            continue;                            
                        }
                        else
                        {
                            // End:0x14E
                            if(A.WorldInfo == none)
                            {
                                continue;                                
                            }
                            else
                            {
                                NotifyWeaponFireTargetChanged(A, true);                                
                            }
                        }
                    }                                        
                }
            }                        
        }
    }    
    //return;    
}

exec function bool FocusFlashlight(bool bNewFocused)
{
    local AdvPlayerPawn P;
    local AdvTurret_Searchlight_Base Searchlight;

    P = AdvPlayerPawn(MyEvilPawn);
    // End:0x47
    if(P == none)
    {
        Searchlight = AdvTurret_Searchlight_Base(Pawn);
    }
    // End:0x368
    if(((bNewFocused && !bCinematicMode) || !bNewFocused) && ((P != none) && P.MyTorch != none) || Searchlight != none)
    {
        // End:0x25B
        if(P != none)
        {
            // End:0x1DE
            if(bNewFocused)
            {
                // End:0x11F
                if(P.CanFocusFlashlight())
                {
                    P.FocusFlashlight(true);                    
                }
                else
                {
                    // End:0x1D9
                    if((P.MyTorch != none) && !P.MyTorch.bFlashlightOn)
                    {
                        P.MyTorch.bAutoActiveAfterEquip = true;
                        Class'AdvGFxUI_InventoryMenu'.static.SelectInventory(1, self);                        
                    }
                    else
                    {
                        return false;
                    }
                }                
            }
            else
            {
                // End:0x238
                if(P.MyTorch != none)
                {
                    P.MyTorch.bAutoActiveAfterEquip = false;
                }
                P.FocusFlashlight(false);
            }            
        }
        else
        {
            // End:0x2E7
            if(bNewFocused)
            {
                Searchlight.MyTorch.ActivateFlightBeam();
                // End:0x2E4
                if(int(Role) < int(ROLE_Authority))
                {
                    Searchlight.MyTorch.ClientActivateFlightBeam();
                }                
            }
            else
            {
                Searchlight.MyTorch.DeactivateFlightBeam();
                // End:0x365
                if(int(Role) < int(ROLE_Authority))
                {
                    Searchlight.MyTorch.ClientDeactivateFlightBeam();
                }
            }
        }        
    }
    else
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function PawnDied(Pawn P)
{
    SlidingRotation = rot(0, 0, 0);
    UpdateVisualAndAudioConfig();
    ClientSetSoundMode('Default');
    // End:0x6D
    if(LastBreathAmbientComponent != none)
    {
        LastBreathAmbientComponent.Stop();
        LastBreathAmbientComponent = none;
    }
    // End:0xA6
    if(ExplosionStunAmbientComponent != none)
    {
        ExplosionStunAmbientComponent.Stop();
        ExplosionStunAmbientComponent = none;
    }
    GetMeleeActionsManager().StopHintMessage();
    // End:0x10F
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        MyEvilPawn.FadeOutAllDialogSounds();
    }
    super(UTPlayerController).PawnDied(P);
    //return;    
}

simulated event ReceivedPlayer()
{
    super.ReceivedPlayer();
    // End:0x4F
    if(LocalPlayer(Player) != none)
    {
        LocalPlayer(Player).ClearPostProcessSettingsOverride(0.0000000);
    }
    //return;    
}

reliable client simulated function ClientRestart(Pawn NewPawn)
{
    super(UTConsolePlayerController).ClientRestart(NewPawn);
    // End:0x43
    if((GetPPManager()) != none)
    {
        GetPPManager().Reset();
    }
    //return;    
}

function bool isInventory(Inventory Inv)
{
    return Inv.IsA('AdvInventoryItem_Base');
    //return ReturnValue;    
}

function RestoreFlashlight(Inventory Inv)
{
    // End:0x11B
    if(MyEvilPawn.IsA('AdvPlayerPawn') && Inv.Class == Class'AdvInventoryItem_Torch')
    {
        AdvPlayerPawn(MyEvilPawn).MyTorch = AdvInventoryItem_Torch(Inv);
        AdvPlayerPawn(MyEvilPawn).MyTorch.bFlashlightOn = bFlashlightOn;
        AdvPlayerPawn(MyEvilPawn).MyTorch.bPendingFlashlightOn = bFlashlightOn;
    }
    //return;    
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    local int I, J;
    local AdvPRI PRI;
    local InventoryRecord InvRecord;
    local PerkPathRecord TreasurePathRecord;
    local ObjectiveIconRecord ObjIconRecord;
    local EvilWeap_Base Weapon;
    local Pawn InvHolder;
    local AdvGRI GRI;
    local AdvGameSP Game;

    PRI = AdvPRI(PlayerReplicationInfo);
    GRI = AdvGRI(WorldInfo.GRI);
    Game = AdvGameSP(WorldInfo.Game);
    // End:0x527
    if(MyEvilPawn != none)
    {
        Record.SavedGuid = MyGuid;
        Record.CheckpointName = LastCheckpointSaveName;
        Record.TeamIndex = GetTeamNum();
        Record.PawnClassName = PathName(Pawn.Class);
        Record.Location = Pawn.Location;
        Record.Rotation = Pawn.Rotation;
        Record.Health = Pawn.Health;
        Record.HealthMax = Pawn.HealthMax;
        // End:0x367
        if(PRI != none)
        {
            Record.MonstersKilled = PRI.MonstersKilled;
            Record.AmmoFound = PRI.AmmoFound;
            Record.BonusItems = PRI.BonusItems;
            Record.SecretsFound = PRI.SecretsFound;
            Record.DestroyedObjects = PRI.DestroyedObjects;
        }
        Record.GRIBonusItemsFromFallenEnemy = GRI.BonusItemsFromFallenEnemy;
        Record.GRIGameplayTime = GRI.GameplayTime;
        Record.ShotsCounter = CurrentLevelShotsCount;
        Record.StakeShotCounter = StakeGunShots;
        Record.StakeGunHits = StakeGunHits;
        Record.MonsterHitCounter = CurrentLevelMonsterHitCounter;
        Record.bPlayerGotSomeDamage = bPlayerGotSomeDamage;
        Record.PuzzleDifficultyLevel = PuzzleDifficultyLevel;
        Record.FightDifficultyLevel = FightDifficultyLevel;
        GRI.CopyGlobalStatisticsToLevelStatisticsStruct(Record.CurrentLevelStatistics);        
    }
    else
    {
        Record.PawnPathName = PathName(Pawn);
    }
    // End:0x683
    if(Pawn != none)
    {
        // End:0x5B2
        if(Vehicle(Pawn) != none)
        {
            InvHolder = Vehicle(Pawn).Driver;            
        }
        else
        {
            InvHolder = Pawn;
        }
        // End:0x682
        foreach InvHolder.InvManager.InventoryActors(Class'EvilGame.EvilWeap_Base', Weapon)
        {
            // End:0x681
            if(Weapon.ShouldSaveForCheckpoint())
            {
                Weapon.CreateCheckpointRecord(InvRecord);
                Record.InventoryRecords.AddItem(InvRecord);                
            }            
        }        
    }
    // End:0x84F
    if(Game != none)
    {
        Record.bPlayingMusic = (WorldInfo.MusicComp != none) && WorldInfo.MusicComp.IsPlaying();
        // End:0x84F
        if(Record.bPlayingMusic)
        {
            Record.BattleMusic.Length = 1;
            Record.BattleCues.Length = 1;
            Record.BattleMusic[0] = WorldInfo.CurrentMusicTrack;
            Record.BattleCues[0] = PathName(WorldInfo.CurrentMusicTrack.TheSoundCue);
            Record.MusicPlaybackTime = WorldInfo.MusicComp.PlaybackTime;
        }
    }
    Record.bFireModeSwitch = bFireModeSwitch;
    PRI = AdvPRI(PlayerReplicationInfo);
    // End:0xACB
    if(MyEvilPawn != none)
    {
        Record.TreasuresCollected = PRI.TreasuresColected;
        I = 0;
        J0x8E8:

        // End:0xACB [Loop If]
        if(I < 3)
        {
            Record.TreasuresPerTypeCollected.AddItem(PRI.TreasuresPerTypeColected[I]);            
            Record.TreasuresPerTypeAvailable.AddItem(PRI.TreasuresPerTypeAvailable[I]);            
            TreasurePathRecord.Level.Remove(0, TreasurePathRecord.Level.Length);            
            TreasurePathRecord.Level.Length = 0;
            J = 0;
            J0x9EE:

            // End:0xA94 [Loop If]
            if(J < TreasurePerks[I].PerkPath.Length)
            {
                TreasurePathRecord.Level.AddItem(TreasurePerks[I].PerkPath[J].CurrentLevel);                
                J++;
                // [Loop Continue]
                goto J0x9EE;
            }
            Record.TreasuresPerkPathLevels.AddItem(TreasurePathRecord);            
            I++;
            // [Loop Continue]
            goto J0x8E8;
        }
    }
    I = 0;
    J0xAD6:

    // End:0xB3C [Loop If]
    if(I < 24)
    {
        Record.ItemsCount.AddItem(PRI.ItemsCount[I]);        
        I++;
        // [Loop Continue]
        goto J0xAD6;
    }
    I = 0;
    J0xB47:

    // End:0xC52 [Loop If]
    if(I < ObjectiveIconStorage.Length)
    {
        // End:0xC44
        if(ObjectiveIconStorage[I].Target != none)
        {
            ObjIconRecord.TargetPathName = PathName(ObjectiveIconStorage[I].Target);
            ObjIconRecord.Type = ObjectiveIconStorage[I].Type;
            Record.ObjectiveIcons.AddItem(ObjIconRecord);            
        }
        I++;
        // [Loop Continue]
        goto J0xB47;
    }
    Record.bFlashlightOn = ((AdvPlayerPawn(MyEvilPawn).MyTorch != none) ? AdvPlayerPawn(MyEvilPawn).MyTorch.bFlashlightOn : false);
    Record.bCinematicMode = self.bCinematicMode;
    // End:0xE44
    if(Record.bCinematicMode)
    {
        // End:0xD87
        if((Pawn != none) && Pawn.bHidden)
        {
            Record.bHidePlayer = true;            
        }
        else
        {
            Record.bHidePlayer = false;
        }
        Record.bAdjustMoveInput = bCinemaDisableInputMove;
        Record.bAdjustLookInput = bCinemaDisableInputLook;
        // End:0xE44
        if(myHUD != none)
        {
            Record.bAffectsHUD = !myHUD.bShowHUD;
        }
    }
    Record.SavedInventoryElements = AdvInventoryManager(Pawn.InvManager).InventoryElements;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    local bool bOldCollideAsEncoacher;
    local int I, J;
    local AdvPRI PRI;
    local TObjectiveIconStorage ObjIcon;
    local Actor FoundObjTarget;
    local Rotator CamRot;
    local Pawn FoundPawn;
    local AdvGRI GRI;
    local AdvGameSP Game;
    local GFxObject PuzzleTextField, PuzzleTextFieldBG;

    PRI = AdvPRI(PlayerReplicationInfo);
    GRI = AdvGRI(WorldInfo.GRI);
    MyGuid = Record.SavedGuid;
    LastCheckpointSaveName = Record.CheckpointName;
    // End:0xAB
    if(MyEvilPawn != none)
    {        
    }
    // End:0xE1
    if(MyEvilPawn != none)
    {
        MyEvilPawn.LifeSpan = 0.1000000;        
    }
    else
    {
        // End:0x121
        if(Vehicle(Pawn) != none)
        {
            Vehicle(Pawn).DriverLeft();
        }
    }
    UnPossess();
    bFlashlightOn = Record.bFlashlightOn;
    // End:0x3D1
    if(Record.PawnPathName == "")
    {
        WorldInfo.Game.RestartPlayer(self);
        // End:0x3CE
        if(Pawn != none)
        {
            ApplyInventoryRecords(Record.InventoryRecords);
            AdvInventoryManager(Pawn.InvManager).InventoryElements = Record.SavedInventoryElements;
            WorldInfo.Game.ChangeTeam(self, int(Record.TeamIndex), false);
            bOldCollideAsEncoacher = Pawn.bCollideAsEncroacher;
            Pawn.bCollideAsEncroacher = true;
            Pawn.SetLocation(Record.Location);
            Pawn.bCollideAsEncroacher = bOldCollideAsEncoacher;
            Pawn.SetRotation(Record.Rotation);
            CamRot = Record.Rotation;
            CamRot.Roll = 0;
            SetRotation(CamRot);
            ClientSetRotation(CamRot);
        }        
    }
    else
    {
        FoundPawn = Pawn(FindObject(Record.PawnPathName, Class'Engine.Pawn'));
        // End:0x638
        if(FoundPawn != none)
        {
            FoundPawn.SetHidden(false);
            // End:0x50B
            if(Vehicle(FoundPawn) != none)
            {
                // End:0x50B
                if(Vehicle(FoundPawn) != Pawn)
                {
                    WorldInfo.Game.RestartPlayer(self);
                    ApplyInventoryRecords(Record.InventoryRecords);
                    // End:0x50B
                    if(!Vehicle(FoundPawn).TryToDrive(Pawn))
                    {
                    }
                }
            }
            FoundPawn.SetLocation(Record.Location);
            FoundPawn.SetRotation(Record.Rotation);
            // End:0x59E
            if(FoundPawn != Pawn)
            {
                Possess(FoundPawn, false);
            }
            SetRotation(Record.Rotation);
            ClientSetRotation(Record.Rotation);
            WorldInfo.Game.ChangeTeam(self, int(Record.TeamIndex), false);
        }
    }
    // End:0x682
    if(Pawn != none)
    {
        Pawn.HealthMax = Record.HealthMax;
    }
    // End:0x7B8
    if(PRI != none)
    {
        PRI.MonstersKilled = Record.MonstersKilled;
        PRI.AmmoFound = Record.AmmoFound;
        PRI.BonusItems = Record.BonusItems;
        PRI.SecretsFound = Record.SecretsFound;
        PRI.DestroyedObjects = Record.DestroyedObjects;
    }
    GRI.BonusItemsFromFallenEnemy = Record.GRIBonusItemsFromFallenEnemy;
    GRI.GameplayTime = Record.GRIGameplayTime;
    CurrentLevelMonsterHitCounter = Record.MonsterHitCounter;
    CurrentLevelShotsCount = Record.ShotsCounter;
    StakeGunShots = Record.StakeShotCounter;
    StakeGunHits = Record.StakeGunHits;
    bPlayerGotSomeDamage = Record.bPlayerGotSomeDamage;
    PuzzleDifficultyLevel = Record.PuzzleDifficultyLevel;
    FightDifficultyLevel = Record.FightDifficultyLevel;
    GRI.CopyLevelStatisticsToGlobalStatistics(Record.CurrentLevelStatistics);
    // End:0x9C1
    if(IsLocalPlayerController())
    {
        GetPPManager().Reset();
        GRI.ResumeGameplayTimer();
    }
    Game = AdvGameSP(WorldInfo.Game);
    // End:0xB2E
    if(Game != none)
    {
        // End:0xB2E
        if(Record.bPlayingMusic)
        {
            Game.BattleMusic.Length = 1;
            Game.BattleMusic[0] = Record.BattleMusic[0];
            Game.BattleMusic[0].TheSoundCue = SoundCue(FindObject(Record.BattleCues[0], Class'Engine.SoundCue'));
            WorldInfo.UpdateMusicTrack(Game.BattleMusic[0]);
        }
    }
    bFireModeSwitch = Record.bFireModeSwitch;
    PRI = AdvPRI(PlayerReplicationInfo);
    PRI.TreasuresColected = Record.TreasuresCollected;
    I = 0;
    J0xBB8:

    // End:0xD77 [Loop If]
    if(I < Record.TreasuresPerTypeCollected.Length)
    {
        PRI.TreasuresPerTypeColected[I] = Record.TreasuresPerTypeCollected[I];
        PRI.TreasuresPerTypeAvailable[I] = Record.TreasuresPerTypeAvailable[I];
        J = 0;
        J0xC8C:

        // End:0xD69 [Loop If]
        if(J < Record.TreasuresPerkPathLevels[I].Level.Length)
        {
            TreasurePerks[I].PerkPath[J].CurrentLevel = Record.TreasuresPerkPathLevels[I].Level[J];
            J++;
            // [Loop Continue]
            goto J0xC8C;
        }
        I++;
        // [Loop Continue]
        goto J0xBB8;
    }
    ApplyTreasurePerk();
    I = 0;
    J0xD8E:

    // End:0xE16 [Loop If]
    if(I < Record.ItemsCount.Length)
    {
        PRI.ItemsCount[I] = Record.ItemsCount[I];
        I++;
        // [Loop Continue]
        goto J0xD8E;
    }
    // End:0xEAC
    if((AdvGFxHudWrapper(myHUD) != none) && AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie) != none)
    {
        AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).UpdateItemsOnHud();
    }
    ObjectiveIconStorage.Remove(0, ObjectiveIconStorage.Length);    
    I = 0;
    J0xECD:

    // End:0x1006 [Loop If]
    if(I < Record.ObjectiveIcons.Length)
    {
        FoundObjTarget = Actor(FindObject(Record.ObjectiveIcons[I].TargetPathName, Class'Engine.Actor'));
        // End:0xFF8
        if(FoundObjTarget != none)
        {
            ObjIcon.Target = FoundObjTarget;
            ObjIcon.Type = Record.ObjectiveIcons[I].Type;
            ObjectiveIconStorage.AddItem(ObjIcon);            
        }
        I++;
        // [Loop Continue]
        goto J0xECD;
    }
    // End:0x109C
    if((AdvGFxHudWrapper(myHUD) != none) && AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie) != none)
    {
        AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).RefreshObjectiveIconsFromStorage();
    }
    // End:0x11E0
    if(Record.bCinematicMode)
    {
        bCinematicMode = Record.bCinematicMode;
        Pawn.SetHidden(Record.bHidePlayer);
        bCinemaDisableInputMove = Record.bAdjustMoveInput;
        IgnoreMoveInput(bCinemaDisableInputMove);
        bCinemaDisableInputLook = Record.bAdjustLookInput;
        IgnoreLookInput(bCinemaDisableInputLook);
        ClientSetCinematicMode(bCinematicMode, bCinemaDisableInputMove, bCinemaDisableInputLook, Record.bAffectsHUD);        
    }
    else
    {
        self.SetCinematicMode(Record.bCinematicMode, Record.bCinematicMode, true, true, true, true);
    }
    PuzzleTextField = AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.TreasureTipMC_g.textField");
    PuzzleTextFieldBG = AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.bg");
    PuzzleTextFieldBG.GotoAndStop("hide");
    PuzzleTextField.SetBool("html", true);
    PuzzleTextField.SetString("htmlText", "");
    // End:0x13E6
    if(IsInState('NotepadFocus') && int(GetPuzzleDifficultyLevel()) > int(FocusMaxDifficultyLevel))
    {
        IterateOverFocusHighligths(DisableHighlightsInstant);
    }
    //return;    
}

reliable client simulated function ClientSetHUD(class<HUD> newHUDType)
{
    super(PlayerController).ClientSetHUD(newHUDType);
    AdvHudWrapper = AdvGFxHudWrapper(myHUD);
    //return;    
}

reliable client simulated function ClientSetWinnerOfTheMatch(bool bWinner)
{
    // End:0x0D
    if(bWinner)
    {
    }
    bWinnerOfTheMatch = bWinner;
    //return;    
}

reliable client simulated function ClientStartOnlineGame()
{
    local OnlineGameSettings GameSettings;
    local class<OnlineGameSettings> Defaults;
    local int DstIndex, SrcIndex;

    // End:0x376
    if((PlayerReplicationInfo != none) && WorldInfo.GRI != none)
    {
        // End:0x369
        if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && IsPrimaryPlayer())
        {
            GameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfo.SessionName);
            DstIndex = ((GameSettings != none) ? GameSettings.LocalizedSettings.Find('Id', 0) : bDelayedStart);
            // End:0x369
            if(DstIndex != -1) != Defaults = WorldInfo.GRI.GameClass.default.OnlineGameSettingsClass;
            {
                SrcIndex
                Defaults.default.LocalizedSettings.Find('Id', 0);                
                // End:0x258
                if(SrcIndex != -1)
                {
                    GameSettings.LocalizedSettings[DstIndex].ValueIndex = Defaults.default.LocalizedSettings[SrcIndex].ValueIndex;
                }
                DstIndex = GameSettings.LocalizedSettings.Find('Id', 32779);                
                // End:0x369
                if(DstIndex != -1)
                {
                    SrcIndex = Defaults.default.LocalizedSettings.Find('Id', 32779);                    
                    // End:0x369
                    if(SrcIndex != -1)
                    {
                        GameSettings.LocalizedSettings[DstIndex].ValueIndex = Defaults.default.LocalizedSettings[SrcIndex].ValueIndex;
                    }
                }
            }
        }
        super(PlayerController).ClientStartOnlineGame();
    }
    goto J0x389;
    SetTimer(0.2000000, false, 'ClientStartOnlineGame');
}

simulated function int GetGlobalStat(int stat)
{
    local int StatValue;

    ProfileSettings.GetProfileSettingValueInt(stat, StatValue);
    return StatValue;
    //return ReturnValue;    
}

reliable client simulated function TryUnlockTreasureAchievement()
{
    local int I, J;
    local AdvEngine Engine;
    local array<string> Wariors, Lights, Lives;
    local string TreasureID;
    local AdvTypes.ETreasureType TreasureType;

    Engine = AdvEngine(Class'AdvEngine'.static.GetEngine());
    I = 0;
    J0x3D:

    // End:0x2B7 [Loop If]
    if(I < 3)
    {
        // End:0x2A9
        if(!Engine.SaveSlotData[I].bIsCorrupted && Engine.SaveSlotData[I].bContainsData)
        {
            J = 0;
            J0xDA:

            // End:0x2A9 [Loop If]
            if(J < Engine.SaveSlotData[I].HeaderData.UniqueCollectedTreasures.Length)
            {
                TreasureID = Engine.SaveSlotData[I].HeaderData.UniqueCollectedTreasures[J];
                TreasureType = Class'AdvTreasureTrigger_Base'.static.GetTreasureTypeFromID(TreasureID);
                switch(TreasureType)
                {
                    // End:0x21C
                    case 0:
                        // End:0x219
                        if(Lives.Find(TreasureID) == )
                        {                            
                            Lives.AddItem(TreasureID);                            
                        }
                        // End:0x29B
                        break;
                    // End:0x25A
                    case 2:
                        // End:0x257
                        if(Wariors.Find(TreasureID) == )
                        {                            
                            Wariors.AddItem(TreasureID);                            
                        }
                        // End:0x29B
                        break;
                    // End:0x298
                    case 1:
                        // End:0x295
                        if(Lights.Find(TreasureID) == )
                        {                            
                            Lights.AddItem(TreasureID);                            
                        }
                        // End:0x29B
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
                J++;
                // [Loop Continue]
                goto J0xDA;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x3D;
    }
    I = 0;
    J0x2C2:

    // End:0x431 [Loop If]
    if(I < Engine.TemporaryCollectedTreasureIDs.Length)
    {
        TreasureID = Engine.TemporaryCollectedTreasureIDs[I];
        TreasureType = Class'AdvTreasureTrigger_Base'.static.GetTreasureTypeFromID(TreasureID);
        switch(TreasureType)
        {
            // End:0x3A4
            case 0:
                // End:0x3A1
                if(Lives.Find(TreasureID) == )
                {                    
                    Lives.AddItem(TreasureID);                    
                }
                // End:0x423
                break;
            // End:0x3E2
            case 2:
                // End:0x3DF
                if(Wariors.Find(TreasureID) == )
                {                    
                    Wariors.AddItem(TreasureID);                    
                }
                // End:0x423
                break;
            // End:0x420
            case 1:
                // End:0x41D
                if(Lights.Find(TreasureID) == )
                {                    
                    Lights.AddItem(TreasureID);                    
                }
                // End:0x423
                break;
            // End:0xFFFF
            default:
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x2C2;
    }
    // End:0x467
    if(((Lives.Length + Wariors.Length) + Lights.Length) >= 50)
    {
        ClientUnlockAchievement(16);
    }
    // End:0x485
    if(Wariors.Length >= 15)
    {
        ClientUnlockAchievement(15);
    }
    // End:0x4A3
    if(Lives.Length >= 10)
    {
        ClientUnlockAchievement(14);
    }
    // End:0x4C1
    if(Lights.Length >= 5)
    {
        ClientUnlockAchievement(13);
    }
    //return;    
}

reliable client simulated function IncrementGlobalIntStat(int StatId, optional int Amount = 1, optional bool bForceSaveProfile = false)
{
    local byte AchievID;
    local int CurrentValue;

    // End:0x1B
    if(ProfileSettings == none)
    {
        return;
    }
    ProfileSettings.GetProfileSettingValueInt(StatId, CurrentValue);
    ProfileSettings.SetProfileSettingValueInt(StatId, CurrentValue + Amount);
    AchievID = Class'AdvAchievements'.static.TranslateGlobalStatsToAchievement(StatId);
    switch(AchievID)
    {
        // End:0x10D
        case 17:
            // End:0x10A
            if((CurrentValue + Amount) >= 50)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x353
            break;
        // End:0x14D
        case 18:
            // End:0x14A
            if((CurrentValue + Amount) >= 100)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x353
            break;
        // End:0x18D
        case 20:
            // End:0x18A
            if((CurrentValue + Amount) >= 25)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x353
            break;
        // End:0x1CD
        case 36:
            // End:0x1CA
            if((CurrentValue + Amount) >= 100)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x353
            break;
        // End:0x20D
        case 37:
            // End:0x20A
            if((CurrentValue + Amount) >= 50)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x353
            break;
        // End:0x24D
        case 38:
            // End:0x24A
            if((CurrentValue + Amount) >= 100)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x353
            break;
        // End:0x28D
        case 41:
            // End:0x28A
            if((CurrentValue + Amount) >= 200)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x353
            break;
        // End:0x2CD
        case 45:
            // End:0x2CA
            if((CurrentValue + Amount) >= 10)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x353
            break;
        // End:0x30D
        case 48:
            // End:0x30A
            if((CurrentValue + Amount) >= 100)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x353
            break;
        // End:0x350
        case 50:
            // End:0x34D
            if((CurrentValue + Amount) >= 500)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x353
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function OnPickTreasureMapForAchievement(SeqAct_PickTreasureMapForAchievement Action)
{
    local AdvEngine Eng;
    local AdvGRI_SP GRI;
    local int CollectedTreasuresMaskA, CollectedTreasuresMaskB, CollectedTreasuresMaskC;
    local bool bAllTreasuresAreCollected;

    GRI = AdvGRI_SP(WorldInfo.GRI);
    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x770
    if((GRI != none) && ProfileSettings != none)
    {
        Eng.SetCollectedTreasureMap(byte(GRI.ChapterNum));
        CollectedTreasuresMaskA = Eng.GetCollectetTreasuresMaps(0);
        CollectedTreasuresMaskB = Eng.GetCollectetTreasuresMaps(1);
        CollectedTreasuresMaskC = Eng.GetCollectetTreasuresMaps(2);
        bAllTreasuresAreCollected = (((((((((((Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskA, 3) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskB, 3)) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskC, 3)) && (Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskA, 4) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskB, 4)) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskC, 4)) && (Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskA, 6) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskB, 6)) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskC, 6)) && (Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskA, 7) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskB, 7)) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskC, 7)) && (Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskA, 8) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskB, 8)) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskC, 8)) && (Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskA, 9) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskB, 9)) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskC, 9)) && (Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskA, 11) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskB, 11)) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskC, 11)) && (Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskA, 12) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskB, 12)) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskC, 12)) && (Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskA, 13) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskB, 13)) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskC, 13)) && (Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskA, 14) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskB, 14)) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskC, 14)) && (Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskA, 15) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskB, 15)) || Class'AdvProfileSettings'.static.BitIsSet(CollectedTreasuresMaskC, 15);
        // End:0x770
        if(bAllTreasuresAreCollected)
        {
            ClientUnlockAchievement(19);
        }
    }
    //return;    
}

function OnUnlockAchievement(SeqAct_UnlockAchievement Action)
{
    ClientUnlockAchievement(Action.AchievementId);
    //return;    
}

reliable client simulated function ClientUnlockAchievement(byte Achievement, optional bool bForceSaveProfile = false)
{
    local LocalPlayer LocPlayer;
    local AdvEngine Engine;
    local byte TrueAchievementID;

    // End:0x18
    if(int(Achievement) == 0)
    {
        return;
    }
    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0xCC
    if(WorldInfo.IsConsoleBuild(1))
    {
        TrueAchievementID = Engine.GetTrueAchievementIDForXBOX(Achievement);
        // End:0xB6
        if(int(TrueAchievementID) == int(255))
        {
            return;
        }
        Achievement = TrueAchievementID;        
    }
    else
    {
        // End:0x14B
        if(WorldInfo.IsConsoleBuild(2))
        {
            TrueAchievementID = Engine.GetTrueAchievementIDForPS3(Achievement);
            // End:0x138
            if(int(TrueAchievementID) == int(255))
            {
                return;
            }
            Achievement = TrueAchievementID;
        }
    }
    // End:0x17A
    if(ProfileSettings.IsAchievementUnlocked(int(Achievement)))
    {
        return;
    }
    // End:0x27B
    if(OnlineSub != none)
    {
        // End:0x278
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            LocPlayer = LocalPlayer(Player);
            // End:0x275
            if(OnlineSub.PlayerInterface.UnlockAchievement(byte(LocPlayer.ControllerId), int(Achievement)))
            {
                ProfileSettings.MarkAchievementAsUnlocked(int(Achievement), self, bForceSaveProfile);                
            }            
        }        
    }
    //return;    
}

function ProcessGameOver()
{
    local AdvPlayerController PC;

    // End:0x54
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        PC.ClientGameOver();        
    }    
    //return;    
}

reliable client simulated event ClientGameOver()
{
    ClearTimer('ProcessGameOver');
    // End:0x54
    if(AdvGFxHudWrapper(myHUD) != none)
    {
        AdvGFxHudWrapper(myHUD).ShowGameOverMenu();
    }
    //return;    
}

simulated function UpdateWithMatineCamera(float DeltaTime, out Vector POVLocation, out Rotator POVRotation)
{
    local CameraActor CamActor;
    local TViewTarget OutVT;
    local TPOV NewPOV;
    local CameraActor AdvCam;
    local float Alpha, SmoothAlpha;

    CamActor = CameraActor(ViewTarget);
    CamActor.GetCameraView(DeltaTime, OutVT.POV);
    PlayerCamera.ApplyCameraModifiers(DeltaTime, OutVT.POV);
    MatineeCameraViewRotation = OutVT.POV.Rotation;
    // End:0x50D
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        AdvCam = CamActor;
        Alpha = ((AdvCam != none) ? MatineeInterpolationAlpha : 1.0000000);
        // End:0x23F
        if(bMatineeCameraFadeActive)
        {
            // End:0x1CB
            if(bMatineeCameraFadeIn)
            {
                Alpha = (WorldInfo.TimeSeconds - MatineeCameraFadeStartTime) / MatineeCameraFadeDuration;
                // End:0x1C8
                if(Alpha >= 1.0000000)
                {
                    Alpha = 1.0000000;
                    bMatineeCameraFadeActive = false;
                }                
            }
            else
            {
                Alpha = 1.0000000 - ((WorldInfo.TimeSeconds - MatineeCameraFadeStartTime) / MatineeCameraFadeDuration);
                // End:0x23C
                if(Alpha <= float(0))
                {
                    Alpha = 0.0000000;
                    bMatineeCameraFadeActive = false;
                }
            }            
        }
        else
        {
            MatineeInterpolationAlpha = 1.0000000;
        }
        // End:0x270
        if(AdvCam != none)
        {
            MatineeInterpolationAlpha = Alpha;
        }
        // End:0x4D2
        if(Alpha < 1.0000000)
        {
            Pawn.GetActorEyesViewPoint(PrevPlayerPOV.Location, PrevPlayerPOV.Rotation);
            SmoothAlpha = FCubicInterp(0.0000000, 0.0000000, 1.0000000, 0.0000000, Alpha);
            NewPOV.Location = VLerp(PrevPlayerPOV.Location, OutVT.POV.Location, SmoothAlpha);
            NewPOV.FOV = Lerp(FOVAngle, OutVT.POV.FOV, SmoothAlpha);
            NewPOV.Rotation = RLerp(PrevPlayerPOV.Rotation, OutVT.POV.Rotation, SmoothAlpha, true);
            OutVT.POV = NewPOV;
            // End:0x4D2
            if(PlayerCamera != none)
            {
                PlayerCamera.SetFOV(NewPOV.FOV);
            }
        }
        OutVT.POV.Rotation += MatineeCameraRotation;
    }
    POVLocation = OutVT.POV.Location;
    POVRotation = OutVT.POV.Rotation;
    //return;    
}

simulated event GetPlayerViewPoint(out Vector POVLocation, out Rotator POVRotation)
{
    local float DeltaTime;
    local UTPawn P;
    local TPOV POV;
    local TViewTarget OutVT;

    P = ((IsLocalPlayerController()) ? UTPawn(CalcViewActor) : none);
    // End:0x171
    if(((((LastCameraTimeStamp == WorldInfo.TimeSeconds) && CalcViewActor == ViewTarget) && CalcViewActor != none) && CalcViewActor.Location == CalcViewActorLocation) && CalcViewActor.Rotation == CalcViewActorRotation)
    {
        // End:0x171
        if((P == none) || (P.EyeHeight == CalcEyeHeight) && P.WalkBob == CalcWalkBob)
        {
            POVLocation = CalcViewLocation;
            POVRotation = CalcViewRotation;
            return;
        }
    }
    DeltaTime = WorldInfo.TimeSeconds - LastCameraTimeStamp;
    LastCameraTimeStamp = WorldInfo.TimeSeconds;
    // End:0x315
    if(CameraActor(ViewTarget) != none)
    {
        // End:0x238
        if((PlayerCamera != none) && PlayerCamera.bLockedFOV)
        {
            PlayerCamera.bLockedFOV = false;
        }
        // End:0x262
        if(!bMatineeAlphaIsReset)
        {
            MatineeInterpolationAlpha = 1.0000000;
            bMatineeAlphaIsReset = true;
        }
        UpdateWithMatineCamera(DeltaTime, POVLocation, POVRotation);
        CalcViewActor = ViewTarget;
        CalcViewActorLocation = ViewTarget.Location;
        CalcViewActorRotation = ViewTarget.Rotation;
        CalcViewLocation = POVLocation;
        CalcViewRotation = POVRotation;
        return;        
    }
    else
    {
        // End:0x32E
        if(bMatineeCameraFadeActive)
        {
            bMatineeCameraFadeActive = false;
        }
        // End:0x347
        if(bMatineeAlphaIsReset)
        {
            bMatineeAlphaIsReset = false;
        }
        // End:0x440
        if(PlayerCamera == none)
        {
            ResetCameraMode();
            SpawnPlayerCamera();
            // End:0x3D5
            if(EvilWeap_Base(MyEvilPawn.Weapon) != none)
            {
                EvilWeap_Base(MyEvilPawn.Weapon).RestartIdleAnim(true);
            }
            // End:0x440
            if(EvilWeap_Base(MyEvilPawn.WeaponLeft) != none)
            {
                EvilWeap_Base(MyEvilPawn.WeaponLeft).RestartIdleAnim(true);
            }
        }
        // End:0x4A8
        if(PlayerCamera != none)
        {
            PlayerCamera.SetFOV(FOVAngle);
            PlayerCamera.GetCameraViewPoint(POVLocation, POVRotation);
        }
        // End:0x617
        if(ViewTarget != none)
        {
            POVRotation = Rotation;
            // End:0x5B1
            if(((PlayerReplicationInfo != none) && PlayerReplicationInfo.bOnlySpectator) && EvilVehicle_Base(ViewTarget) != none)
            {
                EvilVehicle_Base(ViewTarget).bSpectatedView = true;
                ViewTarget.CalcCamera(DeltaTime, POVLocation, POVRotation, FOVAngle);
                EvilVehicle_Base(ViewTarget).bSpectatedView = false;                
            }
            else
            {
                ViewTarget.CalcCamera(DeltaTime, POVLocation, POVRotation, FOVAngle);
            }
            // End:0x614
            if(bFreeCamera)
            {
                POVRotation = Rotation;
            }            
        }
        else
        {
            CalcCamera(DeltaTime, POVLocation, POVRotation, FOVAngle);
            return;
        }
    }
    POVRotation = Normalize(POVRotation + ShakeRot);
    POVLocation += (ShakeOffset >> ((IsInState('Dead') && MyEvilPawn != none) ? MyEvilPawn.Rotation : Rotation));
    // End:0x71B
    if(CameraEffect != none)
    {
        CameraEffect.UpdateLocation(POVLocation, POVRotation, GetFOVAngle());
    }
    // End:0x77A
    if(P != none)
    {
        CalcEyeHeight = P.EyeHeight;
        CalcWalkBob = P.WalkBob;
    }
    // End:0x9F7
    if(PlayerCamera != none)
    {
        POV.FOV = FOVAngle;
        POV.Location = POVLocation;
        POV.Rotation = POVRotation;
        PlayerCamera.ApplyCameraModifiers(DeltaTime, POV);
        OutVT.Controller = self;
        OutVT.Target = Pawn;
        OutVT.POV.FOV = FOVAngle;
        OutVT.POV.Location = POVLocation;
        OutVT.POV.Rotation = POVRotation;
        // End:0x964
        if(GamePlayerCamera(PlayerCamera) != none)
        {
            GamePlayerCamera(PlayerCamera).UpdateCameraLensEffects(OutVT);
        }
        FOVAngle = POV.FOV;
        POVLocation = POV.Location;
        POVRotation = POV.Rotation;
        PlayerCamera.SetLocation(POVLocation);
    }
    CalcViewActor = ViewTarget;
    CalcViewActorLocation = ViewTarget.Location;
    CalcViewActorRotation = ViewTarget.Rotation;
    CalcViewLocation = POVLocation;
    CalcViewRotation = POVRotation;
    //return;    
}

simulated function NotifyFinisherStart()
{
    //return;    
}

simulated function NotifyFinisherEnd()
{
    //return;    
}

function SelectPerk(int PerkNumber)
{
    ServerSelectPerk(PerkNumber, self);
    //return;    
}

reliable server function ServerSelectPerk(int PerkNumber, PlayerController PC)
{
    // End:0x144
    if((WorldInfo.GRI.IsMultiplayerGame() && AdvGameMP_Base(WorldInfo.Game).PerkManager != none) && AdvGameMP_Base(WorldInfo.Game).PerkManager.Perks.Length > PerkNumber)
    {
        AdvGameMP_Base(WorldInfo.Game).PerkManager.SelectPerk(PerkNumber, PC);        
    }
    //return;    
}

reliable client simulated function ClientShowTreasurePerkMessage(AdvTypes.ETreasureType TreasureType)
{
    SetTimer(3.0000000, false, 'ShowTreasurePerkMessage_T');
    //return;    
}

simulated function ShowTreasurePerkMessage_T()
{
    local AdvTypes.ETreasureType TreasureType;
    local class<AdvPerk_Treasure_Base> PerkClass;

    TreasureType = AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).LastTreasureTypeCollected;
    PerkClass = class<AdvPerk_Treasure_Base>(FindObject(TreasurePerks[int(TreasureType)].PerkClassName, Class'Core.Class'));
    // End:0x121
    if(PerkClass != none)
    {
        AdvGFxHudWrapper(myHUD).HudMovie.SetCenterMessageText(PerkClass.default.NotifyMessage, true);
        PlaySound(SoundCue'a_GameplaySounds.Treasure.a_TreasureFanfare', true);
    }
    //return;    
}

function ApplyTreasurePerk(optional bool bAllPerks = true, optional AdvTypes.ETreasureType TreasureType)
{
    local class<AdvPerk_Treasure_Base> PerkClass;
    local int I, J;

    // End:0x3F
    if(WorldInfo.GRI.IsMultiplayerGame())
    {
        return;
    }
    // End:0x1D6
    if(bAllPerks)
    {
        I = 0;
        J0x57:

        // End:0x1D3 [Loop If]
        if(I < 3)
        {
            J = 0;
            J0x72:

            // End:0x1C5 [Loop If]
            if(J < TreasurePerks[I].PerkPath.Length)
            {
                // End:0x1B7
                if(TreasurePerks[I].PerkPath[J].CurrentLevel > 0)
                {
                    PerkClass = class<AdvPerk_Treasure_Base>(FindObject(TreasurePerks[I].PerkClassName, Class'Core.Class'));
                    // End:0x1B7
                    if(PerkClass != none)
                    {
                        PerkClass.static.ActivateTreasurePerk(self, J, TreasurePerks[I].PerkPath[J].CurrentLevel);
                    }
                }
                J++;
                // [Loop Continue]
                goto J0x72;
            }
            I++;
            // [Loop Continue]
            goto J0x57;
        }        
    }
    else
    {
        J = 0;
        J0x1E1:

        // End:0x33C [Loop If]
        if(J < TreasurePerks[int(TreasureType)].PerkPath.Length)
        {
            // End:0x32E
            if(TreasurePerks[int(TreasureType)].PerkPath[J].CurrentLevel > 0)
            {
                PerkClass = class<AdvPerk_Treasure_Base>(FindObject(TreasurePerks[int(TreasureType)].PerkClassName, Class'Core.Class'));
                // End:0x32E
                if(PerkClass != none)
                {
                    PerkClass.static.ActivateTreasurePerk(self, J, TreasurePerks[int(TreasureType)].PerkPath[J].CurrentLevel);
                }
            }
            J++;
            // [Loop Continue]
            goto J0x1E1;
        }
    }
    //return;    
}

function int GetTreasurePerkPathCount(AdvTypes.ETreasureType TreasureType)
{
    return TreasurePerks[int(TreasureType)].PerkPath.Length;
    //return ReturnValue;    
}

function int GetTreasurePerkPathLevel(AdvTypes.ETreasureType TreasureType, int PathIndex)
{
    // End:0x7D
    if(PathIndex < TreasurePerks[int(TreasureType)].PerkPath.Length)
    {
        return TreasurePerks[int(TreasureType)].PerkPath[PathIndex].CurrentLevel;
    }
    return 0;
    //return ReturnValue;    
}

function SetTreasurePerkPathLevel(AdvTypes.ETreasureType TreasureType, int PathIndex, int Level)
{
    // End:0x86
    if(PathIndex < TreasurePerks[int(TreasureType)].PerkPath.Length)
    {
        TreasurePerks[int(TreasureType)].PerkPath[PathIndex].CurrentLevel = Level;
    }
    //return;    
}

function GetTreasuresInfoWorker(out byte TreasuresCollected[4], out byte TreasuresAvailable[4])
{
    local int I;
    local AdvPRI PRI;

    PRI = AdvPRI(PlayerReplicationInfo);
    // End:0x112
    if(PRI != none)
    {
        I = 0;
        J0x36:

        // End:0x112 [Loop If]
        if(I < 4)
        {
            TreasuresCollected[I] = 0;
            TreasuresAvailable[I] = 0;
            // End:0x101
            if(I < 3)
            {
                TreasuresCollected[I] = byte(PRI.TreasuresPerTypeColected[I]);
                TreasuresAvailable[I] = byte(PRI.TreasuresPerTypeAvailable[I]);                
            }
            else
            {
                // [Explicit Break]
                goto J0x112;
            }
            I++;
            // [Loop Continue]
            goto J0x36;
        }
    }
    J0x112:

    //return;    
}

function GetUpgradesInfoWorker(out byte UpgradesLevels[8])
{
    local int I, CurrentTreasureType, CurrentUpgradePath;

    CurrentTreasureType = 0;
    CurrentUpgradePath = 0;
    I = 0;
    J0x21:

    // End:0xDB [Loop If]
    if(I < 8)
    {
        // End:0xCA
        if(CurrentTreasureType < 3)
        {
            // End:0xA6
            if(CurrentUpgradePath < (GetTreasurePerkPathCount(byte(CurrentTreasureType))))
            {
                UpgradesLevels[I] = byte(GetTreasurePerkPathLevel(byte(CurrentTreasureType), CurrentUpgradePath));
                CurrentUpgradePath++;                
            }
            else
            {
                CurrentUpgradePath = 0;
                CurrentTreasureType++;
                --I;
            }            
        }
        else
        {
            // [Explicit Break]
            goto J0xDB;
        }
        I++;
        // [Loop Continue]
        goto J0x21;
    }
    J0xDB:

    //return;    
}

function RestoreTreasuresWorker(byte TreasuresCollected[4], byte TreasuresAvailable[4])
{
    local int I;
    local AdvPRI PRI;

    PRI = AdvPRI(PlayerReplicationInfo);
    // End:0x14E
    if(PRI != none)
    {
        PRI.TreasuresColected = 0;
        I = 0;
        J0x56:

        // End:0x14E [Loop If]
        if(I < 4)
        {
            // End:0x13D
            if(I < 3)
            {
                PRI.TreasuresPerTypeColected[I] = int(TreasuresCollected[I]);
                PRI.TreasuresPerTypeAvailable[I] = int(TreasuresAvailable[I]);
                PRI.TreasuresColected += PRI.TreasuresPerTypeColected[I];                
            }
            else
            {
                // [Explicit Break]
                goto J0x14E;
            }
            I++;
            // [Loop Continue]
            goto J0x56;
        }
    }
    J0x14E:

    //return;    
}

function RestoreUpgradesWorker(out byte UpgradesLevels[8])
{
    local int I, CurrentTreasureType, CurrentUpgradePath;

    CurrentTreasureType = 0;
    CurrentUpgradePath = 0;
    I = 0;
    J0x21:

    // End:0xDA [Loop If]
    if(I < 8)
    {
        // End:0xC9
        if(CurrentTreasureType < 3)
        {
            // End:0xA5
            if(CurrentUpgradePath < (GetTreasurePerkPathCount(byte(CurrentTreasureType))))
            {
                SetTreasurePerkPathLevel(byte(CurrentTreasureType), CurrentUpgradePath, int(UpgradesLevels[I]));
                CurrentUpgradePath++;                
            }
            else
            {
                CurrentUpgradePath = 0;
                CurrentTreasureType++;
                --I;
            }            
        }
        else
        {
            // [Explicit Break]
            goto J0xDA;
        }
        I++;
        // [Loop Continue]
        goto J0x21;
    }
    J0xDA:

    ApplyTreasurePerk();
    //return;    
}

function GetTreasuresAndUpgradesFromProfile()
{
    local byte TreasuresCollected[4], TreasuresAvailable, UpgradesLevels;

    // End:0x97
    if(ProfileSettings != none)
    {
        ProfileSettings.GetTreasuresSPData(TreasuresCollected, TreasuresAvailable);
        ProfileSettings.GetUpgradesSPData(UpgradesLevels);
        RestoreTreasuresWorker(TreasuresCollected, TreasuresAvailable);
        RestoreUpgradesWorker(UpgradesLevels);
    }
    //return;    
}

function SaveTreasuresAndUpgradesToProfile()
{
    local byte TreasuresCollected[4], TreasuresAvailable, UpgradesLevels;

    // End:0x97
    if(ProfileSettings != none)
    {
        GetTreasuresInfoWorker(TreasuresCollected, TreasuresAvailable);
        GetUpgradesInfoWorker(UpgradesLevels);
        ProfileSettings.SaveTreasuresSPData(TreasuresCollected, TreasuresAvailable);
        ProfileSettings.SaveUpgradesSPData(UpgradesLevels);
    }
    //return;    
}

function GetTreasuresAndUpgradesFromCheckpoint()
{
    local byte TreasuresCollected[4], TreasuresAvailable, UpgradesLevels;
    local AdvEngine Eng;
    local byte Data[4];
    local int I;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x3ED
    if(((Eng != none) && Eng.CurrentCheckpoint != none) && !Eng.CurrentCheckpoint.CheckpointIsEmpty())
    {
        Class'AdvProfileSettings'.static.GetBytesArrayFromInt(Eng.CurrentCheckpoint.HeaderData.TreasuresCollectedInfoA, Data);
        TreasuresCollected[0] = Data[0];
        TreasuresAvailable[0] = Data[1];
        TreasuresCollected[1] = Data[2];
        TreasuresAvailable[1] = Data[3];
        Class'AdvProfileSettings'.static.GetBytesArrayFromInt(Eng.CurrentCheckpoint.HeaderData.TreasuresCollectedInfoB, Data);
        TreasuresCollected[2] = Data[0];
        TreasuresAvailable[2] = Data[1];
        TreasuresCollected[3] = Data[2];
        TreasuresAvailable[3] = Data[3];
        RestoreTreasuresWorker(TreasuresCollected, TreasuresAvailable);
        Class'AdvProfileSettings'.static.GetBytesArrayFromInt(Eng.CurrentCheckpoint.HeaderData.UpgradesInfoA, Data);
        I = 0;
        J0x2D3:

        // End:0x318 [Loop If]
        if(I < 4)
        {
            UpgradesLevels[I] = Data[I];
            I++;
            // [Loop Continue]
            goto J0x2D3;
        }
        Class'AdvProfileSettings'.static.GetBytesArrayFromInt(Eng.CurrentCheckpoint.HeaderData.UpgradesInfoB, Data);
        I = 0;
        J0x391:

        // End:0x3DA [Loop If]
        if(I < 4)
        {
            UpgradesLevels[I + 4] = Data[I];
            I++;
            // [Loop Continue]
            goto J0x391;
        }
        RestoreUpgradesWorker(UpgradesLevels);
    }
    //return;    
}

function int StoreTreasuresInfoAToINT()
{
    local byte TreasuresCollected[4], TreasuresAvailable, Data;
    local int IntVal;

    GetTreasuresInfoWorker(TreasuresCollected, TreasuresAvailable);
    Data[0] = TreasuresCollected[0];
    Data[1] = TreasuresAvailable[0];
    Data[2] = TreasuresCollected[1];
    Data[3] = TreasuresAvailable[1];
    Class'AdvProfileSettings'.static.SetBytesArrayIntoInt(Data, IntVal);
    return IntVal;
    //return ReturnValue;    
}

function int StoreTreasuresInfoBToINT()
{
    local byte TreasuresCollected[4], TreasuresAvailable, Data;
    local int IntVal;

    GetTreasuresInfoWorker(TreasuresCollected, TreasuresAvailable);
    Data[0] = TreasuresCollected[2];
    Data[1] = TreasuresAvailable[2];
    Data[2] = TreasuresCollected[3];
    Data[3] = TreasuresAvailable[3];
    Class'AdvProfileSettings'.static.SetBytesArrayIntoInt(Data, IntVal);
    return IntVal;
    //return ReturnValue;    
}

function int StoreUpgradesInfoAToINT()
{
    local int I;
    local byte UpgradesLevels[8], Data;
    local int IntVal;

    GetUpgradesInfoWorker(UpgradesLevels);
    I = 0;
    J0x1E:

    // End:0x63 [Loop If]
    if(I < 4)
    {
        Data[I] = UpgradesLevels[I];
        I++;
        // [Loop Continue]
        goto J0x1E;
    }
    Class'AdvProfileSettings'.static.SetBytesArrayIntoInt(Data, IntVal);
    return IntVal;
    //return ReturnValue;    
}

function int StoreUpgradesInfoBToINT()
{
    local int I;
    local byte UpgradesLevels[8], Data;
    local int IntVal;

    GetUpgradesInfoWorker(UpgradesLevels);
    I = 0;
    J0x1E:

    // End:0x67 [Loop If]
    if(I < 4)
    {
        Data[I] = UpgradesLevels[I + 4];
        I++;
        // [Loop Continue]
        goto J0x1E;
    }
    Class'AdvProfileSettings'.static.SetBytesArrayIntoInt(Data, IntVal);
    return IntVal;
    //return ReturnValue;    
}

exec function DEMOToggleHelp()
{
    // End:0x95
    if((DEMOHelpScreen != none) && DEMOHelpScreen.bMovieIsOpen)
    {
        DEMOHelpScreen.Close(true);
        DEMOHelpScreen = none;
        WorldInfo.Game.ClearPause();        
    }
    else
    {
        // End:0xE4
        if(DEMOHelpScreen == none)
        {
            DEMOHelpScreen = new Class'AdvGfxMoviePlayer';
            DEMOHelpScreen.SetMovieInfo(SwfMovie'ui_advfsm.Loading_00_SP-10-Xibalba_P');
        }
        DEMOHelpScreen.Init(LocalPlayer(Player));
        DEMOHelpScreen.GetVariableObject("_root.container").SetVisible(false);
        WorldInfo.Game.SetPause(self);
    }
    //return;    
}

function bool MMenuReturn(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    ReturnToMainMenu(true);
    return true;
    //return ReturnValue;    
}

reliable server function ServerSetMPCharacter(AdvPRI PKPRI, int Idx)
{
    local AdvPlayerControllerMP PC;

    PKPRI.SetupPlayerCharacter(Idx);
    // End:0x94
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        // End:0x93
        if(PC != self)
        {
            PC.ClientLoadMPCharacter(Idx);
        }        
    }    
    //return;    
}

simulated function SetMPCharacter()
{
    local AdvPRI PKPRI;
    local int characterIndex;

    PKPRI = AdvPRI(PlayerReplicationInfo);
    // End:0x131
    if((PKPRI != none) && WorldInfo.GRI != none)
    {
        // End:0x11D
        if(WorldInfo.GRI.IsMultiplayerGame())
        {
            // End:0xE1
            if(class<AdvGameSurvivalBase>(WorldInfo.GRI.GameClass) != none)
            {
                characterIndex = GetPlayerCharacterSV();                
            }
            else
            {
                characterIndex = GetPlayerCharacterMP();
            }
            PKPRI.SetupPlayerCharacter(characterIndex);
        }
        ClearTimer('SetMPCharacter');
    }
    //return;    
}

reliable client simulated function ClientLoadFamilyInfo(AdvPRI PRI, int SkinIndex)
{
    PRI.SetupPlayerCharacter(SkinIndex);
    //return;    
}

reliable server function ServerPleaseSendMeInfoWhichSkinLoad(AdvPRI PRI)
{
    local int SkinIndex;

    SkinIndex = Class'AdvCharacterStore'.static.FindSkinIndexForGivenSkinName(PathName(PRI.GetCharClassInfo()));
    ClientLoadFamilyInfo(PRI, SkinIndex);
    //return;    
}

reliable server function ServerFamilyInfoLoaded(string FamilyInfoClassPath, AdvPRI PRI)
{
    // End:0x2B
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        return;
    }
    PRI.CharacterStore.LoadFamilyInfoClass(FamilyInfoClassPath);
    //return;    
}

function UpdateVisualAndAudioConfig()
{
    // End:0x162
    if(ProfileSettings != none)
    {
        SetAudioGroupVolume('Master', ProfileSettings.GetMasterVolume());
        SetAudioGroupVolume('Music', ProfileSettings.GetMusicVolume());
        SetAudioGroupVolume('SFX', ProfileSettings.GetSFXVolume());
        SetAudioGroupVolume('Special', ProfileSettings.GetSFXVolume());
        SetAudioGroupVolume('Voice', ProfileSettings.GetVoiceVolume());
        SetGamma(ProfileSettings.GetGamma());
        SetShowSubtitles(ProfileSettings.GetShowSubtitles());
    }
    //return;    
}

function UpdateControllerConfig()
{
    local array<BindingInfo> KeyBindingData;
    local int BindingHash;
    local AdvProfileSettings.EStickConfigOpts CurrentStickScheme;

    // End:0x4C9
    if(ProfileSettings != none)
    {
        PlayerInput.bInvertMouse = ProfileSettings.GetInvertY();
        PlayerInput.bEnableMouseSmoothing = ProfileSettings.GetMouseSmoothing();
        PlayerInput.SetSensitivity(ProfileSettings.GetMouseSensitivity());
        AdvPlayerInput(PlayerInput).SensitivityMultiplier = ProfileSettings.GetSensitivity();
        AdvPlayerInput(PlayerInput).bHoldZoom = !ProfileSettings.GetAimZoomToggle();
        // End:0x1AE
        if(ForceFeedbackManager != none)
        {
            ForceFeedbackManager.bAllowsForceFeedback = ProfileSettings.GetControllerVibrationOption();
        }
        // End:0x27C
        if(!Class'Engine.WorldInfo'.static.IsConsoleBuild(0))
        {
            ProfileSettings.GetKeyBindings(76, KeyBindingData, BindingHash);
            // End:0x248
            if(KeyBindingData.Length == 0)
            {
                AdvPlayerInput(PlayerInput).GetDefaultBindingsForPC(KeyBindingData);
            }
            AdvPlayerInput(PlayerInput).SetBindingsForPC(KeyBindingData);            
        }
        else
        {
            AdvPlayerInput(PlayerInput).ClearAllPCBindings();
        }
        CurrentStickScheme = ProfileSettings.GetStickConfigOption();
        // End:0x3C6
        if(int(CurrentStickScheme) == int(0))
        {
            UpdateControllerSettings_Worker('XboxTypeS_LeftX', "GBA_StrafeLeft_Gamepad");
            UpdateControllerSettings_Worker('XboxTypeS_LeftY', "GBA_MoveForward_Gamepad");
            UpdateControllerSettings_Worker('XboxTypeS_RightX', "GBA_TurnLeft_Gamepad");
            UpdateControllerSettings_Worker('XboxTypeS_RightY', "GBA_Look_Gamepad");
            UpdateControllerSettings_Worker('XboxTypeS_LeftThumbStick', "GBA_Sprint");
            UpdateControllerSettings_Worker('XboxTypeS_RightThumbStick', "GBA_Duck");            
        }
        else
        {
            // End:0x4C9
            if(int(CurrentStickScheme) == int(2))
            {
                UpdateControllerSettings_Worker('XboxTypeS_LeftX', "GBA_TurnLeft_Gamepad");
                UpdateControllerSettings_Worker('XboxTypeS_LeftY', "GBA_Look_Gamepad_Invert");
                UpdateControllerSettings_Worker('XboxTypeS_RightX', "GBA_StrafeLeft_Gamepad");
                UpdateControllerSettings_Worker('XboxTypeS_RightY', "GBA_MoveForward_Gamepad_Invert");
                UpdateControllerSettings_Worker('XboxTypeS_LeftThumbStick', "GBA_Duck");
                UpdateControllerSettings_Worker('XboxTypeS_RightThumbStick', "GBA_Sprint");
            }
        }
    }
    //return;    
}

private final function UpdateControllerSettings_Worker(name TheName, string TheCommand)
{
    local int BindIndex;

    BindIndex = 0;
    J0x0B:

    // End:0xD4 [Loop If]
    if(BindIndex < PlayerInput.Bindings.Length)
    {
        // End:0xC6
        if(PlayerInput.Bindings[BindIndex].Name == TheName)
        {
            PlayerInput.Bindings[BindIndex].Command = TheCommand;
        }
        ++BindIndex;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function OnDeviceSelectionComplete(bool bUserSelectedDevice)
{
    //return;    
}

function bool OnSelectDeviceChosenNotEnoughSpace(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local OnlinePlayerInterfaceEx PlayerIntEx;

    // End:0x8F
    if(SelectedInputAlias == 'AcceptSelectDevice')
    {
        PlayerIntEx = OnlineSub.PlayerInterfaceEx;
        // End:0x8C
        if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
        {
            PlayerIntEx.ShowDeviceSelectionUI(byte(PlayerIndex), 0, true);
        }        
    }
    else
    {
        // End:0xE8
        if(SelectedInputAlias == 'CancelContinueAnyway')
        {
            // End:0xE8
            if(AdvLocalPlayer(Player) != none)
            {
                AdvLocalPlayer(Player).bWantsToSkipSaves = true;
            }
        }
    }
    return true;
    //return ReturnValue;    
}

function bool OnSelectDeviceChosen(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local OnlinePlayerInterfaceEx PlayerIntEx;

    PlayerIntEx = OnlineSub.PlayerInterfaceEx;
    // End:0x42
    if(SelectedInputAlias == 'AcceptOverwrite')
    {        
    }
    else
    {
        // End:0xA6
        if(SelectedInputAlias == 'AcceptSelectDeviceOverWrite')
        {
            // End:0xA6
            if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
            {
                PlayerIntEx.ShowDeviceSelectionUI(byte(PlayerIndex), 0, true);
            }
        }
    }
    return true;
    //return ReturnValue;    
}

function OnProfileReadComplete(byte LocalUserNum, bool bWasSuccessful)
{
    local AdvLocalPlayer LP;
    local array<string> CustomMsg;

    bHasSigninChanged = false;
    bProfileSettingsUpdated = true;
    SetTimer(0.1000000, true, 'SetMPCharacter');
    ProfileSettings = AdvProfileSettings(OnlinePlayerData.ProfileProvider.Profile);
    ReplaceNoPrimaryStorageDeviceMessage();
    CheckDLCs();
    LP = AdvLocalPlayer(Player);
    // End:0x116
    if((LP != none) && !LP.bAchievementsMasksResetComplete)
    {
        LP.bAchievementsMasksResetComplete = true;
        ProfileSettings.ResetAchievementsMasks();
    }
    // End:0x546
    if(bWasSuccessful && ProfileSettings != none)
    {
        ProfileSettings.UpdateControllerSensitivity();
        ProfileSettings.UpdateGearStickConfig();
        // End:0x1F8
        if(!Class'Engine.WorldInfo'.static.IsConsoleBuild(0))
        {
            ProfileSettings.GetCustomMessages(79, CustomMsg);
            // End:0x1E5
            if(CustomMsg.Length == 0)
            {
                GetDefaultCustomMessages(CustomMsg);
            }
            CustomMessages = CustomMsg;
        }
        // End:0x3E5
        if(IsPrimaryPlayer() && (Class'AdvFrontEnd'.static.GetFrontEnd() == none) || !Class'AdvFrontEnd'.static.GetFrontEnd().bOnTitleScreen)
        {
            SetAudioGroupVolume('Master', ProfileSettings.GetMasterVolume());
            SetAudioGroupVolume('Music', ProfileSettings.GetMusicVolume());
            SetAudioGroupVolume('SFX', ProfileSettings.GetSFXVolume());
            SetAudioGroupVolume('Special', ProfileSettings.GetSFXVolume());
            SetAudioGroupVolume('Voice', ProfileSettings.GetVoiceVolume());
            SetGamma(ProfileSettings.GetGamma());
            SetShowSubtitles(ProfileSettings.GetShowSubtitles());
            SetShowTutorials(ProfileSettings.GetShowTutorials());
        }
        // End:0x434
        if(!Class'Engine.WorldInfo'.static.IsConsoleBuild(0))
        {
            FOV(ProfileSettings.GetFOV());
        }
        // End:0x51C
        if(((AdvGRI(WorldInfo.GRI) != none) && (int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_Standalone)) && !WorldInfo.IsMenuLevel())
        {
            AdvGRI(WorldInfo.GRI).LoadPartyTypeFromProfile(self);
        }
        CrosshairIndex = ProfileSettings.GetCrosshairType();
    }
    //return;    
}

function SetShowTutorials(bool bShow)
{
    local AdvEngine Engine;

    Engine = AdvEngine(Class'AdvEngine'.static.GetEngine());
    Engine.SetShowTutorials(bShow);
    //return;    
}

unreliable client simulated function ClientShowTutorial(string TutorialStringInLocalization, string TutorialSectionInLocalization)
{
    // End:0xFB
    if(AdvEngine(Class'AdvEngine'.static.GetEngine()).IsTutorialsVisible())
    {
        // End:0xFB
        if((AdvHudWrapper != none) && AdvGFxHud(AdvHudWrapper.HudMovie) != none)
        {
            AdvGFxHud(AdvHudWrapper.HudMovie).ShowTutorialPopup(true,, Localize(TutorialSectionInLocalization, TutorialStringInLocalization, "ADVGame"));
            bShowingTutorial = true;
            SetPause(true);
        }
    }
    //return;    
}

reliable client simulated function ClientHideTutorial(optional bool bInstant = false)
{
    // End:0x75
    if(bShowingTutorial)
    {
        AdvGFxHud(AdvHudWrapper.HudMovie).ShowTutorialPopup(false, !bInstant);
        bShowingTutorial = false;
        SetPause(false);
    }
    //return;    
}

exec function DebugChangeCheckPointSlot(int newSlot)
{
    local AdvEngine Engine;

    Engine = AdvEngine(Class'AdvEngine'.static.GetEngine());
    Engine.SetCheckpointSlotIndex(newSlot);
    //return;    
}

exec function SaveCheckpoint(optional name InCheckpointName, optional bool bIsLevelStart)
{
    local AdvEngine Engine;
    local AdvLocalPlayer LP;

    // End:0x1ED
    if((((IsPrimaryPlayer() && Pawn != none) && Pawn.Health > 0) && int(Role) == int(ROLE_Authority)) && (WorldInfo.TimeSeconds - LastCheckpointSaveTime) > 0.5000000)
    {
        Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
        // End:0x1ED
        if(Engine != none)
        {
            LP = AdvLocalPlayer(Player);
            // End:0x1ED
            if(LP != none)
            {
                Engine.bShouldWriteCheckpointToDisk = !LP.bWantsToSkipSaves;
                // End:0x184
                if(!WorldInfo.IsConsoleBuild())
                {
                    Engine.bShouldWriteCheckpointToDisk = true;
                }
                // End:0x1ED
                if(PersistentData != none)
                {
                    Engine.SetCurrentDeviceID(PersistentData.DeviceID);
                    SaveCheckpointWorker(bIsLevelStart, InCheckpointName);
                }
            }
        }
    }
    //return;    
}

exec function UpdateLocalCacheOfProfileSettings()
{
    local int PlayerIndex;

    GetTreasuresAndUpgradesFromCheckpoint();
    UpdateControllerConfig();
    PlayerIndex = GetUIPlayerIndex();
    // End:0x104
    if((PlayerIndex == 0) && OnlineSub != none)
    {
        // End:0x104
        if(LocalPlayer(Player) != none)
        {
            // End:0xC5
            if(Class'Engine.WorldInfo'.static.IsMenuLevel())
            {
                LocalPlayer(Player).ViewportClient.SetSplitscreenConfiguration(0);                
            }
            else
            {
                LocalPlayer(Player).ViewportClient.SetSplitscreenConfiguration(2);
            }
        }
    }
    //return;    
}

function int GetDeviceId()
{
    // End:0x2E
    if(PersistentData != none)
    {
        return PersistentData.DeviceID;
    }
    return -1;
    //return ReturnValue;    
}

function SetDeviceId(int DeviceID)
{
    // End:0x37
    if(PersistentData != none)
    {
        PersistentData.DeviceID = DeviceID;
    }
    //return;    
}

function bool IsStorageDeviceValid()
{
    // End:0x27
    if(!WorldInfo.IsConsoleBuild())
    {
        return true;
    }
    // End:0x9D
    if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
        return OnlineSub.PlayerInterfaceEx.IsDeviceValid(GetDeviceId());
    }
    return true;
    //return ReturnValue;    
}

function OnPersistentDataReadComplete(byte LocalUserNum, bool bWasSuccessful)
{
    PersistentData = AdvPlayerPersistentData(OnlinePlayerData.StorageProvider.Profile);
    bPersistentDataReadComplete = true;
    // End:0x7F
    if(ADVGame(WorldInfo.Game) != none)
    {
    }
    //return;    
}

function OnProfileWriteComplete(byte LocalUserNum, bool bWasSuccessful)
{
    //return;    
}

function bool IsOnTitleScreen()
{
    local AdvGFxMenuHudWrapper MenuHUD;

    MenuHUD = AdvGFxMenuHudWrapper(myHUD);
    return ((MenuHUD != none) && MenuHUD.Frontend != none) && MenuHUD.Frontend.bOnTitleScreen;
    //return ReturnValue;    
}

function bool IsOnMPScreens()
{
    local AdvGFxMenuHudWrapper MenuHUD;

    MenuHUD = AdvGFxMenuHudWrapper(myHUD);
    return ((MenuHUD != none) && MenuHUD.Frontend != none) && MenuHUD.Frontend.bOnMPScreens;
    //return ReturnValue;    
}

function OnLoginStatusChange(OnlineSubsystem.ELoginStatus NewStatus, UniqueNetId NewId)
{
    // End:0x37
    if(PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo.SetUniqueId(NewId);
    }
    // End:0x8E
    if(AdvEngine(Class'Engine.Engine'.static.GetEngine()).IsPlayingLoadingMovie())
    {
        bSeamlessTravel = false;
        ClientStopLevelLoadingMovie();
    }
    //return;    
}

function ShowOSSConnectionLostMessage()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x194
    if(UIManager != none)
    {
        // End:0x6F
        if(UIManager.IsUIMessageActive('ConnectionError'))
        {
            return;
        }
        ButtonAliases.AddItem('GenericAccept');        
        UIManager.ShowUIMessage('ConfirmNetworkLost', Localize("MessageBoxErrorStrings", "XboxLive_Title" $ Class'AdvFrontEnd'.static.GetLocKeySuffix(), "ADVGame"), Localize("MessageBoxErrorStrings", "LostLiveConnection_Message" $ Class'AdvFrontEnd'.static.GetLocKeySuffix(), "ADVGame"), ButtonAliases, None,,,,, false, false);
    }
    //return;    
}

function bool CheckIfSomeoneIsLogged()
{
    local int ControllerIndex, NumLogins;

    // End:0xEC
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        NumLogins = OnlineSub.GetNumSupportedLogins();
        ControllerIndex = 0;
        J0x7A:

        // End:0xEC [Loop If]
        if(ControllerIndex < NumLogins)
        {
            // End:0xDE
            if(int(OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerIndex))) > int(0))
            {
                return true;
            }
            ControllerIndex++;
            // [Loop Continue]
            goto J0x7A;
        }
    }
    return false;
    //return ReturnValue;    
}

function OnLoginChange(byte LocalUserNum)
{
    local LocalPlayer GLP;
    local UniqueNetId NetId;
    local string GamerTag;

    // End:0x2EB
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        GLP = LocalPlayer(Player);
        // End:0x22F
        if((GLP != none) && GLP.ControllerId == int(LocalUserNum))
        {
            bHasSigninChanged = true;
            OnlineSub.PlayerInterface.GetUniquePlayerId(byte(GLP.ControllerId), NetId);
            PlayerReplicationInfo.SetUniqueId(NetId);
            GamerTag = OnlineSub.PlayerInterface.GetPlayerNickname(byte(GLP.ControllerId));
            // End:0x1CD
            if(GamerTag != "")
            {
                PlayerReplicationInfo.SetPlayerName(GamerTag);                
            }
            else
            {
                PlayerReplicationInfo.SetPlayerName(Class'EvilGame.EvilGame'.default.DefaultPlayerName @ string(GLP.ControllerId + 1));
            }
        }
        // End:0x2E1
        if(int(OnlineSub.PlayerInterface.GetLoginStatus(LocalUserNum)) == int(0))
        {
            OnPersistentDataReadComplete(LocalUserNum, true);
            OnProfileReadComplete(LocalUserNum, true);
            // End:0x2DE
            if(int(WorldInfo.NetMode) == int(NM_Client))
            {
                ShowLoginChangeError();
                ReturnToMainMenu(true);
            }            
        }
        else
        {
            OnNewLogin();
        }
    }
    //return;    
}

function OnNewLogin()
{
    ShowLoginChangeError();
    //return;    
}

function OnLinkStatusChanged(bool bIsConnected)
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local AdvLocalPlayer LP;
    local AdvGRI GRI;

    GRI = AdvGRI(WorldInfo.GRI);
    LP = AdvLocalPlayer(Player);
    // End:0x1D8
    if((LP != none) && LP.bHasSeenStartScreen)
    {
        // End:0x1D8
        if(!bIsConnected && GRI.IsMultiplayerGame())
        {
            UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
            // End:0x1D8
            if(UIManager != none)
            {
                ButtonAliases.AddItem('GenericAccept');                
                UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "LostLink_Title", "ADVGame"), Localize("MessageBoxErrorStrings", "LostLink_Message", "ADVGame"), ButtonAliases, None,,,,, false, false);
                ReturnToMainMenu(true);
            }
        }
    }
    //return;    
}

final function ShowLoginChangeError()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local AdvLocalPlayer LP;

    LP = AdvLocalPlayer(Player);
    ScriptTrace();
    // End:0x1B2
    if((LP != none) && LP.bHasSeenStartScreen)
    {
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x1B2
        if(UIManager != none)
        {
            UIManager.CloseAllUIMessageBoxes(LP);
            ButtonAliases.AddItem('GenericAccept');            
            UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "IllegalSigninChange_Title", "ADVGame"), Localize("MessageBoxErrorStrings", "IllegalSigninChange_Message", "ADVGame"), ButtonAliases, None,,,,, false, false);
        }
    }
    //return;    
}

reliable client simulated event ClientWasKicked()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    // End:0x131
    if(IsPrimaryPlayer())
    {
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x131
        if(UIManager != none)
        {
            ButtonAliases.AddItem('GenericAccept');            
            UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "LostLink_Title", "ADVGame"), Localize("MessageBoxStrings", "AFKKicked_Desc", "ADVGame"), ButtonAliases, None, LocalPlayer(Player),,,, false, false);
        }
    }
    //return;    
}

protected simulated function RegisterCustomPlayerDataStores()
{
    local LocalPlayer LP;

    // End:0x19
    if(ProfileSettings != none)
    {
        UnregisterPlayerDataStores();
    }
    LP = LocalPlayer(Player);
    super(UTPlayerController).RegisterCustomPlayerDataStores();
    // End:0x108
    if(LP != none)
    {
        ProfileSettings = AdvProfileSettings(OnlinePlayerData.ProfileProvider.Profile);
        // End:0xC2
        if(OnlineSub == none)
        {
            ProfileSettings.SetToDefaults();
        }
        PersistentData = AdvPlayerPersistentData(OnlinePlayerData.StorageProvider.Profile);
    }
    //return;    
}

simulated function UnregisterPlayerDataStores()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;

    LP = LocalPlayer(Player);
    // End:0xC6
    if(LP != none)
    {
        ProfileSettings = none;
        PersistentData = none;
        DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
        // End:0xC6
        if(DataStoreManager != none)
        {
            // End:0xC3
            if(BoundEventsStringDataStore != none)
            {
                // End:0xB5
                if(!DataStoreManager.UnregisterDataStore(BoundEventsStringDataStore))
                {
                }
                BoundEventsStringDataStore = none;                
            }            
        }
    }
    super(UTPlayerController).UnregisterPlayerDataStores();
    //return;    
}

simulated function SaveProfile()
{
    local int ControllerId;

    ControllerId = LocalPlayer(Player).ControllerId;
    // End:0xE2
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        // End:0xE2
        if(ControllerId != -1)
        {
            // End:0xE2
            if(!bHasSigninChanged)
            {
                OnlineSub.PlayerInterface.WriteProfileSettings(byte(ControllerId), ProfileSettings);
            }
        }
    }
    //return;    
}

protected function SavePersistentData()
{
    local OnlinePlayerInterface PlayerInt;
    local int ControllerId;

    ControllerId = LocalPlayer(Player).ControllerId;
    // End:0xFE
    if((OnlineSub != none) && PersistentData != none)
    {
        PlayerInt = OnlineSub.PlayerInterface;
        // End:0xFE
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
        {
            // End:0xFE
            if(ControllerId != -1)
            {
                PlayerInt.WritePlayerStorage(byte(ControllerId), PersistentData, PersistentData.DeviceID);
            }
        }
    }
    //return;    
}

function bool CanReadProfileMP()
{
    local int Retval;

    // End:0x31
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function int GetPlayerCharacterMP()
{
    local int Retval;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(62, Retval))
    {
    }
    return Retval;
    //return ReturnValue;    
}

function SetPlayerCharacterMP(int val)
{
    // End:0x2F
    if(!ProfileSettings.SetProfileSettingValueInt(62, val))
    {
    }
    //return;    
}

function int GetPlayerCharacterSV()
{
    local int Retval;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(81, Retval))
    {
    }
    return Retval;
    //return ReturnValue;    
}

function SetPlayerCharacterSV(int val)
{
    // End:0x2F
    if(!ProfileSettings.SetProfileSettingValueInt(81, val))
    {
    }
    //return;    
}

function string GetStringValueMP(int dataID)
{
    local string Retval;

    // End:0x37
    if(!ProfileSettings.GetProfileSettingValue(dataID, Retval))
    {
    }
    return Retval;
    //return ReturnValue;    
}

function SetStringValueMP(int dataID, string val)
{
    // End:0x36
    if(!ProfileSettings.SetProfileSettingValue(dataID, val))
    {
    }
    //return;    
}

function int GetIntValueMP(int dataID)
{
    local int Retval;

    // End:0x36
    if(!ProfileSettings.GetProfileSettingValueInt(dataID, Retval))
    {
    }
    return Retval;
    //return ReturnValue;    
}

function SetIntValueMP(int dataID, int val)
{
    // End:0x36
    if(!ProfileSettings.SetProfileSettingValueInt(dataID, val))
    {
    }
    //return;    
}

function bool GetPublicGameMP()
{
    local int Retval;
    local bool retFlag;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
    }
    retFlag = (Retval & (1 << 0)) != 0;
    return retFlag;
    //return ReturnValue;    
}

function bool GetTeamDamageMP()
{
    local int Retval;
    local bool retFlag;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
    }
    retFlag = (Retval & (1 << 1)) != 0;
    return retFlag;
    //return ReturnValue;    
}

function bool GetTrapsMP()
{
    local int Retval;
    local bool retFlag;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
    }
    retFlag = (Retval & (1 << 2)) != 0;
    return retFlag;
    //return ReturnValue;    
}

function bool GetKillingSpreeMP()
{
    local int Retval;
    local bool retFlag;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
    }
    retFlag = (Retval & (1 << 3)) != 0;
    return retFlag;
    //return ReturnValue;    
}

function bool GetOracleMP()
{
    local int Retval;
    local bool retFlag;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
    }
    retFlag = (Retval & (1 << 4)) != 0;
    return retFlag;
    //return ReturnValue;    
}

function bool GetRealismMP()
{
    local int Retval;
    local bool retFlag;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
    }
    retFlag = (Retval & (1 << 5)) != 0;
    return retFlag;
    //return ReturnValue;    
}

function SetFlagsMP(bool PublicGameMP, bool TeamDamageMP, bool TrapsMP, bool KillingSpreeMP, bool OracleMP, bool RealismMP)
{
    local int val;

    val = 0;
    // End:0x31
    if(PublicGameMP)
    {
        val = val | (1 << 0);
    }
    // End:0x57
    if(TeamDamageMP)
    {
        val = val | (1 << 1);
    }
    // End:0x7E
    if(TrapsMP)
    {
        val = val | (1 << 2);
    }
    // End:0xA5
    if(KillingSpreeMP)
    {
        val = val | (1 << 3);
    }
    // End:0xCC
    if(OracleMP)
    {
        val = val | (1 << 4);
    }
    // End:0xF3
    if(RealismMP)
    {
        val = val | (1 << 5);
    }
    // End:0x122
    if(!ProfileSettings.SetProfileSettingValueInt(74, val))
    {
    }
    //return;    
}

function AddXP(int XP)
{
    local AdvGRI GRI;

    GRI = AdvGRI(WorldInfo.GRI);
    // End:0x13A
    if(AdvGRI(WorldInfo.GRI).CanWriteStats() && class<AdvGameSurvivalBase>(GRI.GameClass) == none)
    {
        AdvPRI(PlayerReplicationInfo).XP += int(float(XP) * GRI.ExperienceMultiplier);
        IncrementGlobalIntStat(36, int(float(XP) * GRI.ExperienceMultiplier));
        CheckPlayerLevel();
    }
    //return;    
}

function CheckPlayerLevel()
{
    local AdvPRI PRI;
    local int WeaponUnlockLevel, MaxWeaponUnlockLevel, MaxSkinUnlockLevel;
    local FamilyInfoToPackageName FamilyInfoToPackage;
    local array<int> Levels;
    local int MaxLevel;

    MaxWeaponUnlockLevel = -10;
    MaxSkinUnlockLevel = -10;
    PRI = AdvPRI(PlayerReplicationInfo);
    Levels = Class'AdvClassInfo_MP_Base'.default.LevelThresholds;
    MaxLevel = Levels.Length;
    J0x76:

    // End:0x189 [Loop If]
    if((PRI.PlayerLevel < MaxLevel) && (PRI.BaseXP + PRI.XP) >= Levels[PRI.PlayerLevel])
    {
        PRI.PlayerLevel++;
        // End:0x186
        if(AdvPlayerControllerMP(self) != none)
        {
            AdvPlayerControllerMP(self).SetLevelUpMessage(AdvPRI(PlayerReplicationInfo).PlayerLevel);
        }
        // [Loop Continue]
        goto J0x76;
    }
    // End:0x1C2
    if(PRI.PlayerLevel >= MaxLevel)
    {
        ClientUnlockAchievement(44);
    }
    // End:0x219
    foreach Class'AdvClassInfo_MP_Base'.default.EquipmentUnlockLevel(WeaponUnlockLevel)
    {
        // End:0x218
        if(WeaponUnlockLevel > MaxWeaponUnlockLevel)
        {
            MaxWeaponUnlockLevel = WeaponUnlockLevel;
        }        
    }    
    // End:0x297
    foreach Class'AdvCharacterStore'.default.FamilyInfosToPackages(FamilyInfoToPackage)
    {
        // End:0x296
        if(FamilyInfoToPackage.UnlockLevel > MaxSkinUnlockLevel)
        {
            MaxSkinUnlockLevel = FamilyInfoToPackage.UnlockLevel;
        }        
    }    
    // End:0x2D1
    if(PRI.PlayerLevel >= MaxWeaponUnlockLevel)
    {
        ClientUnlockAchievement(39);
    }
    // End:0x30A
    if(PRI.PlayerLevel >= MaxSkinUnlockLevel)
    {
        ClientUnlockAchievement(40);
    }
    //return;    
}

reliable client simulated function ClientShowEndStatisticsScreen()
{
    //return;    
}

static simulated function AdvTypes.ELevelID ComputeNextLevelIDForCurrentLevel(AdvTypes.ELevelID inLevelID)
{
    local AdvEngine Engine;

    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    return Engine.ComputeNextLevelID(inLevelID);
    //return ReturnValue;    
}

reliable client simulated function WriteEndLevelStatistics(AdvTypes.ELevelID inLevelID, bool bSuppressCheckpointSave)
{
    local LevelStatistics ls;
    local AdvPRI PRI;
    local AdvGRI PGRI;
    local AdvEngine Engine;
    local AdvGameSP GSP;

    GSP = AdvGameSP(WorldInfo.Game);
    PRI = AdvPRI(PlayerReplicationInfo);
    PGRI = AdvGRI(WorldInfo.GRI);
    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    PRI.CopyLevelStatsToLevelStatsStruct(ls);
    ProfileSettings.MarkLevelAsCompletedForAchiev(inLevelID);
    PGRI.NextLevelID = ComputeNextLevelIDForCurrentLevel(inLevelID);
    TryUnlockSomeAchievementsAtWriteEndLevelStatistics(inLevelID, ls);
    GSP.CurrentChapter = int(PGRI.NextLevelID);
    // End:0x1F0
    if(Engine.CurrentCheckpoint != none)
    {
        Engine.CurrentCheckpoint.SetLevelCompleted(int(inLevelID));
    }
    // End:0x20B
    if(!bSuppressCheckpointSave)
    {
        SaveCheckpoint(,, true);
    }
    //return;    
}

reliable client simulated function WriteEndGameInformations()
{
    //return;    
}

simulated function TryUnlockSomeAchievementsAtWriteEndLevelStatistics(AdvTypes.ELevelID inLevelID, out LevelStatistics ls)
{
    //return;    
}

function DeleteSaveGame(int InControllerID, int InDeviceId, optional bool bClearPersistent = false)
{
    local OnlinePlayerInterface PlayerInt;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    Eng.SaveSlotData[Eng.SelectedSaveSlot].bContainsData = false;
    Eng.SaveSlotData[Eng.SelectedSaveSlot].bIsCorrupted = false;
    // End:0x2AA
    if(WorldInfo.IsConsoleBuild())
    {
        // End:0x20F
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
        {
            OnlineSub.ContentInterface.DeleteSaveGame(byte(InControllerID), InDeviceId, Class'EvilGame.Checkpoint'.default.DisplayName, ("AdvCheckpoint" $ string(Eng.SelectedSaveSlot)) $ ".sav");
        }
        // End:0x2A7
        if(bClearPersistent)
        {
            // End:0x2A7
            if(OnlineSub != none)
            {
                PlayerInt = OnlineSub.PlayerInterface;
                // End:0x2A7
                if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
                {
                    PlayerInt.ClearLocalPlayerStorage(byte(InControllerID), InDeviceId);
                }
            }
        }        
    }
    else
    {
        // End:0x390
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
        {
            OnlineSub.ContentInterface.DeleteSaveGame(byte(InControllerID), InDeviceId, Class'EvilGame.Checkpoint'.default.DisplayName, ("AdvCheckpoint" $ string(Eng.SelectedSaveSlot)) $ ".sav");
        }
    }
    //return;    
}

simulated function ClearPlayerProfileOnSignThePact()
{
    local AdvLocalPlayer LP;
    local AdvEngine Engine;

    LP = AdvLocalPlayer(Player);
    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0xB7
    if((Engine != none) && Engine.CurrentCheckpoint != none)
    {
        Engine.CurrentCheckpoint.InvalidateCheckpointData();
    }
    DeleteSaveGame(LP.ControllerId, GetDeviceId());
    ProfileSettings.ClearDataOnSignThePact();
    //return;    
}

function OnDestroyDestructibleObject(EvilDestructibleObject O)
{
    //return;    
}

function OnDestroyDynamicDestructibleObject(EvilDynamicDestructibleObject O)
{
    //return;    
}

simulated function NotifyClientsHostLeavingForMigration()
{
    //return;    
}

simulated function CloseUnwantedMessageBoxes()
{
    local AdvUIManager UIManager;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.ClearUIMessage('NotifyHostMigrationStart');
    //return;    
}

simulated function CloseHostMigrationMessageBox()
{
    local AdvUIManager UIManager;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.ClearUIMessage('NotifyHostMigrationMsg');
    //return;    
}

function OpenReturnToMainMenuCogSpin()
{
    Class'AdvEngine'.static.OpenInputBlockingScene(5);
    Class'AdvUIManager'.static.UpdateButtonsOnMessageBoxesVisibility(true);
    //return;    
}

function CloseReturnToMainMenuCogSpin()
{
    local AdvUIManager Manager;

    Manager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0xA0
    if((Manager != none) && Manager.UpdatingScene != none)
    {
        Manager.UpdatingScene.WaitTimeRemaining = -1.0000000;
    }
    Class'AdvEngine'.static.CloseInputBlockingScene(5);
    Class'AdvUIManager'.static.UpdateButtonsOnMessageBoxesVisibility(false);
    //return;    
}

simulated function ExitFromMPGame()
{
    local AdvEngine Engine;
    local UniqueNetId RequestingPlayerId;

    // End:0x37
    if(PlayerReplicationInfo != none)
    {
        RequestingPlayerId = PlayerReplicationInfo.UniqueId;
    }
    AdvLocalPlayer(Player).bIsReturningFromMP = true;
    // End:0x131
    if(((AdvPreGameGRI(WorldInfo.GRI) != none) && int(AdvPreGameGRI(WorldInfo.GRI).WinningGameMode) == int(3)) || class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) != none)
    {
        AdvLocalPlayer(Player).bIsReturningFromSurvival = true;
    }
    Engine = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x191
    if(Engine != none)
    {
        Engine.StopFF();
    }
    // End:0x22A
    if((AdvGRI(WorldInfo.GRI) != none) && AdvGameMP_Base(WorldInfo.Game) != none)
    {
        AdvGameMP_Base(WorldInfo.Game).StopAllPawns();
    }
    // End:0x268
    if(IsPartyLeader())
    {
        // End:0x25A
        if(ReturnWithParty())
        {
            PartyIsLeavingGame(RequestingPlayerId);            
        }
        else
        {
            ReturnToMainMenu(false);
        }        
    }
    else
    {
        ReturnToMainMenu(false);
    }
    //return;    
}

simulated function bool ReturnWithParty()
{
    return false;
    //return ReturnValue;    
}

simulated function ReturnToMainMenu(bool bReturnToStartScreen)
{
    local OnlineGameSettings GameSettings;
    local bool bShouldTravel;
    local AdvLocalPlayer LP;
    local Engine Eng;
    local int I;

    CleanupSteamLobby();
    WorldInfo.ToggleHostMigration(false);
    // End:0x48
    if(bIsReturningFromMatch || bIsReturningToMainMenu)
    {
        return;
    }
    CloseUnwantedMessageBoxes();
    NotifyClientsHostLeavingForMigration();
    Eng = Class'Engine.Engine'.static.GetEngine();
    I = 0;
    J0x90:

    // End:0x163 [Loop If]
    if(I < Eng.GamePlayers.Length)
    {
        LP = AdvLocalPlayer(Eng.GamePlayers[I]);
        // End:0x155
        if(LP != none)
        {
            LP.ClearPostProcessSettingsOverride(0.0000000);
            LP.bIsFirstFrontEndLoad = bReturnToStartScreen;
        }
        ++I;
        // [Loop Continue]
        goto J0x90;
    }
    bShouldTravel = true;
    bIsReturningFromMatch = true;
    bIgnoreNetworkMessages = true;
    bIsReturningToMainMenu = true;
    // End:0x404
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        OpenReturnToMainMenuCogSpin();
        GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
        // End:0x325
        if(GameSettings != none)
        {
            IgnoreMoveInput(true);
            // End:0x30C
            if(int(WorldInfo.NetMode) == int(NM_Standalone))
            {
                // End:0x2FF
                if(ADVGame(WorldInfo.Game).ShouldWaitForStartupSession())
                {
                    ADVGame(WorldInfo.Game).SetStartupSessionSetupCompleteDelegate(DelayedSessionReturnToMainMenu);                    
                }
                else
                {
                    ReturnToMainMenuWorker();
                }                
            }
            else
            {
                ReturnToMainMenuWorker();
            }
            bShouldTravel = false;            
        }
        else
        {
            bShouldTravel = false;
            // End:0x3F9
            if(int(WorldInfo.NetMode) == int(NM_Standalone))
            {
                // End:0x3EB
                if(ADVGame(WorldInfo.Game).ShouldWaitForStartupSession())
                {
                    ADVGame(WorldInfo.Game).SetStartupSessionSetupCompleteDelegate(DelayedSessionReturnToMainMenuNoGameSessings);                    
                }
                else
                {
                    ReturnToMainMenuCleanupComplete(true);
                }                
            }
            else
            {
                ReturnToMainMenuCleanupComplete(true);
            }
        }
    }
    // End:0x428
    if(bShouldTravel)
    {
        ClientTravel("?Closed", 0);
    }
    //return;    
}

function DelayedSessionReturnToMainMenu(bool bSessionCreated)
{
    ReturnToMainMenuWorker();
    //return;    
}

function DelayedSessionReturnToMainMenuNoGameSessings(bool bSessionCreated)
{
    ReturnToMainMenuCleanupComplete(true);
    //return;    
}

function ReturnToMainMenuWorker()
{
    local AdvGRI GRI;
    local bool bWriteStats;

    GRI = AdvGRI(WorldInfo.GRI);
    bWriteStats = GRI.IsMultiplayerGame();
    WriteStatsAndEndGameSession(bWriteStats, true, ReturnToMainMenuCleanupComplete);
    //return;    
}

reliable client simulated function ClientReturnToMainMenu(bool bClearHistory)
{
    ReturnToMainMenu(false);
    //return;    
}

simulated function ReturnToMainMenuCleanupComplete(bool bWasSuccessful)
{
    CheckOkToDeletePartySession(OnDestroyPartyCompleteForMainMenu);
    //return;    
}

delegate OnWriteStatsAndEndSessionCompleteDelegate(bool bWasSuccessful)
{
    //return;    
}

simulated function WriteStatsAndEndGameSession(bool bWriteStats, bool bDestroySession, delegate<OnWriteStatsAndEndSessionCompleteDelegate> EndDelegate)
{
    local AdvGRI GRI;
    local OnlineGameSettings GameSettings;
    local LocalPlayer LP;

    WriteStatsAndEndSessionDelegate = EndDelegate;
    // End:0x36F
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
        // End:0x35B
        if(GameSettings != none)
        {
            // End:0x320
            if(int(GameSettings.GameState) == int(3))
            {
                GRI = AdvGRI(WorldInfo.GRI);
                // End:0x243
                if((GRI != none) && GRI.GameClass != none)
                {
                    // End:0x243
                    if(bWriteStats && CanAllPlayersPlayOnline())
                    {
                        LP = LocalPlayer(Player);
                        // End:0x243
                        if((LP != none) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(LP.ControllerId)))
                        {
                            // End:0x243
                            if(GRI.IsMultiplayerGame())
                            {
                                ClientWriteLeaderboardStats(GRI.GameClass.default.OnlineStatsWriteClass, true);
                            }
                        }
                    }
                }
                // End:0x299
                if(bDestroySession)
                {
                    OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnEndGameThenDestroyComplete);                    
                }
                else
                {
                    OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnDestroyGameComplete);
                }
                OnlineSub.GameInterface.EndOnlineGame('Game');                
            }
            else
            {
                // End:0x344
                if(bDestroySession)
                {
                    OnEndGameThenDestroyComplete('Game', true);                    
                }
                else
                {
                    OnDestroyGameComplete('Game', true);
                }
            }            
        }
        else
        {
            OnDestroyGameComplete('Game', true);
        }
    }
    //return;    
}

function DelayedEndGameSession()
{
    OnlineSub.GameInterface.EndOnlineGame('Game');
    //return;    
}

simulated function OnEndGameThenDestroyComplete(name SessionName, bool bWasSuccessful)
{
    // End:0xAD
    if(SessionName == 'Game')
    {
        // End:0xA3
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
        {
            OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndGameThenDestroyComplete);
        }
        CheckOkToDeleteGameSession();
    }
    //return;    
}

simulated function OnDestroyGameComplete(name SessionName, bool bWasSuccessful)
{
    // End:0xEA
    if(SessionName == 'Game')
    {
        // End:0xA3
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
        {
            OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnDestroyGameComplete);
        }
        // End:0xCF
        if(WriteStatsAndEndSessionDelegate != none)
        {
            OnWriteStatsAndEndSessionCompleteDelegate(bWasSuccessful);
        }
        WriteStatsAndEndSessionDelegate = None;
    }
    //return;    
}

function CheckOkToDeleteGameSession()
{
    local OnlineGameSettings GameSettings;
    local bool bWaiting;

    // End:0x23C
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
        // End:0x23C
        if(GameSettings != none)
        {
            bWaiting = true;
            // End:0x1AA
            if(((int(GameSettings.GameState) != int(2)) && int(GameSettings.GameState) != int(4)) && !GameSettings.bHasSkillUpdateInProgress)
            {
                OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyGameComplete);
                OnlineSub.GameInterface.DestroyOnlineGame('Game');                
            }
            else
            {
                // End:0x229
                if((AdvHudWrapper != none) && AdvHudWrapper.AdvPauseMenuMovie != none)
                {
                    AdvHudWrapper.AdvPauseMenuMovie.PlayCloseAnimation();
                    SetTimer(0.1000000, false, 'CheckOkToDeleteGameSession');                    
                }
                else
                {
                    SetTimer(0.2500000, false, 'CheckOkToDeleteGameSession');
                }
            }
        }
    }
    // End:0x25F
    if(!bWaiting)
    {
        OnDestroyGameComplete('Game', true);
    }
    //return;    
}

function OnConnectionStatusChange(OnlineSubsystem.EOnlineServerConnectionStatus ConnectionStatus)
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local bool bShowError;

    // End:0x42
    if(AdvGRI(WorldInfo.GRI).IsPureSinglePlayerGame())
    {
        return;
    }
    // End:0x451
    if(IsPrimaryPlayer())
    {
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x1D7
        if(int(ConnectionStatus) == int(7))
        {
            ButtonAliases.AddItem('GenericAccept');            
            UIManager.ShowUIMessage('ConfirmNetworkLost', Localize("MessageBoxErrorStrings", "SignedOut_Title" $ Class'AdvFrontEnd'.static.GetLocKeySuffix(), "ADVGame"), Localize("MessageBoxErrorStrings", "DuplicateSignin_Message" $ Class'AdvFrontEnd'.static.GetLocKeySuffix(), "ADVGame"), ButtonAliases, None, LocalPlayer(Player),,,, false, false);
            ReturnToMainMenu(true);            
        }
        else
        {
            // End:0x451
            if(WorldInfo.IsConsoleBuild())
            {
                bShowError = false;
                // End:0x289
                if((AdvGRI(WorldInfo.GRI) != none) && int(AdvGRI(WorldInfo.GRI).GetCurrentPartyType()) != int(2))
                {
                    bShowError = true;
                }
                // End:0x451
                if(bShowError)
                {
                    switch(ConnectionStatus)
                    {
                        // End:0x2AE
                        case 2:
                        // End:0x2B3
                        case 3:
                        // End:0x2B8
                        case 4:
                        // End:0x2BD
                        case 5:
                        // End:0x44E
                        case 6:
                            // End:0x44B
                            if(OnlineSub.SystemInterface.HasLinkConnection())
                            {
                                ButtonAliases.AddItem('GenericAccept');                                
                                UIManager.CloseAllUIMessageBoxes();
                                UIManager.ShowUIMessage('ConfirmNetworkLost', Localize("MessageBoxErrorStrings", "XboxLive_Title" $ Class'AdvFrontEnd'.static.GetLocKeySuffix(), "ADVGame"), Localize("MessageBoxErrorStrings", "LostLiveConnection_Message" $ Class'AdvFrontEnd'.static.GetLocKeySuffix(), "ADVGame"), ButtonAliases, None,,,,, false, false);
                                ReturnToMainMenu(true);
                            }
                            // End:0x451
                            break;
                        // End:0xFFFF
                        default:
                            break;
                    }
                }
                else
                {
                }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x451! */
            }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x1D7! */
        }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x1D7! */
        //return;        
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x042! */
}

static function string GetLobbySettingsData(const array<LobbyMetaData> lobbyData, string Key)
{
    local LobbyMetaData LD;

    // End:0x60
    foreach lobbyData(LD)
    {
        // End:0x5F
        if(LD.Key ~= Key)
        {            
            return LD.Value;
        }        
    }    
    return "";
    //return ReturnValue;    
}

static function string GetLobbyData(BasicLobbyInfo LobbyInfo, string Key)
{
    return GetLobbySettingsData(LobbyInfo.LobbySettings, Key);
    //return ReturnValue;    
}

static function string GetActiveLobbyData(ActiveLobbyInfo LobbyInfo, string Key)
{
    return GetLobbySettingsData(LobbyInfo.LobbySettings, Key);
    //return ReturnValue;    
}

reliable server function SetupSteamLobby()
{
    local UniqueNetId ZeroId;

    // End:0x31
    if(LobbyUID == ZeroId)
    {
        SetTimer(0.5000000, true, 'TryToCreateLobby');
    }
    //return;    
}

function TryToCreateLobby()
{
    local string sid;
    local UniqueNetId ServerID;

    // End:0x124
    if(((OnlineSubsystemSteamworks(OnlineSub) != none) && OnlineSubsystemSteamworks(OnlineSub).CachedAuthInt != none) && OnlineSubsystemSteamworks(OnlineSub).CachedAuthInt.GetServerUniqueId(ServerID))
    {
        sid = OnlineSub.UniqueNetIdToStringDEC(ServerID);
        CreateLobby(sid);
        OnlineSubsystemSteamworks(OnlineSub).ClearConnectionStatusChangeDelegate(OnConnectionStatusChange);
        ClearTimer('TryToCreateLobby');
    }
    //return;    
}

exec function CreateLobby(string SteamId)
{
    local OnlineLobbyInterfaceSteamworks LobbyInterface;
    local array<LobbyMetaData> InitialSettings;
    local OnlineGameSettings Settings;
    local int settingsUsePassword, PlaylistId;
    local LobbyMetaData tmpVal;

    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    Settings = OnlineSub.GameInterface.GetGameSettings('Game');
    // End:0xAE
    if((Settings != none) && Settings.bIsLanMatch)
    {
        return;
    }
    // End:0xDD
    if(!Settings.GetStringSettingValue(37, settingsUsePassword))
    {
    }
    // End:0x11E
    if(!Settings.GetIntProperty(268435457, PlaylistId))
    {
        PlaylistId = -1;
    }
    InitialSettings.Add(8);    
    InitialSettings[0].Key = "STEAMID";
    InitialSettings[0].Value = SteamId;
    InitialSettings[1].Key = "SERVERNAME";
    InitialSettings[1].Value = Settings.OwningPlayerName;
    InitialSettings[2].Key = "GAMETYPE";
    InitialSettings[2].Value = string(PlaylistId);
    InitialSettings[3].Key = "PLAYERS";
    InitialSettings[3].Value = (("" @ string(Settings.NumPublicConnections - Settings.NumOpenPublicConnections)) @ " / ") @ string(Settings.NumPublicConnections);
    InitialSettings[4].Key = "OPENSLOTS";
    InitialSettings[4].Value = string(Settings.NumOpenPublicConnections);
    InitialSettings[5].Key = "JIPALLOWED";
    InitialSettings[5].Value = ((Settings.bAllowJoinInProgress) ? "1" : "0");
    InitialSettings[6].Key = "MAPNAME";
    InitialSettings[6].Value = WorldInfo.GetMapName(true);
    InitialSettings[7].Key = "GAMEMODE";
    InitialSettings[7].Value = Settings.GetPropertyAsStringByName('CustomGameMode');
    // End:0x4C2
    foreach InitialSettings(tmpVal)
    {        
    }    
    LobbyInterface.AddCreateLobbyCompleteDelegate(OnCreateLobbyComplete);
    // End:0x541
    if(LobbyInterface.CreateLobby(Settings.NumPublicConnections, 0, InitialSettings))
    {        
    }
    else
    {
        LobbyInterface.ClearCreateLobbyCompleteDelegate(OnCreateLobbyComplete);
    }
    //return;    
}

function CleanupSteamLobby()
{
    local UniqueNetId ZeroId;
    local OnlineLobbyInterfaceSteamworks LobbyInterface;

    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    // End:0x8A
    if(LobbyUID != ZeroId)
    {
        LobbyInterface.LeaveLobby(LobbyUID);
        LobbyUID = ZeroId;
    }
    //return;    
}

function OnCreateLobbyComplete(bool bWasSuccessful, UniqueNetId LobbyId, string Error)
{
    local OnlineLobbyInterfaceSteamworks LobbyInterface;

    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    LobbyInterface.ClearCreateLobbyCompleteDelegate(OnCreateLobbyComplete);
    LobbyUID = LobbyId;
    //return;    
}

function UpdateSteamLobby(string MapName, string NumPlayers, int OpenSlots)
{
    local UniqueNetId ZeroId;
    local OnlineLobbyInterfaceSteamworks LobbyInterface;

    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    // End:0x101
    if(LobbyUID != ZeroId)
    {
        LobbyInterface.SetLobbySetting(LobbyUID, "MAPNAME", MapName);
        LobbyInterface.SetLobbySetting(LobbyUID, "PLAYERS", NumPlayers);
        LobbyInterface.SetLobbySetting(LobbyUID, "OPENSLOTS", string(OpenSlots));
    }
    //return;    
}

function UpdateSteamLobbyNumPlayers(string NumPlayers, int OpenSlots)
{
    local UniqueNetId ZeroId;
    local OnlineLobbyInterfaceSteamworks LobbyInterface;

    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    // End:0xC7
    if(LobbyUID != ZeroId)
    {
        LobbyInterface.SetLobbySetting(LobbyUID, "PLAYERS", NumPlayers);
        LobbyInterface.SetLobbySetting(LobbyUID, "OPENSLOTS", string(OpenSlots));
    }
    //return;    
}

function UpdateSteamLobbyJIP(string JIPAllowed)
{
    local UniqueNetId ZeroId;
    local OnlineLobbyInterfaceSteamworks LobbyInterface;

    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    // End:0x8C
    if(LobbyUID != ZeroId)
    {
        LobbyInterface.SetLobbySetting(LobbyUID, "JIPALLOWED", JIPAllowed);
    }
    //return;    
}

function UpdateSteamLobbyGameMode(string Mode)
{
    local UniqueNetId ZeroId;
    local OnlineLobbyInterfaceSteamworks LobbyInterface;

    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    // End:0x8D
    if(LobbyUID != ZeroId)
    {
        LobbyInterface.SetLobbySetting(LobbyUID, "GAMEMODE", Mode);        
    }
    //return;    
}

protected function OnLeaderboardStatsFlushed(name SessionName, bool bWasSuccessful)
{
    OnlineSub.StatsInterface.ClearFlushOnlineStatsCompleteDelegate(OnLeaderboardStatsFlushed);
    //return;    
}

reliable client simulated function ClientWriteOnlinePlayerScores(int LeaderboardId)
{
    //return;    
}

simulated function PunishPlayerForLeavingTheMatch()
{
    AdvPRI(PlayerReplicationInfo).Score -= float(50);
    AdvPRI(PlayerReplicationInfo).Deaths += 1;
    //return;    
}

reliable client simulated function ClientWriteLeaderboardStats(class<OnlineStatsWrite> OnlineStatsWriteClass, optional bool bIsIncomplete = false, optional bool bMigrating = false)
{
    local array<UniqueNetId> UIDList;

    // End:0x190
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
    {
        LeaderboardStatsWriteClass = class<AdvLeaderboard_Write_Base>(OnlineStatsWriteClass);
        LeaderboardStatsRead = new LeaderboardStatsWriteClass.default.LeaderboardReaderClass;
        LeaderboardStatsRead.ViewId = OnlineStatsWriteClass.default.ViewIds[0];
        UIDList.AddItem(PlayerReplicationInfo.UniqueId);        
        OnlineSub.StatsInterface.AddReadOnlineStatsCompleteDelegate(ReadLeaderboardStatsComplete);
        OnlineSub.StatsInterface.ReadOnlineStats(UIDList, LeaderboardStatsRead);
    }
    //return;    
}

simulated function ReadLeaderboardStatsComplete(bool bWasSuccessful)
{
    OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(ReadLeaderboardStatsComplete);
    // End:0x19B
    if((bWasSuccessful && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
    {
        // End:0xC0
        if(ClassIsChildOf(LeaderboardStatsWriteClass, Class'AdvLeaderboard_Write_DM'))
        {
            ReadAndWriteDMLeaderBoard();            
        }
        else
        {
            // End:0xE5
            if(ClassIsChildOf(LeaderboardStatsWriteClass, Class'AdvLeaderboard_Write_TDM'))
            {
                ReadAndWriteTDMLeaderBoard();                
            }
            else
            {
                // End:0x10A
                if(ClassIsChildOf(LeaderboardStatsWriteClass, Class'AdvLeaderboard_Write_SV'))
                {
                    ReadAndWriteSurvivalLeaderBoard();                    
                }
                else
                {
                    // End:0x12F
                    if(ClassIsChildOf(LeaderboardStatsWriteClass, Class'AdvLeaderboard_Write_CTF'))
                    {
                        ReadAndWriteCTFLeaderBoard();                        
                    }
                    else
                    {
                        // End:0x154
                        if(ClassIsChildOf(LeaderboardStatsWriteClass, Class'AdvLeaderboard_Write_LMS'))
                        {
                            ReadAndWriteLMSLeaderboard();                            
                        }
                        else
                        {
                            // End:0x179
                            if(ClassIsChildOf(LeaderboardStatsWriteClass, Class'AdvLeaderboard_Write_TH'))
                            {
                                ReadAndWriteTHLeaderboard();                                
                            }
                            else
                            {
                                // End:0x19B
                                if(ClassIsChildOf(LeaderboardStatsWriteClass, Class'AdvLeaderboard_Write_TTH'))
                                {
                                    ReadAndWriteTTHLeaderboard();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    ClientSaveAllPlayerData(true);
    LeaderboardStatsRead = none;
    //return;    
}

simulated function ReadAndWriteLMSLeaderboard()
{
    local AdvPRI PRI;
    local AdvLeaderboard_Read_LMS Reader;
    local AdvLeaderboard_Write_LMS Writer;
    local int CurrentScore, OldScore, CurrentKills, OldKills, CurrentDeaths, OldDeaths,
	    CurrentRescues, OldRescues;

    PRI = AdvPRI(PlayerReplicationInfo);
    Reader = AdvLeaderboard_Read_LMS(LeaderboardStatsRead);
    OldScore = Reader.GetScore(PRI.UniqueId);
    OldKills = Reader.GetKills(PRI.UniqueId);
    OldDeaths = Reader.GetDeaths(PRI.UniqueId);
    OldRescues = Reader.GetRescues(PRI.UniqueId);
    CurrentScore = int(float(OldScore) + PRI.Score);
    CurrentKills = OldKills + PRI.Kills;
    CurrentDeaths = OldDeaths + PRI.Deaths;
    CurrentRescues = OldRescues + PRI.RescuesCount;
    Writer = AdvLeaderboard_Write_LMS(new LeaderboardStatsWriteClass);
    Writer.SetScore(CurrentScore);
    Writer.SetKills(CurrentKills);
    Writer.SetDeaths(CurrentDeaths);
    Writer.SetRescues(CurrentRescues);
    OnlineSub.StatsInterface.WriteOnlineStats(PRI.SessionName, PRI.UniqueId, Writer);
    OnlineSub.StatsInterface.FlushOnlineStats(PRI.SessionName);
    //return;    
}

simulated function ReadAndWriteTHLeaderboard()
{
    local AdvPRI PRI;
    local AdvLeaderboard_Read_TH Reader;
    local AdvLeaderboard_Write_TH Writer;
    local int CurrentScore, OldScore, CurrentKills, OldKills, CurrentDeaths, OldDeaths,
	    CurrentTreasures, OldTreasures;

    PRI = AdvPRI(PlayerReplicationInfo);
    Reader = AdvLeaderboard_Read_TH(LeaderboardStatsRead);
    OldScore = Reader.GetScore(PRI.UniqueId);
    OldKills = Reader.GetKills(PRI.UniqueId);
    OldDeaths = Reader.GetDeaths(PRI.UniqueId);
    OldTreasures = Reader.GetTreasures(PRI.UniqueId);
    CurrentScore = int(float(OldScore) + PRI.Score);
    CurrentKills = OldKills + PRI.Kills;
    CurrentDeaths = OldDeaths + PRI.Deaths;
    CurrentTreasures = (OldTreasures + PRI.TotalTeamMultiplayerTreasuresColected) + PRI.TotalEnemyMultiplayerTreasuresColected;
    Writer = AdvLeaderboard_Write_TH(new LeaderboardStatsWriteClass);
    Writer.SetScore(CurrentScore);
    Writer.SetKills(CurrentKills);
    Writer.SetDeaths(CurrentDeaths);
    Writer.SetTreasures(CurrentTreasures);
    OnlineSub.StatsInterface.WriteOnlineStats(PRI.SessionName, PRI.UniqueId, Writer);
    OnlineSub.StatsInterface.FlushOnlineStats(PRI.SessionName);
    //return;    
}

simulated function ReadAndWriteTTHLeaderboard()
{
    local AdvPRI PRI;
    local AdvLeaderboard_Read_TTH Reader;
    local AdvLeaderboard_Write_TTH Writer;
    local int CurrentScore, OldScore, CurrentKills, OldKills, CurrentDeaths, OldDeaths,
	    CurrentTreasures, OldTreasures;

    PRI = AdvPRI(PlayerReplicationInfo);
    Reader = AdvLeaderboard_Read_TTH(LeaderboardStatsRead);
    OldScore = Reader.GetScore(PRI.UniqueId);
    OldKills = Reader.GetKills(PRI.UniqueId);
    OldDeaths = Reader.GetDeaths(PRI.UniqueId);
    OldTreasures = Reader.GetTreasures(PRI.UniqueId);
    CurrentScore = int(float(OldScore) + PRI.Score);
    CurrentKills = OldKills + PRI.Kills;
    CurrentDeaths = OldDeaths + PRI.Deaths;
    CurrentTreasures = (OldTreasures + PRI.TotalTeamMultiplayerTreasuresColected) + PRI.TotalEnemyMultiplayerTreasuresColected;
    Writer = AdvLeaderboard_Write_TTH(new LeaderboardStatsWriteClass);
    Writer.SetScore(CurrentScore);
    Writer.SetKills(CurrentKills);
    Writer.SetDeaths(CurrentDeaths);
    Writer.SetTreasures(CurrentTreasures);
    OnlineSub.StatsInterface.WriteOnlineStats(PRI.SessionName, PRI.UniqueId, Writer);
    OnlineSub.StatsInterface.FlushOnlineStats(PRI.SessionName);
    //return;    
}

simulated function ReadAndWriteSurvivalLeaderBoard()
{
    local AdvPRI PRI;
    local AdvLeaderboard_Read_SV Reader;
    local AdvLeaderboard_Write_SV Writer;
    local int CurrentScore, OldScore, CurrentEnemiesKills, OldEnemiesKilled, CurrentWaves, OldWaves;

    PRI = AdvPRI(PlayerReplicationInfo);
    Reader = AdvLeaderboard_Read_SV(LeaderboardStatsRead);
    OldScore = Reader.GetScore(PRI.UniqueId);
    OldEnemiesKilled = Reader.GetKills(PRI.UniqueId);
    OldWaves = Reader.GetWaves(PRI.UniqueId);
    CurrentScore = int(float(OldScore) + PRI.Score);
    CurrentEnemiesKills = OldEnemiesKilled + PRI.Kills;
    CurrentWaves = OldWaves + PRI.WavesCount;
    Writer = AdvLeaderboard_Write_SV(new LeaderboardStatsWriteClass);
    Writer.SetScore(CurrentScore);
    Writer.SetKills(CurrentEnemiesKills);
    Writer.SetWaves(CurrentWaves);
    OnlineSub.StatsInterface.WriteOnlineStats(PRI.SessionName, PRI.UniqueId, Writer);
    OnlineSub.StatsInterface.FlushOnlineStats(PRI.SessionName);
    //return;    
}

simulated function ReadAndWriteCTFLeaderBoard()
{
    local AdvPRI PRI;
    local AdvLeaderboard_Read_CTF Reader;
    local AdvLeaderboard_Write_CTF Writer;
    local int CurrentScore, OldScore, CurrentFlagsCaptured, OldFlagsCaptured, CurrentFlagsReturned, OldFlagsReturned;

    PRI = AdvPRI(PlayerReplicationInfo);
    Reader = AdvLeaderboard_Read_CTF(LeaderboardStatsRead);
    OldScore = Reader.GetScore(PRI.UniqueId);
    OldFlagsCaptured = Reader.GetFlagsCaptured(PRI.UniqueId);
    OldFlagsReturned = Reader.GetFlagsReturned(PRI.UniqueId);
    CurrentScore = int(PRI.Score + float(OldScore));
    CurrentFlagsCaptured = PRI.GetFlagsCapturedSinceLastWrite() + OldFlagsCaptured;
    CurrentFlagsReturned = PRI.GetFlagsReturnedSinceLastWrite() + OldFlagsReturned;
    Writer = AdvLeaderboard_Write_CTF(new LeaderboardStatsWriteClass);
    Writer.SetScore(CurrentScore);
    Writer.SetFlagsCaptured(CurrentFlagsCaptured);
    Writer.SetFlagsReturned(CurrentFlagsReturned);
    OnlineSub.StatsInterface.WriteOnlineStats('Game', PRI.UniqueId, Writer);
    OnlineSub.StatsInterface.FlushOnlineStats('Game');
    //return;    
}

simulated function ReadAndWriteDMLeaderBoard()
{
    local AdvPRI PRI;
    local AdvLeaderboard_Read_DM Reader;
    local AdvLeaderboard_Write_DM Writer;
    local int CurrentScore, OldScore, CurrentKills, OldKills, CurrentDeaths, OldDeaths,
	    CurrentAssists, OldAssists;

    PRI = AdvPRI(PlayerReplicationInfo);
    Reader = AdvLeaderboard_Read_DM(LeaderboardStatsRead);
    OldScore = Reader.GetScore(PRI.UniqueId);
    OldKills = Reader.GetKills(PRI.UniqueId);
    OldAssists = Reader.GetAssists(PRI.UniqueId);
    OldDeaths = Reader.GetDeaths(PRI.UniqueId);
    CurrentScore = int(PRI.Score + float(OldScore));
    CurrentKills = PRI.Kills + OldKills;
    CurrentAssists = PRI.Assists + OldAssists;
    CurrentDeaths = PRI.Deaths + OldDeaths;
    Writer = AdvLeaderboard_Write_DM(new LeaderboardStatsWriteClass);
    Writer.SetScore(CurrentScore);
    Writer.SetKills(CurrentKills);
    Writer.SetAssists(CurrentAssists);
    Writer.SetDeaths(CurrentDeaths);
    OnlineSub.StatsInterface.WriteOnlineStats('Game', PRI.UniqueId, Writer);
    OnlineSub.StatsInterface.FlushOnlineStats('Game');
    //return;    
}

simulated function ReadAndWriteTDMLeaderBoard()
{
    local AdvPRI PRI;
    local AdvLeaderboard_Read_TDM Reader;
    local AdvLeaderboard_Write_TDM Writer;
    local int CurrentScore, OldScore, CurrentKills, OldKills, CurrentDeaths, OldDeaths,
	    CurrentAssists, OldAssists;

    PRI = AdvPRI(PlayerReplicationInfo);
    Reader = AdvLeaderboard_Read_TDM(LeaderboardStatsRead);
    OldScore = Reader.GetScore(PRI.UniqueId);
    OldKills = Reader.GetKills(PRI.UniqueId);
    OldAssists = Reader.GetAssists(PRI.UniqueId);
    OldDeaths = Reader.GetDeaths(PRI.UniqueId);
    CurrentScore = int(PRI.Score + float(OldScore));
    CurrentKills = PRI.Kills + OldKills;
    CurrentAssists = PRI.Assists + OldAssists;
    CurrentDeaths = PRI.Deaths + OldDeaths;
    Writer = AdvLeaderboard_Write_TDM(new LeaderboardStatsWriteClass);
    Writer.SetScore(CurrentScore);
    Writer.SetKills(CurrentKills);
    Writer.SetAssists(CurrentAssists);
    Writer.SetDeaths(CurrentDeaths);
    OnlineSub.StatsInterface.WriteOnlineStats('Game', PRI.UniqueId, Writer);
    OnlineSub.StatsInterface.FlushOnlineStats('Game');
    //return;    
}

simulated event Destroyed()
{
    local AdvGRI GRI;

    super.Destroyed();
    CleanupSteamLobby();
    GRI = AdvGRI(WorldInfo.GRI);
    // End:0x9B
    if((GRI != none) && GRI.IsMultiplayerGame())
    {
        Pawn.Destroy();
        MyEvilPawn = none;
    }
    // End:0xCD
    if(AdvHudWrapper != none)
    {
        AdvHudWrapper.Destroy();
        AdvHudWrapper = none;
    }
    // End:0xFF
    if(PlayerCamera != none)
    {
        PlayerCamera.Destroy();
        PlayerCamera = none;
    }
    ClearOnlineDelegates();
    UnregisterPlayerDataStores();
    //return;    
}

event PreClientTravel(string PendingURL, Actor.ETravelType TravelType, bool bIsSeamlessTravel)
{
    local string MapName;
    local int OptionStart;
    local string NewGameType;
    local AdvGRI GRI;

    super(PlayerController).PreClientTravel(PendingURL, TravelType, bIsSeamlessTravel);
    bSeamlessTravel = bIsSeamlessTravel;
    GRI = AdvGRI(WorldInfo.GRI);
    OptionStart = InStr(PendingURL, "?");
    // End:0xB0
    if(OptionStart == -1)
    {
        MapName = PendingURL;        
    }
    else
    {
        MapName = Left(PendingURL, OptionStart);
    }
    // End:0x255
    if(GRI.IsMultiplayerGame() || GRI.IsInPregameLobby())
    {
        OptionStart = InStr(PendingURL, "game=");
        // End:0x1C1
        if(OptionStart != -1)
        {
            NewGameType = Right(PendingURL, (Len(PendingURL) - OptionStart) - 5);
            OptionStart = InStr(NewGameType, "?");
            // End:0x1C1
            if(OptionStart != -1)
            {
                NewGameType = Left(NewGameType, OptionStart);
            }
        }
        // End:0x1FE
        if(NewGameType ~= "AdvGame.AdvPreGameLobbyGame_Base")
        {
            ClientShowReturnToLobbyMovie();            
        }
        else
        {
            // End:0x236
            if(Class'AdvPlayerController'.static.IsMenuMap(MapName))
            {
                ClientShowDefaultLoadingMovie();                
            }
            else
            {
                ClientShowMPLevelLoadingMovie(MapName, PendingURL);
            }
        }        
    }
    else
    {
        // End:0x28A
        if(Class'AdvPlayerController'.static.IsMenuMap(MapName))
        {
            ClientShowDefaultLoadingMovie();
        }
    }
    //return;    
}

exec function LoadCheckpoint(optional name InCheckpointName)
{
    local AdvPlayerController PC;
    local AdvGFxHudWrapper HUD;

    // End:0xA2
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        HUD = AdvGFxHudWrapper(PC.myHUD);
        // End:0xA1
        if(HUD != none)
        {
            HUD.bWasVisibleBeforePause = true;
            HUD.SetVisible(true);
        }        
    }    
    super.LoadCheckpoint(InCheckpointName);
    //return;    
}

exec function RestartLevel()
{
    local AdvPlayerController PC;
    local AdvGFxHudWrapper HUD;

    // End:0xA1
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        HUD = AdvGFxHudWrapper(PC.myHUD);
        // End:0xA0
        if(HUD != none)
        {
            HUD.bWasVisibleBeforePause = true;
            HUD.SetVisible(true);
        }        
    }    
    // End:0x245
    if(!WorldInfo.GRI.IsMultiplayerGame())
    {
        AdvEngine(Class'AdvEngine'.static.GetEngine()).RestoreTreasuresAndUpgradesInfoFromInitialLevelData();
        GetTreasuresAndUpgradesFromCheckpoint();
        ClientShowLevelLoadingMovieByChapter(AdvGameSP(WorldInfo.Game).CurrentChapter);
        WorldInfo.ServerTravel((((("ADVGame_P?loadcheckpoint=0?chapter=" $ string(AdvGameSP(WorldInfo.Game).CurrentChapter)) $ "?PuzzleDifficultyLevel=") $ string(int(PuzzleDifficultyLevel))) $ "?FightDifficultyLevel=") $ string(int(FightDifficultyLevel)));        
    }
    else
    {
        super(PlayerController).RestartLevel();
    }
    //return;    
}

exec function RestartLevel2()
{
    // End:0x41
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        ClientTravel("?restart", NM_ListenServer);
    }
    //return;    
}

simulated function int GetControllerId()
{
    local LocalPlayer LP;

    LP = LocalPlayer(Player);
    // End:0x4A
    if(LP != none)
    {
        return LP.ControllerId;
    }
    return -1;
    //return ReturnValue;    
}

event InitInputSystem()
{
    super(UTPlayerController).InitInputSystem();
    // End:0x4C
    if((int(WorldInfo.NetMode) == int(NM_Client)) && IsPrimaryPlayer())
    {
        ServerStopLevelLoadingMovie();
    }
    AdvEngine(Class'AdvEngine'.static.GetEngine()).SetCheckMapLoading(false);
    // End:0xB9
    if(IsPrimaryPlayer())
    {
        Class'AdvEngine'.static.SetEngineState(NM_Standalone);
    }
    //return;    
}

reliable server function ServerStopLevelLoadingMovie()
{
    ClientStopLevelLoadingMovie();
    //return;    
}

simulated function ReplaceNoPrimaryStorageDeviceMessage()
{
    //return;    
}

exec function ConditionalPauseGame()
{
    local string CurrentMovieName;

    GetCurrentMovie(CurrentMovieName);
    // End:0x2E
    if(CurrentMovieName == "")
    {
        PauseGame();
    }
    //return;    
}

delegate bool CanUnpause()
{
    return (WorldInfo.Pauser == PlayerReplicationInfo) || IsSplitscreenPlayer();
    //return ReturnValue;    
}

function bool SetPause(bool bPause, optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
    local bool bRetval;
    local AdvPlayerController PC;
    local AdvUIManager UIManager;

    bRetval = super(PlayerController).SetPause(bPause, CanUnpauseDelegate);
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0xAE
    if(bPause)
    {
        // End:0xAB
        if(AdvHudWrapper != none)
        {
            AdvHudWrapper.SetVisibilityForPause(true);
        }        
    }
    else
    {
        // End:0x104
        if(WorldInfo.Pauser == none)
        {
            // End:0x101
            if(AdvHudWrapper != none)
            {
                AdvHudWrapper.SetVisibilityForPause(false);
            }            
        }
        else
        {
            // End:0x14E
            if(!UIManager.IsUIMessageActive('HostPaused', LocalPlayer(Player)))
            {
                ClientUpdateHostPause(true);
            }
        }
    }
    // End:0x255
    if((!bPause && int(WorldInfo.NetMode) != int(NM_Client)) && WorldInfo.Pauser == none)
    {
        // End:0x255
        if(WorldInfo.Pauser == none)
        {
            // End:0x254
            foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
            {
                // End:0x253
                if(LocalPlayer(PC.Player) == none)
                {
                    PC.ClientUpdateHostPause(false);
                }                
            }            
        }
    }
    return bRetval;
    //return ReturnValue;    
}

function UnPauseGame()
{
    AdvHudWrapper.UnPauseGame();
    //return;    
}

function PauseGame(optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
    local AdvPlayerController PC;
    local delegate<CanUnpause> DefaultUnpauseDelegate;
    local AdvGameSP Game;

    DefaultUnpauseDelegate = CanUnpause;
    Game = AdvGameSP(WorldInfo.Game);
    // End:0x296
    if(!IsTimerActive('ProcessGameOver'))
    {
        // End:0x293
        if((!bCinematicMode || IsPrimaryPlayer()) && (Game == none) || Game.bLoadingScreenFinished)
        {
            // End:0x15A
            if(AdvHudWrapper != none)
            {
                // End:0x12F
                if(CanUnpauseDelegate == DefaultUnpauseDelegate || CanUnpauseDelegate == )
                {
                    AdvHudWrapper.PauseGame();                    
                }
                else
                {
                    AdvHudWrapper.PauseGame(CanUnpauseDelegate);
                }                
            }
            else
            {
                SetPause(true, CanUnpauseDelegate);
            }
            // End:0x293
            if((int(Role) == int(ROLE_Authority)) && WorldInfo.Pauser != none)
            {
                // End:0x292
                foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
                {
                    // End:0x291
                    if((LocalPlayer(PC.Player) == none) || PC.IsSplitscreenPlayer() && PC.PlayerReplicationInfo != WorldInfo.Pauser)
                    {
                        PC.ClientUpdateHostPause(true);
                    }                    
                }                
            }
        }        
    }
    else
    {
        ClearTimer('ProcessGameOver');
        ProcessGameOver();
    }
    //return;    
}

simulated function bool DoNotClose(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    return false;
    //return ReturnValue;    
}

function ProcessClientPauseKey(int ControllerIdx)
{
    local AdvPlayerController PC;

    // End:0x8A
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        // End:0x89
        if(LocalPlayer(PC.Player).ControllerId == ControllerIdx)
        {
            PC.PauseGame();
        }        
    }    
    //return;    
}

exec function ForceHostPause(optional bool bEnable = true)
{
    local array<name> ButtonArray;
    local AdvUIManager UIManager;
    local UIScene_MessageBox MessageBox;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x17F
    if(bEnable)
    {
        ButtonArray.Length = 0;
        UIManager.ClearUIMessage('HostPaused', none, true);
        UIManager.ShowUIMessage('HostPaused', Localize("MessageBoxStrings", "HostPaused_Title", "ADVGame"), Localize("MessageBoxStrings", "HostPaused_Text", "ADVGame"), ButtonArray, DoNotClose,, MessageBox, 60,, false);
        // End:0x17C
        if(MessageBox != none)
        {
            MessageBox.__OnStartButtonPressed__Delegate = ProcessClientPauseKey;
        }        
    }
    else
    {
        UIManager.ClearUIMessage('HostPaused');
    }
    //return;    
}

reliable client simulated function ClientUpdateHostPause(bool bNowPaused)
{
    local array<name> ButtonArray;
    local AdvUIManager UIManager;
    local UIScene_MessageBox MessageBox;
    local string Title, Text;

    // End:0x27E
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x93
        if(AdvHudWrapper != none)
        {
            AdvHudWrapper.SetVisibilityForPause(bNowPaused);
        }
        // End:0x240
        if(bNowPaused)
        {
            ButtonArray.Length = 0;
            Title = Localize("MessageBoxStrings", "HostPaused_Title", "ADVGame");
            Text = Localize("MessageBoxStrings", "HostPaused_Text", "ADVGame");
            UIManager.ClearUIMessage('HostPaused', LocalPlayer(Player), true);
            UIManager.ShowUIMessage('HostPaused', Title, Text, ButtonArray, DoNotClose, LocalPlayer(Player), MessageBox, 60,, IsSplitscreenPlayer());
            // End:0x22A
            if(MessageBox != none)
            {
                MessageBox.__OnStartButtonPressed__Delegate = ProcessClientPauseKey;
            }
            SetTimer(0.5000000, true, 'ServerVerifyPausedState');            
        }
        else
        {
            UIManager.ClearUIMessage('HostPaused');
            ClearTimer('ServerVerifyPausedState');
        }
    }
    //return;    
}

unreliable server final function ServerVerifyPausedState()
{
    // End:0x2E
    if(WorldInfo.Pauser == none)
    {
        UnreliableClientClearHostPause();
    }
    //return;    
}

unreliable client final simulated function UnreliableClientClearHostPause()
{
    ClientUpdateHostPause(false);
    //return;    
}

function OnControllerChanged(int ControllerId, bool bIsConnected)
{
    local LocalPlayer LP;
    local bool bIsTraveling, bMenuLevel, bOpenPauseMenu, bOpenPauseMenuNoPause;
    local OnlinePlayerInterface PlayerInterface;
    local byte PlayerID;
    local int NumPlayersOnMachine;
    local string ActiveMovieName;
    local AdvPlayerController PC;
    local Engine Eng;
    local UIInteraction UICtrl;
    local AdvGRI_SP GRI;

    LP = LocalPlayer(Player);
    Eng = Class'Engine.Engine'.static.GetEngine();
    UICtrl = Eng.GamePlayers[0].ViewportClient.UIController;
    // End:0x5EE
    if(((LP != none) && WorldInfo.IsConsoleBuild()) && (WorldInfo.Game == none) || !WorldInfo.Game.IsAutomatedPerfTesting())
    {
        PlayerID = byte(LP.ControllerId);
        bMenuLevel = Class'Engine.WorldInfo'.static.IsMenuLevel();
        GRI = AdvGRI_SP(WorldInfo.GRI);
        // End:0x215
        if(bMenuLevel || (GRI != none) && GRI.Finished)
        {
            OnControllerChangedInMenu(ControllerId, bIsConnected);
            return;
        }
        // End:0x5EE
        if(int(PlayerID) == ControllerId)
        {
            bIsControllerConnected = bIsConnected;
            // End:0x42C
            if(OnlineSub != none)
            {
                PlayerInterface = OnlineSub.PlayerInterface;
                // End:0x42C
                if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
                {
                    GetCurrentMovie(ActiveMovieName);
                    bIsTraveling = (GameEngine(LP.Outer).TravelURL != "") || ActiveMovieName != "";
                    // End:0x42C
                    if(!bIsTraveling && !bIsConnected)
                    {
                        // End:0x415
                        if(WorldInfo.Game != none)
                        {
                            NumPlayersOnMachine = Class'Engine.UIInteraction'.static.GetPlayerCount();
                            // End:0x3DD
                            if(NumPlayersOnMachine > 2)
                            {
                                Eng.GamePlayers[0].ViewportClient.RemovePlayer(LP);
                                return;
                            }
                            // End:0x3FB
                            if(NumPlayersOnMachine == 1)
                            {
                                bOpenPauseMenu = true;                                
                            }
                            else
                            {
                                bOpenPauseMenuNoPause = !bMenuLevel;
                            }                            
                        }
                        else
                        {
                            bOpenPauseMenuNoPause = !bMenuLevel;
                        }
                    }
                }
            }
            // End:0x58C
            if(bOpenPauseMenu || bOpenPauseMenuNoPause && AdvHudWrapper != none)
            {
                // End:0x484
                if(bOpenPauseMenu)
                {
                    PauseGame(CanUnpauseControllerConnected);                    
                }
                else
                {
                    // End:0x589
                    if(bOpenPauseMenuNoPause && AdvHudWrapper != none)
                    {
                        // End:0x569
                        if(int(WorldInfo.NetMode) != int(NM_Client))
                        {
                            // End:0x568
                            foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
                            {
                                // End:0x567
                                if(!PC.IsLocalPlayerController() && PC.IsPrimaryPlayer())
                                {
                                    PC.ClientUpdateHostPause(true);
                                }                                
                            }                            
                        }
                        AdvHudWrapper.PauseGame();
                    }
                }                
            }
            else
            {
                // End:0x5EE
                if(bIsConnected)
                {
                    // End:0x5EE
                    if((AdvHudWrapper == none) || !AdvHudWrapper.IsGamePaused())
                    {
                        LP.ClearPostProcessSettingsOverride();
                    }
                }
            }
        }
    }
    //return;    
}

function OnControllerChangedInMenu(int ControllerId, bool bIsConnected)
{
    local array<name> ButtonArray;
    local AdvUIManager UIManager;
    local UIInteraction UICtrl;
    local LocalPlayer LP;
    local Engine Eng;
    local bool bIsOnIIS, bIsPlayingCloseAnimation;

    LP = LocalPlayer(Player);
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    Eng = Class'Engine.Engine'.static.GetEngine();
    UICtrl = Eng.GamePlayers[0].ViewportClient.UIController;
    // End:0x1C1
    if(Class'AdvFrontEnd'.static.GetFrontEnd() != none)
    {
        bIsOnIIS = Class'AdvFrontEnd'.static.GetFrontEnd().bOnTitleScreen;
        bIsPlayingCloseAnimation = (Class'AdvFrontEnd'.static.GetFrontEnd().CurrentScene != none) && Class'AdvFrontEnd'.static.GetFrontEnd().CurrentScene.bIsPlayingCloseAnimation;
    }
    // End:0x318
    if(bIsOnIIS)
    {
        // End:0x2EC
        if(!bIsConnected)
        {
            // End:0x2E9
            if(UICtrl.GetConnectedGamepadCount() == 0)
            {
                ButtonArray.Length = 0;
                UIManager.ShowUIMessage('ControllerRemoved', Localize("MessageBoxErrorStrings", "ReconnectController_Title", "ADVGame"), Localize("MessageBoxErrorStrings", "ReconnectController_Message", "ADVGame"), ButtonArray, DoNotClose,,, 80,, false);
            }            
        }
        else
        {
            UIManager.ClearUIMessage('ControllerRemoved', none, true);
        }
        return;
    }
    // End:0x3B3
    if(bIsPlayingCloseAnimation && ControllerId == LP.ControllerId)
    {
        Class'AdvFrontEnd'.static.GetFrontEnd().CurrentScene.HandleControllerDisconnected(bIsConnected, ControllerId);        
    }
    else
    {
        ToggleControllerDisconnectedMessage(!bIsConnected, ControllerId);
    }
    //return;    
}

function ToggleControllerDisconnectedMessage(bool bShow, int ControllerId)
{
    local array<name> ButtonArray;
    local AdvUIManager UIManager;
    local LocalPlayer LP;
    local string ControllersMessage;

    LP = LocalPlayer(Player);
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x221
    if(ControllerId == LP.ControllerId)
    {
        // End:0x1F7
        if(bShow)
        {
            ButtonArray.Length = 0;
            ControllersMessage = Localize("MessageBoxErrorStrings", "ReconnectController_Message", "ADVGame");
            ControllersMessage = ((Localize("ControllerFont_XBOX", "Controller_Player" $ string(ControllerId + 1), "ADVGame")) $ "<br><br>") $ ControllersMessage;
            UIManager.ShowUIMessage('ControllerRemoved', Localize("MessageBoxErrorStrings", "ReconnectController_Title", "ADVGame"), ControllersMessage, ButtonArray, DoNotClose, LP,, 80,, false);            
        }
        else
        {
            UIManager.ClearUIMessage('ControllerRemoved', none, true);
        }
    }
    //return;    
}

function OnExternalUIChanged(bool bIsOpening)
{
    local AdvPlayerController PC;

    bIsExternalUIOpen = bIsOpening;
    // End:0x199
    if((IsPrimaryPlayer() || (Class'AdvFrontEnd'.static.GetFrontEnd() != none) && Class'AdvFrontEnd'.static.GetFrontEnd().bOnTitleScreen) && !AdvEngine(Class'Engine.Engine'.static.GetEngine()).IsPlayingLoadingMovie())
    {
        super(PlayerController).OnExternalUIChanged(bIsOpening);
        // End:0x199
        if((int(Role) == int(ROLE_Authority)) && WorldInfo.Pauser != none)
        {
            // End:0x198
            foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
            {
                // End:0x197
                if(!PC.IsLocalPlayerController())
                {
                    PC.ClientUpdateHostPause(bIsOpening);
                }                
            }            
        }
    }
    //return;    
}

reliable client simulated function ShowScriptTrace()
{
    //return;    
}

reliable client simulated event ClientShowLevelLoadingMovie(string MapName, string MovieName, optional bool bWaitForInput = false)
{
    local ADVGameViewportClient Viewport;
    local array<string> hintArray;

    ShowScriptTrace();
    Class'Engine.Engine'.static.PlayLoadMapMovie(MapName, MovieName, bWaitForInput || bStartLevelAfterKeyPress);
    // End:0xE8
    if(IsPrimaryPlayer() && LocalPlayer(Player) != none)
    {
        Viewport = ADVGameViewportClient(LocalPlayer(Player).ViewportClient);
        // End:0xE8
        if(Viewport != none)
        {
            Viewport.LoadMapTransition();
        }
    }
    InsertToArray(SPHintsInfo, hintArray);
    InsertToArray(SPHintsTips, hintArray);
    ParseHintsArray(hintArray);
    UpdateSPLoadingScreen(hintArray, HintsSection, HintsPackage, true);
    //return;    
}

reliable client simulated event ClientShowDefaultLoadingMovie()
{
    ShowScriptTrace();
    // End:0x4E
    if(WorldInfo.GRI.IsMultiplayerGame())
    {
        ClientShowReturnToMenuMovie();        
    }
    else
    {
        // End:0x8D
        if(Class'Engine.Engine'.static.PlayLoadMapMovie("", "", false))
        {
            UpdateStatus("ReturnToMenu");
        }
    }
    //return;    
}

reliable client simulated function ClientShowReturnToMenuMovie()
{
    // End:0x54
    if(Class'Engine.Engine'.static.PlayLoadMapMovie("", InfoLoadingMovie, false))
    {
        UpdateStatus("ReturnToMenu");
        UpdateDisplayedHints();
    }
    //return;    
}

reliable client simulated function ClientShowMPLevelLoadingMovie(string MapName, string URL)
{
    local string MapImage, InOpt;
    local AdvGRI GRI;
    local string PlayerNo;
    local Vector MapLocation;
    local string FriendlyMapName;
    local AdvTypes.EMultiGameMode Mode;
    local bool bOracle, bKillingSpree, bTraps;

    ShowScriptTrace();
    MapImage = GetImageForMap(MapName, FriendlyMapName, MapLocation);
    GRI = AdvGRI(WorldInfo.GRI);
    MapName = GRI.NextMap;
    // End:0xE3
    if((MapImage == "") && MapName != "")
    {
        MapImage = GetImageForMap(MapName, FriendlyMapName, MapLocation);
    }
    // End:0x5D5
    if((MapImage != "") && Class'Engine.Engine'.static.PlayLoadMapMovie("", MultiLoadingMovie, false))
    {
        Mode = 7;
        // End:0x1D1
        if(GRI.PlaylistId != -1)
        {            
            URL $= OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager')).GetUrlFromPlaylist(GRI.PlaylistId);
        }
        // End:0x50E
        if(URL != "")
        {
            URL = Caps(URL);
            InOpt = ParseOption(URL, "GAME");
            // End:0x3B3
            if(InOpt != "")
            {
                switch(InOpt)
                {
                    // End:0x270
                    case "ADVGAMECONTENT.ADVGAMEDEATHMATCH":
                        Mode = 0;
                        // End:0x3B3
                        break;
                    // End:0x2A8
                    case "ADVGAMECONTENT.ADVGAMETEAMDEATHMATCH":
                        Mode = 1;
                        // End:0x3B3
                        break;
                    // End:0x2D5
                    case "ADVGAMECONTENT.ADVGAMECTF":
                        Mode = 2;
                        // End:0x3B3
                        break;
                    // End:0x30F
                    case "ADVGAMECONTENT.ADVGAMETEAMTREASUREHUNT":
                        Mode = 6;
                        // End:0x3B3
                        break;
                    // End:0x345
                    case "ADVGAMECONTENT.ADVGAMETREASUREHUNT":
                        Mode = 4;
                        // End:0x3B3
                        break;
                    // End:0x37E
                    case "ADVGAMECONTENT.ADVGAMELASTMENSTANDING":
                        Mode = 5;
                        // End:0x3B3
                        break;
                    // End:0x3B0
                    case "ADVGAMECONTENT.ADVGAMESURVIVAL":
                        Mode = 3;
                        // End:0x3B3
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
            }
            else
            {
                InOpt = ParseOption(URL, "TRAPS");
                bTraps = (InOpt != "") && bool(InOpt);
                // End:0x4DD
                if(int(Mode) != int(3))
                {
                    InOpt = ParseOption(URL, "KILLINGSPREE");
                    bKillingSpree = (InOpt != "") && bool(InOpt);
                    // End:0x4DD
                    if((int(Mode) == int(4)) || int(Mode) == int(6))
                    {
                        InOpt = ParseOption(URL, "ORACLE");
                        bOracle = (InOpt != "") && bool(InOpt);
                    }
                }
                UpdateDisplayedHints(Mode, bOracle, bKillingSpree, bTraps);
            }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x3B3! */            
            PlayerNo $= string(WorldInfo.GRI.PRIArray.Length);
            UpdateMultiLoadingScreen(MapImage, FriendlyMapName, Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(Mode).GameName, PlayerNo, MapLocation);
            UpdateStatusOnLoadingScreen("", "", "");
        }
        //return;        
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x0E3! */
}

simulated function UpdateStatus(string Message)
{
    UpdateStatusOnLoadingScreen(Class'AdvGFxHud'.static.ParseString(Localize("LoadingScreenMessages", Message, "AdvGame"), self), "", "", true);
    //return;    
}

simulated function UpdateDisplayedHints(optional AdvTypes.EMultiGameMode Mode = 7, optional bool bOracle = false, optional bool bKillingSpree = false, optional bool bTraps = false)
{
    local array<string> hintArray;

    // End:0x11C
    if(int(Mode) == int(7))
    {
        // End:0x11C
        if(((AdvGRI(WorldInfo.GRI) != none) && AdvGRI(WorldInfo.GRI).IsSurvivalGame()) || (AdvGameMenu(WorldInfo.Game) != none) && int(AdvGameMenu(WorldInfo.Game).MultiGameModeSelected) == int(3))
        {
            Mode = 3;
        }
    }
    switch(Mode)
    {
        // End:0x153
        case 2:
            InsertToArray(CTAHints, hintArray);
            // End:0x1E6
            break;
        // End:0x177
        case 6:
            InsertToArray(TTHHints, hintArray);
            // End:0x1E6
            break;
        // End:0x19B
        case 4:
            InsertToArray(THHints, hintArray);
            // End:0x1E6
            break;
        // End:0x1BF
        case 5:
            InsertToArray(LMSHints, hintArray);
            // End:0x1E6
            break;
        // End:0x1E3
        case 3:
            InsertToArray(SVHints, hintArray);
            // End:0x1E6
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x242
    if(bTraps)
    {
        // End:0x226
        if(int(Mode) == int(3))
        {
            InsertToArray(TrapsSVHints, hintArray);            
        }
        else
        {
            InsertToArray(TrapsHints, hintArray);
        }
    }
    // End:0x30A
    if(int(Mode) != int(3))
    {
        InsertToArray(GeneralHints, hintArray);
        InsertToArray(AWUHints, hintArray);
        // End:0x2B7
        if(bKillingSpree)
        {
            InsertToArray(KillstreakHints, hintArray);
        }
        // End:0x30A
        if((int(Mode) == int(4)) || int(Mode) == int(6))
        {
            // End:0x30A
            if(bOracle)
            {
                InsertToArray(OracleHints, hintArray);
            }
        }
    }
    ParseHintsArray(hintArray);
    UpdateHintsOnLoadingScreen(hintArray, HintsSection, HintsPackage, true);
    //return;    
}

simulated function string ParseOption(string URL, string Key)
{
    local int OptionStart;
    local string NewGameType;

    NewGameType = "";
    OptionStart = InStr(URL, Key $ "=");
    // End:0xCC
    if(OptionStart != -1)
    {
        NewGameType = Right(URL, ((Len(URL) - OptionStart) - 1) - Len(Key));
        OptionStart = InStr(NewGameType, "?");
        // End:0xCC
        if(OptionStart != -1)
        {
            NewGameType = Left(NewGameType, OptionStart);
        }
    }
    return NewGameType;
    //return ReturnValue;    
}

simulated function InsertToArray(SHintsType NewHints, out array<string> HintsArray)
{
    local int NewIndex, I;

    I = 0;
    J0x0B:

    // End:0x9B [Loop If]
    if(I < NewHints.HintsCount)
    {
        NewIndex = Rand(HintsArray.Length);
        HintsArray.InsertItem(NewIndex, NewHints.HintsPrefix $ string(1 + I));        
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated function ParseHintsArray(out array<string> HintsArray)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x94 [Loop If]
    if(I < HintsArray.Length)
    {
        HintsArray[I] = Class'AdvGFxHud'.static.ParseString(Localize(HintsSection, HintsArray[I], HintsPackage), self);
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated function string GetImageForMap(string MapName, out string FriendlyMapName, out Vector MapLocation)
{
    local string MapImage;
    local UTUIDataProvider_MapInfo MapInfo;
    local array<UDKUIResourceDataProvider> ProviderList;
    local int I;

    MapImage = "";
    // End:0x181
    if(MapName != "")
    {
        Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
        MapName = Caps(MapName);
        I = 0;
        J0x6D:

        // End:0x181 [Loop If]
        if(I < ProviderList.Length)
        {
            MapInfo = UTUIDataProvider_MapInfo(ProviderList[I]);
            // End:0x173
            if(Caps(MapInfo.MapName) == MapName)
            {
                MapImage = MapInfo.PreviewImageMarkup;
                FriendlyMapName = Class'AdvGFxUI_Menu_PregameLobbyPrivateHost'.static.ConvertFriendlyNameToReadable(MapInfo.FriendlyName);
                MapLocation = MapInfo.MapLocation;
                // [Explicit Break]
                goto J0x181;
            }
            I++;
            // [Loop Continue]
            goto J0x6D;
        }
    }
    J0x181:

    return MapImage;
    //return ReturnValue;    
}

reliable client simulated function ClientShowHostMigrationMovie()
{
    local array<name> ButtonAliases;

    ShowScriptTrace();
    // End:0x46
    if(Class'Engine.Engine'.static.PlayLoadMapMovie("", InfoLoadingMovie, false))
    {
        UpdateDisplayedHints();
    }
    ButtonAliases.AddItem('GenericAccept');    
    Class'AdvUIManager'.static.ShowUIMessage('NotifyHostMigrationMsg', Localize("MessageBoxStrings", "HostMigration_Title", "ADVGame"), Localize("MessageBoxStrings", "HostMigration_Message", "ADVGame"), ButtonAliases,,,,,,, false);
    UpdateStatus("HostMigration_Message");
    //return;    
}

reliable client simulated function ClientShowJoinPartyMovie()
{
    ShowScriptTrace();
    // End:0x46
    if(Class'Engine.Engine'.static.PlayLoadMapMovie("", InfoLoadingMovie, false))
    {
        UpdateDisplayedHints();
    }
    UpdateStatus("JoiningToPartyMessage");
    //return;    
}

reliable client simulated function ClientShowJoinGameMovie(AdvPartyGRI.EMatchmakingState eMMState)
{
    local string Message;

    ShowScriptTrace();
    // End:0x20
    if(int(eMMState) == int(0))
    {
        return;
    }
    // End:0x5C
    if(Class'Engine.Engine'.static.PlayLoadMapMovie("", InfoLoadingMovie, false))
    {
        UpdateDisplayedHints();
    }
    switch(eMMState)
    {
        // End:0x99
        case 2:
            Message = "PreparingSearchMessage";
            // End:0x1CC
            break;
        // End:0xC7
        case 3:
            Message = "SearchBestDedicatedMessage";
            // End:0x1CC
            break;
        // End:0xF4
        case 4:
            Message = "SearchAnyDedicatedMessage";
            // End:0x1CC
            break;
        // End:0x123
        case 5:
            Message = "SearchEmptyDedicatedMessage";
            // End:0x1CC
            break;
        // End:0x14D
        case 6:
            Message = "SearchBestPartyMessage";
            // End:0x1CC
            break;
        // End:0x176
        case 7:
            Message = "SearchAnyPartyMessage";
            // End:0x1CC
            break;
        // End:0x1A2
        case 9:
            Message = "ConnectingToLobbyMessage";
            // End:0x1CC
            break;
        // End:0xFFFF
        default:
            Message = "ConnectingToMatchMessage";
            // End:0x1CC
            break;
            break;
    }
    UpdateStatus(Message);
    //return;    
}

reliable client simulated function ClientShowReturnToLobbyMovie()
{
    ShowScriptTrace();
    // End:0x62
    if(Class'Engine.Engine'.static.PlayLoadMapMovie("", InfoLoadingMovie, false))
    {
        UpdateStatus("ReturningToLobby");
        UpdateDisplayedHints();
    }
    //return;    
}

reliable client simulated function ClientShowReturnToPartyMovie()
{
    ShowScriptTrace();
    // End:0x66
    if(Class'Engine.Engine'.static.PlayLoadMapMovie("", InfoLoadingMovie, false))
    {
        UpdateStatus("ReturnToParty_Member");
        UpdateDisplayedHints();
    }
    //return;    
}

reliable client simulated function ClientShowPartyDisbandedMovie()
{
    ShowScriptTrace();
    ClientSetProgressMessage(2, "<Strings:ADVGame.MessageBoxStrings.KickedForPartyKill_Desc>", "<Strings:ADVGame.MessageBoxStrings.KickedForPartyKill_Title>", true);
    // End:0xCE
    if(Class'Engine.Engine'.static.PlayLoadMapMovie("", InfoLoadingMovie, false))
    {
        UpdateDisplayedHints();
    }
    UpdateStatus("KickedForPartyKill_Desc");
    //return;    
}

reliable client simulated function ClientShowKickedMovie()
{
    ShowScriptTrace();
    ClientSetProgressMessage(2, "<Strings:ADVGame.MessageBoxStrings.PlayerWasKicked_Desc>", "<Strings:ADVGame.MessageBoxStrings.KickedForPartyKill_Title>", true);
    // End:0xCB
    if(Class'Engine.Engine'.static.PlayLoadMapMovie("", InfoLoadingMovie, false))
    {
        UpdateDisplayedHints();
    }
    UpdateStatus("PlayerWasKicked_Desc");
    //return;    
}

reliable client simulated function ClientShowKickedByVotingMovie()
{
    ShowScriptTrace();
    ClientSetProgressMessage(2, "<Strings:ADVGame.MessageBoxStrings.PlayerWasKickedByVoting_Desc>", "<Strings:ADVGame.MessageBoxStrings.KickedForPartyKill_Title>", true);
    // End:0xD3
    if(Class'Engine.Engine'.static.PlayLoadMapMovie("", InfoLoadingMovie, false))
    {
        UpdateDisplayedHints();
    }
    UpdateStatus("PlayerWasKickedByVoting_Desc");
    //return;    
}

reliable client simulated event ClientStopLevelLoadingMovie()
{
    // End:0x28
    if(!bSeamlessTravel)
    {
        super.ClientStopLevelLoadingMovie();
        bCloseLoadingScreen = false;        
    }
    else
    {
        bCloseLoadingScreen = true;
    }
    //return;    
}

reliable client simulated function ClientPostTravel()
{
    bSeamlessTravel = false;
    // End:0x23
    if(bCloseLoadingScreen)
    {
        ClientStopLevelLoadingMovie();
    }
    //return;    
}

static simulated function bool IsMenuMap(string MapName)
{
    return (MapName ~= "UI-StartMap") || MapName ~= "";
    //return ReturnValue;    
}

// Export UAdvPlayerController::execUpdateSPLoadingScreen(FFrame&, void* const)
native simulated function UpdateSPLoadingScreen(array<string> NewHintsArray, string Section, string Package, optional bool bDontLocalize = false);

// Export UAdvPlayerController::execUpdateMultiLoadingScreen(FFrame&, void* const)
native simulated function UpdateMultiLoadingScreen(string MapImage, string MapName, string Mode, string PlayerNo, Vector MapLocation);

// Export UAdvPlayerController::execUpdateStatusOnLoadingScreen(FFrame&, void* const)
native simulated function UpdateStatusOnLoadingScreen(string Message, string Section, string Package, optional bool bDontLocalize = false);

// Export UAdvPlayerController::execUpdateHintsOnLoadingScreen(FFrame&, void* const)
native simulated function UpdateHintsOnLoadingScreen(array<string> NewHintsArray, string Section, string Package, optional bool bDontLocalize = false);

reliable server function ServerSetPartyOwner(UniqueNetId PartyOwnerUniqueId, bool bRegisterPlayerWithParty)
{
    local AdvPRI GPRI;

    GPRI = AdvPRI(PlayerReplicationInfo);
    // End:0x7F
    if(GPRI != none)
    {
        GPRI.PartyOwnerUniqueId = PartyOwnerUniqueId;
        // End:0x7F
        if(bRegisterPlayerWithParty)
        {
            GPRI.RegisterPlayerWithParty();
        }
    }
    //return;    
}

reliable client simulated function ClientRegisterWithParty(bool bRegisterPlayerWithParty)
{
    local UniqueNetId PartyOwnerUniqueId;
    local OnlineGameSettings PartySettings;

    // End:0xE2
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
        // End:0xC5
        if(PartySettings != none)
        {
            PartyOwnerUniqueId = PartySettings.OwningPlayerId;
        }
        ServerSetPartyOwner(PartyOwnerUniqueId, bRegisterPlayerWithParty);
    }
    //return;    
}

reliable server function ServerMaskAsGuest(bool bIsGuest)
{
    local AdvPRI PRI;

    PRI = AdvPRI(PlayerReplicationInfo);
    // End:0x55
    if(PRI != none)
    {
        PRI.bIsGuest = bIsGuest;
    }
    //return;    
}

simulated function UpdateGuestStatus()
{
    local LocalPlayer LP;

    LP = LocalPlayer(Player);
    // End:0x149
    if((((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && PlayerReplicationInfo != none)
    {
        // End:0x114
        if(OnlineSub.PlayerInterface.IsGuestLogin(byte(LP.ControllerId)))
        {
            AdvPRI(PlayerReplicationInfo).bIsGuest = true;
            ServerMaskAsGuest(true);            
        }
        else
        {
            AdvPRI(PlayerReplicationInfo).bIsGuest = false;
            ServerMaskAsGuest(false);
        }
    }
    //return;    
}

reliable client simulated function ClientSetPartyInviteFlags(bool bAllowInvites, bool bAllowJoinViaPresence, bool bAllowJoinViaPresenceFriendsOnly, int NumPublicConnections, optional bool bAllowJoinInProgress = true)
{
    local OnlineGameSettings PartySettings;
    local int PartyType;

    ScriptTrace();
    // End:0x378
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && IsPrimaryPlayer())
    {
        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
        // End:0x378
        if(PartySettings != none)
        {
            // End:0xF2
            if(NumPublicConnections < 0)
            {
                NumPublicConnections = PartySettings.NumPublicConnections;
            }
            // End:0x174
            if(PartySettings.GetStringSettingValue(88, PartyType))
            {
                // End:0x155
                if(PartyType == 0)
                {
                    bAllowJoinViaPresence = false;
                    bAllowJoinViaPresenceFriendsOnly = false;
                    bAllowJoinInProgress = false;                    
                }
                else
                {
                    // End:0x171
                    if(PartyType == 2)
                    {
                        bAllowJoinViaPresenceFriendsOnly = false;
                    }
                }                
            }
            // End:0x378
            if(((((PartySettings.bAllowInvites != bAllowInvites) || PartySettings.bAllowJoinViaPresence != bAllowJoinViaPresence) || PartySettings.bAllowJoinViaPresenceFriendsOnly != bAllowJoinViaPresenceFriendsOnly) || PartySettings.NumPublicConnections != NumPublicConnections) || PartySettings.bAllowJoinInProgress != bAllowJoinInProgress)
            {
                PartySettings.bAllowInvites = bAllowInvites;
                PartySettings.bAllowJoinViaPresence = bAllowJoinViaPresence;
                PartySettings.bAllowJoinViaPresenceFriendsOnly = bAllowJoinViaPresenceFriendsOnly;
                PartySettings.NumPublicConnections = NumPublicConnections;
                PartySettings.bAllowJoinInProgress = bAllowJoinInProgress;
                OnlineSub.GameInterface.UpdateOnlineGame('Party', PartySettings, true);
            }
        }
    }
    //return;    
}

reliable client simulated function ClientLogoutPartyHost(UniqueNetId PartyHostNetId)
{
    local AdvLocalPlayer GLP;
    local int I, PartyType;
    local OnlineGameSettings OldParty;
    local URL PendingURL;
    local bool bLoadingFromInvite;

    // End:0x532
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && !bIsReturningFromMatch)
    {
        OldParty = OnlineSub.GameInterface.GetGameSettings('Party');
        // End:0x532
        if(((((OldParty != none) && PlayerReplicationInfo != none) && PlayerReplicationInfo.UniqueId != PartyHostNetId) && IsPrimaryPlayer()) && !bIsReturningToMainMenu)
        {
            NewPartySettings = new Class'AdvPartyGameSettings';
            NewPartySettings.NumPublicConnections = OldParty.NumPublicConnections;
            NewPartySettings.NumPrivateConnections = OldParty.NumPrivateConnections;
            NewPartySettings.bAllowInvites = OldParty.bAllowInvites;
            NewPartySettings.bAllowJoinInProgress = OldParty.bAllowJoinInProgress;
            NewPartySettings.bAllowJoinViaPresence = OldParty.bAllowJoinViaPresence;
            NewPartySettings.bAllowJoinViaPresenceFriendsOnly = OldParty.bAllowJoinViaPresenceFriendsOnly;
            GLP = AdvLocalPlayer(Player);
            // End:0x3D6
            if((GLP != none) && ProfileSettings != none)
            {
                PartyType = int(AdvGRI(WorldInfo.GRI).GetCurrentPartyType());
                // End:0x37B
                if(PartyType == 0)
                {
                    NewPartySettings.bAllowJoinViaPresence = false;
                    NewPartySettings.bAllowJoinViaPresenceFriendsOnly = false;                    
                }
                else
                {
                    // End:0x3AB
                    if(PartyType == 1)
                    {
                        NewPartySettings.bAllowJoinViaPresenceFriendsOnly = false;
                    }
                }
                NewPartySettings.SetStringSettingValue(88, PartyType);
            }
            // End:0x532
            if(AdvEngine(Player.Outer) != none)
            {
                PendingURL = AdvEngine(Player.Outer).GetPendinglevelURL();
                I = 0;
                J0x455:

                // End:0x4D7 [Loop If]
                if(I < PendingURL.Op.Length)
                {
                    // End:0x4C9
                    if(PendingURL.Op[I] ~= "bIsFromInvite")
                    {
                        bLoadingFromInvite = true;
                        // [Explicit Break]
                        goto J0x4D7;
                    }
                    ++I;
                    // [Loop Continue]
                    goto J0x455;
                }
                J0x4D7:

                // End:0x532
                if(!bLoadingFromInvite)
                {
                    CheckOkToDeletePartySession(OnDestroyPartyCompleteToRecreate);
                    ServerUpdateRecentPlayersList(PartyHostNetId, PlayerReplicationInfo.UniqueId);
                }
            }
        }
    }
    //return;    
}

reliable server function ServerUpdateRecentPlayersList(UniqueNetId PartyHostNetId, UniqueNetId PartyMemberNetId)
{
    local AdvRecentPlayersList RecentPlayersList;
    local int PartyIdx, MemberIdx;
    local AdvRecentPlayer MemberPlayer;

    RecentPlayersList = AdvRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
    // End:0x295
    if(RecentPlayersList != none)
    {
        PartyIdx = RecentPlayersList.FindLastPKPartyIndex(PartyHostNetId);
        // End:0x295
        if(PartyIdx != -1)
        {
            MemberIdx = 0;
            J0x9A:

            // End:0x1F8 [Loop If]
            if(MemberIdx < RecentPlayersList.LastPKParties[PartyIdx].PartyMembers.Length)
            {
                // End:0x1EA
                if(RecentPlayersList.LastPKParties[PartyIdx].PartyMembers[MemberIdx].NetId == PartyMemberNetId)
                {
                    MemberPlayer = RecentPlayersList.LastPKParties[PartyIdx].PartyMembers[MemberIdx];
                    RecentPlayersList.LastPKParties[PartyIdx].PartyMembers.Remove(MemberIdx, 1);                    
                    // [Explicit Break]
                    goto J0x1F8;
                }
                ++MemberIdx;
                // [Loop Continue]
                goto J0x9A;
            }
            J0x1F8:

            // End:0x264
            if(RecentPlayersList.LastPKParties[PartyIdx].PartyMembers.Length == 0)
            {
                RecentPlayersList.LastPKParties.Remove(PartyIdx, 1);                
            }
            RecentPlayersList.AddLastPKPartyPlayer(PartyMemberNetId, MemberPlayer);
        }
    }
    //return;    
}

function OnDestroyPartyCompleteToRecreate(name SessionName, bool bWasSuccessful)
{
    local LocalPlayer LP;

    // End:0x175
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyCompleteToRecreate);
        LP = LocalPlayer(Player);
        // End:0x175
        if((LP != none) && !bIsReturningToMainMenu)
        {
            OnlineSub.GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreateNewPartyComplete);
            OnlineSub.GameInterface.CreateOnlineGame(byte(LP.ControllerId), 'Party', NewPartySettings);
        }
    }
    NewPartySettings = none;
    //return;    
}

function OnCreateNewPartyComplete(name SessionName, bool bWasSuccessful)
{
    local AdvPlayerController PCIter;

    // End:0x144
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        OnlineSub.GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreateNewPartyComplete);
        // End:0x144
        if(bWasSuccessful)
        {
            CreatePersistentPartyHostBeacon();
            // End:0x105
            foreach LocalPlayerControllers(Class'AdvPlayerController', PCIter)
            {
                // End:0x104
                if(PCIter.IsPrimaryPlayer())
                {
                    PCIter.ClientRegisterWithParty(true);
                }                
            }            
            OnlineSub.GameInterface.StartOnlineGame(SessionName);
        }
    }
    //return;    
}

reliable client simulated function ClientLogoutPersistentParty()
{
    local AdvPersistentPartyBeaconHost HostPersistentPartyBeacon;

    // End:0x98
    if(((OnlineSub != none) && IsLocalPlayerController()) && IsPrimaryPlayer())
    {
        HostPersistentPartyBeacon = AdvPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
        // End:0x98
        if(HostPersistentPartyBeacon != none)
        {
            HostPersistentPartyBeacon.bUpdateElapsedSessionTimes = false;
        }
    }
    //return;    
}

reliable client simulated function ClientLoginPersistentParty()
{
    local AdvPersistentPartyBeaconHost HostPersistentPartyBeacon;

    // End:0xB7
    if(((OnlineSub != none) && IsLocalPlayerController()) && IsPrimaryPlayer())
    {
        HostPersistentPartyBeacon = AdvPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
        // End:0xB7
        if(HostPersistentPartyBeacon != none)
        {
            HostPersistentPartyBeacon.ResetElapsedSessionUpdateTimes();
            HostPersistentPartyBeacon.bUpdateElapsedSessionTimes = true;
        }
    }
    //return;    
}

function CreatePersistentPartyHostBeacon()
{
    local LocalPlayer LP;
    local OnlineGameSettings PartySettings;
    local array<PlayerReservation> HostPartyMembers;
    local AdvPersistentPartyBeaconHost HostPersistentPartyBeacon;

    LP = LocalPlayer(Player);
    // End:0x24B
    if(((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        DestroyPersistentParty();
        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
        // End:0x24B
        if((PartySettings != none) && !PartySettings.bIsLanMatch)
        {
            // End:0x248
            if((IsLocalPlayerController()) && IsPrimaryPlayer())
            {
                HostPersistentPartyBeacon = new Class'AdvPersistentPartyBeaconHost';
                HostPersistentPartyBeacon.BeaconName = 'PersistentPartyHost';
                OnlineSub.SetNamedInterface('PersistentPartyHostBeacon', HostPersistentPartyBeacon);
                HostPersistentPartyBeacon.InitHostBeacon(1, PartySettings.NumPublicConnections, PartySettings.NumPublicConnections, 'Party');
                GetHostPartyMembers(HostPartyMembers);
                HostPersistentPartyBeacon.AddPartyReservationEntry(PlayerReplicationInfo.UniqueId, HostPartyMembers, 0, true);
            }            
        }
    }
    //return;    
}

function DestroyPersistentParty()
{
    local AdvPersistentPartyBeaconHost HostPersistentPartyBeacon;

    // End:0xA1
    if(OnlineSub != none)
    {
        HostPersistentPartyBeacon = AdvPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
        // End:0x78
        if(HostPersistentPartyBeacon != none)
        {
            HostPersistentPartyBeacon.DestroyBeacon();
        }
        OnlineSub.SetNamedInterface('PersistentPartyHostBeacon', none);
    }
    //return;    
}

function GetHostPartyMembers(out array<PlayerReservation> HostPartyMembers)
{
    local AdvPlayerController PC;
    local LocalPlayer LP;
    local UniqueNetId PlayerID;
    local PlayerReservation PlayerRes;

    HostPartyMembers.Length = 0;
    // End:0x181
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        // End:0x53
        if(!PC.IsPrimaryPlayer())
        {
            continue;            
        }
        LP = LocalPlayer(PC.Player);
        // End:0x180
        if((LP != none) && OnlineSub.PlayerInterface.GetUniquePlayerId(byte(LP.ControllerId), PlayerID))
        {
            PlayerRes.NetId = PlayerID;
            // End:0x143
            if(PC.ProfileSettings != none)
            {                
            }
            // End:0x16A
            if(PC.PersistentData != none)
            {                
            }
            HostPartyMembers.AddItem(PlayerRes);            
        }        
    }    
    //return;    
}

delegate OnDestroyPartyComplete(name SessionName, bool bWasSuccessful)
{
    //return;    
}

function CheckOkToDeletePartySession(delegate<OnDestroyPartyComplete> DestroyPartyCompleteDelegate)
{
    local OnlineGameSettings PartySettings;
    local bool bWaiting;

    // End:0x199
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        DestroyPersistentParty();
        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
        // End:0x199
        if(PartySettings != none)
        {
            bWaiting = true;
            // End:0x186
            if((int(PartySettings.GameState) != int(2)) && int(PartySettings.GameState) != int(4))
            {
                OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(DestroyPartyCompleteDelegate);
                OnlineSub.GameInterface.DestroyOnlineGame('Party');                
            }
            else
            {
                SetTimer(0.2500000, false, 'CheckOkToDeletePartySession');
            }
        }
    }
    // End:0x1C5
    if(!bWaiting)
    {
        OnDestroyPartyComplete('Party', true);
    }
    //return;    
}

simulated function SetRichPresenceString(int StringId)
{
    local LocalPlayer LP;
    local array<LocalizedStringSetting> StringSettings;
    local array<SettingsProperty> Properties;

    LP = LocalPlayer(Player);
    // End:0xE3
    if(((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        OnlineSub.PlayerInterface.SetOnlineStatus(byte(LP.ControllerId), StringId, StringSettings, Properties);
    }
    //return;    
}

reliable client simulated function ClientSetRichPresenceString(int StringId)
{
    SetRichPresenceString(StringId);
    //return;    
}

reliable client simulated function ClientSetCampaignRichPresence(int characterIndex, int Chapter)
{
    local LocalPlayer LP;
    local array<LocalizedStringSetting> StringSettings;
    local array<SettingsProperty> Properties;
    local int StringToUse;

    LP = LocalPlayer(Player);
    // End:0xEF
    if(((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        StringToUse = 5;
        OnlineSub.PlayerInterface.SetOnlineStatus(byte(LP.ControllerId), StringToUse, StringSettings, Properties);
    }
    //return;    
}

reliable client simulated function ClientSetMPRichPresenceString(byte StringId, AdvTypes.EMultiGameMode MPType, byte MapNameId)
{
    local LocalPlayer LP;
    local array<LocalizedStringSetting> StringSettings;
    local array<SettingsProperty> Properties;

    LP = LocalPlayer(Player);
    // End:0x164
    if(((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        StringSettings.Length = 1;
        StringSettings[0].AdvertisementType = 1;
        StringSettings[0].Id = 0;
        StringSettings[0].ValueIndex = Clamp(int(MPType), 0, 7 - 1);
        OnlineSub.PlayerInterface.SetOnlineStatus(byte(LP.ControllerId), int(StringId), StringSettings, Properties);
    }
    //return;    
}

simulated function ClearDLCDownloadedStatus()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x3F [Loop If]
    if(I < 11)
    {
        DownloadedDLCS[I] = 0;
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

reliable client simulated function CheckDLCs()
{
    local OnlineSubsystemSteamworks SteamSub;

    SteamSub = OnlineSubsystemSteamworks(Class'Engine.GameEngine'.static.GetOnlineSubsystem());
    ClearDLCDownloadedStatus();
    // End:0x4D
    if(SteamSub == none)
    {
        return;
    }
    DownloadedDLCS[0] = 0;
    DownloadedDLCS[1] = 0;
    DownloadedDLCS[2] = 0;
    DownloadedDLCS[3] = 0;
    DownloadedDLCS[4] = 0;
    DownloadedDLCS[5] = 0;
    DownloadedDLCS[6] = 0;
    DownloadedDLCS[7] = 0;
    DownloadedDLCS[8] = 0;
    DownloadedDLCS[9] = 0;
    DownloadedDLCS[10] = SteamSub.IsDLCInstalled(231340);
    //return;    
}

reliable server function ServerUpdateDLCStatusInPRI(AdvTypes.EDLCIdentifiers DLCID, bool bUnlocked)
{
    DownloadedDLCS[int(DLCID)] = ((bUnlocked) ? 1 : 0);
    //return;    
}

simulated function byte IsDLCInstalled(AdvTypes.EDLCIdentifiers DLCID)
{
    // End:0x17
    if(int(DLCID) >= int(11))
    {
        return 0;
    }
    return DownloadedDLCS[int(DLCID)];
    //return ReturnValue;    
}

function ShowDLCRemovalError()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local AdvLocalPlayer LP;

    LP = AdvLocalPlayer(Player);
    // End:0x198
    if((LP != none) && LP.bHasSeenStartScreen)
    {
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x198
        if(UIManager != none)
        {
            UIManager.CloseAllUIMessageBoxes(LP);
            ButtonAliases.AddItem('GenericAccept');            
            UIManager.ShowUIMessage('DLCRemovalError', Localize("MessageBoxErrorStrings", "DLCRemovedAtMenuTitle", "ADVGame"), Localize("MessageBoxErrorStrings", "DLCErrorMessage", "ADVGame"), ButtonAliases, None,,,,, false, false);
        }
    }
    //return;    
}

function OnDLCDownloadComplete(int AppID)
{
    CheckDLCs();
    //return;    
}

function OnLobbyJoinGameSimpleDelegate(UniqueNetId SteamId, UniqueNetId FriendId, bool bAccepted)
{
    local string URL;
    local OnlineLobbyInterfaceSteamworks LobbyInterface;

    // End:0x11
    if(OnlineSub == none)
    {
        return;
    }
    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    // End:0x53
    if(LobbyInterface == none)
    {
        return;
    }
    // End:0xCA
    if(bAccepted)
    {
        ClientShowJoinGameMovie(8);
        URL = "open steam." $ OnlineSub.UniqueNetIdToStringDEC(SteamId);        
        ConsoleCommand(URL);
    }
    //return;    
}

function OnLobbyInviteDelegate(UniqueNetId LobbyId, UniqueNetId FriendId, bool bAccepted)
{
    local OnlineLobbyInterfaceSteamworks LobbyInterface;

    // End:0x11
    if(OnlineSub == none)
    {
        return;
    }
    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    // End:0x53
    if(LobbyInterface == none)
    {
        return;
    }
    // End:0xC7
    if(bAccepted)
    {
        LobbyInterface.AddJoinLobbyCompleteDelegate(OnJoinLobbyComplete);
        // End:0xC7
        if(LobbyInterface.JoinLobby(LobbyId))
        {
            ClientShowJoinGameMovie(8);
        }
    }
    //return;    
}

function OnLobbyJoinGameDelegate(const out array<ActiveLobbyInfo> LobbyList, int LobbyIndex, UniqueNetId ServerID, string ServerIP)
{
    local OnlineLobbyInterfaceSteamworks LobbyInterface;

    // End:0x11
    if(OnlineSub == none)
    {
        return;
    }
    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    // End:0x53
    if(LobbyInterface == none)
    {
        return;
    }
    // End:0x103
    if((LobbyIndex >= 0) && LobbyIndex < LobbyList.Length)
    {
        LobbyInterface.AddJoinLobbyCompleteDelegate(OnJoinLobbyCompleteJIP);
        // End:0x100
        if(LobbyInterface.JoinLobby(LobbyList[LobbyIndex].LobbyUID))
        {
            ClientShowJoinGameMovie(8);
        }        
    }
    //return;    
}

function OnJoinLobbyComplete(bool bWasSuccessful, const out array<ActiveLobbyInfo> LobbyList, int LobbyIndex, UniqueNetId InLobbyUID, string Error)
{
    local string URL, ServerSteamID;
    local ActiveLobbyInfo CurrentLobby;

    CleanupSteamLobby();
    LobbyUID = InLobbyUID;
    OnlineSubsystemSteamworks(OnlineSub).LobbyInterface.ClearJoinLobbyCompleteDelegate(OnJoinLobbyComplete);
    // End:0x10F
    if(bWasSuccessful)
    {
        CurrentLobby = LobbyList[LobbyIndex];
        ServerSteamID = GetActiveLobbyData(CurrentLobby, "STEAMID");
        URL = ("open steam." $ ServerSteamID) $ "?bIsFromInvite";        
        ConsoleCommand(URL);        
    }
    else
    {
        // End:0x130
        if(Error ~= "Full")
        {
            NotifyNotEnoughSpaceInInvite();            
        }
        else
        {
            NotifyInviteFailed();
        }
        bSeamlessTravel = false;
        ClientStopLevelLoadingMovie();
    }
    //return;    
}

function OnJoinLobbyCompleteJIP(bool bWasSuccessful, const out array<ActiveLobbyInfo> LobbyList, int LobbyIndex, UniqueNetId InLobbyUID, string Error)
{
    local string URL, ServerSteamID;
    local ActiveLobbyInfo CurrentLobby;

    CleanupSteamLobby();
    LobbyUID = InLobbyUID;
    OnlineSubsystemSteamworks(OnlineSub).LobbyInterface.ClearJoinLobbyCompleteDelegate(OnJoinLobbyCompleteJIP);
    // End:0xFD
    if(bWasSuccessful)
    {
        CurrentLobby = LobbyList[LobbyIndex];
        ServerSteamID = GetActiveLobbyData(CurrentLobby, "STEAMID");
        URL = "open steam." $ ServerSteamID;        
        ConsoleCommand(URL);        
    }
    else
    {
        // End:0x11E
        if(Error ~= "Full")
        {
            NotifyNotEnoughSpaceInInvite();            
        }
        else
        {
            NotifyInviteFailed();
        }
        bSeamlessTravel = false;
        ClientStopLevelLoadingMovie();
    }
    //return;    
}

reliable client simulated function ClientSetSoundMode(name NewMode)
{
    SetSoundMode(NewMode);
    //return;    
}

function CancelJIPGameReservation()
{
    // End:0x69
    if(PendingJIPClientReservationBeacon != none)
    {
        PendingJIPClientReservationBeacon.__OnReservationRequestComplete__Delegate = None;
        PendingJIPClientReservationBeacon.DestroyBeacon();
        PendingJIPClientReservationBeacon = none;
    }
    PendingJIPGameSearch = none;
    //return;    
}

function CancelPersistentPartyReservation(AdvPlayerController.EInviteAcceptanceError InviteErrorType)
{
    // End:0x39
    if(ClientPersistentPartyBeacon != none)
    {
        ClientPersistentPartyBeacon.DestroyBeacon();
        ClientPersistentPartyBeacon = none;
    }
    CancelJIPGameReservation();
    NotifyInviteFailedMsg(int(InviteErrorType));
    //return;    
}

function OnDestroyClientBeacon_JoinReservedPersistentPartySession()
{
    ClientPersistentPartyBeacon = none;
    JoinReservedPersistentPartySession();
    //return;    
}

function OnJIPGameSessionJoinComplete(name SessionName, bool bWasSuccessful)
{
    OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJIPGameSessionJoinComplete);
    // End:0xC1
    if(bWasSuccessful)
    {
        // End:0xB4
        if(ClientPersistentPartyBeacon != none)
        {
            ClientPersistentPartyBeacon.__OnDestroyComplete__Delegate = OnDestroyClientBeacon_JoinReservedPersistentPartySession;
            ClientPersistentPartyBeacon.DestroyBeacon();            
        }
        else
        {
            JoinReservedPersistentPartySession();
        }        
    }
    else
    {
        CancelPersistentPartyReservation(5);
    }
    //return;    
}

function OnDestroyGameForJIPGameSessionComplete(name SessionName, bool bWasSuccessful)
{
    local OnlinePlaylistManager PlaylistMan;
    local OnlineGameSearchResult JIPSessionToJoin;

    OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyGameForJIPGameSessionComplete);
    // End:0x26F
    if((PendingJIPGameSearch != none) && PendingJIPGameSearch.Results.Length > 0)
    {
        JIPSessionToJoin = PendingJIPGameSearch.Results[0];
        // End:0x187
        if(SessionName == 'Game')
        {
            PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
            // End:0x187
            if(PlaylistMan != none)
            {
                Class'AdvPlayerController'.static.UpdateGameSettingsFromPlaylistId(JIPSessionToJoin.GameSettings, AdvGRI(WorldInfo.GRI).PlaylistId, PlaylistMan);
            }
        }
        OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnJIPGameSessionJoinComplete);
        // End:0x26C
        if(OnlineSub.GameInterface.JoinOnlineGame(byte(LocalPlayer(Player).ControllerId), SessionName, JIPSessionToJoin))
        {
            ClientSetPartyInviteFlags(false, false, false, Class'AdvPartyGameSettings'.default.NumPublicConnections, false);
        }        
    }
    else
    {
        CancelPersistentPartyReservation(1);
    }
    //return;    
}

function OnEndGameForJIPGameSessionComplete(name SessionName, bool bWasSuccessful)
{
    OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndGameForJIPGameSessionComplete);
    OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyGameForJIPGameSessionComplete);
    OnlineSub.GameInterface.DestroyOnlineGame(SessionName);
    //return;    
}

function JoinReservedJIPGameSession()
{
    local OnlineGameSettings GameSettings;

    bIsReturningFromMatch = true;
    bIgnoreNetworkMessages = true;
    GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
    // End:0x1A6
    if(GameSettings != none)
    {
        // End:0x11F
        if(GameSettings.bUsesArbitration)
        {
            ClientWriteOnlinePlayerScores(((WorldInfo.GRI.GameClass != none) ? WorldInfo.GRI.GameClass.default.ArbitratedLeaderboardId : 0));
        }
        OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnEndGameForJIPGameSessionComplete);
        OnlineSub.GameInterface.EndOnlineGame('Game');        
    }
    else
    {
        OnDestroyGameForJIPGameSessionComplete('Game', true);
    }
    //return;    
}

function PartyBeaconClient CreateGameClientReservationBeacon(class<OnlineGameSearch> SearchClass)
{
    local PartyBeaconClient JIPClientBeacon;

    // End:0x58
    if(ClassIsChildOf(SearchClass, Class'AdvGameSearchQuick'))
    {
        JIPClientBeacon = new Class'AdvPartyBeaconClient';
        JIPClientBeacon.BeaconName = 'JIPGameClient';
    }
    return JIPClientBeacon;
    //return ReturnValue;    
}

function OnDestroyPendingJIPClientBeacon_JoinReservedJIPGameSession()
{
    PendingJIPClientReservationBeacon = none;
    JoinReservedJIPGameSession();
    //return;    
}

function OnJIPGameReservationUpdateRequestComplete(PartyBeacon.EPartyReservationResult ReservationResult)
{
    // End:0x98
    if((int(ReservationResult) == int(6)) || int(ReservationResult) == int(4))
    {
        // End:0x8B
        if(PendingJIPClientReservationBeacon != none)
        {
            PendingJIPClientReservationBeacon.__OnDestroyComplete__Delegate = OnDestroyPendingJIPClientBeacon_JoinReservedJIPGameSession;
            PendingJIPClientReservationBeacon.DestroyBeacon();            
        }
        else
        {
            JoinReservedJIPGameSession();
        }        
    }
    else
    {
        // End:0xD1
        if((int(ReservationResult) == int(1)) || int(ReservationResult) == int(2))
        {
            CancelPersistentPartyReservation(4);            
        }
        else
        {
            CancelPersistentPartyReservation(5);
        }
    }
    //return;    
}

function bool RequestJIPGameSessionReservation(PartyBeaconClient JIPClientReservationBeacon)
{
    local AdvPlayerController PC;
    local LocalPlayer LocPlayer;
    local array<PlayerReservation> Party;
    local OnlineGameSearchResult JIPSessionToJoin;
    local PlayerReservation PlayerRes;
    local UniqueNetId PlayerID, ZeroId;
    local bool bResult;

    bResult = false;
    // End:0x3A
    if(PendingJIPClientReservationBeacon != none)
    {
        PendingJIPClientReservationBeacon.DestroyBeacon();
    }
    PendingJIPClientReservationBeacon = JIPClientReservationBeacon;
    // End:0x2E2
    if((((PendingJIPClientReservationBeacon != none) && PendingJIPGameSearch != none) && PendingJIPGameSearch.Results.Length > 0) && InvitePartyHostOwnerId != ZeroId)
    {
        JIPSessionToJoin = PendingJIPGameSearch.Results[0];
        // End:0x268
        foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
        {
            // End:0x125
            if(!PC.IsPrimaryPlayer())
            {
                continue;                
            }
            LocPlayer = LocalPlayer(PC.Player);
            // End:0x267
            if((LocPlayer != none) && OnlineSub.PlayerInterface.GetUniquePlayerId(byte(LocPlayer.ControllerId), PlayerID))
            {
                PlayerRes.NetId = PlayerID;
                // End:0x233
                if(PC.PersistentData != none)
                {
                    PlayerRes.XpLevel = 0;                    
                }
                else
                {
                    PlayerRes.XpLevel = 0;
                }
                Party.AddItem(PlayerRes);                
            }            
        }        
        // End:0x2E2
        if(PendingJIPClientReservationBeacon.RequestReservationUpdate(JIPSessionToJoin, InvitePartyHostOwnerId, Party))
        {
            bResult = true;
            PendingJIPClientReservationBeacon.__OnReservationRequestComplete__Delegate = OnJIPGameReservationUpdateRequestComplete;
        }
    }
    return bResult;
    //return ReturnValue;    
}

function OnPersistentPartyJIPGameSessionReceived(AdvPersistentPartyBeaconHost.EPKPersistentPartyJIPResult JIPResult, name SessionName, class<OnlineGameSearch> SearchClass, int GamePlaylistId, int GamePlaylistMgrVer, int InDLCRequired, string CustomMapName, byte PlatformSpecificInfo[80])
{
    local OnlineGameSettings GameSettings;
    local OnlineGameSearchResult JIPSessionToJoin;
    local PartyBeaconClient JIPClientReservationBeacon;
    local UniqueNetId ZeroId;
    local AdvFrontEnd Frontend;
    local int NumLocalPlayers;
    local AdvPlayerController PC;
    local AdvPlayerController.EInviteAcceptanceError ErrorValue;
    local AdvOnlinePlaylistProvider AdvProvider;

    ClientPersistentPartyBeacon.__OnJIPGameSessionReceived__Delegate = None;
    ClientPersistentPartyBeacon.__OnReservationRequestComplete__Delegate = None;
    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    PendingJIPGameSearch = new SearchClass;
    // End:0x57F
    if(OnlineSub.GameInterface.BindPlatformSpecificSessionToSearch(byte(LocalPlayer(Player).ControllerId), PendingJIPGameSearch, PlatformSpecificInfo))
    {
        JIPSessionToJoin = PendingJIPGameSearch.Results[0];
        GameSettings = OnlineSub.GameInterface.GetGameSettings(SessionName);
        // End:0x236
        if(((GameSettings != none) && GameSettings.OwningPlayerId != ZeroId) && GameSettings.OwningPlayerId == JIPSessionToJoin.GameSettings.OwningPlayerId)
        {
            CancelPersistentPartyReservation(1);            
        }
        else
        {
            // End:0x2B6
            if(GamePlaylistId != -1)
            {
                AdvProvider = AdvOnlinePlaylistProvider(Class'IpDrv.UIDataStore_OnlinePlaylists'.static.GetOnlinePlaylistProviderByPlaylistID(GamePlaylistId));
                ErrorValue = CheckPlaylistAllowedPRI(AdvProvider, AdvPRI(PlayerReplicationInfo));                
            }
            else
            {
                // End:0x2F8
                if(CustomMapName != "")
                {
                    ErrorValue = CheckMapAllowedPRI(CustomMapName, AdvPRI(PlayerReplicationInfo));                    
                }
                else
                {
                    // End:0x331
                    if(!CheckDLCAvailable(InDLCRequired, AdvPRI(PlayerReplicationInfo)))
                    {
                        ErrorValue = 8;                        
                    }
                    else
                    {
                        ErrorValue = 0;
                    }
                }
            }
            // End:0x364
            if(int(ErrorValue) != int(0))
            {
                DLCRequired = InDLCRequired;
            }
            // End:0x3F0
            if((int(JIPResult) == int(3)) && int(ErrorValue) == int(0))
            {
                JIPClientReservationBeacon = CreateGameClientReservationBeacon(SearchClass);
                // End:0x3E1
                if(JIPClientReservationBeacon != none)
                {
                    // End:0x3DE
                    if(!RequestJIPGameSessionReservation(JIPClientReservationBeacon))
                    {
                        CancelPersistentPartyReservation(5);
                    }                    
                }
                else
                {
                    CancelPersistentPartyReservation(5);
                }                
            }
            else
            {
                // End:0x506
                if(((int(JIPResult) == int(1)) || int(JIPResult) == int(2)) && int(ErrorValue) == int(0))
                {
                    NumLocalPlayers = 0;
                    // End:0x466
                    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
                    {
                        NumLocalPlayers++;                        
                    }                    
                    DesiredSessionCustomMapName = CustomMapName;
                    // End:0x503
                    if(IsPrimaryPlayer() && NumLocalPlayers <= 1)
                    {
                        // End:0x4F9
                        if(ClientPersistentPartyBeacon != none)
                        {
                            ClientPersistentPartyBeacon.__OnDestroyComplete__Delegate = OnDestroyClientBeacon_JoinReservedJIPGameSession;
                            ClientPersistentPartyBeacon.DestroyBeacon();                            
                        }
                        else
                        {
                            JoinReservedJIPGameSession();
                        }
                    }                    
                }
                else
                {
                    // End:0x555
                    if(((int(JIPResult) != int(1)) && int(JIPResult) != int(2)) && int(JIPResult) != int(3))
                    {
                        CancelPersistentPartyReservation(5);                        
                    }
                    else
                    {
                        // End:0x57C
                        if(int(ErrorValue) != int(0))
                        {
                            CancelPersistentPartyReservation(ErrorValue);
                        }
                    }
                }
            }
        }        
    }
    else
    {
        CancelPersistentPartyReservation(1);
    }
    //return;    
}

function OnDestroyClientBeacon_JoinReservedJIPGameSession()
{
    ClientPersistentPartyBeacon = none;
    JoinReservedJIPGameSession();
    //return;    
}

function LaunchReplyRequest()
{
    RequestPersistentPartyJoin(InviteFailCache);
    //return;    
}

function OnPersistentPartyReservationRequestComplete(PartyBeacon.EPartyReservationResult ReservationResult)
{
    local int NumLocalPlayers;
    local AdvPlayerController PC;

    // End:0xD7
    if(int(ReservationResult) == int(6))
    {
        NumLocalPlayers = 0;
        // End:0x4A
        foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
        {
            NumLocalPlayers++;            
        }        
        // End:0xD4
        if(IsPrimaryPlayer() && NumLocalPlayers <= 1)
        {
            // End:0xCA
            if(ClientPersistentPartyBeacon != none)
            {
                ClientPersistentPartyBeacon.__OnDestroyComplete__Delegate = OnDestroyClientBeacon_JoinReservedPersistentPartySession;
                ClientPersistentPartyBeacon.DestroyBeacon();                
            }
            else
            {
                JoinReservedPersistentPartySession();
            }
        }        
    }
    else
    {
        // End:0x152
        if(InviteReplyCounter > 0)
        {
            // End:0x118
            if(!Class'Engine.UIInteraction'.static.HasLinkConnection())
            {
                InviteReplyCounter = 0;                
            }
            else
            {
                // End:0x14F
                if(!IsTimerActive('LaunchReplyRequest'))
                {
                    SetTimer(3.0000000, false, 'LaunchReplyRequest');
                    InviteReplyCounter--;
                }
            }            
        }
        else
        {
            // End:0x18B
            if(ClientPersistentPartyBeacon != none)
            {
                ClientPersistentPartyBeacon.DestroyBeacon();
                ClientPersistentPartyBeacon = none;
            }
            // End:0x1C4
            if((int(ReservationResult) == int(1)) || int(ReservationResult) == int(2))
            {
                NotifyInviteFailedMsg(2);                
            }
            else
            {
                // End:0x1DD
                if(InviteReplyCounter <= 0)
                {
                    NotifyInviteFailed();
                }
            }
        }
    }
    //return;    
}

function bool RequestPersistentPartyJoin(const out OnlineGameSearchResult SessionToJoin)
{
    local AdvPlayerController PC;
    local LocalPlayer LocPlayer;
    local array<PlayerReservation> Party;
    local PlayerReservation PlayerRes;
    local UniqueNetId PlayerID;
    local OnlineGameSettings PartySettings;
    local bool bResult;

    InvitePartyHostOwnerId = SessionToJoin.GameSettings.OwningPlayerId;
    bResult = false;
    PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
    // End:0xFE
    if((PartySettings != none) && PartySettings.OwningPlayerId == SessionToJoin.GameSettings.OwningPlayerId)
    {        
    }
    else
    {
        LocPlayer = LocalPlayer(Player);
        // End:0x3F3
        if(LocPlayer != none)
        {
            // End:0x157
            if(ClientPersistentPartyBeacon != none)
            {
                ClientPersistentPartyBeacon.DestroyBeacon();
            }
            ClientPersistentPartyBeacon = new Class'AdvPersistentPartyBeaconClient';
            ClientPersistentPartyBeacon.BeaconName = 'PersistentPartyClient';
            // End:0x321
            foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
            {
                // End:0x1DE
                if(!PC.IsPrimaryPlayer())
                {
                    continue;                    
                }
                LocPlayer = LocalPlayer(PC.Player);
                // End:0x320
                if((LocPlayer != none) && OnlineSub.PlayerInterface.GetUniquePlayerId(byte(LocPlayer.ControllerId), PlayerID))
                {
                    PlayerRes.NetId = PlayerID;
                    // End:0x2EC
                    if(PC.PersistentData != none)
                    {
                        PlayerRes.XpLevel = 0;                        
                    }
                    else
                    {
                        PlayerRes.XpLevel = 0;
                    }
                    Party.AddItem(PlayerRes);                    
                }                
            }            
            // End:0x3F3
            if(ClientPersistentPartyBeacon.RequestReservationUpdate(SessionToJoin, SessionToJoin.GameSettings.OwningPlayerId, Party))
            {
                bResult = true;
                ClientPersistentPartyBeacon.__OnJIPGameSessionReceived__Delegate = OnPersistentPartyJIPGameSessionReceived;
                ClientPersistentPartyBeacon.__OnReservationRequestComplete__Delegate = OnPersistentPartyReservationRequestComplete;
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

simulated function bool OnShowMarketPlaceMessage(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local int OfferId;
    local AdvEngine Eng;

    OfferId = 0;
    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x89
    if(DLCRequired != 0)
    {
        OfferId = Eng.GetXboxOfferIDForDLCID(DLCRequired);
        DLCRequired = 0;
    }
    // End:0xA3
    if(SelectedInputAlias == 'GenericCancel')
    {        
    }
    else
    {
        // End:0xD2
        if(SelectedInputAlias == 'GenericMarketplace')
        {
            ShowMarketPlace2(-1, OfferId);
        }
    }
    return true;
    //return ReturnValue;    
}

exec function DebugShowMissingDLCMessage(int Type)
{
    DLCRequired = 1;
    ShowMissingDLCMessage(Type);
    //return;    
}

simulated function ShowMissingDLCMessage(int Type)
{
    local array<name> ButtonAliases;
    local AdvUIManager UIManager;
    local string LocMessage;
    local AdvLocalPlayer LP;

    ButtonAliases.AddItem('GenericMarketplace');    
    ButtonAliases.AddItem('GenericCancel');    
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    LP = AdvLocalPlayer(Player);
    // End:0x1F6
    if(UIManager != none)
    {
        // End:0xED
        if(Type == 6)
        {
            LocMessage = Localize("MessageBoxErrorStrings", "PlaylistRequiresDLC_Player", "ADVGame");            
        }
        else
        {
            LocMessage = Localize("MessageBoxErrorStrings", "MapRequiresDLC_Player", "ADVGame");
        }
        UIManager.ShowUIMessage(name("CorruptedDLC_" $ string(DLCRequired)), "<Strings:ADVGame.MessageBoxErrorStrings.PlaylistRequiresDLC_Title>", LocMessage, ButtonAliases, OnShowMarketPlaceMessage, LP,,,,,,,, Class'UIScene_MarketplaceMessageBoxWithCancel');
    }
    //return;    
}

function NotifyInviteFailedMsg(int InviteErrorType)
{
    bSeamlessTravel = false;
    ClientStopLevelLoadingMovie();
    switch(InviteErrorType)
    {
        // End:0x9B
        case 3:
            Class'AdvUIManager'.static.DisplayErrorMessage("OnePlayerMPOnly_Message_XBOX", "InviteJoinFailed_Title", "GenericAccept");
            // End:0x4E7
            break;
        // End:0x10A
        case 2:
            Class'AdvUIManager'.static.DisplayErrorMessage("InviteJoinFailed_GameFull", "InviteJoinFailed_Title", "GenericAccept");
            // End:0x4E7
            break;
        // End:0x179
        case 4:
            Class'AdvUIManager'.static.DisplayErrorMessage("InviteJoinFailed_GameFull", "InviteJoinFailed_Title", "GenericAccept");
            // End:0x4E7
            break;
        // End:0x18D
        case 6:
            ShowMissingDLCMessage(6);
            // End:0x4E7
            break;
        // End:0x1A1
        case 8:
            ShowMissingDLCMessage(8);
            // End:0x4E7
            break;
        // End:0x213
        case 7:
            Class'AdvUIManager'.static.DisplayErrorMessage("PlaylistRequiresDLC_Party", "PlaylistRequiresDLC_Title", "GenericAccept");
            // End:0x4E7
            break;
        // End:0x280
        case 9:
            Class'AdvUIManager'.static.DisplayErrorMessage("MapRequiresDLC_Party", "PlaylistRequiresDLC_Title", "GenericAccept");
            // End:0x4E7
            break;
        // End:0x2FD
        case 12:
            Class'AdvUIManager'.static.DisplayErrorMessage("PlaylistRequiresMinLevel_Player", "PlaylistRequiresMinLevel_Title", "GenericAccept");
            // End:0x4E7
            break;
        // End:0x379
        case 13:
            Class'AdvUIManager'.static.DisplayErrorMessage("PlaylistRequiresMinLevel_Party", "PlaylistRequiresMinLevel_Title", "GenericAccept");
            // End:0x4E7
            break;
        // End:0x3F6
        case 14:
            Class'AdvUIManager'.static.DisplayErrorMessage("PlaylistRequiresMaxLevel_Player", "PlaylistRequiresMaxLevel_Title", "GenericAccept");
            // End:0x4E7
            break;
        // End:0x472
        case 15:
            Class'AdvUIManager'.static.DisplayErrorMessage("PlaylistRequiresMaxLevel_Party", "PlaylistRequiresMaxLevel_Title", "GenericAccept");
            // End:0x4E7
            break;
        // End:0x477
        case 5:
        // End:0x47B
        case 1:
        // End:0xFFFF
        default:
            Class'AdvUIManager'.static.DisplayErrorMessage("InviteJoinFailed_Message", "InviteJoinFailed_Title", "GenericAccept");
            // End:0x4E7
            break;
            break;
    }
    // End:0x514
    if((InviteErrorType != 6) && InviteErrorType != 8)
    {
        DLCRequired = 0;
    }
    //return;    
}

function NotifyInviteFailed()
{
    ScriptTrace();
    NotifyInviteFailedMsg(1);
    //return;    
}

function NotifyNotAllPlayersCanJoinInvite()
{
    NotifyInviteFailedMsg(3);
    //return;    
}

function NotifyNotEnoughSpaceInInvite()
{
    bSeamlessTravel = false;
    ClientStopLevelLoadingMovie();
    Class'AdvUIManager'.static.DisplayErrorMessage("InviteJoinFailed_GameFull", "InviteJoinFailed_Title", "GenericAccept");
    //return;    
}

function bool CheckPlaylistAndDisplayError(int PlaylistId)
{
    local AdvPlayerController.EInviteAcceptanceError Error;

    Error = CheckPlaylistAllowed(PlaylistId);
    // End:0x48
    if(int(Error) != int(0))
    {
        NotifyInviteFailedMsg(int(Error));
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool CheckMapAndDisplayError(string MapName)
{
    local AdvPlayerController.EInviteAcceptanceError Error;

    Error = CheckMapAllowed(MapName);
    // End:0x48
    if(int(Error) != int(0))
    {
        NotifyInviteFailedMsg(int(Error));
        return false;
    }
    return true;
    //return ReturnValue;    
}

function AdvPlayerController.EInviteAcceptanceError CheckPlaylistAllowed(int PlaylistId)
{
    local AdvOnlinePlaylistProvider AdvProvider;
    local AdvPRI PRI;
    local AdvPlayerController.EInviteAcceptanceError ReturnVal;
    local int I;

    AdvProvider = AdvOnlinePlaylistProvider(Class'IpDrv.UIDataStore_OnlinePlaylists'.static.GetOnlinePlaylistProviderByPlaylistID(PlaylistId));
    ReturnVal = CheckPlaylistAllowedPRI(AdvProvider, AdvPRI(PlayerReplicationInfo));
    // End:0x206
    if(int(ReturnVal) == int(0))
    {
        I = 0;
        J0x89:

        // End:0x206 [Loop If]
        if(I < WorldInfo.GRI.PRIArray.Length)
        {
            PRI = AdvPRI(WorldInfo.GRI.PRIArray[I]);
            // End:0x1F8
            if(((PRI != none) && !PRI.bIsInactive) && PRI != PlayerReplicationInfo)
            {
                ReturnVal = CheckPlaylistAllowedPRI(AdvProvider, PRI);
                // End:0x1F8
                if(int(ReturnVal) != int(0))
                {
                    switch(ReturnVal)
                    {
                        // End:0x1CA
                        case 14:
                            ReturnVal = 15;
                            // End:0x1F5
                            break;
                        // End:0x1DE
                        case 12:
                            ReturnVal = 13;
                            // End:0x1F5
                            break;
                        // End:0x1F2
                        case 6:
                            ReturnVal = 7;
                            // End:0x1F5
                            break;
                        // End:0xFFFF
                        default:
                            break;
                    }
                    // [Explicit Break]
                    goto J0x206;
                }
            }
            I++;
            // [Loop Continue]
            goto J0x89;
        }
    }
    J0x206:

    return ReturnVal;
    //return ReturnValue;    
}

function AdvPlayerController.EInviteAcceptanceError CheckMapAllowed(string MapName)
{
    local AdvPRI PRI;
    local AdvPlayerController.EInviteAcceptanceError ReturnVal;
    local int I;

    ReturnVal = CheckMapAllowedPRI(MapName, AdvPRI(PlayerReplicationInfo));
    // End:0x1A3
    if(int(ReturnVal) == int(0))
    {
        I = 0;
        J0x4E:

        // End:0x1A3 [Loop If]
        if(I < WorldInfo.GRI.PRIArray.Length)
        {
            PRI = AdvPRI(WorldInfo.GRI.PRIArray[I]);
            // End:0x195
            if(((PRI != none) && !PRI.bIsInactive) && PRI != PlayerReplicationInfo)
            {
                ReturnVal = CheckMapAllowedPRI(MapName, PRI);
                // End:0x195
                if(int(ReturnVal) != int(0))
                {
                    switch(ReturnVal)
                    {
                        // End:0x18F
                        case 8:
                            ReturnVal = 9;
                            // End:0x192
                            break;
                        // End:0xFFFF
                        default:
                            break;
                    }
                    // [Explicit Break]
                    goto J0x1A3;
                }
            }
            I++;
            // [Loop Continue]
            goto J0x4E;
        }
    }
    J0x1A3:

    return ReturnVal;
    //return ReturnValue;    
}

static function bool CheckDLCAvailable(int ContentID, AdvPRI PRI)
{
    // End:0x6F
    if((ContentID != 0) && (PRI.DLCFlag == -1) || (PRI.DLCFlag & (1 << ContentID)) == 0)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function AdvPlayerController.EInviteAcceptanceError CheckPlaylistAllowedPRI(AdvOnlinePlaylistProvider AdvProvider, AdvPRI PRI)
{
    local int ContentID;
    local string PlaylistName;
    local int PlayerXP;

    // End:0xB1
    if(AdvProvider != none)
    {
        PlaylistName = OnlinePlaylistManager(Class'Engine.GameEngine'.static.GetOnlineSubsystem().GetNamedInterface('PlaylistManager')).GetPlaylistName(AdvProvider.PlaylistId);
        ContentID = GetContentDLC(PlaylistName);
    }
    ProfileSettings.GetProfileSettingValueInt(36, PlayerXP);
    PRI.InitXP(PlayerXP);
    // End:0x13B
    if((AdvProvider == none) || !CheckDLCAvailable(ContentID, PRI))
    {
        return 6;        
    }
    else
    {
        // End:0x1AC
        if((AdvProvider.MaxLevel != -1) && PRI.PlayerLevel > AdvProvider.MaxLevel)
        {
            return 14;            
        }
        else
        {
            // End:0x21A
            if((AdvProvider.MinLevel != -1) && PRI.PlayerLevel < AdvProvider.MinLevel)
            {
                return 12;
            }
        }
    }
    return 0;
    //return ReturnValue;    
}

static function AdvPlayerController.EInviteAcceptanceError CheckMapAllowedPRI(string MapName, AdvPRI PRI)
{
    local int ContentID;

    // End:0x53
    if(MapName != "")
    {
        ContentID = GetContentDLC(MapName);
        return ((CheckDLCAvailable(ContentID, PRI)) ? 0 : 8);
    }
    return 8;
    //return ReturnValue;    
}

static function int GetContentDLC(string ContentName)
{
    local int StartIndex, EndIndex;

    StartIndex = InStr(ContentName, "DLC_");
    // End:0xBB
    if(StartIndex != -1)
    {
        ContentName = Right(ContentName, (Len(ContentName) - 4) - StartIndex);
        EndIndex = InStr(ContentName, "_");
        // End:0xAC
        if(EndIndex != -1)
        {
            ContentName = Left(ContentName, EndIndex);
        }
        return int(ContentName);        
    }
    else
    {
        return 0;
    }
    //return ReturnValue;    
}

function OnGameInviteAccepted(const out OnlineGameSearchResult InviteResult)
{
    OnlineSub.DumpGameSettings(InviteResult.GameSettings);
    // End:0x12A
    if((OnlineSub.GameInterface.GetGameSettings('Game') == none) || InviteResult.GameSettings.OwningPlayerName != OnlineSub.GameInterface.GetGameSettings('Game').OwningPlayerName)
    {
        CleanupSteamLobby();
        super(PlayerController).OnGameInviteAccepted(InviteResult);        
    }
    //return;    
}

function bool InviteHasEnoughSpace(OnlineGameSettings InviteSettings)
{
    return true;
    //return ReturnValue;    
}

function NotifyDisbandedPartyClients(UniqueNetId PartyOwnerId)
{
    //return;    
}

function JoinReservedPersistentPartySession()
{
    local OnlineGameSettings GameSettings, PartySettings;

    // End:0x39
    if(PendingJIPClientReservationBeacon != none)
    {
        PendingJIPClientReservationBeacon.DestroyBeacon();
        PendingJIPClientReservationBeacon = none;
    }
    // End:0x99
    if(ClientPersistentPartyBeacon != none)
    {
        ClientPersistentPartyBeacon.__OnDestroyComplete__Delegate = OnDestroyClientBeacon_JoinReservedPersistentPartySession;
        ClientPersistentPartyBeacon.DestroyBeacon();
        return;
    }
    bIsReturningFromMatch = true;
    bIgnoreNetworkMessages = true;
    // End:0x3F1
    if(true)
    {
        NotifyClientsHostLeavingForMigration();
        WorldInfo.ToggleHostMigration(false);
        GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
        // End:0x1F0
        if((GameSettings != none) && PendingJIPGameSearch == none)
        {
            // End:0x169
            if(GameSettings.bUsesArbitration)
            {
            }
            OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnEndGameForInviteComplete);
            OnlineSub.GameInterface.EndOnlineGame('Game');            
        }
        else
        {
            PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
            // End:0x2F6
            if(PartySettings != none)
            {
                NotifyDisbandedPartyClients(PartySettings.OwningPlayerId);
                OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyPartyForInviteComplete);
                OnlineSub.GameInterface.DestroyOnlineGame('Party');                
            }
            else
            {
                OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
                // End:0x3EE
                if(!OnlineSub.GameInterface.AcceptGameInvite(byte(LocalPlayer(Player).ControllerId), 'Party'))
                {
                    OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
                }
            }
        }        
    }
    else
    {
        OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
        // End:0x4E9
        if(!OnlineSub.GameInterface.AcceptGameInvite(byte(LocalPlayer(Player).ControllerId), 'Party'))
        {
            OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
        }
    }
    PendingJIPGameSearch = none;
    //return;    
}

function OnEndGameForInviteComplete(name SessionName, bool bWasSuccessful)
{
    OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndGameForInviteComplete);
    OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyGameForInviteComplete);
    OnlineSub.GameInterface.DestroyOnlineGame('Game');
    //return;    
}

function OnDestroyGameForInviteComplete(name SessionName, bool bWasSuccessful)
{
    local OnlineGameSettings PartySettings;

    OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyGameForInviteComplete);
    PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
    // End:0x14C
    if(PartySettings != none)
    {
        NotifyDisbandedPartyClients(PartySettings.OwningPlayerId);
        OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyPartyForInviteComplete);
        OnlineSub.GameInterface.DestroyOnlineGame('Party');        
    }
    else
    {
        OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
        // End:0x244
        if(!OnlineSub.GameInterface.AcceptGameInvite(byte(LocalPlayer(Player).ControllerId), 'Party'))
        {
            OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
        }
    }
    //return;    
}

function OnDestroyPartyForInviteComplete(name SessionName, bool bWasSuccessful)
{
    OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyForInviteComplete);
    OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
    // End:0x13E
    if(!OnlineSub.GameInterface.AcceptGameInvite(byte(LocalPlayer(Player).ControllerId), 'Party'))
    {
        OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
    }
    //return;    
}

function OnInviteJoinComplete(name SessionName, bool bWasSuccessful)
{
    local string URL;

    // End:0x246
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
        // End:0x1E0
        if(bWasSuccessful)
        {
            // End:0x1C9
            if(OnlineSub.GameInterface.GetResolvedConnectString('Game', URL))
            {
                OnlineSub.GameInterface.AddStartOnlineGameCompleteDelegate(OnStartPartyForJoinComplete);
                // End:0x1C6
                if(!OnlineSub.GameInterface.StartOnlineGame('Party'))
                {
                    OnlineSub.GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartPartyForJoinComplete);
                    OnStartPartyForJoinComplete('Party', false);
                }                
            }
            else
            {
                OnStartPartyForJoinComplete('Party', true);
            }            
        }
        else
        {
            Class'AdvUIManager'.static.DisplayErrorMessage("InviteJoinFailed_Message", "InviteJoinFailed_Title", "GenericAccept");
        }
    }
    //return;    
}

function OnStartPartyForJoinComplete(name SessionName, bool bWasSuccessful)
{
    local string URL;
    local bool bValidURL;
    local AdvPersistentPartyBeaconHost HostPersistentPartyBeacon;
    local bool bJoiningGame;

    OnlineSub.GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartPartyForJoinComplete);
    bValidURL = false;
    // End:0x26D
    if(bWasSuccessful)
    {
        // End:0xC4
        if(OnlineSub.GameInterface.GetResolvedConnectString('Game', URL))
        {
            bValidURL = true;
            bJoiningGame = true;            
        }
        else
        {
            // End:0x126
            if(OnlineSub.GameInterface.GetResolvedConnectString('Party', URL))
            {
                bValidURL = true;
                bJoiningGame = false;
            }
        }
        // End:0x26D
        if(bValidURL)
        {
            HostPersistentPartyBeacon = AdvPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
            // End:0x19C
            if(HostPersistentPartyBeacon != none)
            {
                HostPersistentPartyBeacon.DestroyBeacon();
            }
            OnlineSub.SetNamedInterface('PersistentPartyHostBeacon', none);            
            URL $= "?bIsFromInvite";
            bIsReturningFromMatch = false;
            // End:0x24C
            if(bJoiningGame)
            {
                // End:0x23D
                if(Class'AdvPlayerController'.static.IsMenuMap(DesiredSessionCustomMapName))
                {
                    ClientShowJoinGameMovie(9);                    
                }
                else
                {
                    ClientShowJoinGameMovie(8);
                }                
            }
            else
            {
                ClientShowJoinPartyMovie();
            }
            ClientTravel(URL, 0);
        }
    }
    // End:0x2E2
    if(!bValidURL)
    {
        Class'AdvUIManager'.static.DisplayErrorMessage("InviteJoinFailed_Message", "InviteJoinFailed_Title", "GenericAccept");
    }
    //return;    
}

reliable server function PartyIsLeavingGame(UniqueNetId RequestingPlayerId)
{
    local AdvPlayerController GPC, RequestingPC;
    local WorldInfo WI;

    WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
    // End:0xC0
    foreach WI.AllControllers(Class'AdvPlayerController', GPC)
    {
        // End:0xAC
        if(!GPC.IsLocalPlayerController())
        {
            GPC.ClientReturnToParty(RequestingPlayerId);
            // End:0xBF
            continue;
        }
        RequestingPC = GPC;        
    }    
    RequestingPC.ClientReturnToParty(RequestingPlayerId);
    //return;    
}

reliable client simulated function ClientSetReturnMPFlags()
{
    AdvLocalPlayer(Player).bIsReturningFromMP = true;
    // End:0x82
    if(class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) != none)
    {
        AdvLocalPlayer(Player).bIsReturningFromSurvival = true;
    }
    //return;    
}

reliable client simulated function ClientReturnToParty(UniqueNetId RequestingPlayerId)
{
    local OnlineGameSettings GameSettings, PartySettings;
    local bool bDestroySession, bWriteStats;
    local AdvGRI GRI;
    local UniqueNetId ZeroId;

    PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
    CleanupSteamLobby();
    GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
    OnlineSub.DumpGameSettings(PartySettings);
    OnlineSub.DumpGameSettings(GameSettings);
    // End:0x588
    if(((PartySettings != none) && PartySettings.OwningPlayerId == RequestingPlayerId || PartySettings.OwningPlayerId == ZeroId) || PlayerReplicationInfo.UniqueId == RequestingPlayerId)
    {
        AdvLocalPlayer(Player).bIsReturningFromMP = true;
        // End:0x292
        if(((AdvPreGameGRI(WorldInfo.GRI) != none) && int(AdvPreGameGRI(WorldInfo.GRI).WinningGameMode) == int(3)) || class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) != none)
        {
            AdvLocalPlayer(Player).bIsReturningFromSurvival = true;
        }
        // End:0x2CF
        if(RequestingPlayerId == PlayerReplicationInfo.UniqueId)
        {
            NotifyClientsHostLeavingForMigration();
        }
        WorldInfo.ToggleHostMigration(false);
        CloseUnwantedMessageBoxes();
        WorldInfo.CancelPendingMapChange();
        bIsReturningFromMatch = true;
        bIgnoreNetworkMessages = true;
        // End:0x53B
        if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            // End:0x53B
            if(IsPrimaryPlayer())
            {
                GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
                ReturnToPartyRequestingId = RequestingPlayerId;
                bWasLocalSystemOrPrivate = (GameSettings == none) || !GameSettings.bUsesArbitration;
                OpenReturnToMainMenuCogSpin();
                GRI = AdvGRI(WorldInfo.GRI);
                // End:0x530
                if(GameSettings != none)
                {
                    bWriteStats = GRI.IsMultiplayerGame();
                    bDestroySession = ((int(WorldInfo.NetMode) == int(NM_Client)) ? true : false);
                    WriteStatsAndEndGameSession(bWriteStats, bDestroySession, OnClientReturnToPartySessionCleanupComplete);                    
                }
                else
                {
                    OnClientReturnToPartySessionCleanupComplete(true);
                }
            }
        }
        // End:0x57B
        if(PlayerReplicationInfo.UniqueId == RequestingPlayerId)
        {
            ClientShowDefaultLoadingMovie();            
        }
        else
        {
            ClientShowReturnToPartyMovie();
        }        
    }
    //return;    
}

static function string GetPartyMapName()
{
    return "UI-StartMap";
    //return ReturnValue;    
}

static function string GetPartyGameTypeName()
{
    return "ADVGame.AdvPartyGame_Base";
    //return ReturnValue;    
}

function OnClientReturnToPartySessionCleanupComplete(bool bWasSuccessful)
{
    local string URL;
    local OnlineGameSettings Party, GameSettings;
    local UniqueNetId ZeroId;
    local bool bDeletePartyReturnToMain;
    local OnlineSubsystem.ELoginStatus LoginStatus;
    local AdvLocalPlayer LP;

    Party = OnlineSub.GameInterface.GetGameSettings('Party');
    GameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfo.SessionName);
    // End:0x325
    if(Party != none)
    {
        // End:0x143
        if(IsPartyLeader())
        {
            UnregisterRemotePlayers();
            URL = (((GetPartyMapName()) $ "?game=") $ (GetPartyGameTypeName())) $ "?listen";
            PreClientTravel(URL, 0, false);
            WorldInfo.ServerTravel(URL, true, true);            
        }
        else
        {
            // End:0x316
            if(bWasLocalSystemOrPrivate || !GameSettings.bUsesArbitration)
            {
                LP = AdvLocalPlayer(Player);
                LoginStatus = 2;
                // End:0x254
                if(((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
                {
                    LoginStatus = OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId));
                }
                // End:0x307
                if((int(LoginStatus) == int(2)) || int(LP.GetCurrentPartyType()) == int(2))
                {
                    // End:0x2F8
                    if(OnlineSub.GameInterface.GetResolvedConnectString('Party', URL))
                    {
                        ClientTravel(URL, 0);                        
                    }
                    else
                    {
                        bDeletePartyReturnToMain = true;
                    }                    
                }
                else
                {
                    bDeletePartyReturnToMain = true;
                }                
            }
            else
            {
                bDeletePartyReturnToMain = true;
            }
        }        
    }
    else
    {
        URL = (((GetPartyMapName()) $ "?game=") $ (GetPartyGameTypeName())) $ "?listen";
        PreClientTravel(URL, 0, false);
        WorldInfo.ServerTravel(URL, true, true);
    }
    ReturnToPartyRequestingId = ZeroId;
    bWasLocalSystemOrPrivate = false;
    // End:0x3E4
    if(bDeletePartyReturnToMain)
    {
        CheckOkToDeletePartySession(OnDestroyPartyCompleteForMainMenu);        
    }
    else
    {
        CloseReturnToMainMenuCogSpin();
    }
    //return;    
}

simulated function OnDestroyPartyCompleteForMainMenu(name SessionName, bool bWasSuccessful)
{
    local AdvGFxMenuHudWrapper GMH;
    local bool bTravel, bIsPreGameLobby;

    // End:0x2A6
    if(SessionName == 'Party')
    {
        // End:0xA3
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
        {
            OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyCompleteForMainMenu);
        }
        GMH = AdvGFxMenuHudWrapper(myHUD);
        // End:0x131
        if(GMH != none)
        {
            // End:0x131
            if(GMH.Frontend != none)
            {
                bIsPreGameLobby = GMH.Frontend.bPreGameLobby;
            }
        }
        CloseReturnToMainMenuCogSpin();
        // End:0x29A
        if(((AdvLocalPlayer(Player) != none) && AdvGameMenu(WorldInfo.Game) != none) && !bIsPreGameLobby)
        {
            // End:0x297
            if(GMH != none)
            {
                // End:0x23A
                if(((GMH.Frontend != none) && GMH.Frontend.IsMatchmaking(true)) && int(WorldInfo.NetMode) != int(NM_Client))
                {
                    bTravel = true;                    
                }
                else
                {
                    bSeamlessTravel = false;
                    ClientStopLevelLoadingMovie();
                    GMH.RestartFrontEnd(AdvLocalPlayer(Player).bIsFirstFrontEndLoad);
                }
            }            
        }
        else
        {
            bTravel = true;
        }
    }
    // End:0x2CA
    if(bTravel)
    {
        ClientTravel("?Closed", 0);
    }
    //return;    
}

simulated function UnregisterRemotePlayers()
{
    local AdvPlayerController OwnerPC;
    local AdvPRI PRI;
    local int Index;

    // End:0x1C9
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        Index = 0;
        J0x51:

        // End:0x1C9 [Loop If]
        if(Index < WorldInfo.GRI.PRIArray.Length)
        {
            PRI = AdvPRI(WorldInfo.GRI.PRIArray[Index]);
            OwnerPC = AdvPlayerController(PRI.Owner);
            // End:0x1BB
            if(((OwnerPC == none) || !OwnerPC.IsLocalPlayerController()) && PRI.PartyOwnerUniqueId == AdvPRI(PlayerReplicationInfo).PartyOwnerUniqueId)
            {
                PRI.UnregisterPlayerFromParty();
            }
            Index++;
            // [Loop Continue]
            goto J0x51;
        }
    }
    //return;    
}

reliable server function LogoutFromParty()
{
    AdvPRI(PlayerReplicationInfo).UnregisterPlayerFromParty();
    // End:0x93
    if(AdvPartyGame_Base(WorldInfo.Game) != none)
    {
        AdvPartyGame_Base(WorldInfo.Game).Logout(self);
    }
    //return;    
}

reliable client simulated function ClientSetAllPlayerPawnsCustomTimeDilation(float InCustomTimeDilation)
{
    local EvilPawn EPawn;

    // End:0x83
    foreach WorldInfo.AllPawns(Class'EvilGame.EvilPawn', EPawn)
    {
        // End:0x82
        if(EPawn.PlayerReplicationInfo != none)
        {
            EPawn.CustomTimeDilation = InCustomTimeDilation;
        }        
    }    
    //return;    
}

function TellClientToRecreateParty()
{
    local AdvFrontEnd Frontend;

    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    // End:0x59
    if(Frontend != none)
    {
        Frontend.bStartPartySession = true;
    }
    //return;    
}

function DisbandParty()
{
    local AdvPlayerController PC;

    // End:0x89
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        // End:0x88
        if((PC != none) && !PC.IsLocalController())
        {
            PC.TellClientToRecreateParty();
        }        
    }    
    //return;    
}

function bool HasParty()
{
    local AdvPlayerController PC;

    // End:0x6D
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        // End:0x6C
        if((PC != none) && !PC.IsLocalController())
        {            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

static simulated function UpdateGameSettingsFromPlaylistId(OnlineGameSettings GameSettings, int PlaylistId, OnlinePlaylistManager PlaylistMan)
{
    local OnlineSubsystem OnlineSS;

    OnlineSS = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x156
    if((((OnlineSS != none) && NotEqual_InterfaceInterface(OnlineSS.GameInterface, OnlineGameInterface(none))) && GameSettings != none) && PlaylistId > 0)
    {
        GameSettings.SetIntProperty(268435457, PlaylistId);
        GameSettings.SetIntProperty(268435488, PlaylistMan.VersionNumber);
        GameSettings.SetStringSettingValue(32779, Class'AdvGameSettingsCommon'.static.GetGameModeFromPlaylistId(PlaylistMan, PlaylistId), true);
    }
    //return;    
}

exec function ShowMarketPlace()
{
    local OnlinePlayerInterfaceEx PlayerIntEx;

    PlayerIntEx = OnlineSub.PlayerInterfaceEx;
    // End:0x93
    if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
    {
        PlayerIntEx.ShowContentMarketplaceUI(byte(AdvLocalPlayer(Player).ControllerId));
    }
    //return;    
}

exec function ShowMarketPlace2(int CategoryMask, int OfferId)
{
    local OnlinePlayerInterfaceEx PlayerIntEx;

    PlayerIntEx = OnlineSub.PlayerInterfaceEx;
    // End:0xA3
    if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
    {
        PlayerIntEx.ShowContentMarketplaceUI(byte(AdvLocalPlayer(Player).ControllerId), CategoryMask, OfferId);
    }
    //return;    
}

function PreventDeath()
{
    //return;    
}

function RestartFrontEnd()
{
    //return;    
}

simulated function SwitchView()
{
    //return;    
}

simulated function PreJoinUpdateGameSettings(name SessionName, OnlineGameSettings GameSettings)
{
    local OnlinePlaylistManager PlaylistMan;

    // End:0xB9
    if(SessionName == 'Game')
    {
        PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
        // End:0xB9
        if(PlaylistMan != none)
        {
            UpdateGameSettingsFromPlaylistId(GameSettings, AdvGRI(WorldInfo.GRI).PlaylistId, PlaylistMan);
        }
    }
    //return;    
}

unreliable client simulated function SetAlienFxLight(EvilPlayerController.EAlienFxLight Light, byte R, byte G, byte B, EvilPlayerController.EAlienFxMode Mode, EvilPlayerController.EAlienFxType Type, float Duration, optional int repeatTimes = 1)
{
    local EvilEngine Engine;

    // End:0x4E
    if(CheckAlienFx(Mode))
    {
        // End:0x37
        if(actualDuration == Duration)
        {
            return;            
        }
        else
        {
            ClearAlienFx(actualMode, false);
        }        
    }
    else
    {
        // End:0x6B
        if(int(Mode) < int(actualMode))
        {
            return;
        }
    }
    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x2A8
    if(Engine != none)
    {
        actualColor.R = R;
        actualColor.G = G;
        actualColor.B = B;
        actualColor.A = 255;
        actualDuration = Duration;
        actualMode = Mode;
        actualLight = Light;
        switch(Type)
        {
            // End:0x1A0
            case 0:
                typeMod = 1.0000000;
                // End:0x1BE
                break;
            // End:0x1BB
            case 1:
                typeMod = impulseBlinkModifier;
                // End:0x1BE
                break;
            // End:0xFFFF
            default:
                break;
        }
        Engine.AlienwareSetLights(int(actualLight), actualColor);
        // End:0x225
        if(repeatTimes == 1)
        {
            SetTimer(actualDuration * typeMod, false, 'SetAlienFxTimerOff');            
        }
        else
        {
            SetTimer(actualDuration * typeMod, false, 'SetAlienFxOff');
            SetTimer(actualDuration * float(2), true, 'SetAlienFxLast');
            // End:0x2A8
            if(repeatTimes > 1)
            {
                SetTimer((float(repeatTimes) * (actualDuration * float(2))) - actualDuration, false, 'SetAlienFxTimerOff');
            }
        }
    }
    //return;    
}

function bool CheckAlienFx(EvilPlayerController.EAlienFxMode Mode)
{
    return ((int(actualMode) == int(Mode)) ? true : false);
    //return ReturnValue;    
}

function bool CheckAlienFxLight(EvilPlayerController.EAlienFxLight Light)
{
    return ((int(actualLight) == int(Light)) ? true : false);
    //return ReturnValue;    
}

function SetAlienFxLast()
{
    local EvilEngine Engine;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x96
    if(Engine != none)
    {
        Engine.AlienwareSetLights(int(actualLight), actualColor);
        SetTimer(actualDuration * typeMod, false, 'SetAlienFxOff');
    }
    //return;    
}

function SetAlienFxOff()
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).AlienwareTurnOffLights();
    //return;    
}

function SetAlienFxTimerOff()
{
    ClearAlienFx(actualMode);
    //return;    
}

unreliable client simulated function ClearAlienFx(EvilPlayerController.EAlienFxMode Mode, optional bool withLights = true)
{
    // End:0xBD
    if(CheckAlienFx(Mode))
    {
        // End:0x66
        if(withLights)
        {
            EvilEngine(Class'Engine.Engine'.static.GetEngine()).AlienwareTurnOffLights();
        }
        ClearTimer('SetAlienFxOff');
        ClearTimer('SetAlienFxLast');
        ClearTimer('SetAlienFxTimerOff');
        actualMode = 0;
        actualLight = 0;        
    }
    else
    {
        // End:0x10F
        if(int(Mode) == int(0))
        {
            EvilEngine(Class'Engine.Engine'.static.GetEngine()).AlienwareTurnOffLights();
        }
    }
    //return;    
}

function SetAlienFxTimerRate(EvilPlayerController.EAlienFxMode Mode, EvilPlayerController.EAlienFxLight Light, name inTimer, float Value)
{
    // End:0x64
    if((CheckAlienFx(Mode)) && CheckAlienFxLight(Light))
    {
        ModifyTimerRate(inTimer, Value);
        actualDuration = Value / float(2);
    }
    //return;    
}

exec function ToggleInventoryMap()
{
    local AdvWeap_Base Map;

    // End:0x1A
    if(Vehicle(Pawn) != none)
    {
        return;
    }
    Map = AdvWeap_Base(MyEvilPawn.FindInventoryType(Class'AdvInventoryItem_Map'));
    // End:0x151
    if(Map != none)
    {
        // End:0xE8
        if((MyEvilPawn.WeaponLeft != Map) && CanShowGameplayObject())
        {
            MyEvilPawn.SetBlockingInventoryClass(Map.Class, true);
            ShowGameplayObject();
        }
        // End:0x14E
        if((MyEvilPawn.WeaponLeft == Map) && CanHideGameplayObject())
        {
            HideGameplayObject();
            MyEvilPawn.SetBlockingInventoryClass(none, true);
        }        
    }
    else
    {
        // End:0x1CD
        if(AdvHudWrapper != none)
        {
            AdvHudWrapper.HudMovie.SetCenterMessageText(Localize("LocalizedCenterMessages", "NoMapText", "ADVGame"));
        }
    }
    //return;    
}

exec function Melee()
{
    super.Melee();
    // End:0x6D
    if(PlayerInput.bUsingGamepad)
    {
        // End:0x6D
        if(Vehicle(Pawn) != none)
        {
            Vehicle(Pawn).DriverLeave(false);
        }
    }
    //return;    
}

reliable client simulated function AddObjectiveIcon(Actor Target, string Type)
{
    local TObjectiveIconStorage ObjIcon;
    local int I;

    // End:0x35
    if((Target == none) || Target.bDeleteMe)
    {
        return;
    }
    I = 0;
    J0x40:

    // End:0x9C [Loop If]
    if(I < ObjectiveIconStorage.Length)
    {
        // End:0x8E
        if(ObjectiveIconStorage[I].Target == Target)
        {
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x40;
    }
    ObjIcon.Target = Target;
    ObjIcon.Type = Type;
    ObjectiveIconStorage.AddItem(ObjIcon);    
    AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).AddObjectiveIcon(Target, Type);
    //return;    
}

reliable client simulated function RemoveObjectiveIcon(Actor Target)
{
    local int I;

    I = ObjectiveIconStorage.Length - 1;
    J0x17:

    // End:0xCE [Loop If]
    if(I >= 0)
    {
        // End:0xC0
        if(ObjectiveIconStorage[I].Target == Target)
        {
            ObjectiveIconStorage.Remove(I, 1);            
            AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).DeleteObjectiveIcon(Target);
            return;
        }
        I--;
        // [Loop Continue]
        goto J0x17;
    }
    //return;    
}

function RegisterOnlineDelegates()
{
    local OnlinePlayerInterface PlayerInterface;
    local OnlinePlayerInterfaceEx PlayerIntEx;
    local LocalPlayer LocPlayer;

    super(PlayerController).RegisterOnlineDelegates();
    // End:0x1B
    if(!IsPrimaryPlayer())
    {
        return;
    }
    LocPlayer = LocalPlayer(Player);
    // End:0x4C8
    if((LocPlayer != none) && OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        // End:0x214
        if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerInterface.AddLoginStatusChangeDelegate(OnLoginStatusChange, byte(LocPlayer.ControllerId));
            PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
            PlayerInterface.AddReadProfileSettingsCompleteDelegate(byte(LocPlayer.ControllerId), OnProfileReadComplete);
            PlayerInterface.AddReadPlayerStorageCompleteDelegate(byte(LocPlayer.ControllerId), OnPersistentDataReadComplete);
            PlayerInterface.AddWriteProfileSettingsCompleteDelegate(byte(LocPlayer.ControllerId), OnProfileWriteComplete);
        }
        PlayerIntEx = OnlineSub.PlayerInterfaceEx;
        // End:0x2AD
        if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
        {
            PlayerIntEx.AddDeviceSelectionDoneDelegate(byte(LocPlayer.ControllerId), OnDeviceSelectionComplete);
        }
        // End:0x3A5
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.AddConnectionStatusChangeDelegate(OnConnectionStatusChange);
            OnlineSub.SystemInterface.AddLinkStatusChangeDelegate(OnLinkStatusChanged);
            OnlineSub.SystemInterface.SetNetworkNotificationPosition(2);
        }
        OnlineSubsystemSteamworks(OnlineSub).AddOnDLCDownloadCompleteDelegate(OnDLCDownloadComplete);
        OnlineSubsystemSteamworks(OnlineSub).LobbyInterface.AddLobbyInviteDelegate(OnLobbyInviteDelegate);
        OnlineSubsystemSteamworks(OnlineSub).LobbyInterface.AddLobbyJoinGameSimpleDelegate(OnLobbyJoinGameSimpleDelegate);
        OnlineSubsystemSteamworks(OnlineSub).LobbyInterface.AddLobbyJoinGameDelegate(OnLobbyJoinGameDelegate);
    }
    //return;    
}

function ClearOnlineDelegates()
{
    local OnlinePlayerInterfaceEx PlayerIntEx;
    local OnlinePlayerInterface PlayerInterface;
    local OnlinePlaylistManager PlaylistMan;
    local LocalPlayer LocPlayer;

    super(UTPlayerController).ClearOnlineDelegates();
    // End:0x1B
    if(!IsPrimaryPlayer())
    {
        return;
    }
    LocPlayer = LocalPlayer(Player);
    // End:0x5B6
    if((LocPlayer != none) && OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        // End:0x214
        if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerInterface.ClearLoginStatusChangeDelegate(OnLoginStatusChange, byte(LocPlayer.ControllerId));
            PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
            PlayerInterface.ClearReadProfileSettingsCompleteDelegate(byte(LocPlayer.ControllerId), OnProfileReadComplete);
            PlayerInterface.ClearReadPlayerStorageCompleteDelegate(byte(LocPlayer.ControllerId), OnPersistentDataReadComplete);
            PlayerInterface.ClearWriteProfileSettingsCompleteDelegate(byte(LocPlayer.ControllerId), OnProfileWriteComplete);
        }
        PlayerIntEx = OnlineSub.PlayerInterfaceEx;
        // End:0x2AD
        if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
        {
            PlayerIntEx.ClearDeviceSelectionDoneDelegate(byte(LocPlayer.ControllerId), OnDeviceSelectionComplete);
        }
        // End:0x328
        if(NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
        {
            OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(ReadLeaderboardStatsComplete);
        }
        PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
        // End:0x3D2
        if(PlaylistMan != none)
        {
            PlaylistMan.__OnPlaylistPopulationDataUpdated__Delegate = None;
            PlaylistMan.__OnReadPlaylistComplete__Delegate = None;
        }
        // End:0x493
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.ClearConnectionStatusChangeDelegate(OnConnectionStatusChange);
            OnlineSub.SystemInterface.ClearLinkStatusChangeDelegate(OnLinkStatusChanged);
        }
        OnlineSubsystemSteamworks(OnlineSub).ClearOnDLCDownloadCompleteDelegate(OnDLCDownloadComplete);
        OnlineSubsystemSteamworks(OnlineSub).LobbyInterface.ClearLobbyInviteDelegate(OnLobbyInviteDelegate);
        OnlineSubsystemSteamworks(OnlineSub).LobbyInterface.ClearLobbyInviteDelegate(OnLobbyJoinGameSimpleDelegate);
        OnlineSubsystemSteamworks(OnlineSub).LobbyInterface.ClearLobbyJoinGameDelegate(OnLobbyJoinGameDelegate);
    }
    //return;    
}

function CleanupMessageBoxesForInvite()
{
    local AdvLocalPlayer LP;
    local AdvUIManager UIManager;

    LP = AdvLocalPlayer(Player);
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x86
    if(UIManager != none)
    {
        UIManager.CloseAllUIMessageBoxes(LP);
    }
    //return;    
}

function OnGameInviteAccepted0(const out OnlineGameSearchResult InviteResult)
{
    local UniqueNetId UserId;
    local AdvFrontEnd Frontend;

    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    // End:0xBC
    if(OnlineSub.PlayerInterface.GetUniquePlayerId(0, UserId))
    {
        AdvEngine(Class'AdvEngine'.static.GetEngine()).SetInviteCache(UserId, InviteResult);
    }
    // End:0x106
    if((Frontend == none) || !Frontend.bOnTitleScreen)
    {
        CleanupMessageBoxesForInvite();
        ReturnToMainMenu(true);
    }
    //return;    
}

function OnGameInviteAccepted1(const out OnlineGameSearchResult InviteResult)
{
    local UniqueNetId UserId;
    local AdvFrontEnd Frontend;

    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    // End:0xBC
    if(OnlineSub.PlayerInterface.GetUniquePlayerId(1, UserId))
    {
        AdvEngine(Class'AdvEngine'.static.GetEngine()).SetInviteCache(UserId, InviteResult);
    }
    // End:0x106
    if((Frontend == none) || !Frontend.bOnTitleScreen)
    {
        CleanupMessageBoxesForInvite();
        ReturnToMainMenu(true);
    }
    //return;    
}

function OnGameInviteAccepted2(const out OnlineGameSearchResult InviteResult)
{
    local UniqueNetId UserId;
    local AdvFrontEnd Frontend;

    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    // End:0xBC
    if(OnlineSub.PlayerInterface.GetUniquePlayerId(2, UserId))
    {
        AdvEngine(Class'AdvEngine'.static.GetEngine()).SetInviteCache(UserId, InviteResult);
    }
    // End:0x106
    if((Frontend == none) || !Frontend.bOnTitleScreen)
    {
        CleanupMessageBoxesForInvite();
        ReturnToMainMenu(true);
    }
    //return;    
}

function OnGameInviteAccepted3(const out OnlineGameSearchResult InviteResult)
{
    local UniqueNetId UserId;
    local AdvFrontEnd Frontend;

    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    // End:0xBC
    if(OnlineSub.PlayerInterface.GetUniquePlayerId(3, UserId))
    {
        AdvEngine(Class'AdvEngine'.static.GetEngine()).SetInviteCache(UserId, InviteResult);
    }
    // End:0x106
    if((Frontend == none) || !Frontend.bOnTitleScreen)
    {
        CleanupMessageBoxesForInvite();
        ReturnToMainMenu(true);
    }
    //return;    
}

function OnRegisterPlayerComplete(name SessionName, UniqueNetId PlayerID, bool bWasSuccessful)
{
    // End:0x20
    if(bWasSuccessful)
    {
        ServerRefreshMuteListFor(PlayerID);
    }
    //return;    
}

reliable server function ServerRefreshMuteListFor(UniqueNetId PlayerID)
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(Class'Engine.PlayerController'.static.GetPlayerControllerFromNetId(PlayerID));
    // End:0xBF
    if((ADVGame(WorldInfo.Game) != none) && PC != none)
    {
        ADVGame(WorldInfo.Game).UpdateGameplayMuteList(PC);
    }
    //return;    
}

event PerformGameHostMigration()
{
    //return;    
}

function PeerDesignatedAsHost(name SessionName)
{
    PerformGameHostMigration();
    super(PlayerController).PeerDesignatedAsHost(SessionName);
    ClientShowHostMigrationMovie();
    //return;    
}

function int BestNextHostSort(AdvPlayerControllerMP A, AdvPlayerControllerMP B)
{
    local int Result;

    // End:0xA2
    if(A.ConnectedPeers.Length == B.ConnectedPeers.Length)
    {
        Result = FCeil(A.HostMigrationScore) - FCeil(B.HostMigrationScore);        
    }
    else
    {
        Result = A.ConnectedPeers.Length - B.ConnectedPeers.Length;
    }
    return Result;
    //return ReturnValue;    
}

function UpdateBestNextHostsOnNotify()
{
    local AdvPlayerControllerMP PC;
    local array<PlayerController> SortedPCList;
    local UniqueNetId SortedPlayerIdList[10], ZeroId;
    local int Idx, NumEntries;

    // End:0x12D
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        // End:0x12C
        if((((!PC.IsLocalPlayerController() && PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo.UniqueId != ZeroId) && PC.HostMigrationScore > 0.0001000) && PC.IsPrimaryPlayer())
        {
            SortedPCList.AddItem(PC);            
        }        
    }    
    SortedPCList.Sort(BestNextHostSort);    
    NumEntries = Min(SortedPCList.Length, 10);
    Idx = 0;
    J0x16F:

    // End:0x1E5 [Loop If]
    if(Idx < NumEntries)
    {
        SortedPlayerIdList[Idx] = SortedPCList[Idx].PlayerReplicationInfo.UniqueId;
        Idx++;
        // [Loop Continue]
        goto J0x16F;
    }
    // End:0x271
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        // End:0x270
        if(!PC.IsLocalPlayerController())
        {
            PC.ClientUpdateBestNextHosts(SortedPlayerIdList, byte(NumEntries));
        }        
    }    
    //return;    
}

reliable server function ServerUpdateHostMigrationScore(float NewHostMigrationScore)
{
    HostMigrationScore = NewHostMigrationScore;
    UpdateBestNextHostsOnNotify();
    //return;    
}

simulated function UpdateHostMigrationScore()
{
    local OnlineSubsystem.ENATType NatType;
    local array<ConnectionBandwidthStats> BandwidthHistory;
    local int MinutesSinceLastTest;
    local array<float> Weights;

    HostMigrationScore = 1.0000000;
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x1FC
    if(OnlineSub != none)
    {
        // End:0x1FC
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            NatType = OnlineSub.SystemInterface.GetNATType();
            // End:0x121
            if((int(NatType) < int(Class'AdvGameMenu'.default.CanHostVersusNatType)) || Class'Engine.Engine'.static.IsSplitScreen())
            {
                HostMigrationScore = 0.0000000;                
            }
            else
            {
                // End:0x1FC
                if(ProfileSettings != none)
                {
                    ProfileSettings.ReadBandwidthHistory(BandwidthHistory, MinutesSinceLastTest);
                    // End:0x1FC
                    if(BandwidthHistory.Length > 0)
                    {
                        Weights.Length = 5;
                        Weights[0] = 5.0000000;
                        Weights[1] = 4.0000000;
                        Weights[2] = 3.0000000;
                        Weights[3] = 2.0000000;
                        Weights[4] = 1.0000000;
                        HostMigrationScore = CalcWeightedUpstreamAvg(BandwidthHistory, Weights);
                    }
                }
            }
        }
    }
    ServerUpdateHostMigrationScore(HostMigrationScore);
    //return;    
}

static function float CalcWeightedUpstreamAvg(const out array<ConnectionBandwidthStats> BandwidthHistory, const out array<float> Weights)
{
    local int BandwidthIdx, WeightIdx;
    local float AvgResult, CurWeight, WeightSum;

    // End:0xF6
    if(BandwidthHistory.Length > 0)
    {
        CurWeight = 1.0000000;
        BandwidthIdx = 0;
        J0x2A:

        // End:0xE2 [Loop If]
        if(BandwidthIdx < BandwidthHistory.Length)
        {
            // End:0x82
            if(WeightIdx < Weights.Length)
            {
                CurWeight = Weights[WeightIdx];
                WeightIdx++;
            }
            WeightSum += CurWeight;
            AvgResult += (float(BandwidthHistory[BandwidthIdx].UpstreamRate) * CurWeight);
            BandwidthIdx++;
            // [Loop Continue]
            goto J0x2A;
        }
        AvgResult /= WeightSum;
    }
    return AvgResult;
    //return ReturnValue;    
}

function bool IsThereOtherReasonToLetUseHold()
{
    local bool Result;
    local AdvPuzzle_Base AP;

    Result = super.IsThereOtherReasonToLetUseHold();
    // End:0x54
    foreach Pawn.OverlappingActors(Class'AdvPuzzle_Base', AP, 50.0000000)
    {        
        return true;        
    }    
    return Result;
    //return ReturnValue;    
}

function class<OnlineGameSearch> GetCurrentSearchClass()
{
    return Class'AdvGameSearchDeathmatch';
    //return ReturnValue;    
}

function UpdateGameSettings(name SessionName)
{
    local OnlineGameSettings ServerGameSettings;

    ServerGameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
    OnlineSub.DumpGameSettings(ServerGameSettings);
    UpdateIntProperty(268435457, ServerGameSettings, SessionName);
    UpdateIntProperty(268435458, ServerGameSettings, SessionName);
    UpdateIntProperty(268435459, ServerGameSettings, SessionName);
    UpdateIntProperty(268435460, ServerGameSettings, SessionName);
    UpdateStringProperty(1073741825, ServerGameSettings, SessionName);
    UpdateStringProperty(1073741826, ServerGameSettings, SessionName);
    UpdateStringSetting(32779, ServerGameSettings, SessionName);
    UpdateStringSetting(0, ServerGameSettings, SessionName);
    //return;    
}

function UpdateIntProperty(int PropertyId, OnlineGameSettings ServerGameSettings, name SessionName)
{
    local int IntValue;

    // End:0x59
    if(ServerGameSettings.GetIntProperty(PropertyId, IntValue))
    {
        ClientUpdateGameSettingsIntProperty(PropertyId, IntValue, SessionName);
    }
    //return;    
}

function UpdateStringProperty(int PropertyId, OnlineGameSettings ServerGameSettings, name SessionName)
{
    local string StringValue;

    // End:0x59
    if(ServerGameSettings.GetStringProperty(PropertyId, StringValue))
    {
        ClientUpdateGameSettingsStringProperty(PropertyId, StringValue, SessionName);
    }
    //return;    
}

function UpdateStringSetting(int SettingId, OnlineGameSettings ServerGameSettings, name SessionName)
{
    local int IntValue;

    // End:0x59
    if(ServerGameSettings.GetStringSettingValue(SettingId, IntValue))
    {
        ClientUpdateGameSettingsStringSetting(SettingId, IntValue, SessionName);
    }
    //return;    
}

reliable client simulated function ClientUpdateGameSettingsIntProperty(int PropertyId, int Value, name SessionName)
{
    local OnlineGameSettings GameSettings;

    // End:0x7D
    if(NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings(SessionName);
    }
    // End:0xBD
    if(GameSettings != none)
    {
        GameSettings.SetIntProperty(PropertyId, Value);
    }
    //return;    
}

reliable client simulated function ClientUpdateGameSettingsStringProperty(int PropertyId, string Value, name SessionName)
{
    local OnlineGameSettings GameSettings;

    // End:0x7D
    if(NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings(SessionName);
    }
    // End:0xBD
    if(GameSettings != none)
    {
        GameSettings.SetStringProperty(PropertyId, Value);
    }
    //return;    
}

reliable client simulated function ClientUpdateGameSettingsStringSetting(int SettingId, int Value, name SessionName)
{
    local OnlineGameSettings GameSettings;

    // End:0x7D
    if(NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings(SessionName);
    }
    // End:0xBE
    if(GameSettings != none)
    {
        GameSettings.SetStringSettingValue(SettingId, Value);
    }
    //return;    
}

reliable client simulated function NotifyWeaponFireTargetChanged(Actor A, bool bNewEnabled)
{
    local EvilWeaponFireTargetInterface FireTargetInterface;

    FireTargetInterface = EvilWeaponFireTargetInterface(A);
    // End:0x69
    if(NotEqual_InterfaceInterface(FireTargetInterface, EvilWeaponFireTargetInterface(none)))
    {
        FireTargetInterface.SetWeaponFireTarget(bNewEnabled);        
    }
    else
    {
        // End:0xB3
        if(InterpActor(A) != none)
        {
            InterpActor(A).SetWeaponFireTarget(bNewEnabled);
        }
    }
    //return;    
}

simulated function int GetPlayerAvailableDLCFlag()
{
    local int DLCFlagResult;
    local AdvEngine Engine;
    local int I;

    Engine = AdvEngine(Class'AdvEngine'.static.GetEngine());
    CheckDLCs();
    // End:0xC1
    if(Engine != none)
    {
        I = 1;
        J0x56:

        // End:0xC1 [Loop If]
        if(I < 31)
        {
            // End:0xB3
            if(Engine.UserHasDLC(I, self))
            {
                DLCFlagResult = DLCFlagResult | (1 << I);
            }
            ++I;
            // [Loop Continue]
            goto J0x56;
        }
    }
    return DLCFlagResult;
    //return ReturnValue;    
}

reliable client simulated function UpdateLocalPlayersDLCValues()
{
    local AdvPlayerController PC;
    local int DLCFlagResult;
    local AdvPRI PRI;

    DLCFlagResult = GetPlayerAvailableDLCFlag();
    // End:0xCA
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        PRI = AdvPRI(PC.PlayerReplicationInfo);
        // End:0xC9
        if((PRI != none) && DLCFlagResult != PRI.DLCFlag)
        {
            PC.ServerSetDLCFlag(DLCFlagResult);
        }        
    }    
    //return;    
}

reliable server function ServerSetDLCFlag(int DLCFlag)
{
    AdvPRI(PlayerReplicationInfo).DLCFlag = DLCFlag;
    // End:0x12C
    if(Class'AdvFrontEnd'.static.GetFrontEnd() != none)
    {
        // End:0x12C
        if(AdvFrontEndParty(Class'AdvFrontEnd'.static.GetFrontEnd()) != none)
        {
            // End:0x12C
            if(AdvGFxUI_Menu_PregameLobbyPrivateHost(AdvFrontEndParty(Class'AdvFrontEnd'.static.GetFrontEnd()).PregameLobby) != none)
            {
                AdvGFxUI_Menu_PregameLobbyPrivateHost(AdvFrontEndParty(Class'AdvFrontEnd'.static.GetFrontEnd()).PregameLobby).UpdateLobbyMapWithPriDLCFlags();
            }
        }
    }
    //return;    
}

function InitPlayerReplicationInfo()
{
    super.InitPlayerReplicationInfo();
    UpdateLocalPlayersDLCValues();
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x53
    if(VarName == 'PlayerReplicationInfo')
    {
        // End:0x50
        if(PlayerReplicationInfo != none)
        {
            PlayerReplicationInfo.ClientInitialize(self);
            UpdateLocalPlayersDLCValues();
        }        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

function bool HasPreorder()
{
    return int(IsDLCInstalled(10)) == int(1);
    //return ReturnValue;    
}

function bool GetPreorderWeaponSelectedFromProfile()
{
    return ProfileSettings.GetPreorderWeaponSelected();
    //return ReturnValue;    
}

simulated function DumpMITextures(MaterialInterface MI)
{
    local MaterialInstanceConstant MC;

    MC = MaterialInstanceConstant(MI);
    J0x1C:

    MI = MaterialInstance(MI).Parent;
    MC = MaterialInstanceConstant(MI);
    // End:0x1C
    if(!(MI != none))
        goto J0x1C;
    //return;    
}

exec function DumpPawnMaterials()
{
    local AdvPawn P;
    local int I;
    local MaterialInterface MI;

    // End:0x158
    foreach WorldInfo.AllPawns(Class'AdvPawn', P)
    {
        // End:0x157
        if(P.Mesh != none)
        {
            // End:0x157
            if(P.Mesh.SkeletalMesh != none)
            {
                I = 0;
                J0x9E:

                // End:0x157 [Loop If]
                if(I < P.Mesh.Materials.Length)
                {
                    MI = P.Mesh.Materials[I];
                    // End:0x149
                    if(MI != none)
                    {
                        DumpMITextures(MI);
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x9E;
                }
            }
        }        
    }    
    //return;    
}

reliable client simulated event Kismet_ClientPlaySound(SoundCue ASound, Actor SourceActor, float VolumeMultiplier, float PitchMultiplier, float FadeInTime, bool bSuppressSubtitles, bool bSuppressSpatialization)
{
    // End:0x15F
    if((((int(WorldInfo.NetMode) != int(NM_Standalone)) || Pawn.IsAliveAndWell()) || bCinematicMode) || (((ASound.SoundClass != 'Dialog') && ASound.SoundClass != 'Character') && ASound.SoundClass != 'CharacterFriend') && ASound.SoundClass != 'CharacterEnemy')
    {
        super(PlayerController).Kismet_ClientPlaySound(ASound, SourceActor, VolumeMultiplier, PitchMultiplier, FadeInTime, bSuppressSubtitles, bSuppressSpatialization);
    }
    //return;    
}

reliable client simulated function SetAudioGroupParams(float VolumeMultiplier, optional name NewSoundMode = 'Default')
{
    ClientSetSoundMode(NewSoundMode);
    // End:0xE9
    if(ProfileSettings != none)
    {
        SetAudioGroupVolume('SFX', ProfileSettings.GetSFXVolume() * VolumeMultiplier);
        SetAudioGroupVolume('Voice', ProfileSettings.GetVoiceVolume() * VolumeMultiplier);
        SetAudioGroupVolume('Music', ProfileSettings.GetMusicVolume() * VolumeMultiplier);
    }
    //return;    
}

function MoveSmoothTo(Vector DestLocation)
{
    // End:0x39
    if(!IsInState('MovingSmooth'))
    {
        MoveSmoothLocation = DestLocation;
        PushState('MovingSmooth');
    }
    //return;    
}

// Export UAdvPlayerController::execIsPCGamepadConnected(FFrame&, void* const)
native simulated function bool IsPCGamepadConnected();

simulated function bool IsPCGamepadMode()
{
    return AdvLocalPlayer(Player).bPCGamepadMode && !AdvLocalPlayer(Player).bForceNoGamepadUI;
    //return ReturnValue;    
}

exec function TestFreeWeekendSubscription()
{
    //return;    
}

simulated function bool IsFreeWeekendSubscribed()
{
    local OnlineSubsystemSteamworks SteamSub;

    SteamSub = OnlineSubsystemSteamworks(Class'Engine.GameEngine'.static.GetOnlineSubsystem());
    return int(SteamSub.IsDLCInstalled(267580)) == int(0);
    //return ReturnValue;    
}

state MirrorControlling
{
    function PlayerMove(float DeltaTime)
    {
        local Rotator Rot, RotationRestriction, BaseRotation;

        // End:0x424
        if(AdvMirrorDynamic(Pawn) != none)
        {
            Rot = Pawn.Rotation;
            BaseRotation = AdvMirrorDynamic(Pawn).BaseRotation;
            RotationRestriction = AdvMirrorDynamic(Pawn).GetRotationRestriction();
            Rot.Pitch += int(PlayerInput.aForward * DeltaTime);
            Rot.Yaw += int(PlayerInput.aStrafe * DeltaTime);
            // End:0x1EA
            if(Rot.Yaw > (BaseRotation.Yaw + RotationRestriction.Yaw))
            {
                Rot.Yaw = BaseRotation.Yaw + RotationRestriction.Yaw;                
            }
            else
            {
                // End:0x29C
                if(Rot.Yaw < (BaseRotation.Yaw - RotationRestriction.Yaw))
                {
                    Rot.Yaw = BaseRotation.Yaw - RotationRestriction.Yaw;
                }
            }
            // End:0x351
            if(Rot.Pitch > (BaseRotation.Pitch + RotationRestriction.Pitch))
            {
                Rot.Pitch = BaseRotation.Pitch + RotationRestriction.Pitch;                
            }
            else
            {
                // End:0x403
                if(Rot.Pitch < (BaseRotation.Pitch - RotationRestriction.Pitch))
                {
                    Rot.Pitch = BaseRotation.Pitch - RotationRestriction.Pitch;
                }
            }
            Pawn.SetRotation(Rot);
        }
        //return;        
    }
    stop;    
}

state BlockControlling
{
    function PlayerMove(float DeltaTime)
    {
        local Pawn ControlledObject;
        local bool bMove;

        bMove = false;
        ControlledObject = AdvChessMovableBlock(Pawn);
        // End:0x1E7
        if(ControlledObject != none)
        {
            LastPosition = ControlledObject.Location;
            // End:0xAD
            if(PlayerInput.aForward > 0.0000000)
            {
                MoveUnit = vect(0.0000000, 1.0000000, 0.0000000);
                bMove = true;                
            }
            else
            {
                // End:0xFB
                if(PlayerInput.aForward < 0.0000000)
                {
                    MoveUnit = vect(0.0000000, -1.0000000, 0.0000000);
                    bMove = true;                    
                }
                else
                {
                    // End:0x149
                    if(PlayerInput.aStrafe > 0.0000000)
                    {
                        MoveUnit = vect(-1.0000000, 0.0000000, 0.0000000);
                        bMove = true;                        
                    }
                    else
                    {
                        // End:0x194
                        if(PlayerInput.aStrafe < 0.0000000)
                        {
                            MoveUnit = vect(1.0000000, 0.0000000, 0.0000000);
                            bMove = true;
                        }
                    }
                }
            }
            // End:0x1E7
            if(bMove)
            {
                MoveUnit = MoveUnit * 160.0000000;
                NewPosition = LastPosition + MoveUnit;
                GotoState('BlockMoving');
            }
        }
        //return;        
    }
    stop;    
}

state BlockMoving
{Begin:

    bMoveState = true;
    AdvChessMovableBlock(Pawn).Controller.MoveToDirectNonPathPos(NewPosition,, 0.0000000, true);
    bMoveState = false;
    GotoState('BlockControlling');
    stop;                    
}

state SafeControlling
{
    function PlayerMove(float DeltaTime)
    {
        // End:0xAE
        if(AdvSafeRotator(Pawn) != none)
        {
            AdvSafeRotator(Pawn).Rotate(PlayerInput.aStrafe);
            // End:0xAE
            if(PlayerInput.aForward != 0.0000000)
            {
                AdvSafeRotator(Pawn).CheckSafeValue();
            }
        }
        //return;        
    }
    stop;    
}

state MagPuzzleControlling
{
    function PlayerMove(float DeltaTime)
    {
        // End:0x26
        if(AdvMagPuzzle_base(Pawn) == none)
        {
            GotoState('PlayerWalking');
        }
        // End:0xBF
        if(PlayerInput.bUsingGamepad)
        {
            AdvMagPuzzle_base(Pawn).MoveMagnifyingGlass(PlayerInput.aStrafe * 0.0010000, -PlayerInput.aForward * 0.0010000);            
        }
        else
        {
            AdvMagPuzzle_base(Pawn).MoveMagnifyingGlass(PlayerInput.aMouseX * 0.0010000, -PlayerInput.aMouseY * 0.0030000);
        }
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        // End:0x43
        if(AdvMagPuzzle_base(Pawn) != none)
        {
            AdvMagPuzzle_base(Pawn).bMarkCurrent = true;
        }
        //return;        
    }
    stop;    
}

state PicPuzzleControlling
{
    local AdvPuzzleHudComponent APHC;
    local Vector HitLocation, HitNormal;

    ignores GrenadeThrow, GrenadeRelease, MeleeKick, ToggleQuickMenu;

    event BeginState(name PreviousStateName)
    {
        super(Object).BeginState(PreviousStateName);
        // End:0x42
        if(APHC == none)
        {
            APHC = new (APHC) Class'AdvPuzzleHudComponent';
        }
        APHC.Init(myHUD, "_root.HUD.mc_cursor", false);
        //return;        
    }

    simulated function DrawHUD(HUD H)
    {
        super(AdvPlayerController).DrawHUD(H);
        APHC.DrawHUD(H);
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        // End:0x22E
        if(AdvPicPuzzle_base(Pawn) != none)
        {
            APHC.PlayerMove(DeltaTime, PlayerInput, 0);
            AdvPicPuzzle_base(Pawn).SetTextfield();
            Pawn.Trace(HitLocation, HitNormal, APHC.CursorWorldOrigin + (APHC.CursorWorldDirection * float(100000)), APHC.CursorWorldOrigin + APHC.CursorWorldDirection, true,,, 1);
            // End:0x192
            if(AdvPicPuzzle_base(Pawn).IsOverPiece(HitLocation))
            {
                APHC.Cursor.GotoAndStopI(4);                
            }
            else
            {
                // End:0x1F8
                if(AdvPicPuzzle_base(Pawn).CurrentPiece < 0)
                {
                    APHC.Cursor.GotoAndStopI(2);                    
                }
                else
                {
                    APHC.Cursor.GotoAndStopI(3);
                }
            }
        }
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        // End:0x7B
        if((AdvPicPuzzle_base(Pawn) != none) && !PlayerInput.bUsingGamepad)
        {
            // End:0x7B
            if(int(FireModeNum) == int(0))
            {
                AdvPicPuzzle_base(Pawn).SelectPiece();
            }
        }
        //return;        
    }

    exec function Melee()
    {
        // End:0x8A
        if(PlayerInput.bUsingGamepad)
        {
            // End:0x8A
            if(AdvPicPuzzle_base(Pawn) != none)
            {
                AdvPicPuzzle_base(Pawn).DisSelectPiece();
                AdvPicPuzzle_base(Pawn).LeaveThePuzzle();
            }
        }
        //return;        
    }

    exec function Reload()
    {
        // End:0x63
        if(PlayerInput.bUsingGamepad)
        {
            // End:0x63
            if(AdvPicPuzzle_base(Pawn) != none)
            {
                AdvPicPuzzle_base(Pawn).RotatePiece(false);
            }
        }
        //return;        
    }

    exec function NextWeapon()
    {
        // End:0x41
        if(AdvPicPuzzle_base(Pawn) != none)
        {
            AdvPicPuzzle_base(Pawn).RotatePiece(true);
        }
        //return;        
    }

    exec function PrevWeapon()
    {
        // End:0x41
        if(AdvPicPuzzle_base(Pawn) != none)
        {
            AdvPicPuzzle_base(Pawn).RotatePiece(false);
        }
        //return;        
    }

    exec function Use()
    {
        // End:0x65
        if(PlayerInput.bUsingGamepad)
        {
            // End:0x62
            if(AdvPicPuzzle_base(Pawn) != none)
            {
                AdvPicPuzzle_base(Pawn).SelectPiece();
            }            
        }
        else
        {
            // End:0xCD
            if(AdvPicPuzzle_base(Pawn) != none)
            {
                AdvPicPuzzle_base(Pawn).DisSelectPiece();
                AdvPicPuzzle_base(Pawn).LeaveThePuzzle();
            }
        }
        //return;        
    }

    event EndState(name NextStateName)
    {
        APHC.Cursor.SetVisible(false);
        super(Object).EndState(NextStateName);
        //return;        
    }
    stop;    
}

state JigsawPuzzleControlling
{
    local AdvPuzzleHudComponent APHC;
    local Vector HitLocation, HitNormal;

    ignores NextWeapon, PrevWeapon, GrenadeThrow, GrenadeRelease, MeleeKick, Reload, 
	    ToggleQuickMenu;

    event BeginState(name PreviousStateName)
    {
        // End:0x2F
        if(APHC == none)
        {
            APHC = new (APHC) Class'AdvPuzzleHudComponent';
        }
        APHC.Init(myHUD, "_root.HUD.mc_cursor", false);
        APHC.BoundriesModifier.X = 0.3000000;
        APHC.BoundriesModifier.Y = 0.2000000;
        //return;        
    }

    simulated function DrawHUD(HUD H)
    {
        super(AdvPlayerController).DrawHUD(H);
        APHC.DrawHUD(H);
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        // End:0x1C8
        if(AdvJigsawPuzzle_base(Pawn) != none)
        {
            APHC.PlayerMove(DeltaTime, PlayerInput, 0);
            AdvJigsawPuzzle_base(Pawn).SetTextfield();
            Pawn.Trace(HitLocation, HitNormal, APHC.CursorWorldOrigin + (APHC.CursorWorldDirection * float(100000)), APHC.CursorWorldOrigin + APHC.CursorWorldDirection, true,,, 1);
            // End:0x192
            if(AdvJigsawPuzzle_base(Pawn).IsOverPlate(HitLocation))
            {
                APHC.Cursor.GotoAndStopI(4);                
            }
            else
            {
                APHC.Cursor.GotoAndStopI(2);
            }
        }
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        // End:0xAA
        if(((AdvJigsawPuzzle_base(Pawn) != none) && !AdvJigsawPuzzle_base(Pawn).bIsPlateMoving) && !PlayerInput.bUsingGamepad)
        {
            // End:0xAA
            if(int(FireModeNum) == int(0))
            {
                AdvJigsawPuzzle_base(Pawn).Click();
            }
        }
        //return;        
    }

    exec function Melee()
    {
        // End:0x62
        if(PlayerInput.bUsingGamepad)
        {
            // End:0x62
            if(AdvJigsawPuzzle_base(Pawn) != none)
            {
                AdvJigsawPuzzle_base(Pawn).LeaveThePuzzle();
            }
        }
        //return;        
    }

    exec function Use()
    {
        // End:0x94
        if(PlayerInput.bUsingGamepad)
        {
            // End:0x91
            if((AdvJigsawPuzzle_base(Pawn) != none) && !AdvJigsawPuzzle_base(Pawn).bIsPlateMoving)
            {
                AdvJigsawPuzzle_base(Pawn).Click();
            }            
        }
        else
        {
            // End:0xD4
            if(AdvJigsawPuzzle_base(Pawn) != none)
            {
                AdvJigsawPuzzle_base(Pawn).LeaveThePuzzle();
            }
        }
        //return;        
    }

    event EndState(name NextStateName)
    {
        APHC.Cursor.SetVisible(false);
        super(Object).EndState(NextStateName);
        //return;        
    }
    stop;    
}

state ScalesPuzzleControlling
{
    local AdvPuzzleHudComponent APHC;
    local Actor ActorHit;
    local Vector HitLocation, HitNormal;

    ignores NextWeapon, PrevWeapon, GrenadeThrow, GrenadeRelease, MeleeKick, Reload, 
	    ToggleQuickMenu;

    simulated function DrawHUD(HUD H)
    {
        super(AdvPlayerController).DrawHUD(H);
        APHC.DrawHUD(H);
        //return;        
    }

    event BeginState(name PreviousStateName)
    {
        // End:0x2F
        if(APHC == none)
        {
            APHC = new (APHC) Class'AdvPuzzleHudComponent';
        }
        APHC.Init(myHUD, "_root.HUD.mc_cursor", false);
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        // End:0x3B3
        if(AdvScalesPuzzle_base(Pawn) != none)
        {
            APHC.PlayerMove(DeltaTime, PlayerInput, 0);
            AdvScalesPuzzle_base(Pawn).SetTextfield();
            // End:0x17C
            if(AdvScalesPuzzle_base(Pawn).CurrentCoin < 0)
            {
                ActorHit = Pawn.Trace(HitLocation, HitNormal, APHC.CursorWorldOrigin + (APHC.CursorWorldDirection * float(100000)), APHC.CursorWorldOrigin + APHC.CursorWorldDirection, true, APHC.Extent,, 1);                
            }
            else
            {
                ActorHit = AdvScalesPuzzle_base(Pawn).User.Trace(HitLocation, HitNormal, APHC.CursorWorldOrigin + (APHC.CursorWorldDirection * float(100000)), APHC.CursorWorldOrigin + (APHC.CursorWorldDirection * float(36)), true,,, 1);
            }
            // End:0x317
            if(AdvScalesPuzzle_base(Pawn).CursorMove(APHC.CursorWorldOrigin + (APHC.CursorWorldDirection * float(35)), HitLocation, ActorHit))
            {
                APHC.Cursor.GotoAndStopI(4);                
            }
            else
            {
                // End:0x37D
                if(AdvScalesPuzzle_base(Pawn).CurrentCoin < 0)
                {
                    APHC.Cursor.GotoAndStopI(2);                    
                }
                else
                {
                    APHC.Cursor.GotoAndStopI(3);
                }
            }
        }
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        // End:0xBA
        if(AdvScalesPuzzle_base(Pawn) != none)
        {
            // End:0x92
            if(int(FireModeNum) == int(0))
            {
                // End:0x8F
                if((ActorHit != none) && ActorHit != WorldInfo)
                {
                    AdvScalesPuzzle_base(Pawn).Click(ActorHit, HitLocation);
                }                
            }
            else
            {
                AdvScalesPuzzle_base(Pawn).ReturnCoin();
            }
        }
        //return;        
    }

    exec function Melee()
    {
        // End:0x2C
        if(PlayerInput.bUsingGamepad)
        {
            Leave();
        }
        //return;        
    }

    exec function Use()
    {
        // End:0x31
        if(PlayerInput.bUsingGamepad)
        {
            StartFire(0);            
        }
        else
        {
            Leave();
        }
        //return;        
    }

    function Leave()
    {
        // End:0x98
        if(AdvScalesPuzzle_base(Pawn) != none)
        {
            // End:0x70
            if(AdvScalesPuzzle_base(Pawn).CurrentCoin < 0)
            {
                AdvScalesPuzzle_base(Pawn).CheckEndPuzzle();                
            }
            else
            {
                AdvScalesPuzzle_base(Pawn).ReturnCoin();
            }
        }
        //return;        
    }

    event EndState(name NextStateName)
    {
        APHC.Cursor.SetVisible(false);
        super(Object).EndState(NextStateName);
        //return;        
    }
    stop;    
}

state ConsoleObjectPuzzleControlling
{
    local AdvPuzzleHudComponent APHC;
    local Actor ActorHit;
    local Vector HitLocation, HitNormal;

    ignores NextWeapon, PrevWeapon, GrenadeThrow, GrenadeRelease, MeleeKick, Reload, 
	    ToggleQuickMenu;

    simulated function DrawHUD(HUD H)
    {
        super(AdvPlayerController).DrawHUD(H);
        APHC.DrawHUD(H);
        //return;        
    }

    event BeginState(name PreviousStateName)
    {
        // End:0x2F
        if(APHC == none)
        {
            APHC = new (APHC) Class'AdvPuzzleHudComponent';
        }
        APHC.Init(myHUD, "_root.HUD.mc_cursor", false);
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        // End:0x1AA
        if(AdvConsoleObject_base(Pawn) != none)
        {
            APHC.PlayerMove(DeltaTime, PlayerInput, 0);
            ActorHit = Pawn.Trace(HitLocation, HitNormal, APHC.CursorWorldOrigin + (APHC.CursorWorldDirection * float(100000)), APHC.CursorWorldOrigin + APHC.CursorWorldDirection, true,,, 1);
            // End:0x174
            if(AdvConsoleObject_base(Pawn).OverButton(ActorHit))
            {
                APHC.Cursor.GotoAndStopI(4);                
            }
            else
            {
                APHC.Cursor.GotoAndStopI(2);
            }
        }
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        // End:0x86
        if(AdvConsoleObject_base(Pawn) != none)
        {
            // End:0x86
            if(int(FireModeNum) == int(0))
            {
                // End:0x86
                if((ActorHit != none) && ActorHit != WorldInfo)
                {
                    AdvConsoleObject_base(Pawn).ButtonClick(ActorHit);
                }
            }
        }
        //return;        
    }

    exec function StopFire(optional byte FireModeNum)
    {
        // End:0x55
        if(AdvConsoleObject_base(Pawn) != none)
        {
            // End:0x55
            if(int(FireModeNum) == int(0))
            {
                AdvConsoleObject_base(Pawn).ButtonUnclick();
            }
        }
        //return;        
    }

    exec function Melee()
    {
        // End:0x40
        if(AdvConsoleObject_base(Pawn) != none)
        {
            AdvConsoleObject_base(Pawn).LeaveThePuzzle();
        }
        //return;        
    }

    exec function Use()
    {
        // End:0x40
        if(AdvConsoleObject_base(Pawn) != none)
        {
            AdvConsoleObject_base(Pawn).LeaveThePuzzle();
        }
        //return;        
    }

    event EndState(name NextStateName)
    {
        APHC.Cursor.SetVisible(false);
        super(Object).EndState(NextStateName);
        //return;        
    }
    stop;    
}

state PlayerSlide
{
    local Vector newAccel, AirAccel, X, Y, Z;

    local CameraShake Shake;
    local Vector CurrentV, AddV, CurrentVnormal;
    local float CurrentSpeed, MaxSpeed;
    local Actor HitActor;
    local Vector HitLocation, HitNormalS, pawnOffset;
    local float Rate, BlendInTime, BlendOutTime;
    local AdvPlayerPawn SlidingPawn;
    local editinline AudioComponent JumpingSound, SlidingSound;
    local SoundCue SlideSound, LandSound;
    local bool bJumpedOffEdge;
    local float MoveInfluenceFactor;
    local Rotator ClampedPlayerViewRot;
    local int SavedViewPitchMax, SavedViewPitchMin, SlideSlopeEnd;
    local RadialBlurActor RadialBlur;
    local float FocusAlpha;
    local GFxObject TextField, TextFieldBG;
    local string HintString;
    local bool bLastUsingGamepad;

    ignores StartFire, NextWeapon, PrevWeapon, GrenadeThrow, GrenadeRelease, Melee, 
	    MeleeKick, Reload;

    event BeginState(name PreviousStateName)
    {
        local FOscillator FOsc;

        super(Object).BeginState(PreviousStateName);
        HideWeapons();
        MoveInfluenceFactor = SlidingVelocity;
        SlideSlopeEnd = SlidingRotation.Roll;
        CurrentSpeed = float(SlidingRotation.Pitch);
        MaxSpeed = CurrentSpeed * float(3);
        SlidingVelocity = CurrentSpeed;
        pawnOffset.X = 0.0000000;
        pawnOffset.Y = 0.0000000;
        pawnOffset.Z = Pawn.BaseEyeHeight * float(3);
        Shake = new (Shake) Class'Engine.CameraShake';
        Shake.OscillationDuration = 1.0000000;
        Shake.OscillationBlendInTime = 0.1000000;
        Shake.OscillationBlendOutTime = 0.2000000;
        FOsc.Amplitude = 80.0000000;
        FOsc.Frequency = 40.0000000;
        Shake.RotOscillation.Pitch = FOsc;
        FOsc.Amplitude = 50.0000000;
        FOsc.Frequency = 15.0000000;
        Shake.RotOscillation.Yaw = FOsc;
        FOsc.Amplitude = 80.0000000;
        FOsc.Frequency = 30.0000000;
        Shake.RotOscillation.Roll = FOsc;
        SlidingPawn = AdvPlayerPawn(Pawn);
        Rate = 1.0000000;
        BlendInTime = 0.2000000;
        BlendOutTime = 0.2000000;
        SlideSound = none;
        LandSound = SoundCue'a_AztecMummy_CUE.Movement.a_MummyJump_01';
        bJumpedOffEdge = false;
        SlidingPawn.FullBodyAnimSlot.PlayCustomAnim('Slide_Fly', Rate, BlendInTime, BlendOutTime,, false);
        SlidingPawn.SlideCamXoffset = 0.0000000;
        SlidingPawn.SlideCamZoffset = 0.0000000;
        SlidingPawn.GotoState('SlideBendForward');
        JumpingSound = CreateAudioComponent(SoundCue'a_PlayerMovement.Clothes.a_JumpStart');
        JumpingSound.VolumeMultiplier = 5.0000000;
        SlidingSound = CreateAudioComponent(SoundCue'a_GameplaySounds.Sliding.a_SlideStone');
        SlidingSound.VolumeMultiplier = 1.5000000;
        SlidingPawn.AttachComponent(SlidingSound);
        SlidingPawn.AttachComponent(JumpingSound);
        ShowPlayerMaterials(true);
        SlidingPawn.ShowMaterialSectionOnAllLods(0, false);
        SlidingPawn.ShowMaterialSectionOnAllLods(1, false);
        SlidingPawn.ShowMaterialSectionOnAllLods(2, false);
        SavedViewPitchMax = int(Pawn.ViewPitchMax);
        SavedViewPitchMin = int(Pawn.ViewPitchMin);
        Pawn.ViewPitchMax = 12740.0000000;
        Pawn.ViewPitchMin = -11340.0000000;
        // End:0x7B8
        if(RadialBlur == none)
        {
            RadialBlur = Spawn(Class'Engine.RadialBlurActor', Pawn);
            RadialBlur.RadialBlur.SetEnabled(false);
            RadialBlur.DetachComponent(RadialBlur.RadialBlur);
            RadialBlur.RadialBlur = new (RadialBlur) Class'Engine.RadialBlurComponent' (RadialBlurComponent'ar_FlashLight.ar_RadialBlurComponent');
            RadialBlur.AttachComponent(RadialBlur.RadialBlur);
            RadialBlur.RadialBlur.SetBlurScale(0.0000000);
        }
        RadialBlur.RadialBlur.SetEnabled(true);
        // End:0x966
        if(TextField != AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.TreasureTipMC_g.textField"))
        {
            TextField = AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.TreasureTipMC_g.textField");
            TextFieldBG = AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.bg");
        }
        TextFieldBG.GotoAndStop("show");
        SetTextfield();
        //return;        
    }

    event EndState(name NextStateName)
    {
        local Rotator tmpRot;

        super(Object).EndState(NextStateName);
        TextFieldBG.GotoAndStop("hide");
        TextField.SetString("htmlText", "");
        RestoreWeapons();
        SlidingPawn.ShowMaterialSectionOnAllLods(0, true);
        SlidingPawn.ShowMaterialSectionOnAllLods(1, true);
        SlidingPawn.ShowMaterialSectionOnAllLods(2, true);
        ShowPlayerMaterials(false);
        Pawn.ViewPitchMax = float(SavedViewPitchMax);
        Pawn.ViewPitchMin = float(SavedViewPitchMin);
        SlidingPawn.SlideCamXoffset = 0.0000000;
        SlidingPawn.SlideCamZoffset = 0.0000000;
        JumpingSound.DetachFromAny();
        JumpingSound.bAutoDestroy = true;
        JumpingSound.Stop();
        SlidingSound.DetachFromAny();
        SlidingSound.bAutoDestroy = true;
        SlidingSound.Stop();
        SlidingPawn.GotoState('Auto');
        tmpRot = self.Rotation;
        tmpRot.Roll = 0;
        tmpRot.Pitch = 0;
        SlidingPawn.GetSkeletalMeshComponent().SetRotation(tmpRot);
        // End:0x31B
        if(RadialBlur != none)
        {
            RadialBlur.Destroy();
        }
        //return;        
    }

    function SetTextfield()
    {
        HintString = "\n";        
        HintString @= "\n";        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("LocalizedCenterMessages", "WalkTutorial", "ADVGame"), self));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("LocalizedCenterMessages", "LookTutorial", "ADVGame"), self));
        TextField.SetBool("html", true);
        TextField.SetString("htmlText", HintString);
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        // End:0x20
        if(Pawn == none)
        {
            GotoState('Dead');            
        }
        else
        {
            // End:0x470
            if(!SlidingPawn.IsJumping())
            {
                AddV = Pawn.Floor;
                // End:0x45D
                if(Abs(float(Rotator(AddV).Pitch)) < float(SlideSlopeEnd))
                {
                    // End:0x2A1
                    if((SlidingPawn.FullBodyAnimSlot.GetPlayedAnimation() != 'Slide_Fly') && !bJumpedOffEdge)
                    {
                        // End:0x13B
                        if(!SlidingPawn.IsInState('SlideBendBackward'))
                        {
                            SlidingPawn.GotoState('SlideBendBackward');
                        }
                        // End:0x1C0
                        if(PlayerInput.aStrafe > float(0))
                        {
                            SlidingPawn.FullBodyAnimSlot.PlayCustomAnim('Slide_TurnRight', Rate, BlendInTime, BlendOutTime,, false);                            
                        }
                        else
                        {
                            // End:0x245
                            if(PlayerInput.aStrafe < float(0))
                            {
                                SlidingPawn.FullBodyAnimSlot.PlayCustomAnim('Slide_TurnLeft', Rate, BlendInTime, BlendOutTime,, false);                                
                            }
                            else
                            {
                                SlidingPawn.FullBodyAnimSlot.PlayCustomAnim('Slide_Idle', Rate, BlendInTime, BlendOutTime,, false);
                            }
                        }
                    }
                    CurrentV += ((AddV * float(20)) * DeltaTime);
                    CurrentSpeed = VSize(CurrentV);
                    CurrentVnormal = Normal(CurrentV);
                    // End:0x31A
                    if(CurrentSpeed < SlidingVelocity)
                    {
                        CurrentSpeed = SlidingVelocity;
                    }
                    // End:0x344
                    if(CurrentSpeed > MaxSpeed)
                    {
                        CurrentSpeed = MaxSpeed;
                    }
                    SlidingSound.VolumeMultiplier = 0.5000000 + (CurrentSpeed / MaxSpeed);
                    newAccel = (SlidingVelocity * CurrentSpeed) * CurrentVnormal;
                    AirAccel = newAccel;
                    newAccel.Z -= ((float(2) * SlidingVelocity) * CurrentSpeed);
                    AirAccel.Z -= ((1.1000000 * SlidingVelocity) * CurrentSpeed);
                    PlayerCamera.PlayCameraShake(Shake, 0.7000000);                    
                }
                else
                {
                    super(PlayerController).PlayerMove(DeltaTime);
                }
            }
        }
        //return;        
    }

    event Landed(Vector HitNormal, Actor FloorActor)
    {
        super(EvilPlayerController).Landed(HitNormal, FloorActor);
        //return;        
    }

    event PlayerTick(float DeltaTime)
    {
        local Rotator OldRotation, meshOffset, tmpRotYaw;
        local Actor.EDoubleClickDir DoubleClickMove;

        global.PlayerTick(DeltaTime);
        GetAxes(Rotator(CurrentVnormal), X, Y, Z);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime);
        // End:0x26D
        if(((CurrentV.X != float(0)) || CurrentV.Y != float(0)) || CurrentV.Z != float(0))
        {
            ClampedPlayerViewRot = Pawn.GetViewRotation();
            tmpRotYaw = ClampedPlayerViewRot;
            ClampRotation(tmpRotYaw, Rotator(CurrentVnormal), rot(0, 8190, 0), rot(0, 8190, 0));
            ClampedPlayerViewRot.Yaw = tmpRotYaw.Yaw;
            Pawn.SetViewRotation(ClampedPlayerViewRot);
            meshOffset.Yaw = -ClampedPlayerViewRot.Yaw;
            meshOffset.Pitch = -16380;
            meshOffset.Roll = 0;
            SlidingPawn.GetSkeletalMeshComponent().SetRotation(Rotator(CurrentVnormal) + meshOffset);
        }
        HitActor = Trace(HitLocation, HitNormalS, Pawn.Location - pawnOffset, Pawn.Location, true,,, 1);
        // End:0x529
        if(HitActor == none)
        {
            newAccel = AirAccel;
            // End:0x43E
            if(!bJumpedOffEdge)
            {
                // End:0x349
                if(SlidingSound.IsPlaying())
                {
                    SlidingSound.Stop();
                }
                // End:0x38C
                if(!JumpingSound.IsPlaying())
                {
                    JumpingSound.Play();
                }
                bJumpedOffEdge = true;
                // End:0x3E2
                if(!SlidingPawn.IsInState('SlideBendForward'))
                {
                    SlidingPawn.GotoState('SlideBendForward');
                }
                SlidingPawn.FullBodyAnimSlot.PlayCustomAnim('Slide_Idle2Fly', Rate, BlendInTime, BlendOutTime,, false);
            }
            // End:0x526
            if(SlidingPawn.FullBodyAnimSlot.GetPlayedAnimation() != 'Slide_Idle2Fly')
            {
                // End:0x4CA
                if(!SlidingPawn.IsInState('SlideBendForward'))
                {
                    SlidingPawn.GotoState('SlideBendForward');
                }
                SlidingPawn.FullBodyAnimSlot.PlayCustomAnim('Slide_Fly', Rate, BlendInTime, BlendOutTime,, false);
            }            
        }
        else
        {
            DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
            // End:0x642
            if(int(Role) < int(ROLE_Authority))
            {
                ReplicateMove(DeltaTime, ((Pawn.AccelRate * Normal(Y * PlayerInput.aStrafe)) * Normal(X * PlayerInput.aForward)) / float(4), DoubleClickMove, OldRotation - Rotation);                
            }
            else
            {
                ProcessMove(DeltaTime, ((Pawn.AccelRate * Normal(Y * PlayerInput.aStrafe)) * Normal(X * PlayerInput.aForward)) / float(4), DoubleClickMove, OldRotation - Rotation);
            }
            // End:0x723
            if(bJumpedOffEdge)
            {
                PlaySound(LandSound, false, true,,, true);
                bJumpedOffEdge = false;
            }
            // End:0x770
            if(!SlidingSound.IsPlaying())
            {
                SlidingSound.FadeIn(0.2000000, 1.0000000);
            }
        }
        Pawn.MoveSmooth((newAccel + ((Pawn.AccelRate * Normal(Y * PlayerInput.aStrafe)) * MoveInfluenceFactor)) * DeltaTime);
        Pawn.Acceleration += newAccel;
        PawnLastPos = Pawn.Location;
        FocusAlpha = 0.7000000 + (CurrentSpeed / MaxSpeed);
        // End:0x9E4
        if(RadialBlur != none)
        {
            // End:0x906
            if(RadialBlur.RadialBlur.bEnabled != (FocusAlpha > 0.0000000))
            {
                RadialBlur.RadialBlur.SetEnabled(FocusAlpha > 0.0000000);
            }
            // End:0x9E4
            if(RadialBlur.RadialBlur.bEnabled)
            {
                RadialBlur.SetLocation(Pawn.Location + (Vector(ClampedPlayerViewRot) * 20.0000000));
                RadialBlur.RadialBlur.SetBlurScale(FocusAlpha * RadialBlurComponent'ar_FlashLight.ar_RadialBlurComponent'.BlurScale);
            }
        }
        // End:0xB67
        if(TextField != AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.TreasureTipMC_g.textField"))
        {
            TextField = AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.TreasureTipMC_g.textField");
            TextFieldBG = AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.bg");
            SetTextfield();
        }
        // End:0xBC9
        if(bLastUsingGamepad != PlayerInput.bUsingGamepad)
        {
            bLastUsingGamepad = PlayerInput.bUsingGamepad;
            SetTextfield();
        }
        //return;        
    }

    function bool isPlayerSliding()
    {
        return true;
        //return ReturnValue;        
    }

    exec function ToggleQuickMenu(optional AdvTypes.EInventoryItem SelectedIndex, optional bool bFromQuickMenu = false)
    {
        // End:0x37
        if(int(SelectedIndex) == int(0))
        {
            global.ToggleQuickMenu(SelectedIndex, bFromQuickMenu);
        }
        return;
        //return;        
    }
    stop;    
}

state PlayerDriving
{
    unreliable server function ServerUse()
    {
        local Vehicle CurrentVehicle;

        // End:0x60
        if(!PlayerInput.bUsingGamepad)
        {
            CurrentVehicle = Vehicle(Pawn);
            CurrentVehicle.DriverLeave(false);
        }
        //return;        
    }
    stop;    
}

state Vaulting
{
    simulated function BeginState(name PreviousStateName)
    {
        local BoxSphereBounds VolumeBounds;
        local float FallingGravity, JumpDist;

        VolumeBounds = AdvPawn(Pawn).CurrentWalkableObstacle.BrushComponent.Bounds;
        FallingGravity = Abs(2.0000000 * Pawn.GetGravityZ());
        JumpDist = 2.0000000 * VolumeBounds.BoxExtent.Z;
        Pawn.DoJump(bUpdating);
        Pawn.Velocity.Z = Sqrt((2.0000000 * FallingGravity) * JumpDist);
        SetTimer((0.9000000 * Pawn.Velocity.Z) / FallingGravity, false, 'Grounded');
        //return;        
    }

    function Grounded()
    {
        Pawn.Velocity += (Vector(Rotation) * float(150));
        GotoState('PlayerWalking');
        //return;        
    }
Begin:

    Sleep(0.1000000);
    goto 'Begin';
    stop;        
}

state DefaultFOVOverride extends PlayerWalking
{
    local float OriginalDefaultFOV;
    local bool bOverrideFOVReached;

    event PushedState()
    {
        super(Object).PushedState();
        OriginalDefaultFOV = DefaultFOV;
        DefaultFOV = OverrideFOV;
        StartZoom(OverrideFOV, OverrideFOVRate);
        bOverrideFOVReached = false;
        //return;        
    }

    event PoppedState()
    {
        super(Object).PoppedState();
        DefaultFOV = OriginalDefaultFOV;
        StartZoom(DefaultFOV, OverrideFOVRate);
        //return;        
    }

    simulated function StopZoom()
    {
        // End:0x3F
        if(!bOverrideFOVReached)
        {
            bOverrideFOVReached = FOVAngle == FocusFOV;
            // End:0x3F
            if(!bOverrideFOVReached)
            {
                return;
            }
        }
        global.StopZoom();
        //return;        
    }

    simulated function EndZoom()
    {
        // End:0x3F
        if(!bOverrideFOVReached)
        {
            bOverrideFOVReached = FOVAngle == FocusFOV;
            // End:0x3F
            if(!bOverrideFOVReached)
            {
                return;
            }
        }
        global.EndZoom();
        //return;        
    }
    stop;    
}

state ButtonTracing extends DefaultFOVOverride
{
    local AdvPuzzleHudComponent APHC;
    local Actor ActorHit;
    local Vector HitLocation, HitNormal, projStart, TraceEnd;
    local Rotator CameraRot;
    local bool bBlockFire;
    local AdvConsoleObject_base ACO;
    local float HideTime;
    local GFxObject TextField, TextFieldBG;
    local string HintString;
    local bool bLastUsingGamepad;

    simulated function DrawHUD(HUD H)
    {
        super(AdvPlayerController).DrawHUD(H);
        APHC.DrawHUD(H);
        //return;        
    }

    event BeginState(name PreviousStateName)
    {
        // End:0x2F
        if(APHC == none)
        {
            APHC = new (APHC) Class'AdvPuzzleHudComponent';
        }
        APHC.Init(myHUD, "_root.HUD.mc_cursor", true);
        bBlockFire = false;
        HideTime = 0.1000000;
        // End:0x201
        if(TextField != AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.TreasureTipMC_g.textField"))
        {
            TextField = AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.TreasureTipMC_g.textField");
            TextFieldBG = AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.bg");
        }
        TextFieldBG.GotoAndStop("show");
        SetTextfield();
        //return;        
    }

    function SetTextfield()
    {
        // End:0xFE
        if(IsPCGamepadMode())
        {
            HintString = "\n";            
            HintString @= "\n";            
            HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "ConsoleMove", "EvilGame"), self));            
            HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "ConsoleUse", "EvilGame"), self));            
        }
        else
        {
            HintString = "\n";            
            HintString @= "\n";            
            HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "ConsoleMove", "EvilGame"), self));            
            HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "ConsoleUse_PC", "EvilGame"), self));
        }
        TextField.SetBool("html", true);
        TextField.SetString("htmlText", HintString);
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        super(PlayerWalking).PlayerMove(DeltaTime);
        APHC.PlayerMove(DeltaTime, PlayerInput, 0);
        //return;        
    }

    event PlayerTick(float DeltaTime)
    {
        global.PlayerTick(DeltaTime);
        // End:0x196
        if(TextField != AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.TreasureTipMC_g.textField"))
        {
            TextField = AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.TreasureTipMC_g.textField");
            TextFieldBG = AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.bg");
            SetTextfield();
        }
        // End:0x1F8
        if(bLastUsingGamepad != PlayerInput.bUsingGamepad)
        {
            bLastUsingGamepad = PlayerInput.bUsingGamepad;
            SetTextfield();
        }
        GetPlayerViewPoint(projStart, CameraRot);
        TraceEnd = projStart + (Normal(Vector(CameraRot)) * 200.0000000);
        ActorHit = Pawn.Trace(HitLocation, HitNormal, TraceEnd, projStart, true, APHC.Extent,, 1);
        // End:0x2FF
        if(AdvConsoleObject_base(ActorHit) != none)
        {
            APHC.Cursor.GotoAndStopI(2);
            HideWeapons();            
        }
        else
        {
            // End:0x35A
            if(AdvConsoleObjectButton_base(ActorHit) != none)
            {
                APHC.Cursor.GotoAndStopI(4);
                HideWeapons();                
            }
            else
            {
                RestoreWeapons();
            }
        }
        //return;        
    }

    function HideWeapons()
    {
        APHC.Cursor.SetVisible(true);
        // End:0x176
        if(AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeapon()) != none)
        {
            AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeapon()).bDisplayCrosshair = false;
            // End:0x176
            if(!AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeapon()).IsInState('QuickHide'))
            {
                AdvPlayerPawn(Pawn).QuickHideCurrentWeapon(false, HideTime * float(3), true);
                AdvPlayerPawn(Pawn).QuickHideCurrentWeapon(false, HideTime * float(3), false);
            }
        }
        bBlockFire = true;
        //return;        
    }

    function RestoreWeapons()
    {
        APHC.Cursor.SetVisible(false);
        // End:0x168
        if(AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeapon()) != none)
        {
            AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeapon()).bDisplayCrosshair = true;
            // End:0x168
            if(AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeapon()).IsInState('QuickHide'))
            {
                AdvPlayerPawn(Pawn).EndQuickHideCurrentWeapon(false, HideTime, true);
                AdvPlayerPawn(Pawn).EndQuickHideCurrentWeapon(false, HideTime, false);
            }
        }
        bBlockFire = false;
        // End:0x1AD
        if(ACO != none)
        {
            ACO.ButtonUnclick();
            ACO = none;
        }
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        // End:0x26
        if(!bBlockFire)
        {
            super(EvilPlayerController).StartFire(FireModeNum);            
        }
        else
        {
            // End:0xD3
            if(((int(FireModeNum) == int(0)) && AdvConsoleObjectButton_base(ActorHit) != none) && !PlayerInput.bUsingGamepad)
            {
                ACO = AdvConsoleObjectButton_base(ActorHit).ParentConsole;
                ACO.ButtonClick(ActorHit);
            }
        }
        //return;        
    }

    exec function StopFire(optional byte FireModeNum)
    {
        super(PlayerController).StopFire(FireModeNum);
        // End:0x43
        if((int(FireModeNum) == int(0)) && ACO != none)
        {
            ReleaseButton();
        }
        //return;        
    }

    function ReleaseButton()
    {
        // End:0x39
        if(ACO != none)
        {
            ACO.ButtonUnclick();
            ACO = none;
        }
        //return;        
    }

    exec function Use()
    {
        // End:0xA3
        if(PlayerInput.bUsingGamepad)
        {
            // End:0x96
            if(AdvConsoleObjectButton_base(ActorHit) != none)
            {
                ACO = AdvConsoleObjectButton_base(ActorHit).ParentConsole;
                ACO.ButtonClick(ActorHit);                
            }
            else
            {
                super(UTPlayerController).Use();
            }            
        }
        else
        {
            super(UTPlayerController).Use();
        }
        //return;        
    }

    exec function Input_A_Released()
    {
        // End:0x19
        if(ACO != none)
        {
            ReleaseButton();
        }
        //return;        
    }

    event EndState(name NextStateName)
    {
        APHC.Cursor.SetVisible(false);
        AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeapon()).ClearTimer('DoneQuickHide');
        // End:0x105
        if(AdvPlayerPawn(Pawn).GetWeaponLeft() != none)
        {
            AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeaponLeft()).ClearTimer('DoneQuickHide');
        }
        RestoreWeapons();
        TextFieldBG.GotoAndStop("hide");
        TextField.SetString("htmlText", "");
        super(PlayerWalking).EndState(NextStateName);
        //return;        
    }

    function bool IsThereOtherReasonToLetUseHold()
    {
        local bool Result;

        Result = global.IsThereOtherReasonToLetUseHold();
        // End:0x39
        if(AdvConsoleObjectButton_base(ActorHit) != none)
        {
            Result = true;
        }
        return Result;
        //return ReturnValue;        
    }
    stop;    
}

state NotepadFocus extends DefaultFOVOverride
{
    event PushedState()
    {
        OverrideFOV = FocusFOV;
        OverrideFOVRate = FocusFOVRate;
        super.PushedState();
        // End:0x162
        if(!bCinematicMode)
        {
            // End:0x76
            if(int(GetPuzzleDifficultyLevel()) <= int(FocusMaxDifficultyLevel))
            {
                IterateOverFocusHighligths(EnableHighlights);
            }
            // End:0x162
            if(IsLocalPlayerController())
            {
                AdvPostProcessManager(GetPPManager()).EnableVignette(true, FocusVignetteScale);
                // End:0x162
                if(int(GetPuzzleDifficultyLevel()) <= int(FocusMaxDifficultyLevel))
                {
                    AdvPostProcessManager(GetPPManager()).EnableSelectiveDesaturation(true, FocusSelDesatExceptionColor, MakeLinearColor(FocusSelDesatThresholds.X, FocusSelDesatThresholds.Y, FocusSelDesatScale, 1.0000000 - FocusSelDesatScale));
                }
            }
        }
        //return;        
    }

    event PoppedState()
    {
        super.PoppedState();
        // End:0x41
        if(int(GetPuzzleDifficultyLevel()) <= int(FocusMaxDifficultyLevel))
        {
            IterateOverFocusHighligths(DisableHighlights);
        }
        // End:0xCB
        if(IsLocalPlayerController())
        {
            AdvPostProcessManager(GetPPManager()).EnableVignette(false, FocusVignetteScale);
            // End:0xCB
            if(int(GetPuzzleDifficultyLevel()) <= int(FocusMaxDifficultyLevel))
            {
                AdvPostProcessManager(GetPPManager()).EnableSelectiveDesaturation(false);
            }
        }
        //return;        
    }

    function NotifyChangedWeapon(Weapon PreviousWeapon, Weapon NewWeapon)
    {
        // End:0x65
        if((NewWeapon == MyEvilPawn.WeaponLeft) && NewWeapon.Class != NotepadFocusTriggerItemClass)
        {
            PopState();
        }
        global.NotifyChangedWeapon(PreviousWeapon, NewWeapon);
        //return;        
    }

    function SetCinematicMode(bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons)
    {
        global.SetCinematicMode(bInCinematicMode, bHidePlayer, bAffectsHUD, bAffectsMovement, bAffectsTurning, bAffectsButtons);
        // End:0x8D
        if(int(GetPuzzleDifficultyLevel()) <= int(FocusMaxDifficultyLevel))
        {
            IterateOverFocusHighligths(((bCinematicMode) ?  : ));
        }
        // End:0x19E
        if(LocalPlayer(Player) != none)
        {
            AdvPostProcessManager(GetPPManager()).EnableVignette(!bCinematicMode, FocusVignetteScale, 0.0000000);
            // End:0x19E
            if(int(GetPuzzleDifficultyLevel()) <= int(FocusMaxDifficultyLevel))
            {
                AdvPostProcessManager(GetPPManager()).EnableSelectiveDesaturation(!bCinematicMode, FocusSelDesatExceptionColor, MakeLinearColor(FocusSelDesatThresholds.X, FocusSelDesatThresholds.Y, FocusSelDesatScale, 1.0000000 - FocusSelDesatScale), false);
            }
        }
        //return;        
    }
    stop;    
}

state FlashlightFocus extends DefaultFOVOverride
{
    event PushedState()
    {
        local AdvPlayerPawn P;

        P = AdvPlayerPawn(MyEvilPawn);
        OverrideFOV = P.MyTorch.ZoomedTargetFOV;
        OverrideFOVRate = P.MyTorch.ZoomedRate;
        super.PushedState();
        //return;        
    }
    stop;    
}

auto state PlayerWaiting
{
    ignores SwitchWeapon;

    simulated event FellOutOfWorld(class<DamageType> dmgType)
    {
        bCameraOutOfWorld = true;
        //return;        
    }

    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        local Vector OldLocation;

        OldLocation = Location;
        super(BaseSpectating).ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        // End:0x66
        if(bCameraOutOfWorld)
        {
            bCameraOutOfWorld = false;
            SetLocation(OldLocation);
        }
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        ServerRestartPlayer();
        //return;        
    }

    reliable server function ServerRestartPlayer()
    {
        super.ServerRestartPlayer();
        // End:0x102
        if((WorldInfo.Game.bWaitingToStartMatch && EvilGame(WorldInfo.Game).bWarmupRound) && float(EvilGame(WorldInfo.Game).WarmupTime) > 1.0000000)
        {
            WorldInfo.Game.RestartPlayer(self);
        }
        //return;        
    }
    stop;    
}

state PlayerWalking
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x55
        if(AdvPRI(PlayerReplicationInfo) != none)
        {
            AdvPRI(PlayerReplicationInfo).bIsAlive = true;
        }
        //return;        
    }
    stop;    
}

state Dead
{
    function BeginState(name PreviousStateName)
    {
        // End:0x42
        if(AdvPRI(PlayerReplicationInfo) != none)
        {
            AdvPRI(PlayerReplicationInfo).bIsAlive = false;
        }
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

state FlashlightOffsetEditor
{
    ignores ToggleQuickMenu, MeleeKick, Melee, NextWeapon, GrenadeThrow, GrenadeRelease, 
	    TryPOILookAway;

    function PlayerMove(float DeltaTime)
    {
        local AdvWeap_Base Weap;
        local AdvWeap_3PhaseReload_Base Weap3PR;
        local bool bZooming;

        // End:0x61
        if(AdvInventoryItem_Torch(MyEvilPawn.WeaponLeft) != none)
        {
            Weap = AdvWeap_Base(MyEvilPawn.WeaponLeft);            
        }
        else
        {
            Weap = AdvWeap_Base(MyEvilPawn.Weapon);
        }
        // End:0xE3
        if(Weap == none)
        {
            Weap3PR = AdvWeap_3PhaseReload_Base(MyEvilPawn.Weapon);
            // End:0xE3
            if(Weap3PR == none)
            {
                return;
            }
        }
        bZooming = int(EvilWeap_Base(MyEvilPawn.Weapon).GetZoomedState()) == int(3);
        // End:0x297
        if(PlayerInput.aBaseY >= 0.3000000)
        {
            // End:0x201
            if(bZooming)
            {
                // End:0x1BC
                if(Weap != none)
                {
                    Weap.FlashlightAimingSpotlightOffset.Z += (DeltaTime * float(2));                    
                }
                else
                {
                    Weap3PR.FlashlightAimingSpotlightOffset.Z += (DeltaTime * float(2));
                }                
            }
            else
            {
                // End:0x255
                if(Weap != none)
                {
                    Weap.FlashlightBaseSpotlightOffset.Z += (DeltaTime * float(2));                    
                }
                else
                {
                    Weap3PR.FlashlightBaseSpotlightOffset.Z += (DeltaTime * float(2));
                }
            }
        }
        // End:0x3FB
        if(PlayerInput.aBaseY <= -0.3000000)
        {
            // End:0x365
            if(bZooming)
            {
                // End:0x320
                if(Weap != none)
                {
                    Weap.FlashlightAimingSpotlightOffset.Z -= (DeltaTime * float(2));                    
                }
                else
                {
                    Weap3PR.FlashlightAimingSpotlightOffset.Z -= (DeltaTime * float(2));
                }                
            }
            else
            {
                // End:0x3B9
                if(Weap != none)
                {
                    Weap.FlashlightBaseSpotlightOffset.Z -= (DeltaTime * float(2));                    
                }
                else
                {
                    Weap3PR.FlashlightBaseSpotlightOffset.Z -= (DeltaTime * float(2));
                }
            }
        }
        // End:0x55F
        if(PlayerInput.aStrafe <= -0.3000000)
        {
            // End:0x4C9
            if(bZooming)
            {
                // End:0x484
                if(Weap != none)
                {
                    Weap.FlashlightAimingSpotlightOffset.Y -= (DeltaTime * float(2));                    
                }
                else
                {
                    Weap3PR.FlashlightAimingSpotlightOffset.Y -= (DeltaTime * float(2));
                }                
            }
            else
            {
                // End:0x51D
                if(Weap != none)
                {
                    Weap.FlashlightBaseSpotlightOffset.Y -= (DeltaTime * float(2));                    
                }
                else
                {
                    Weap3PR.FlashlightBaseSpotlightOffset.Y -= (DeltaTime * float(2));
                }
            }
        }
        // End:0x6C3
        if(PlayerInput.aStrafe >= 0.3000000)
        {
            // End:0x62D
            if(bZooming)
            {
                // End:0x5E8
                if(Weap != none)
                {
                    Weap.FlashlightAimingSpotlightOffset.Y += (DeltaTime * float(2));                    
                }
                else
                {
                    Weap3PR.FlashlightAimingSpotlightOffset.Y += (DeltaTime * float(2));
                }                
            }
            else
            {
                // End:0x681
                if(Weap != none)
                {
                    Weap.FlashlightBaseSpotlightOffset.Y += (DeltaTime * float(2));                    
                }
                else
                {
                    Weap3PR.FlashlightBaseSpotlightOffset.Y += (DeltaTime * float(2));
                }
            }
        }
        // End:0x85B
        if(PlayerInput.aLookUp >= 0.3000000)
        {
            // End:0x7AB
            if(bZooming)
            {
                // End:0x759
                if(Weap != none)
                {
                    Weap.FlashlightAimingSpotlightRotOffset.Pitch += FCeil(DeltaTime * float(500));                    
                }
                else
                {
                    Weap3PR.FlashlightAimingSpotlightRotOffset.Pitch += FCeil(DeltaTime * float(500));
                }                
            }
            else
            {
                // End:0x80C
                if(Weap != none)
                {
                    Weap.FlashlightBaseSpotlightRotOffset.Pitch += FCeil(DeltaTime * float(500));                    
                }
                else
                {
                    Weap3PR.FlashlightBaseSpotlightRotOffset.Pitch += FCeil(DeltaTime * float(500));
                }
            }
        }
        // End:0x9F3
        if(PlayerInput.aLookUp <= -0.3000000)
        {
            // End:0x943
            if(bZooming)
            {
                // End:0x8F1
                if(Weap != none)
                {
                    Weap.FlashlightAimingSpotlightRotOffset.Pitch -= FCeil(DeltaTime * float(500));                    
                }
                else
                {
                    Weap3PR.FlashlightAimingSpotlightRotOffset.Pitch -= FCeil(DeltaTime * float(500));
                }                
            }
            else
            {
                // End:0x9A4
                if(Weap != none)
                {
                    Weap.FlashlightBaseSpotlightRotOffset.Pitch -= FCeil(DeltaTime * float(500));                    
                }
                else
                {
                    Weap3PR.FlashlightBaseSpotlightRotOffset.Pitch -= FCeil(DeltaTime * float(500));
                }
            }
        }
        // End:0xB8B
        if(PlayerInput.aTurn <= -0.3000000)
        {
            // End:0xADB
            if(bZooming)
            {
                // End:0xA89
                if(Weap != none)
                {
                    Weap.FlashlightAimingSpotlightRotOffset.Yaw -= FCeil(DeltaTime * float(500));                    
                }
                else
                {
                    Weap3PR.FlashlightAimingSpotlightRotOffset.Yaw -= FCeil(DeltaTime * float(500));
                }                
            }
            else
            {
                // End:0xB3C
                if(Weap != none)
                {
                    Weap.FlashlightBaseSpotlightRotOffset.Yaw -= FCeil(DeltaTime * float(500));                    
                }
                else
                {
                    Weap3PR.FlashlightBaseSpotlightRotOffset.Yaw -= FCeil(DeltaTime * float(500));
                }
            }
        }
        // End:0xD23
        if(PlayerInput.aTurn >= 0.3000000)
        {
            // End:0xC73
            if(bZooming)
            {
                // End:0xC21
                if(Weap != none)
                {
                    Weap.FlashlightAimingSpotlightRotOffset.Yaw += FCeil(DeltaTime * float(500));                    
                }
                else
                {
                    Weap3PR.FlashlightAimingSpotlightRotOffset.Yaw += FCeil(DeltaTime * float(500));
                }                
            }
            else
            {
                // End:0xCD4
                if(Weap != none)
                {
                    Weap.FlashlightBaseSpotlightRotOffset.Yaw += FCeil(DeltaTime * float(500));                    
                }
                else
                {
                    Weap3PR.FlashlightBaseSpotlightRotOffset.Yaw += FCeil(DeltaTime * float(500));
                }
            }
        }
        //return;        
    }

    function ToggleInventoryMap()
    {
        local string CpyStr, nl;
        local AdvWeap_Base Weap;
        local AdvWeap_3PhaseReload_Base Weap3PR;

        // End:0x61
        if(AdvInventoryItem_Torch(MyEvilPawn.WeaponLeft) != none)
        {
            Weap = AdvWeap_Base(MyEvilPawn.WeaponLeft);            
        }
        else
        {
            Weap = AdvWeap_Base(MyEvilPawn.Weapon);
        }
        // End:0xE3
        if(Weap == none)
        {
            Weap3PR = AdvWeap_3PhaseReload_Base(MyEvilPawn.Weapon);
            // End:0xE3
            if(Weap3PR == none)
            {
                return;
            }
        }
        nl = Chr(13) $ Chr(10);
        CpyStr = ((((((("FlashlightBaseSpotlightOffset=" $ "(X=") $ string(((Weap != none) ? Weap.FlashlightBaseSpotlightOffset : Weap3PR.FlashlightBaseSpotlightOffset).X)) $ ",Y=") $ string(((Weap != none) ? Weap.FlashlightBaseSpotlightOffset : Weap3PR.FlashlightBaseSpotlightOffset).Y)) $ ",Z=") $ string(((Weap != none) ? Weap.FlashlightBaseSpotlightOffset : Weap3PR.FlashlightBaseSpotlightOffset).Z)) $ ")") $ nl;        
        CpyStr $= (((((((("FlashlightBaseSpotlightRotOffset=" $ "(Yaw=") $ string(((Weap != none) ? Weap.FlashlightBaseSpotlightRotOffset : Weap3PR.FlashlightBaseSpotlightRotOffset).Yaw)) $ ",Pitch=") $ string(((Weap != none) ? Weap.FlashlightBaseSpotlightRotOffset : Weap3PR.FlashlightBaseSpotlightRotOffset).Pitch)) $ ",Roll=") $ string(((Weap != none) ? Weap.FlashlightBaseSpotlightRotOffset : Weap3PR.FlashlightBaseSpotlightRotOffset).Roll)) $ ")") $ nl);        
        CpyStr $= (((((((("FlashlightAimingSpotlightOffset=" $ "(X=") $ string(((Weap != none) ? Weap.FlashlightAimingSpotlightOffset : Weap3PR.FlashlightAimingSpotlightOffset).X)) $ ",Y=") $ string(((Weap != none) ? Weap.FlashlightAimingSpotlightOffset : Weap3PR.FlashlightAimingSpotlightOffset).Y)) $ ",Z=") $ string(((Weap != none) ? Weap.FlashlightAimingSpotlightOffset : Weap3PR.FlashlightAimingSpotlightOffset).Z)) $ ")") $ nl);        
        CpyStr $= (((((((("FlashlightAimingSpotlightRotOffset=" $ "(Yaw=") $ string(((Weap != none) ? Weap.FlashlightAimingSpotlightRotOffset : Weap3PR.FlashlightAimingSpotlightRotOffset).Yaw)) $ ",Pitch=") $ string(((Weap != none) ? Weap.FlashlightAimingSpotlightRotOffset : Weap3PR.FlashlightAimingSpotlightRotOffset).Pitch)) $ ",Roll=") $ string(((Weap != none) ? Weap.FlashlightAimingSpotlightRotOffset : Weap3PR.FlashlightAimingSpotlightRotOffset).Roll)) $ ")") $ nl);
        CopyToClipboard(CpyStr);
        return;
        //return;        
    }

    function ShowPauseMenu()
    {
        local EvilWeap_Base Weap;

        // End:0x61
        if(AdvInventoryItem_Torch(MyEvilPawn.WeaponLeft) != none)
        {
            Weap = EvilWeap_Base(MyEvilPawn.WeaponLeft);            
        }
        else
        {
            Weap = EvilWeap_Base(MyEvilPawn.Weapon);
        }
        // End:0xC9
        if((Weap == none) || Weap.CustomAnimNode == none)
        {
            return;
        }
        // End:0x181
        if(Weap.CustomAnimNode.GetCustomAnimNodeSeq().bPlaying)
        {
            Weap.CustomAnimNode.StopAnim();
            Weap.CustomArmAnimNode.StopAnim();            
        }
        else
        {
            Weap.CustomAnimNode.ReplayAnim();
            Weap.CustomArmAnimNode.ReplayAnim();
        }
        //return;        
    }

    exec function SetSprint(bool SprintState)
    {
        local AdvWeap_Base Weap;
        local AdvWeap_3PhaseReload_Base Weap3PR;
        local bool bZooming;

        // End:0x61
        if(AdvInventoryItem_Torch(MyEvilPawn.WeaponLeft) != none)
        {
            Weap = AdvWeap_Base(MyEvilPawn.WeaponLeft);            
        }
        else
        {
            Weap = AdvWeap_Base(MyEvilPawn.Weapon);
        }
        // End:0xE3
        if(Weap == none)
        {
            Weap3PR = AdvWeap_3PhaseReload_Base(MyEvilPawn.Weapon);
            // End:0xE3
            if(Weap3PR == none)
            {
                return;
            }
        }
        bZooming = int(EvilWeap_Base(MyEvilPawn.Weapon).GetZoomedState()) == int(3);
        // End:0x25B
        if(bZooming)
        {
            // End:0x18F
            if(Weap != none)
            {
                Weap.FlashlightAimingSpotlightOffset = Weap.default.FlashlightAimingSpotlightOffset;                
            }
            else
            {
                Weap3PR.FlashlightAimingSpotlightOffset = Weap3PR.default.FlashlightAimingSpotlightOffset;
            }
            // End:0x21B
            if(Weap != none)
            {
                Weap.FlashlightAimingSpotlightRotOffset = Weap.default.FlashlightAimingSpotlightRotOffset;                
            }
            else
            {
                Weap3PR.FlashlightAimingSpotlightRotOffset = Weap3PR.default.FlashlightAimingSpotlightRotOffset;
            }            
        }
        else
        {
            // End:0x2AA
            if(Weap != none)
            {
                Weap.FlashlightBaseSpotlightOffset = Weap.default.FlashlightBaseSpotlightOffset;                
            }
            else
            {
                Weap3PR.FlashlightBaseSpotlightOffset = Weap3PR.default.FlashlightBaseSpotlightOffset;
            }
            // End:0x336
            if(Weap != none)
            {
                Weap.FlashlightBaseSpotlightRotOffset = Weap.default.FlashlightBaseSpotlightRotOffset;                
            }
            else
            {
                Weap3PR.FlashlightBaseSpotlightRotOffset = Weap3PR.default.FlashlightBaseSpotlightRotOffset;
            }
        }
        //return;        
    }

    event PlayerTick(float DeltaTime)
    {
        local AdvWeap_Base Weap;
        local AdvWeap_3PhaseReload_Base Weap3PR;
        local bool bZooming;

        global.PlayerTick(DeltaTime);
        // End:0x74
        if(AdvInventoryItem_Torch(MyEvilPawn.WeaponLeft) != none)
        {
            Weap = AdvWeap_Base(MyEvilPawn.WeaponLeft);            
        }
        else
        {
            Weap = AdvWeap_Base(MyEvilPawn.Weapon);
        }
        // End:0xF6
        if(Weap == none)
        {
            Weap3PR = AdvWeap_3PhaseReload_Base(MyEvilPawn.Weapon);
            // End:0xF6
            if(Weap3PR == none)
            {
                return;
            }
        }
        bZooming = int(EvilWeap_Base(MyEvilPawn.Weapon).GetZoomedState()) == int(3);
        // End:0x2CA
        if(int(EvilPlayerInput(PlayerInput).InputButtonDataList[10].RawActive) == int(1))
        {
            // End:0x234
            if(bZooming)
            {
                // End:0x1EF
                if(Weap != none)
                {
                    Weap.FlashlightAimingSpotlightOffset.X += (DeltaTime * float(3));                    
                }
                else
                {
                    Weap3PR.FlashlightAimingSpotlightOffset.X += (DeltaTime * float(3));
                }                
            }
            else
            {
                // End:0x288
                if(Weap != none)
                {
                    Weap.FlashlightBaseSpotlightOffset.X += (DeltaTime * float(3));                    
                }
                else
                {
                    Weap3PR.FlashlightBaseSpotlightOffset.X += (DeltaTime * float(3));
                }
            }
        }
        // End:0x44E
        if(int(EvilPlayerInput(PlayerInput).InputButtonDataList[12].RawActive) == int(1))
        {
            // End:0x3B8
            if(bZooming)
            {
                // End:0x373
                if(Weap != none)
                {
                    Weap.FlashlightAimingSpotlightOffset.X -= (DeltaTime * float(3));                    
                }
                else
                {
                    Weap3PR.FlashlightAimingSpotlightOffset.X -= (DeltaTime * float(3));
                }                
            }
            else
            {
                // End:0x40C
                if(Weap != none)
                {
                    Weap.FlashlightBaseSpotlightOffset.X -= (DeltaTime * float(3));                    
                }
                else
                {
                    Weap3PR.FlashlightBaseSpotlightOffset.X -= (DeltaTime * float(3));
                }
            }
        }
        // End:0x606
        if(int(EvilPlayerInput(PlayerInput).InputButtonDataList[11].RawActive) == int(1))
        {
            // End:0x556
            if(bZooming)
            {
                // End:0x504
                if(Weap != none)
                {
                    Weap.FlashlightAimingSpotlightRotOffset.Roll -= FCeil(DeltaTime * float(800));                    
                }
                else
                {
                    Weap3PR.FlashlightAimingSpotlightRotOffset.Roll -= FCeil(DeltaTime * float(800));
                }                
            }
            else
            {
                // End:0x5B7
                if(Weap != none)
                {
                    Weap.FlashlightBaseSpotlightRotOffset.Roll -= FCeil(DeltaTime * float(800));                    
                }
                else
                {
                    Weap3PR.FlashlightBaseSpotlightRotOffset.Roll -= FCeil(DeltaTime * float(800));
                }
            }
        }
        // End:0x7BE
        if(int(EvilPlayerInput(PlayerInput).InputButtonDataList[13].RawActive) == int(1))
        {
            // End:0x70E
            if(bZooming)
            {
                // End:0x6BC
                if(Weap != none)
                {
                    Weap.FlashlightAimingSpotlightRotOffset.Roll += FCeil(DeltaTime * float(800));                    
                }
                else
                {
                    Weap3PR.FlashlightAimingSpotlightRotOffset.Roll += FCeil(DeltaTime * float(800));
                }                
            }
            else
            {
                // End:0x76F
                if(Weap != none)
                {
                    Weap.FlashlightBaseSpotlightRotOffset.Roll += FCeil(DeltaTime * float(800));                    
                }
                else
                {
                    Weap3PR.FlashlightBaseSpotlightRotOffset.Roll += FCeil(DeltaTime * float(800));
                }
            }
        }
        //return;        
    }

    simulated function DrawHUD(HUD H)
    {
        local AdvWeap_Base Weap;
        local AdvWeap_3PhaseReload_Base Weap3PR;

        super(AdvPlayerController).DrawHUD(H);
        // End:0x74
        if(AdvInventoryItem_Torch(MyEvilPawn.WeaponLeft) != none)
        {
            Weap = AdvWeap_Base(MyEvilPawn.WeaponLeft);            
        }
        else
        {
            Weap = AdvWeap_Base(MyEvilPawn.Weapon);
        }
        // End:0xF6
        if(Weap == none)
        {
            Weap3PR = AdvWeap_3PhaseReload_Base(MyEvilPawn.Weapon);
            // End:0xF6
            if(Weap3PR == none)
            {
                return;
            }
        }
        H.Canvas.DrawColor.R = 255;
        H.Canvas.DrawColor.G = 0;
        H.Canvas.DrawColor.B = 0;
        H.Canvas.DrawColor.A = 255;
        H.Canvas.SetPos(10.0000000, 5.0000000);
        H.Canvas.DrawText("INFO");
        H.Canvas.SetPos(10.0000000, 20.0000000);
        H.Canvas.DrawText("[Left Stick] Change Y/Z position");
        H.Canvas.SetPos(10.0000000, 35.0000000);
        H.Canvas.DrawText("[Right Stick] Change Yaw/Pitch rotation");
        H.Canvas.SetPos(10.0000000, 50.0000000);
        H.Canvas.DrawText("[DPAD UP/DOWN] Change X position");
        H.Canvas.SetPos(10.0000000, 65.0000000);
        H.Canvas.DrawText("[DPAD LEFT/RIGHT] Change Roll rotation");
        H.Canvas.SetPos(10.0000000, 80.0000000);
        H.Canvas.DrawText("[R3] Restore defaults");
        H.Canvas.SetPos(10.0000000, 95.0000000);
        H.Canvas.DrawText("[Start] Pause/replay anim");
        H.Canvas.SetPos(10.0000000, 110.0000000);
        H.Canvas.DrawText("[Back] Copy to clipboard");
        // End:0xB53
        if(int(EvilWeap_Base(MyEvilPawn.Weapon).GetZoomedState()) < int(3))
        {
            H.Canvas.SetPos(10.0000000, 170.0000000);
            H.Canvas.DrawText("CONFIG: NORMAL");
            H.Canvas.SetPos(10.0000000, 185.0000000);
            H.Canvas.DrawText((((((("FlashlightBaseSpotlightOffset: " $ "(X=") $ string(((Weap != none) ? Weap.FlashlightBaseSpotlightOffset : Weap3PR.FlashlightBaseSpotlightOffset).X)) $ ",Y=") $ string(((Weap != none) ? Weap.FlashlightBaseSpotlightOffset : Weap3PR.FlashlightBaseSpotlightOffset).Y)) $ ",Z=") $ string(((Weap != none) ? Weap.FlashlightBaseSpotlightOffset : Weap3PR.FlashlightBaseSpotlightOffset).Z)) $ ")");
            H.Canvas.SetPos(10.0000000, 200.0000000);
            H.Canvas.DrawText((((((("FlashlightBaseSpotlightRotOffset: " $ "(Yaw=") $ string(((Weap != none) ? Weap.FlashlightBaseSpotlightRotOffset : Weap3PR.FlashlightBaseSpotlightRotOffset).Yaw)) $ ",Pitch=") $ string(((Weap != none) ? Weap.FlashlightBaseSpotlightRotOffset : Weap3PR.FlashlightBaseSpotlightRotOffset).Pitch)) $ ",Roll=") $ string(((Weap != none) ? Weap.FlashlightBaseSpotlightRotOffset : Weap3PR.FlashlightBaseSpotlightRotOffset).Roll)) $ ")");            
        }
        else
        {
            H.Canvas.SetPos(10.0000000, 170.0000000);
            H.Canvas.DrawText("CONFIG: ZOOMING");
            H.Canvas.SetPos(10.0000000, 185.0000000);
            H.Canvas.DrawText((((((("FlashlightAimingSpotlightOffset: " $ "(X=") $ string(((Weap != none) ? Weap.FlashlightAimingSpotlightOffset : Weap3PR.FlashlightAimingSpotlightOffset).X)) $ ",Y=") $ string(((Weap != none) ? Weap.FlashlightAimingSpotlightOffset : Weap3PR.FlashlightAimingSpotlightOffset).Y)) $ ",Z=") $ string(((Weap != none) ? Weap.FlashlightAimingSpotlightOffset : Weap3PR.FlashlightAimingSpotlightOffset).Z)) $ ")");
            H.Canvas.SetPos(10.0000000, 200.0000000);
            H.Canvas.DrawText((((((("FlashlightAimingSpotlightRotOffset: " $ "(Yaw=") $ string(((Weap != none) ? Weap.FlashlightAimingSpotlightRotOffset : Weap3PR.FlashlightAimingSpotlightRotOffset).Yaw)) $ ",Pitch=") $ string(((Weap != none) ? Weap.FlashlightAimingSpotlightRotOffset : Weap3PR.FlashlightAimingSpotlightRotOffset).Pitch)) $ ",Roll=") $ string(((Weap != none) ? Weap.FlashlightAimingSpotlightRotOffset : Weap3PR.FlashlightAimingSpotlightRotOffset).Roll)) $ ")");
        }
        //return;        
    }
    stop;    
}

state WeaponSetPosMode
{
    ignores ToggleQuickMenu;
    stop;    
}

state MovingSmooth
{
    function PushedState()
    {
        StartMovingSmoothTime = WorldInfo.TimeSeconds;
        super(Object).PushedState();
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        local Vector MoveVector;

        MoveVector = MoveSmoothLocation - Pawn.Location;
        // End:0x89
        if((VSize(MoveVector) < float(26)) || (WorldInfo.TimeSeconds - StartMovingSmoothTime) > float(2))
        {
            PopState();            
        }
        else
        {
            MoveVector = Normal(MoveVector);
            MoveVector = (MoveVector * DeltaTime) * float(300);
            Pawn.MoveSmooth(MoveVector);
        }
        super(PlayerController).PlayerMove(DeltaTime);
        //return;        
    }
Begin:

    Sleep(0.1000000);
    stop;                
}

defaultproperties
{
    LevelUpMsg="Level Up!"
    LastBreathStartCue=SoundCue'a_Accents.Cue.a_PlayerStunIn'
    LastBreathEndCue=SoundCue'a_Accents.Cue.a_PlayerStunOut'
    LastBreathAmbientCue=SoundCue'a_Accents.Cue.a_PlayerStunLoop'
    ExplosionStunStartCue=SoundCue'a_Accents.Cue.a_PlayerStunIn'
    ExplosionStunEndCue=SoundCue'a_Accents.Cue.a_PlayerStunOut'
    ExplosionStunAmbientCue=SoundCue'a_Player.Cue.a_InHeadBeep_02'
    NotepadFocusTriggerItemClass=Class'AdvInventoryItem_Notepad'
    FocusFOV=90.0000000
    FocusFOVRate=60.0000000
    FocusVignetteScale=2.0000000
    FocusSelDesatExceptionColor=(R=1.0000000,G=0.8000000,B=0.0000000,A=0.0000000)
    FocusSelDesatThresholds=(X=0.2000000,Y=0.3000000)
    FocusSelDesatScale=0.7000000
    PrevPlayerPOV=(Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0000000)
    MatineeInterpolationAlpha=1.0000000
    AimPPOverride=(bOverride_EnableBloom=true,bOverride_EnableDOF=true,bOverride_EnableMotionBlur=true,bOverride_EnableSceneEffect=true,bOverride_AllowAmbientOcclusion=true,bOverride_OverrideRimShaderColor=true,bOverride_Bloom_Scale=true,bOverride_Bloom_Threshold=true,bOverride_Bloom_Tint=true,bOverride_Bloom_ScreenBlendThreshold=true,bOverride_Bloom_InterpolationDuration=true,bOverride_DOF_FalloffExponent=true,bOverride_DOF_BlurKernelSize=true,bOverride_DOF_BlurBloomKernelSize=true,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=true,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=true,bOverride_DOF_FocusPosition=true,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=true,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=true,bOverride_Scene_MidTones=true,bOverride_Scene_Shadows=true,bOverride_Scene_InterpolationDuration=true,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=true,bOverride_RimShader_InterpolationDuration=true,bOverride_MobileColorGrading=false,bEnableBloom=true,bEnableDOF=false,bEnableMotionBlur=true,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=255,A=0),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=0.0000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=2000.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=1.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=0.4704400,G=0.5859730,B=0.8277260,A=1.0000000),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=0.7000000,G=0.7000000,B=0.7000000,A=1.0000000),MidTones=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000),Shadows=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000))
    TreasurePerks[0]=(PerkClassName="AdvGame.AdvPerk_Treasure_Health",PerkPath=PerkPath[0]=(CurrentLevel=0,LevelCost=LevelCost[0]=1
    LevelCost[1]=3
    LevelCost[2]=6
    LevelCost[3]=10)
    PerkPath[1]=(CurrentLevel=0,LevelCost=LevelCost[0]=2
    LevelCost[1]=3
    LevelCost[2]=6
    LevelCost[3]=8))
    TreasurePerks[1]=(PerkClassName="AdvGame.AdvPerk_Treasure_Flashlight",PerkPath=PerkPath[0]=(CurrentLevel=0,LevelCost=LevelCost[0]=3
    LevelCost[1]=6
    LevelCost[2]=10
    LevelCost[3]=15))
    TreasurePerks[2]=(PerkClassName="AdvGame.AdvPerk_Treasure_Weapon",PerkPath=PerkPath[0]=(CurrentLevel=0,LevelCost=LevelCost[0]=2
    LevelCost[1]=3
    LevelCost[2]=5
    LevelCost[3]=7)
    PerkPath[1]=(CurrentLevel=0,LevelCost=LevelCost[0]=2
    LevelCost[1]=3
    LevelCost[2]=5
    LevelCost[3]=8))
    MultiLoadingMovie="UI_AdvMultiplayer.AdvMultiLoading"
    InfoLoadingMovie="UI_AdvMultiplayer.AdvMultiLoadingPre"
    HintsPackage="Hints"
    HintsSection="LoadingHints"
    GeneralHints=(HintsPrefix="HintGeneral",HintsCount=7)
    TrapsHints=(HintsPrefix="HintTraps",HintsCount=4)
    KillstreakHints=(HintsPrefix="HintKillstreak",HintsCount=7)
    AWUHints=(HintsPrefix="HintAWU",HintsCount=2)
    THHints=(HintsPrefix="HintTH",HintsCount=3)
    TTHHints=(HintsPrefix="HintTTH",HintsCount=4)
    OracleHints=(HintsPrefix="HintOracle",HintsCount=5)
    CTAHints=(HintsPrefix="HintCTA",HintsCount=2)
    LMSHints=(HintsPrefix="HintLMS",HintsCount=3)
    SVHints=(HintsPrefix="HintSV",HintsCount=5)
    TrapsSVHints=(HintsPrefix="HintTrapsSV",HintsCount=3)
    SPHintsInfo=(HintsPrefix="DeadfallInfo",HintsCount=21)
    SPHintsTips=(HintsPrefix="DeadfallTip",HintsCount=11)
    HighlightComponentClass=Class'AdvFocusHighlightComponent'
    typeMod=1.0000000
    takeDamageDuration=0.2500000
    killDuration=0.1000000
    compassDuration=0.7000000
    afterPickTreasureDuration=1.0000000
    criticalHealthDuration=0.1000000
    criticalHealthDurationModifier=0.3000000
    afterDeathDuration=1.0000000
    minBlinkTime=0.0300000
    impulseBlinkModifier=0.1000000
    // Reference: EvilSceneCaptureHighlightComponent'Default__AdvPlayerController.HighlightComponent'
    begin object name=HighlightComponent
    end object
    HighlightSceneCaptureComponent=HighlightComponent
    PointOfInterestLookatInterpSpeed=7.0000000
    CheckpointSavedString="Saving content. Please don't turn off your computer."
    CheckpointLoadedString="Checkpoint Loaded"
    // Reference: ForceFeedbackWaveform'Default__AdvPlayerController.ForceFeedbackWaveform7'
    begin object name=ForceFeedbackWaveform7
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__AdvPlayerController.ForceFeedbackWaveform8'
    begin object name=ForceFeedbackWaveform8
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    OnFootDefaultFOV=75.0000000
    FOVAngle=95.0000000
    DesiredFOV=95.0000000
    CheatClass=Class'AdvCheatManager'
    InputClass=Class'AdvPlayerInput'
    // Reference: CylinderComponent'Default__AdvPlayerController.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=HighlightComponent
    CollisionComponent=CollisionCylinder
}