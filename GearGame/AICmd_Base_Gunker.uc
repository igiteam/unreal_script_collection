/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_Gunker extends AICommand_Base_Combat
	within GearAI_Gunker;


/** Time since last gunk lob */
var transient float LastGunkLobTime;
/** Amount of time to wait before throwing another gunk lob */
var const float GunkLobWaitTime;

/** Reference to the call delegate reaction */
var AIReactCond_GenericCallDelegate EnemyMoveToDelegate;

/** Cached reference to the pawn */
var GearPawn_LocustGunkerBase GunkerPawnRef;


/** Overloaded for sound hookup */
function Pushed()
{
	GunkerPawnRef = GearPawn_LocustGunkerBase(Pawn);
	if (GunkerPawnRef != None)
	{
		GunkerPawnRef.EnterAmbientMode();
		GunkerPawnRef.SpeakLine(None, GunkerPawnRef.VoiceAlertOfEnemy, "", 0.f, Speech_Immediate);

		// Need to scale the attack logic values with the gunker's scale
		EnemyDistance_Melee = default.EnemyDistance_Melee * GunkerPawnRef.GunkerScale;
		EnemyDistance_Short = default.EnemyDistance_Short * GunkerPawnRef.GunkerScale;
		EnemyDistance_Medium = default.EnemyDistance_Medium * GunkerPawnRef.GunkerScale;
		EnemyDistance_Long = default.EnemyDistance_Long * GunkerPawnRef.GunkerScale;
		EnemyDistance_MinLobAttack = default.EnemyDistance_MinLobAttack * GunkerPawnRef.GunkerScale;
		ChopRangeDelta = default.ChopRangeDelta * GunkerPawnRef.GunkerScale;
		ShootRangeDelta = default.ShootRangeDelta * GunkerPawnRef.GunkerScale;
	}
}

function Popped()
{
	if (EnemyMoveToDelegate != None)
	{
		EnemyMoveToDelegate.UnsubscribeAll();
	}

	if (GunkerPawnRef != None)
	{
		GunkerPawnRef.ExitAmbientMode();
	}

	Super.Popped();
}

function Resumed(Name OldCommandName)
{
	if (EnemyMoveToDelegate != None)
	{
		EnemyMoveToDelegate.UnsubscribeAll();
	}

	Super.Resumed(OldCommandName);
}

