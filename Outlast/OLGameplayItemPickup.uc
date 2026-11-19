class OLGameplayItemPickup extends OLPickableObject
	native
	placeable;

var() name ItemName;
var() name LastValidCheckpoint;
var() AkEvent PickupSound;

cpptext
{
	virtual void Pickup(AOLHero* hero);
	FString GetPickableName();
	void Reset();
}

native function bool ShouldShowItem();

function PostBeginPlay()
{
	if (LastValidCheckpoint != '' && !ShouldShowItem())
	{
		SetHidden(true);
	}
}

defaultproperties
{
	ItemName="Dumbledore"

	Begin Object Name=PickupMeshComp
		StaticMesh=StaticMesh'Electronic.Keypad.Keycard'
	End Object
	PickupMesh=PickupMeshComp

	PickupSound=AkEvent'Player_Sound.Pick_Up_Object'	
}