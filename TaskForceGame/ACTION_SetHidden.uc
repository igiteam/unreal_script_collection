class ACTION_SetHidden extends ScriptedAction;

var(Action) bool bHidden;					// boolean
var(Action) edfindable Actor ActorToHide;	// actor to set drawscale for

function bool InitActionFor(ScriptedController C)
{
	if ( ActorToHide != None ) {
	
		ActorToHide.bHidden = bHidden;
	}
	
	return false;
}

function string GetActionString()
{
	return ActionString@ActorToHide;
}


// Decompiled with UE Explorer.
defaultproperties
{
    ActionString="SetHidden"
}