auto state InCombat
{
	/** Determine if we are within range to do the chopping melee attack */
	function bool IsChoppingRange(vector TestLocation)
	{
		local float Dist;
		local GearPawn_LocustGunkerBase GunkerPawn;

		GunkerPawn = GearPawn_LocustGunkerBase(Pawn);
		if (GunkerPawn != None)
		{
			Dist = VSize(TestLocation - GunkerPawn.GetBodyCenterLocation());
		}

		return Dist <= EnemyDistance_Short + ChopRangeDelta &&
			   Dist >= EnemyDistance_Short - ChopRangeDelta;
	}

	/** Determine if we are within range to do the lob gunk attack */
	function bool IsLobbingRange(vector TestLocation)
	{
		local float Dist;

		Dist = VSize(TestLocation - Pawn.Location);
		return Dist <= EnemyDistance_Long &&
			   Dist >= EnemyDistance_MinLobAttack;
	}

	/** Determine if we are within range to do the short range gunk attack */
	function bool IsShootingRange(vector TestLocation)
	{
		local float Dist;

		Dist = VSize(TestLocation - Pawn.Location);
		return Dist <= EnemyDistance_Medium &&
			   Dist >= EnemyDistance_MinLobAttack;
	}

	/** Whether the Gunker can perform the lob attack or not */
	function bool CanLobAttack( Actor TargetToAttack, bool bUseTimePause)
	{
		local GearPawn_LocustGunkerBase GunkerPawn;
		local Actor HoldTarget;

		GunkerPawn = GearPawn_LocustGunkerBase(Pawn);
		if (GunkerPawn != None)
		{
			// Set the Target temporarily for the caluculatedlobvel test
			HoldTarget = GunkerPawn.GunkTarget;
			GunkerPawn.GunkTarget = TargetToAttack;
			if ((!bUseTimePause || (LastGunkLobTime == -1 || WorldInfo.TimeSeconds > LastGunkLobTime+GunkLobWaitTime)) &&
				IsLobbingRange(TargetToAttack.Location) &&
				MoveIsInterruptable() &&
				Pawn != None &&
				GunkerPawn.CalculateLobVelocity())
			{
				GunkerPawn.GunkTarget = HoldTarget;
				return TRUE;
			}
			GunkerPawn.GunkTarget = HoldTarget;
		}
		return FALSE;
	}

	/** Whether the Gunker can perform the short range gunk attack or not */
	function bool CanShootAttack(Actor TargetToAttack, bool bIgnoreRange, bool bIgnoreTrace)
	{
		local vector StartTraceLoc;
		local vector EndTraceLoc;
		local GearPawn_LocustGunkerBase GunkerPawn;
		local float BoundsRadius, BoundsHeight;

		if (bIgnoreRange ||
			IsShootingRange(TargetToAttack.Location))
		{
			if (bIgnoreTrace)
			{
				return TRUE;
			}
			else
			{
				TargetToAttack.GetBoundingCylinder( BoundsRadius, BoundsHeight );

				GunkerPawn = GearPawn_LocustGunkerBase(Pawn);
				if (GunkerPawn != None)
				{
					StartTraceLoc = GunkerPawn.Location;
					StartTraceLoc.Z = StartTraceLoc.Z - Pawn.GetCollisionHeight() + 60.0f;
					EndTraceLoc = TargetToAttack.Location;
					EndTraceLoc.Z = EndTraceLoc.Z - BoundsHeight + 60.0f;
					if (FastTrace(EndTraceLoc, StartTraceLoc))
					{
						return TRUE;
					}
				}
			}
		}
		return FALSE;
	}

	/** Whether the Gunker can perform the melee chop attack or not */
	function bool CanChopAttack(Actor TargetToAttack)
	{
		local vector StartTraceLoc;
		local vector EndTraceLoc;
		local GearPawn_LocustGunkerBase GunkerPawn;
		local float BoundsRadius, BoundsHeight;

		GunkerPawn = GearPawn_LocustGunkerBase(Pawn);

		if (GunkerPawn != None &&
			IsChoppingRange(TargetToAttack.Location) &&
			CanEngageMelee())
		{
			TargetToAttack.GetBoundingCylinder( BoundsRadius, BoundsHeight );

			StartTraceLoc = GunkerPawn.GetBodyCenterLocation();
			StartTraceLoc.Z = StartTraceLoc.Z - Pawn.GetCollisionHeight() + 120.0f;
			EndTraceLoc = TargetToAttack.Location;
			EndTraceLoc.Z = EndTraceLoc.Z - BoundsHeight + 120.0f;
			if (FastTrace(EndTraceLoc, StartTraceLoc))
			{
				return TRUE;
			}
		}
		return FALSE;
	}

	/** @return TRUE to indicate that we can do the close melee attack */
	function bool CanCloseMeleeAttack()
	{
		return TRUE;
	}

	/** Shoot the enemy we just knocked away from us with a melee swipe */
	function DoShootAttackAt(Actor TargetToAttack, bool bIgnoreRange, bool bIgnoreTrace)
	{
		local GearPawn EnemyGP;

		if (TargetToAttack != None &&
			CanShootAttack(TargetToAttack, bIgnoreRange, bIgnoreTrace))
		{
			EnemyGP = GearPawn(TargetToAttack);
			if( EnemyGP == None || EnemyGP.IsAliveAndWell() )
			{
				// Attempt a gunk throw at the other enemy
				class'AICmd_Attack_Gunker_Shoot'.static.InitShootCommand(Outer, TargetToAttack);
			}
		}
	}

	/** Determine if it's facing target **/
	function bool IsFacing(vector TestLocation)
	{
		local GearPawn_LocustGunkerBase GunkerPawn;
		local vector ToTestVect;

		GunkerPawn = GearPawn_LocustGunkerBase(Pawn);
		if (GunkerPawn != None)
		{
			ToTestVect = TestLocation - GunkerPawn.GetBodyCenterLocation();

			//  make sure it's facing same direction
			return (ToTestVect Dot vector(GunkerPawn.Rotation) > 0);
		}
	}

	/** Determine if Turning is done - even rotation is done, turning still be happening **/
	function bool IsTurningDone()
	{
		local GearPawn_LocustGunkerBase GunkerPawn;

		GunkerPawn = GearPawn_LocustGunkerBase(Pawn);

		return !GunkerPawn.IsTurningDone();
	}

	/** */
	function SetEnemyMoveGoalWithTimeout(float Timeout)
	{
		EnemyMoveToDelegate = new(Outer) class'AIReactCond_GenericCallDelegate';
		EnemyMoveToDelegate.AutoSubscribeChannels[1]='Timer';
		EnemyMoveToDelegate.TimerInterval=Timeout;
		EnemyMoveToDelegate.OutputFunction=EnemyMoveGoalTimeoutCallback;
		EnemyMoveToDelegate.Initialize();
		SetEnemyMoveGoal();
	}

	/** */
	function EnemyMoveGoalTimeoutCallback(Actor EventInstigator, AIReactChannel OrigChannel)
	{
		EnemyMoveToDelegate.UnsubscribeAll();
		AbortCommand(None, class'AICmd_MoveToEnemy');
	}

	/**
	 * Used by AICmd_Base_Gunker_CloseQuarters only
	 * @param TargetToAttack - the enemy being chopped
	 */
	function NotifyChopAttack(Actor TargetToAttack);

	function NotifyLobAttack(Actor TargetToAttack);

Begin:
	// If we couldn't select an target go to the failure state
	if( !SelectTarget() )
	{
		//debug
		`AILog("Failed to select a target -- delay failure");
		GotoState('DelayFailure');
	}

	// make sure stale value doesn't cause AI to think it reached target when it didn't
	Pawn.DestinationOffset = 0.0;

	//debug
	`AILog( "BEGIN TAG"@`showvar(FireTarget)@`showvar(Enemy)@IsMeleeRange(FireTarget.Location)@Pawn.ReachedDestination(FireTarget)@CanEngageMelee()@VSize(FireTarget.Location-Pawn.Location) );


	// If it's not facing target
	while ( IsFacing(FireTarget.Location) == FALSE )
	{
		// Set desired rotation and have him rotate
		SetFocalPoint(FireTarget.Location);
		SetDesiredRotation(Rotator(FireTarget.Location - Pawn.Location));
		// rotation is done
		FinishRotation();
		
		// Now wait until turning is done
		while (!IsTurningDone())
		{
			Sleep(0.1f);
		}
	}

	// If close enough to melee target
	if( IsMeleeRange(FireTarget.Location) && CanCloseMeleeAttack() )
	{
		// Attempt a close melee attack
		if (CanEngageMelee())
		{
			class'AICmd_Attack_Gunker_MeleeClose'.static.InitCommand(Outer);
		}
		else
		{
			Sleep(0.1f);
		}
	}
	// If not close enough to melee the target but is close enough to do the chop attack
	else if( Pawn(FireTarget) != None && CanChopAttack(FireTarget))
	{
		NotifyChopAttack(FireTarget);
		class'AICmd_Attack_Gunker_MeleeFar'.static.InitCommand(Outer);
	}
	// If not close enough to use either melee attack but is close enough to lob some gunk
	else if (CanLobAttack(FireTarget, TRUE))
	{
		// Attempt a gunk throw
		NotifyLobAttack(FireTarget);
		class'AICmd_Attack_Gunker_Lob'.static.InitLobCommand(Outer, FireTarget);
		// Mark that the lob happened
		LastGunkLobTime = WorldInfo.TimeSeconds;
	}
	// See if we will be able to lob attack after timer expires, if NOT we will move toward the target
	else if( !CanLobAttack(FireTarget, FALSE) )
	{
		if( !GunkerPawnRef.bForceStationary && Enemy != None )
		{
			GunkerPawnRef.ExitAmbientMode();
			SetEnemyMoveGoalWithTimeout(4.0f);
			Sleep(1.f + FRand());
			GunkerPawnRef.EnterAmbientMode();
		}
	}

	Sleep(0.1f);

	Goto('Begin');
}


defaultproperties
{
	LastGunkLobTime=-1
	GunkLobWaitTime=3.0f
}