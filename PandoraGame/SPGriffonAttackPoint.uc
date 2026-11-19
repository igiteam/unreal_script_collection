class SPGriffonAttackPoint extends Actor
    native
    placeable;

enum EGriffonAttackPointPoseType
{
    egappNone,                      // 0
    egappNormal,                    // 1
    egappWall,                      // 2
    egappWindow,                    // 3
    egappHover,                     // 4
    EGriffonAttackPointPoseType_MAX // 5
};

struct native AttackPointPerVolumeProperties
{
    var() SPGriffonAttackPointVolume m_AttackVolume;
    var() name m_AnimNameAttack;
    var() name m_AnimNameBlockedAttack;
    var() name m_AnimNameUnblockedIdle;
    var() name m_AnimNameBlockedIdle;
    var() name m_AnimNameDeath;
    var() int m_iNumTimesToFireEvent;
    var() name m_EventName;
    var() array<Actor> m_DestructibleActors;
    var int m_iNumTimesEventFired;
    var() SPGriffonAttackPoint.EGriffonAttackPointPoseType m_ePoseType;
    var() bool m_bAllowAutoOrientingToPlayer;

    structdefaultproperties
    {
        m_AttackVolume=none
        m_AnimNameAttack="AttackForward"
        m_AnimNameBlockedAttack="AttackForward"
        m_AnimNameUnblockedIdle="DefaultUnblocked"
        m_AnimNameBlockedIdle="DefaultBlocked"
        m_AnimNameDeath="DefaultDeath"
        m_iNumTimesToFireEvent=0
        m_EventName="None"
        m_DestructibleActors=none
        m_iNumTimesEventFired=0
        m_ePoseType=egappNone
        m_bAllowAutoOrientingToPlayer=false
    }
};

/** VARIABLE DECLARATIONS */
var() array<AttackPointPerVolumeProperties> m_VolumeProperties;
var() bool m_bEnabled;

// Export USPGriffonAttackPoint::execFireEvent(FFrame&, void* const)
native function FireEvent(int iVolumeIndex);

event bool IsDestructibleDestroyed(int iVolumeIndex)
{
    local editinline SPActorDestructComponent kDestructComponent;
    local bool bDestroyed;
    local int I;

    bDestroyed = true;
    // End:0xC8
    if(m_VolumeProperties[iVolumeIndex].m_DestructibleActors.Length > 0)
    {
        I = 0;
        J0x2C:

        // End:0xC8 [Loop If]
        if(I < m_VolumeProperties[iVolumeIndex].m_DestructibleActors.Length)
        {
            // End:0xBE
            if(m_VolumeProperties[iVolumeIndex].m_DestructibleActors[I] != none)
            {
                kDestructComponent = SPActorDestructComponent(m_VolumeProperties[iVolumeIndex].m_DestructibleActors[I].GetActorDestructComponent());
                // End:0xBE
                if(kDestructComponent.HitPoints > 0)
                {
                    bDestroyed = false;
                }
            }
            I++;
            // [Loop Continue]
            goto J0x2C;
        }
    }
    return bDestroyed;
    //return ReturnValue;    
}
