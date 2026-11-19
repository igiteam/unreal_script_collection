/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeaponPickupFactory extends GearPickupFactory
	implements(Interface_AIMoveFailed)
	native;


var() RepNotify class<GearWeapon>	WeaponPickupClass;
/** Keep track of which mesh was set, to not create it twice. */
var				class<Actor>		CachedMeshActorClass;

/** When using a non-gearweapon (shield) this is a reference to that class */
var class<Inventory> PlaceholderClass;

var const		ActionInfo			CantPickupAction;

var() const array< class<Inventory> > MPWeaponPickupList;

/** Whether to exclude this spawner for Annex gameplay */
var() bool bMP_ExcludeAnnex;
/** Whether to exclude this spawner for KOTH gameplay */
var() bool bMP_ExcludeKOTH;
/** Whether to exclude this spawner for Meatflag gameplay */
var() bool bMP_ExcludeMeatflag;

/** Whether to not draw on the overhead map */
var() bool bSkipOverheadmapDisplay;

var() int ExtraAmmoCount;

/** extra translation to apply to the visual mesh, for when the pickup is on uneven terrain and such
 * since moving the nav point itself could break the AI
 */
var() vector MeshTranslation;

/** Mesh used for rendering in taccom */
var transient protected PrimitiveComponent TaccomMesh;

/** The material to use for the taccom preview */
var protected Material TaccomViewMaterial;

/** linked factory. stays constant after initial link. */
var transient GearWeaponPickupFactory CoopWeaponCounterpartFactory;

var transient CoopMGSyncActor CoopWeaponSyncActor;

/** Sprite displayed during taccom viewing */
var transient SpriteComponent TaccomSprite;

/** translucent copy of the mesh showed to indicate pickups requiring purchase in Horde */
var MeshComponent PurchaseGlow;
/** different HUD action indicator for pickups requiring Horde purchase */
var ActionInfo PickupActionRequiresPurchase;
/** text added to icon to indicate cost */
var localized string CostTooltip;

/** Allow pickups that normally require purchase to be free e.g. coop machine gun counterpart after one part is bought */
var transient repnotify bool bPurchaseExempt;

/** var that keeps track of the last time an AI failed to pathfind to me */
var transient float LastPathFailTime;

/** cached position to path to if pathing direction to this factory does not succeed */
var transient vector CachedFallbackPathPos;

cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	/** Make sure that invalid choices are weeded out */
#if WITH_EDITOR
	virtual void CheckForErrors();
#endif

	/** returns the position the AI should move toward to reach this actor */
	FVector GetDestination(AController* C);

}

replication
{
	if (bNetDirty)
		WeaponPickupClass, PlaceholderClass;

	if (bNetDirty && Role == ROLE_Authority)
		CoopWeaponSyncActor, bPurchaseExempt;
}

/*
 * BEGIN Interface: Interface_AIMoveFailed
 */
/**
 * allows objects to handle situations where an AI fails to path to it
 * @param FailingAI - the ai that failed to path to this object
 */
function AIFailedToPathToMe(GearAI FailingAI)
{
	LastPathFailTime = WorldInfo.TimeSeconds;
}
/**
 * function used to early out of pathing to an enemy if someone has failed to do so recently
 * @param AskingAI - the ai who wants to know if we should early out
 * @return TRUE if path has failed recently 
 */
