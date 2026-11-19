/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_MesmorizedByNanoAttractor extends NSM_StopAndPlayAnAnimationLooping;



function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );


	MyNP.ZeroMovementVariables();

	MyNP.SetTimer( class'NanoAttractMetaCorpTroopsBase'.default.DurationOfEffectiveAttraction, FALSE, nameof(MyNP.EndSpecialMove) );

}


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );
}


function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

}










defaultproperties
{

}


