class ACTION_DemiGodMode extends ScriptedAction;

var() bool DemiGod;
var() name DemiGodTag;

function bool InitActionFor(ScriptedController C)
{
	local ZombiePawn ZP;

	if ( ( DemiGodTag == 'None' ) || ( DemiGodTag == '') )
	{
		ZP = ZombiePawn ( C.GetInstigator ( ) );
		if ( ZP != none )
		{
			ZP.bDemiGod = DemiGod;
		}
	}
	else
	{
		ForEach C.AllActors ( class'ZombiePawn', ZP, DemiGodTag )
		{
			ZP.bDemiGod = DemiGod;
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
    DemiGodTag="'"
    ActionString="Set DemiGodMode"
}