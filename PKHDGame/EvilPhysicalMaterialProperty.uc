class EvilPhysicalMaterialProperty extends EvilPhysicalMaterialPropertyBase
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

struct native ImpactFXBallistic extends ImpactFXBase
{
    var() EvilTypes.EImpactTypeBallistic Type;
    var() ParticleSystem ExitWoundPS;
    var() ParticleSystem ExitWoundPS_ForSlowPerf;

    structdefaultproperties
    {
        CameraEffectRadius=0.0000000
    }
};

struct native ImpactFXExplosion extends ImpactFXBase
{
    var() EvilTypes.EImpactTypeExplosion Type;
    var() Object FogVolumeArchetype;
    var() Object FogVolumeArchetype_ForSlowPerf;

    structdefaultproperties
    {
        CameraEffectRadius=0.0000000
    }
};

struct native FootStepsDatum extends FootStepsDatumBase
{
    var() EvilTypes.ECharacterFootStepType Type;
};

var() editinline ImpactFXBallistic DefaultFXInfoBallistic;
var() editinline ImpactFXExplosion DefaultFXInfoExplosion;
var() editinline array<editinline ImpactFXBallistic> FXInfoBallistic;
var() editinline array<editinline ImpactFXExplosion> FXInfoExplosion;
var(FootSteps) editinline array<editinline FootStepsDatum> FootStepInfo;
var() bool bSuppressNonGoreStuff;

static simulated function DecalData DetermineImpactDecalData(PhysicalMaterial PhysMaterial, const class<EvilDmgType_Base> dmgType, const out WorldInfo WorldInfo, const Pawn Instigator)
{
    local DecalData DecalData;
    local EvilPhysicalMaterialProperty PhysMatProp;
    local bool bShouldShowGore;

    // End:0x19
    if(dmgType == none)
    {
        return DecalData;
    }
    // End:0x77
    if((int(dmgType.default.ImpactTypeBallisticID) == int(0)) && int(dmgType.default.ImpactTypeExplosionID) == int(0))
    {
        return DecalData;
    }
    bShouldShowGore = WorldInfo.GRI.ShouldShowGore();
    J0xB6:

    // End:0x63F [Loop If]
    if(!DecalData.bIsValid && PhysMaterial != none)
    {
        PhysMatProp = EvilPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
        // End:0x614
        if(PhysMatProp != none)
        {
            // End:0x200
            if(((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].bIgnoreParentDecal : PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].bIgnoreParentDecal))
            {
                // [Explicit Break]
                goto J0x63F;
            }
            // End:0x407
            if((bShouldShowGore == true) || PhysMatProp.bSuppressNonGoreStuff)
            {
                DecalData = Class'EvilDecal'.static.GetRandomDecalMaterial(((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].DecalData : PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].DecalData));
                // End:0x404
                if(DecalData.DecalMaterial == none)
                {
                    DecalData = Class'EvilDecal'.static.GetRandomDecalMaterial(((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.DefaultFXInfoBallistic.DecalData : PhysMatProp.DefaultFXInfoExplosion.DecalData));
                }                
            }
            else
            {
                DecalData = Class'EvilDecal'.static.GetRandomDecalMaterial(((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].DecalData : PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].DecalData_NoGore));
                // End:0x5D7
                if(DecalData.DecalMaterial == none)
                {
                    DecalData = Class'EvilDecal'.static.GetRandomDecalMaterial(((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.DefaultFXInfoBallistic.DecalData_NoGore : PhysMatProp.DefaultFXInfoExplosion.DecalData_NoGore));
                }
            }
            DecalData.bIsValid = DecalData.DecalMaterial != none;
        }
        PhysMaterial = PhysMaterial.Parent;
        // [Loop Continue]
        goto J0xB6;
    }
    J0x63F:

    return DecalData;
    //return ReturnValue;    
}

