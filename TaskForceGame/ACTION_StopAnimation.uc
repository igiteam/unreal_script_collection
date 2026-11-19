class ACTION_StopAnimation extends ScriptedAction;

var(Action) bool	bExceptBase;


function bool InitActionFor(ScriptedController C)
{
	C.Pawn.StopAnimating( bExceptBase );
	return false;
}


// Decompiled with UE Explorer.
defaultproperties
{
    ActionString="stop animation"
    bValidForTrigger=false
}