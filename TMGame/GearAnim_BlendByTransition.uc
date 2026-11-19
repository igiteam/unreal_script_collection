
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class GearAnim_BlendByTransition extends GearAnim_BlendList
	native(TGAnim);

/** Internal cached pointer to TGPawn Owner */
var const	transient	TGPawn		TGPawnOwner;
/** If set, will bypass intro animation if previous cover action matches what is set here. */
var()	Array<ECoverAction>	PrevCoverActionBypassIntro;
/** If set, will bypass outro animation if CoverAction matches what is set here. */
var()	Array<ECoverAction>	CoverActionBypassOutro;

var()	bool	b360AimingBypassIntro;
var()	bool	b360AimingBypassOutro;

// Internal
var transient	bool	bPlayingIntro;
var	transient	bool	bPlayingOutro;
var	transient	bool	bPlayedOutro;

var()			bool	bUpdatePawnActionFiringFlag;

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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


