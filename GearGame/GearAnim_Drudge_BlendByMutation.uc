
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Blend by mutation type 
 * Check the items if you'd like to know if anything is mutated or not
 */

class GearAnim_Drudge_BlendByMutation extends AnimNodeBlendList
	native(Anim);

/** Check if you'd like to blend when arm is mutated. **/
var() bool ArmsMutated;
/** Check if you'd like to blend when leg is mutated. **/
var() bool LegsMutated;
/** Check if you'd like to blend when head is mutated. **/
var() bool HeadMutated;

cpptext
{
	virtual void TickAnim(FLOAT DeltaSeconds);
};

defaultproperties
{
	Children.Empty
	Children(0)=(Name="Default")
	Children(1)=(Name="Mutated")

	bPlayActiveChild = TRUE;
}
