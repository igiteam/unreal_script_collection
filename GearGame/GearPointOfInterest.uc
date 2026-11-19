/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPointOfInterest extends KeyPoint
	config(Game)
	native
	nativereplication;


/************************************************************************/
/* Constants, Enums, Structs, etc.										*/
/************************************************************************/

/** Preset priority values for POIs */
var const int POIPriority_ScriptedEvent;
var const int POIPriority_RevivableComrade;
var const int POIPriority_MoveOrder;
var const int POIPriority_TargetOrder;
var const int POIPriority_ComradeHuman;
var const int POIPriority_Comrade;
var const int POIPriority_Pickup;

/** Enum of the different ForceLook types */
enum EPOIForceLookType
{
	ePOIFORCELOOK_None,
	ePOIFORCELOOK_Automatic,
	ePOIFORCELOOK_PlayerInduced,
};

/** action info associated with looking at a focus point, and the timer that goes with it. */
var const ActionInfo ActionLookAt;

/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** -------Begin list of variables that are copied from the SeqAct_ManagePOI------- */

/** The name of the lookup variable for finding the localized text in the [POIS] section of the POI.int file */
var string DisplayName;

/** Whether the POI is enabled or not (on, off) */
var repnotify bool bEnabled;

/** The length of time the Y-Look icon will show on the screen when this POI is enabled */
var config float IconDuration;

/** Whether this POI will force the player to look at it or not */
var EPOIForceLookType ForceLookType;

/** The length of time the ForceLook will happen, if ForceLookType is set */
var float ForceLookDuration;

/** Whether of not a line of sight check should occur when doing a ForceLook, if ForceLookType is set */
var bool bForceLookCheckLineOfSight;

/** All POIs have a priority, and this is the LD's way of overriding that priority (should only be used when absolutely necessary) */
var config int LookAtPriority;

/** Field of view to zoom to when the player looks at the POI */
var config float DesiredFOV;

/** The number of times the POI will perform the POI_DesiredFOV zoom when the player looks at it - 0 means infinite */
var int FOVCount;

/** Whether or not to do a line of sight check when performing the POI_DesiredFOV zoom when the player looks at the POI */
var config bool bDoTraceForFOV;

/** Whether or not this POI should force all other active scripted POIs to disable themselves */
var bool bDisableOtherPOIs;

/** The length of time this POI will remain enabled - the POI will auto disable afterward */
var config float EnableDuration;

var bool bLeavePlayerFacingPOI;

var float DisableMovementDuration;

/** -------End list of variables that are copied from the SeqAct_ManagePOI------- */


/** The current duration left on the icon */
var float CurrIconDuration;

/** The actor this POI is attached to */
var repnotify Actor AttachedToActor;

/** Whether this POI is initialized or not */
var protected bool bIsInitialized;

/** The potential kismet action that could be referencing this POI */
var SeqAct_ManagePOI POIAction;

/** The desired priority of this POI for displaying the "look at me" icon for the action icon section of the HUD */
var EActionType ActionIconType;

/** How many times we've been looked at */
var transient int LookAtCount;

/** If true, force a head look as well as a camera look */
var() bool bAffectHead;
/** If true, only the instigator of the "POI Manager" action will view this POI */
var() bool bInstigatorOnly;
/** GearPC that instigated this POI */
var repnotify GearPC InstigatorPC;


/************************************************************************/
/* C++ functions                                                        */
/************************************************************************/
cpptext
{
	// Networking
	INT* GetOptimizedRepList( BYTE* InDefault, FPropertyRetirement* Retire, INT* Ptr, UPackageMap* Map, UActorChannel* Channel );
}


/************************************************************************/
/* Replication block                                                    */
/************************************************************************/

replication
{
	if (bNetDirty)
		bEnabled, AttachedToActor, IconDuration, DisplayName, ForceLookType, DesiredFOV, FOVCount,
		bDoTraceForFOV, ForceLookDuration, LookAtPriority, bForceLookCheckLineOfSight, bLeavePlayerFacingPOI, bInstigatorOnly, InstigatorPC;
}

/** replicated event */
simulated event ReplicatedEvent( name VarName )
{
	switch( VarName )
	{
		case 'AttachedToActor':
			InitializePOI();
			break;
		case 'bEnabled':
			if (bEnabled)
			{
				EnablePOI();
			}
			else
			{
				DisablePOI();
			}
			break;
		case 'InstigatorPC':
			if (bEnabled)
			{
				EnablePOI();
			}
			break;
		default:
			break;
	}
}


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