static simulated function SoundCue DetermineImpactSound(PhysicalMaterial PhysMaterial, const class<EvilDmgType_Base> dmgType, const out WorldInfo WorldInfo)
{
    local SoundCue ImpactCue;
    local EvilPhysicalMaterialProperty PhysMatProp;

    // End:0x11
    if(dmgType == none)
    {
        return none;
    }
    // End:0x67
    if((int(dmgType.default.ImpactTypeBallisticID) == int(0)) && int(dmgType.default.ImpactTypeExplosionID) == int(0))
    {
        return none;
    }
    J0x67:

    // End:0x348 [Loop If]
    if((ImpactCue == none) && PhysMaterial != none)
    {
        PhysMatProp = EvilPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
        // End:0x31D
        if(PhysMatProp != none)
        {
            ImpactCue = ((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].ImpactCue : PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].ImpactCue);
            // End:0x246
            if(ImpactCue == none)
            {
                ImpactCue = ((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.DefaultFXInfoBallistic.ImpactCue : PhysMatProp.DefaultFXInfoExplosion.ImpactCue);
            }
            // End:0x31D
            if(((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].bIgnoreParentImpactCue : PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].bIgnoreParentImpactCue))
            {
                // [Explicit Break]
                goto J0x348;
            }
        }
        PhysMaterial = PhysMaterial.Parent;
        // [Loop Continue]
        goto J0x67;
    }
    J0x348:

    return ImpactCue;
    //return ReturnValue;    
}

static simulated function FogVolumeSphericalDensityInfo DetermineFogVolumeArchetype(PhysicalMaterial PhysMaterial, const class<EvilDmgType_Base> dmgType, const out WorldInfo WorldInfo)
{
    local FogVolumeSphericalDensityInfo Retval;
    local EvilPhysicalMaterialProperty PhysMatProp;

    J0x00:
    // End:0x143 [Loop If]
    if((Retval == none) && PhysMaterial != none)
    {
        PhysMatProp = EvilPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
        // End:0x118
        if(PhysMatProp != none)
        {
            Retval = FogVolumeSphericalDensityInfo(PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].FogVolumeArchetype);
            // End:0x118
            if(Retval == none)
            {
                Retval = FogVolumeSphericalDensityInfo(PhysMatProp.DefaultFXInfoExplosion.FogVolumeArchetype);
            }
        }
        PhysMaterial = PhysMaterial.Parent;
        // [Loop Continue]
        goto J0x00;
    }
    return Retval;
    //return ReturnValue;    
}

static simulated function class<EmitterCameraLensEffectBase> DetermineImpactCameraEffect(PhysicalMaterial PhysMaterial, const class<EvilDmgType_Base> dmgType, const out WorldInfo WorldInfo, out float Radius)
{
    local class<EmitterCameraLensEffectBase> Retval;
    local EvilPhysicalMaterialProperty PhysMatProp;

    // End:0x11
    if(dmgType == none)
    {
        return none;
    }
    // End:0x6F
    if((int(dmgType.default.ImpactTypeBallisticID) == int(0)) && int(dmgType.default.ImpactTypeExplosionID) == int(0))
    {
        return Retval;
    }
    J0x6F:

    // End:0x3E9 [Loop If]
    if((Retval == none) && PhysMaterial != none)
    {
        PhysMatProp = EvilPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
        // End:0x3BE
        if(PhysMatProp != none)
        {
            Retval = ((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].CameraEffect : PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].CameraEffect);
            Radius = ((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].CameraEffectRadius : PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].CameraEffectRadius);
            // End:0x3BE
            if(Retval == none)
            {
                Retval = ((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.DefaultFXInfoBallistic.CameraEffect : PhysMatProp.DefaultFXInfoExplosion.CameraEffect);
                Radius = ((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.DefaultFXInfoBallistic.CameraEffectRadius : PhysMatProp.DefaultFXInfoExplosion.CameraEffectRadius);
            }
        }
        PhysMaterial = PhysMaterial.Parent;
        // [Loop Continue]
        goto J0x6F;
    }
    return Retval;
    //return ReturnValue;    
}

