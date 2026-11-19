
/**
 * Meat Shield: Kidnapper
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Kidnapper extends GSM_InteractionPawnLeader_Base;

/** Animations */
var GearPawn.BodyStance BS_KidnapperGrab, BS_HostageGrab, BS_HostageStruggle, BS_KidnapperStruggle;

var PlayerController BackupController;
var bool bWantHostageToLeaveHisSpecialMove;
/** Original weapon carried when grabbing someone */
var GearWeapon OriginalWeapon;
/** Offset of Marker from Pawn's location. Used to place kidnapper to grab hostage properly. */
var vector MarkerOffset, VectToHostage;
var float HostageRotationTimeToGo;
var bool bInterpolatingHostageRotation;
var class<GearDamageType> KidnapperDamageType;
/** total duration of hostage resistance (controls anim playrate, no firing) */
var config float HostageResistanceDuration;
/** duration of hostage resistance stun (no movement or firing) - must be <= HostageResistanceDuration */
var config float HostageResistanceStunDuration;

/** set when most recent ending to this special move was voluntary via weapon switch */
var bool bEndedByWeaponSwitch;
/** If Head is Locked or not */
var bool bHeadLocked;

protected function bool InternalCanDoSpecialMove()
{
	return ( !PawnOwner.bDoingMeleeAttack && !PawnOwner.bSwitchingWeapons && PawnOwner.InvManager.PendingWeapon == None &&
		!PawnOwner.IsDBNO() && !PawnOwner.IsDoingSpecialMove(SM_RoadieRun) &&
		GearInventoryManager(PawnOwner.InvManager).FindWeaponOfType(WT_Holster) != None &&
		Super.InternalCanDoSpecialMove() );
}

/**
 * Test conditions to take another Pawn has a hostage
 */
function bool CanInteractWithPawn(GearPawn OtherPawn)
{
	local GearPawn_Infantry OtherIP;

	if (PawnOwner.CoverType != CT_None || PawnOwner.IsCarryingShield() || PawnOwner.IsDoingSpecialMove(SM_RoadieRun) || PawnOwner.bCoveringHead)
	{
		return FALSE;
	}

	OtherIP = GearPawn_Infantry(OtherPawn);
	if( OtherIP == none 		// Can only take hostage infantry.
		|| !OtherIP.CanBeAHostage()
		|| PawnOwner.IsSameTeam(OtherPawn) 			// Can only take hostage enemies
		|| OtherPawn.Physics == PHYS_Falling 		// Hostage cannot be falling.
		|| OtherPawn.Physics == PHYS_RigidBody 		// Hostage cannot be a rag doll
		|| OtherPawn.bPlayedDeath )					// Hostage cannot be already dead.
	{
		return FALSE;
	}

	// Hostage has to be DBNO of some type
	if (!OtherPawn.IsDBNO(true))
	{
		return FALSE;
	}

	// facing check is client authoritative
	return (!PawnOwner.IsLocallyControlled() || PawnOwner.IsFacingOther(OtherPawn, 0.f));
}


/** Notification called when Special Move starts */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearWeapon Weap;
	local GearPC PC;

	bCanFireWeapon = false;

	// Reset this flag
	bWantHostageToLeaveHisSpecialMove = false;
	bEndedByWeaponSwitch = false;

	// can't mantle while kidnapping
	PawnOwner.bCanMantle  = false;
	PawnOwner.bCanClimbUp = false;

	// Update the attached hostage before physics runs
	PawnOwner.Mesh.bForceUpdateAttachmentsInTick = true;

	// force the kidnapper to switch to pistols
	// Do this only on locally controlled Pawn. So the new weapon properly replicates to all.
	if( PawnOwner.IsLocallyControlled() )
	{
		// Backup weapon, so we can restore it.
		OriginalWeapon = PawnOwner.MyGearWeapon;

		PC = GearPC(PawnOwner.Controller);
		if (PC != None)
		{
			if (PC.MyGearHud != None)
			{
				PC.MyGearHud.ClearActionInfoByType(AT_SpecialMove);
			}

			// Flush the special move cache
			PC.CachedCanDoGlobalActionSpecialMoves.Length = 0;
		}

		foreach PawnOwner.InvManager.InventoryActors(class'GearWeapon', Weap)
		{
			if( Weap.WeaponType == WT_Holster )
			{
				PawnOwner.InvManager.SetCurrentWeapon(Weap);
				break;
			}
		}
	}

	Super.SpecialMoveStarted(bForced,PrevMove);
}

