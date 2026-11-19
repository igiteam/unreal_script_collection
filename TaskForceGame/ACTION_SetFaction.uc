class ACTION_SetFaction extends ScriptedAction;

var() EFaction NewFaction;

function bool InitActionFor(ScriptedController C)
{
	if ( ZombiePawn ( C.Pawn ) != None )
	{
		ZombiePawn ( C.Pawn ).Faction = NewFaction;
	}
	
	return false;	
}


// Decompiled with UE Explorer.
defaultproperties
{
    bValidForTrigger=false
}