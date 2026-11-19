class OLAmbientSound extends AkAmbientSound
	dependson(OLTypes)
	native;

var() bool bAllowVirtualization;
var() array<OLAmbientSoundClone> Clones;
	
cpptext
{
	virtual void PreEditChange(UProperty* PropertyThatWillChange);
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void Playing( UBOOL in_IsPlaying );
	virtual void SetVolumes(const TArray<class AVolume*>& Volumes);
}

defaultproperties
{
	bAllowVirtualization=false

	Begin Object NAME=Sprite
		SpriteCategoryName="OutlastSound"
	End Object
}