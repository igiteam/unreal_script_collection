
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_AimOffset extends AnimNodeAimOffset
	native(TGAnim);

/** Internal cached pointer to TGPawn Owner */
var		const transient TGPawn				TGPawnOwner;
/** Internal cached pointer to MirrorMaster node */
var		const transient GearAnim_Mirror_Master	MirrorNode;

var()	const transient	FLOAT					TurnInPlaceOffset;

/** TRUE if used by a mirror transition. Treated different regarding Aim mirroring. */
var()	bool	bIsMirrorTransition;
/** if TRUE, only update in 360 aiming in cover. */
var()	bool	bOnlyUpdateIn360Aiming;
/** Asks to look up the InteractionPawn's aim. Used by hostages. */
var()	bool	bUseInteractionPawnAim;
/** See if we want to shut down that aimoffset when reloading */
var()	bool	bTurnOffWhenReloadingWeapon;
var()	float	ReloadingBlendTime;
var		transient const bool	bDoingWeaponReloadInterp;
var		transient const float	ReloadingBlendTimeToGo;

/** Interpolation when looping around, so it doesn't look weird */
var transient const vector2d	LastAimOffset, LastPostProcessedAimOffset;
var transient const	FLOAT		TurnAroundTimeToGo;
var()	FLOAT					TurnAroundBlendTime;

enum EAimInput
{
	AI_PawnAimOffset,
	AI_BrumakLeftGun,
	AI_BrumakRightGun,
	/** Special value used for position (height) adjustment */
	AI_PawnPositionAdjust,
	/** Use the VehicleAimOffset in GearVehicle for aiming */
	AI_VehicleAimOffset,
};

/** What we are using as our Aim input. */
var()	EAimInput	AimInput;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