static simulated function ParticleSystem DetermineImpactParticleSystem(PhysicalMaterial PhysMaterial, const class<EvilDmgType_Base> dmgType, const out WorldInfo WorldInfo, const Pawn Instigator, out float ParticleScale, optional bool bSkipDefaults)
{
    local EvilPhysicalMaterialProperty PhysMatProp;
    local ParticleSystem ImpactPS;
    local int RandIndex;
    local bool bShouldShowGore, bShouldDisableEffectDueToFramerate;

    // End:0x12
    if(dmgType == none)
    {
        return none;
    }
    ParticleScale = 1.0000000;
    // End:0x77
    if((int(dmgType.default.ImpactTypeBallisticID) == int(0)) && int(dmgType.default.ImpactTypeExplosionID) == int(0))
    {
        return none;
    }
    bShouldShowGore = WorldInfo.GRI.ShouldShowGore();
    bShouldDisableEffectDueToFramerate = false;
    J0xC2:

    // End:0x12B9 [Loop If]
    if((ImpactPS == none) && PhysMaterial != none)
    {
        PhysMatProp = EvilPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
        // End:0x128E
        if(PhysMatProp != none)
        {
            // End:0xBCB
            if((bShouldShowGore == true) || PhysMatProp.bSuppressNonGoreStuff)
            {
                // End:0x305
                if(bShouldDisableEffectDueToFramerate == true)
                {
                    // End:0x305
                    if(ImpactPS == none)
                    {
                        ImpactPS = ((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].ImpactPS_ForSlowPerf : PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].ImpactPS_ForSlowPerf);
                        // End:0x305
                        if((ImpactPS == none) && !bSkipDefaults)
                        {
                            ImpactPS = ((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.DefaultFXInfoBallistic.ImpactPS_ForSlowPerf : PhysMatProp.DefaultFXInfoExplosion.ImpactPS_ForSlowPerf);
                        }
                    }
                }
                // End:0xBC8
                if(ImpactPS == none)
                {
                    // End:0x5B3
                    if((int(dmgType.default.ImpactTypeBallisticID) != int(0)) && PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].ImpactPS.Length > 0)
                    {
                        RandIndex = Rand(PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].ImpactPS.Length);
                        ImpactPS = PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].ImpactPS[RandIndex];
                        // End:0x5B0
                        if(PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].ImpactPSScale.Length > RandIndex)
                        {
                            ParticleScale = RandRange(PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].ImpactPSScale[RandIndex].MinScale, PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].ImpactPSScale[RandIndex].MaxScale);
                        }                        
                    }
                    else
                    {
                        // End:0x824
                        if(PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].ImpactPS.Length > 0)
                        {
                            RandIndex = Rand(PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].ImpactPS.Length);
                            ImpactPS = PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].ImpactPS[RandIndex];
                            // End:0x824
                            if(PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].ImpactPSScale.Length > RandIndex)
                            {
                                ParticleScale = RandRange(PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].ImpactPSScale[RandIndex].MinScale, PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].ImpactPSScale[RandIndex].MaxScale);
                            }
                        }
                    }
                    // End:0xBC8
                    if((ImpactPS == none) && !bSkipDefaults)
                    {
                        // End:0xA1D
                        if((int(dmgType.default.ImpactTypeBallisticID) != int(0)) && PhysMatProp.DefaultFXInfoBallistic.ImpactPS.Length > 0)
                        {
                            RandIndex = Rand(PhysMatProp.DefaultFXInfoBallistic.ImpactPS.Length);
                            ImpactPS = PhysMatProp.DefaultFXInfoBallistic.ImpactPS[RandIndex];
                            // End:0xA1A
                            if(PhysMatProp.DefaultFXInfoBallistic.ImpactPSScale.Length > RandIndex)
                            {
                                ParticleScale = RandRange(PhysMatProp.DefaultFXInfoBallistic.ImpactPSScale[RandIndex].MinScale, PhysMatProp.DefaultFXInfoBallistic.ImpactPSScale[RandIndex].MaxScale);
                            }                            
                        }
                        else
                        {
                            // End:0xBC8
                            if(PhysMatProp.DefaultFXInfoExplosion.ImpactPS.Length > 0)
                            {
                                RandIndex = Rand(PhysMatProp.DefaultFXInfoExplosion.ImpactPS.Length);
                                ImpactPS = PhysMatProp.DefaultFXInfoExplosion.ImpactPS[RandIndex];
                                // End:0xBC8
                                if(PhysMatProp.DefaultFXInfoExplosion.ImpactPSScale.Length > RandIndex)
                                {
                                    ParticleScale = RandRange(PhysMatProp.DefaultFXInfoExplosion.ImpactPSScale[RandIndex].MinScale, PhysMatProp.DefaultFXInfoExplosion.ImpactPSScale[RandIndex].MaxScale);
                                }
                            }
                        }
                    }
                }                
            }
            else
            {
                // End:0xD7A
                if(bShouldDisableEffectDueToFramerate == true)
                {
                    // End:0xD7A
                    if(ImpactPS == none)
                    {
                        ImpactPS = ((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].ImpactPS_NoGore_ForSlowPerf : PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].ImpactPS_NoGore_ForSlowPerf);
                        // End:0xD7A
                        if((ImpactPS == none) && !bSkipDefaults)
                        {
                            ImpactPS = ((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.DefaultFXInfoBallistic.ImpactPS_NoGore_ForSlowPerf : PhysMatProp.DefaultFXInfoExplosion.ImpactPS_NoGore_ForSlowPerf);
                        }
                    }
                }
                // End:0x11B7
                if(ImpactPS == none)
                {
                    // End:0xED5
                    if((int(dmgType.default.ImpactTypeBallisticID) != int(0)) && PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].ImpactPS_NoGore.Length > 0)
                    {
                        RandIndex = Rand(PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].ImpactPS_NoGore.Length);
                        ImpactPS = PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].ImpactPS_NoGore[RandIndex];                        
                    }
                    else
                    {
                        // End:0xFF3
                        if(PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].ImpactPS_NoGore.Length > 0)
                        {
                            RandIndex = Rand(PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].ImpactPS_NoGore.Length);
                            ImpactPS = PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].ImpactPS_NoGore[RandIndex];
                        }
                    }
                    // End:0x11B7
                    if((ImpactPS == none) && !bSkipDefaults)
                    {
                        // End:0x10FC
                        if((int(dmgType.default.ImpactTypeBallisticID) != int(0)) && PhysMatProp.DefaultFXInfoBallistic.ImpactPS_NoGore.Length > 0)
                        {
                            RandIndex = Rand(PhysMatProp.DefaultFXInfoBallistic.ImpactPS_NoGore.Length);
                            ImpactPS = PhysMatProp.DefaultFXInfoBallistic.ImpactPS_NoGore[RandIndex];                            
                        }
                        else
                        {
                            // End:0x11B7
                            if(PhysMatProp.DefaultFXInfoExplosion.ImpactPS_NoGore.Length > 0)
                            {
                                RandIndex = Rand(PhysMatProp.DefaultFXInfoExplosion.ImpactPS_NoGore.Length);
                                ImpactPS = PhysMatProp.DefaultFXInfoExplosion.ImpactPS_NoGore[RandIndex];
                            }
                        }
                    }
                }
            }
            // End:0x128E
            if(((int(dmgType.default.ImpactTypeBallisticID) != int(0)) ? PhysMatProp.FXInfoBallistic[int(dmgType.default.ImpactTypeBallisticID)].bIgnoreParentImpactPS : PhysMatProp.FXInfoExplosion[int(dmgType.default.ImpactTypeExplosionID)].bIgnoreParentImpactPS))
            {
                // [Explicit Break]
                goto J0x12B9;
            }
        }
        PhysMaterial = PhysMaterial.Parent;
        // [Loop Continue]
        goto J0xC2;
    }
    J0x12B9:

    return ImpactPS;
    //return ReturnValue;    
}

