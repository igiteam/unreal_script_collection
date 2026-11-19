class EvilPhysicalMaterialPropertyBase extends PhysicalMaterialPropertyBase
    abstract
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

struct EvilMinMax
{
    var() float MinScale;
    var() float MaxScale;

    structdefaultproperties
    {
        MinScale=1.0000000
        MaxScale=1.0000000
    }
};

struct native ImpactFXBase
{
    var() editinline array<editinline DecalData> DecalData;
    var() bool bIgnoreParentDecal;
    var() editinline array<editinline DecalData> DecalData_NoGore;
    var() SoundCue ImpactCue;
    var() bool bIgnoreParentImpactCue;
    var() SoundCue ImpactPlayerCue;
    var() array<ParticleSystem> ImpactPS;
    var() array<EvilMinMax> ImpactPSScale;
    var() bool bIgnoreParentImpactPS;
    var() ParticleSystem ImpactPS_ForSlowPerf;
    var() array<ParticleSystem> ImpactPS_NoGore;
    var() ParticleSystem ImpactPS_NoGore_ForSlowPerf;
    var() class<EmitterCameraLensEffectBase> CameraEffect;
    var() float CameraEffectRadius;

    structdefaultproperties
    {
        DecalData=none
        bIgnoreParentDecal=false
        DecalData_NoGore=none
        ImpactCue=none
        bIgnoreParentImpactCue=false
        ImpactPlayerCue=none
        ImpactPS=none
        ImpactPSScale=none
        bIgnoreParentImpactPS=false
        ImpactPS_ForSlowPerf=none
        ImpactPS_NoGore=none
        ImpactPS_NoGore_ForSlowPerf=none
        CameraEffect=none
        CameraEffectRadius=800.0000000
    }
};

struct native FootStepsDatumBase
{
    var() SoundCue FootStep;
    var() SoundCue FootStep3P;
    var() SoundCue CrouchFootStep;
    var() SoundCue Landing;
    var() SoundCue Leaping;
    var() SoundCue Crouching;
    var() SoundCue CrouchingEnd;
    var() SoundCue Sliding;
    var() ParticleSystem FootstepEffectPS;

    structdefaultproperties
    {
        FootStep=none
        FootStep3P=none
        CrouchFootStep=none
        Landing=none
        Leaping=none
        Crouching=none
        CrouchingEnd=none
        Sliding=none
        FootstepEffectPS=none
    }
};

var int Version;
var(FootSteps) ParticleSystem FootstepEffectWalk;
var(FootSteps) ParticleSystem FootstepEffectRun;
var(Dust) ParticleSystem RoadieRun;
var(Dust) ParticleSystem EvadeEffect;
var() class<EmitterCameraLensEffectBase> EvadeCameraLensEffect;
var(Dust) ParticleSystem SlideIntoCoverEffect;
var(Dust) ParticleSystem SlideIntoCoverNonPlayerEffect;
var() class<EmitterCameraLensEffectBase> SlideIntoCoverCameraLensEffect;
var() float PassThroughDamping;

static final simulated function PhysicalMaterial GetImpactPhysicalMaterial(const out ImpactInfo Impact)
{
    local PhysicalMaterial PhysMaterial;

    // End:0x71
    if(Impact.HitInfo.PhysMaterial != none)
    {
        PhysMaterial = Impact.HitInfo.PhysMaterial;        
    }
    else
    {
        // End:0x21C
        if(((StaticMeshComponent(Impact.HitInfo.HitComponent) != none) && StaticMeshComponent(Impact.HitInfo.HitComponent).StaticMesh.BodySetup != none) && StaticMeshComponent(Impact.HitInfo.HitComponent).StaticMesh.BodySetup.PhysMaterial != none)
        {
            PhysMaterial = StaticMeshComponent(Impact.HitInfo.HitComponent).StaticMesh.BodySetup.PhysMaterial;            
        }
        else
        {
            // End:0x29F
            if(Impact.HitInfo.Material != none)
            {
                PhysMaterial = Impact.HitInfo.Material.PhysMaterial;
            }
        }
    }
    // End:0x2C1
    if(PhysMaterial == none)
    {
        PhysMaterial = PhysicalMaterial'pm_materials.PM_Default';
    }
    return PhysMaterial;
    //return ReturnValue;    
}

