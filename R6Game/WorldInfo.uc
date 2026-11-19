class WorldInfo extends ZoneInfo
    native
    nativereplication
    config(Game)
    notplaceable
    hidecategories(lighting,Movement,Collision,Actor,Advanced,Display,Events,Object,Attachment,ResourceStreaming);

enum ENetMode
{
    NM_Standalone,                  // 0
    NM_DedicatedServer,             // 1
    NM_ListenServer,                // 2
    NM_Client,                      // 3
    NM_MAX                          // 4
};

struct R6DecalCreationInfo
{
    var() IntPoint m_iStart;
    var() IntPoint m_iSize;
    var() float m_fScale;
    var() float m_fScaleJitter;
    var() float m_fProjectionDistance;

    structdefaultproperties
    {
        m_iStart=(X=45,Y=4)
        m_iSize=(X=45,Y=4)
        m_fScale=0.0000000
        m_fScaleJitter=1.2000000
        m_fProjectionDistance=2.0000000
    }
};

struct OcclusionZone
{
    var() array<ZoneInfo> IncludedZoneInfos;

    structdefaultproperties
    {
        IncludedZoneInfos=none
    }
};

struct SubLevelInfo
{
    var() string m_Name;

    structdefaultproperties
    {
        m_Name=""
    }
};

struct MemoryBuffers
{
    var transient bool m_bUsed;
    var transient array<Texture> m_aTexture;
    var export editinline transient array<export editinline PrimitiveComponent> m_aPrimitiveComponent;
    var export editinline transient array<export editinline LightComponent> m_aLightComponent;

    structdefaultproperties
    {
        m_bUsed=false
        m_aTexture=none
        m_aPrimitiveComponent=none
        m_aLightComponent=none
    }
};

