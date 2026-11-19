class SeqAct_PlaySceneAnimation extends SeqAct_Latent
    native;

enum EToggleOptions
{
    ETO_Disable,                    // 0
    ETO_Enable,                     // 1
    ETO_LeaveAlone,                 // 2
    ETO_MAX                         // 3
};

struct native PlaySceneTeleportStruct
{
    var() bool m_bTeleport;
    var() bool m_bPrePivotAdjust;
    var() bool m_bUpdateRotation;

    structdefaultproperties
    {
        m_bTeleport=false
        m_bPrePivotAdjust=false
        m_bUpdateRotation=false
    }
};

struct native PlayScenePhysicsStruct
{
    var() bool m_bSetPhysics;
    var() Actor.EPhysics m_bOverridePhysics;

    structdefaultproperties
    {
        m_bSetPhysics=false
        m_bOverridePhysics=PHYS_None
    }
};

struct native PlaySceneTeleportAndOrientStruct
{
    var() bool m_bTeleportAndOrient;
    var() bool m_bUseMayaCoords;
    var() Vector m_position;
    var() Vector m_EulerRotation;

    structdefaultproperties
    {
        m_bTeleportAndOrient=false
        m_bUseMayaCoords=false
        m_position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_EulerRotation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

/** name of the animation to play */
var() name m_animSeqName;
/** how many times to play it (-1 to loop) */
var() int m_playCount;
/** wait for anim to finish before continuing */
var() bool m_bWaitForSceneToFinish;
var transient bool m_UnderAIControl;
var transient SPPawn m_TargetPawn;
var() SeqAct_PlaySceneAnimation.EToggleOptions m_bCollideWorld;
var() SeqAct_PlaySceneAnimation.EToggleOptions m_bCollideActors;
var() SeqAct_PlaySceneAnimation.EToggleOptions m_bBlockActors;
var() SeqAct_PlaySceneAnimation.EToggleOptions m_bPathColliding;
var() SeqAct_PlaySceneAnimation.EToggleOptions m_bEnableAI;
var() SeqAct_PlaySceneAnimation.EToggleOptions m_bTargettable;
var() SeqAct_PlaySceneAnimation.EToggleOptions m_bCollideProj;
var() PlaySceneTeleportStruct TeleportInfo;
var() PlaySceneTeleportAndOrientStruct TeleportAndOrientInfo;
var() PlayScenePhysicsStruct PhysicsInfo;
