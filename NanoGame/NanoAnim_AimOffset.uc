
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAnim_AimOffset extends AnimNodeAimOffset
	native(Anim);

/** Internal cached pointer to NanoPawn Owner */
var		const transient NanoPawn				NanoPawnOwner;
/** TRUE if this is a rear facing aim node */
var()   const bool      bRearAim;

var()	Vector2d		DesiredAim;
var()   float           AimInterpSpeed;



/** Internal cached pointer to MirrorMaster node */
//var		const transient NanoAnim_Mirror_Master	MirrorNode;

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
	/** Special value used for position (height) adjustment */
	AI_PawnPositionAdjust,
	/** Use the VehicleAimOffset in NanoVehicle for aiming */
	AI_VehicleAimOffset,
	/** Use Base to retrieve aiming information */
	AI_BasePawn,
	/** Use Custom Aim Offset - override GetCustomAimOffset function in the NanoPawn*/
	AI_CustomAimOffset, 
};

/** What we are using as our Aim input. */
var()	EAimInput	AimInput;

cpptext
{
	virtual void		InitAnim(USkeletalMeshComponent* MeshComp, UAnimNodeBlendBase* Parent);
	/** Pull aim information from Pawn */
	virtual FVector2D	GetAim() ;
	virtual void		PostAimProcessing(FVector2D &AimOffsetPct);
	/** Parent node is requesting a blend out. Give node a chance to delay that. */
	virtual UBOOL		CanBlendOutFrom();
	/** parent node is requesting a blend in. Give node a chance to delay that. */
	virtual UBOOL		CanBlendTo();

	// AnimNode interface
	virtual	void TickAnim(FLOAT DeltaSeconds);
}

defaultproperties
{
	TurnAroundBlendTime=0.42f
	ReloadingBlendTime=0.33f
	AimInput=AI_PawnAimOffset

	AimInterpSpeed=12
}