
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_BlendByTargetingMode extends GearAnim_BlendList
	native(TGAnim);

/** Internal cached pointer to TGPawn Owner */
var const	transient	TGPawn		TGPawnOwner;

/** Internal cached pointer to owner's weapon */
var const	transient	TGWeapon	Weapon;

/** When Aim Fire and Idle are the same, then only Idle will be triggered for both */
var()	bool	bMergeAimFiringIntoIdle;
/** When Aim Idle and Idle Ready are the same, then only Idle Ready will be triggered for both */
var()	bool	bMergeAimIdleIntoIdleReady;
/** When Aim and Downsights poses are the same, then only Aim will be triggered for both */
var()	bool	bMergeDownSightsIntoAim;
/** When Downsights Fire and Idle are the same, then only Idle will be triggered for both */
var()	bool	bMergeDownSightsFireIntoIdle;

/** Blend Time from Aim to Idle */
var()	float	Aim2IdleBlendOutTime;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


