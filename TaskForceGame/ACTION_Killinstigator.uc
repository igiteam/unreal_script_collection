class ACTION_KillInstigator extends ScriptedAction;

var() class<DamageType>		 DamageType;

function bool InitActionFor(ScriptedController C)
{
	if ( C.GetInstigator() != None )
	{
		C.GetInstigator().Died( None, DamageType, C.Instigator.Location );
	}
	return false;	
}

function string GetActionString()
{
	return ActionString@DamageType;
}


// Decompiled with UE Explorer.
defaultproperties
{
    DamageType=Class'Engine.Crushed'
    ActionString="Damage instigator"
}