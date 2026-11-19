/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DenseBash extends NanoSpecialMove;


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	SetMovementLock( TRUE );

	MyNP.EnableFakeDenseEffects();

	MyNP.SetTimer( 1.0f, FALSE, nameof(MyNP.EndSpecialMove) );
}


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	SetMovementLock( FALSE );
	MyNP.DisableFakeDenseEffects();

	MyNP.ClearTimer( nameof(MyNP.EndSpecialMove) );
}


function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	MyNP.ZeroMovementVariables();
}






defaultproperties
{
	bDisableMovement=TRUE
}


