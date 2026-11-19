class EvilUsePickUp_Base extends EvilTouchPickUp_Base
    abstract
    notplaceable
    hidecategories(Navigation)
    implements(EvilUsableInfoInterface);

var EvilUsePickupTrigger PickupTrigger;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        PickupTrigger;
}

protected simulated function SpawnTrigger()
{
    // End:0xB2
    if(int(Role) == int(ROLE_Authority))
    {
        PickupTrigger = Spawn(Class'EvilUsePickupTrigger', self,, Location);
        PickupTrigger.PickupItem = self;
        PickupTrigger.SetBase(self);
        PickupTrigger.CylinderComponent.SetActorCollision(true, false);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SpawnTrigger();
    //return;    
}

simulated function Destroyed()
{
    // End:0x3D
    if((PickupTrigger != none) && int(Role) == int(ROLE_Authority))
    {
        PickupTrigger.Destroy();
    }
    super(Actor).Destroyed();
    //return;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    //return;    
}

function TriggerTouched(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    //return;    
}

function TriggerUnTouched(Actor Other)
{
    //return;    
}

function Used(Pawn User)
{
    // End:0x0F
    if(bHidden)
    {
        return;
    }
    PickupTrigger.UnTouch(User);
    Pickup(EvilPawn(User));
    //return;    
}

simulated function bool IsUsable()
{
    return true;
    //return ReturnValue;    
}

simulated function bool IsUsableAndActive()
{
    return true;
    //return ReturnValue;    
}

simulated function bool CanBeUsedNow(PlayerController PC)
{
    return (EvilPlayerController(PC) != none) && EvilPlayerController(PC).UsableTrigger == PickupTrigger;
    //return ReturnValue;    
}

simulated function float GetInteractRange()
{
    local SequenceEvent SeqEvent;

    // End:0x7E
    if(PickupTrigger != none)
    {
        // End:0x7D
        foreach PickupTrigger.GeneratedEvents(SeqEvent)
        {
            // End:0x7C
            if(SeqEvent_Used(SeqEvent) != none)
            {                
                return SeqEvent_Used(SeqEvent).InteractDistance;
            }            
        }        
    }
    return 0.0000000;
    //return ReturnValue;    
}

event OnSleepRBPhysics()
{
    super.OnSleepRBPhysics();
    PickupTrigger.PickupItem = none;
    PickupTrigger.Destroy();
    PickupTrigger = none;
    SpawnTrigger();
    //return;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__EvilUsePickUp_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=1.0000000
        CollisionRadius=1.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: StaticMeshComponent'Default__EvilUsePickUp_Base.PickupMeshComp'
    begin object name=PickupMeshComp
        ReplacementPrimitive=none
    end object
    PickupMesh=PickupMeshComp
    // Reference: EvilCaptionComponent'Default__EvilUsePickUp_Base.CaptionComp'
    begin object name=CaptionComp
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__EvilUsePickUp_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=PickupMeshComp
    Components[2]=MyLightEnvironment
    Components[3]=CaptionComp
    CollisionType=ECollisionType.COLLIDE_CustomDefault
    CollisionComponent=CollisionCylinder
}