/**
 * Begins the interaction.
 */
function StartInteraction()
{
	local GearPRI HostagePRI, KidnapperPRI;
	local GearWeap_GrenadeBase OwnerGrenadeWeap, FollowerGrenadeWeap;
	local GearWeap_COGPistol Pistol;
	local int Amount;

	// Move kidnapper into position to grab hostage.
	MoveToMarkers();

	// steal the hostage's grenades if we don't have any
	FollowerGrenadeWeap = GearWeap_GrenadeBase(Follower.FindInventoryType(class'GearWeap_GrenadeBase', true));
	if (FollowerGrenadeWeap != None && FollowerGrenadeWeap.HasAnyAmmo())
	{
		OwnerGrenadeWeap = GearWeap_GrenadeBase(PawnOwner.FindInventoryType(class'GearWeap_GrenadeBase', true));
		if (OwnerGrenadeWeap == None || OwnerGrenadeWeap.Class == FollowerGrenadeWeap.Class || !OwnerGrenadeWeap.HasAnyAmmo())
		{
			if (OwnerGrenadeWeap != None && OwnerGrenadeWeap.Class == FollowerGrenadeWeap.Class)
			{
				Amount = OwnerGrenadeWeap.AddAmmo(FollowerGrenadeWeap.SpareAmmoCount + FollowerGrenadeWeap.WeaponMagSize - FollowerGrenadeWeap.AmmoUsedCount);
				if (Amount > 0)
				{
					OwnerGrenadeWeap.AddAmmoMessage(Amount);
				}
			}
			else
			{
				if (OwnerGrenadeWeap != None)
				{
					OwnerGrenadeWeap.Destroy();
				}
				OwnerGrenadeWeap = GearWeap_GrenadeBase(PawnOwner.CreateInventory(FollowerGrenadeWeap.Class, true));
				if (OwnerGrenadeWeap != None)
				{
					OwnerGrenadeWeap.SpareAmmoCount = FollowerGrenadeWeap.SpareAmmoCount;
					OwnerGrenadeWeap.AddAmmoMessage(FollowerGrenadeWeap.SpareAmmoCount + 1);
				}
			}
			FollowerGrenadeWeap.Destroy();
		}
	}

	// give some free pistol ammo if the kidnapper has none so they're not stuck with no weapon
	Pistol = GearWeap_COGPistol(PawnOwner.FindInventoryType(class'GearWeap_COGPistol', false));
	if (Pistol != None && Pistol.SpareAmmoCount < 25)
	{
		Pistol.AddAmmo(25 - Pistol.SpareAmmoCount);
	}

	// award the death of the hostage if allowed to
	if( Follower.CanBeSpecialMeleeAttacked(PawnOwner) )
	{
		if( PawnOwner.WorldInfo.Game != None )
		{
			// Set PRI death variables
			HostagePRI = GearPRI(Follower.PlayerReplicationInfo);
			KidnapperPRI = GearPRI(PawnOwner.PlayerReplicationInfo);
			Follower.SetDeathReplicationData( KidnapperPRI, HostagePRI, class'GDT_Hostage' );
			KidnapperPRI.ScoreExecution(HostagePRI, class'GDT_Hostage', GDT_NORMAL);
			// Score the kill in the game object
			PawnOwner.WorldInfo.Game.Killed(PawnOwner.Controller, Follower.Controller, Follower, class'GDT_Hostage');
		}
	}
}

/** Place both characters on markers, so they can connect and play their grab animation for attachment */
function MoveToMarkers()
{
	local Vector	KidnapperDestination;
	local float		BlendInTime, AnimPlayRate;

	VectToHostage = Follower.Location - PawnOwner.Location;
	VectToHostage.Z = 0.f;
	VectToHostage = Normal(VectToHostage);

	KidnapperDestination = Follower.Location + RelativeToWorldOffset(Rotator(-VectToHostage), MarkerOffset);

	BlendInTime = 0.2f;
	AnimPlayRate = 1.67f;

	// Start playing grab animation
	PlayGrab(AnimPlayRate, BlendInTime);

	// Move kidnapper relative to hostage, so his marker aligns with Hostage's root bone.
	SetReachPreciseDestination(KidnapperDestination);
	// Rotate Kidnapper so he faces hostage.
	SetFacePreciseRotation(Rotator(VectToHostage), BlendInTime);
}

