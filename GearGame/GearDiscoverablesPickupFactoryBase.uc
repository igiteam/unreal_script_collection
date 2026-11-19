/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This object represents a placed discoverable in a level
 */
class GearDiscoverablesPickupFactoryBase extends GearPickupFactory
	abstract
	dependson(GearProfileSettings,HeadTrackTargetSpawnable)
	showcategories(Display)
	native;

/** Enum of the different methods the player will use to grab the discoverable (tied to animations) */
enum EGearDiscoverablePickupType
{
	eGDPT_Ground,
	eGDPT_Wall,
};

/** The actual discoverable this factory is handling */
var() EGearDiscoverableType	DISC_DiscoverableType;

/** The type of method the player will use to grab the discoverable (tied to animations) */
var() EGearDiscoverablePickupType DISC_PickupType;

/** Sound to play when discoverable is picked up */
var() SoundCue DISC_PickupSound;

/** The mesh that will be rendered to represent this discoverable */
var() editconst StaticMeshComponent DISC_MeshComponent;

/** The background texture to display when this discoverable is picked up */
var() Texture2D DISC_BackgroundTexture;

/** The spawned head tracking target if created */
var transient HeadTrackTargetSpawnable HeadTrackTarget;

/** The radius to provide hints for */
var() protected const float GUDSHintRadius;

/** Who should turn their head to look at the collectible */
var() const EHeadTrackPawnFilter LookAtPawnFilter;

simulated function bool CanPickUpAmmoType(Pawn P, class<GearAmmoType> AmmoTypeClass, bool bExcludeChecks)
{
	return false;
}

function bool PickUpAmmoFromWeaponClass(Pawn P, class<GearWeapon> WeaponClass, optional int ExtraAmmo)
{
	return false;
}

/**
 * Spawns a head track target if requested
 */
simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if (GUDSHintRadius > 0.f)
	{
		HeadTrackTarget = Spawn(class'HeadTrackTargetSpawnable', self);
		if (HeadTrackTarget != None)
		{
			HeadTrackTarget.SetBase(self);
			HeadTrackTarget.SetHardAttach(true);
			HeadTrackTarget.SetRelativeLocation(PickupMesh.Translation);
			HeadTrackTarget.PawnFilter = LookAtPawnFilter;
			HeadTrackTarget.Radius = GUDSHintRadius;
		}
	}
}


simulated function InitializePickup()
{
	SetPickupMesh();
}

simulated function SetPickupMesh()
{
	if ( DISC_MeshComponent != None )
	{
		if ( bPickupHidden )
		{
			SetPickupHidden();
		}
		else
		{
			SetPickupVisible();
		}
	}
}

/** Overloaded so we can determine whether or not to show this discoverable or not */
simulated event SetInitialState()
{
	// note: not calling super function here on purpose, so this needs to be here
	bScriptInitialized = TRUE;

	if ( DISC_DiscoverableType != InvalidDiscoverable )
	{
		CheckForDiscoverableVisibility();
	}
	// LD didn't set the DiscoverableType
	else
	{
		`log("Discoverable"@self@"does not have DISC_DiscoverableType set properly!");
	}
}


//No display name, should be hidden
simulated function String GetDisplayName()
{
	return "";
}

/** Loops through local player controllers seeing if we should show the discoverable or not */
simulated function CheckForDiscoverableVisibility()
{
	local GearPC_SP APlayer;
	local bool bNeedDiscoverable, bFoundControllers;

	// search for any local players that need the discoverable
	ForEach LocalPlayerControllers(class'GearPC_SP', APlayer)
	{
		bFoundControllers = true;
		bNeedDiscoverable = (bNeedDiscoverable || !APlayer.HasFoundDiscoverable( DISC_DiscoverableType ));
	}

	// Enable/disable headtracking based upon players needing it
	if (HeadTrackTarget != None)
	{
		HeadTrackTarget.bEnabled = bNeedDiscoverable || !bFoundControllers;
	}

	SetVisible( bNeedDiscoverable || !bFoundControllers );
}

/** Toggles, locally, discoverable visibility */
simulated function SetVisible(bool bNewVisible)
{
	if ( bNewVisible )
	{
		GotoState('Auto');
	}
	else
	{
		GotoState('disabled');
	}
}

/** See if we can do something with this discoverable pickup */
simulated function Name FindInteractionWith(Pawn P, bool bExcludeChecks)
{
	// using neither 'Pickup' || 'SwapWithCurrent'  will cause GearSpecialMove's SpecialMoveStarted to play BS_Pickup
	return 'Grab';
}

/** Give pickup to player */
simulated function GiveTo(Pawn P)
{
	local GearPC_SP GPC;

	if ( DISC_DiscoverableType != InvalidDiscoverable )
	{
		GPC = GearPC_SP(P.Controller);
		if ( GPC != None )
		{
			// Tell PC that it is to pick up a discoverable
			GPC.PickedUpDiscoverable( self );
		}
	}
	else
	{
		P.ClientMessage("Discoverable"@self@"does not have DISC_DiscoverableType set properly!");
	}
}

/** No respawning */
simulated function SetRespawn()
{
}

/** Sets a timer to tell the discoverable to check for visibility */
simulated function HideDiscoverableAfterDelay( float TimeDelay )
{
	SetTimer( TimeDelay, false, nameof(HideDiscoverable) );
}

/** Tell the discoverable hide */
simulated function HideDiscoverable()
{
	SetVisible( false );
}

/** PICKUP STATE */
auto simulated state Pickup
{
	simulated event BeginState(name PreviousStateName)
	{
		SetHidden(false);
		SetCollision(default.bCollideActors, default.bBlockActors);
		Super.BeginState(PreviousStateName);
	}
};

/** DISABLED STATE */
simulated state Disabled
{
	simulated function BeginState(Name PreviousStateName)
	{
		SetHidden(true);
		SetCollision(false, false);
		super.BeginState(PreviousStateName);
	}
}

/** Set the nav logging type */
simulated event string GetDebugAbbrev()
{
	return "DISC";
}

defaultproperties
{
	GUDSHintRadius=256
	LookAtPawnFilter=HT_PlayerTeamOnly
	DISC_PickupSound=SoundCue'Music_Stingers.Stingers_G2.G2Stinger_CrimsonOmen01Cue'
}