// if someone has been unable to path to us recently, tell them to try another pickup
function bool HasPathFailedRecently(GearAI AskingAI)
{
	return `TimeSince(LastPathFailTime) < 2.0;
}
// END interface	

simulated event ReplicatedEvent(name VarName)
{
	if ( VarName == 'WeaponPickupClass' )
	{
		PickupClassChanged();
		if (WeaponPickupClass != None && IsInState('Disabled'))
		{
			GotoState('Auto');
		}
	}
	else if (VarName == 'bPurchaseExempt')
	{
		CheckPurchaseGlow();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

/** Internal. */
protected function TriggerPickupGUDS(GearPawn GP, GearWeapon NewWeap)
{
	// LDs are placing these on dead COG bodies so the celebratory GUDs are inappropriate
	// We'll have to add a flag if we want this back.
	if (!WorldInfo.Game.IsA('GearGameSP_Base'))
	{
		if (GearWeap_GrenadeBase(NewWeap) != None)
		{
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_PickedUpGrenades, GP, None);
		}
		else
		{
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_PickedUpNewWeapon, GP, None);
		}
	}
}

simulated function PreBeginPlay()
{
	PickupClassChanged();

	Super.PreBeginPlay();
}

simulated function PostBeginPlay()
{
	VerifyCoopWeaponSync();

	Super.PostBeginPlay();
}

/**
 * All the coop machine gun pickup factory stuff should happen here
 * Need to make sure that it's set up every round and resilient to pickup class changes
 */
simulated function VerifyCoopWeaponSync()
{
	local class<Actor> CoopCounterpartClass;
	local GearWeaponPickupFactory PF;

	if (Role == ROLE_Authority)
	{
		if (class<GearWeap_HeavyCoopMGBase>(WeaponPickupClass) != None)
		{
			if (CoopWeaponCounterpartFactory == None)
			{
				CoopCounterpartClass = WeaponPickupClass.default.CoopCounterpartClass;
				if (CoopCounterpartClass != None)
				{
					// look for nearby pickups of the same class
					foreach CollidingActors(class'GearWeaponPickupFactory', PF, 512.f)
					{
						// @fixme, come up with a less hacky way of pairing these guys
						if (PF.WeaponPickupClass == CoopCounterpartClass && PF.CoopWeaponCounterpartFactory == None && PF.CoopWeaponSyncActor == None )
						{
							// link them up!
							CoopWeaponCounterpartFactory = PF;
							PF.CoopWeaponCounterpartFactory = self;

							break;
						}
					}
				}
			}

			if (CoopWeaponCounterpartFactory != None && CoopWeaponSyncActor == None)
			{
				if (CoopWeaponCounterpartFactory.CoopWeaponSyncActor == None)
				{
					// Our sync actor may have been deleted, probably due to a pickup class change
					CoopWeaponSyncActor = Spawn(WeaponPickupClass.default.CoopSyncActorClass);
					if (CoopWeaponSyncActor != None)
					{
						CoopWeaponSyncActor.LinkCoopWeapons(self, CoopWeaponCounterpartFactory);
					}

					// We're waiting to respawn, make the coop factory wait as well
					if (IsInState('Sleeping'))
					{
						CoopWeaponCounterpartFactory.SetRespawn();
					}
				}
				else
				{
					// A player is probably holding a copy of this weapon and the counterpart is still in pickup form
					SetRespawn();
				}
			}

			// If the coop factory is sleeping and we are not, wake them up.
			// Wingman in particular can have a sleeping mg ammo box if the respawn happens out of sync with this gun
			if (!IsInState('Sleeping') && (CoopWeaponCounterpartFactory.IsInState('Disabled') || CoopWeaponCounterpartFactory.IsInState('Sleeping')))
			{
				CoopWeaponCounterpartFactory.Reset();
			}
		}
		else if (class<GearWeap_HeavyCoopMGAmmoBoxBase>(WeaponPickupClass) != None)
		{
			if (CoopWeaponCounterpartFactory != None && CoopWeaponSyncActor == None && CoopWeaponCounterpartFactory.CoopWeaponSyncActor != None)
			{
				// A player is probably holding a copy of this weapon and the counterpart is still in pickup form
				SetRespawn();
			}
		}
		else if (CoopWeaponSyncActor != None)
		{
			// We have a stale sync actor
			CoopWeaponSyncActor.UnlinkAllAndDestroy();
			CoopWeaponSyncActor = None;
		}
	}
}

simulated function PickupClassChanged()
{
	InventoryType = WeaponPickupClass;
	bPurchaseExempt = FALSE;
	if (Role == ROLE_Authority)
	{
		// None is the class default so we have to force it to replicate if we change to that due to weapon swapping
		SetForcedInitialReplicatedProperty(Property'GearGame.GearWeaponPickupFactory.WeaponPickupClass', WeaponPickupClass == default.WeaponPickupClass);
	}
	SetPickupMesh();
	VerifyCoopWeaponSync();
}

/** Overridden to use DroppedPickupMesh instead of PickupFactoryMesh */
simulated function SetPickupMesh()
{
	local PrimitiveComponent	InvPickupMesh;
	local SkeletalMeshComponent	SkelMeshComp;
	local class<Actor>			MeshActorClass;

	if( InventoryType == None )
	{
		if( PickupMesh != None || CachedMeshActorClass != None )
		{
			// clear pickup mesh.
			DetachComponent(PickupMesh);
			PickupMesh = None;
			CachedMeshActorClass = None;
		}
	}
	else
	{
		if( WeaponPickupClass != None )
		{
			InvPickupMesh = WeaponPickupClass.static.GetPickupMesh(self);
			MeshActorClass = WeaponPickupClass;
		}

		if( InvPickupMesh == None )
		{
			InvPickupMesh = InventoryType.default.DroppedPickupMesh;
			MeshActorClass = InventoryType;
		}

		// If mesh needs to be updated, do it!
		if( InvPickupMesh != None && (PickupMesh == None || MeshActorClass != CachedMeshActorClass) )
		{
			if( PickupMesh != None )
			{
				DetachComponent(PickupMesh);
				PickupMesh = None;
			}

			PickupMesh = new(self) InvPickupMesh.Class(InvPickupMesh);
			PickupMesh.SetLightEnvironment( MyLightEnvironment );
			PickupMesh.SetHidden(bPickupHidden);
			PickupMesh.SetTranslation(InvPickupMesh.Translation + MeshTranslation);
			PickupMesh.bAllowAmbientOcclusion = true;
			AttachComponent(PickupMesh);
			CachedMeshActorClass = MeshActorClass;

			SkelMeshComp = SkeletalMeshComponent(PickupMesh);
			if( SkelMeshComp != None )
			{
				// Disable animations on pickups, they don't need those.
				SkelMeshComp.SetAnimTreeTemplate(None);
				SkelMeshComp.bForceRefpose = 1;
				SkelMeshComp.bUpdateSkelWhenNotRendered = FALSE;
			}

			// this component is destroyed when picked up so we don't need to worry about changing
			// the emissive color back to the default
			CreateAndSetMICWeaponSkin(MeshComponent(PickupMesh));
			// all weapons should have the EmissiveCOG as their colors

			AlignCollisionCylinder();
		}
	}

	// Create the taccom component for viewing in taccom
	//CreateTaccomMesh();
	InitializeTaccomSprite();

	CheckPurchaseGlow();
}

/** decides if we need to display the purchase glow for Horde and if so initializes it */
simulated final function CheckPurchaseGlow()
{
	local int i;

	if (PurchaseGlow != None)
	{
		DetachComponent(PurchaseGlow);
		PurchaseGlow = None;
	}
	if (PickupMesh != None && RequiresPurchase())
	{
		PurchaseGlow = MeshComponent(new(self) PickupMesh.Class(PickupMesh));
		PurchaseGlow.SetScale(1.05 * PickupMesh.Scale);
		PurchaseGlow.SetCullDistance(1000.0);
		for (i = 0; i < PurchaseGlow.GetNumElements(); i++)
		{
			PurchaseGlow.SetMaterial(i, MaterialInstanceConstant'Effects_Gameplay.Horde.MI_GameplayObject_Horde_Blue');
		}
		AttachComponent(PurchaseGlow);
	}
}

/**
 *  Sets the taccom sprite to the appropriate picture for the weapon type
 */
simulated function InitializeTaccomSprite()
{
	local CanvasIcon Icon;
	local GearGRI GRI;
	local class<GearShield> ShieldClass;
	local bool bFoundIcon;

	bFoundIcon = false;

	GRI = GearGRI(WorldInfo.GRI);

	// The GRI is not valid on clients until it is replicated, just check back in a bit
	if (GRI == None || GRI.GameClass == None)
	{
		SetTimer(0.2f, FALSE, nameof(InitializeTaccomSprite));
		return;
	}

	if (class<GearGame>(GRI.GameClass).default.bShouldDisplayWeaponPickupsViaTaccom && TaccomSprite != None)
	{
		if (WeaponPickupClass != none)
		{
			Icon = WeaponPickupClass.default.WeaponIcon;
			bFoundIcon = true;
		}
		else if (PlaceholderClass != none)
		{
			ShieldClass = class<GearShield>(PlaceholderClass);
			if (ShieldClass != None)
			{
				Icon = ShieldClass.default.PickupIcon;
				bFoundIcon = true;
			}
		}
		if (bFoundIcon)
		{
			TaccomSprite.SetSpriteAndUV(Texture2D(Icon.Texture), Icon.U, Icon.UL, Icon.V, Icon.VL);
			TaccomSprite.SetDepthPriorityGroup(SDPG_Foreground);
			// This will be unhidden in AGearPC::UpdateHiddenComponents when in taccom mode
			TaccomSprite.SetHidden(true);
			if (!TaccomSprite.bAttached)
			{
				AttachComponent(TaccomSprite);
			}
		}
		else
		{
			// Remove a stale sprite if there's nothing at this pickup factory anymore
			if (TaccomSprite.bAttached)
			{
				DetachComponent(TaccomSprite);
			}
		}
	}
}

/**
 * Clones the pickup mesh, changes the materials for it, and changes the DPG
 */
simulated function CreateTaccomMesh()
{
	local int MaterialIndex;
	local MeshComponent	MeshComp;
	local PrimitiveComponent PickupMeshComp;
	local GearGRI GRI;

	GRI = GearGRI(WorldInfo.GRI);

	// The GRI is not valid on clients until it is replicated, just check back in a bit
	if (GRI == None || GRI.GameClass == None)
	{
		SetTimer(0.2f, FALSE, nameof(CreateTaccomMesh));
		return;
	}

	if (class<GearGame>(GRI.GameClass).default.bShouldDisplayWeaponPickupsViaTaccom)
	{
		if (TaccomMesh != None)
		{
			TaccomMesh.SetHidden(true);
			DetachComponent(TaccomMesh);
			TaccomMesh = None;
		}

		if (WeaponPickupClass != None)
		{
			PickupMeshComp = PickupMesh;
		}
		else if (PlaceholderClass != None)
		{
			PickupMeshComp = PlaceholderClass.default.DroppedPickupMesh;
		}

		if (PickupMeshComp != None)
		{
			// Clone the pickup mesh and set the material and DPG
			TaccomMesh = new(Self) PickupMeshComp.Class(PickupMeshComp);
			MeshComp = MeshComponent(TaccomMesh);
			if (MeshComp != None)
			{
				for (MaterialIndex = 0; MaterialIndex < MeshComp.GetNumElements(); MaterialIndex++)
				{
					MeshComp.SetMaterial(MaterialIndex,TaccomViewMaterial);
				}
			}
			TaccomMesh.SetDepthPriorityGroup(SDPG_Foreground);
			// This will be unhidden in AGearPC::UpdateHiddenComponents when in taccom mode
			TaccomMesh.SetHidden(TRUE);
			AttachComponent(TaccomMesh);
		}
	}
}

simulated function SetPickupHidden()
{
	Super.SetPickupHidden();

	if (CoopWeaponSyncActor != None)
	{
		CoopWeaponSyncActor.SetHidden(TRUE);
	}

	if (PurchaseGlow != None)
	{
		PurchaseGlow.SetHidden(true);
	}
}

simulated function SetPickupVisible()
{
	Super.SetPickupVisible();

	if (CoopWeaponSyncActor != None)
	{
		CoopWeaponSyncActor.SetHidden(FALSE);
	}

	if (PurchaseGlow != None)
	{
		PurchaseGlow.SetHidden(false);
	}
}

simulated function bool ValidTouch(Pawn Other);

auto state Pickup
{
	function BeginState(name PreviousStateName)
	{
		if (bPurchaseExempt)
		{
			bPurchaseExempt = FALSE;
			CheckPurchaseGlow();
		}

		// on spawn/respawn, reconnect to our partner factory
		// @fixme, sync up respawning with partner factory.
		// i.e. don't repspawn either until both are ready, then respawn both at once

		VerifyCoopWeaponSync();

		super.BeginState(PreviousStateName);
	}

	/**
	* Validate touch (if valid return true to let other pick me up and trigger event).
	* Overridden to support GearPawn.bCanPickupFactoryWeapons.
	*/
	simulated function bool ValidTouch(Pawn Other)
	{
		local GearHUD_Base WHUD;
		if ( (GearPawn(Other) != None) && !GearPawn(Other).bCanPickupFactoryWeapons )
		{
			if ( PlayerController(Other.Controller) != None )
			{
				WHUD = GearHUD_Base(PlayerController(Other.Controller).MyHUD);
				if ( WHUD != None )
					WHUD.WeaponFactoryPickupFailed();
			}
			return false;
		}

		return Super.ValidTouch(Other);
	}

	event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
	{
		local GearAI_TDM Bot;
		local GearPawn P;

		Super.Touch(Other, OtherComp, HitLocation, HitNormal);

		// if a bot touched me while doing something else, see if it wants to pick me up anyway
		if (InventoryType != None)
		{
			P = GearPawn(Other);
			if (P != None && P.CanDoSpecialMove(SM_WeaponPickup))
			{
				Bot = GearAI_TDM(P.Controller);
				if (Bot != None && Bot.MoveTarget != self && Bot.AllowDetourToPickUp(InventoryType))
				{
					class'AICmd_PickupWeapon'.static.PickupWeaponFromFactory(Bot, self);
				}
			}
		}
	}
}

/**
 * returns the display name of the item to be picked up
 */
simulated function String GetDisplayName()
{
	if (WeaponPickupClass != None)
	{
		return WeaponPickupClass.default.ItemName;
	}

	return GetHumanReadableName();
}

function bool CheckForErrors()
{
	if( super.CheckForErrors() )
	{
		return TRUE;
	}

	if( WeaponPickupClass == None )
	{
		`log(Self @ "no weapon pickup class");
		return TRUE;
	}

	return FALSE;
}

