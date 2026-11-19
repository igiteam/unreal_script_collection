class ACTION_WaitIndefinitely extends LatentScriptedAction;


function bool InitActionFor(ScriptedController C)
{
	C.CurrentAction = self;
	return true;
}

function string GetActionString()
{
	return ActionString;
}


// Decompiled with UE Explorer.
defaultproperties
{
    ActionString="Wait indefinitely"
}