/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_EngageThreat_Trooper_WithFireBuddy extends NanoAIAction_EngageThreat_Trooper within NanoAI_Trooper;


static function int InternalGetUtility( NanoAIBase InAI )
{
	return 0;
}



state Combat_WithFireBuddy
{
	function ProvideCover(NanoAI_Trooper TestBuddy)
	{
		Outer.ProvideCover(TestBuddy);
		GotoState('Combat_ProvidingCover');
	}

	function bool CanProvideCover(NanoAI_Trooper TestBuddy)
	{
		return CommandList == None;
	}

	function MoveToNewPosition()
	{
		`AILog(`location);
		if (PickDefensePoint(FireTarget))
		{
			`AILog(`showvar(CurrentDefensePoint));
			if (!IsCloseEnoughToDefensePoint())
			{
				MoveToActor(GetClosestDefensePoint(FireTarget));
			}
		}
		else
		{
			class'NanoAICmd_Move_UntilInRange'.static.MoveToVisibleActor(Outer,FireTarget,FALSE,1.5f);
		}
	}

	function bool IsPointWithinRange(Vector Pt)
	{
		local float DistScale;
		DistScale = MyTrooper.bHasShield ? 2.f : 1.2f;
		`AIlog(`location@`showvar(VSize2D(Pt - Pawn.Location)));
		return VSize2D(Pt - Pawn.Location) < class'BoidRule_TrooperRanged'.default.MinDistanceToStandFromFoe * DistScale;
	}

	function BeginState(Name PrevStateName)
	{
		SetActiveBoidMovementByClass( class'BoidRule_TrooperRanged', TRUE );
	}

	function EndState(Name NextStateName)
	{
		SetActiveBoidMovementByClass( class'BoidRule_TrooperRanged', FALSE );
	}

Begin:
	`AILog("begin");
	MyTrooper.SpawnNanoBaton();
	if (!FindFireBuddy())
	{
		`AILog("no buddy");
		GotoState('Combat');
	}
	PossiblyPickFireTarget();
	// if close enough just jump in swinging
	if (!MyTrooper.bHasShield && (FireTarget != none) && IsPointWithinRange(FireTarget.GetTargetedLocation()))
	{
		EngageMeleeWith(NanoPawn(FireTarget));
	}
	// otherwise see if we can move with our buddy firing
	else if ( (FireTarget != none) && !IsPointWithinRange(FireTarget.GetTargetedLocation()) && FireBuddy.CanProvideCover(Outer))
	{
		`AILog("buddy covering, moving up");
		FireBuddy.ProvideCover(Outer);
		MoveToNewPosition();
		Sleep(0.25f);
	}
	// otherwise shoooooot
	ProvideCover(FireBuddy);
	Goto('Begin');
}




defaultproperties
{
	StartingStateName="Combat_WithFireBuddy"
}