event Reset()
{
	Super.Reset();
	bPickupHidden = FALSE;
	bPurchaseExempt = FALSE;
	SetPickupMesh();
}

State Disabled
{
	/** Overridden to support checkpoint loading */
	function Reset()
	{
		SetPickupVisible();
		SetCollision(TRUE,FALSE);
		Global.Reset();
	}
}

simulated protected function bool IsReadyForPickup()
{
	if ( bHidden || (PickupMesh == None) || PickupMesh.HiddenGame )
	{
		return FALSE;
	}

	return TRUE;
}

/**
 * See if we can do something with this weapon pickup.
 * bExcludeChecks - TRUE = could you have?
 *                - FALSE = you actually can
 */
simulated function Name FindInteractionWith(Pawn P, bool bExcludeChecks)
{
	local GearInventoryManager InvManager;
	local GearPawn.EAttachSlot DesiredSlot;
	local GearPawn GP;

	if ( !IsReadyForPickup() )
	{
		return '';
	}

	GP = GearPawn(P);
	if (GP != None && !GP.bCanPickupFactoryWeapons)
	{
		return 'PickupLocked';
	}

	// check for Horde cash cost
	if (RequiresPurchase() && P.PlayerReplicationInfo != None && P.PlayerReplicationInfo.Score < WeaponPickupClass.default.HordeCost)
	{
		return 'PickupLocked';
	}

	InvManager = GearInventoryManager(P.InvManager);

	// if we're already carrying that same weapon
	if (InvManager.FindInventoryType(WeaponPickupClass, true) != None)
	{
		// check if we can pick up ammo from it
		if (CanPickUpAmmoType(P, WeaponPickupClass.default.AmmoTypeClass, bExcludeChecks))
		{
			return 'TakeAmmo';
		}
	}
	else
	{
		// See if we can find an available slot for this weapon
		DesiredSlot = InvManager.FindFreeSlotForInventoryClass(WeaponPickupClass);

		if( DesiredSlot != EASlot_None )
		{
			//`log( "0" );
			// we found a free slot, we can pickup weapon!
			return 'PickUp';
		}

		// if shoulder weapon then do kick up
		if( InvManager.CanSwapWeaponClassWithCurrent(WeaponPickupClass) && P.CanThrowWeapon() )
		{
			//`log( "2" );
			return 'SwapWithCurrent';
		}
		else if ( bExcludeChecks && WeaponPickupClass.default.WeaponType == WT_Normal && GearWeapon(InvManager.Instigator.Weapon).WeaponType != WT_Normal )
		{
			return 'SwapWithCurrent';
		}

		// If we want to pick up a pistol or a grenade, we can just grab and exchange it
		if( WeaponPickupClass.default.WeaponType == WT_Holster ||
			WeaponPickupClass.default.WeaponType == WT_Item )
		{
			//`log( "3" );
			return 'SwapWithAttachment';
		}

		// for heavy weapons, we pick up and hold
		if (WeaponPickupClass.default.WeaponType == WT_Heavy)
		{
			if ( (GearWeapon(P.Weapon) != None) && (GearWeapon(P.Weapon).WeaponType == WT_Heavy) )
			{
				return 'SwapCarried';
			}
			else
			{
				return 'PickUpAndCarry';
			}
		}
	}

	return '';
}

