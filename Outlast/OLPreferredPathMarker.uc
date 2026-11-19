class OLPreferredPathMarker extends OLGameplayMarker
	native
	placeable;

var() OLPreferredPathMarker Next;

defaultproperties
{
	bEnabled=true

	Begin Object Name=Sprite
		Sprite=Texture2D'EditorResources.PathLinear'
		Scale=1.0
	End Object	
}