simulated event SetEnabled( bool bOn )
{
	local bool OldbEnabled;

	// Store old value
	OldbEnabled = bEnabled;

	// Set the flag
	if ( bOn )
	{
		bEnabled = TRUE;
	}
	else
	{
		bEnabled = FALSE;
	}

	// If flag is a new value force the net to update
	if ( OldbEnabled != bEnabled )
	{
		bForceNetUpdate = TRUE;
	}

	// Call the appropriate function
	if ( bEnabled )
	{
		EnablePOI();
	}
	else
	{
		DisablePOI();
	}
}

/** Whether the controller should add/remove this POI */
simulated function bool ShouldControllerHavePOI(GearPC GearPCToTest)
{
	local vector CameraLoc;
	local rotator CameraRot;

	// No POIs during deployment phase of Horde
	if (GearGRI_Horde(WorldInfo.GRI) != None && GearGRI_Horde(WorldInfo.GRI).bCanPlaceFortifications)
	{
		return false;
	}
	// If we're limiting the valid GearPCs to use this POI, check if GearPCToTest is one of them
	else if( bInstigatorOnly && InstigatorPC != GearPCToTest )
	{
		return false;
	}
	else if (!bForceLookCheckLineOfSight)
	{
		return true;
	}
	else
	{
		// trace check LOS
		GearPCToTest.GetPlayerViewPoint(CameraLoc, CameraRot);
		return FastTrace(Location, CameraLoc);
	}
}

simulated function EnablePOI()
{
	local GearPC LPC;

	if (Role == ROLE_Authority)
	{
		// Set the duration timer
		if ( EnableDuration > 0 )
		{
			SetTimer( EnableDuration, false, nameof(DisablePOI) );
		}
	}

	CurrIconDuration = IconDuration;

	foreach LocalPlayerControllers(class'GearPC', LPC)
	{
		if ( ShouldControllerHavePOI(LPC) )
		{
			LPC.AddPointOfInterest(self);
		}
	}
}

simulated function DisablePOI()
{
	local GearPC LPC;

	// Clear the timer if and set variables if needed
	if ( Role == ROLE_Authority )
	{
		if ( IsTimerActive('DisablePOI') )
		{
			ClearTimer( 'DisablePOI' );
		}

		bEnabled = FALSE;
		bForceNetUpdate = TRUE;

		if ( POIAction != None )
		{
			POIAction.bIsDone = TRUE;
		}
	}

	InstigatorPC = None;
	foreach LocalPlayerControllers(class'GearPC', LPC)
	{
		LPC.RemovePointOfInterest(self, ForceLookType);
	}
}

/** Internal. */
simulated protected function AttachToActor( Actor Host )
{
	AttachedToActor = Host;
	bForceNetUpdate = TRUE;

	if ( AttachedToActor != None )
	{
		if ( AttachedToActor.IsA('GearDroppedPickup') || AttachedToActor.IsA('GearPickupFactory') || AttachedToActor.IsA('GearPawn') )
		{
			SetBase( AttachedToActor );
		}
	}
}

/*
 * Get the priority value for force looks... -1 is returned if no priority could be found.
 */
simulated function int GetLookAtPriority( GearPC PC )
{
	if ( (PC != None) && (AttachedToActor != None) )
	{
		if ( AttachedToActor.IsA('GearDroppedPickup') || AttachedToActor.IsA('GearPickupFactory') )
		{
			if ( VSizeSq(Location - PC.Pawn.Location) > 262144 )
			{
				return -1;
			}
		}
		else if ( AttachedToActor.IsA('GearPawn') )
		{
			return GearPawn(AttachedToActor).GetLookAtPriority( PC, -1 );
		}
	}

	return LookAtPriority;
}

simulated function InitializePOI()
{
	if (!bIsInitialized)
	{
		if (AttachedToActor != None)
		{
			if ( AttachedToActor.IsA('GearDroppedPickup') )
			{
				CurrIconDuration = 0.f;
				IconDuration = 0.f;
				DisplayName = GearDroppedPickup(AttachedToActor).GetDisplayName();
				LookAtPriority = POIPriority_Pickup;
			}
			else if ( AttachedToActor.IsA('GearPickupFactory') )
			{
				CurrIconDuration = 0.f;
				IconDuration = 0.f;
				DisplayName = GearPickupFactory(AttachedToActor).GetDisplayName();
				LookAtPriority = POIPriority_Pickup;
			}
			else if ( AttachedToActor.IsA('GearPawn') )
			{
				if (GearPawn(AttachedToActor).PlayerReplicationInfo == None)
				{
					// try again in a little bit
					SetTimer( 0.5f,FALSE,nameof(InitializePOI) );
				}
			}
		}

		if (bEnabled)
		{
			EnablePOI();
		}

		bIsInitialized = TRUE;
	}
}