function PlayGrab(float PlayRate, float BlendInTime)
{
	local float AnimTime;

	// Play animation on both characters.
	AnimTime = PawnOwner.BS_Play(BS_KidnapperGrab, PlayRate, BlendInTime, 0.2f);
	PawnOwner.SetTimer(AnimTime, FALSE, nameof(ResetMovementLock), Self);

	Follower.BS_Play(BS_HostageGrab, PlayRate, BlendInTime, 0.2f);
	Follower.BS_SetbZeroRootTranslation(BS_HostageGrab, TRUE);
	Follower.ShootOffAttachment(eATTACHTYPE_Helmet, vect(0,0,0), class'GearDamageType', TRUE );
	Follower.ShootOffAttachment(eATTACHTYPE_ShoulderLeft, vect(0,0,0), class'GearDamageType', TRUE );
	Follower.ShootOffAttachment(eATTACHTYPE_ShoulderRight, vect(0,0,0), class'GearDamageType', TRUE );
	Follower.RemoveAndDropAttachments( vect(0,0,0), class'GearDamageType' );

	// Activate MeatShield Morph Target to prevent hostage clipping into kidnapper.
// 	Follower.SetActiveMeatShieldMorph(TRUE);

	if( Follower.MeatShieldMorphNodeWeight != None )
	{
		Follower.MeatShieldMorphNodeWeight.SetNodeWeight(1.f);
	}

	// Timer to trigger the grab, do this once we're fully blended in
	if( BlendInTime > 0.f )
	{
		PawnOwner.SetTimer(BlendInTime, FALSE, nameof(AttachHostageToKidnapper), self);
	}
	else
	{
		AttachHostageToKidnapper();
	}

	// Hostage turning takes place from 0.65 seconds to 1.15seconds, so it lasts for 0.5 seconds.
	// Scale everything by play rate.
	HostageRotationTimeToGo = 0.5f / PlayRate;
	PawnOwner.SetTimer( 0.65f / PlayRate, FALSE, nameof(self.StartHostageTurn), self );

	// notify guds
	if (PawnOwner.WorldInfo.Game != None)
	{
		if (GearPRI(Follower.PlayerReplicationInfo).bIsLeader)
		{
			GearGame(PawnOwner.WorldInfo.Game).TriggerGUDEvent(GUDEvent_PickedUpMeatShield_Leader, PawnOwner, Follower);
		}
		else
		{
			GearGame(PawnOwner.WorldInfo.Game).TriggerGUDEvent(GUDEvent_PickedUpMeatShield, PawnOwner, Follower);
		}
	}

	/** Trigger the swat turn delegates in the PC */
	if ( PCOwner != None )
	{
		PCOwner.TriggerGearEventDelegates( eGED_MeatBagGrabbed );
	}
}

function StartHostageTurn()
{
	bInterpolatingHostageRotation = TRUE;
}

/** Grab animation is done playing, we can now move again. */
function ResetMovementLock()
{
	SetMovementLock(FALSE);
	SetLockPawnRotation(FALSE);
	bCanFireWeapon = true;
}

