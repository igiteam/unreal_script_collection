class R6VehicleTemplate extends PhysicsAsset
    native
    hidecategories(Object);

var(LifePoint) int m_iChassisLifePoint;
var(LifePoint) int m_iWheelLifePoint;
var(LifePoint) int m_iDoorLifePoint;
var(LifePoint) int m_iDetailLifePoint;
var(fX) float m_fDestroyChassisSpeed;
var(fX) ParticleSystem m_DestroyChassisEffect;
var(fX) ParticleSystem m_DestroyWheelEffect;
var(fX) ParticleSystem m_DestroyDoorEffect;
var(fX) ParticleSystem m_DestroyDetailEffect;
var(fX) ParticleSystem m_BlownEngineEffect;
var(fX) array<MaterialInstance> m_aDestroyMaterials;
var(Bump) float BumpImpulse;
var(Bump) float BumpImpulseZOffset;
var(Bump) float BumpImpulseMaxSpeed;
var int m_iBrokenMesh;
var() Vector m_aWheelRestPos[4];
var() bool m_bKeepLocation;
var() bool m_bKeepYaw;
var(Sound) /*0x04000000-0x00000000*/ SoundCue m_pExplosionSound;
var(Sound) /*0x04000000-0x00000000*/ SoundCue m_pChassisImpactSound;
var(Sound) /*0x04000000-0x00000000*/ SoundCue m_pShockAbsorberSound;
var(Sound) /*0x04000000-0x00000000*/ SoundCue m_pWindowBreakSound;
var(Sound) /*0x04000000-0x00000000*/ SoundCue m_pDoorBreakSound;
var(Sound) /*0x04000000-0x00000000*/ SoundCue m_pDoorSmallImpactSound;
var(Sound) /*0x04000000-0x00000000*/ SoundCue m_pDoorBigImpactSound;

defaultproperties
{
    m_iChassisLifePoint=400
    m_iWheelLifePoint=100
    m_iDoorLifePoint=100
    m_iDetailLifePoint=50
    m_fDestroyChassisSpeed=1000.0000000
    BumpImpulse=100.0000000
    BumpImpulseMaxSpeed=1000.0000000
    m_iBrokenMesh=-1
}