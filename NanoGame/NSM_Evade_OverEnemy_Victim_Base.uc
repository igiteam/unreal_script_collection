/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Evade_OverEnemy_Victim_Base extends NSM_PlaySingleAnim_Base
	native(SpecialMoves)
	abstract;

var() Vector	MarkerOffset;

protected function bool InternalCanDoSpecialMove()
{
	if( MyNP.Physics != PHYS_Walking )
	{
		return FALSE;
	}
	return Super.InternalCanDoSpecialMove();
}

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	MyNP.StopFiring();
	MyNP.ZeroMovementVariables();

	MoveToMarkers();
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	MyNP.Knockdown( 1.f + FRand() * 2.f );
}

/** Place both characters on markers, so they can connect and play their grab animation for attachment */
function MoveToMarkers()
{
	local Vector	Dest;

	if( (Vector(MyNP.Rotation) DOT Vector(MyNP.InteractionPawn.Rotation)) < 0.f )
	{
		MyNP.SetDesiredRotation( MyNP.InteractionPawn.Rotation + rot(0,32768,0), TRUE );
		Dest = RelativeToWorldOffset( MyNP.DesiredRotation, -MarkerOffset );
	}
	else
	{
		MyNP.SetDesiredRotation( MyNP.InteractionPawn.Rotation, TRUE );
		Dest = RelativeToWorldOffset( MyNP.DesiredRotation, MarkerOffset );
	}
	Dest += MyNP.InteractionPawn.Location;

/*
	MyNP.FlushPersistentDebugLines();
	MyNP.DrawDebugBox( Dest, vect(5,5,5), 255, 0, 0, TRUE );
	MyNP.DrawDebugBox( MyNP.InteractionPawn.Location, vect(5,5,5), 0, 0, 255, TRUE );
	`log( `location@Dest );
*/

	// Move leader relative to enemy, so his marker aligns with enemy's root bone.
	SetReachPreciseDestination( Dest );
}

event ReachedPrecisePosition()
{
	PlayAnimation();
}

defaultproperties
{
	bAutoPlayAnimation=FALSE
}