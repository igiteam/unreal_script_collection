class EvilPickupFactory extends UDKPickupFactory
    abstract
    hidecategories(Navigation,Lighting,LightColor,Force,Display,Collision,PickupFactory);

var Controller TeamOwner[4];
var SoundCue RespawnSound;
var export editinline AudioComponent PickupReadySound;
var export editinline DynamicLightEnvironmentComponent LightEnvironment;
var name PickupStatName;
var bool bHasLocationSpeech;
var array<SoundNodeWave> LocationSpeech;
var float LastSeekNotificationTime;
var ForceFeedbackWaveform PickUpWaveForm;

simulated function PostBeginPlay()
{
    // End:0x0F
    if(bIsDisabled)
    {
        return;
    }
    super(Actor).PostBeginPlay();
    bUpdatingPickup = (int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && bRotatingPickup || bFloatingPickup;
    // End:0xC5
    if(Glow != none)
    {
        Glow.SetFloatParameter('LightStrength', 0.0000000);
        Glow.SetActive(true);
    }
    // End:0x1B1
    if(((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && BaseMesh != none) && BaseMaterialParamName != 'None')
    {
        BaseMaterialInstance = BaseMesh.CreateAndSetMaterialInstanceConstant(0);
        BaseTargetEmissive = ((bPickupHidden) ? BaseDimEmissive : BaseBrightEmissive);
        BaseEmissive = BaseTargetEmissive;
        BaseMaterialInstance.SetVectorParameterValue(BaseMaterialParamName, BaseEmissive);
    }
    // End:0x1F0
    if(!bIsSuperItem && PickupReadySound != none)
    {
        PickupReadySound.Play();
    }
    // End:0x258
    if(WorldInfo.bUseConsoleInput)
    {
        SetCollisionSize(1.5000000 * CylinderComponent.CollisionRadius, CylinderComponent.CollisionHeight);
    }
    //return;    
}

simulated function SetResOut()
{
    // End:0x4B
    if(bDoVisibilityFadeIn && MIC_Visibility != none)
    {
        MIC_Visibility.SetScalarParameterValue(VisibilityParamName, 1.0000000);
    }
    //return;    
}

simulated function DisablePickup()
{
    bIsDisabled = true;
    GotoState('Disabled');
    //return;    
}

simulated function ShutDown()
{
    DisablePickup();
    //return;    
}

simulated function ReplicatedEvent(name VarName)
{
    // End:0x24
    if(VarName == 'bIsDisabled')
    {
        global.SetInitialState();        
    }
    else
    {
        // End:0x54
        if((VarName == 'bPickupHidden') && bPickupHidden)
        {
            SetResOut();
        }
        // End:0xC0
        if((VarName == 'bPulseBase') || VarName == 'bPickupHidden')
        {
            StartPulse(((bPickupHidden && !bPulseBase) ? BaseDimEmissive : BaseBrightEmissive));
        }
        // End:0xEE
        if(VarName == 'bIsRespawning')
        {
            // End:0xEE
            if(bIsRespawning)
            {
                RespawnEffect();
            }
        }
        super(PickupFactory).ReplicatedEvent(VarName);
    }
    //return;    
}

static simulated function UpdateHUD(UTHUD H)
{
    //return;    
}

simulated function RespawnEffect()
{
    bIsRespawning = true;
    PlaySound(RespawnSound, true);
    // End:0x53
    if(PickupMesh != none)
    {
        PickupMesh.SetHidden(false);
    }
    //return;    
}

simulated function bool StopsProjectile(Projectile P)
{
    local Actor HitActor;
    local Vector HitNormal, HitLocation;

    // End:0x11C
    if((P.CylinderComponent.CollisionRadius > float(0)) || P.CylinderComponent.CollisionHeight > float(0))
    {
        HitActor = Trace(HitLocation, HitNormal, P.Location, P.Location - (float(100) * Normal(P.Velocity)), true, vect(0.0000000, 0.0000000, 0.0000000));
        // End:0x11C
        if(HitActor != self)
        {
            return false;
        }
    }
    return bProjTarget || bBlockActors;
    //return ReturnValue;    
}

simulated function StartPulse(LinearColor TargetEmissive)
{
    // End:0xAD
    if(((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && BaseMesh != none) && BaseMaterialParamName != 'None')
    {
        BaseTargetEmissive = TargetEmissive;
        // End:0x8F
        if(BasePulseTime <= 0.0000000)
        {
            BasePulseTime = BasePulseRate;            
        }
        else
        {
            BasePulseTime = BasePulseRate - BasePulseTime;
        }
    }
    //return;    
}

simulated function SetPickupMesh()
{
    super(PickupFactory).SetPickupMesh();
    InitPickupMeshEffects();
    //return;    
}

function name GetPickupStatName()
{
    return ((default.PickupStatName != 'None') ? default.PickupStatName : 'INVALID_PICKUPSTAT');
    //return ReturnValue;    
}

simulated event InitPickupMeshEffects()
{
    // End:0x12D
    if(PickupMesh != none)
    {
        PickupMesh.SetLightEnvironment(LightEnvironment);
        // End:0xD2
        if(bDoVisibilityFadeIn && MeshComponent(PickupMesh) != none)
        {
            MIC_Visibility = MeshComponent(PickupMesh).CreateAndSetMaterialInstanceConstant(0);
            MIC_Visibility.SetScalarParameterValue(VisibilityParamName, ((bIsSuperItem) ? 1.0000000 : 0.0000000));
        }
        BobBaseOffset = PickupMesh.Translation.Y;
        // End:0x12D
        if(bRandomStart)
        {
            BobTimer = 1000.0000000 * FRand();
        }
    }
    //return;    
}

simulated function SetPickupVisible()
{
    // End:0x2E
    if(PickupReadySound != none)
    {
        PickupReadySound.Play();
    }
    // End:0x6A
    if(Glow != none)
    {
        Glow.SetFloatParameter('LightStrength', 1.0000000);
    }
    super.SetPickupVisible();
    //return;    
}

simulated function SetPickupHidden()
{
    // End:0x2E
    if(PickupReadySound != none)
    {
        PickupReadySound.Stop();
    }
    // End:0x6A
    if(Glow != none)
    {
        Glow.SetFloatParameter('LightStrength', 0.0000000);
    }
    super.SetPickupHidden();
    //return;    
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    // End:0x2A
    if(bIsDisabled)
    {
        GotoState('Disabled');        
    }
    else
    {
        super(PickupFactory).SetInitialState();
    }
    //return;    
}

function PickedUpBy(Pawn P)
{
    local PlayerController PC;

    super(PickupFactory).PickedUpBy(P);
    PC = PlayerController(P.Controller);
    // End:0x7C
    if(PC != none)
    {
        PC.ClientPlayForceFeedbackWaveform(PickUpWaveForm);
    }
    //return;    
}

auto state Pickup
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        bPulseBase = false;
        StartPulse(BaseBrightEmissive);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        bIsRespawning = false;
        SetResOut();
        //return;        
    }
    stop;    
}

state Sleeping
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        bPulseBase = false;
        StartPulse(BaseDimEmissive);
        SetTimer((GetRespawnTime()) - PulseThreshold, false, 'PulseThresholdMet');
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ClearTimer('PulseThresholdMet');
        //return;        
    }

    function PulseThresholdMet()
    {
        bPulseBase = true;
        StartPulse(BaseBrightEmissive);
        //return;        
    }
    stop;    
}

