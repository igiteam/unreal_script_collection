/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_TroikaGunner extends AICmd_Base_UseTurret
	within TGAI_Cover;

var AIReactCond_GenericCallDelegate TurretClamped;
var HodAI hod;
var bool TurretUsed;

function Pushed()
{
	hod = MyTGPawn.hod;
	TurretUsed = false;
	if( EnsureWereOnATurret() )
	{
		// Don't let people go DBNO off a turret
		MyTGPawn.bCanDBNO = FALSE;

		Super.Pushed();
	}

	// ensure this isn't suppressed from an earlier subscription
	ReactionManager.UnSuppressChannel('TurretRotationClamped');
	TurretClamped = new(outer) class'AIReactCond_GenericCallDelegate';
	TurretClamped.AutosubscribeChannels.AddItem('TurretRotationClamped');
	TurretClamped.OutputFunction = NotifyTurretRotationClamped;
	TurretClamped.Initialize();
}

function Popped()
{
	TurretClamped.UnsubscribeAll();
	TurretClamped=none;
	LeaveTurret();
	Super.Popped();
	//RegisterReGunReaction();
}

// registers a reaction which will check periodically to see if it's ok to come back to this troika
//function RegisterReGunReaction()
//{
//	local AIReactCond_CanReturnToTroika ReturnReact;
//	ReturnReact = new(outer) class'AIReactCond_CanReturnToTroika';
//	ReturnReact.Initialize();
//}

function NotifyTurretRotationClamped(Actor Inst, AIreactChannel OrigChan)
{
	;
	if(!bIgnoreFlank && Enemy != none)
	{
		if(!CanTurretFireAt(Enemy))
		{
			;
			// try to find a new enemy within our rotation clamps
			SelectTarget();

			// if we still can't fire at the new enemy, leave the turret
			if(!CanTurretFireAt(Enemy))
			{
				;
				bReachedTurret=false;
				AbortCommand(self);
			}
			else
			{
				;
			}
		}
		else
		{
			;
		}

	}

}

function bool EnsureWereOnATurret()
{
	// try and go to our last turret
	if( !bReachedTurret && !HasValidTurret() )
	{
		//debug
		;

		if( LastTurret != none && !LastTurret.ClaimTurret(GameAIOwner) )
		{
			//debug
			;

			GotoState('DelayFailure');
			return FALSE;
		}
		else
		{
			;
		}

	}
	return TRUE;
}

function LeaveTurret()
{
	local int OldHealth;
	local pawn Driver;
	;
	if( CurrentTurret != none )
	{
		LastTurret = CurrentTurret;
		LastTurret.UnclaimTurret( CoverOwner );

		Driver = LastTurret.Driver;
		OldHealth = Driver.Health;

		if(Driver.Health <= 0)
		{
			Driver.Health=1;
		}
		LastTurret.DriverLeave( true );
		Driver.Health=OldHealth;
		BeginCombatCommand( none/*class'AICmd_Base_CoverAI'*/, "return to CoverAI!", true );
	}

	// restore the fire tickets flag
	bUseFireTickets = default.bUseFireTickets;
	ClearTimer( 'SelectTarget' );

}

