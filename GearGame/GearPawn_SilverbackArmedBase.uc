
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_SilverbackArmedBase extends GearPawn_SilverbackBase
	config(Pawn)
	abstract;

/** Need to replicate access to these weapons for clients that don't have the inventory manager */
var GearWeapon PrimaryWeapon, AltWeapon;

/** Bool indicating if Silverback wants to be deployed or not */
var bool    bWantsToBeDeployed;
/** Max Yaw aiming half FOV when deployed */
var config int     MaxDeployedAimAdjustYaw;
/** Coverlink for humans to take cover behind silver back*/
var CoverLink_Spawnable DeployedLink;
var() Name   LeftGunSocketName, RightGunSocketName, RightGunMuzzleSocketName, LeftGunMuzzleSocketName;

/** Set by CoverDeploy/CoverExit Special Moves to trigger animation transitions */
var bool    bAnimIsDeployed;

/** Set by CoverDeploy/CoverExit Special Moves to keep network sync */
var bool    bNetIsDeployed;

/** Whether the guns have overheated */
var protected transient bool	bOverheated;

/** The percentage the guns are along to overheating */
var float   CurrentBarrelHeat;

/** Whether we are actively cooling the guns to speed the reduction of barrel heat */
var protected bool    bActivelyCooling;

/** The time it takes to overheat the guns */
var config float   MaxFiringTimeBeforeOverheat;

/** The time it takes to overheat while running */
var config float   MaxRunningTimeBeforeOverheat;

/** The time it takes to cool the guns while holding the reload button */
var config float   CooldownTimeActiveCooling;

/** The time it takes for the guns to cool without hitting reload */
var config float   CooldownTime;

/** The waiting time before the overheated guns are usable again */
var config float   OverheatPenaltyTime;

/** Recoil nodes */
var GearSkelCtrl_IKRecoil RecoilRightArm, RecoilLeftArm;

replication
{
	// Variables the server should send ALL clients.
	if (bNetDirty)
		DeployedLink, PrimaryWeapon, AltWeapon, bNetIsDeployed;
}

/** Mount the guns immediately */
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Role == ROLE_Authority)
	{
		AddDefaultInventory();

		PrimaryWeapon = GearInventoryManager_SilverbackArmed(InvManager).PrimaryWeapon;
		AltWeapon = GearInventoryManager_SilverbackArmed(InvManager).AltFireWeapon;
	}
}

/** Actually destroy Silverback */
function DestroySilverback()
{
	CleanUpDeployment();

	Super.DestroySilverback();
}

/** Fail-safe to make sure cover is cleaned up */
simulated function Destroyed()
{
	CleanUpDeployment();

	Super.Destroyed();
}

/**
 * The weapons never switch from the Silverback, so we need to block detaching here.
 *
 * @param	OldWeapon	Old weapon held by Pawn.
 *
 * @param	NewWeapon	New weapon held by Pawn.
 */
simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon)
{
	MyGearWeapon = GearWeapon(NewWeapon);
}

simulated function DoDriverAttachment(GearPawn InDriver)
{
	Super.DoDriverAttachment(InDriver);

	// The weapon system doesn't expect weapons to change owners without reactivation, so just force a good state here.
	if (bNetIsDeployed)
	{
		SetActiveWeapon(AltWeapon);
		Weapon = AltWeapon;
		MyGearWeapon = AltWeapon;
	}
	else
	{
		SetActiveWeapon(PrimaryWeapon);
		Weapon = PrimaryWeapon;
		MyGearWeapon = PrimaryWeapon;
	}

	Weapon.InvManager = InvManager;

	if (WorldInfo.NetMode != NM_Client)
	{
		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_EnteredSilverback, InDriver);
	}
}

/**
 * Stop the weapons from firing when the driver leaves.
 *
 * @param OldDriver - the previous pawn driver
 *
 */
simulated function DoDriverDetach(GearPawn OldDriver)
{
	if (PrimaryWeapon != none)
	{
		PrimaryWeapon.StopFire(0);
		PrimaryWeapon.StopFire(1);
	}

	if (AltWeapon != none)
	{
		AltWeapon.StopFire(0);
	}

	// Just clear up all the non-replicated state here
	// If getting out and jumping back in becomes an exploit, replicate barrel heat
	CurrentBarrelHeat = 0;
	ClearTimer(nameof(OverheatPenaltyExpired));
	OverheatPenaltyExpired();
	bActivelyCooling = FALSE;
	PrimaryWeapon.EndActiveCooling();
	AltWeapon.EndActiveCooling();

	Super.DoDriverDetach(OldDriver);
}