/** Attach Hostage to Kidnapper */
function AttachHostageToKidnapper()
{
	// Cache HeadLock SkelControls.
	Follower.HostageHeadLock = Follower.Mesh.FindSkelControl('HostageHeadLock');
	Follower.HostageHeadLockIK = Follower.Mesh.FindSkelControl('HostageHeadLockIK');

	// lock head
	LockHead(Follower, TRUE);

	// Cancel kidnapper movement, since hostage is now going to be attached.
	SetReachPreciseDestination(Vect(0,0,0), TRUE);

	// if the follower will be killed by this move, drop their weapons
	if (Follower.CanBeSpecialMeleeAttacked(PawnOwner))
	{
		if (Follower.Weapon != None)
		{
			Follower.TossInventory(Follower.Weapon);
		}
	}

	// Turn off flappy bits on the follower during the attach so the instant rotation doesn't glitch the physics sim
	Follower.Mesh.bEnableFullAnimWeightBodies = FALSE;

	AttachFollowerToLeader('HostageGrab');

	// Turn flappy bits back on for the follower
	Follower.Mesh.bEnableFullAnimWeightBodies = TRUE;

	// Synchronize animations together.
	Follower.AnimTreeRootNode.ForceGroupRelativePosition('Sync_Idle', PawnOwner.AnimTreeRootNode.GetGroupRelativePosition('Sync_Idle'));
	Follower.AnimTreeRootNode.ForceGroupRelativePosition('RunWalk', PawnOwner.AnimTreeRootNode.GetGroupRelativePosition('RunWalk'));

	// Hide weapon attachments from Hostage's back, so it doesn't clip into kidnapper.
	FollowerSetAttachmentHidden(EASlot_LeftShoulder, TRUE);
	FollowerSetAttachmentHidden(EASlot_RightShoulder, TRUE);

	// detach the controller if this is a MP player that can be executed
	// so that they can spectate, respawn, etc
	if( PawnOwner.WorldInfo.GRI.IsMultiplayerGame() && Follower.CanBeSpecialMeleeAttacked(PawnOwner) )
	{
		Follower.DetachFromController(FALSE);
	}

	// Allow the game object to know if a kidnapping took place
	if( PawnOwner.WorldInfo.Game != None )
	{
		GearGame(PawnOwner.WorldInfo.Game).KidnappingStarted(Follower, PawnOwner);
	}
}

function Tick(float DeltaTime)
{
	local Rotator				DeltaRot;
	local SkeletalMeshSocket	Socket;

	Super.Tick(DeltaTime);

	if( bInterpolatingHostageRotation )
	{
		Socket = PawnOwner.Mesh.GetSocketByName('HostageGrab');
		if( Socket != None )
		{
			if( HostageRotationTimeToGo > DeltaTime )
			{
				// Delta rotation
				DeltaRot = Normalize(Normalize(Socket.RelativeRotation) - Normalize(Follower.RelativeRotation));
				Follower.SetRelativeRotation(Normalize(Follower.RelativeRotation + DeltaRot * (DeltaTime / HostageRotationTimeToGo)));
				HostageRotationTimeToGo -= DeltaTime;
			}
			else
			{
				Follower.SetRelativeRotation(Socket.RelativeRotation);
				bInterpolatingHostageRotation = FALSE;
			}
		}
		else
		{
			bInterpolatingHostageRotation = FALSE;
		}
	}

	// Keep animations in sync between Kidnapper and Hostage.
	if( Follower != None )
	{
		Follower.AnimTreeRootNode.ForceGroupRelativePosition('Sync_Idle', PawnOwner.AnimTreeRootNode.GetGroupRelativePosition('Sync_Idle'));
		Follower.AnimTreeRootNode.ForceGroupRelativePosition('RunWalk', PawnOwner.AnimTreeRootNode.GetGroupRelativePosition('RunWalk'));

		if( bHeadLocked && Follower.HostageHeadLock != None )
		{
			if( Follower.HostageHeadLock.StrengthTarget > 0.f && PawnOwner.IsReloadingWeapon() )
			{
				Follower.HostageHeadLock.SetSkelControlActive(FALSE);
				Follower.HostageHeadLockIK.SetSkelControlActive(FALSE);
			}
			else if( Follower.HostageHeadLock.StrengthTarget < 1.f && !PawnOwner.IsReloadingWeapon() )
			{
				Follower.HostageHeadLock.SetSkelControlActive(TRUE);
				Follower.HostageHeadLockIK.SetSkelControlActive(TRUE);
			}
		}
	}
}