static simulated function SoundCue DetermineFootStepSound(PhysicalMaterial PhysMaterial, EvilPawn Pawn, const out WorldInfo WorldInfo)
{
    local SoundCue ImpactCue;
    local EvilPhysicalMaterialProperty PhysMatProp;

    J0x00:
    // End:0xE7 [Loop If]
    if((ImpactCue == none) && PhysMaterial != none)
    {
        PhysMatProp = EvilPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
        // End:0xBC
        if(PhysMatProp != none)
        {
            ImpactCue = PhysMatProp.FootStepInfo[int(Pawn.CharacterFootStepType)].FootStep;
        }
        PhysMaterial = PhysMaterial.Parent;
        // [Loop Continue]
        goto J0x00;
    }
    return ImpactCue;
    //return ReturnValue;    
}

static simulated function SoundCue DetermineSlidingSound(PhysicalMaterial PhysMaterial, EvilPawn Pawn, const out WorldInfo WorldInfo)
{
    local SoundCue ImpactCue;
    local EvilPhysicalMaterialProperty PhysMatProp;

    J0x00:
    // End:0xE7 [Loop If]
    if((ImpactCue == none) && PhysMaterial != none)
    {
        PhysMatProp = EvilPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
        // End:0xBC
        if(PhysMatProp != none)
        {
            ImpactCue = PhysMatProp.FootStepInfo[int(Pawn.CharacterFootStepType)].Sliding;
        }
        PhysMaterial = PhysMaterial.Parent;
        // [Loop Continue]
        goto J0x00;
    }
    return ImpactCue;
    //return ReturnValue;    
}

