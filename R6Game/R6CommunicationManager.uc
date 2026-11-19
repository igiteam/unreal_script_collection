class R6CommunicationManager extends Object
    native;

struct TeamMessage
{
    var array<R6EngineEnums.ECommunicationTeamMessageType> ArrayMessageType;
    var Actor.ETacticType TacticType;
    var Actor pActor;
    var Vector vActorLocation;

    structdefaultproperties
    {
        ArrayMessageType=none
        TacticType=0
        pActor=none
        vActorLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct Communication
{
    var R6EngineEnums.ECommunicationTeamMessageType eMessageType;
    var int eVoiceBankType;
    var R6EngineEnums.ECommunicationMethod eCommMethod;
    var array<R6Pawn> ArrayPawnsTo;
    var R6Pawn pOptionalPawnData;
    var array<R6Pawn> ArrayNextCommunicators;
    var float fRequestTimeStamp;
    var int iCommPriority;
    var R6EngineEnums.ECommunicationState eCommState;
    var R6EngineEnums.ECommunicationType eCommType;
    var TeamMessage TeamMessage;
    var SoundCue pSoundCue;
    var R6Goal_Ptr pGoalToEventuallyStop;
    var native MultiMap_Mirror mapGesture;

    structdefaultproperties
    {
        eMessageType=0
        eVoiceBankType=0
        eCommMethod=0
        ArrayPawnsTo=none
        pOptionalPawnData=none
        ArrayNextCommunicators=none
        fRequestTimeStamp=0.0000000
        iCommPriority=0
        eCommState=0
        eCommType=0
        TeamMessage=(ArrayMessageType=none,TacticType=0,pActor=none,vActorLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        pSoundCue=none
        pGoalToEventuallyStop=(I=none)
    }
};

struct MakeNoiseRequirement
{
    var R6Pawn pNoisyPawn;
    var Actor.AIEventType eAIEventType;

    structdefaultproperties
    {
        pNoisyPawn=none
        eAIEventType=0
    }
};

var private native const noexport Pointer VfTable_FTickableObject;
var native MultiMap_Mirror m_Communications;
var array<R6Pawn> m_PawnOutOfConversation;
var array<MakeNoiseRequirement> m_MakeNoiseList;
var float m_fTimerTactic;
var float m_fTimerToExitChopper;
var float m_fLostTimerTerrorists;
var float m_fLostTimerRainbows;
var float m_fLastKillBulletTime;
var float m_fLastKillExplosionTime;
var float m_fTimeMultipleHostages;
var float m_fTimeNeutralSpottedFrequency;
var float m_fTimeMultipleEnemies;
var float m_fTimerHostageShot;
var float m_fTimerMoveOutOfTheWayChopper;
var float m_fTimerHostageInTheWay;
var float m_fTimerHostagePanicBullet;
var float m_fTimerHostagePanicHiding;
var float m_fTimerRainbowAIBlocked;
