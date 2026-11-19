class PKProjectile_Heater_Base extends EvilProjectile_Bouncing_Base
    abstract
    hidecategories(Navigation);

var int BounceCounter;

simulated function bool ShouldBounce(Actor Touched, Vector HitNormal, optional PrimitiveComponent HitComponent)
{
    local bool Result;

    Result = super.ShouldBounce(Touched, HitNormal, HitComponent);
    // End:0xB7
    if(Result)
    {
        BounceCounter++;
        // End:0xB7
        if((BounceCounter > 2) || (PKPlayerPawn(Instigator) != none) && PainPRI(Instigator.PlayerReplicationInfo).bHasWeaponModifier)
        {
            return false;
        }
    }
    return Result;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__PKProjectile_Heater_Base.StaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMesh'
    // Archetype: StaticMeshComponent'EvilGame.Default__EvilProjectile_Bouncing_Base.StaticMesh'
    begin object name="StaticMesh"
        ReplacementPrimitive=none
    end object
    Mesh=StaticMesh
    VelocityDampingFactor=0.7000000
    Bounciness=1.4000000
    InitialRotationRate=(Pitch=7000,Yaw=5000,Roll=20000)
    bAddVelocityFromInstigator=true
    bAddOnlyForwardVelocityFromInstigator=true
    TossZ=400.0000000
    CustomGravityScaling=1.5000000
    Speed=1000.0000000
    MaxSpeed=1000.0000000
    MyDamageType=Class'PKDmgType_Heater'
    // Reference: CylinderComponent'Default__PKProjectile_Heater_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Bouncing_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    CollisionComponent=StaticMesh
}