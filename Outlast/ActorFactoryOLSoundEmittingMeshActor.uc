class ActorFactoryOLSoundEmittingMeshActor extends ActorFactoryStaticMesh
	config(Editor)
	collapsecategories
	hidecategories(Object)
	native;

var()	AKEvent	StartEvent;
var()	AKEvent	StopEvent;

defaultproperties 
{
	MenuName="Add OLSoundEmittingMeshActor"
	NewActorClass=class'OLGame.OLSoundEmittingMeshActor'
}
