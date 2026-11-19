class OLSoundEmittingMeshActor extends StaticMeshActor
	native;

var() AkEvent PlayEvent;
var() bool bAllowVirtualization;
var() bool bEnableMultiPosition;

cpptext
{
	virtual void PostBeginPlay();
	virtual void OnRemoveFromWorld();	
}

defaultproperties
{
	bStatic=true
	bRouteBeginPlayEvenIfStatic=true
	bAllowVirtualization=false
	bEnableMultiPosition=true
}