var() const editconst editinline array<editinline LevelStreaming> StreamingLevels;
var(Editor) array<EdLayer> Layers;
var(Editor) BookMark BookMarks[10];
var float TimeDilation;
var float TimeSeconds;
var float PauseDelay;
var PlayerReplicationInfo Pauser;
var LevelSummary Summary;
var string VisibleGroups;
var transient string SelectedGroups;
var bool bBegunPlay;
var bool bPlayersOnly;
var bool bDropDetail;
var bool bAggressiveLOD;
var bool bStartup;
var bool bPathsRebuilt;
var bool bHasPathNodes;
var(Physics) bool bUseFixedTimestep;
var bool m_bAllow3DRendering;
var() bool bForceMaximumShadowAndLightMapPacking;
var bool m_bIsResettingLevel;
var bool m_bEnableZoningVisibility;
var(Tutorial) bool m_bIsATutorial;
var(Intro) bool m_bFadeIn;
var(Intro) bool m_bPlayIntroInEditor;
var bool m_bIntroFinished;
var(HUD) bool m_bAllowHeliRideOutfitting;
var(Shadow) bool m_bOverrideShadowMapResolution;
var(Physics) int RBPhysicsTimestepHz;
var(Physics) int RBPhysicsMinHz;
var(Physics) float RBSleepLinVel;
var(Physics) float RBSleepAngVel;
var Texture2D DefaultTexture;
var Texture2D WireframeTexture;
var Texture2D WhiteSquareTexture;
var Texture2D LargeVertex;
var Texture2D BSPVertex;
var transient GameReplicationInfo GRI;
var WorldInfo.ENetMode NetMode;
var(AI) R6EngineEnums.ERulesOfEngagement m_StartingROE;
var string ComputerName;
var string EngineVersion;
var string MinNetVersion;
var GameInfo Game;
var() float StallZ;
var transient float WorldGravityZ;
var const globalconfig float DefaultGravityZ;
var() float GlobalGravityZ;
var globalconfig float RBPhysicsGravityScaling;
var private const transient NavigationPoint NavigationPointList;
var const Controller ControllerList;
var private const Pawn PawnList;
var const transient CoverLink CoverList;
var float MoveRepSize;
var const PlayerController ReplicationViewer;
var const Actor ReplicationViewTarget;
var string NextURL;
var float NextSwitchCountdown;
var SoundCue m_ImpactSound3P;
var SoundCue m_ImpactSound1P;
var SoundCue m_RicochetSound;
var SoundCue m_BulletFlybySound;
var SoundCue m_StairFoley;
var SoundCue m_ToneExplosionPlay;
var SoundCue m_ToneExplosionStop;
var(ToneSound) /*0x04000000-0x00000000*/ float m_FadeInSoundsVolume;
var(ToneSound) /*0x04000000-0x00000000*/ float m_FadeInSoundsTime;
var(ToneSound) /*0x04000000-0x00000000*/ float m_FadeOutSoundsVolume;
var(ToneSound) /*0x04000000-0x00000000*/ float m_FadeOutSoundsTime;
var(ToneSound) /*0x04000000-0x00000000*/ float m_TimeToneDuration;
var(ToneSound) /*0x04000000-0x00000000*/ float m_TimeTriggerPauseVolumetricsSinceExplosion;
var(ToneSound) /*0x04000000-0x00000000*/ float m_TimeTriggerResumeVolumetricsSinceExplosion;
var(ToneSound) /*0x04000000-0x00000000*/ float m_LenghtTriggerPauseVolumetricsSinceExplosion;
var(ToneSound) /*0x04000000-0x00000000*/ float m_LenghtTriggerResumeVolumetricsSinceExplosion;
var R6PlayerAmbienceManager m_PlayerAmbienceManager;
var float m_AmbientSplitFadeInTime;
var float m_AmbientSplitFadeOutTime;
var(SplitScreenSound) /*0x04000000-0x00000000*/ SoundCue m_SplitScreen_Ambiances[4];
var(SplitScreenSound) /*0x04000000-0x00000000*/ SoundCue m_SplitScreen_Reverb;
var SoundCue m_RopeKickDownPlay;
var SoundCue m_RopeKickDownStop;
var SoundCue m_FastRopePlay;
var SoundCue m_FastRopeStop;
var SoundCue m_PipSoundOn;
var SoundCue m_PipSoundOff;
var export editinline transient R6BulletTracerComponent m_tracerComponent;
var(AI) int m_iPAMDeactivationZonesAway;
var(R6SoundPropagation) /*0x04000000-0x00000000*/ array<OcclusionZone> m_OcclusionZones;
var float m_fColorGelModifier;
var(SceneAdjustment) Vector m_vSceneBrightness;
var(SceneAdjustment) Vector m_vSceneContrast;
var(SceneAdjustment) Vector m_vSceneSaturation;
var int m_iFireReplicationID;
var int m_iNbFiresToReplicate;
var export editinline PrimitiveComponent m_NewFireComponents[8];
var Vector m_NewFirePositions[8];
var R6ActorListManager m_ActorListManager;
var R6PostProcessConfig m_PostProcessOverridesConfig;
var transient array<R6PostProcessConfigCollection> m_PostProcessOverridesMerged;
var(PostProcessConfigs) R6PostProcessConfigCollection m_PostProcessOverrides;
var Object m_VoiceChatActorHandle;
var() array<SubLevelInfo> m_SubLevels;
var() array<int> m_SubLevelsOrder;
var(Waypoints) array<R6Waypoint> m_pWaypoints;
var(ScriptedEvent) array<AnimSet> m_AnimSets;
var private native const map{VOID,VOID} m_AnimSeqMap;
var(MPModes) float m_fTHDensityPercentageLow;
var(MPModes) float m_fTHDensityPercentageMedium;
var(MPModes) float m_fTHDensityPercentageHigh;
var(MPModes) int m_iNumZonesAwayBeforeDeactivate;
var(R6Sound) /*0x04000000-0x00000000*/ const SoundCue m_MapMusic;
var(R6Sound) /*0x04000000-0x00000000*/ const int m_CombatMusicFadeInTime;
var(R6Sound) /*0x04000000-0x00000000*/ const int m_CombatMusicFadeOutTime;
var(IdleDialog) int m_iIdleDialogLocationIndex;
var(VoiceBanks) array<R6VoiceBank> m_aTerroristBanks;
var(VoiceBanks) array<R6VoiceBank> m_aMaleCivilianBanks;
var(VoiceBanks) array<R6VoiceBank> m_aFemaleCivilianBanks;
var(Intro) const localized string m_sBigText;
var(Intro) const localized string m_sSmallText;
var(Intro) const localized string m_sIntroQuote;
var(Streaming) array<string> m_arrKismetStreamsToPreload;
var(Streaming) int m_iMaxTextureStreamedSizeInMegs;
var const array<Texture> m_apMPBriefingTexture;
var const array<Actor> m_aMassiveActors;
var(Shadow) int m_fNewShadowMapResolution;
var private transient MemoryBuffers m_MemoryBuffers[2];
var(FirstZone) ZoneInfo m_SpawnZone;
var(ListenServer) int m_iListenServerTexturesLODBias;
var(ListenServer) int m_iListenServerLightmapsLODBias;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        Pauser, TimeDilation, 
        WorldGravityZ, m_NewFireComponents, 
        m_NewFirePositions, m_iFireReplicationID, 
        m_iNbFiresToReplicate;
}

