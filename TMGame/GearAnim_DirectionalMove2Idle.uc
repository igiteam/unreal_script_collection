
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class GearAnim_DirectionalMove2Idle extends GearAnim_BlendAnimsByDirection
	native(TGAnim);

/** Directional Transition information. */
struct native DTransInfo
{
	/** Name of transition */
	var()	Name	TransitionName;
	var()	Name	AnimName_Fd;
	var()	Name	AnimName_Bd;
	var()	Name	AnimName_Lt;
	var()	Name	AnimName_Rt;
};

var() Array<DTransInfo>	DTransList;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

