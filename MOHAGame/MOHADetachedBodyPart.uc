class MOHADetachedBodyPart extends Actor
    notplaceable
    hidecategories(Navigation);

var export editinline StaticMeshComponent Mesh;
var bool bImmune;
var float fImmuneTime;
var float Mass;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SetTimer(fImmuneTime, false, 'EndImmunity');
    //return;    
}

simulated function EndImmunity()
{
    bImmune = false;
    //return;    
}

event TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    // End:0x36
    if(bImmune)
    {
        return;
    }
    Mesh.SetRBLinearVelocity(Momentum / Mass, true);
    LifeSpan = default.LifeSpan;
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__MOHADetachedBodyPart.BodyPartMesh'
    begin object name=BodyPartMesh class=Class'Engine.StaticMeshComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHADetachedBodyPart.MyLightEnvironment'
        LightingChannels=(bInitialized=true,Characters_Weapons_Vehicles=true)
        BlockActors=false
        RBChannel=5
        RBCollideWithChannels=(Default=true)
        bNotifyRigidBodyCollision=true
        ScriptRigidBodyCollisionThreshold=10.0000000
    end object
    Mesh=BodyPartMesh
    bImmune=true
    fImmuneTime=1.0000000
    Mass=5.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__MOHADetachedBodyPart.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    Components[0]=MyLightEnvironment
    Components[1]=BodyPartMesh
    Physics=10
    bTakesRadiusDamage=true
    bCollideActors=true
    bProjTarget=true
    LifeSpan=30.0000000
    CollisionComponent=BodyPartMesh
    CollisionType=0
}