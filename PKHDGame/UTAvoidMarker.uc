class UTAvoidMarker extends Actor
    notplaceable
    hidecategories(Navigation);

var export editinline CylinderComponent CollisionCylinder;

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    //return;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__UTAvoidMarker.Cylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'Cylinder'
    begin object name="Cylinder" class=Class'Engine.CylinderComponent'
        CollisionHeight=40.0000000
        CollisionRadius=100.0000000
        ReplacementPrimitive=none
        CollideActors=true
    end object
    CollisionCylinder=Cylinder
    Components[0]=none
    Components[1]=Cylinder
    bCollideActors=true
    CollisionComponent=Cylinder
}