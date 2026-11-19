class TriggerRandomSound extends Trigger placeable;

enum ESoundType {
  STYPE_IN_HEAD,
  STYPE_3D
};

var(TriggerRandomSound)	float SoundGeneratingInterval;

// random value between min and max is generated and added to the 
// SoundGeneratingInterval to produce next sound generation time
var(TriggerRandomSound)	float RandomMinInterval, RandomMaxInterval; 

var(TriggerRandomSound)	float Radius; 
var(TriggerRandomSound) bool Repeating;
var(TriggerRandomSound) sound RandomSound; 
var(TriggerRandomSound) ESoundType SoundSlot;

function Touch( actor Other )
{
	local int i;

	if( IsRelevant( Other ) )
	{
		// if > 0, delay until trigger can be used again
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay && TriggerTime != -1.0)
				return;
			TriggerTime = Level.TimeSeconds;
		}
		
		// Broadcast the Trigger message to all matching actors.
		TriggerEvent(Event, self, Other.Instigator);

		if ( (Pawn(Other) != None) && (Pawn(Other).Controller != None) )
		{
			for ( i=0;i<4;i++ )
				if ( Pawn(Other).Controller.GoalList[i] == self )
				{
					Pawn(Other).Controller.GoalList[i] = None;
					break;
				}
		}	
				
		if( (Message != "") && (Other.Instigator != None) )
			// Send a string message to the toucher.
			Other.Instigator.ClientMessage( Message );

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
		
		if ( RepeatTriggerTime > 0 )
		{
			SetTimer(RepeatTriggerTime, Repeating);
		}
		else
		{		
			// Play sound instantly
			SetTimer(0.01, Repeating);
		}
	}
}

function UnTouch( actor Other )
{
	SetTimer(0.0, false);
}

function Timer()
{
	if (RandomSound != None)
	{
		if( SoundSlot == STYPE_IN_HEAD )
			PlaySound(RandomSound,SLOT_Interface, 1,,Radius, 1.0,true);
		else
			PlaySound(RandomSound,SLOT_Misc, 1,,Radius, 1.0,true);
	}		

	
	if(Repeating)
	{
		SetTimer(SoundGeneratingInterval+Rand(RandomMaxInterval-RandomMinInterval)+RepeatTriggerTime, Repeating);
	}
}



// Decompiled with UE Explorer.
defaultproperties
{
    SoundGeneratingInterval=5.0000000
    RandomMinInterval=1.0000000
    RandomMaxInterval=2.0000000
    Radius=500.0000000
    Texture=Texture'Engine.S_MaterialTrigger'
}