// Export UWorldInfo::execAddImpactUnlitMod(FFrame&, void* const)
native final function AddImpactUnlitMod(Vector HitLocation, Vector HitDirection, R6DecalCreationInfo creationInfo, R6MaterialGameParams impactMGP, Level inLevel, PrimitiveComponent Component);

// Export UWorldInfo::execSpawnImpactEffect(FFrame&, void* const)
native final function SpawnImpactEffect(Actor pHitActor, PrimitiveComponent pHitComponent, Vector vAimDir, Vector vHitLocation, Vector vHitNormal, TraceHitInfo HitInfo, bool bPenetrated, R6MaterialGameParams pMatGameParams, bool bIsLocalPlayer, bool bPlayImpactSound, Pawn pInstigator, optional bool bUsePool);

// Export UWorldInfo::execGetHitEffectOrientation(FFrame&, void* const)
native final function Rotator GetHitEffectOrientation(Vector vDesiredDirection, Vector vNormal, Vector vAimDir, Rotator rEffectRandom, bool bExitEffect);

// Export UWorldInfo::execStartNewFire(FFrame&, void* const)
native final function StartNewFire(Vector NewLocation);

// Export UWorldInfo::execShowNMPortal(FFrame&, void* const)
native final function ShowNMPortal();

final function bool IsServer()
{
    return (int(NetMode) == int(NM_DedicatedServer)) || int(NetMode) == int(NM_ListenServer);
    return;
}

// Export UWorldInfo::execGetGravityZ(FFrame&, void* const)
native function float GetGravityZ();

// Export UWorldInfo::execGetGameSequence(FFrame&, void* const)
native final function Sequence GetGameSequence(optional int idx);

// Export UWorldInfo::execSetLevelRBGravity(FFrame&, void* const)
native final function SetLevelRBGravity(Vector NewGrav);

// Export UWorldInfo::execGetLocalURL(FFrame&, void* const)
native simulated function string GetLocalURL();

// Export UWorldInfo::execIsDemoBuild(FFrame&, void* const)
native static final simulated function bool IsDemoBuild();

// Export UWorldInfo::execIsConsoleBuild(FFrame&, void* const)
native static final simulated function bool IsConsoleBuild();

// Export UWorldInfo::execForceGarbageCollection(FFrame&, void* const)
native final simulated function ForceGarbageCollection();

// Export UWorldInfo::execGetAddressURL(FFrame&, void* const)
native simulated function string GetAddressURL();

simulated function class<GameInfo> GetGameClass()
{
    // End:0x2C
    if(WorldInfo.Game != none)
    {
        return WorldInfo.Game.Class;
    }
    // End:0x5C
    if((GRI != none) && GRI.GameClass != none)
    {
        return GRI.GameClass;
    }
    return none;
    return;
}

event ServerTravel(string URL, bool bItems)
{
    // End:0x12
    if(InStr(URL, "%") >= 0)
    {
        return;
    }
    // End:0x48
    if(((InStr(URL, ":") >= 0) || InStr(URL, "/") >= 0) || InStr(URL, "\\") >= 0)
    {
        return;
    }
    // End:0x93
    if(NextURL == "")
    {
        NextURL = URL;
        // End:0x88
        if(Game != none)
        {
            Game.ProcessServerTravel(URL, bItems);            
        }
        else
        {
            NextSwitchCountdown = 0.0000000;
        }
    }
    return;
}

function ThisIsNeverExecuted()
{
    return;
}

event PostLoadGame()
{
    // End:0x1F
    if(GRI == none)
    {
        GRI = Game.GameReplicationInfo;
    }
    return;
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    m_ActorListManager = new (self) Class'R6ActorListManager';    
    m_tracerComponent = new (self) Class'Engine.R6BulletTracerComponent';    
    AttachComponent(m_tracerComponent);
    m_PlayerAmbienceManager = new (self) Class'R6PlayerAmbienceManager';    
    m_PlayerAmbienceManager.Initialize();
    return;
}

simulated event bool ShouldPlayIntro()
{
    return ((GRI != none) && GRI.bPlayIntro) && !m_bIntroFinished;
    return;
}

simulated function int EffectsDetailLevel()
{
    return 0;
    return;
}

// Export UWorldInfo::execAllNavigationPoints(FFrame&, void* const)
native final iterator function AllNavigationPoints(class<NavigationPoint> BaseClass, out NavigationPoint N);

