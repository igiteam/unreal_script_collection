class PainItemKActorBase extends KActor;

struct CheckpointRecord
{
    var Vector Location;
    var Rotator Rotation;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
    }
};

var(PainItem) export editinline CylinderComponent CylinderComponent;
var(PainItem) SoundCue PickupSound1p;
var(PainItem) SoundCue PickupSound;
var(PainItem) int MaxPickCount;
var(PainItem) float CheckSameDropDistance;
var bool bWaitForEffects;
var float TimeToLive;
var EvilLightActor BindedLightActor;
var EvilLightActor BindedLightArchetype;

simulated function PreBeginPlay()
{
    super(Actor).PreBeginPlay();
    // End:0x23
    if(BindedLightArchetype != none)
    {
        CreateLight();
    }
    // End:0x4B
    if(TimeToLive > float(0))
    {
        SetTimer(TimeToLive, false, 'TimedDestroy');
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    Class'EvilGame.EvilPhysicsHelpers'.static.SetRBCCDThreshold(StaticMeshComponent, 50.0000000);
    //return;    
}

simulated function CreateLight()
{
    BindedLightActor = Spawn(Class'EvilGame.EvilLightActor', self,, Location,, BindedLightArchetype);
    BindedLightActor.SetBase(self);
    BindedLightActor.Activate();
    //return;    
}

simulated function DestoryLight()
{
    // End:0x39
    if(BindedLightActor != none)
    {
        BindedLightActor.Deactivate();
        BindedLightActor = none;
    }
    //return;    
}

simulated function ShowLight(bool bShow)
{
    // End:0x3A
    if(BindedLightActor != none)
    {
        BindedLightActor.DisableLight(!bShow);
    }
    //return;    
}

function bool CanPickUp(PKPlayerPawn P, PainPRI PRI)
{
    return true;
    //return ReturnValue;    
}

function Pickup(PKPlayerPawn P, PainPRI PRI)
{
    local PKPlayerController PC;
    local bool bSeparate1pSound;

    // End:0x0F
    if(bHidden)
    {
        return;
    }
    PC = PKPlayerController(P.Controller);
    bSeparate1pSound = (PickupSound1p != none) && PickupSound1p != PickupSound;
    // End:0xB5
    if(PickupSound != none)
    {
        P.PlaySound(PickupSound,, bSeparate1pSound);
    }
    // End:0xFB
    if(bSeparate1pSound && PC != none)
    {
        PC.ClientPlaySound(PickupSound1p);
    }
    TriggerEventClass(Class'EvilGame.SeqEvent_Picked', P);
    // End:0x146
    if((MaxPickCount > 0) && --MaxPickCount <= 0)
    {
        DestroyItem();
    }
    // End:0x174
    if(PC != none)
    {
        PC.NotifyPickup();
    }
    //return;    
}

function PlayerTouch(PKPlayerPawn P, PainPRI PRI)
{
    //return;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local PKPlayerPawn P;
    local EvilPlayerController PC;

    // End:0x0F
    if(bHidden)
    {
        return;
    }
    P = PKPlayerPawn(Other);
    // End:0x3C
    if(P == none)
    {
        return;
    }
    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    PC = PKPlayerController(P.Controller);
    // End:0x15E
    if(PC != none)
    {
        // End:0x124
        if(CanPickUp(P, PainPRI(P.PlayerReplicationInfo)))
        {
            Pickup(P, PainPRI(P.PlayerReplicationInfo));            
        }
        else
        {
            PlayerTouch(P, PainPRI(P.PlayerReplicationInfo));
        }
    }
    //return;    
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    super(Actor).OnToggleHidden(Action);
    ShowLight(bHidden);
    //return;    
}

simulated function StopEffects()
{
    DestoryLight();
    //return;    
}

simulated function DestroyItem()
{
    // End:0x29
    if(bWaitForEffects)
    {
        StopEffects();
        LifeSpan = 1.0000000;        
    }
    else
    {
        Destroy();
    }
    //return;    
}

simulated function TimedDestroy()
{
    ClearTimer('TimedDestroy');
    DestroyItem();
    //return;    
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.Rotation = Rotation;
    Record.Location = Location;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    CollisionComponent.SetRBPosition(Record.Location);
    CollisionComponent.SetRBRotation(Record.Rotation);
    //return;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__PainItemKActorBase.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    begin object name="CollisionCylinder" class=Class'Engine.CylinderComponent'
        CollisionHeight=60.0000000
        CollisionRadius=60.0000000
        ReplacementPrimitive=none
        CollideActors=true
        BlockZeroExtent=false
    end object
    CylinderComponent=CollisionCylinder
    MaxPickCount=1
    CheckSameDropDistance=200.0000000
    TimeToLive=-1.0000000
    bDamageAppliesImpulse=false
    // Reference: StaticMeshComponent'Default__PainItemKActorBase.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMeshComponent0'
    // Archetype: StaticMeshComponent'Engine.Default__KActor.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PainItemKActorBase.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__PainItemKActorBase.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Engine.Default__KActor.MyLightEnvironment'
    begin object name="MyLightEnvironment"
        bCastShadows=false
        bUseBooleanEnvironmentShadowing=false
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=CollisionCylinder
    bNoDelete=false
    bBlockActors=false
    CollisionComponent=StaticMeshComponent0
    SupportedEvents=/* Array type was not detected. */
}