state InCombat
{
	function BeginState( Name PrevStateName )
	{
		Super.BeginState( PrevStateName );

		bUseFireTickets = FALSE;
		SetTimer( 1.f, TRUE, nameof(SelectTarget) );
	}

	function EndState( Name NextStateName )
	{
		super.EndState( NextStateName );
		LeaveTurret();
	}

	function Tick( float DeltaTime )
	{
		if( HasValidTurret() )
		{
			// have turret define how we should track enemies
			CurrentTurret.UpdateAIController( CoverOwner, DeltaTime );
		}

		super.Tick( DeltaTime );
	}

	/**
	 * Figure out current aim error and return fire rotation.
	 */
	function Rotator GetAdjustedAimFor(Weapon W, vector StartFireLoc)
	{
		local Rotator	POVRot;
		local Vector	POVLoc;

		GetPlayerViewPoint( POVLoc, POVRot );

		// base aim error
		POVRot.Pitch += RandRange(-256,128);
		POVRot.Yaw	 += RandRange(-512,512);

		return POVRot;
	}

	// check to see if the target is outside our rotation clamps
	function AdjustEnemyRating(out float out_Rating, Pawn EnemyPawn)
	{
		local float EnemyDist;

//		if (ChildCommand != None)
//		{
//			ChildCommand.AdjustEnemyRating(out_Rating, EnemyPawn);
//			return;
//		}

		if (AICommand(ChildCommand) != None)
		{
			AICommand(ChildCommand).AdjustEnemyRating(out_Rating, EnemyPawn);
			return;
		}

		if( bReachedTurret )
		{
			// scale enemy rating if they're really close
			EnemyDist = VSize(GetEnemyLocation(EnemyPawn) - CurrentTurret.Location);
			if (EnemyDist < 512.f)
			{
				out_Rating *= 1.f + (1.f - (EnemyDist/512.f));
			}
			// check to see if we could shoot them
			if (CanTurretFireAt(EnemyPawn))
			{
				out_Rating *= 1.5f;
			}
			else
			{
				out_Rating *= 0.5f;
			}
		}

		Super.AdjustEnemyRating( out_Rating, EnemyPawn );
	}

	function vector GetEntryLocation()
	{
		local vector	EntryLoc;
		local vector	Extent;
		local TraceHitInfo HitInfo;
		local vector HitLocation;
		local vector HitNormal;

		Extent.x = Pawn.CylinderComponent.CollisionRadius;
		Extent.y = Pawn.CylinderComponent.CollisionRadius;
		Extent.z = 0;

		// Get location of player reference socket.
		EntryLoc = CurrentTurret.GetEntryLocation();
		if (Trace(HitLocation, HitNormal, EntryLoc - vect(0, 0, 150), EntryLoc, false, Extent, HitInfo, TRACEFLAG_Blocking) != none)
		{
			EntryLoc.z = HitLocation.z + Pawn.CylinderComponent.CollisionHeight;
		}
		return EntryLoc;
	}

Begin:
	//debug
	;

	if( HasValidTurret() )
	{
		while( HasValidTurret() )
		{
			// make sure we're at the turret
			if( !IsAtTurret() )
			{
				//debug
				;

				SetMovePoint(GetEntryLocation());
				if( Pawn.ReachedPoint(GetEntryLocation(), none))
				{
					bReachedTurret = TRUE;
				}
				//Pawn.SetLocation(CurrentTurret.GetEntryLocation());
				//Pawn.SetRotation(CurrentTurret.Rotation);

				if( !CurrentTurret.TryToDrive(Pawn) )
				{
					//debug
					;

					//@hack!!!
//					Pawn.SetLocation(GetEntryLocation());
//					CurrentTurret.TryToDrive(Pawn);
//					bReachedTurret = TRUE;
					//claim turret failed! goto the free combat
					CurrentTurret = none;
					BeginCombatCommand( none/*class'AICmd_Base_CoverAI'*/, "return to CoverAI!", true );
					bReachedTurret = false;
					Sleep(1.f);
				}
				else
				{
					bReachedTurret = TRUE;
					//CurrentTurret.Driver.SetRotation(CurrentTurret.Rotation);
				}
			}
			else
			{
				if (!TurretUsed)
				{
					CurrentTurret.Driver.SetRotation(CurrentTurret.Rotation);
					TurretUsed = TRUE;
				}
				// found an enemy to fire at
				if( SelectTarget() &&
					CanTurretFireAt( FireTarget ) )
				{
					// attempt to set enemy to the firetarget
					// this is needed to correctly aim at the pawn bone locations, if firing at a player
					SetEnemy(Pawn(FireTarget));

					//debug
					;

					// Aim at them and shoot
					StartFiring();
					do
					{
						Sleep(2.f);
						CheckInterruptCombatTransitions();
						;
					}
					until(!IsFiringWeapon() || !HasValidTarget() || !CanTurretFireAt( FireTarget ));
					;
					StopFiring();
					Focus = None;
				}
				else
				{
					//debug
					;

					Sleep( 1.0f );
					CurrentTurret.AIIdleNotification( CoverOwner );
				}
			}

			// added to avoid infinite recursion
			Sleep( 0.1f );
		}
	}
	else
	{
		//debug
		;

		Sleep( 1.f );
	}

	// Check combat transitions
	//CheckCombatTransition();
}
