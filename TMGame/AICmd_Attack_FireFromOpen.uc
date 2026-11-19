/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_FireFromOpen extends AICommand
	within TGAI;

/** number of bursts to fire (-1 for infinite) */
var int BurstsToFire;
var bool bFireWhileMoving;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool FireFromOpen(TGAI AI, optional int InBursts = 1,optional bool bAllowFireWhileMoving=true)
{
	local AICmd_Attack_FireFromOpen Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_Attack_FireFromOpen';
		Cmd.BurstsToFire = InBursts;
		Cmd.bFireWhileMoving = bAllowFireWhileMoving;
		AI.PushCommand( Cmd );
		return true;
	}

	return FALSE;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@"Bursts"@BurstsToFire;
}

function Pushed()
{
	Super.Pushed();

	if (TGAI_Cover(Outer) != None)
	{
		TGAI_Cover(Outer).ResetCoverType();
	}

	bFailedToFireFromOpen = FALSE;

	TriggerAttackGUDS();
	GameAIOwner.SetTimer( 15.f, TRUE, nameof(TGAI(GameAIOwner).TriggerAttackGUDS) );

	GotoState( 'Firing' );
}

function Popped()
{
	Super.Popped();

	GameAIOwner.ClearTimer('TriggerAttackGUDS');

	if (MyTGPawn != None)
	{
		MyTGPawn.SetTargetingMode(false);
	}

	bFailedToFireFromOpen = (Status != 'Success');
}

state Firing 
{
Begin:
	//debug
	;

	if( !bTurtle )
	{
		if( HasValidTarget() )
		{
			if( !CanFireAt(FireTarget, Pawn.GetWeaponStartTraceLocation()) )
			{
				//debug
				;

				if( FireTarget == Enemy && AllowedToMove() && IsEnemyWithinCombatZone(Enemy))
				{
					SetEnemyMoveGoal(,,,bFireWhileMoving);
					if( bFailedToMoveToEnemy ||
						!CanFireAt(FireTarget, Pawn.GetWeaponStartTraceLocation()))
					{
						//debug
						;

						Sleep(0.25f);

						Status = 'Failure';
						PopCommand( self );
					}
				}
				else
				{
					Sleep(0.25f);

					Status = 'Failure';
					PopCommand( self );
				}
			}

			Focus = FireTarget;
			Sleep(0.5f);

			if (MyTGPawn != None)
			{
				if(MyTGPawn.IsCarryingAHeavyWeapon())
				{
					Sleep(0.5f); // more time to recenter toward enemy
				}

				// set fire mode for all (not just heavy)
				MyTGPawn.SetTargetingMode(true);

				if(MyTGPawn.IsCarryingAHeavyWeapon())
				{
					do
					{
						Sleep(0.25f);
						//debug
						;
					} until (!IsMountingWeapon());

					;
					if( !IsSwitchingWeapons() )
					{
						if( SelectWeapon() )
						{
							Sleep( 0.25f );
						}
					}
					while( IsSwitchingWeapons() )
					{
						//debug
						;

						Sleep(0.25f);
					}
				}


			}

			//@FIXME: probably should be done generally but I'd rather not shake things up at this point
			//	just to make the Casual bots a little easier
			if (GetDifficultyLevel() == DL_Casual)
			{
				FinishRotation();
			}

			if( ClaimFireTicket() )
			{
				Sleep(AboutToFireFromOpen());

				StartFiring(BurstsToFire);

				// wait for possible reload
				if(IsReloading())
				{
					if (CoverOwner != None && GetDifficultyLevel() > DL_Normal)
					{
						;
						Status = 'Success'; // sort of lying, but don't want commands under this to think something broke
						PopCommand(self);
					}

					do
					{
						Sleep(0.25f);
						//debug
						;
					} until( !IsReloading() );
				}

				do
				{
					Sleep(0.25f);

					//debug
					;
				} until (!IsFiringWeapon());

				Sleep(0.1f);

				;
				if( !IsSwitchingWeapons() )
				{
					if( SelectWeapon() )
					{
						Sleep( 0.25f );
					}
				}
				while( IsSwitchingWeapons() )
				{
					//debug
					;

					Sleep(0.25f);
				}
			}
			else
			{
				//debug
				;

/*
				// Give combat action a chance to evaluate
				if( CombatAction != None )
				{
					CombatAction.static.NotifyFireTicketUnavailable( self );
				}
*/
				// Just rest for a moment
				Sleep( 0.5f );
			}
		}
		else
		{
			//debug
			;

			Sleep(0.5f);
//			CombatAction.static.NotifyUnableToFireFromCover(self);
		}
	}
	else
	{
		;
		Sleep(0.5);
	}

	Status = bFailedToFireFromOpen ? 'Failure' : 'Success';
	PopCommand( self );
}


