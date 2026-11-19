/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoSoftContainmentAnchor extends NanoTargetPoint;

/** If you are outside of this you will get a warning saying you are exiting the "safe" zone. **/
var() float SoftRadius;

/** If you are outside of this you will get a chaos increase based on the settings on this object. **/
var() float HardRadius;


/** If you breach the hard radius you get immediate chaos increase **/
var() bool bImmediateChaosIncreaseOnBreachOfHardRadius;

/** If when breaching the soft radius you get N seconds before chaos increase**/
var() bool bUseTimerOnBreachOfSoftRadius;

/** How long you get after breaching soft radius**/
var() float DurationAfterSoftBreachBeforeChaosIncrease;

/** Sound to play when the player breaches the soft radius**/
var() SoundCue BreachOfSoftRadiusAlertSound;


/** Whether or not a breach has occurred **/
var transient bool bSoftBreachHasOccurred;
var transient bool bHardBreachHasOccurred;

simulated function Tick( float DeltaSeconds )
{
	local NanoPC NPC;
	local float PlayerDistanceFromCenter;

	Super.Tick( DeltaSeconds );


	//FIXMEMP:  Assumes there is only one player!
	foreach WorldInfo.AllControllers(class'NanoPC', NPC)
	{
		break;
	}


	PlayerDistanceFromCenter = VSize( NPC.Pawn.Location - Location );

	if( ( bSoftBreachHasOccurred == FALSE )
		&& ( PlayerDistanceFromCenter > SoftRadius )
		)
	{
		if( bUseTimerOnBreachOfSoftRadius == TRUE )
		{
			SetTimer( DurationAfterSoftBreachBeforeChaosIncrease, FALSE, nameof(FireOffTimerBasedSoftContainmentBreach) );
		}

		NPC.Pawn.PlaySound( BreachOfSoftRadiusAlertSound );

		bSoftBreachHasOccurred = TRUE;
	}


	if( ( bHardBreachHasOccurred == FALSE )
		&& ( PlayerDistanceFromCenter > HardRadius )
		)
	{
		if( bImmediateChaosIncreaseOnBreachOfHardRadius == TRUE )
		{
			NanoGRI(WorldInfo.GRI).ModifyChaosLevel( NanoPawn(NPC.Pawn).GetChaosZone(), self, class'NanoCausingChaosValues'.default.BreachedSoftContainmentZone );
		}

		bHardBreachHasOccurred = TRUE;
	}


	if( ( PlayerDistanceFromCenter < SoftRadius )
		)
	{
		ClearTimer( nameof(FireOffTimerBasedSoftContainmentBreach) );
		bSoftBreachHasOccurred = FALSE;
	}

	if( ( PlayerDistanceFromCenter < HardRadius )
		)
	{
		bHardBreachHasOccurred = FALSE;
	}

}


function FireOffTimerBasedSoftContainmentBreach()
{
	local NanoPC NPC;

	foreach WorldInfo.AllControllers(class'NanoPC', NPC)
	{
		break;
	}


	NanoGRI(WorldInfo.GRI).ModifyChaosLevel( NanoPawn(NPC.Pawn).GetChaosZone(), self, class'NanoCausingChaosValues'.default.BreachedSoftContainmentZone );
}




defaultproperties
{
	bIsActive=TRUE
	Debug_InfoTextVerticalOffset=64

	SoftRadius=15000
	HardRadius=17000

	bImmediateChaosIncreaseOnBreachOfHardRadius=TRUE
	bUseTimerOnBreachOfSoftRadius=TRUE
	DurationAfterSoftBreachBeforeChaosIncrease=30.0f

	BreachOfSoftRadiusAlertSound=SoundCue'Cinematics_InGame.FirstMission.CliffHanger_BullramsApproach_Cue'
}