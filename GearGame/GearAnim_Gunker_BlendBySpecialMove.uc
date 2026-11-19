
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 *
 * Queries the Pawn's SpecialMove and activates the proper child
 * associated with each type.  
 */

class GearAnim_Gunker_BlendBySpecialMove extends GearAnim_BlendBySpecialMove
	native(Anim);


cpptext
{
	virtual void TickAnim(FLOAT DeltaSeconds);
};

defaultproperties
{
	Children.Empty
	Children(0)=(Name="Default")
	Children(1)=(Name="MeleeSwipe")
	Children(2)=(Name="Chop Attack")
	Children(3)=(Name="Lob Attack")
	Children(4)=(Name="Shoot Attack")
	Children(5)=(Name="Death")

	ChildBlendInTime.Empty
	ChildBlendInTime(0)=0.2f
	ChildBlendInTime(1)=0.2f
	ChildBlendInTime(2)=0.2f
	ChildBlendInTime(3)=0.2f
	ChildBlendInTime(4)=0.2f
	ChildBlendInTime(5)=0.2f
}
