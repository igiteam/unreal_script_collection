class ACTION_DestroyActor extends ScriptedAction;

var(Action)		name			DestroyTag;

function bool InitActionFor(ScriptedController C)
{
	local Actor A;
	local Pawn	P;

	if ( DestroyTag != 'None' )
	{
		ForEach C.AllActors ( class'Actor', A, DestroyTag )
		{
			P = Pawn ( A );
			if ( P != None )
			{
				if ( ScriptedController ( P.Controller ) != None )
				{
					ScriptedController ( P.Controller ).DestroyPawn ( );
				}
			}
			else
			{
				A.Destroy();
			}
		}
	}

	return false;	
}

function string GetActionString()
{
	return ActionString;
}


// Decompiled with UE Explorer.
defaultproperties
{
    ActionString="Destroy actor"
}