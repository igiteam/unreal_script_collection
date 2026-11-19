/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Base_BlimpTurret extends AICmd_Base_UseTurret
	within GearAI_BlimpTurret;

var AIReactCond_GenericCallDelegate TurretClamped;

/** how long we have been doing nothing because we couldn't find a target (reset when a target is found) */
var int IdleTime;

/** Variable for saving off current entry location for the turret */
var transient vector EntryLocation;

function Pushed()
{
	Super.Pushed();

	// ensure this isn't suppressed from an earlier subscription
	ReactionManager.UnSuppressChannel('TurretRotationClamped');
	TurretClamped = new(Outer) class'AIReactCond_GenericCallDelegate';
	TurretClamped.AutosubscribeChannels.AddItem('TurretRotationClamped');
	TurretClamped.OutputFunction = NotifyTurretRotationClamped;
	TurretClamped.Initialize();
}

function Popped()
{
	Super.Popped();
	TurretClamped.UnsubscribeAll();
	TurretClamped = None;
}

function NotifyTurretRotationClamped(Actor Inst, AIreactChannel OrigChan)
{
	`AILog(GetFuncName()@self@Outer@Enemy@bIgnoreFlank);
	if (!bIgnoreFlank && Enemy != None)
	{
		if (!CanTurretFireAt(Enemy))
		{
			`AILog(GetFuncName()@self@outer@"Can't fire turret at target:"@Enemy@"looking for new target I can fire at....");
			// try to find a new enemy within our rotation clamps
			SelectTarget();

			// if we still can't fire at the new enemy, leave the turret
			if(!CanTurretFireAt(Enemy))
			{
				`AILog(GetFuncName()@self@outer@"Found no new target to shoot at.. leaving turret");
				AbortCommand(self);
			}
			else
			{
				`AILog(GetFuncName()@self@outer@"Found a new target!");
			}
		}
		else
		{
			`AILog(GetFuncName()@self@outer@"Can fire at target? what?");
		}

	}
}

function bool HasValidTurret()
{
	return MyTurret != None;
}

state InCombat
{
	function BeginState(name PrevStateName)
	{
		// Reduce response time when on Troika
		Response_MinEnemySeenTime *= 0.5f;
		Response_MinEnemyHearTime *= 0.5f;

		bUseFireTickets = false;
	}

	function Tick(float DeltaTime)
	{
		if( HasValidTurret() )
		{
			// have turret define how we should track enemies
			MyTurret.UpdateAIController( Outer, DeltaTime );
		}

		Super.Tick(DeltaTime);
	}

	// check to see if the target is outside our rotation clamps
	function AdjustEnemyRating(out float out_Rating, Pawn EnemyPawn)
	{
		// check to see if we could shoot them
		if( CanTurretFireAt( EnemyPawn ) )
		{
			out_Rating *= 1.5f;
		}
		else
		{
			out_Rating *= 0.5f;
		}

		Super.AdjustEnemyRating(out_Rating, EnemyPawn);
	}

	function vector GetEntryLocation()
	{
		local vector EntryLoc;
		local array<vector> Positions;

		EntryLoc = MyTurret.GetEntryLocation();

		if( !class'NavigationHandle'.static.ObstaclePointCheck(EntryLoc, vect(32,32,72) ) )
		{
			class'NavigationHandle'.static.GetValidPositionsForBox(EntryLoc,256,vect(32,32,72),FALSE,Positions,1);

			if( Positions.length > 0 )
			{
				return Positions[0];
			}
		}

		return EntryLoc;
	}

Begin:
	//debug
	`AILog( "BEGIN TAG"@HasValidTurret()@IsAtTurret(), 'State' );

	if( HasValidTurret() )
	{
		while( HasValidTurret() )
		{
			// found an enemy to fire at
			if( SelectTarget() &&
				CanTurretFireAt( FireTarget ) )
			{
				IdleTime = 0;

				// attempt to set enemy to the firetarget
				// this is needed to correctly aim at the pawn bone locations, if firing at a player
				SetEnemy(Pawn(FireTarget));

				//debug
				`AILog( "Aiming at an enemy...?"@Enemy@FireTarget@LineOfSightTo(FireTarget), 'Turret' );

				// Aim at them and shoot
				StartFiring();
				do
				{
					Sleep(2.f);
					CheckInterruptCombatTransitions();
					`AILog("can still fire at?"@FireTarget@CanTurretFireAt(FireTarget));
				}
				until(!IsFiringWeapon() || !HasValidTarget() || !CanTurretFireAt( FireTarget ));

				`AILog("No longer firing at target, valid target?"@HasValidTarget());

				StopFiring();
				Focus = None;
			}
			else
			{
				//debug
				`AILog( "Idle look..."@FireTarget@Enemy@SelectTarget()@CanTurretFireAt( FireTarget ), 'Turret' );

				Sleep(1.0);
				IdleTime += 1;
			}

			// added to avoid infinite recursion
			Sleep( 0.1f );
		}
	}
	else
	{
		//debug
		`AILog( "Error: No turret, can't gun!" );

		Sleep(1.0);
		Status = 'Failure';
		PopCommand(self);
	}

	// Check combat transitions
	CheckCombatTransition();

	Goto('Begin');
}
