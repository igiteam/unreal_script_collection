
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class GearAnim_BlendByWeaponFire extends AnimNodeBlend
	native(TGAnim);

/** Internal cached pointer to TGPawn Owner */
var const	transient	TGPawn		TGPawnOwner;

/** Maximum weight of fire node. Set lower to one to retain some of the idle movement */
var()	float	MaxFireBlendWeight;

/** duration of blends */
var()	float	BlendInTime;
var()	float	BlendOutTime;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)



