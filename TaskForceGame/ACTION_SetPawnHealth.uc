class ACTION_SetPawnHealth extends ScriptedAction;

var(Action) float	NewHealth;

function bool InitActionFor(ScriptedController C)
{
	if ( C.Pawn != None ) 
	{
		C.Pawn.Health = NewHealth;
	}
	
	return false;
}


// Decompiled with UE Explorer.
defaultproperties
{
    NewHealth=100.0000000
    ActionString="Set Pawn Health"
}