////////////////////////////////////////////
// TriggerMutliEvent.uc
////////////////////////////////////////////

class TriggerMultiEvent extends Trigger;

var() array<name> EventArray;

/* 
Trigger an event
*/
event TriggerEvent( Name EventName, Actor Other, Pawn EventInstigator )
{
	local Actor A;
	local int i;
	local int EventSize;
	
	EventSize = EventArray.Length;
	
	Super.TriggerEvent( EventName, Other, EventInstigator );

	//Loop through the EventArray
	for( i = 0; i < EventSize; ++i )
	{	
		// Procede if this is a valid event entry
		if( EventArray[i] != '')
		{		
			ForEach DynamicActors( class 'Actor', A, EventArray[i] )
				A.Trigger(Other, EventInstigator);
		}
	}
}

/*
Untrigger an event
*/
function UntriggerEvent( Name EventName, Actor Other, Pawn EventInstigator )
{
	local Actor A;
	local int i;
	local int EventSize;
	
	EventSize = EventArray.Length;

	Super.UntriggerEvent( EventName, Other, EventInstigator );

	// Loop through the EventArray
	for( i = 0; i < EventSize; ++i )
	{
		// Procede if this is a valid event entry
		if( EventArray[i] != '' )
		{	
			ForEach DynamicActors( class 'Actor', A, EventName )
				A.Untrigger(Other, EventInstigator);
		}
	}
}
