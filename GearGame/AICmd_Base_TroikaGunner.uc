/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_TroikaGunner extends AICmd_Base_UseTurret
	within GearAI_Cover;

var AIReactCond_GenericCallDelegate TurretClamped;

/** how long we have been doing nothing because we couldn't find a target (reset when a target is found) */
var int IdleTime;

/** Variable for saving off current entry location for the turret */
var transient vector EntryLocation;

function Pushed()
{
	if( EnsureWereOnATurret() )
	{
		Super.Pushed();
	}

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
	LeaveTurret(true);
}

function Paused(GameAICommand NewCommand)
{
	Super.Paused(NewCommand);

	LeaveTurret(false);
}

function Resumed(name OldCommandName)
{
	Super.Resumed(OldCommandName);

	// if we evaded off the turret, it's not a good position so leave it unless forced to use it by designer
	if (OldCommandName == 'AICmd_Move_Evade' && ScriptedTurret == None)
	{
		PopCommand(self);
	}
	else
	{
		EnsureWereOnATurret();
	}
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

function bool EnsureWereOnATurret()
{
	// try and go to our last turret
	if (!IsAtTurret() && !HasValidTurret())
	{
		//debug
		`AILog("Has no current turret! trying to go to the last turret we were using ("@LastTurret@")");

		if( LastTurret != none && !LastTurret.ClaimTurret(AIOwner) )
		{
			//debug
			`AILog("Failed to use lastturret:"$LastTurret$", bailing...");

			GotoState('DelayFailure');
			return FALSE;
		}
		else
		{
			`AILog("Succesfully claimed "@LastTurret);
		}

	}
	return TRUE;
}

function LeaveTurret(bool bUnclaim)
{
	local int OldHealth;
	local Pawn Driver;

	`AILog(GetFuncName()@CurrentTurret@CurrentTurret.Driver@MyGearPawn);
	if (CurrentTurret != None)
	{
		LastTurret = CurrentTurret;
		if (bUnclaim)
		{
			LastTurret.UnclaimTurret(CoverOwner);
		}

		if( LastTurret.Driver == Pawn || LastTurret == Pawn )
		{
			Driver = LastTurret.Driver;
			// might be no driver if we're leaving through PopCommand() caused by death
			if (Driver != None)
			{
				OldHealth = Driver.Health;

				if(Driver.Health <= 0)
				{
					Driver.Health = 1;
				}
				LastTurret.DriverLeave(true);
				Driver.Health = OldHealth;
			}
		}
	}

	// restore the fire tickets flag
	bUseFireTickets = default.bUseFireTickets;
	ClearTimer( 'SelectTarget' );

}

/** @return whether we should cough up the turret we're using to a nearby ally */
final static function bool ShouldGiveTurretToAlly( GearAI_Cover AI, optional bool bMustBeOnTurret = TRUE )
{
	local GearPC PC;
	local float range;

	// NPC AIs (e.g. campaign allies) give up their turret for humans
	if( !AI.IsPlayerOwned() && (!bMustBeOnTurret || AI.Pawn == AI.CurrentTurret) )
	{
		foreach AI.WorldInfo.AllControllers(class'GearPC', PC)
		{
			range = 512.0;
			// if we've been scripted onto this turret don't give it up unless we're very close indeed
			if( AI.ScriptedTurret == AI.Pawn && PC.Pawn != None )
			{
				range = PC.Pawn.CylinderComponent.CollisionRadius+5;
			}
			if ( PC.Pawn != None && AI.WorldInfo.GRI.OnSameTeam(PC, AI) &&
				VSize(PC.Pawn.Location - AI.CurrentTurret.Location) < range && AI.LineOfSightTo(PC.Pawn) )
			{
				//`AILog("Giving turret to" @ PC @ ScriptedTurret @ range);
				//@todo: GUDS?
				return TRUE;
			}
		}
	}

	return FALSE;
}

state InCombat
{
	function BeginState(name PrevStateName)
	{
		Super.BeginState(PrevStateName);

		bUseFireTickets = false;
	}

	function EndState(name NextStateName)
	{
		Super.EndState(NextStateName);
		LeaveTurret(true);
	}

	function Tick(float DeltaTime)
	{
		if (HasValidTurret())
		{
			// have turret define how we should track enemies
			CurrentTurret.UpdateAIController(CoverOwner, DeltaTime);
		}

		Super.Tick(DeltaTime);
	}

	// check to see if the target is outside our rotation clamps
	function AdjustEnemyRating(out float out_Rating, Pawn EnemyPawn)
	{
		local float EnemyDist;
		local float TimeSinceSeen;

		if (CachedGearChildCommand != None)
		{
			CachedGearChildCommand.AdjustEnemyRating(out_Rating, EnemyPawn);
			return;
		}

		if (IsAtTurret())
		{
			// scale enemy rating if they're really close
			EnemyDist = VSize(GetEnemyLocation(EnemyPawn) - CurrentTurret.Location);
			if (EnemyDist < 512.0)
			{
				out_Rating *= 1.0 + (1.0 - (EnemyDist / 512.0));
			}
			// check to see if we could shoot them
			if (CanTurretFireAt(EnemyPawn))
			{
				out_Rating *= 1.5f;
			}
			else
			{
				out_Rating *= 0.5f;
				TimeSinceSeen = TimeSinceLastSeenEnemy( EnemyPawn );
				if( TimeSinceSeen > 3.f )
				{
					out_Rating = -1.f;
				}				
			}
		}

		Super.AdjustEnemyRating(out_Rating, EnemyPawn);
	}

	function vector GetEntryLocation()
	{
		local vector EntryLoc;
		local array<vector> Positions;

		EntryLoc = CurrentTurret.GetEntryLocation();

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

	if (HasValidTurret())
	{
		while (HasValidTurret())
		{
			if( ShouldGiveTurretToAlly( Outer ) )
			{
				Status = 'Success';
				PopCommand(self);
			}
			else if (ScriptedTurret != CurrentTurret && (CurrentTurret.Weapon == None || !CurrentTurret.Weapon.HasAnyAmmo()))
			{
				`AILog("Bail on turret because it is out of ammo"@CurrentTurret.Weapon@CurrentTurret.Weapon.HasAnyAmmo());
				Status = 'Success';
				PopCommand(self);
			}
			else if( ScriptedTurret == None && (ShouldMoveToSquad() || !HasAnyEnemies()) )
			{
				`AILog( "Bail on turret because we need to catch up to squad" );
				Status = 'Success';
				PopCommand( self );
			}
			// make sure we're at the turret
			else if (!IsAtTurret())
			{
				//debug
				`AILog( "Moving to turret", 'Turret' );

				IdleTime = 0;

				EntryLocation = GetEntryLocation();
				while (!Pawn.ReachedPoint(EntryLocation, None) && !Pawn.ReachedDestination(CurrentTurret))
				{
					`AILog("Moving to entry location for turret" @ CurrentTurret);
					SetMovePoint(EntryLocation);
					if (ChildStatus == 'Failure')
					{
						// see if it will let us enter anyway
						if ( VSize(Pawn.Location - CurrentTurret.Location) < 256.0 &&
							Abs(Pawn.Location.Z - CurrentTurret.Location.Z) < Pawn.GetCollisionHeight() &&
							CurrentTurret.TryToDrive(Pawn) )
						{
							break;
						}
						else
						{
							`AILog("Unable to reach turret");
							Status = 'Failure';
							PopCommand(self);
						}
					}
					Sleep(0.1);
				}

				if( HasValidTurret() && !IsAtTurret() && !CurrentTurret.TryToDrive(Pawn) )
				{
					//debug
					`AILog("FAILED TO DRIVE");

					//@hack!!!
					EntryLocation = GetEntryLocation();
					Pawn.SetLocation(EntryLocation);
					CurrentTurret.TryToDrive(Pawn);

					Sleep(1.f);
				}
			}
			else
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
					CoverOwner.TurretIdle(IdleTime);
				}
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
