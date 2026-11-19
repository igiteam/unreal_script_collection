//============================================================================//
// ZombieTriggerVolume                                                     //
//                                                                            //
// This trigger volume will be used to control the spawning of the bots in    //
// the levels so that not every bot needs to be active in the world           //
// simultaneously.                                                            //
//============================================================================//
class ZombieTriggerVolume 
	  extends Volume;

// Only trigger once and then go dormant.
var(Trigger) bool bTriggerOnceOnly;

// Trigger type.
var(Trigger) enum ETriggerType
{
	TT_PlayerProximity,	 // Trigger is activated by player proximity.
	TT_AnyProximity,    	 // Trigger is activated by any actor in proximity.
	TT_HumanPlayerProximity, // Trigger activated by human player (not bot)
	TT_ClassProximity,		// Trigger activated by specific class type
	TT_Shoot,				// Trigger activated by player shooting it
} TriggerType;

var(Trigger) class<actor> ClassProximityType;

// Human readable triggering message.
var(Trigger) localized string Message;

var(Trigger) float ReTriggerDelay; //minimum time before trigger can be triggered again
var	  float TriggerTime;
var(Trigger) float DamageThreshold; //minimum damage to trigger if TT_Shoot

// store for reset

var bool bSavedInitialCollision;
var bool bSavedInitialActive;

event PostBeginPlay()
{
	if ( TriggerType == TT_Shoot )
	{
		bHidden = false;
		bProjTarget = true;
		SetDrawType(DT_None);
	}
	bSavedInitialActive = !bDisabled;
	bSavedInitialCollision = bCollideActors;
	TriggerTime = -1.0;  // Trigger has never been triggered
	Super.PostBeginPlay();
}

/* Reset() 
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	Super.Reset();

	// collision, bInitiallyactive
	bDisabled = !bSavedInitialActive;
	SetCollision(bSavedInitialCollision, bBlockActors, bBlockPlayers );
}

//
// See whether the other actor is relevant to this trigger.
//
function bool IsRelevant( actor Other )
{
	switch( TriggerType )
	{
		case TT_HumanPlayerProximity:
			return (Pawn(Other) != None) && Pawn(Other).IsHumanControlled();
		case TT_PlayerProximity:
			return (Pawn(Other) != None) && (Pawn(Other).IsPlayerPawn() || Pawn(Other).WasPlayerPawn());
		case TT_AnyProximity:
			return true;
		case TT_ClassProximity:
			return ClassIsChildOf(Other.Class, ClassProximityType);
		case TT_Shoot:
			return ( (Projectile(Other) != None) && (Projectile(Other).Damage >= DamageThreshold) );
	}
}

//
// Called when something touches the trigger.
//
function Touch( actor Other )
{
	if( IsRelevant( Other ) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay && TriggerTime != -1.0 )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		TriggerEvent(Event, self, Other.Instigator);
				
		if( (Message != "") && (Other.Instigator != None) )
			// Send a string message to the toucher.
			Other.Instigator.ClientMessage( Message );

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
	}
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, class<DamageType> damageType, optional Controller KillerController )
{
	if ( !bDisabled && (TriggerType == TT_Shoot) && (Damage >= DamageThreshold) && (instigatedBy != None) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay && TriggerTime != -1.0 )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		TriggerEvent(Event, self, instigatedBy);

		if( Message != "" )
			// Send a string message to the toucher.
			instigatedBy.Instigator.ClientMessage( Message );

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
	}
}

event UnTouch( Actor Other )
{
	if( IsRelevant( Other ) )
	{
		// Broadcast the UnTrigger message to all matching actors.
		UnTriggerEvent(Event, self, Pawn(Other));
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    TriggerType=2
}