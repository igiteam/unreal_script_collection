class R6BreakParams extends Object
    native
    editinlinenew
    hidecategories(Object);

enum EBreakOn
{
    EBreakOn_None,                  // 0
    EBreakOn_Bull,                  // 1
    EBreakOn_Expl,                  // 2
    EBreakOn_Bull_Expl,             // 3
    EBreakOn_Coll,                  // 4
    EBreakOn_Bull_Coll,             // 5
    EBreakOn_Expl_Coll,             // 6
    EBreakOn_Bull_Expl_Coll,        // 7
    EBreakOn_Fire,                  // 8
    EBreakOn_Bull_Fire,             // 9
    EBreakOn_Expl_Fire,             // 10
    EBreakOn_Bull_Expl_Fire,        // 11
    EBreakOn_Coll_Fire,             // 12
    EBreakOn_Bull_Coll_Fire,        // 13
    EBreakOn_Expl_Coll_Fire,        // 14
    EBreakOn_All,                   // 15
    EBreakOn_MAX                    // 16
};

var(BreakParams) float m_fLifePoints;
var(Actor) bool m_bFixed;
var(Actor) bool m_bBlockActors;
var(AI) bool m_bCover;
var(BreakParams) bool m_bSubPartBreaking;
var(BreakParams) bool m_bIsCentralForSubPartBreaking;
var(Actor) bool m_bDamagePawn;
var(BreakParams) bool m_bNoDamage;
var(Actor) float m_fMassScale;
var(BreakParams) float m_fExplosionImpulse;
var(BreakParams) float m_fExplosionRotation;
var(Actor) float m_fLifeTime;
var(BreakParams) float m_fCollision2DamageFactor;
var(Actor) array<byte> m_RenderBits;
var(BreakParams) array<MaterialInstance> m_aBreakMaterials;
var(BreakParams) /*0x80000000-0x00000000*/ noclear editinline array<editinline R6BreakParams> m_Children;
var(ParticleSystem) array<Vector> m_DestroyEffectPos;
var(Sound) /*0x04000000-0x00000000*/ array<SoundCue> m_DestroySound;
var(ParticleSystem) ParticleSystem m_DestroyEffect;
var(ParticleSystem) Vector m_CreateEffectPos;
var(ParticleSystem) Rotator m_CreateEffectRot;
var(ParticleSystem) ParticleSystem m_CreateEffect;
var(Sound) /*0x44000000-0x00000000*/ R6SoundMaterial m_pSoundMaterial;
var RB_BodySetup m_pBodySetup;
var array<int> m_aiConnectedTo;
var(ParticleSystem) editinline array<editinline ParticleSysParam> m_CreateEffectParameters;
var(ParticleSystem) editinline array<editinline ParticleSysParam> m_DestroyEffectParameters;
var(BreakParams) R6BreakParams.EBreakOn m_eBreakOn;

defaultproperties
{
    m_fLifePoints=100.0000000
    m_bBlockActors=true
    m_bCover=true
    m_bSubPartBreaking=true
    m_fMassScale=1.0000000
    m_fCollision2DamageFactor=0.0500000
    m_eBreakOn=11
}