/** Get references to the weapons from the inventory manager and notify kismet */
function OnDriverSet()
{
	Super.OnDriverSet();

	PrimaryWeapon = GearInventoryManager_SilverbackArmed(InvManager).PrimaryWeapon;
	AltWeapon = GearInventoryManager_SilverbackArmed(InvManager).AltFireWeapon;
}

/**
 *  Disallow exit from a deployed silverback.
 *
 *  @param bForceLeave - whether to skip all checks and force the player out of the vehicle
 *
 *  @return true if the driver has been removed
 */
event bool DriverLeave( bool bForceLeave )
{
	if( IsDoingASpecialMove() )
	{
		// If we're deployed check with special move if we're allowed to exit.
		if( IsDoingSpecialMove(GSM_Silverback_CoverDeploy) )
		{
			if( GSM_Silverback_CoverDeploy(SpecialMoves[SpecialMove]).CanOverrideMoveWith(GSM_Silverback_GetOut) )
			{
				return Super.DriverLeave(bForceLeave);
			}
		}

		if( bForceLeave )
		{
			// Stop roadie run if we're leaving to make sure the silverback cools down without a driver.
			if (IsDoingSpecialMove(SM_RoadieRun))
			{
				ServerEndSpecialMove(SM_RoadieRun);
			}
		}
		else
		{
			return FALSE;
		}
	}

	return Super.DriverLeave(bForceLeave);
}

/** Deploy the silverback */
simulated function Deploy()
{
	bWantsToBeDeployed = TRUE;
	CheckDeployedStatus();
}

/** Undeploy the silverback */
simulated function Undeploy()
{
	bWantsToBeDeployed = FALSE;
	CheckDeployedStatus();
}

/** Check if Silverback should be deployed or not, and trigger proper special move */
simulated function CheckDeployedStatus()
{
	if( !IsLocallyControlled() )
	{
		return;
	}

	if( bWantsToBeDeployed )
	{
		if (!IsDoingSpecialMove(GSM_Silverback_CoverDeploy))
		{
			PlaySound(DeploySound);
		}

		LocalDoSpecialMove(GSM_Silverback_CoverDeploy);
	}
	else
	{
		PlaySound(UndeploySound);
		LocalDoSpecialMove(GSM_Silverback_CoverExit);
	}
}

/** Never throw a weapon */
function ThrowActiveWeapon( optional bool bDestroyWeap );

/** We attach weapons at spawn and then never need to attach again */
simulated function AttachWeapon();

/** Handle Targeting Mode */
simulated function bool ShouldForceTargeting()
{
	return TRUE;
}

/** Handle Targeting Mode */
simulated function bool ShouldPreventTargeting()
{
	return !ShouldForceTargeting();
}

/** Setup Cover, so human players can take cover behind silverback. */
function SetupCover()
{
	if (Role != ROLE_Authority)
		return;

	// create the two cover links for the shield
	// we always create the link where the Pawn is standing, since obviously that works
	DeployedLink = Spawn(class'CoverLink_Spawnable',,, Location - vector(Rotation) * CylinderComponent.CollisionRadius * 2.f, Rotation,, TRUE);
	SetupCoverLink(DeployedLink);
	bForceNetUpdate = TRUE;
}

/** Setup Coverlink information */
final function SetupCoverLink(CoverLink_Spawnable NewLink)
{
	local CoverSlot Slot;

	// create and add some slots
	Slot.ForceCoverType = CT_MidLevel;
	Slot.CoverType = CT_MidLevel;
	Slot.bCanMantle = FALSE;
	Slot.bCanPopUp = FALSE;
	Slot.bCanSwatTurn_Left = FALSE;
	Slot.bCanSwatTurn_Right = FALSE;
	Slot.bEnabled = TRUE;
	Slot.RotationOffset = rot(0,0,0);
	Slot.OverlapClaimsList.Add(1);
	Slot.OverlapClaimsList[0].Link	= NewLink;

	Slot.bLeanLeft = TRUE;
	Slot.bLeanRight = FALSE;
	Slot.bCanCoverSlip_Left = Slot.bLeanLeft;
	Slot.bCanCoverSlip_Right = Slot.bLeanRight;
	Slot.LocationOffset = TransformVectorByRotation(NewLink.Rotation, vect(12.f, -20, 0), TRUE);
	Slot.OverlapClaimsList[0].SlotIdx = 1;
	NewLink.Slots[0] = Slot;
	NewLink.SetReplicatedSlot0(Slot);

	Slot.bLeanLeft = FALSE;
	Slot.bLeanRight = TRUE;
	Slot.bCanCoverSlip_Left = Slot.bLeanLeft;
	Slot.bCanCoverSlip_Right = Slot.bLeanRight;
	Slot.LocationOffset = TransformVectorByRotation(NewLink.Rotation, vect(12.f, 20, 0), TRUE);
	Slot.OverlapClaimsList[0].SlotIdx = 0;
	NewLink.Slots[1] = Slot;
	NewLink.SetReplicatedSlot1(Slot);

	// add the link the navigation network so we can take cover on it later
	NewLink.bAddToPathNetwork = TRUE;

	NewLink.UpdateCoverLink();
	NewLink.UpdateCoverSlot(0, TRUE);
	NewLink.UpdateCoverSlot(1, TRUE);
}

