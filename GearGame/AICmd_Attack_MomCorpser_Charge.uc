/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_MomCorpser_Charge extends AICommand_SpecialMove
	within GearAI_MomCorpser;

function Pushed()
{
	local vector DirToTarg;
	local Rotator DesiredRot;

	super.Pushed();

	if (EnemyWhoShotEyeLocation != vect(0,0,0))
	{
		DirToTarg = Normal(EnemyWhoShotEyeLocation-Pawn.Location);
		SetChargeLocation( None, EnemyWhoShotEyeLocation + DirToTarg * 10000.0f );
	}
	else
	{
		DirToTarg = Normal(Enemy.Location-Pawn.Location);
		SetChargeLocation( Enemy, Enemy.Location + DirToTarg * 10000.0f );
	}
	EnemyWhoShotEyeLocation = vect(0,0,0);

	SetFocalPoint(Vect(0,0,0));
	MyGearPawn.ResetDesiredRotation();
	Focus = None;
	StopFiring();

	// Update controller destination
	SetDestinationPosition( ChargeLocation, TRUE );

 	// Tell Pawn in which direction we'd like to launch our attack
	// This is replicated so the special move can use it.
	DesiredRot = Rotator(ChargeLocation - Pawn.Location);
	GearPawn_LocustMomCorpserBase(Pawn).SetDesiredRootRotation( DesiredRot );

	// Preparing charge move - pawn needs to rotate towards target first
	bPreparingCharge	= TRUE;
	bPreparingMove		= TRUE;

	Pawn.SetAnchor( None );

	Corpser.StopStabAttack();
}

function Popped()
{
	local GearPawn_LocustMomCorpserBase P;

	super.Popped();

	bPreparingMove = FALSE;

	P = GearPawn_LocustMomCorpserBase(Pawn);
	if (P != None)
	{
		P.EndSpecialMove();
		P.ClearDesiredRootRotation();
	}
}

auto state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return SM_Corpser_Charge;
	}

	function DoChargeSlide()
	{
		//debug
		`AILog( GetFuncName() );

		if( MyGearPawn != None )
		{
			SetFocalPoint(Vect(0,0,0));
			MyGearPawn.ResetDesiredRotation();
			MyGearPawn.DoSpecialMove(SM_Corpser_Hurt, true);
		}
	}

Begin:
	//debug
	`AILog( "BEGIN TAG"@GetStateName(), 'State' );

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

			if( GearPawn(Pawn).IsDoingSpecialMove(SM_Corpser_Charge) )
			{
				// Exit with a slide move if we're done or something goes wrong and we end up moving the wrong way
				if( !bPreciseDestination || IsZero(Pawn.Velocity) || Normal(Pawn.Velocity) dot vector(Pawn.Rotation) < 0.7 )
				{
					break;
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
	Focus = Enemy;
	MyGearPawn.ResetDesiredRotation();
	PopCommand(self);
}

event DrawDebug( HUD H, Name Category )
{
	Super.DrawDebug( H, Category );

	DrawDebugLine( Pawn.Location, ChargeLocation, 255, 128, 255 );
	DrawDebugCylinder( ChargeLocation, ChargeLocation, 64.f, 10, 255, 128, 255 );

	if( ChargeActor != None )
	{
		DrawDebugLine( Pawn.Location, ChargeActor.Location, 255, 128, 255 );	
	}
}

defaultproperties
{
}