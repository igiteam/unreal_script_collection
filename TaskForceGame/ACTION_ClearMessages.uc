class ACTION_ClearMessages extends ScriptedAction;

function bool InitActionFor(ScriptedController C)
{
	local PlayerController pc;

/*	pc = PlayerController(C.GetInstigator().Controller); 

	if (pc != none)
	{
		pc.myHud.ClearMessages();
	}*/

	ForEach C.DynamicActors(class'PlayerController', pc)
	{
		pc.myHud.ClearMessages();
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
    ActionString="clear messages"
}