// Export UWorldInfo::execRadiusNavigationPoints(FFrame&, void* const)
native final iterator function RadiusNavigationPoints(class<NavigationPoint> BaseClass, out NavigationPoint N, Vector Point, float Radius);

// Export UWorldInfo::execAllControllers(FFrame&, void* const)
native final iterator function AllControllers(class<Controller> BaseClass, out Controller C);

// Export UWorldInfo::execAllPawns(FFrame&, void* const)
native final iterator function AllPawns(class<Pawn> BaseClass, out Pawn P);

// Export UWorldInfo::execNotifyMatchStarted(FFrame&, void* const)
native final function NotifyMatchStarted();

defaultproperties
{
    TimeDilation=1.0000000
    VisibleGroups="None"
    m_bAllow3DRendering=true
    m_bAllowHeliRideOutfitting=true
    RBPhysicsTimestepHz=100
    RBPhysicsMinHz=30
    RBSleepLinVel=0.3000000
    RBSleepAngVel=0.3000000
    DefaultTexture=Texture2D'EngineResources.DefaultTexture'
    WhiteSquareTexture=Texture2D'EngineResources.WhiteSquareTexture'
    LargeVertex=Texture2D'EngineResources.LargeVertex'
    BSPVertex=Texture2D'EngineResources.BSPVertex'
    m_StartingROE=1
    StallZ=1000000.0000000
    DefaultGravityZ=-750.0000000
    RBPhysicsGravityScaling=1.3000000
    MoveRepSize=42.0000000
    m_ImpactSound3P=SoundCue'Dare.W_Bullets.Play_Impacts_To_3P'
    m_ImpactSound1P=SoundCue'Dare.W_Bullets.Play_Impacts_To_1P'
    m_RicochetSound=SoundCue'Dare.W_Bullets.Play_B_Ricochets'
    m_BulletFlybySound=SoundCue'Dare.W_Bullets.Play_B_FlyBys'
    m_StairFoley=SoundCue'Dare.Foley_Rainbow.Rainbow_Stairs'
    m_ToneExplosionPlay=SoundCue'Dare.Player.Play_E_HearTon5a'
    m_ToneExplosionStop=SoundCue'Dare.Player.Stop_E_HearTon5a'
    m_FadeInSoundsTime=8.0000000
    m_FadeOutSoundsVolume=-96.0000000
    m_FadeOutSoundsTime=0.3000000
    m_TimeToneDuration=1.0000000
    m_TimeTriggerResumeVolumetricsSinceExplosion=1.0000000
    m_LenghtTriggerPauseVolumetricsSinceExplosion=0.5000000
    m_LenghtTriggerResumeVolumetricsSinceExplosion=0.5000000
    m_AmbientSplitFadeInTime=0.2500000
    m_AmbientSplitFadeOutTime=0.2500000
    m_RopeKickDownPlay=SoundCue'Dare.Foley_Rainbow.Play_F_KickDown_Rope'
    m_RopeKickDownStop=SoundCue'Dare.Foley_Rainbow.Stop_F_KickDown_Rope'
    m_FastRopePlay=SoundCue'Dare.Foley_Rainbow.Play_F_FastRope_RopeSlide'
    m_FastRopeStop=SoundCue'Dare.Foley_Rainbow.Stop_F_FastRope_RopeSlide_Go'
    m_PipSoundOn=SoundCue'Dare.Player.Play_PIP_On'
    m_PipSoundOff=SoundCue'Dare.Player.Play_PIP_Off'
    m_iPAMDeactivationZonesAway=3
    m_fColorGelModifier=1.0000000
    m_vSceneBrightness=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    m_vSceneContrast=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    m_vSceneSaturation=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    m_fTHDensityPercentageLow=0.4000000
    m_fTHDensityPercentageMedium=0.6000000
    m_fTHDensityPercentageHigh=0.8000000
    m_iNumZonesAwayBeforeDeactivate=4
    m_CombatMusicFadeInTime=2
    m_CombatMusicFadeOutTime=10
    m_iIdleDialogLocationIndex=-1
    m_iMaxTextureStreamedSizeInMegs=64
    bWorldGeometry=true
    bAlwaysRelevant=true
    bBlockActors=true
    bHiddenEd=true
    m_bDoNotClimbOnMe=false
    // Reference: R6SoundZoneInfo'Default__WorldInfo.SoundZoneInfo'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: R6SoundZoneInfo'Default__ZoneInfo.SoundZoneInfo'
    begin object name="SoundZoneInfo"
    end object
    Components[0]=SoundZoneInfo
    RemoteRole=1
}