/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_EngageThreat_Trooper extends NanoAIAction_EngageThreatBase within NanoAI_Trooper
	abstract;


state Combat
{
	function BeginState(Name PrevStateName)
	{
		Super.BeginState(PrevStateName);
		SetMood(AIMood_Aggressive);
	}

	function bool NotifyActiveAttackAvailable(NanoPawnBase AvailableTarget)
	{
		`AILog(GetFuncName()@`showvar(AvailableTarget)@`showvar(FireTarget)@bWaitingForActiveAttack@CanActivelyAttackTarget());
		if (AvailableTarget == FireTarget)
		{
			if( bWaitingForActiveAttack && CanActivelyAttackTarget() )
			{
				bWaitingForActiveAttack = FALSE;
				StartFiring();
				return TRUE;
			}
		}
		else
		{
			`AILog("Available to attack something other than fire target, shouldn't happen");
			AvailableTarget.UnregisterAttacker(self);
		}

		return FALSE;
	}


	function PickNewAction()
	{
		PossiblyPickFireTarget();

		`AILog( GetFuncName()@FireTarget );

// 		if( FireTarget != None )
// 		{
// 			if (VSize(FireTarget.GetTargetedLocation() - Pawn.Location) > 512.f)
// 			{
// 				GotoState(GetStateName(),'MoveToFireTarget');
// 			}
// 			else
// 			{
// 				GotoState('Combat_MeleeAttack');
// 			}
// 		}
/*
		FindFireBuddy();
        if (FireBuddy != None)
        {
            GotoState('Combat_WithFireBuddy');
        }
		else if (FireTarget != None)
		{
			NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_StopPlayer,Pawn);
			GotoState('Combat_RangedAttack');
		}
        else
        {
            // dunno waht to doOooOOo
        }
*/
	}


}





defaultproperties
{
	StartingStateName="Combat"
}