class EvilTouchPickUp_Base extends Actor
    abstract
    native
    notplaceable
    hidecategories(Navigation);

var(Pickup) export editinline CylinderComponent CylinderComponent;
var(Pickup) export editinline StaticMeshComponent PickupMesh;
var(Pickup) SoundCue PickupSound;
var(Pickup) SoundCue LandingSoound;
var(Pickup) export editinline EvilCaptionComponent CaptionComponent;
var(Pickup) array<MaterialInstance> Materials;
var(Pickup) int MaxPickCount;
var(Pickup) float CheckSameDropDistance;
var() export editinline DynamicLightEnvironmentComponent LightEnvironment;
var transient float TimeToDestroy;
var repnotify bool bActorHidden;
var transient KActorFromStatic CurrentKActor;
var() float MinFloorZToLand;
var(Pickup) float MinFloorZWhenSlipping;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) || bNetDirty
        bActorHidden;
}

function Pickup(EvilPawn P)
{
    // End:0x0F
    if(bHidden)
    {
        return;
    }
    // End:0x53
    if(PickupSound != none)
    {
        P.PlaySound(PickupSound,,,, Location);
    }
    TriggerEventClass(Class'SeqEvent_Picked', P);
    // End:0xDB
    if((MaxPickCount > 0) && --MaxPickCount <= 0)
    {
        // End:0xD8
        if(TimeToDestroy > float(0))
        {
            // End:0xD5
            if(!IsTimerActive('DestroyDelayed'))
            {
                SetTimer(TimeToDestroy, false, 'DestroyDelayed');
            }            
        }
        else
        {
            Destroy();
        }
    }
    //return;    
}

function DestroyDelayed()
{
    Destroy();
    //return;    
}

simulated function PostBeginPlay()
{
    local PlayerController PC;
    local int Idx;

    super.PostBeginPlay();
    Idx = 0;
    J0x15:

    // End:0x76 [Loop If]
    if(Idx < Materials.Length)
    {
        PickupMesh.SetMaterial(Idx, Materials[Idx]);
        ++Idx;
        // [Loop Continue]
        goto J0x15;
    }
    // End:0x13F
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xF8
        if(!PC.bIsPlayer || PC.myHUD == none)
        {
            continue;            
        }
        EvilGFxHudWrapper(PC.myHUD).AddPostRenderedComponent(CaptionComponent);        
    }    
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0xCE
    if(VarName == 'bActorHidden')
    {
        PickupMesh.SetHidden(bActorHidden);
        // End:0x81
        if(bActorHidden)
        {
            CaptionComponent.Hide();
            SetCollision(false, false);
            SetCollisionType(1);            
        }
        else
        {
            CaptionComponent.Show();
            SetCollision(default.bCollideActors, default.bBlockActors);
            SetCollisionType(default.CollisionType);
        }        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local EvilPawn P;
    local EvilPlayerController PC;

    // End:0x0F
    if(bHidden)
    {
        return;
    }
    P = EvilPawn(Other);
    super.Touch(Other, OtherComp, HitLocation, HitNormal);
    // End:0xBB
    if(P != none)
    {
        PC = EvilPlayerController(P.Controller);
        // End:0xBB
        if(PC != none)
        {
            Pickup(P);
        }
    }
    //return;    
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    super.OnToggleHidden(Action);
    // End:0x9E
    if(Action.InputLinks[0].bHasImpulse)
    {
        PickupMesh.SetHidden(true);
        CaptionComponent.Hide();
        SetCollision(false, false);
        SetCollisionType(1);        
    }
    else
    {
        // End:0x142
        if(Action.InputLinks[1].bHasImpulse)
        {
            PickupMesh.SetHidden(false);
            CaptionComponent.Show();
            SetCollision(default.bCollideActors, default.bBlockActors);
            SetCollisionType(default.CollisionType);            
        }
        else
        {
            PickupMesh.SetHidden(!bHidden);
            // End:0x1AE
            if(bHidden)
            {
                CaptionComponent.Hide();
                SetCollision(false, false);
                SetCollisionType(1);                
            }
            else
            {
                CaptionComponent.Show();
                SetCollision(default.bCollideActors, default.bBlockActors);
                SetCollisionType(default.CollisionType);
            }
        }
    }
    bActorHidden = bHidden;
    //return;    
}

event OnSleepRBPhysics()
{
    super.OnSleepRBPhysics();
    // End:0x129
    if(CurrentKActor != none)
    {
        SetLocation(CurrentKActor.Location);
        SetRotation(CurrentKActor.Rotation);
        // End:0xE7
        if(CurrentKActor.bDeleteMe)
        {
            // End:0xE4
            if((PickupMesh != none) && PickupMesh.Owner != self)
            {
                PickupMesh.DetachFromAny();
                AttachComponent(PickupMesh);
            }            
        }
        else
        {
            CurrentKActor.MakeStatic();
            CurrentKActor.Destroy();
        }
        CurrentKActor = none;
    }
    SetCollision(default.bCollideActors, default.bBlockActors);
    SetCollisionType(default.CollisionType);
    //return;    
}

event EncroachedBy(Actor Other)
{
    // End:0x42
    if(Other.IsA('InterpActor'))
    {
        MinFloorZToLand = MinFloorZWhenSlipping;
        StartFalling();
    }
    super.EncroachedBy(Other);
    //return;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    MinFloorZToLand = default.MinFloorZToLand;
    //return;    
}

simulated function StartFalling(optional Vector InStartVelocity, optional Pawn InInstigator)
{
    //return;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__EvilTouchPickUp_Base.CollisionCylinder'
    begin object name=CollisionCylinder class=Class'Engine.CylinderComponent'
        CollisionHeight=60.0000000
        CollisionRadius=60.0000000
        ReplacementPrimitive=none
        CollideActors=true
    end object
    CylinderComponent=CollisionCylinder
    // Reference: StaticMeshComponent'Default__EvilTouchPickUp_Base.PickupMeshComp'
    begin object name=PickupMeshComp class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        bIgnoreOwnerHidden=true
        bCastStaticShadow=false
        LightingChannels=(Dynamic=true,Unnamed_6=true,Gameplay_1=true)
    end object
    PickupMesh=PickupMeshComp
    // Reference: EvilCaptionComponent'Default__EvilTouchPickUp_Base.CaptionComp'
    begin object name=CaptionComp class=Class'EvilCaptionComponent'
        Use3DCaption=false
    end object
    CaptionComponent=CaptionComp
    MaxPickCount=1
    CheckSameDropDistance=200.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__EvilTouchPickUp_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
        bCastShadows=false
        bUseBooleanEnvironmentShadowing=false
    end object
    LightEnvironment=MyLightEnvironment
    MinFloorZToLand=0.7000000
    MinFloorZWhenSlipping=0.9700000
    Components[0]=CollisionCylinder
    Components[1]=PickupMeshComp
    Components[2]=MyLightEnvironment
    Components[3]=CaptionComp
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    CollisionType=ECollisionType.COLLIDE_TouchAll
    bAlwaysRelevant=true
    bCollideActors=true
    bCollideWorld=true
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}