simulated event PostBeginPlay()
{
	CurrIconDuration = IconDuration;
	if ( Role == ROLE_Authority )
	{
		if (Base != None)
		{
			// already attached to something, just record that
			AttachedToActor = Base;
		}
		else
		{
			AttachToActor( Owner );
		}
		bForceNetUpdate = TRUE;

		InitializePOI();
	}
}

/**
*	If LDs put text into the POI themselves we must retrieve that text from the localization system.
*/
native simulated function String RetrievePOIString( String TagName );

simulated function String GetDisplayName()
{
	local String DisplayText;

	// if the displayname is empty, see if we need to display the text based on what the POI is attached to
	if ( len(DisplayName) <= 0 )
	{
		if ( AttachedToActor != None )
		{
			if ( AttachedToActor.IsA('GearDroppedPickup') )
			{
				DisplayText = GearDroppedPickup(AttachedToActor).GetDisplayName();
			}
			else if ( AttachedToActor.IsA('GearPickupFactory') )
			{
				DisplayText = GearPickupFactory(AttachedToActor).GetDisplayName();
			}
			else if ( AttachedToActor.IsA('GearPawn') )
			{
				DisplayText = GearPawn(AttachedToActor).PlayerReplicationInfo.PlayerName;
			}
		}
	}
	// if the displayname is not empty it is a tagname into the localization file, so let's retrieve the string
	else
	{
		DisplayText = RetrievePOIString( DisplayName );
	}

	return DisplayText;
}


simulated function Destroyed()
{
	DisablePOI();
}


/** Returns the FOV this POI desires while being looked at.  Returns <= 0 if it doesn't care. */
final simulated function float GetDesiredFOV(vector CameraLoc)
{
	if ( (FOVCount >= 0) && (DesiredFOV >= 0) )
	{
		// see if we should do a FOV change
		if ( !bDoTraceForFOV || FastTrace(Location, CameraLoc) )
		{
			return DesiredFOV;
		}
	}

	return 0.f;
}

/** Returns the actual world-space position to look at for this POI. */
final simulated function vector GetActualLookatLocation()
{
	local vector FocusLocation;
	local SkeletalMeshComponent ComponentIt;
	local Actor LookatActor;
	local Name LookAtBoneName;
	local GearPawn WP;
	local GearLambentStalkBase Stalk;

	LookAtActor = self;
	if ( AttachedToActor != None )
	{
		WP = GearPawn(AttachedToActor);
		if ( WP != None )
		{
			LookAtBoneName = WP.NeckBoneName;
			LookAtActor = WP;
		}
		else
		{
			Stalk = GearLambentStalkBase(AttachedToActor);
			if (Stalk != None)
			{
				LookAtBoneName = Stalk.GetStalkLookAtPos();
				LookAtActor = Stalk;
			}
		}
	}

	if( LookAtBoneName != '' )
	{
		// find a skeletal mesh component on the focus actor
		foreach LookAtActor.ComponentList(class'SkeletalMeshComponent', ComponentIt)
		{
			FocusLocation = ComponentIt.GetBoneLocation(LookAtBoneName);
			break;
		}
	}
	else
	{
		FocusLocation = LookatActor.Location;
	}

	return FocusLocation;
}

defaultproperties
{
	TickGroup=TG_DuringAsyncWork

	bAlwaysRelevant=TRUE
	bReplicateMovement=TRUE
    NetUpdateFrequency=1

	bStatic=FALSE
	bMovable=TRUE
	RemoteRole=ROLE_SimulatedProxy
	bNoDelete=FALSE
	bAffectHead=TRUE

	POIPriority_ScriptedEvent=1000
	POIPriority_RevivableComrade=750
	POIPriority_TargetOrder=700
	POIPriority_MoveOrder=650
	POIPriority_ComradeHuman=-1
	POIPriority_Comrade=-1
	POIPriority_Pickup=500
	ActionIconType=AT_Scripted

	ActionLookAt={(ActionName=LookAtSomething,
				   IconAnimationSpeed=0.35f,
				   ActionIconDatas=((ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=176,V=314,UL=35,VL=64), // Y Button
												  (Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=176,V=314,UL=35,VL=64))),
									(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=293,V=270,UL=74,VL=85),
												  (Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=367,V=270,UL=74,VL=85))) ),
	)}
}
