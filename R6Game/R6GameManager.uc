class R6GameManager extends R6AbstractGameManager
    native;

struct SCheckpointInvInfo
{
    var string m_strClassName;
    var Inventory m_pObj;

    structdefaultproperties
    {
        m_strClassName=""
        m_pObj=none
    }
};

struct SCheckpointPawnInfo
{
    var array<SCheckpointInvInfo> m_aInventory;
    var int m_iCurrentWeapon;
    var int m_iCurrentGadget;
    var R6EngineEnums.ERainbowMembers m_eTeamMember;
    var string m_strCharacterTemplate;
    var Vector m_vLocation;
    var Rotator m_rRotation;
    var bool m_bInHelicopter;

    structdefaultproperties
    {
        m_aInventory=none
        m_iCurrentWeapon=0
        m_iCurrentGadget=0
        m_eTeamMember=0
        m_strCharacterTemplate=""
        m_vLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_rRotation=(Pitch=0,Yaw=0,Roll=0)
        m_bInHelicopter=false
    }
};

struct SCheckpointInfo
{
    structcpptext
    {

        // Serialization
        void SerializeInfo( class FArchive& Archive );
        void LoadPawnInfo( class FArchive& Archive, INT iIndex );
        void SavePawnInfo( class FArchive& Archive, class AR6Pawn* pPawn );

        // Initialization
        void InitializePawn( class AR6Pawn* pPawn );
    
    }

    var bool m_bActive;
    var int m_iIdx;
    var string m_strDescId;
    var R6Helicopter m_pHelicopter;
    var R6CheckpointVolume m_pChkVolumeUsed;
    var R6EngineEnums.ERulesOfEngagement m_eROE;
    var SCheckpointPawnInfo m_aPawnInfo[3];

    structdefaultproperties
    {
        m_bActive=false
        m_iIdx=0
        m_strDescId=""
        m_pHelicopter=none
        m_pChkVolumeUsed=none
        m_eROE=0
        m_aPawnInfo[0]=(m_aInventory=none,m_iCurrentWeapon=0,m_iCurrentGadget=0,m_eTeamMember=0,m_strCharacterTemplate="",m_vLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_rRotation=(Pitch=0,Yaw=0,Roll=0),m_bInHelicopter=false)
        m_aPawnInfo[1]=(m_aInventory=none,m_iCurrentWeapon=0,m_iCurrentGadget=0,m_eTeamMember=0,m_strCharacterTemplate="",m_vLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_rRotation=(Pitch=0,Yaw=0,Roll=0),m_bInHelicopter=false)
        m_aPawnInfo[2]=(m_aInventory=none,m_iCurrentWeapon=0,m_iCurrentGadget=0,m_eTeamMember=0,m_strCharacterTemplate="",m_vLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_rRotation=(Pitch=0,Yaw=0,Roll=0),m_bInHelicopter=false)
    }
};

struct SLoadedSoundBankInfo
{
    var class<Inventory> m_pItemClass;
    var int m_iRefCount;

    structdefaultproperties
    {
        m_pItemClass=none
        m_iRefCount=0
    }
};

var R6MissionManager m_MissionManager;
var string m_fstrNextMissionURL;
var int m_iPreviousTerroHuntMission;
var R6TutorialManager m_TutorialManager;
var array<R6DroppedPickup> m_DroppedPickups;
var array<SLoadedSoundBankInfo> m_LoadedSoundBanksInfo;
var R6EquipmentTemplateMgr m_EquipmentTemplateMgr;
var R6KitRestrictionMgr m_KitRestrictionMgr;
var R6PECAssetManager m_PECAssetManager;
var bool m_bPauseCheat;
var bool m_bPauseStep;
var bool m_bPauseSB;
var bool m_bStepSB;
var bool m_bIsResettingLevel;
var bool m_bForceFireFightColorGel;
var bool m_bFireFightColorGelEnabled;
var bool m_bIsExiting;
var bool m_bHandleLiveDisconnection;
var bool m_bIsInAttrackMode;
var bool m_bSavingCheckpoint;
var bool m_bUseDirectCheckpoint;
var bool m_bWeaponChangeAcknowledged;
var R6EngineEnums.ETargetMenuId m_eTargetMenuId;
var R6EngineEnums.EGameDifficulty m_eGameDifficulty;
var byte m_aControllerConnected[4];
var int m_iFireFightCounter;
var float m_fFireFightColorGelModifier;
var float m_fLoadingProgress;
var int m_iIsLoading;
var int m_iLoadingProgressSteps;
var DynamicSMActor m_pMoveToLocation;
var Double m_StartCycle;
var Double m_InventorySpawnTime;
var native map{VOID,VOID} m_AnimTreePool;
var array<AnimTree> m_AnimTreePoolReference;
var R6SpawnPoint m_pCurrentSpawnPoint;
var array<R6Pawn> m_aSetAnimTreePendingPawns;
var SCheckpointInfo m_CheckpointInfo;
var string m_strDirectChkPt;
var string m_strSavedEquipment;
var int m_iSimulateNetworkTCRLag;
var int m_iSimulateNetworkTCRLoss;
var float m_fSimulateExtremePacketLossTimer;
var AnimSet m_pVisionDeviceAnimSet;
var AnimNode m_pVisionDeviveAnimTree;
var array<R6SpawnableEmitter> m_aEmitterPool;
var array<ParticleSpriteSubUVEmitterInstance> m_aSpriteParticlePool;
var export editinline array<export editinline AudioComponent> m_AudioComponentPool;
var int m_iNbCivilsKilled;
var array<Object> m_apGameStatusListener;

function ToggleForceFireFightColorGel()
{
    m_bForceFireFightColorGel = !m_bForceFireFightColorGel;
    return;
}

function ToggleFireFightColorGel()
{
    m_bFireFightColorGelEnabled = !m_bFireFightColorGelEnabled;
    return;
}

// Export UR6GameManager::execGetLocalPlayer(FFrame&, void* const)
native function PlayerController GetLocalPlayer(optional int iPlayerIndex);

// Export UR6GameManager::execIsUsingGamePad(FFrame&, void* const)
native function bool IsUsingGamePad();

// Export UR6GameManager::execGetNextMissionURL(FFrame&, void* const)
native function string GetNextMissionURL();

// Export UR6GameManager::execSetNextMissionURL(FFrame&, void* const)
native function SetNextMissionURL(string fstrNextMissionURL);

// Export UR6GameManager::execAgoraStartMatch(FFrame&, void* const)
native function AgoraStartMatch();

// Export UR6GameManager::execAgoraEndMatch(FFrame&, void* const)
native function AgoraEndMatch();

// Export UR6GameManager::execCanPlayMapIntro(FFrame&, void* const)
native function bool CanPlayMapIntro();

defaultproperties
{
    m_bFireFightColorGelEnabled=true
    m_bWeaponChangeAcknowledged=true
    m_iLoadingProgressSteps=10
    m_pVisionDeviceAnimSet=AnimSet'Anims_Props_Gadgets_3rd.Goggles'
    m_pVisionDeviveAnimTree=AnimTree'AnimTreeGadgets.GogglesTree'
    m_GameModeInfo=/* Array type was not detected. */
    m_ConfigsManager=R6ConfigsManager'ConfigsManager.KellerConfigurations'
}