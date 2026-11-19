class PKShadowlandBlockingVolume extends DynamicBlockingVolume
    hidecategories(Navigation,Object,Display);

var Actor LockInstigator;
var float TouchDistance;

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x16E
    if(Other.IsA('PKPlayerPawn'))
    {
        Other.MoveSmooth((vect(1.0000000, 1.0000000, 0.0000000) * Normal((Other.Location - Location) * vect(1.0000000, 1.0000000, 0.0000000))) * float(16));
        Other.Velocity = Normal((Other.Location - Location) * vect(1.0000000, 1.0000000, 0.0000000)) * float(16);
        SetCollisionType(2);
        SetTimer(0.1000000, false, 'Unlock', self);
        LockInstigator = Other;
        TouchDistance = VSize2D(Other.Location - Location);
        UnTouch(Other);
    }
    //return;    
}

function Unlock()
{
    // End:0x57
    if(VSize2D(LockInstigator.Location - Location) > (2.0000000 * TouchDistance))
    {
        SetCollisionType(4);        
    }
    else
    {
        SetTimer(0.1000000, false, 'Unlock', self);
    }
    //return;    
}

defaultproperties
{
    // Reference: BrushComponent'Default__PKShadowlandBlockingVolume.BrushComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BrushComponent0'
    // Archetype: BrushComponent'Engine.Default__DynamicBlockingVolume.BrushComponent0'
    begin object name="BrushComponent0"
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}