
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Blend by mutation type 
 * Check the items if you'd like to know if anything is mutated or not
 */

class GearAnim_CorpserSpawner_Blend extends AnimNodeBlendList
	native(Anim);


cpptext
{
	virtual void TickAnim(FLOAT DeltaSeconds);
};

defaultproperties
{
	Children.Empty
	Children(0)=(Name="Idle")
	Children(1)=(Name="Cracked")
	Children(2)=(Name="Open")
	Children(3)=(Name="Dead")

	bPlayActiveChild = TRUE;
}
