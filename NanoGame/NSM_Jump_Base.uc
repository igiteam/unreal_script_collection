/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Jump_Base extends NanoSpecialMove
	native(SpecialMoves);

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );
	MyNP.LockDesiredRotation( TRUE );
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	MyNP.LockDesiredRotation( FALSE );
	Super.SpecialMoveEnded( PrevMove, NextMove );
}

function bool CanOverrideMoveWith( Name NewMove )
{
	return TRUE;
}

function bool CanOverrideSpecialMove( Name InMove )
{
	return TRUE;
}
	
function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	// End the holder special move once we are on the ground
	if( MyNP.Physics != PHYS_Falling )
	{
		MyNP.EndSpecialMove();
	}
	else
	{
		MyNP.HandleMantleChecks(None);
	}
}