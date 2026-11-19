/**
 * GearAnim_BlendByBaseSpeed
 *
 * Blends between child nodes based on the owners speed and the defined constraints.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAnim_BlendByBaseSpeed extends AnimNodeBlendBySpeed
	native(Anim);

cpptext
{
	// AnimNodeBlendBySpeed interface

	/** 
	 *	Function called to calculate the speed that should be used for this node. 
	 *	Allows subclasses to easily modify the speed used.
	 */
	 virtual FLOAT CalcSpeed();
}

defaultproperties
{
}
