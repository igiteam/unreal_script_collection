class EvilUsePickupTrigger extends Trigger
    hidecategories(Navigation);

var EvilUsePickUp_Base PickupItem;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        PickupItem;
}

function bool UsedBy(Pawn User)
{
    PickupItem.Used(User);
    return true;
    //return ReturnValue;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    PickupItem.TriggerTouched(Other, OtherComp, HitLocation, HitNormal);
    super.Touch(Other, OtherComp, HitLocation, HitNormal);
    //return;    
}

event UnTouch(Actor Other)
{
    PickupItem.TriggerUnTouched(Other);
    super(Actor).UnTouch(Other);
    //return;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__EvilUsePickupTrigger.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=128.0000000
        CollisionRadius=256.0000000
        ReplacementPrimitive=none
        CollideActors=false
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__EvilUsePickupTrigger.Sprite'
    begin object name=Sprite
        ReplacementPrimitive=none
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    bNoDelete=false
    CollisionComponent=CollisionCylinder
    GeneratedEvents=/* Array type was not detected. */
}