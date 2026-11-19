/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_EscapeFromBeingStuckLandingOnWall extends NanoSpecialMove;


protected function bool InternalCanDoSpecialMove()
{
	return Super.InternalCanDoSpecialMove();
}


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	`warn( "FALLBACK!!" @ "now doing NSM_EscapeFromBeingStuckLandingOnWall to attempt to get off wall" );

	EscapeFromBeingStuckLandingOnWall();

	// safe guard to make certain if we never have this SpecialMoveEnded called on us that we actually do end
	MyNP.SetTimer( 5.0f, FALSE, nameof(SpecialMoveEnded), self );
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	MyNP.ClearTimer(  nameof(SpecialMoveEnded), self );
}


simulated function EscapeFromBeingStuckLandingOnWall()
{
	local vector X, Y, Z;

	MyNP.GetAxes( MyNP.Rotation, X, Y, Z );
	MyNP.Velocity = -X * 16;

	MyNP.Velocity.Z += 16;
}




defaultproperties
{

}