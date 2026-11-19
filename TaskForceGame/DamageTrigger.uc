class DamageTrigger extends Trigger;

Struct DamageTriggerStruct{
	var() vector 			Momentum;
	var() edfindable Actor		TargetActor;
	var() int 			Damage;
	var() class<DamageType> 	DamageType;

};

var(DamageTrigger) array<DamageTriggerStruct>	DamageActors;

function Touch( actor Other )
{
//	local int i;
	Super.Touch(Other);
	
	Trigger(Other,None);
}

function Trigger(Actor Other, Pawn EventInstigator)
{
	local int i;
	
	Super.Trigger(Other,EventInstigator);

	for(i=0; i < DamageActors.Length; i++)
	{
		if( DamageActors[i].Damage > 0 )
		{
			DamageActors[i].TargetActor.TakeDamage( DamageActors[i].Damage, EventInstigator, vect(0,0,0), DamageActors[i].Momentum, DamageActors[i].DamageType);
		}
	}
	
}