/** Catch melee button to execute hostage */
function bool ButtonPress(Name ButtonName)
{
	// Use button means drop hostage, and execute him if he's still alive
	if (!PawnOwner.bDoingMeleeAttack && !bMovementDisabled)
	{
		// When using alternate controls, x button is spot. Don't do the execution if targeting.
		if (ButtonName == 'X' && (!PCOwner.bUseAlternateControls || !PCOwner.bIsTargeting))
		{
			// If hostage is able to be executed (CanBeSpecialMeleeAttacked), trigger execution Special Move
			if( Follower.CanBeSpecialMeleeAttacked(PawnOwner) )
			{
				PawnOwner.LocalDoSpecialMove(SM_Kidnapper_Execution,, Follower, 0);
			}
			// allow revival from kidnapper move if we can't use X to execute
			else if ( PawnOwner.SpecialMoveClasses[SM_ReviveTeammate] != None && PawnOwner.VerifySMHasBeenInstanced(SM_ReviveTeammate) &&
					GSM_ReviveTeammate(PawnOwner.SpecialMoves[SM_ReviveTeammate]).FindPawnToRevive() )
			{
				PCOwner.ServerReviveTeamMate(GSM_ReviveTeammate(PawnOwner.SpecialMoves[SM_ReviveTeammate]).PawnToRevive, true);
			}
			return true;
		}
		else if (ButtonName == 'DPad_Up')
		{
			if (PCOwner.CanDoSpecialMove(SM_Kidnapper_GrenadeRelease))
			{
				PCOwner.DoSpecialMove(SM_Kidnapper_GrenadeRelease,, PawnOwner.InteractionPawn);
			}
			return true;
		}
	}

	return false;
}

/**
 * Lock Head of the input Pawn
 */
function LockHead( GearPawn APawn, bool bLock )
{
	bHeadLocked = bLock;
	if( APawn.HostageHeadLock != None )
	{
		 APawn.HostageHeadLock.SetSkelControlActive(bLock);
	}
	if( APawn.HostageHeadLockIK != None )
	{
		 APawn.HostageHeadLockIK.SetSkelControlActive(bLock);
	}
}

/**
 * Detaches a based Pawn from the Leader.
 */
function DetachPawn(GearPawn APawn)
{
	// unlock head
	LockHead(APawn, FALSE);

	Super.DetachPawn(APawn);

	// Allow the game object to know if someone was released by a kidnapping
	if( PawnOwner.WorldInfo.Game != None )
	{
		GearGame(PawnOwner.WorldInfo.Game).KidnappingStopped(Follower, PawnOwner);
	}
}

function LockIKStatus(bool bInstant)
{
	// Disable IK on right hand.
	if( bInstant )
	{
		PawnOwner.IKBoneCtrl_RightHand.SetSkelControlStrength(0.f, 0.f);
		PawnOwner.IKBoneCtrl_LeftHand.SetSkelControlStrength(0.f, 0.f);
	}
	else
	{
		PawnOwner.IKBoneCtrl_RightHand.SetSkelControlActive(FALSE);
		PawnOwner.IKBoneCtrl_LeftHand.SetSkelControlActive(FALSE);
	}
	PawnOwner.bLockIKStatus = TRUE;
}

function RestoreIKStatus()
{
	PawnOwner.IKBoneCtrl_RightHand.SetSkelControlActive(TRUE);
	PawnOwner.bLockIKStatus = FALSE;
	// For left hand, depends on what we're doing.
	PawnOwner.UpdateBoneLeftHandIK();
}

/**
 * Directly show and hide the weapon slots
 *
 * @param Slot - the attach slot to show/hide
 *
 * @param bNewHidden - whether it should be hidden or not
 */
