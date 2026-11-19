class AdvWeatherEffectActor extends Actor
    notplaceable
    hidecategories(Navigation);

var protected export editinline StaticMeshComponent Mesh;
var protected MaterialInstanceConstant MIC;
var protected export editinline ParticleSystemComponent FloorEmitter;
var protected EmitterCameraLensEffectBase LensEffect;
var bool bEnabled;
var protected bool bBlocked;
var() float WBVEdgeInterpSpeed;
var protected int FrameCount;
var float Fader;
var protected Vector2D SlantPrev;
var protected Vector2D SlantDest;
var protected float SlantAlpha;
var protected float SlantSpeed;
var float RefMaxDensity;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    InternalUpdate(AdvGRI(WorldInfo.GRI).bWeatherEffectEnabled);
    //return;    
}

function bool IsTouchingWBV(Vector Loc)
{
    local AdvWeatherBlockingVolume WBV;

    // End:0x48
    foreach AllActors(Class'AdvWeatherBlockingVolume', WBV)
    {
        // End:0x47
        if(WBV.EncompassesPoint(Loc))
        {            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

protected simulated function InternalUpdate(bool bNewEnabled)
{
    local AdvGRI EGRI;

    EGRI = AdvGRI(WorldInfo.GRI);
    bEnabled = bNewEnabled;
    // End:0x45B
    if(bNewEnabled)
    {
        // End:0x1AD
        if((MIC == none) || MIC.Parent != EGRI.WeatherEffectProps.CylinderMaterial)
        {
            // End:0x18D
            if(EGRI.WeatherEffectProps.CylinderMaterial != none)
            {
                Mesh.SetMaterial(0, EGRI.WeatherEffectProps.CylinderMaterial);
                MIC = Mesh.CreateAndSetMaterialInstanceConstant(0);
                Mesh.SetHidden(false);                
            }
            else
            {
                Mesh.SetHidden(true);
            }
        }
        // End:0x288
        if(EGRI.WeatherEffectProps.FloorParticleSystem != none)
        {
            // End:0x288
            if(FloorEmitter.Template != EGRI.WeatherEffectProps.FloorParticleSystem)
            {
                FloorEmitter.SetTemplate(EGRI.WeatherEffectProps.FloorParticleSystem);
            }
        }
        // End:0x45B
        if((EvilPlayerController(Owner).PlayerCamera != none) && EGRI.WeatherEffectProps.CameraLensEffect != none)
        {
            LensEffect = EvilPlayerController(Owner).PlayerCamera.FindCameraLensEffect(EGRI.WeatherEffectProps.CameraLensEffect);
            // End:0x45B
            if(LensEffect == none)
            {
                EvilPlayerController(Owner).PlayerCamera.AddCameraLensEffect(EGRI.WeatherEffectProps.CameraLensEffect);
                LensEffect = EvilPlayerController(Owner).PlayerCamera.FindCameraLensEffect(EGRI.WeatherEffectProps.CameraLensEffect);
            }
        }
    }
    //return;    
}

static simulated function Update(AdvPlayerController PC)
{
    local WorldInfo WI;
    local AdvGRI GRI;

    WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
    GRI = ((WI != none) ? GRI : none);
    // End:0x5F
    if(GRI == none)
    {
        return;
    }
    // End:0x135
    if(GRI.bWeatherEffectEnabled)
    {
        // End:0xFD
        if(PC.WeatherEffect == none)
        {
            PC.WeatherEffect = PC.Spawn(Class'AdvWeatherEffectActor', PC);            
        }
        else
        {
            PC.WeatherEffect.InternalUpdate(true);
        }        
    }
    else
    {
        // End:0x18E
        if(PC.WeatherEffect != none)
        {
            PC.WeatherEffect.InternalUpdate(false);
        }
    }
    //return;    
}

event Tick(float DeltaTime)
{
    local EvilPlayerController PC;
    local Vector HitLoc, HitNorm, Loc, Z;
    local Rotator Rot, slant;
    local bool bVisible;

    PC = EvilPlayerController(Owner);
    // End:0x3D
    if(PC == none)
    {
        self.Destroy();
        return;
    }
    PC.GetPlayerViewPoint(Loc, Rot);
    bBlocked = IsTouchingWBV(Loc);
    bVisible = (bEnabled && !bBlocked) || Fader > 0.0000000;
    // End:0x18D
    if(bEnabled && !bBlocked)
    {
        // End:0x18A
        if(Fader < 1.0000000)
        {
            Fader = FInterpTo(Fader, 1.0000000, DeltaTime, ((bBlocked) ? WBVEdgeInterpSpeed : AdvGRI(WorldInfo.GRI).WeatherEffectProps.InterpSpeed));
        }        
    }
    else
    {
        // End:0x319
        if(Fader > 0.0000000)
        {
            Fader = FInterpTo(Fader, 0.0000000, DeltaTime, ((bBlocked) ? WBVEdgeInterpSpeed : AdvGRI(WorldInfo.GRI).WeatherEffectProps.InterpSpeed));
            // End:0x319
            if(Fader <= 0.0000000)
            {
                // End:0x319
                if((!bBlocked && EvilPlayerController(Owner).PlayerCamera != none) && LensEffect != none)
                {
                    LensEffect.ParticleSystemComponent.DeactivateSystem();
                    EvilPlayerController(Owner).PlayerCamera.RemoveCameraLensEffect(LensEffect);
                    LensEffect = none;
                }
            }
        }
    }
    // End:0x732
    if(Fader > 0.0000000)
    {
        Mesh.SetTranslation(Loc);
        // End:0x52C
        if((SlantAlpha += (DeltaTime * SlantSpeed)) >= 1.0000000)
        {
            SlantPrev = SlantDest;
            SlantDest = vect2d(182.0444000 * GetRangeValueByPct(AdvGRI(WorldInfo.GRI).WeatherEffectProps.SlantRangePitch, FRand()), 182.0444000 * GetRangeValueByPct(AdvGRI(WorldInfo.GRI).WeatherEffectProps.SlantRangeRoll, FRand()));
            SlantAlpha = 0.0000000;
            SlantSpeed = 1.0000000 / (AdvGRI(WorldInfo.GRI).WeatherEffectProps.SlantFixedTime + (FRand() * AdvGRI(WorldInfo.GRI).WeatherEffectProps.SlantRandomTime));
        }
        slant = MakeRotator(int(FInterpEaseInOut(SlantPrev.X, SlantDest.X, SlantAlpha, AdvGRI(WorldInfo.GRI).WeatherEffectProps.SlantInterpExponent)), 0, int(FInterpEaseInOut(SlantPrev.Y, SlantDest.Y, SlantAlpha, AdvGRI(WorldInfo.GRI).WeatherEffectProps.SlantInterpExponent)));
        Mesh.SetRotation(slant);
        // End:0x732
        if(MIC != none)
        {
            MIC.SetScalarParameterValue('Rain', Fader * AdvGRI(WorldInfo.GRI).WeatherEffectProps.EffectIntensity);
        }
    }
    // End:0x823
    if(LensEffect != none)
    {
        LensEffect.SetLocation(Loc + (Vector(Rot) * 10.1000000));
        LensEffect.SetRotation(Rot);
        LensEffect.SetDrawScale((Tan((PC.GetFOVAngle() * 0.0174533) * 0.5000000) * 10.1000000) / (Tan((PC.DefaultFOV * 0.0174533) * 0.5000000) * 10.1000000));
    }
    // End:0xA16
    if(FloorEmitter.Template != none)
    {
        GetAxes(slant, HitLoc, HitNorm, Z);
        // End:0x928
        if(++FrameCount > 5)
        {
            // End:0x91A
            if(none == PC.ViewTarget.Trace(HitLoc, HitNorm, Loc - (200.0000000 * Z), Loc, true, vect(42.0000000, 42.0000000, 2.0000000)))
            {
                HitLoc = Loc - vect(0.0000000, 0.0000000, 200.0000000);
            }
            FrameCount = 0;            
        }
        else
        {
            HitLoc = Loc - (Z * ((Loc.Z - FloorEmitter.Translation.Z) / Z.Z));
        }
        // End:0x9EC
        if(FloorEmitter != none)
        {
            FloorEmitter.SetTranslation(HitLoc);
        }
        FloorEmitter.SetActive(bVisible);
    }
    UpdateAttachments(bVisible);
    //return;    
}

simulated function UpdateAttachments(bool bNewEnabled)
{
    local Actor A;
    local FogVolumeDensityInfo Fog;
    local Emitter Emit;

    // End:0x2A3
    foreach ChildActors(Class'Engine.Actor', A)
    {
        // End:0x2B
        if(A == self)
        {
            continue;            
        }
        A.SetLocation(Mesh.Translation);
        // End:0xBA
        if(A.bHidden == bNewEnabled)
        {
            A.SetHidden(!bNewEnabled);
        }
        Fog = FogVolumeDensityInfo(A);
        // End:0x238
        if(Fog != none)
        {
            // End:0x166
            if(Fog.DensityComponent.bEnabled != bNewEnabled)
            {
                Fog.DensityComponent.SetEnabled(bNewEnabled);
            }
            // End:0x235
            if(Fog.IsA('FogVolumeSphericalDensityInfo'))
            {
                FogVolumeSphericalDensityComponent(Fog.DensityComponent).MaxDensity = RefMaxDensity * Fader;
                FogVolumeSphericalDensityComponent(Fog.DensityComponent).SphereCenter = Mesh.Translation;
            }
            // End:0x2A2
            continue;
        }
        Emit = Emitter(A);
        // End:0x2A2
        if(Emit != none)
        {
            Emit.ParticleSystemComponent.SetActive(bNewEnabled);
        }        
    }    
    //return;    
}

simulated function AttachWeatherActor(Actor Other)
{
    Other.SetOwner(self);
    // End:0x8B
    if(Other.IsA('FogVolumeSphericalDensityInfo'))
    {
        RefMaxDensity = FogVolumeSphericalDensityComponent(FogVolumeSphericalDensityInfo(Other).DensityComponent).MaxDensity;
    }
    //return;    
}

simulated function DetachWeatherActor(Actor Other)
{
    // End:0x11
    if(Other == self)
    {
        return;
    }
    Other.SetOwner(none);
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvWeatherEffectActor.Mesh0'
    begin object name=Mesh0 class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'adv_AtmosphericEffects.Mesh.sm_RainSnowCylinder_02'
        ReplacementPrimitive=none
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        CanBlockCamera=false
        BlockRigidBody=false
        bBlockFootPlacement=false
        AbsoluteTranslation=true
        AbsoluteRotation=true
        AbsoluteScale=true
    end object
    Mesh=Mesh0
    // Reference: ParticleSystemComponent'Default__AdvWeatherEffectActor.PSC0'
    begin object name=PSC0 class=Class'Engine.ParticleSystemComponent'
        bAutoActivate=false
        ReplacementPrimitive=none
        CanBlockCamera=false
        bBlockFootPlacement=false
        AbsoluteTranslation=true
        AbsoluteRotation=true
        AbsoluteScale=true
    end object
    FloorEmitter=PSC0
    WBVEdgeInterpSpeed=6.0000000
    SlantAlpha=1.0000000
    Components[0]=Mesh0
    Components[1]=PSC0
    TickGroup=ETickingGroup.TG_PostAsyncWork
    bIgnoreEncroachers=true
}