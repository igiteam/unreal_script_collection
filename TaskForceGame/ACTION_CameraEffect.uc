class ACTION_CameraEffect extends ScriptedAction;

var() editinline CameraEffect	CameraEffect;

function bool InitActionFor(ScriptedController C)
{
	local PlayerController pc;

	ForEach C.DynamicActors(class'PlayerController', pc)
	{
		pc.AddCameraEffect(CameraEffect);
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
    ActionString="Add Cam Effect"
}