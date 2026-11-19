class EvilBloodGlob extends EvilProjectile_Base
    hidecategories(Navigation);

var array<MaterialInterface> BloodDecal;

function Init(Vector Direction)
{
    local Vector Dir;

    Dir = Direction;
    Dir.Z = FRand() * float(1);
    SetRotation(Rotator(Direction));
    Velocity = (Speed * Normal(Dir)) * ((FRand() * 0.4000000) + 0.8000000);
    //return;    
}

simulated function Landed(Vector HitNormal, Actor FloorActor)
{
    local MaterialInterface Decal;
    local float Scale;
    local MaterialInstanceTimeVarying MITV_Decal;

    // End:0x30
    if(BloodDecal.Length > 0)
    {
        Decal = BloodDecal[Rand(BloodDecal.Length)];
    }
    Scale = (FRand() * 0.4000000) + 0.8000000;
    // End:0x171
    if(MaterialInstanceTimeVarying(Decal) != none)
    {
        MITV_Decal = new (self) Class'Engine.MaterialInstanceTimeVarying';
        MITV_Decal.SetParent(Decal);
        WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, Location, Rotator(-HitNormal), DecalWidth * ((FRand() * 0.4000000) + 0.8000000), DecalHeight * ((FRand() * 0.4000000) + 0.8000000), 10.0000000, false,,,,,,, 6);
        MITV_Decal.SetScalarStartTime(DecalDissolveParamName, DurationOfDecal);        
    }
    else
    {
        WorldInfo.MyDecalManager.SpawnDecal(Decal, Location, Rotator(-HitNormal), DecalWidth * Scale, DecalHeight * Scale, 10.0000000, true);
    }
    Destroy();
    //return;    
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    Landed(HitNormal, Wall);
    //return;    
}

defaultproperties
{
    DecalWidth=50.0000000
    DecalHeight=50.0000000
    DurationOfDecal=0.0000000
    Speed=250.0000000
    // Reference: CylinderComponent'Default__EvilBloodGlob.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilProjectile_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Physics=EPhysics.PHYS_Falling
    bCollideActors=false
    bCollideComplex=false
    CollisionComponent=CollisionCylinder
}