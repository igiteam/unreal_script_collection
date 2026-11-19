class CoronaTrigger extends Trigger;

var() bool	UseCorona;
var() bool	bToggle;

function Touch( actor Other )
{
	local Light L;
	Super.Touch(Other);

	if ( (Event == '') || (Event == 'None') )
		return;

	ForEach AllActors( class 'Light', L, Event )
	{
		if(bToggle)
		{
			L.bCorona = !L.bCorona;
		}
		else
		{
			L.bCorona = UseCorona;
		}
	}
}

function Trigger( actor Other, pawn EventInstigator )
{
	Super.Trigger(Other,EventInstigator);
	Touch(Other);
}


// Decompiled with UE Explorer.
defaultproperties
{
    bToggle=true
}