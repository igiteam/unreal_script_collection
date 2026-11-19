class ACTION_DamagePlayer extends ScriptedAction;

var(Action) int Damage;
var(Action) class<DamageType>		 DamageType;

function bool InitActionFor(ScriptedController C)
{
	local Pawn MyPlayer;

	MyPlayer = C.GetMyPlayer();
	MyPlayer.TakeDamage( Damage, MyPlayer, MyPlayer.Location, vect(0,0,0), DamageType);
	return false;	
}

function string GetActionString()
{
	return ActionString@(string(DamageType))@Damage;
}


// Decompiled with UE Explorer.
defaultproperties
{
    Damage=10
    DamageType=Class'Engine.Crushed'
    ActionString="Damage player"
}