class OLAIInvestigationVolume extends Volume
	placeable
	native(AI);

var array<OLAIInvestigationPoint> Points;
var array<OLHidingSpot> Lockers;
var array<OLBed> Beds;

event ProcessActorSetVolume( Actor Other )
{
	if (Other.IsA('OLAIInvestigationPoint'))
	{
		Points.AddItem(OLAIInvestigationPoint(Other));
	}
	else if (Other.IsA('OLHidingSpot'))
	{
		Lockers.AddItem(OLHidingSpot(Other));
	}
	else if (Other.IsA('OLBed'))
	{
		Beds.AddItem(OLBed(Other));
	}
}

defaultproperties
{
	bProcessAllActors=true
}