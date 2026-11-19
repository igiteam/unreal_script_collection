class OLScareMoment extends OLGameplayMarker
	native
	placeable;

var() AkEvent StartEvent;
var() AkEvent StopEvent;
var() name DistanceRTPC;
var() float Range;

var transient bool bPlaying;

cpptext
{
	void UpdateScareRTPC( FLOAT DistToPlayer );
};

event StartScare()
{
	if (!bPlaying)
	{
		PlayAkEvent(StartEvent);

		bPlaying = true;
	}
}

event StopScare()
{
	if (bPlaying)
	{
		PlayAkEvent(StopEvent);

		bPlaying = false;
	}
}

simulated function OnToggle(SeqAct_Toggle Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		bEnabled=true;
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bEnabled=false;
		StopScare();
	}
	else if (Action.InputLinks[2].bHasImpulse)
	{
		bEnabled = !bEnabled;

		if (!bEnabled)
		{
			StopScare();
		}
	}
}

defaultproperties
{
	bEnabled=true
	DistanceRTPC=Distance_of_Scare
	Range=10.0
}