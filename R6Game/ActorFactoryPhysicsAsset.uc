class ActorFactoryPhysicsAsset extends ActorFactory
    native
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() PhysicsAsset PhysicsAsset;
var() SkeletalMesh SkeletalMesh;
var() bool bStartAwake;
var() bool bDamageAppliesImpulse;
var() bool bNotifyRigidBodyCollision;
var() Vector InitialVelocity;
var() Vector DrawScale3D;
var class<Actor> GameplayActorClass;

defaultproperties
{
    bStartAwake=true
    bDamageAppliesImpulse=true
    DrawScale3D=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    GameplayActorClass=Class'R6SpawnableKAsset'
    MenuName="Add PhysicsAsset"
    NewActorClass=Class'KAsset'
}