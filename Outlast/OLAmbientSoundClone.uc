class OLAmbientSoundClone extends Actor
	native
	placeable;

var SpriteComponent SpriteComp;

var() editconst OLAmbientSound Master;
var() bool bAllowVirtualization;

cpptext
{
	virtual void SetVolumes(const TArray<class AVolume*>& Volumes);
}

defaultproperties
{
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'Utility.SoundClone'
		HiddenGame=True
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
		SpriteCategoryName="OutlastSound"
	End Object
	Components.Add(Sprite)
	SpriteComp=Sprite;
}