/**
 * AnimNodeBlendByProperty.uc
 * Looks at a specific property of the Pawn and will blend between two inputs based on its value
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAnimNodeBlendByCamera extends NanoAnimBlendList
		native(Anim);

cpptext
{
	virtual	void TickAnim(FLOAT DeltaSeconds);
}

defaultproperties
{
	Children(0)=(Name="FirstPerson")
	Children(1)=(Name="ThirdPerson")

	bFixNumChildren=TRUE
	bForceChildFullWeightWhenBecomingRelevant=FALSE

	BlendTime=0.0
}
