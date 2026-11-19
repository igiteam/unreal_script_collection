/**
 * SeqAct_ManagePOI - Action that drives a TGPointOfInterest
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ManagePOI extends SequenceAction
	Config(TGGame)
	native(TGSequence)
	dependson(TGPointOfInterest);


/************************************************************************/
/* Constants, Enums, Structs, etc.										*/
/************************************************************************/

/** Enum of the possible inputs of this action */
enum EManagePOIInputType
{
	eMPOIINPUT_On,
	eMPOIINPUT_Off,
};

/** Enum of the possible outputs of this action */
enum EManagePOIOutputType
{
	eMPOIOUTPUT_Out,
	eMPOIOUTPUT_Expired,
	eMPOIOUTPUT_LookAt,
	eMPOIOUTPUT_LookAway,
};


/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** -------Begin list of variables that mimic the properties in TGPointOfInterest------- */

/** The name of the lookup variable for finding the localized text in the [POIS] section of the TGGame.int file */
var() config string				POI_DisplayName;

/** Whether the POI is enabled or not (on, off) */
var bool						POI_bEnabled;

/** The length of time the Y-Look icon will show on the screen when this POI is enabled */
var() config float				POI_IconDuration;

/** Whether this POI will force the player to look at it or not */
var() config EPOIForceLookType	POI_ForceLookType;

/** The length of time the ForceLook will happen, if POI_ForceLookType is set - 0 is not supported */
var() config float				POI_ForceLookDuration;

/** Whether or not a line of sight check should occur when doing a ForceLook, if POI_ForceLookType is set */
var() config bool				POI_bForceLookCheckLineOfSight;

/** All POIs have a priority, and this is the LD's way of overriding that priority (should only be used when absolutely necessary) */
var() config int				POI_LookAtPriority;

/** Field of view to zoom to when the player looks at the POI */
var() config float				POI_DesiredFOV;

/** The number of times the POI will perform the POI_DesiredFOV zoom when the player looks at it - 0 means infinite */
var() config int				POI_FOVCount;

/** Whether or not to do a line of sight check when performing the POI_DesiredFOV zoom when the player looks at the POI */
var() config bool				POI_bFOVLineOfSightCheck;

/** Whether or not this POI should force all other active scripted POIs to disable themselves */
var() config bool				POI_bDisableOtherPOIs;

/** The length of time this POI will remain enabled - the POI will auto disable afterward - 0 means infinite */
var() config float				POI_EnableDuration;

/** If true, leaves player facing in the POIs direction after ending look, instead of swinging back to original facing direction. */
var() config bool				POI_bLeavePlayerFacingPOI;

/** -------End of list of variables that mimic the properties in TGPointOfInterest------- */


/** Whether this action is done or not */
var bool bIsDone;

/** The POI this action is referring to */
var TGPointOfInterest POI;

/************************************************************************/
/* C++ functions                                                        */
/************************************************************************/
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

