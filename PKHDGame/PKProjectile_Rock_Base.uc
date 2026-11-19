class PKProjectile_Rock_Base extends EvilProjectile_Pinnable_Base
    abstract
    hidecategories(Navigation);

var Rotator RotRate;
var float RotDelay;

function Init(Vector Direction)
{
    RotRate = MakeRotator(int((FRand() * 182.0444000) * 360.0000000), int((FRand() * 182.0444000) * 360.0000000), int((FRand() * 182.0444000) * 360.0000000));
    Mesh.SetRotation(PKPawn(Instigator).ProjectileSM.GetRotation() - Rotation);
    super(EvilProjectile_Base).Init(Direction);
    //return;    
}

simulated event Tick(float DeltaTime)
{
    local Rotator NewRotation;

    RotDelay -= DeltaTime;
    // End:0xAD
    if((RotDelay <= float(0)) && VSizeSq(Velocity) > 16.0000000)
    {
        NewRotation = Mesh.Rotation;
        NewRotation += (DeltaTime * RotRate);
        Mesh.SetRotation(NewRotation);
    }
    //return;    
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    local Vector MirroredVelocity;

    MirroredVelocity = MirrorVectorByNormal(Velocity, HitNormal);
    super(EvilProjectile_Base).Explode(HitLocation, Normal(MirroredVelocity));
    //return;    
}

defaultproperties
{
    RotDelay=0.1000000
    // Reference: EvilDissolvingStaticMeshComponent'Default__PKProjectile_Rock_Base.StaticMesh'
    // Archetype: EvilDissolvingStaticMeshComponent'EvilGame.Default__EvilProjectile_Pinnable_Base.StaticMesh'
    begin object name="StaticMesh"
        ReplacementPrimitive=none
    end object
    Mesh=StaticMesh
    bIsManuallyAttached=true
    bWaitForEffects=true
    CustomGravityScaling=0.8000000
    DamageRadius=0.0000000
    MyDamageType=Class'PKDmgType_Bolt'
    // Reference: CylinderComponent'Default__PKProjectile_Rock_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Pinnable_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    CollisionComponent=CollisionCylinder
}