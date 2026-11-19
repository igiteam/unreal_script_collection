class ActorFactorySkeletalMesh extends ActorFactory
    native
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() SkeletalMesh SkeletalMesh;
var() AnimSet AnimSet;
var() name AnimSequenceName;
var class<Actor> GameplayActorClass;

defaultproperties
{
    GameplayActorClass=Class'SkeletalMeshActorSpawnable'
    MenuName="Add SkeletalMesh"
    NewActorClass=Class'SkeletalMeshActor'
}