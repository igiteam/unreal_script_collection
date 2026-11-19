class R6_BreakableActorTemplate extends Object
    native;

var() /*0x80000000-0x00000000*/ noclear editinline R6BreakParams m_Root;
var() editconstarray array<MaterialInstance> m_Materials;
var() /*0x44000000-0x00000000*/ R6SoundMaterial m_pSoundMaterial;
var() /*0x40000000-0x00000000*/ PhysicalMaterial m_pPhysMaterial;
var() bool m_bHasBulletAttractor;
var(Explosion) /*0x40000000-0x00000000*/ R6ExplosionParams m_pExplosionParams;
var(Explosion) /*0x44000000-0x00000000*/ R6SoundExplosionParams m_pExplosionSoundParams;
var() R6_BreakableActorTemplate m_pInheritFrom;
var array<string> m_PartNames;
var array<StaticMesh> m_StaticMeshes;
