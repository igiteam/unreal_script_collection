class AdvFlashlight_GlowableElement_base extends DynamicSMActor
    abstract
    hidecategories(Navigation)
    implements(AdvLightAffection_interface);

struct CheckpointRecord
{
    var Vector Location;
    var Rotator Rotation;
    var bool bIsLit;
    var float LightPower;
    var float ScaledLightPower;
    var bool bIsPuzzleActive;
    var float tmpState;
    var bool bIsBeamEmitterActive;
    var bool bHidden;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        bIsLit=false
        LightPower=0.0000000
        ScaledLightPower=0.0000000
        bIsPuzzleActive=false
        tmpState=0.0000000
        bIsBeamEmitterActive=false
        bHidden=false
    }
};

var export editinline AudioComponent LightSoundComponent;
var() export editinline AudioComponent SizzleSoundComponent;
var() SoundCue TurnedOnSoundComponent;
var() SoundCue TurnedOffSoundComponent;
var export editinline ParticleSystemComponent Glow;
var MaterialInstanceConstant HighlightingMaterial;
var() repnotify MaterialInstanceConstant ParentHighlightingMaterial;
var bool bShouldBeLit;
var bool bIsLit;
var bool bCallsForEndcheck;
var bool bEndingAnimationActive;
var bool bFadingEndingAnimation;
var bool bIsUnderFocusedBeamEffect;
var bool bOnlyLighten;
var bool bCentered;
var() repnotify bool bIsPuzzleActive;
var() bool bWasteLight;
var bool bEnlighted;
var bool bFullEndingAnimation;
var bool bIsBeamEmitterActive;
var bool bLoopedSetLightAffection;
var() float LightTimeout;
var repnotify float LightPower;
var float ScaledLightPower;
var() float LightPowerScalingFactor;
var() float LightPowerThreshold;
var() float LightGainer;
var() float LightWaster;
var() float EndingGlowSpeeder;
var() float LightThresholdInnerDividor;
var() float LightThresholdOuterDividor;
var() float DelayerThreshold;
var SeqAct_GlowableElementVariables KismetVariablesHolder;
var float ScalarParameterPower;
var() EvilExplosion ExplosionTemplate;
var() Actor Locator;
var array<Pawn> PawnsWithFL;
var repnotify int PawnsFocusing;

