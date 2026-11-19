/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPawn_MetaCorp_MechsBase extends NanoPawn  // has to extend NanoPawn or nothing works
	native(Pawn)
	abstract;


event HitWall( vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	local NanoBustableActor Bustable;

	Super.HitWall(HitNormal, Wall, WallComp);

	Bustable = NanoBustableActor(Wall);

	if( ( Bustable != None ) && ( Bustable.bCanBeSmashedByMechs == TRUE ) )
	{
		if( !Bustable.bBusted )
		{
			Bustable.bBusted = TRUE;
			Bustable.OnBust();
		}
	}
}


defaultproperties
{

}