static final simulated function PhysicalMaterial GetImpactPhysicalMaterialHitInfo(const out TraceHitInfo HitInfo)
{
    local PhysicalMaterial PhysMaterial;

    // End:0x4B
    if(HitInfo.PhysMaterial != none)
    {
        PhysMaterial = HitInfo.PhysMaterial;        
    }
    else
    {
        // End:0x1AA
        if(((StaticMeshComponent(HitInfo.HitComponent) != none) && StaticMeshComponent(HitInfo.HitComponent).StaticMesh.BodySetup != none) && StaticMeshComponent(HitInfo.HitComponent).StaticMesh.BodySetup.PhysMaterial != none)
        {
            PhysMaterial = StaticMeshComponent(HitInfo.HitComponent).StaticMesh.BodySetup.PhysMaterial;            
        }
        else
        {
            // End:0x207
            if(HitInfo.Material != none)
            {
                PhysMaterial = HitInfo.Material.PhysMaterial;
            }
        }
    }
    // End:0x229
    if(PhysMaterial == none)
    {
        PhysMaterial = PhysicalMaterial'pm_materials.PM_Default';
    }
    return PhysMaterial;
    //return ReturnValue;    
}

static simulated function DecalData DetermineImpactDecalData(PhysicalMaterial PhysMaterial, const class<EvilDmgType_Base> dmgType, const out WorldInfo WorldInfo, const Pawn Instigator)
{
    local DecalData DecalData;

    return DecalData;
    //return ReturnValue;    
}

static simulated function SoundCue DetermineImpactSound(PhysicalMaterial PhysMaterial, const class<EvilDmgType_Base> dmgType, const out WorldInfo WorldInfo, bool bPlayerIsInstigator)
{
    return none;
    //return ReturnValue;    
}

static simulated function FogVolumeSphericalDensityInfo DetermineFogVolumeArchetype(PhysicalMaterial PhysMaterial, const class<EvilDmgType_Base> dmgType, const out WorldInfo WorldInfo)
{
    return none;
    //return ReturnValue;    
}

static simulated function class<EmitterCameraLensEffectBase> DetermineImpactCameraEffect(PhysicalMaterial PhysMaterial, const class<EvilDmgType_Base> dmgType, const out WorldInfo WorldInfo, out float Radius)
{
    return none;
    //return ReturnValue;    
}

static simulated function ParticleSystem DetermineImpactParticleSystem(PhysicalMaterial PhysMaterial, const class<EvilDmgType_Base> dmgType, const out WorldInfo WorldInfo, const Pawn Instigator, out float ParticleScale, optional bool bSkipDefaults)
{
    return none;
    //return ReturnValue;    
}

static simulated function SoundCue DetermineFootStepSound(PhysicalMaterial PhysMaterial, EvilPawn Pawn, const out WorldInfo WorldInfo, bool bPawnIsCrouched)
{
    return none;
    //return ReturnValue;    
}

static simulated function SoundCue DetermineSlidingSound(PhysicalMaterial PhysMaterial, EvilPawn Pawn, const out WorldInfo WorldInfo)
{
    return none;
    //return ReturnValue;    
}

static simulated function SoundCue DetermineLandingSound(PhysicalMaterial PhysMaterial, EvilPawn Pawn, const out WorldInfo WorldInfo)
{
    return none;
    //return ReturnValue;    
}

static simulated function SoundCue DetermineLeapingSound(PhysicalMaterial PhysMaterial, EvilPawn Pawn, const out WorldInfo WorldInfo)
{
    return none;
    //return ReturnValue;    
}

static simulated function SoundCue DetermineCrouchingSound(PhysicalMaterial PhysMaterial, EvilPawn Pawn, const out WorldInfo WorldInfo)
{
    return none;
    //return ReturnValue;    
}

static simulated function SoundCue DetermineCrouchingEndSound(PhysicalMaterial PhysMaterial, EvilPawn Pawn, const out WorldInfo WorldInfo)
{
    return none;
    //return ReturnValue;    
}

defaultproperties
{
    PassThroughDamping=1.0000000
}