class ACTION_KillTag extends ScriptedAction;

var() class<DamageType>		 DamageType;
var() name KillTag;

function bool InitActionFor(ScriptedController C)
{
	local pawn KillTarget;
	ForEach C.AllActors(class'Pawn',KillTarget,KillTag)
	{
		KillTarget.Died( None, DamageType, KillTarget.Location );
	}
	return false;
}

function string GetActionString()
{
	return ActionString@KillTag@DamageType;
}


// Decompiled with UE Explorer.
defaultproperties
{
    DamageType=Class'Engine.Crushed'
    ActionString="Kill Tag"
}