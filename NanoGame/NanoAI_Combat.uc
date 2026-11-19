/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAI_Combat extends NanoAI
	native(AI);

var transient Name LastErrorCode;



function PostAIFactorySpawned(SeqAct_AIFactory SpawningFactory, INT SpawnSetIdx)
{
	local NanoPawnBase NP;
	if (SpawningFactory.SpawnSets[SpawnSetIdx].bAutoAcquireEnemy)
	{
		SetMood(AIMood_Aggressive);
		foreach WorldInfo.AllPawns(class'NanoPawnBase',NP)
		{
			if (!IsFriendlyActor(NP))
			{
				AddStimulus(NP,NP.Location,FALSE,FALSE,TRUE,FALSE);
				SetFireTarget(NP);
			}
		}
		if (FireTarget != None)
		{
			ScriptedTransitionToCombat();
		}
	}

}




function bool HasValidFireTarget()
{
	return (FireTarget != None);
}


function bool CanActivelyAttackTarget( optional out Name ErrorCode )
{
	ErrorCode = '';
	if( FireTarget == None )
	{
		ErrorCode = 'AttackFail_FireTargetIsNone';
		return FALSE;
	}
	
	if( !LineOfSightTo(FireTarget) )
	{
		ErrorCode = 'AttackFail_NoLOS';
		return FALSE;
	}

	if( !AllowedToActivelyAttackTarget() )
	{
		ErrorCode = 'AttackFail_NotAllowedByTarget';
		return FALSE;
	}

	return TRUE;
}



function RegisterAsActiveAttacker()
{
	if( NanoPawnBase(FireTarget) != None )
	{
		NanoPawnBase(FireTarget).RegisterActiveAttacker(self);
	}
}
function UnregisterAsActiveAttacker()
{
	if( NanoPawnBase(FireTarget) != None )
	{
		NanoPawnBase(FireTarget).UnregisterActiveAttacker(self);
	}
}

function bool AllowedToActivelyAttackTarget()
{
	if( NanoPawnBase(FireTarget) != None && !NanoPawnBase(FireTarget).AllowedToActivelyAttackTarget(self) )
	{
		return FALSE;
	}
	return TRUE;
}

event Tick( float DeltaTime )
{
	local NanoPawn NP;

	Super.Tick(DeltaTime);

	NP = NanoPawn(Pawn);
	if (NP != None)
	{
		if( ShouldTrackFireTarget() )
		{
			if( !NP.IsHeadTrackingEnabled() )
			{
				EnableHeadTracking();
			}
		}
		else if( NP.IsHeadTrackingEnabled() )
		{
			// we want to keep headtracking on all the time
			//DisableHeadTracking();
		}
	}
};

function bool ShouldTrackFireTarget()
{
	if( (FireTarget != None) && ((Normal(FireTarget.GetTargetedLocation() - Pawn.Location) dot vector(Pawn.Rotation)) >= 0.7071f) )
	{
		return TRUE;
	}

	return FALSE;
}



defaultproperties
{


}