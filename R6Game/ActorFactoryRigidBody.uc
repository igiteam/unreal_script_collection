class ActorFactoryRigidBody extends ActorFactoryDynamicSM
    native
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() bool bStartAwake;
var() bool bDamageAppliesImpulse;
var() bool bLocalSpaceInitialVelocity;
var() Vector InitialVelocity;
var class<Actor> GameplayActorClass;

defaultproperties
{
    bStartAwake=true
    bDamageAppliesImpulse=true
    GameplayActorClass=Class'R6SpawnableKActor'
    MenuName="Add RigidBody"
    NewActorClass=Class'KActor'
}