/** this function has been made obsolete by GiveTo(). */
function SpawnCopyFor( Pawn Recipient );

function PickedUpBy(Pawn P)
{
	local GearAI_TDM Bot;
	local AICmd_MoveToGoal_Mesh MoveCmd;
	local GearGRI_Horde GRI;

	Super.PickedUpBy(P);

	// interrupt any bots that were also going for this pickup as it is no longer available
	foreach WorldInfo.AllControllers(class'GearAI_TDM', Bot)
	{
		if (Bot.Pawn != None && Bot.Pawn != P && Bot.RoamGoal == self && Bot.MoveGoal == self)
		{
			MoveCmd = Bot.FindCommandOfClass(class'AICmd_MoveToGoal_Mesh');
			if (MoveCmd != None)
			{
				`AILog_Ext("Aborting move to" @ self @ "because taken by another player", 'None', Bot);
				Bot.AbortCommand(MoveCmd);
			}
		}
	}

	if (GearGameHorde_Base(WorldInfo.Game) != None && !bPurchaseExempt && WeaponPickupClass.default.HordeCost > 0 && P.PlayerReplicationInfo != None)
	{
		P.PlayerReplicationInfo.Score -= WeaponPickupClass.default.HordeCost;
		P.PlayerReplicationInfo.bForceNetUpdate = true;

		if (GearPC(P.Controller) != None)
		{
			GearPC(P.Controller).ClientModifyStat('CashSpent', WeaponPickupClass.default.HordeCost);
		}

		GRI = GearGRI_Horde(WorldInfo.GRI);
		if (GRI.bCanPlaceFortifications)
		{
			GRI.UpdateFortificationGhostImages();
		}
	}

	if (CoopWeaponCounterpartFactory != None)
	{
		CoopWeaponCounterpartFactory.bPurchaseExempt = TRUE;
		CoopWeaponCounterpartFactory.CheckPurchaseGlow();
	}
}

simulated protected function float GetWeaponTotalAmmo(GearWeapon W)
{
	return W.SpareAmmoCount + W.WeaponMagSize - W.AmmoUsedCount;
}


/**
 * Give pickup to player
 */
function GiveTo( Pawn P )
{
	local GearInventoryManager	InvManager;
	local GearWeapon				NewWeap, OtherWeapon;
	local SoundCue AmmoPickupSound;
	local GearPawn GP;
	local name Interaction;

	GP = GearPawn(P);

	InvManager	= GearInventoryManager(P.InvManager);
	Interaction = FindInteractionWith(P, false);

	switch( Interaction )
	{
		/** just take ammo from weapon */
		case 'TakeAmmo' :
			// Fill up ammo if we can. Otherwise leave weapon.
			if (PickUpAmmoFromWeaponClass(P, WeaponPickupClass, ExtraAmmoCount))
			{
				AmmoPickupSound = WeaponPickupClass.default.AmmoTypeClass.default.AmmoPickupSound;
				//DupWeap.AnnouncePickup(P);
				if (AmmoPickupSound != None)
				{
					P.PlaySound(AmmoPickupSound);
				}
				PickedUpBy(P);
				// @STATS - Record weapon pickup
				`RecordWeaponIntStat(WEAPON_PICKUP, P.Controller, WeaponPickupClass, 1);
			}
			break;

		/** throw current weapon, and pick up new one */
		case 'SwapWithCurrent' :
			//@note: intentionally not using ThrowActiveWeapon() as that would cause a SwitchToBestWeapon() we don't want
			if (P.Weapon != None)
			{
				P.TossInventory(P.Weapon);
			}

			NewWeap = GearWeapon(InvManager.CreateInventory(WeaponPickupClass));

			// fix up coop links
			if (CoopWeaponSyncActor != None)
			{
				CoopWeaponSyncActor.UpdateLink(self, NewWeap);
			}

			// Switch to new weapon
			InvManager.SetCurrentWeapon(NewWeap);

			//NewWeap.AnnouncePickup(P);
			TriggerPickupGUDS(GP, NewWeap);
			P.PlaySound( NewWeap.PickupSound );
			PickedUpBy(P);

			if (ExtraAmmoCount > 0)
			{
				NewWeap.AddAmmo(ExtraAmmoCount);
			}

			NewWeap.AddAmmoMessage(Max(GetWeaponTotalAmmo(NewWeap), 0));

			// check to see if we are an MP game
			if( GearGRI(WorldInfo.GRI).IsMultiPlayerGame() == TRUE )
			{
				GearGame(WorldInfo.Game).GearBroadcastWeaponTakenMessage( P.Controller, NewWeap.default.DamageTypeClassForUI );
			}
			// @STATS - Record weapon pickup
			`RecordWeaponIntStat(WEAPON_PICKUP, P.Controller, WeaponPickupClass, 1);
			break;

		/** Just pick up new weapon */
		case 'PickUp' :
			NewWeap = GearWeapon(InvManager.CreateInventory(WeaponPickupClass));

			// fix up coop links
			if (CoopWeaponSyncActor != None)
			{
				CoopWeaponSyncActor.UpdateLink(self, NewWeap);
			}

			TriggerPickupGUDS(GP, NewWeap);
			P.PlaySound( NewWeap.PickupSound );
			PickedUpBy(P);

			if (ExtraAmmoCount > 0)
			{
				NewWeap.AddAmmo(ExtraAmmoCount);
			}

			NewWeap.AddAmmoMessage(Max(GetWeaponTotalAmmo(NewWeap), 0));

			// check to see if we are an MP game
			if( GearGRI(WorldInfo.GRI).IsMultiPlayerGame() == TRUE )
			{
				GearGame(WorldInfo.Game).GearBroadcastWeaponTakenMessage( P.Controller, NewWeap.default.DamageTypeClassForUI );
			}

			// Switch to that new weapon only if it's not a grenade.
			if( NewWeap != None && !NewWeap.IsA('GearWeap_GrenadeBase') )
			{
				InvManager.SetCurrentWeapon(NewWeap);
			}
			// @STATS - Record weapon pickup
			`RecordWeaponIntStat(WEAPON_PICKUP, P.Controller, WeaponPickupClass, 1);
			break;

		// Take weapon and Swap it with an attachment (ie not the currently held one)
		case 'SwapWithAttachment' :

			// Toss carried weapon
			OtherWeapon = InvManager.FindWeaponOfType(WeaponPickupClass.default.WeaponType);
			//`log("OtherWeapon:" @ OtherWeapon);
			if (OtherWeapon != None)
			{
				P.TossInventory(OtherWeapon);
			}

			// Grab new one
			NewWeap = GearWeapon(InvManager.CreateInventory(WeaponPickupClass));

			// fix up coop links
			if (CoopWeaponSyncActor != None)
			{
				CoopWeaponSyncActor.UpdateLink(self, NewWeap);
			}

			//NewWeap.AnnouncePickup(P);
			TriggerPickupGUDS(GP, NewWeap);
			P.PlaySound( NewWeap.PickupSound );
			PickedUpBy(P);

			if (ExtraAmmoCount > 0)
			{
				NewWeap.AddAmmo(ExtraAmmoCount);
			}

			NewWeap.AddAmmoMessage(Max(GetWeaponTotalAmmo(NewWeap), 0));

			// check to see if we are an MP game
			if( GearGRI(WorldInfo.GRI).IsMultiPlayerGame() == TRUE )
			{
				GearGame(WorldInfo.Game).GearBroadcastWeaponTakenMessage( P.Controller, NewWeap.default.DamageTypeClassForUI );
			}

			// Switch to that new weapon only if it's not a grenade.
			if( NewWeap != None && !NewWeap.IsA('GearWeap_GrenadeBase') )
			{
				InvManager.SetCurrentWeapon(NewWeap);
			}
			// @STATS - Record weapon pickup
			`RecordWeaponIntStat(WEAPON_PICKUP, P.Controller, WeaponPickupClass, 1);
			break;


		case 'SwapCarried':
			P.ThrowActiveWeapon();
			// intentional fall-through

		/** Pick up and hold in hands. */
		case 'PickUpAndCarry':

			NewWeap = GearWeapon(InvManager.CreateInventory(WeaponPickupClass));

			// fix up coop links
			if (CoopWeaponSyncActor != None)
			{
				CoopWeaponSyncActor.UpdateLink(self, NewWeap);
			}

			P.PlaySound( NewWeap.PickupSound );
			PickedUpBy(P);

			if (ExtraAmmoCount > 0)
			{
				NewWeap.AddAmmo(ExtraAmmoCount);
			}

			NewWeap.AddAmmoMessage(Max(GetWeaponTotalAmmo(NewWeap), 0));

			// check to see if we are an MP game
			if( GearGRI(WorldInfo.GRI).IsMultiPlayerGame() == TRUE )
			{
				GearGame(WorldInfo.Game).GearBroadcastWeaponTakenMessage( P.Controller, NewWeap.default.DamageTypeClassForUI );
			}

			InvManager.SetCurrentWeapon(NewWeap);

			// @STATS - Record weapon pickup
			`RecordWeaponIntStat(WEAPON_PICKUP, P.Controller, WeaponPickupClass, 1);
			break;

		case 'PickupLocked':
			break;

		default:
			`log( "GearWeaponPickupFactory.GiveTo() has failed with: " $ FindInteractionWith(P,false) );
			ScriptTrace();
			break;
	}
}

simulated function bool GetPickupAction(out ActionInfo out_PickupAction, out Name out_Interaction,  Pawn P)
{
	if ( !IsReadyForPickup() )
	{
		return FALSE;
	}

	out_Interaction = FindInteractionWith(P,true);
	if ( out_Interaction == 'PickupLocked' )
	{
		out_PickupAction = CantPickupAction;
		out_PickupAction.ActionIconDatas[2].ActionIcons[0] = WeaponPickupClass.default.WeaponIcon;
		out_PickupAction.TooltipText = WeaponPickupClass.default.ItemName;
		if (RequiresPurchase())
		{
			out_PickupAction.TooltipText @= "-" @ CostTooltip @ WeaponPickupClass.default.HordeCost;
		}
		return TRUE;
	}
	else if( Super.GetPickupAction(out_PickupAction, out_Interaction, P) )
	{
		// figure out what icons need to swap
		out_PickupAction.ActionName = Name;

		if ( out_Interaction != '' )
		{
			// use the purchase action icon if necessary
			if (RequiresPurchase() && CanBePickedUpBy(P))
			{
				out_PickupAction.ActionIconDatas[0] = PickupActionRequiresPurchase.ActionIconDatas[0];
			}

			if ( out_Interaction != 'TakeAmmo' )
			{
				// replace the ammo icon with weapon icon
				out_PickupAction.ActionIconDatas[2].ActionIcons[0] = WeaponPickupClass.default.WeaponIcon;
			}
			out_PickupAction.TooltipText = WeaponPickupClass.default.ItemName;
			if (RequiresPurchase())
			{
				out_PickupAction.TooltipText @= "-" @ CostTooltip @ WeaponPickupClass.default.HordeCost;
			}
			return TRUE;
		}
	}
	return FALSE;
}

/**
 * Overridden to check for unique weapon classes, preventing respawn if the weapon exists somewhere else in the level.
 */
function bool DelayRespawn()
{
	local bool bUnique;
	local GearDroppedPickup DroppedPickup;
	local GearPawn Pawn;
	local GearWeapon Weapon;
	local Actor A;
	local int NumFactories;
	local GearWeaponPickupFactory Factory;
	// if this weapon pickup is unique don't respawn if one already exists
	bUnique = WeaponPickupClass.default.bUniqueSpawn;
	if (bUnique)
	{
		foreach WorldInfo.AllNavigationPoints(class'GearWeaponPickupFactory', Factory)
		{
			if (Factory.WeaponPickupClass == WeaponPickupClass && Factory.IsInState('Sleeping') && Factory.bRespawnPaused)
			{
				NumFactories++;
			}
		}
		foreach DynamicActors(class'Actor', A)
		{
			DroppedPickup = GearDroppedPickup(A);
			if (DroppedPickup != None &&
				!DroppedPickup.bHidden &&
				DroppedPickup.InventoryClass == WeaponPickupClass)
			{
				NumFactories--;
			}
			else
			{
				Pawn = GearPawn(A);
				if (Pawn != None &&
					Pawn.InvManager != None)
				{
					Weapon = GearWeapon(Pawn.InvManager.FindInventoryType(WeaponPickupClass,FALSE));
					if (Weapon != None && Weapon.HasAnyAmmo())
					{
						NumFactories--;
					}
				}
			}
		}
		return (NumFactories <= 0);
	}
	return Super.DelayRespawn();
}

simulated event string GetDebugAbbrev()
{
	return "WPF";
}

/** spawns a pickup of the PlaceholderClass; used for delayed spawn of inventory that aren't actually weapons (i.e. shields) */
final function RespawnPlaceholder()
{
	local DroppedPickup NewPickup;

	NewPickup = Spawn(PlaceholderClass.default.DroppedPickupClass,,, Location, Rotation);
	if (NewPickup != None)
	{
		NewPickup.InventoryClass = PlaceholderClass;
		NewPickup.SetPickupMesh(PlaceholderClass.default.DroppedPickupMesh);
		NewPickup.SetPhysics(PHYS_None);
	}
}

simulated protected function bool CanPickUpWhileHoldingHeavyWeapon(name Interaction)
{
	 if (Interaction == 'PickUp' && ClassIsChildOf(WeaponPickupClass, class'GearWeap_GrenadeBase'))
	 {
		 return TRUE;
	 }

	 // ok to swap from heavy to heavy
	 if (Interaction == 'SwapWithCurrent' && WeaponPickupClass.default.WeaponType == WT_Heavy)
	 {
		return TRUE;
	 }

	 return super.CanPickUpWhileHoldingHeavyWeapon(Interaction);
}

simulated function bool RequiresPurchase()
{
	return ( WorldInfo.GRI != None && ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameHorde_Base') &&
		WeaponPickupClass != None && WeaponPickupClass.default.HordeCost > 0 && !bPurchaseExempt );
}

/** This is a function to allow subclasses to return an emissive LinearColor. (e.g. some weapons need to be colored and others don't) **/
simulated function LinearColor GetEmissiveColorParam()
{
	local LinearColor LC;

	// so for all weapons EXCEPT grenades we want to not have any coloring for weapon pickups
	if( ( WeaponPickupClass != none )
		&&( ( WeaponPickupClass.default.WeaponID == WC_FragGrenade )
		     || ( WeaponPickupClass.default.WeaponID == WC_GasGrenade )
			 || ( WeaponPickupClass.default.WeaponID == WC_InkGrenade )
			 || ( WeaponPickupClass.default.WeaponID == WC_IncendiaryGrenade )
			 || ( WeaponPickupClass.default.WeaponID == WC_SmokeGrenade )
			 )
		)
	{
		LC = WeaponPickupClass.static.GetWeaponEmisColor_COG( WorldInfo, WeaponPickupClass.default.WeaponID );
		//`log( "using global EmissiveCOG " @ WeaponPickupClass.default.WeaponID @  LC.A @ LC.R @ LC.G @ LC.B );
	}

	// else we want to return a "blank' LC

	return LC;
}


simulated function Destroyed()
{
	if (CoopWeaponSyncActor != None)
	{
		CoopWeaponSyncActor.UnlinkAllAndDestroy();
	}

	super.Destroyed();
}




defaultproperties
{
	TaccomViewMaterial=Material'ALL_WeaponShaders.WeaponPickupTaccomView'

	//bStatic=FALSE
	bNoDelete=TRUE

	PickupAction={(
			 ActionName=WeaponPickupIcon,
			 FontIndex=0,
			 ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32))), // X Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=360,V=0,UL=58,VL=55))),
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=156,V=233,UL=34,VL=56)))	),
			)}
	PickupActionRequiresPurchase={(
			 ActionName=WeaponPickupIcon,
			 FontIndex=0,
			 ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=176,V=314,UL=35,VL=64))), // Y Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=360,V=0,UL=58,VL=55))),
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=156,V=233,UL=34,VL=56)))	),
			)}

	CantPickupAction={(
			 ActionName=WeaponNoPickupIcon,
			 FontIndex=0,
			 ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=411,V=342,UL=49,VL=49))), // No entry
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=360,V=0,UL=58,VL=55))),
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=156,V=233,UL=34,VL=56)))	),
			)}

	Begin Object Class=SpriteComponent Name=TSprite
		Sprite=None
		HiddenGame=false
		HiddenEditor=true
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
		ScreenSize=0.0025
		bIsScreenSizeScaled=True
		Scale=0.5
	End Object
	TaccomSprite=TSprite

}
