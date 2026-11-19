class EffectsVolume extends Volume;

var() class<Actor> AffectedClass;
var array<Actor> ObjectsWithinVolume;

//simulated function PostBeginPlay()
//{
//	RetrieveObjects();
//}
/**	Handling Toggle event from Kismet. */
simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{

	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		
	}
}

// Go through all the AffectedClass Actors and F
// Find ones that have the LocationName of Volume inside the ObjectTag of the Actor
// Fill in
function RetrieveObjects()
{
	local Actor A; 
	local int Counter;

	if (ObjectsWithinVolume.Length > 0)
		return;

	foreach AllActors(AffectedClass,A)
	{
		if (InStr(string(A.Tag), LocationName) == -1)
			continue;
		if (!Encompasses(A))
			continue;
		
		ObjectsWithinVolume.Insert(Counter,1);
		ObjectsWithinVolume[Counter] = A;
		Counter++;
	}
}