/** Disable cover */
function CleanUpDeployment()
{
	local GearPC PC;
	local GearAI AI;
	local int Idx;

	if( DeployedLink != None )
	{
		for (Idx = 0; Idx < DeployedLink.Claims.Length; Idx++)
		{
			PC = GearPC(DeployedLink.Claims[Idx].Controller);
			if (PC != None)
			{
				PC.ClientBreakFromCover();
			}
			else
			{
				AI = GearAI(DeployedLink.Claims[Idx].Controller);
				if (AI != None)
				{
					AI.InvalidateCover();
				}
			}
		}
		DeployedLink.Destroy();
		DeployedLink = None;
	}
}

/** The overheat timer has completed, the guns can fire again */
simulated function OverheatPenaltyExpired()
{
	bOverheated = FALSE;
	PrimaryWeapon.ClearOverheat();
	AltWeapon.ClearOverheat();
}

/**
 * Whether the silverback has overheated
 *
 * @return TRUE if the silverback is overheated
 */
simulated function bool IsOverheated()
{
	return bOverheated;
}

/**
 * Handle the heating and cooling of the guns
 *
 * @param DeltaTime - the amount of time that passed since last frame
 */
simulated function Tick(float DeltaTime)
{
	local GearPC GPC;
	local GearPlayerInput GPI;
	local bool bFiring, bR1Pressed, bRoadieRunning;

	if (PrimaryWeapon != none)
	{
		bFiring = PrimaryWeapon.IsFiring();
	}

	bRoadieRunning = IsDoingSpecialMove(SM_RoadieRun);

	if (bFiring || bRoadieRunning)
	{
		if (bActivelyCooling)
		{
			bActivelyCooling = FALSE;
			PrimaryWeapon.EndActiveCooling();
			AltWeapon.EndActiveCooling();
		}

		if (MaxFiringTimeBeforeOverheat > 0.0)
		{
			if (bFiring)
			{
				CurrentBarrelHeat += DeltaTime / MaxFiringTimeBeforeOverheat;
			}

			if (bRoadieRunning)
			{
				CurrentBarrelHeat += DeltaTime / MaxRunningTimeBeforeOverheat;

				// Force the hud heat display up
				if (GearPC(Controller) != None && GearPC(Controller).MyGearHud != None)
				{
					GearPC(Controller).MyGearHud.LastWeaponInfoTime = WorldInfo.TimeSeconds;
				}
			}


			CurrentBarrelHeat = FMin(CurrentBarrelHeat, 1.f);

			if ((CurrentBarrelHeat >= 1.f) && !bOverheated)
			{
				bOverheated = TRUE;

				if (bRoadieRunning)
				{
					LocalEndSpecialMove(SM_RoadieRun);
				}

				PrimaryWeapon.ForceOverheat();
				AltWeapon.ForceOverheat();

				SetTimer(OverheatPenaltyTime,, nameof(OverheatPenaltyExpired));

				if (WorldInfo.Game != none)
				{
					GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_GatlingOverheated, Driver, None, 0.35f);
				}
			}
		}
	}
	else
	{
		GPC = GearPC(Controller);
		GPI = (GPC != None) ? GearPlayerInput(GPC.PlayerInput) : None;

		bR1Pressed = (GPI != None && GPI.IsButtonActive(GB_RightBumper)) || (MyGearAI != None && MyGearAI.bPerformActiveCooling);

		if (bActivelyCooling && !bR1Pressed)
		{
			bActivelyCooling = FALSE;
			PrimaryWeapon.EndActiveCooling();
			AltWeapon.EndActiveCooling();
		}
		else if (!bActivelyCooling && bR1Pressed && CurrentBarrelHeat > 0.f)
		{
			bActivelyCooling = TRUE;
			PrimaryWeapon.BeginActiveCooling();
			AltWeapon.BeginActiveCooling();
		}

		if (bActivelyCooling)
		{
			CurrentBarrelHeat -= DeltaTime / CooldownTimeActiveCooling;

			if (CurrentBarrelHeat <= 0.f)
			{
				PrimaryWeapon.EndActiveCooling();
				AltWeapon.EndActiveCooling();
			}
		}
		else
		{
			CurrentBarrelHeat -= DeltaTime / CooldownTime;
		}
		CurrentBarrelHeat = FMax(CurrentBarrelHeat, 0.f);
	}

	Super.Tick(DeltaTime);
}

