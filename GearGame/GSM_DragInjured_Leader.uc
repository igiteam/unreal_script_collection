
/**
 * Dragging Injured People: Leader.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_DragInjured_Leader extends GSM_InteractionPawnLeader_Base;

/** Animations */
var	GearPawn.BodyStance	BS_LeaderGrab, BS_FollowerGrab;
var PlayerController	BackupController;
var bool				bWantFollowerToLeaveHisSpecialMove;
/** Original weapon carried when grabbing someone */
var	GearWeapon			OriginalWeapon;
/** Offset of Marker from Pawn's location. Used to place kidnapper to grab hostage properly. */
var vector				MarkerOffset, VectToFollower;
var FLOAT				FollowerRotationTimeToGo;
var bool				bInterpolatingFollowerRotation;

protected function bool InternalCanDoSpecialMove()
{
	return ( !PawnOwner.bDoingMeleeAttack && !PawnOwner.bSwitchingWeapons && PawnOwner.InvManager.PendingWeapon == None &&
		!PawnOwner.IsDBNO() && !PawnOwner.IsDoingSpecialMove(SM_RoadieRun) && Super.InternalCanDoSpecialMove() );
}

/**
 * Test conditions to take another Pawn has a hostage
 */
function bool CanInteractWithPawn(GearPawn OtherPawn)
{
	local GearPawn_Infantry OtherIP;

	if (PawnOwner.CoverType != CT_None || PawnOwner.IsCarryingShield() || PawnOwner.IsDoingSpecialMove(SM_RoadieRun))
	{
		return FALSE;
	}

	OtherIP = GearPawn_Infantry(OtherPawn);
	if( OtherIP == none 		// Can only take hostage infantry.
		|| !PawnOwner.IsSameTeam(OtherPawn) 		// Can only Drag  teammates
		|| OtherPawn.Physics == PHYS_Falling 		// Hostage cannot be falling.
		|| OtherPawn.Physics == PHYS_RigidBody 		// Hostage cannot be a rag doll
		|| OtherPawn.bPlayedDeath )					// Hostage cannot be already dead.
	{
		return FALSE;
	}

	return TRUE;
}


