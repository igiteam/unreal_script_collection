class MOHADetachedHelmet extends MOHADetachedBodyPart
    config(Game)
    notplaceable
    hidecategories(Navigation);

var() config float fMinSpeedForImpactSound;
var() config float fMinTimeBetweenSounds;
var float fLastPlayTime;

event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
    local SoundCue ImpactSound;
    local float fSpeed;
    local PhysicalMaterial OtherMaterial;

    fSpeed = VSize(RigidCollisionData.ContactInfos[0].ContactVelocity[ContactIndex]);
    // End:0xD2
    if((fSpeed >= fMinSpeedForImpactSound) && (fLastPlayTime + fMinTimeBetweenSounds) < WorldInfo.TimeSeconds)
    {
        fLastPlayTime = WorldInfo.TimeSeconds;
        OtherMaterial = RigidCollisionData.ContactInfos[0].PhysMaterial[int(float(ContactIndex + 1) % float(2))];
        ImpactSound = Class'MOHAPhysicalMaterialProperty'.static.GetImpactSound(OtherMaterial, 20, 2);
        PlaySound(ImpactSound);
    }
    //return;    
}

defaultproperties
{
    fMinSpeedForImpactSound=200.0000000
    fMinTimeBetweenSounds=0.2500000
    // Reference: StaticMeshComponent'Default__MOHADetachedHelmet.BodyPartMesh'
    begin object name=BodyPartMesh
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHADetachedHelmet.MyLightEnvironment'
    end object
    Mesh=BodyPartMesh
    // Reference: DynamicLightEnvironmentComponent'Default__MOHADetachedHelmet.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[0]=MyLightEnvironment
    Components[1]=BodyPartMesh
    CollisionComponent=BodyPartMesh
}