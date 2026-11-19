class ActorFactoryOLAmbientSound extends ActorFactoryAkAmbientSound
	config(Editor)
	collapsecategories
	hidecategories(Object)
	native;

cpptext
{
	virtual UBOOL CanCreateActor(FString& OutErrorMsg, UBOOL bFromAssetOnly = FALSE);	
}

defaultproperties 
{
	MenuName="Add OLAmbientSound"
	NewActorClass=class'OLGame.OLAmbientSound'
}
