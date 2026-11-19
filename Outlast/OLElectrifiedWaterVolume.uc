class OLElectrifiedWaterVolume extends PhysicsVolume
	native;

var() bool bElectrified;

simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		bElectrified = true;
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bElectrified = false;
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		bElectrified = !bElectrified;
	}

	Super.OnToggle( Action );
}

defaultproperties
{
	DamagePerSec=25.0
}