state Disabled
{
    function float BotDesireability(Pawn P, Controller C)
    {
        return 0.0000000;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    // Reference: DynamicLightEnvironmentComponent'Default__EvilPickupFactory.PickupLightEnvironment'
    begin object name=PickupLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
        bCastShadows=false
        bDynamic=false
    end object
    LightEnvironment=PickupLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__EvilPickupFactory.ForceFeedbackWaveformPickUp'
    begin object name=ForceFeedbackWaveformPickUp class=Class'Engine.ForceFeedbackWaveform'
    end object
    PickUpWaveForm=ForceFeedbackWaveformPickUp
    bDoVisibilityFadeIn=true
    // Reference: StaticMeshComponent'Default__EvilPickupFactory.BaseMeshComp'
    begin object name=BaseMeshComp class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilPickupFactory.PickupLightEnvironment'
        MaxDrawDistance=7000.0000000
        CachedMaxDrawDistance=7000.0000000
        CastShadow=false
        bForceDirectLightMap=true
        bCastDynamicShadow=false
        CollideActors=false
    end object
    BaseMesh=BaseMeshComp
    BasePulseRate=0.5000000
    PulseThreshold=5.0000000
    BaseMaterialParamName="BaseEmissiveControl"
    YawRotationRate=32768.0000000
    VisibilityParamName="ResIn"
    GlowEmissiveParam="LightStrength"
    // Reference: CylinderComponent'Default__EvilPickupFactory.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=44.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=PickupLightEnvironment
    Components[3]=BaseMeshComp
    bMovable=false
    CollisionComponent=CollisionCylinder
}