/** Notification called when Special Move starts */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearWeapon Weap;
	local GearPC PC;

	bCanFireWeapon = FALSE;

	// Reset this flag
	bWantFollowerToLeaveHisSpecialMove = FALSE;

	// can't mantle while dragging
	PawnOwner.bCanMantle  = FALSE;
	PawnOwner.bCanClimbUp = FALSE;

	// Update the attached follower before physics runs
	PawnOwner.Mesh.bForceUpdateAttachmentsInTick = TRUE;

	// force the leader to switch to pistols
	// Do this only on locally controlled Pawn. So the new weapon properly replicates to all.
	if( PawnOwner.IsLocallyControlled() )
	{
		// Backup weapon, so we can restore it.
		OriginalWeapon = PawnOwner.MyGearWeapon;

		PC = GearPC(PawnOwner.Controller);
		if (PC != None && PC.MyGearHud != None)
		{
			PC.MyGearHud.ClearActionInfoByType(AT_SpecialMove);
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
	local GearWeap_COGPistol Pistol;

	// Debug to find marker location
	if( FALSE )
	{
		PlayGrab(2.f, 0.f);
		PawnOwner.SetTimer( 0.2f, FALSE, nameof(self.DEBUG_GetAttachBoneLoc), self );
	}

	// Move leader into position to grab follower.
	MoveToMarkers();

	// give some free pistol ammo if the leader has none so they're not stuck with no weapon
	Pistol = GearWeap_COGPistol(PawnOwner.FindInventoryType(class'GearWeap_COGPistol', FALSE));
	if( Pistol != None && Pistol.SpareAmmoCount < 25 )
	{
		Pistol.AddAmmo(25 - Pistol.SpareAmmoCount);
	}
}

/** DEBUG function to find out where attachment socket is located, and bake that result into MarketOffset. */
function DEBUG_GetAttachBoneLoc()
{
	DebugSocketRelativeLocation('HostageGrab');
}

/** Place both characters on markers, so they can connect and play their grab animation for attachment */
function MoveToMarkers()
{
	local Vector	LeaderDestination;
	local float		BlendInTime, AnimPlayRate;

	VectToFollower = Follower.Location - PawnOwner.Location;
	VectToFollower.Z = 0.f;
	VectToFollower = Normal(VectToFollower);

	LeaderDestination = Follower.Location + RelativeToWorldOffset(Rotator(-VectToFollower), MarkerOffset);

	BlendInTime = 0.2f;
	AnimPlayRate = 1.67f;

	// Start playing grab animation
	PlayGrab(AnimPlayRate, BlendInTime);

	// Move kidnapper relative to hostage, so his marker aligns with Hostage's root bone.
	SetReachPreciseDestination(LeaderDestination);
	// Rotate Kidnapper so he faces hostage.
	SetFacePreciseRotation(Rotator(VectToFollower), BlendInTime);
}

function PlayGrab(float PlayRate, float BlendInTime)
{
	// Play grab animation on both characters.
	PawnOwner.BS_Play(BS_LeaderGrab, PlayRate, BlendInTime, 0.2f);
	PawnOwner.BS_SetAnimEndNotify(BS_LeaderGrab, TRUE);

	Follower.BS_Play(BS_FollowerGrab, PlayRate, BlendInTime, 0.2f);
	Follower.BS_SetbZeroRootTranslation(BS_FollowerGrab, TRUE);
	// Timer to trigger the grab, do this once we're fully blended in
	if( BlendInTime > 0.f )
	{
		PawnOwner.SetTimer( BlendInTime, FALSE, nameof(self.DoAttachment), self );
	}
	else
	{
		DoAttachment();
	}

	// Hostage turning takes place from 0.65 seconds to 1.15 seconds, so it lasts for 0.5 seconds.
	// Scale everything by play rate.
	FollowerRotationTimeToGo = 0.5f / PlayRate;
	PawnOwner.SetTimer( 0.65f / PlayRate, FALSE, nameof(self.StartFollowerTurn), self );
}

function StartFollowerTurn()
{
	bInterpolatingFollowerRotation = TRUE;
}

function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	// Grab animation is done playing, we can now move again.
	SetMovementLock(FALSE);
	SetLockPawnRotation(FALSE);
	bCanFireWeapon = true;
}

/** Attach Follower to Leader */
function DoAttachment()
{
	// Cancel kidnapper movement, since hostage is now going to be attached.
	SetReachPreciseDestination(Vect(0,0,0), TRUE);

	AttachFollowerToLeader('HostageGrab');

	// Synchronize animations together.
	Follower.AnimTreeRootNode.ForceGroupRelativePosition('Sync_Idle', PawnOwner.AnimTreeRootNode.GetGroupRelativePosition('Sync_Idle'));
	Follower.AnimTreeRootNode.ForceGroupRelativePosition('RunWalk', PawnOwner.AnimTreeRootNode.GetGroupRelativePosition('RunWalk'));

	PawnOwner.SetTimer(1.f, TRUE, 'SyncAnims', Self);
}

function SyncAnims()
{
	Follower.AnimTreeRootNode.ForceGroupRelativePosition('Sync_Idle', PawnOwner.AnimTreeRootNode.GetGroupRelativePosition('Sync_Idle'));
}

