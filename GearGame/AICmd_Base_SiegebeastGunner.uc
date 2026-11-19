/**
 * AI command to seek out a Siegebeast seat
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Base_SiegebeastGunner extends AICommand_Base_Combat
	within GearAI_Cover;

/** Location of the Siegebeast seat we're trying to sit in */
var protected transient vector SeatLocation;

/** Rotation of the Siegebeast seat we're trying to sit in */
var protected transient rotator SeatRotation;

var bool bSavedGodMode;

/**
 * Disallow clearing the AI command
 *
 * @return FALSE if we're attempting to clear the AI command
 */
function bool AllowTransitionTo(class<GameAICommand> AttemptCommand)
{
	if( AttemptCommand == None )
	{
		return FALSE;
	}

	if( HasValidSiegebeast() )
	{
		return FALSE;
	}

	return Super.AllowTransitionTo( AttemptCommand );
}

/** Start the combat state and suppress reactions */
function Pushed()
{
	bSavedGodMode = bGodMode;
	if( GetTeamNum() == TEAM_COG )
	{
		bGodMode = TRUE;
	}

	Super.Pushed();

	ReactionManager.SuppressAllChannels();
	CurrentSiegebeast.GunnerClaim = Outer;

	GotoState( 'InCombat' );
}

/** Unsuppress the reactions */
function Popped()
{
	bGodMode = bSavedGodMode;
	Super.Popped();

	CurrentSiegebeast.GunnerClaim = None;
	ReactionManager.UnSuppressAllChannels();
}

/**
 * Check that the Siegebeast still has a vacancy and a driver
 *
 * @return TRUE if the Siegebeast is good to go
 */
final function bool HasValidSiegebeast()
{
	return CurrentSiegebeast != None && CurrentSiegebeast.SeatAvailable(CurrentSiegebeastSeat);
}

/**
 * Check if we're at the siegebeast
 *
 * @return TRUE if we're there
 */
final function bool IsAtSiegebeast()
{
	return (CurrentSiegebeast != None && Pawn != None && (Pawn == CurrentSiegebeast || Pawn.GetVehicleBase() == CurrentSiegebeast));
}

final function bool CalcSeatLocation()
{
	local array<Vector> ValidLocList;

	SeatRotation.Yaw = CurrentSiegebeast.Rotation.Yaw;
	CurrentSiegebeast.Mesh.GetSocketWorldLocationAndRotation(CurrentSiegebeast.Seats[CurrentSiegebeastSeat].SeatBone, SeatLocation );
	SeatLocation += (vect(-100,0,0) >> SeatRotation);
 	SeatLocation.Z += 32.f;

	NavigationHandle.GetValidPositionsForBox( SeatLocation, 128.f, Pawn.GetCollisionExtent(), TRUE, ValidLocList, 1 );

	if( ValidLocList.Length > 0 )
	{
		SeatLocation = ValidLocList[0];
		return TRUE;
	}
	return FALSE;
}

state InCombat
{
	/** Leave cover */
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		InvalidateCover();
	}

Begin:
	`AILog( "BEGIN TAG"@HasValidSiegebeast()@IsAtSiegebeast(), 'State' );

	if( HasValidSiegebeast() )
	{
		while (TRUE)
		{
			if (!IsAtSiegebeast())
			{
				`AILog( "Moving to siegebeast", 'Siegebeast' );

				CalcSeatLocation();

//				DrawDebugSphere(SeatLocation, 10, 10, 255, 255, 255, TRUE);

				SetMovePoint(SeatLocation);

				if (VSize(Pawn.Location - SeatLocation) < 100 && HasValidSiegebeast())
				{
					if( !CurrentSiegebeast.TryToDrive(Pawn) )
					{
						`AILog( "FAILED TO DRIVE" );
	
						Pawn.SetLocation(SeatLocation);
					}
				}
			}

			// added to avoid infinite recursion
			Sleep(0.1f);
			
			if( !IsAtSiegebeast() || CurrentSiegebeast.Driver == None )
			{
				//debug
				`AILog("Error: Siegebeast gone, can't gun!");

				// Abort, pop this command off the stack
				PopCommand(Self);
			}
		}
	}
	else
	{
		//debug
		`AILog("Error: No siegebeast, can't gun!");

		// Abort, pop this command off the stack
		PopCommand(Self);
	}
}
