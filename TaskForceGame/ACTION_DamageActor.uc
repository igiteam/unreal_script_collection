class ACTION_DamageActor extends ScriptedAction;

var(Action) int Damage;
var(Action) class<DamageType>		 DamageType;
var(Action) edfindable Actor		 DamageActor;

function bool InitActionFor(ScriptedController C)
{
	if( DamageActor != None ){
		DamageActor.TakeDamage( Damage, C.Pawn, DamageActor.Location, vect(0,0,0), DamageType);
	}
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
    ActionString="Damage Actor"
}