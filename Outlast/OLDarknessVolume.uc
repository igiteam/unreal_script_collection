class OLDarknessVolume extends PhysicsVolume
	native;

var() bool bDark;
var() bool bOnlyDarkWhenCrouched;
var transient bool bInitiallyDark;

cpptext
{
	virtual void PostBeginPlay()
	{
		Super::PostBeginPlay();
		bInitiallyDark = bDark;
	}

	virtual void Reset()
	{
		bDark = bInitiallyDark;
	}
}

simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		bDark = true;
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bDark = false;
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		bDark = !bDark;
	}

	Super.OnToggle( Action );
}

defaultproperties
{
}
