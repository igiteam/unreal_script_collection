class OLAIInvestigationPoint extends Actor
	placeable
	native(AI);

var() name AnimToPlay;
var() bool bUseRotation;
var() float WeightOverride;

defaultproperties
{
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'Utility.InvestigationPoint-01_D'
		Scale=0.15
		SpriteCategoryName="OutlastGameplay"
		HiddenGame=true
		HiddenEditor=false
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
	End Object
	Components.Add(Sprite)

	Begin Object Class=ArrowComponent Name=Arrow
		ArrowColor=(R=150,G=200,B=255)
		ArrowSize=0.5
		bTreatAsASprite=True
		HiddenGame=true
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
		SpriteCategoryName="OutlastGameplay"
		Translation=(Z=50.f) // plalonde - Adjusting for lower spawn point.
	End Object
	Components.Add(Arrow)
	
	bEdShouldSnap=True
	WeightOverride=-1.0
}