static simulated function SoundCue DetermineLandingSound(PhysicalMaterial PhysMaterial, EvilPawn Pawn, const out WorldInfo WorldInfo)
{
    local SoundCue ImpactCue;
    local EvilPhysicalMaterialProperty PhysMatProp;

    J0x00:
    // End:0xE7 [Loop If]
    if((ImpactCue == none) && PhysMaterial != none)
    {
        PhysMatProp = EvilPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
        // End:0xBC
        if(PhysMatProp != none)
        {
            ImpactCue = PhysMatProp.FootStepInfo[int(Pawn.CharacterFootStepType)].Landing;
        }
        PhysMaterial = PhysMaterial.Parent;
        // [Loop Continue]
        goto J0x00;
    }
    return ImpactCue;
    //return ReturnValue;    
}

static simulated function SoundCue DetermineLeapingSound(PhysicalMaterial PhysMaterial, EvilPawn Pawn, const out WorldInfo WorldInfo)
{
    local SoundCue ImpactCue;
    local EvilPhysicalMaterialProperty PhysMatProp;

    J0x00:
    // End:0xE7 [Loop If]
    if((ImpactCue == none) && PhysMaterial != none)
    {
        PhysMatProp = EvilPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
        // End:0xBC
        if(PhysMatProp != none)
        {
            ImpactCue = PhysMatProp.FootStepInfo[int(Pawn.CharacterFootStepType)].Leaping;
        }
        PhysMaterial = PhysMaterial.Parent;
        // [Loop Continue]
        goto J0x00;
    }
    return ImpactCue;
    //return ReturnValue;    
}

static simulated function SoundCue DetermineCrouchingSound(PhysicalMaterial PhysMaterial, EvilPawn Pawn, const out WorldInfo WorldInfo)
{
    local SoundCue ImpactCue;
    local EvilPhysicalMaterialProperty PhysMatProp;

    J0x00:
    // End:0xE7 [Loop If]
    if((ImpactCue == none) && PhysMaterial != none)
    {
        PhysMatProp = EvilPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
        // End:0xBC
        if(PhysMatProp != none)
        {
            ImpactCue = PhysMatProp.FootStepInfo[int(Pawn.CharacterFootStepType)].Crouching;
        }
        PhysMaterial = PhysMaterial.Parent;
        // [Loop Continue]
        goto J0x00;
    }
    return ImpactCue;
    //return ReturnValue;    
}

