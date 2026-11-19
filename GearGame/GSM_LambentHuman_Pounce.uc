
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_LambentHuman_Pounce extends GSM_LambentHuman_Leap;

protected function bool InternalCanDoSpecialMove()
{
	local GearAI AI;
	local Vector StartTrace, EndTrace, Extent;

	if( !PawnOwner.IsHumanControlled() )
	{
		AI = GearAI(PawnOwner.Controller);
		if( AI == None || AI.NavigationHandle == None )
		{
			return FALSE;
		}

		StartTrace = PawnOwner.Location;
		EndTrace = StartTrace + (Vector(PawnOwner.Rotation) * PawnOwner.MaxPounceDistXY);
		Extent = PawnOwner.GetCollisionExtent() * vect(1,1,0.5f);

//  		PawnOwner.FlushPersistentDebugLines();
//  		PawnOwner.DrawDebugBox( StartTrace, Extent, 255, 0, 0, TRUE );
//  		PawnOwner.DrawDebugBox( EndTrace, Extent, 0, 255, 0, TRUE );
//  		PawnOwner.DrawDebugLine( StartTrace, EndTrace, 255, 0, 0, TRUE );

		if( !AI.NavigationHandle.ObstacleLineCheck( StartTrace, EndTrace , Extent ) )
		{
			return FALSE;
		}
	}

	return TRUE;
}

defaultproperties
{
}
