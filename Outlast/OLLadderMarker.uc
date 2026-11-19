class OLLadderMarker extends OLGameplayMarker
	native
	placeable;

var() OLLadderMarker OtherMarker;

cpptext
{
	virtual UBOOL IsValid() const { return Super::IsValid() && OtherMarker && OtherMarker->bEnabled && OtherMarker->OtherMarker == this; }
}

defaultproperties
{
	bEnabled=true

	Begin Object Class=ArrowComponent Name=ArrowComponent0
		ArrowColor=(R=173,G=183,B=243)
		bTreatAsASprite=True
		SpriteCategoryName="OutlastGameplay"
	End Object
	Components.Add(ArrowComponent0)
}