simulated function FollowerSetAttachmentHidden(EAttachSlot Slot, bool bNewHidden)
{
	if (Follower.AttachSlots[Slot].StaticMesh != None)
	{
		Follower.AttachSlots[Slot].StaticMesh.SetHidden(bNewHidden);
	}

	if (Follower.AttachSlots[Slot].SkeletalMesh != None)
	{
		Follower.AttachSlots[Slot].SkeletalMesh.SetHidden(bNewHidden);
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// need to make sure AttachHostageToKidnapper() gets called as it performs some death-related functionality
	if (PawnOwner.IsTimerActive(nameof(AttachHostageToKidnapper), self))
	{
		AttachHostageToKidnapper();
		PawnOwner.ClearTimer(nameof(AttachHostageToKidnapper), self);
	}

	bCanFireWeapon = false;

	// Make sure that the weapon hasn't already started equipping by the time this is called
	if (Follower.AttachSlotClass_LeftShoulder != None)
	{
		FollowerSetAttachmentHidden(EASlot_LeftShoulder, FALSE);
	}

	// Make sure that the weapon hasn't already started equipping by the time this is called
	if (Follower.AttachSlotClass_RightShoulder != None)
	{
		FollowerSetAttachmentHidden(EASlot_RightShoulder, FALSE);
	}

	// Keep track of when Hostage was released.
	PawnOwner.HostageReleaseTime = PawnOwner.WorldInfo.TimeSeconds;

	PawnOwner.bCanMantle  = PawnOwner.default.bCanMantle;
	PawnOwner.bCanClimbUp = PawnOwner.default.bCanClimbUp;
	PawnOwner.Mesh.bForceUpdateAttachmentsInTick = PawnOwner.default.Mesh.bForceUpdateAttachmentsInTick;

	// Make sure timer is cleared
	PawnOwner.ClearTimer(nameof(StartHostageTurn), self);
	PawnOwner.ClearTimer(nameof(EndOfStruggleStun), self);
	PawnOwner.ClearTimer(nameof(EndOfStruggle), self);
	PawnOwner.ClearTimer(nameof(ResetMovementLock), Self);

	// If we're not transitioning to an execution, then clean up hostage.
	if (NextMove != SM_Kidnapper_Execution && NextMove != SM_Kidnapper_GrenadeRelease)
	{
		// Make sure IK are disabled. We can't blend out of this because IK setup is different
		// and causes IK over extenstion.
		LockIKStatus(TRUE);

		// Restore IK when animation is done blending out.
		PawnOwner.SetTimer(0.33f, FALSE, 'RestoreIKStatus', Self);

		// Take care of the hostage  if he's still around
		if( Follower != None && !Follower.bDeleteMe  )
		{
			// We're now expecting the hostage to leave his special move
			bWantHostageToLeaveHisSpecialMove = TRUE;
			Follower.Mesh.SetShadowParent(None);
			// Activate MeatShield Morph Target to prevent hostage clipping into kidnapper.
			Follower.SetActiveMeatShieldMorph(FALSE);

			// If the follower has been attached, detach it.
			if( Follower.Role == Role_Authority && !Follower.bPlayedDeath )
			{
				// If Follower is still a hostage, end his special move
				if( Follower.IsDoingSpecialMove(FollowerSpecialMove) )
				{
					Follower.ServerEndSpecialMove(FollowerSpecialMove);

					if( Follower.PendingSpecialMoveStruct.SpecialMove == SM_ChainSawVictim )
					{
						if( Follower.IsBasedOn(PawnOwner) )
						{
							// Detach Follower from Leader.
							DetachPawn(Follower);
							Follower.bCollideWorld = TRUE;
						}
					}
					// kill off the hostage pawn if allowed to
					else if( Follower.CanBeSpecialMeleeAttacked(PawnOwner) )
					{
						Follower.bCollideWorld = TRUE;

						Follower.TearOffMomentum = Normal(Follower.Location - PawnOwner.Location);
						Follower.Died(PawnOwner.Controller, KidnapperDamageType, Follower.Location);
					}
					// Otherwise if kidnapper was killed, then hostage is revived
					else
					{
						if( Follower.IsBasedOn(PawnOwner) )
						{
							// Detach Follower from Leader.
							DetachPawn(Follower);
						}

						Follower.FreeHostage(PawnOwner);
					}
				}
				else if( Follower.IsBasedOn(PawnOwner) )
				{
					// Detach Follower from Leader.
					DetachPawn(Follower);
					Follower.bCollideWorld = TRUE;
				}
			}
			else if (!Follower.bPlayedDeath)
			{
				// need to unlock head
				// a bug that is caused by not unlocking for some clients -
				// it seems it's not based on, so it skips the detachPawn
				LockHead(Follower, FALSE);
				if( Follower.IsBasedOn(PawnOwner) )
				{
					// Detach Follower from Leader.
					DetachPawn(Follower);
				}
			}
		}

		// See if we should restore our original weapon, prior to taking someone hostage
		// Make sure PawnOwner hasn't already swapped his weapon, this could end the meatshield special move as well.
		// In that case we don't want to clobber his weapon choice.
		if( NextMove == SM_None && PawnOwner.IsLocallyControlled() && PawnOwner.IsAliveAndWell() && PawnOwner.InvManager.PendingWeapon == None && PawnOwner.MyGearWeapon.WeaponType == WT_Holster )
		{
			// Only do this if we had a different weapon, and it has enough ammo in case of emergency.
			// Don't force switch to an empty weapon.
			if (OriginalWeapon != PawnOwner.MyGearWeapon && !OriginalWeapon.IsCriticalAmmoCount())
			{
				PawnOwner.InvManager.SetCurrentWeapon(OriginalWeapon);
			}
		}
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

/**
 * Hostage is leaving his special move, catch cases where we didn't expect this from hapening
 * This could happen when the hostage logs out, types 'suicice', or is killed by some other way.
 */
function OnFollowerLeavingSpecialMove()
{
	if (!bWantHostageToLeaveHisSpecialMove)
	{
		bWantHostageToLeaveHisSpecialMove = true;

		// Handle this from the server.
		if (PawnOwner.Role == Role_Authority)
		{
			PawnOwner.ServerEndSpecialMove(PawnOwner.SpecialMove);
		}
	}
}

/**
 * Ends the special move. Intended to be used with SetTimer()
 */
function DelayedEndSpecialMove()
{
	// Handle this from the server.
	if( PawnOwner.Role == Role_Authority )
	{
		PawnOwner.ServerEndSpecialMove(PawnOwner.SpecialMove);
	}
}

function SpecialMoveFlagsUpdated()
{
	// whenever the flags change, it's from the hostage resistance move
	// (handle SpecialMoveFlags like FlashCount)

	// Abort weapon reload if we were doing one
	if (PawnOwner.MyGearWeapon != None)
	{
		PawnOwner.MyGearWeapon.AbortWeaponReload();
	}

	// Play animation on kidnapper
	PawnOwner.BS_PlayByDuration(BS_KidnapperStruggle, HostageResistanceDuration, 0.33, 0.67);
	// Play animation on hostage
	PawnOwner.InteractionPawn.BS_PlayByDuration(BS_HostageStruggle, HostageResistanceDuration, 0.33, 0.67);

	// timer to keep track of event and clean it up
	if (HostageResistanceStunDuration > 0.0)
	{
		SetMovementLock(true);
		PawnOwner.SetTimer(FMin(HostageResistanceDuration, HostageResistanceStunDuration), false, nameof(EndOfStruggleStun), self);
	}
	PawnOwner.SetTimer(HostageResistanceDuration, false, nameof(EndOfStruggle), self);

	bCanFireWeapon = false;
}

/** ends the movement locked portion of the hostage resistance */
final function EndOfStruggleStun()
{
	SetMovementLock(false);
}

/** ends the hostage resistance effects entirely */
final function EndOfStruggle()
{
	bCanFireWeapon = true;
	SetMovementLock(false);
}

defaultproperties
{
	KidnapperDamageType=class'GDT_Hostage'
	bShouldAbortWeaponReload=false
	bCanFireWeapon=false
	bDisableLook=false

	bDisableMovement=true
	bLockPawnRotation=true

	MarkerOffset=(X=125.46,Y=0.00,Z=0.00)
	FollowerSpecialMove=SM_Hostage
	BS_KidnapperGrab=(Stance=((Slot=BS_FullBody,AnimName="Kidnapper_Grab_DBNO")))
	BS_HostageGrab=(Stance=((Slot=BS_FullBody,AnimName="Hostage_Grab_DBNO")))
	BS_PistolReload=(Stance=((Slot=BS_Kidnapper_Upper,AnimName="Kidnapper_Pistol_reload")))
	BS_PistolReloadFail=(Stance=((Slot=BS_Kidnapper_Upper,AnimName="Kidnapper_Pistol_reload_fail")))
	BS_PistolMelee=(Stance=((Slot=BS_FullBody,AnimName="ADD_Kidnapper_MeleeA")))

	BS_HostageStruggle=(Stance=((Slot=BS_FullBody,AnimName="ADD_Hostage_Struggle")))
	BS_KidnapperStruggle=(Stance=((Slot=BS_FullBody,AnimName="ADD_Kidnapper_Struggle")))

	bPlaySimplePistolReload=true

	Action={(
		ActionName=GrabMeatShield,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=212,V=314,UL=35,VL=43))), // A Button
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=0,V=303,UL=58,VL=95)))	),
	)}

	bShowHUDActions=TRUE
}
