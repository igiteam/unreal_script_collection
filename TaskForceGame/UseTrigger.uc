//=============================================================================
// UseTrigger: if a player stands within proximity of this trigger, and hits Use, 
// it will send Trigger/UnTrigger to actors whose names match 'EventName'.
//=============================================================================
class UseTrigger extends Triggers;

var() localized string Message;
var() bool bDisabled;

function UsedBy( Pawn user )
{
	if ( !bDisabled )
		TriggerEvent(Event, self, user);
}

function Touch( Actor Other )
{
	if( (!bDisabled) && (Message != "") && (Other.Instigator != None) )
		// Send a string message to the toucher.
		Other.Instigator.ClientMessage( Message );
}

function Trigger ( Actor Other, Pawn EventInstigator )
{

	local Actor a;
	bDisabled = !bDisabled;
	if (!bDisabled)
	{
		foreach TouchingActors(class'Actor',a)
		{
			Touch(a);
		}
	}
	else
	{
		foreach TouchingActors(class'Actor',a)
		{
			UnTouch(a);
		}
	}
		
}

