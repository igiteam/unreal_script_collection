class PKProjectile_Molotov_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

var Rotator RotRate;
var float RotDelay;

function Init(Vector Direction)
{
    RotRate = MakeRotator(int((FRand() * 182.0444000) * 360.0000000), int((FRand() * 182.0444000) * 360.0000000), int((FRand() * 182.0444000) * 360.0000000));
    super.Init(Direction);
    //return;    
}

simulated event Tick(float DeltaTime)
{
    local Rotator NewRotation;

    RotDelay -= DeltaTime;
    // End:0xAD
    if((RotDelay <= float(0)) && VSizeSq(Velocity) > 16.0000000)
    {
        NewRotation = ProjEffects.Rotation;
        NewRotation += (DeltaTime * RotRate);
        ProjEffects.SetRotation(NewRotation);
    }
    //return;    
}

defaultproperties
{
    RotDelay=0.2000000
    Speed=800.0000000
    MaxSpeed=1000.0000000
    MyDamageType=Class'PKDmgType_Grenade'
    // Reference: CylinderComponent'Default__PKProjectile_Molotov_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Physics=EPhysics.PHYS_Falling
    CollisionComponent=CollisionCylinder
}