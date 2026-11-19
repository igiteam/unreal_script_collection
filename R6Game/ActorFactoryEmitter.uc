class ActorFactoryEmitter extends ActorFactory
    native
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() ParticleSystem ParticleSystem;
var class<Actor> GameplayActorClass;

defaultproperties
{
    GameplayActorClass=Class'R6SpawnableEmitter'
    MenuName="Add Emitter"
    NewActorClass=Class'Emitter'
}