function Tick(float DeltaTime)
{
	local Rotator				DeltaRot;
	local SkeletalMeshSocket	Socket;

	Super.Tick(DeltaTime);

	if( bInterpolatingFollowerRotation)
	{
		Socket = PawnOwner.Mesh.GetSocketByName('HostageGrab');
		if( Socket != None )
		{
			if( FollowerRotationTimeToGo > DeltaTime )
			{
				// Delta rotation
				DeltaRot = Normalize(Normalize(Socket.RelativeRotation) - Normalize(Follower.RelativeRotation));
				Follower.SetRelativeRotation(Normalize(Follower.RelativeRotation + DeltaRot * (DeltaTime / FollowerRotationTimeToGo)));
				FollowerRotationTimeToGo -= DeltaTime;
			}
			else
			{
				Follower.SetRelativeRotation(Socket.RelativeRotation);
				bInterpolatingFollowerRotation = FALSE;
			}
		}
		else
		{
			bInterpolatingFollowerRotation = FALSE;
		}
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	PawnOwner.ClearTimer('SyncAnims', Self);

	bCanFireWeapon = FALSE;

	// Reset stuffs
	PawnOwner.BS_SetAnimEndNotify(BS_LeaderGrab, FALSE);
	PawnOwner.bCanMantle  = PawnOwner.default.bCanMantle;
	PawnOwner.bCanClimbUp = PawnOwner.default.bCanClimbUp;
	PawnOwner.Mesh.bForceUpdateAttachmentsInTick = PawnOwner.default.Mesh.bForceUpdateAttachmentsInTick;

	// Make sure timer is cleared
	PawnOwner.ClearTimer(nameof(self.DoAttachment), Self);
	PawnOwner.ClearTimer(nameof(self.StartFollowerTurn), Self);

	// Take care of the hostage  if he's still around
	if( Follower != None && !Follower.bDeleteMe  )
	{
		// We're now expecting the follower to leave his special move
		bWantFollowerToLeaveHisSpecialMove = TRUE;
		Follower.Mesh.SetShadowParent(None);
		// Activate MeatShield Morph Target to prevent hostage clipping into kidnapper.
		Follower.SetActiveMeatShieldMorph(FALSE);

		// If the follower has been attached, detach it.
		if( Follower.Role == Role_Authority && !Follower.bPlayedDeath )
		{
			// If Follower is still in his followerspecialmove, end it
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
				// Otherwise if kidnapper was killed, then hostage is revived
				else
				{
					if( Follower.IsBasedOn(PawnOwner) )
					{
						// Detach Follower from Leader.
						DetachPawn(Follower);
					}
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

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

/**
 * Hostage is leaving his special move, catch cases where we didn't expect this from hapening
 * This could happen when the hostage logs out, types 'suicice', or is killed by some other way.
 */
function OnFollowerLeavingSpecialMove()
{
	if( !bWantFollowerToLeaveHisSpecialMove )
	{
		bWantFollowerToLeaveHisSpecialMove = TRUE;

		// Handle this from the server.
		if( PawnOwner.Role == Role_Authority )
		{
			PawnOwner.ServerEndSpecialMove(PawnOwner.SpecialMove);
		}
	}
}

defaultproperties
{
	bShouldAbortWeaponReload=FALSE
	bCanFireWeapon=FALSE
	bDisableLook=FALSE
	bDisallowDBNO=true

	bDisableMovement=TRUE
	bLockPawnRotation=TRUE

	MarkerOffset=(X=125.46,Y=0.00,Z=0.00)
	FollowerSpecialMove=GSM_DragInjured_Follower
	BS_LeaderGrab=(Stance=((Slot=BS_FullBody,AnimName="Kidnapper_Grab_DBNO")))
	BS_FollowerGrab=(Stance=((Slot=BS_FullBody,AnimName="Hostage_Grab_DBNO")))
	BS_PistolReload=(Stance=((Slot=BS_Std_Up,AnimName="carrier_reload")))
	BS_PistolReloadFail=(Stance=((Slot=BS_Std_Up,AnimName="carrier_reload_fail")))
	BS_PistolMelee=(Stance=((Slot=BS_Std_Up,AnimName="carrier_melee")))
	bPlaySimplePistolReload=TRUE
}
