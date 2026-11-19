class ACTION_GodMode extends ScriptedAction;

var() bool Invincible;
var() name InvincibleTag;

function bool InitActionFor(ScriptedController C)
{
	local ZombiePawn ZP;

	if ( ( InvincibleTag == 'None' ) || ( InvincibleTag == '' ) )
	{
		ZP = ZombiePawn ( C.GetInstigator ( ) );
		if ( ZP != none )
		{
			ZP.bInvincible = Invincible;
		}
	}
	else
	{
		ForEach C.AllActors ( class'ZombiePawn', ZP, InvincibleTag )
		{
			ZP.bInvincible = Invincible;
		}
	}
	return false;	
}

function string GetActionString ( )
{
	return ActionString;
}


// Decompiled with UE Explorer.
defaultproperties
{
    ActionString="Set GodMode"
}