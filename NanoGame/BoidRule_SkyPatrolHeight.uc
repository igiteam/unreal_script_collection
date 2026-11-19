/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class BoidRule_SkyPatrolHeight extends BoidMovementRule within NanoAI
	native(AI);

cpptext
{
	virtual void ModifyPawnVelocity( ANanoPawnBase* P, FLOAT DeltaTime );
	virtual UBOOL IsActive( ANanoPawnBase* P );
}


defaultproperties
{
}