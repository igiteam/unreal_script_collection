class SequenceTrigger extends Triggers;

Struct TimedTriggerStruct{
	var() edfindable Actor		TargetActor;
	var() float			WaitTime;
};

var(SequenceTrigger) array<TimedTriggerStruct>	SequenceActors;

var(SequenceTrigger) enum ETriggerType
{
	ST_PlayerProximity,
	ST_PawnProximity,
	ST_HumanPlayerProximity,
} TriggerType;

var() bool 	bTriggerOnlyOnce;
var() bool 	bInitiallyActive;
var() float	ReTriggerDelay;

// Interal Variables
var float 	TriggerTime;
var actor	lastTouchActor;
var int		i;

function bool IsRelevant( actor Other )
{
	if( !bInitiallyActive )
		return false;
	switch( TriggerType )
	{
		case ST_HumanPlayerProximity:
			return (Pawn(Other) != None) && Pawn(Other).IsHumanControlled();
		case ST_PlayerProximity:
			return (Pawn(Other) != None) && (Pawn(Other).IsPlayerPawn() || Pawn(Other).WasPlayerPawn());
		case ST_PawnProximity:
			return (Pawn(Other) != None);
//			return (Pawn(Other) != None) && Pawn(Other).CanTrigger(self);
	}
}

function Touch( actor Other )
{

	if( IsRelevant( Other ) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}

		lastTouchActor = Other;
		GotoState('SequenceTriggered');		

		if( bTriggerOnlyOnce )
			SetCollision(False);
	}
}


State SequenceTriggered{

Begin:
	for(i=0;i<SequenceActors.Length;++i){

		if(SequenceActors[i].WaitTime > 0.0){
			sleep(SequenceActors[i].WaitTime);
		}

		SequenceActors[i].TargetActor.Trigger(lastTouchActor, Pawn(lastTouchActor));
		//Log('Destroying');
		//Log(SequenceActors[i].TargetActor);
	}

	GotoState('');
}


// Decompiled with UE Explorer.
defaultproperties
{
    bTriggerOnlyOnce=true
    bInitiallyActive=true
}