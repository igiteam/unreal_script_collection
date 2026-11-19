class ACTION_UnTriggerEvent extends ScriptedAction;

var(Action) name Event;

function bool InitActionFor ( ScriptedController C ) {

	C.UnTriggerEvent ( Event, C.SequenceScript, C.GetInstigator ( ) );
	return false;
}

function string GetActionString()
{
	return ActionString@Event;
}


// Decompiled with UE Explorer.
defaultproperties
{
    ActionString="untrigger event"
}