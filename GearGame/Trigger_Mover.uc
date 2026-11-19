/**
* Trigger_Mover
* Hacky trigger class for detecting touch events with KActors and InterpActors
*
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class Trigger_Mover extends Trigger
	placeable
	native;

cpptext
{
	virtual void TickSpecial( FLOAT DeltaSeconds );
};

defaultproperties
{
	bStatic=false
}