simulated function CacheAnimNodes()
{
	Super.CacheAnimNodes();

	RecoilRightArm = GearSkelCtrl_IKRecoil(Mesh.FindSkelControl('RecoilRightArm'));
	RecoilLeftArm = GearSkelCtrl_IKRecoil(Mesh.FindSkelControl('RecoilLeftArm'));
}

simulated function TriggerRightArmRecoil()
{
	// Right gun
	// Fix for low frame rate issue, do not overwrite shakes...
	if( RecoilRightArm.Recoil.TimeToGo <= RecoilRightArm.Recoil.TimeDuration*0.5f )
	{
		RecoilRightArm.Aim = AimOffsetPct;
		RecoilRightArm.bPlayRecoil = !RecoilRightArm.bPlayRecoil;
	}
}

simulated function TriggerLeftArmRecoil()
{
	// Right gun
	// Fix for low frame rate issue, do not overwrite shakes...
	if( RecoilLeftArm.Recoil.TimeToGo <= RecoilLeftArm.Recoil.TimeDuration*0.5f )
	{
		RecoilLeftArm.Aim = AimOffsetPct;
		RecoilLeftArm.bPlayRecoil = !RecoilLeftArm.bPlayRecoil;
	}
}

/** whether this Silverback is fully deployed (wants to be and anim is complete) */
final function bool IsDeployed()
{
	return (bWantsToBeDeployed && IsDoingSpecialMove(GSM_Silverback_CoverDeploy) && GSM_Silverback_CoverDeploy(SpecialMoves[SpecialMove]).bIsDeployed);
}

/**
 * Whether we should draw an icon for a player taking cover on us
 *
 * @return TRUE if there's a player in our coverlink
 */
simulated function bool ShouldDrawCoverIcon()
{
	return DeployedLink != None && DeployedLink.Claims.Length > 0 && GearPC(Controller) != None && GearPC(Controller).MyGearHud != None;
}

/**
 * SetActiveWeapon doesn't work on non-NetOwner clients, just set the vars we want
 *
 * @param NewWeapon - the weapon to become active
 */
simulated function SetActiveWeapon(Weapon NewWeapon)
{
	if (!bNetOwner)
	{
		// Avoid getting the looping effect stuck on the weapon we're disabling
		Weapon.ClearFlashLocation();

		Weapon = NewWeapon;
		MyGearWeapon = GearWeapon(NewWeapon);
	}
	else
	{
		Super.SetActiveWeapon(NewWeapon);
	}
}

/** Change the weapon emissive color to proper team colors */
simulated function SetTeamColor()
{
	if (bDisabled)
	{
		MyGearWeapon.MIC_WeaponSkin.SetVectorParameterValue('Weap_EmisColor', EmissiveDisabled);
		AltWeapon.MIC_WeaponSkin.SetVectorParameterValue('Weap_EmisColor', EmissiveDisabled);
	}
	else if (GetTeamNum() == 0)
	{
		MyGearWeapon.MIC_WeaponSkin.SetVectorParameterValue('Weap_EmisColor', EmissiveCOG);
		AltWeapon.MIC_WeaponSkin.SetVectorParameterValue('Weap_EmisColor', EmissiveCOG);
	}
	else
	{
		MyGearWeapon.MIC_WeaponSkin.SetVectorParameterValue('Weap_EmisColor', EmissiveLocust);
		AltWeapon.MIC_WeaponSkin.SetVectorParameterValue('Weap_EmisColor', EmissiveLocust);
	}

	Super.SetTeamColor();
}

defaultproperties
{
	SpecialMoveClasses.Empty()
	SpecialMoveClasses(GSM_Silverback_CoverDeploy)=class'GSM_Silverback_CoverDeploy'
	SpecialMoveClasses(GSM_Silverback_CoverExit)=class'GSM_Silverback_CoverExit'
	SpecialMoveClasses(SM_MantleDown)=class'GSM_Silverback_MantleDown'
	SpecialMoveClasses(SM_RoadieRun)=class'GSM_Silverback_RoadieRun'
	SpecialMoveClasses(SM_DoorKick)=class'GSM_DoorKick'
	SpecialMoveClasses(GSM_Silverback_SuperCurbStomp)=class'GSM_Silverback_SuperCurbstomp'
	SpecialMoveClasses(GSM_Silverback_Kick)=class'GSM_Silverback_Kick'
	SpecialMoveClasses(GSM_Silverback_GetIn)=Class'GSM_Silverback_GetIn'
	SpecialMoveClasses(GSM_Silverback_GetOut)=Class'GSM_Silverback_GetOut'

	bCanRoadieRunWhileTargeting=TRUE
}

