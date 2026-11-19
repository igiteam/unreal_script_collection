/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Thrustered extends NanoSpecialMove;


var float DurationOfThruster;

var transient float TimeThrusted;

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	MyNP.SetPhysics( PHYS_Falling );

	TimeThrusted = MyNP.WorldInfo.TimeSeconds;

	// When they land after this they will be knocked down
	MyNP.bKnockDownOnLanding = TRUE;
}

function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( `TimeSinceEx( MyNP, TimeThrusted) > DurationOfThruster )
	{
		MyNP.EndSpecialMove();
	}

	if( MyNP.Physics == PHYS_Walking && !MyNP.bKnockDownOnLanding && !MyNP.bKnockedDown )
	{
		MyNP.EndSpecialMove();
	}
}


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );
}


defaultproperties
{
	DurationOfThruster = 10.0f
}