static simulated function SoundCue DetermineCrouchingEndSound(PhysicalMaterial PhysMaterial, EvilPawn Pawn, const out WorldInfo WorldInfo)
{
    local SoundCue ImpactCue;
    local EvilPhysicalMaterialProperty PhysMatProp;

    J0x00:
    // End:0xE7 [Loop If]
    if((ImpactCue == none) && PhysMaterial != none)
    {
        PhysMatProp = EvilPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
        // End:0xBC
        if(PhysMatProp != none)
        {
            ImpactCue = PhysMatProp.FootStepInfo[int(Pawn.CharacterFootStepType)].CrouchingEnd;
        }
        PhysMaterial = PhysMaterial.Parent;
        // [Loop Continue]
        goto J0x00;
    }
    return ImpactCue;
    //return ReturnValue;    
}

defaultproperties
{
    DefaultFXInfoBallistic=(Type=EImpactTypeBallistic.ITB_None,ExitWoundPS=none,ExitWoundPS_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    DefaultFXInfoExplosion=(Type=EImpactTypeExplosion.ITE_None,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoBallistic[0]=(Type=EImpactTypeBallistic.ITB_None,ExitWoundPS=none,ExitWoundPS_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoBallistic[1]=(Type=EImpactTypeBallistic.ITB_Chaingun,ExitWoundPS=none,ExitWoundPS_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoBallistic[2]=(Type=EImpactTypeBallistic.ITB_Painkiller,ExitWoundPS=none,ExitWoundPS_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoBallistic[3]=(Type=EImpactTypeBallistic.ITB_Shotgun,ExitWoundPS=none,ExitWoundPS_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoBallistic[4]=(Type=EImpactTypeBallistic.ITB_SMG,ExitWoundPS=none,ExitWoundPS_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoBallistic[5]=(Type=EImpactTypeBallistic.ITB_SoulReaperMelee,ExitWoundPS=none,ExitWoundPS_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoBallistic[6]=(Type=EImpactTypeBallistic.ITB_Reserved1,ExitWoundPS=none,ExitWoundPS_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoBallistic[7]=(Type=EImpactTypeBallistic.ITB_Reserved2,ExitWoundPS=none,ExitWoundPS_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoBallistic[8]=(Type=EImpactTypeBallistic.ITB_Reserved3,ExitWoundPS=none,ExitWoundPS_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoBallistic[9]=(Type=EImpactTypeBallistic.ITB_Reserved4,ExitWoundPS=none,ExitWoundPS_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoBallistic[10]=(Type=EImpactTypeBallistic.ITB_Reserved5,ExitWoundPS=none,ExitWoundPS_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[0]=(Type=EImpactTypeExplosion.ITE_None,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[1]=(Type=EImpactTypeExplosion.ITE_Bolt,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[2]=(Type=EImpactTypeExplosion.ITE_Electro,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[3]=(Type=EImpactTypeExplosion.ITE_Flamer,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[4]=(Type=EImpactTypeExplosion.ITE_Freezer,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[5]=(Type=EImpactTypeExplosion.ITE_Grenade,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[6]=(Type=EImpactTypeExplosion.ITE_Heater,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[7]=(Type=EImpactTypeExplosion.ITE_Painkiller,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[8]=(Type=EImpactTypeExplosion.ITE_Rocket,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[9]=(Type=EImpactTypeExplosion.ITE_ElectroSaw,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[10]=(Type=EImpactTypeExplosion.ITE_Shuriken,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[11]=(Type=EImpactTypeExplosion.ITE_SoulSaw,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[12]=(Type=EImpactTypeExplosion.ITE_SoulReaper,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[13]=(Type=EImpactTypeExplosion.ITE_GasBarrel,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[14]=(Type=EImpactTypeExplosion.ITE_PainkillerBeam,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[15]=(Type=EImpactTypeExplosion.ITE_BoltBurning,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[16]=(Type=EImpactTypeExplosion.ITE_ShurikenExplo,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[17]=(Type=EImpactTypeExplosion.ITE_SoulSawCombo,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[18]=(Type=EImpactTypeExplosion.ITE_GrenadeGas,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FXInfoExplosion[19]=(Type=EImpactTypeExplosion.ITE_ClownSpell,FogVolumeArchetype=none,FogVolumeArchetype_ForSlowPerf=none,DecalData=none,bIgnoreParentDecal=false,DecalData_NoGore=none,ImpactCue=none,bIgnoreParentImpactCue=false,ImpactPS=none,ImpactPSScale=none,bIgnoreParentImpactPS=false,ImpactPS_ForSlowPerf=none,ImpactPS_NoGore=none,ImpactPS_NoGore_ForSlowPerf=none,CameraEffect=none,CameraEffectRadius=800.0000000)
    FootStepInfo[0]=(Type=ECharacterFootStepType.CFST_Generic,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[1]=(Type=ECharacterFootStepType.CFST_Templar,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[2]=(Type=ECharacterFootStepType.CFST_Zombie,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[3]=(Type=ECharacterFootStepType.CFST_ZombieSoldier,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[4]=(Type=ECharacterFootStepType.CFST_Banshee,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[5]=(Type=ECharacterFootStepType.CFST_Boy,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[6]=(Type=ECharacterFootStepType.CFST_Samurai,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[7]=(Type=ECharacterFootStepType.CFST_Hellangel,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[8]=(Type=ECharacterFootStepType.CFST_Sado,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[9]=(Type=ECharacterFootStepType.CFST_EvilMonk,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[10]=(Type=ECharacterFootStepType.CFST_BlackDemon,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[11]=(Type=ECharacterFootStepType.CFST_EvilMonkRich,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[12]=(Type=ECharacterFootStepType.CFST_BlackDemonBig,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[13]=(Type=ECharacterFootStepType.CFST_Clown,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[14]=(Type=ECharacterFootStepType.CFST_BreakBoy,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[15]=(Type=ECharacterFootStepType.CFST_SkeletonSoldier,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[16]=(Type=ECharacterFootStepType.CFST_Skeleton,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[17]=(Type=ECharacterFootStepType.CFST_DevilMonk,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[18]=(Type=ECharacterFootStepType.CFST_Pinokio,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[19]=(Type=ECharacterFootStepType.CFST_Nun,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[20]=(Type=ECharacterFootStepType.CFST_Skull,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[21]=(Type=ECharacterFootStepType.CFST_Maso,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[22]=(Type=ECharacterFootStepType.CFST_Preacher,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[23]=(Type=ECharacterFootStepType.CFST_KrustyClown,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[24]=(Type=ECharacterFootStepType.CFST_BagBaby,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[25]=(Type=ECharacterFootStepType.CFST_Ghost,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[26]=(Type=ECharacterFootStepType.CFST_SkeletonBaby,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[27]=(Type=ECharacterFootStepType.CFST_PsychoElektro,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[28]=(Type=ECharacterFootStepType.CFST_Multiplayer,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[29]=(Type=ECharacterFootStepType.CFST_Girl,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[30]=(Type=ECharacterFootStepType.CFST_Assassin,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[31]=(Type=ECharacterFootStepType.CFST_Raven,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[32]=(Type=ECharacterFootStepType.CFST_Eve,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[33]=(Type=ECharacterFootStepType.CFST_Reserved18,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[34]=(Type=ECharacterFootStepType.CFST_Reserved19,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[35]=(Type=ECharacterFootStepType.CFST_Reserved20,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[36]=(Type=ECharacterFootStepType.CFST_Reserved21,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[37]=(Type=ECharacterFootStepType.CFST_Reserved22,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[38]=(Type=ECharacterFootStepType.CFST_Reserved23,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[39]=(Type=ECharacterFootStepType.CFST_Reserved24,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[40]=(Type=ECharacterFootStepType.CFST_Reserved25,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[41]=(Type=ECharacterFootStepType.CFST_Reserved26,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[42]=(Type=ECharacterFootStepType.CFST_Reserved27,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[43]=(Type=ECharacterFootStepType.CFST_Reserved28,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[44]=(Type=ECharacterFootStepType.CFST_Reserved29,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    FootStepInfo[45]=(Type=ECharacterFootStepType.CFST_Reserved30,FootStep=none,Landing=none,Leaping=none,Crouching=none,CrouchingEnd=none,Sliding=none,FootstepEffectPS=none)
    bSuppressNonGoreStuff=true
}