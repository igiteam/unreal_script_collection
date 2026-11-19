class SkyPhysicalMaterialProperty extends PhysicalMaterialPropertyBase
    native
    editinlinenew
    collapsecategories;

struct native MaterialImpactEffect
{
    var() name MaterialType;
    var() ParticleSystem ParticleTemplate;
    var() notforconsole const ParticleSystem PCParticleTemplate;
    var() float ParticleDrawScale;
    var() SoundCue Sound;
    var() MaterialInterface DecalMaterial;
    var float DecalWidth;
    var float DecalHeight;
    var() float DecalMinSize;
    var() float DecalMaxSize;
    var float DecalRotation;
    var() float DecalMinRotation;
    var() float DecalMaxRotation;
    var int SubImageIndex;
    var() int SubImages_Horizontal;
    var() int SubImages_Vertical;
    var() int SubImageMinIndex;
    var() int SubImageMaxIndex;
    var() float DecalLifeSpan;
    var() float FadeDistanceMin;
    var() float FadeDistanceMax;
    var() bool bKillOnMaxDistance;
    var() bool bOnlyIfDead;
    var() bool bLocalToHitPawn;
    var() bool bLooping;
    var() bool bLoopingSound;
    var() name PawnAttachBoneName;

    structdefaultproperties
    {
        MaterialType="None"
        ParticleTemplate=none
        PCParticleTemplate=none
        ParticleDrawScale=1.0000000
        Sound=none
        DecalMaterial=none
        DecalWidth=0.0000000
        DecalHeight=0.0000000
        DecalMinSize=10.0000000
        DecalMaxSize=10.0000000
        DecalRotation=0.0000000
        DecalMinRotation=0.0000000
        DecalMaxRotation=360.0000000
        SubImageIndex=0
        SubImages_Horizontal=1
        SubImages_Vertical=1
        SubImageMinIndex=0
        SubImageMaxIndex=0
        DecalLifeSpan=-1.0000000
        FadeDistanceMin=0.0000000
        FadeDistanceMax=0.0000000
        bKillOnMaxDistance=false
        bOnlyIfDead=false
        bLocalToHitPawn=false
        bLooping=false
        bLoopingSound=false
        PawnAttachBoneName="None"
    }
};

struct native MaterialSoundEffect
{
    var name MaterialType;
    var SoundCue Sound;

    structdefaultproperties
    {
        MaterialType="None"
        Sound=none
    }
};

struct native MaterialParticleEffect
{
    var name MaterialType;
    var ParticleSystem ParticleTemplate;

    structdefaultproperties
    {
        MaterialType="None"
        ParticleTemplate=none
    }
};

var() name MaterialType;
var() bool bFluid;
