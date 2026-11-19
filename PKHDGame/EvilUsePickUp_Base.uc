class EvilUsePickUp_Base extends EvilTouchPickUp_Base
    abstract
    notplaceable
    hidecategories(Navigation)
    implements(EvilUsableInfoInterface);

var EvilUsePickupTrigger PickupTrigger;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0xBC
    if(int(Role) == int(ROLE_Authority))
    {
        PickupTrigger = Spawn(Class'EvilUsePickupTrigger', self,, Location);
        PickupTrigger.PickupItem = self;
        PickupTrigger.SetBase(self);
        PickupTrigger.CylinderComponent.SetActorCollision(true, false);
    }
    //return;    
}

simulated function Destroyed()
{
    // End:0x27
    if(PickupTrigger != none)
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

simulated function TriggerTouched(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    //return;    
}

simulated function TriggerUnTouched(Actor Other)
{
    //return;    
}

function Used(Pawn User)
{
    CaptionComponent.SetCaptionCustom("");
    PickupTrigger.UnTouch(User);
    Pickup(EvilPawn(User));
    //return;    
}

function bool IsUsable()
{
    return true;
    //return ReturnValue;    
}

function bool IsUsableAndActive()
{
    return true;
    //return ReturnValue;    
}

function bool CanBeUsedNow(PlayerController PC)
{
    return (EvilPlayerController(PC) != none) && EvilPlayerController(PC).UsableTrigger == PickupTrigger;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__EvilUsePickUp_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilTouchPickUp_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=1.0000000
        CollisionRadius=1.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: StaticMeshComponent'Default__EvilUsePickUp_Base.PickupMeshComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMeshComp'
    // Archetype: StaticMeshComponent'Default__EvilTouchPickUp_Base.PickupMeshComp'
    begin object name="PickupMeshComp"
        ReplacementPrimitive=none
    end object
    PickupMesh=PickupMeshComp
    // Reference: EvilCaptionComponent'Default__EvilUsePickUp_Base.CaptionComp'
    // Archetype: EvilCaptionComponent'Default__EvilTouchPickUp_Base.CaptionComp'
    begin object name="CaptionComp"
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__EvilUsePickUp_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilTouchPickUp_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=PickupMeshComp
    Components[2]=MyLightEnvironment
    Components[3]=CaptionComp
    CollisionComponent=CollisionCylinder
}