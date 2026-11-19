/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_BerserkerCharge extends AICommand_SpecialMove
	within GearAI_BerserkerBase;


/** Whether the berserker stopped updating her rotation toward her enemy or not */
var transient bool bStoppedRotationTowardEnemy;

/** The time this move started */
var transient float StartChargeTime;


function Pushed()
{
	local Vector VectToTarg;

	super.Pushed();

	SetFocalPoint(Vect(0,0,0));
	MyGearPawn.ResetDesiredRotation();
	MyGearPawn.bAllowAccelSmoothing = FALSE;
	FireTarget = Enemy;
	Focus = None;
	StopFiring();

	// Update controller destination
	VectToTarg		 = ChargeLocation-Pawn.Location;
	VectToTarg.Z	 = 0;
	ChargeLocation  += Normal(VectToTarg) * 128.f;
	SetDestinationPosition( ChargeLocation, TRUE );

 	// Tell Pawn in which direction we'd like to launch our attack
	// This is replicated so the special move can use it.
	GearPawn_LocustBerserkerBase(Pawn).SetDesiredRootRotation( rotator(ChargeLocation - Pawn.Location) );

	// Uncomment this to have Berserker pre-rotate before charging.
	Pawn.SetDesiredRotation( rotator(ChargeLocation - Pawn.Location) );

	// Preparing charge move - pawn needs to rotate towards target first
	bPreparingCharge	= TRUE;
	bPreparingMove		= TRUE;

	bStoppedRotationTowardEnemy = false;

	Pawn.SetAnchor( None );

	StartChargeTime = WorldInfo.TimeSeconds;
}

function Popped()
{
	local GearPawn_LocustBerserkerBase P;

	super.Popped();

	bPreparingMove = FALSE;
	MyGearPawn.bAllowAccelSmoothing = MyGearPawn.default.bAllowAccelSmoothing;

	P = GearPawn_LocustBerserkerBase(Pawn);
	if (P != None)
	{
		P.EndSpecialMove();
		P.ClearDesiredRootRotation();
	}
}

auto state Command_SpecialMove
{
	function Tick( float DeltaTime )
	{
		local GearPawn_LocustBerserkerLambentBase LambentBerserker;
		local float LerpDelta;

		Global.Tick( DeltaTime );

		// If we've stopped her rotation toward her enemy, do not set a new charge location
		if (!bStoppedRotationTowardEnemy)
		{
			SetChargeLocation(Enemy, Enemy.Location);
		}

		// Lerp destination to charge location so she doesn't snap toward enemy
		LambentBerserker = GearPawn_LocustBerserkerLambentBase(Pawn);
		if (LambentBerserker != None &&
			LambentBerserker.CurrentPhase < LambentBerserker.PhaseInfo.length)
		{
			if (StartChargeTime + LambentBerserker.ChargeTimeToJump < WorldInfo.TimeSeconds &&
				LambentBerserker.PhaseInfo[LambentBerserker.CurrentPhase].bCanDoJumpAttack &&
				LambentBerserker.IsDoingSpecialMove(SM_Berserker_Charge) &&
				LambentBerserker.IsReadyForJumpAttack() &&
				LambentBerserker.PrepareForJumpAttack(true))
			{
				bForceJumpAttack = true;
				AbortCommand(self);
				return;
			}

			// Make sure the berserker hasn't already stopped rotating and if she hasn't see if she should
			if (!bStoppedRotationTowardEnemy &&
				VSize(Enemy.Location - LambentBerserker.Location) > LambentBerserker.PhaseInfo[LambentBerserker.CurrentPhase].StopChargeDistance)
			{
				// Allow the speed of the berserker's rotation speed be configurable
				LerpDelta = DeltaTime + LambentBerserker.PhaseInfo[LambentBerserker.CurrentPhase].ChargeRotationSpeed;
				LerpDelta = FClamp(LerpDelta, 0.0f, 1.0f);
			}
			else
			{
				// We haven't stopped her from adjusting her rotation to her enemy yet, but are about to
				if (!bStoppedRotationTowardEnemy)
				{
					// Stop rotation to enemy and set the final destination so we can add a configurable over shoot to her charge
					bStoppedRotationTowardEnemy = true;
					SetChargeLocation(None, Pawn.Location + Normal(Pawn.Velocity) * LambentBerserker.PhaseInfo[LambentBerserker.CurrentPhase].ChargeOverShootDistance);
					SetDestinationPosition(ChargeLocation, TRUE);
					SetDesiredRotation(Rotator(ChargeLocation-Pawn.Location));
					if (GearPawn(Pawn).IsDoingSpecialMove(SM_Berserker_Charge))
					{
						GearPawn(Pawn).SpecialMoves[SM_Berserker_Charge].SetLockPawnRotation(true);
					}
				}
			}
		}
		else
		{
			LerpDelta = DeltaTime;
		}

		// Stop her rotation toward her enemy
		if (!bStoppedRotationTowardEnemy)
		{
			SetDestinationPosition(VLerp(GetDestinationPosition(), ChargeLocation, LerpDelta), TRUE);
			SetDesiredRotation(Rotator(GetDestinationPosition()-Pawn.Location),,, LerpDelta);
		}
	}

	function ESpecialMove GetSpecialMove()
	{
		return SM_Berserker_Charge;
	}

	function DoChargeSlide()
	{
		//debug
		`AILog( GetFuncName() );

		if( MyGearPawn != None )
		{
			SetFocalPoint(Vect(0,0,0));
			MyGearPawn.ResetDesiredRotation();
			NextHearTime = WorldInfo.TimeSeconds + default.NextHearTime;
			MyGearPawn.DoSpecialMove( SM_Berserker_Slide, TRUE );
		}
	}

Begin:
	//debug
	`AILog( "BEGIN TAG"@GetStateName(), 'State' );

	FinishRotation();

	if( ExecuteSpecialMove() )
	{
		// Wait for pawn to be aligned to target
		if( bPreparingCharge )
		{
			do
			{
				sleep(0.1f);
			} until( !bPreparingCharge || GearPawn(Pawn) == None || GearPawn(Pawn).SpecialMove == SM_None );
		}

		do
		{
			//debug
			`AILog( "Waiting for SM to end"@GearPawn(Pawn).SpecialMove, 'Loop' );

			Sleep(0.1f);

			if( GearPawn(Pawn).IsDoingSpecialMove(SM_Berserker_Charge) )
			{
				// If we've stopped her from updating her rotation to her enemy
				if (bStoppedRotationTowardEnemy)
				{
					// If she is close to the charge location (which can be set to over shoot in the config)
					if (VSize(Pawn.Location - ChargeLocation) < 128.0f)
					{
						DoChargeSlide();
					}
				}
				// exit with a slide move if we're done or something goes wrong and we end up moving the wrong way
				else if (!bPreciseDestination || IsZero(Pawn.Velocity) || Normal(Pawn.Velocity) dot vector(Pawn.Rotation) < 0.7)
				{
					DoChargeSlide();
				}
			}
		} until (!bPreparingMove || GearPawn(Pawn) == None || GearPawn(Pawn).SpecialMove == SM_None);
		FinishedSpecialMove();
		Sleep( GetPostSpecialMoveSleepTime() );
	}
	else
	{
		//debug
		`AILog("Failed to do special move");

		Sleep(0.5f);
	}

	SetFocalPoint(Vect(0,0,0));
	MyGearPawn.ResetDesiredRotation();
	PopCommand(self);
}
