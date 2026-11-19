class OLCornerMarker extends OLGameplayMarker
	native
	placeable;

var() bool b3Sided;
var() bool bRoundedCorner;

/** Used only when 3-sided */
var() float WallThickness;

var() bool bCanPeekFromLeftStanding;
var() bool bCanPeekFromRightStanding;
var editconst bool bCanPeekFromLeftCrouched;
var editconst bool bCanPeekFromRightCrouched;

var() editconst string BoundStaticMesh;

cpptext
{
	void CopyFrom(const AOLCornerMarker* refMarker)
	{
		b3Sided = refMarker->b3Sided;
		bRoundedCorner = refMarker->bRoundedCorner;
		WallThickness = refMarker->WallThickness;
		bCanPeekFromLeftStanding = refMarker->bCanPeekFromLeftStanding;
		bCanPeekFromRightStanding = refMarker->bCanPeekFromRightStanding;
		bCanPeekFromLeftCrouched = refMarker->bCanPeekFromLeftCrouched;
		bCanPeekFromRightCrouched = refMarker->bCanPeekFromRightCrouched;
		BoundStaticMesh = refMarker->BoundStaticMesh;
	}
}

defaultproperties
{
	b3Sided=false
	bCanPeekFromLeftStanding=true
	bCanPeekFromRightStanding=true
	bCanPeekFromLeftCrouched=false
	bCanPeekFromRightCrouched=false
	WallThickness=16.0

	Begin Object Name=Sprite
		Sprite=Texture2D'MobileResources.HUD.AnalogHat'
	End Object
}
