class SeqAct_EndSceneAnimation extends SequenceAction;

struct native EndScenePhysicsStruct
{
    var() bool m_bSetPhysics;
    var() Actor.EPhysics m_bOverridePhysics;

    structdefaultproperties
    {
        m_bSetPhysics=false
        m_bOverridePhysics=PHYS_None
    }
};

/** Variable Declaration */
var() SeqAct_PlaySceneAnimation.EToggleOptions m_bCollideWorld;
var() SeqAct_PlaySceneAnimation.EToggleOptions m_bCollideActors;
var() SeqAct_PlaySceneAnimation.EToggleOptions m_bBlockActors;
var() SeqAct_PlaySceneAnimation.EToggleOptions m_bPathColliding;
var() SeqAct_PlaySceneAnimation.EToggleOptions m_bEnableAI;
var() SeqAct_PlaySceneAnimation.EToggleOptions m_bTargettable;
var() SeqAct_PlaySceneAnimation.EToggleOptions m_bCollideProj;
var() EndScenePhysicsStruct PhysicsInfo;
