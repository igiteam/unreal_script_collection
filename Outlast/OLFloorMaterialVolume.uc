class OLFloorMaterialVolume extends Volume
	native
	placeable;

var() bool bEnabled;

/** Highest priority wins */
var() int Priority;
var()	PhysicalMaterial PhysMaterial;

simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		bEnabled=true;
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bEnabled=false;
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		bEnabled = !bEnabled;
	}
}

defaultproperties
{	
	bEnabled=true
	Priority=10
	bForceAllowKismetModification=true

	Begin Object Name=BrushComponent0
		CollideActors=true
		BlockActors=false
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		BlockRigidBody=false
	End Object

	bColored=true
	BrushColor=(R=0,G=245,B=55,A=255)
}
