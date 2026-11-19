/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 * Targeted Reaction Condition - activates when an enemy in front of us has his crosshair on us
 */
class AIReactCond_Targeted extends AIReactCondition_Base
	native(TGAI);

var Pawn Shooter;
/** enemies within this range will qualify for evade */
var() float ShooterRangeThreshold;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


event Activate( Actor EventInstigator, AIReactChannel OriginatingChannel )
{
	Super.Activate(EventInstigator, OriginatingChannel);
	if( Shooter != None )
	{
		// If in cover not exposed to the shooter
		if( MyTGPawn.IsInCover() && !IsCoverExposedToAnEnemy( TGAI_Cover(Outer).Cover, Shooter ) )
		{
			// Stop leaning out as a "dodge"
			if( MyTGPawn.IsLeaning() || MyTGPawn.IsPeeking(MyTGPawn.CoverAction) )
			{
				bFailedToFireFromCover = TRUE;
			}
		}
		// Otherwise, do the evade
		else
		if( InterpActor(MyTGPawn.Base) == None )
		{
			DoEvade( GetBestEvadeDir( MyTGPawn.Location, Shooter ), TRUE );
		}
	}
	else
	{
		;
	}
}




