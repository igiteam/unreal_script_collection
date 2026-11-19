class SPDKAsset extends SPKAsset
    native;

/** VARIABLE DECLARATIONS */
var(DestructComponent) const editconst export editinline SPActorDestructComponent DestructComponent;
var export editinline DrawSphereComponent RenderComponent;
var export editinline DrawSphereComponent PreviewSphere;

event Landed(Vector HitNormal, Actor FloorActor)
{
    TakeFallingDamage();
    //return;    
}

function TakeFallingDamage()
{
    local int Damage;

    Damage = DestructComponent.SpeedToDamage(Velocity.Z);
    // End:0x60
    if(Damage > 0)
    {
        TakeDamageAndProcEffects(float(Damage), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Fell');
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SkeletalMeshComponent.SetPhysicsWeight(1.0000000);
    //return;    
}