replication
{
    // Pos:0x000
    if(bNetInitial && int(Role) == int(ROLE_Authority)
        EndingGlowSpeeder, ExplosionTemplate, 
        LightTimeout, ParentHighlightingMaterial, 
        SizzleSoundComponent, TurnedOffSoundComponent, 
        TurnedOnSoundComponent;

    // Pos:0x020
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        DelayerThreshold, LightGainer, 
        LightPower, LightPowerScalingFactor, 
        LightPowerThreshold, LightThresholdInnerDividor, 
        LightThresholdOuterDividor, LightWaster, 
        PawnsFocusing, bIsPuzzleActive, 
        bWasteLight;
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bIsLit = bIsLit;
    Record.LightPower = LightPower;
    Record.ScaledLightPower = ScaledLightPower;
    Record.bIsPuzzleActive = bIsPuzzleActive;
    HighlightingMaterial.GetScalarParameterValue('State', Record.tmpState);
    Record.bIsBeamEmitterActive = bIsBeamEmitterActive;
    Record.Location = self.Location;
    Record.Rotation = self.Rotation;
    Record.bHidden = self.bHidden;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    local Actor OldBase;
    local editinline SkeletalMeshComponent OldBaseComp;
    local name OldBaseBoneName;
    local array<Actor> OldAttached;
    local array<Vector> OldLocations;
    local int I;

    bIsLit = Record.bIsLit;
    LightPower = Record.LightPower;
    ScaledLightPower = Record.ScaledLightPower;
    bIsPuzzleActive = Record.bIsPuzzleActive;
    HighlightingMaterial.SetScalarParameterValue('State', Record.tmpState);
    HighlightingMaterial.SetScalarParameterValue('Power', ScaledLightPower);
    bIsBeamEmitterActive = Record.bIsBeamEmitterActive;
    OldAttached = Attached;
    J0x14C:

    // End:0x20D [Loop If]
    if(I < OldAttached.Length)
    {
        // End:0x1F5
        if((OldAttached[I] != none) && OldAttached[I].bJustTeleported)
        {
            OldLocations[I] = OldAttached[I].Location;
            I++;            
        }
        else
        {
            OldAttached.Remove(I, 1);            
        }
        // [Loop Continue]
        goto J0x14C;
    }
    OldBase = Base;
    OldBaseComp = BaseSkelComponent;
    OldBaseBoneName = BaseBoneName;
    SetLocation(Record.Location);
    SetRotation(Record.Rotation);
    SetBase(OldBase,, OldBaseComp, OldBaseBoneName);
    I = 0;
    J0x2AE:

    // End:0x348 [Loop If]
    if(I < OldAttached.Length)
    {
        // End:0x33A
        if(OldAttached[I] != none)
        {
            OldAttached[I].SetLocation(OldLocations[I]);
            OldAttached[I].SetBase(self);
        }
        I++;
        // [Loop Continue]
        goto J0x2AE;
    }
    // End:0x3CE
    if(Record.bHidden != bHidden)
    {
        SetHidden(Record.bHidden);
        SetForcedInitialReplicatedProperty(BoolProperty'Engine.Actor.bHidden', bHidden == default.bHidden);
        ForceNetRelevant();
    }
    //return;    
}

function bool ShouldSaveForCheckpoint()
{
    return true;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SetCollisionType(2);
    // End:0x91
    if(HighlightingMaterial == none)
    {
        // End:0x5D
        if(ParentHighlightingMaterial != none)
        {
            StaticMeshComponent.SetMaterial(0, ParentHighlightingMaterial);
        }
        HighlightingMaterial = StaticMeshComponent.CreateAndSetMaterialInstanceConstant(0);
        ForceNetRelevant();
    }
    ReplicatedMeshScale3D = StaticMeshComponent.Scale3D * 100.0000000;
    TurnOff();
    // End:0xEC
    if(LightTimeout < 0.0000000)
    {
        LightTimeout = 0.0000000;
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x7C
    if(VarName == 'ParentHighlightingMaterial')
    {
        // End:0x4F
        if(ParentHighlightingMaterial != none)
        {
            StaticMeshComponent.SetMaterial(0, ParentHighlightingMaterial);
        }
        HighlightingMaterial = StaticMeshComponent.CreateAndSetMaterialInstanceConstant(0);        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function TurnOn()
{
    local EvilExplosionActor ExplosionActor;
    local EvilExplosion ExplosionObject;

    // End:0x1A1
    if(!bIsLit && bIsPuzzleActive)
    {
        bCallsForEndcheck = true;
        // End:0x51
        if(TurnedOnSoundComponent != none)
        {
            PlaySound(TurnedOnSoundComponent);
        }
        bEndingAnimationActive = false;
        bFullEndingAnimation = false;
        bFadingEndingAnimation = false;
        SetTimer(0.0000000, false, 'SetLightAffectionFromFlashLight_T');
        // End:0x1A1
        if((ExplosionTemplate != none) && Locator != none)
        {
            ExplosionObject = new ExplosionTemplate.Class (ExplosionTemplate);
            ExplosionActor = Spawn(Class'EvilGame.EvilExplosionActor', Locator,, Locator.Location, Locator.Rotation);
            ExplosionObject.HitNormal = Vector(self.Rotation);
            ExplosionActor.Explode(ExplosionObject);
        }
    }
    SetTimer(0.0000000, false, 'StopInLightEffects');
    FlashlightBeamElsewhere_T();
    LightPower = LightPowerThreshold;
    ScaledLightPower = (LightPowerScalingFactor * LightPower) / LightPowerThreshold;
    HighlightingMaterial.SetScalarParameterValue('State', 2.0000000);
    HighlightingMaterial.SetScalarParameterValue('Power', ScaledLightPower);
    bIsLit = true;
    Glow.SetActive(true);
    SetTimer(LightTimeout, false, 'StopInLightEffects');
    //return;    
}

simulated function TurnOff()
{
    SetTimer(0.0000000, false, 'StopInLightEffects');
    LightPower = 0.0000000;
    HighlightingMaterial.SetScalarParameterValue('State', 0.0000000);
    HighlightingMaterial.SetScalarParameterValue('Power', LightPower);
    bIsLit = false;
    bOnlyLighten = false;
    bCentered = false;
    Glow.SetActive(false);
    Glow.KillParticlesForced();
    //return;    
}

simulated function SetLightAffectionFromFlashLight(bool bInLightCone, optional bool bBeamActive, optional Vector FlashSourceLocation)
{
    // End:0x11B
    if(bIsPuzzleActive && bInLightCone)
    {
        bEndingAnimationActive = false;
        bFullEndingAnimation = false;
        bFadingEndingAnimation = false;
        SetTimer(0.0000000, false, 'FlashlightBeamElsewhere_T');
        // End:0x95
        if(bBeamActive)
        {
            // End:0x88
            if(bIsLit)
            {
                bOnlyLighten = false;
                TurnOn();                
            }
            else
            {
                StartInLightEffects();
            }            
        }
        else
        {
            // End:0x104
            if(!bIsLit)
            {
                bOnlyLighten = true;
                // End:0x104
                if((LightSoundComponent != none) && !LightSoundComponent.IsPlaying())
                {
                    LightSoundComponent.Play();
                }
            }
        }
        SetTimer(DelayerThreshold, false, 'FlashlightBeamElsewhere_T');
    }
    //return;    
}

function SetLightAffectionFromFlashLight_T()
{
    SetTimer(0.0000000, false, 'FlashlightBeamElsewhere_T');
    // End:0x39
    if(bIsLit)
    {
        bOnlyLighten = false;
        TurnOn();        
    }
    else
    {
        StartInLightEffects();
    }
    SetTimer(DelayerThreshold, false, 'FlashlightBeamElsewhere_T');
    //return;    
}

function LoopedSetLightAffectionFromFlashLight_T()
{
    SetTimer(DelayerThreshold / float(2), true, 'SetLightAffectionFromFlashLight_T');
    //return;    
}

simulated function StartInLightEffects()
{
    bIsUnderFocusedBeamEffect = true;
    LightAffection();
    //return;    
}

simulated function LightAffection()
{
    // End:0x54
    if((SizzleSoundComponent != none) && !SizzleSoundComponent.IsPlaying())
    {
        SizzleSoundComponent.Play();
    }
    //return;    
}

simulated function StopInLightEffects()
{
    // End:0x45
    if(bIsLit && !bIsBeamEmitterActive)
    {
        // End:0x45
        if(TurnedOffSoundComponent != none)
        {
            PlaySound(TurnedOffSoundComponent);
        }
    }
    // End:0x5E
    if(bIsPuzzleActive)
    {
        bCallsForEndcheck = true;
    }
    bIsLit = false;
    //return;    
}

simulated function FlashlightBeamElsewhere_T()
{
    bCentered = false;
    bOnlyLighten = false;
    bIsUnderFocusedBeamEffect = false;
    //return;    
}

function SetLightAffectionFromVolume(bool bInLightVolume)
{
    //return;    
}

function UpdateLightInfluence_T()
{
    //return;    
}

simulated function SetTraceParameters(Actor HitActor, Vector HitLocation, Vector HitNormal, Vector SourceLocation)
{
    SetTimer(0.0000000, false, 'ClearCenter_T');
    bCentered = true;
    SetTimer(DelayerThreshold, false, 'ClearCenter_T');
    //return;    
}

simulated function ClearCenter_T()
{
    bCentered = false;
    PawnsWithFL.Remove(0, PawnsWithFL.Length);    
    //return;    
}

simulated function AddPawnWithFL(Pawn P)
{
    // End:0x36
    if(PawnsWithFL.Find(P) == )
    {        
        PawnsWithFL.AddItem(P);        
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x4E
    if(int(Role) == int(ROLE_Authority))
    {
        PawnsFocusing = ((PawnsWithFL.Length == 0) ? 1 : PawnsWithFL.Length);
    }
    // End:0x473
    if(bIsUnderFocusedBeamEffect || bOnlyLighten)
    {
        HighlightingMaterial.SetScalarParameterValue('State', 1.0000000);
        // End:0xE1
        if(bWasteLight || !bEnlighted)
        {
            LightPower += ((LightGainer * DeltaTime) * float(PawnsFocusing));
        }
        // End:0x1B3
        if((bCentered && !bIsUnderFocusedBeamEffect) && LightPower > (LightPowerThreshold / LightThresholdInnerDividor))
        {
            // End:0x1B3
            if(bWasteLight || !bEnlighted)
            {
                LightPower -= (((LightGainer * float(2)) * DeltaTime) * float(PawnsFocusing));
                // End:0x1B3
                if(LightPower < (LightPowerThreshold / LightThresholdInnerDividor))
                {
                    LightPower = LightPowerThreshold / LightThresholdInnerDividor;
                }
            }
        }
        // End:0x296
        if(((bOnlyLighten && !bIsUnderFocusedBeamEffect) && !bCentered) && LightPower > (LightPowerThreshold / LightThresholdOuterDividor))
        {
            // End:0x296
            if(bWasteLight || !bEnlighted)
            {
                LightPower -= (((LightGainer * float(2)) * DeltaTime) * float(PawnsFocusing));
                // End:0x296
                if(LightPower < (LightPowerThreshold / LightThresholdOuterDividor))
                {
                    LightPower = LightPowerThreshold / LightThresholdOuterDividor;
                }
            }
        }
        ScaledLightPower = (LightPowerScalingFactor * LightPower) / LightPowerThreshold;
        HighlightingMaterial.SetScalarParameterValue('Power', ScaledLightPower);
        // End:0x473
        if(bIsUnderFocusedBeamEffect)
        {
            // End:0x338
            if(!bWasteLight)
            {
                LightPower += ((LightGainer * DeltaTime) * float(PawnsFocusing));
            }
            // End:0x366
            if(LightPower > (LightPowerThreshold / LightThresholdInnerDividor))
            {
                bEnlighted = true;
            }
            // End:0x433
            if((bCentered && LightPower >= (LightPowerThreshold * 0.8500000)) && LightPower <= LightPowerThreshold)
            {
                // End:0x3E4
                if(ScalarParameterPower == (LightPowerThreshold / LightThresholdOuterDividor))
                {
                    ScalarParameterPower = LightPower;                    
                }
                else
                {
                    ScalarParameterPower = LightPowerThreshold / LightThresholdOuterDividor;
                }
                HighlightingMaterial.SetScalarParameterValue('Power', ScalarParameterPower);
            }
            // End:0x473
            if(LightPower >= LightPowerThreshold)
            {
                TurnOn();
                bIsUnderFocusedBeamEffect = false;
                ScalarParameterPower = LightPower;
            }
        }
    }
    // End:0x5C9
    if((bWasteLight || !bEnlighted) && (((!bIsLit && LightPower > float(0)) && !bIsUnderFocusedBeamEffect) && !bOnlyLighten) && !bEndingAnimationActive)
    {
        HighlightingMaterial.SetScalarParameterValue('State', 1.0000000);
        LightPower -= (LightWaster * DeltaTime);
        // End:0x554
        if(LightPower < float(0))
        {
            LightPower = 0.0000000;
        }
        // End:0x56F
        if(LightPower == float(0))
        {
            TurnOff();
        }
        ScaledLightPower = (LightPowerScalingFactor * LightPower) / LightPowerThreshold;
        HighlightingMaterial.SetScalarParameterValue('Power', ScaledLightPower);
    }
    // End:0x5FE
    if(bEndingAnimationActive)
    {
        bFadingEndingAnimation = EndingAnimation(DeltaTime, bFadingEndingAnimation);
    }
    //return;    
}

function bool EndingAnimation(float DeltaTime, bool bFading)
{
    // End:0x3C
    if(!bFading)
    {
        LightPower += ((EndingGlowSpeeder * LightGainer) * DeltaTime);        
    }
    else
    {
        LightPower -= ((EndingGlowSpeeder * LightWaster) * DeltaTime);
    }
    LightPower = FClamp(LightPower, ((bShouldBeLit && !bFullEndingAnimation) ? LightPowerThreshold : 0.0000000), LightPowerThreshold * float(2));
    // End:0x128
    if(LightPower >= LightPowerThreshold)
    {
        HighlightingMaterial.SetScalarParameterValue('State', 2.0000000);
        // End:0x125
        if(LightPower >= (LightPowerThreshold * float(2)))
        {
            bFading = true;
        }        
    }
    else
    {
        HighlightingMaterial.SetScalarParameterValue('State', 1.0000000);
    }
    // End:0x1DD
    if(bFading && LightPower == ((bShouldBeLit && !bFullEndingAnimation) ? LightPowerThreshold : 0.0000000))
    {
        bFading = false;
        bEndingAnimationActive = false;
        bFullEndingAnimation = false;
        // End:0x1DD
        if(bFullEndingAnimation)
        {
            bIsPuzzleActive = true;
        }
    }
    // End:0x1FE
    if(bShouldBeLit && !bFullEndingAnimation)
    {        
    }
    else
    {
        bIsLit = false;
    }
    ScaledLightPower = (LightPowerScalingFactor * LightPower) / LightPowerThreshold;
    HighlightingMaterial.SetScalarParameterValue('Power', ScaledLightPower);
    return bFading;
    //return ReturnValue;    
}

function UpdateKismetVariablesHolder_T()
{
    KismetVariablesHolder.ForceActivateInput(0);
    //return;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x46
    if(Action.InputLinks[0].bHasImpulse)
    {
        bIsPuzzleActive = true;        
    }
    else
    {
        // End:0x8C
        if(Action.InputLinks[1].bHasImpulse)
        {
            bIsPuzzleActive = false;            
        }
        else
        {
            // End:0xDB
            if(Action.InputLinks[2].bHasImpulse)
            {
                bIsPuzzleActive = !bIsPuzzleActive;
            }
        }
    }
    //return;    
}

simulated event InterpolationFinished(SeqAct_Interp InterpAction)
{
    // End:0x68
    if(InterpAction.bNoResetOnRewind && InterpAction.bRewindOnPlay)
    {
        ForceNetRelevant();
        bUpdateSimulatedPosition = true;
        bReplicateMovement = true;
    }
    //return;    
}

function bool AddFlashlight(AdvInventoryItem_Torch addTorch)
{
    //return ReturnValue;    
}

function RemoveFlashlight(AdvInventoryItem_Torch removeTorch)
{
    //return;    
}

function bool IsUnderBeamEffect()
{
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: AudioComponent'Default__AdvFlashlight_GlowableElement_base.LightAudioComponent0'
    begin object name=LightAudioComponent0 class=Class'Engine.AudioComponent'
    end object
    LightSoundComponent=LightAudioComponent0
    // Reference: AudioComponent'Default__AdvFlashlight_GlowableElement_base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0 class=Class'Engine.AudioComponent'
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    // Reference: ParticleSystemComponent'Default__AdvFlashlight_GlowableElement_base.FireParticles'
    begin object name=FireParticles class=Class'Engine.ParticleSystemComponent'
        bAutoActivate=false
        ReplacementPrimitive=none
    end object
    Glow=FireParticles
    bWasteLight=true
    LightPowerScalingFactor=8.0000000
    LightPowerThreshold=6.0000000
    LightGainer=4.0000000
    LightWaster=4.0000000
    EndingGlowSpeeder=12.0000000
    LightThresholdInnerDividor=2.0000000
    LightThresholdOuterDividor=10.0000000
    DelayerThreshold=0.2000000
    // Reference: StaticMeshComponent'Default__AdvFlashlight_GlowableElement_base.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvFlashlight_GlowableElement_base.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvFlashlight_GlowableElement_base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=FireParticles
    Components[3]=LightAudioComponent0
    Components[4]=SizzleAudioComponent0
    CollisionComponent=StaticMeshComponent0
}