class OLSqueezeVolume extends OLGameplayVolume
	native
	config(Game)
	placeable;

var() OLGameplayMarker Node1;
var() OLGameplayMarker Node2;

var() bool bCanLookLeft;
var() bool bCanLookRight;
var() bool bNoHands;

cpptext
{
	virtual UBOOL IsValid() const { return Super::IsValid() && Node1 && Node2 && (bCanLookLeft || bCanLookRight); }
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
}

defaultproperties
{
	Begin Object Name=BrushComponent0
		HiddenEditor=false
	End Object

	RemoteRole=ROLE_SimulatedProxy

	bCanLookLeft=true;
	bCanLookRight=true;
}
