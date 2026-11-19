class AdvMirror_base extends DynamicSMActor
    abstract
    hidecategories(Navigation);

struct CheckpointRecord
{
    var Vector Location;
    var Rotator Rotation;
    var int Purpose;
    var bool bIsLit;
    var bool bWasLit;
    var float LightPower;
    var float tmpState;
    var bool bIsUnderFocusedBeamEffect;
    var string SavedBase;
    var bool bHidden;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        Purpose=0
        bIsLit=false
        bWasLit=false
        LightPower=0.0000000
        tmpState=0.0000000
        bIsUnderFocusedBeamEffect=false
        SavedBase=""
        bHidden=false
    }
};

var() export editinline AdvMirrorComponent MirrorComponent;
var() export editinline ArrowComponent ArrowComp;

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    MirrorComponent.MirrorReflectingMaterial.GetScalarParameterValue('LightPower', Record.tmpState);
    Record.bIsUnderFocusedBeamEffect = MirrorComponent.bIsUnderFocusedBeamEffect;
    Record.bIsLit = MirrorComponent.bIsLit;
    Record.bWasLit = MirrorComponent.bWasLit;
    Record.LightPower = MirrorComponent.LightPower;
    Record.Purpose = int(MirrorComponent.Purpose);
    Record.Location = self.Location;
    Record.Rotation = self.Rotation;
    Record.SavedBase = PathName(Base);
    Record.bHidden = self.bHidden;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    local Actor SavedBaseActor;

    MirrorComponent.DestroyDecals();
    MirrorComponent.SetupSpotlight();
    MirrorComponent.MirrorReflectingMaterial.SetScalarParameterValue('LightPower', Record.tmpState);
    MirrorComponent.bIsUnderFocusedBeamEffect = Record.bIsUnderFocusedBeamEffect;
    MirrorComponent.bIsLit = Record.bIsLit;
    MirrorComponent.bWasLit = Record.bWasLit;
    MirrorComponent.LightPower = Record.LightPower;
    MirrorComponent.UpdatePurpose(Record.Purpose);
    self.SetLocation(Record.Location);
    self.SetRotation(Record.Rotation);
    // End:0x29F
    if(Record.SavedBase != "")
    {
        SavedBaseActor = Actor(FindObject(Record.SavedBase, Class'Engine.Actor'));
        // End:0x29F
        if(SavedBaseActor != none)
        {
            SetBase(SavedBaseActor);
        }
    }
    SetHidden(Record.bHidden);
    //return;    
}

function bool ShouldSaveForCheckpoint()
{
    return true;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    MirrorComponent.Init();
    super.PostBeginPlay();
    //return;    
}

simulated event Destroyed()
{
    MirrorComponent.DestroyDecals();
    super(Actor).Destroyed();
    //return;    
}

function SetLightAffectionFromFlashLight(bool bInLightCone, optional bool bBeamActive, optional Vector FlashSourceLocation)
{
    MirrorComponent.SetLightAffectionFromFlashLight(bInLightCone, bBeamActive);
    //return;    
}

function SetLightAffectionFromVolume(bool bInLightVolume)
{
    MirrorComponent.SetLightAffectionFromVolume(bInLightVolume);
    //return;    
}

function UpdateLightInfluence_T()
{
    MirrorComponent.UpdateLightInfluence_T();
    //return;    
}

function StartInLightEffects()
{
    MirrorComponent.StartInLightEffects();
    //return;    
}

function StopInLightEffects()
{
    MirrorComponent.StopInLightEffects();
    //return;    
}

function SetTraceParameters(Actor HitActor, Vector HitLocation, Vector HitNormal, Vector SourceLocation)
{
    MirrorComponent.SetTraceParameters(HitActor, HitLocation, HitNormal, SourceLocation);
    //return;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x1D9
    if((int(MirrorComponent.Purpose) == int(0)) || int(MirrorComponent.Purpose) == int(1))
    {
        // End:0xAF
        if(Action.InputLinks[0].bHasImpulse)
        {
            MirrorComponent.Purpose = 1;            
        }
        else
        {
            // End:0x10A
            if(Action.InputLinks[1].bHasImpulse)
            {
                MirrorComponent.Purpose = 0;                
            }
            else
            {
                // End:0x1D9
                if(Action.InputLinks[2].bHasImpulse)
                {
                    // End:0x18F
                    if(int(MirrorComponent.Purpose) == int(1))
                    {
                        MirrorComponent.Purpose = 0;                        
                    }
                    else
                    {
                        // End:0x1D9
                        if(int(MirrorComponent.Purpose) == int(0))
                        {
                            MirrorComponent.Purpose = 1;
                        }
                    }
                }
            }
        }
    }
    // End:0x331
    if((int(MirrorComponent.Purpose) == int(2)) || MirrorComponent.ToggleMode)
    {
        // End:0x27F
        if(Action.InputLinks[0].bHasImpulse)
        {
            MirrorComponent.ActivateBeam();            
        }
        else
        {
            // End:0x2F9
            if(Action.InputLinks[1].bHasImpulse)
            {
                MirrorComponent.DeactivateBeam();
                MirrorComponent.bIsUnderFocusedBeamEffect = false;                
            }
            else
            {
                // End:0x331
                if(Action.InputLinks[2].bHasImpulse)
                {
                }
            }
        }
    }
    //return;    
}

defaultproperties
{
    // Reference: AdvMirrorComponent'Default__AdvMirror_base.MirrorComponent0'
    begin object name=MirrorComponent0 class=Class'AdvMirrorComponent'
        LightMesh=StaticMeshComponent'Default__AdvMirror_base.StaticMeshLight'
        // Reference: LensFlareComponent'Default__AdvMirror_base.MirrorComponent0.LensFlare0'
        begin object name=LensFlare0
            NextTraceTime=-0.1595813
            ReplacementPrimitive=none
        end object
        MirrorLensFlare=LensFlare0
        // Reference: AudioComponent'Default__AdvMirror_base.MirrorComponent0.ChargeAudioComponent0'
        begin object name=ChargeAudioComponent0
        end object
        ChargeSound=ChargeAudioComponent0
        // Reference: SpotLightComponent'Default__AdvMirror_base.MirrorComponent0.SpotLightComponent0'
        begin object name=SpotLightComponent0
        end object
        SLC=SpotLightComponent0
    end object
    MirrorComponent=MirrorComponent0
    // Reference: StaticMeshComponent'Default__AdvMirror_base.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvMirror_base.MyLightEnvironment'
        BlockRigidBody=true
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvMirror_base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    // Reference: StaticMeshComponent'Default__AdvMirror_base.StaticMeshLight'
    begin object name=StaticMeshLight class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        HiddenEditor=true
        bUsePrecomputedShadows=true
        Rotation=(Pitch=32760,Yaw=0,Roll=0)
    end object
    Components[2]=StaticMeshLight
    Components[3]=MirrorComponent0
    Components[4]=none
    CollisionType=ECollisionType.COLLIDE_BlockAll
    BlockRigidBody=true
    bCollideActors=true
    bBlockActors=true
    CollisionComponent=StaticMeshComponent0
    SupportedEvents=/* Array type was not detected. */
}