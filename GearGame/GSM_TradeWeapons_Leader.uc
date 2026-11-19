
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_TradeWeapons_Leader extends GSM_InteractionPawnLeader_Base
	native(SpecialMoves);

/** Struct to store dueling animations. They are sync'd animations working in pairs. */
struct native BSInteractionAnim
{
	var()	BodyStance	Leader;
	var()	BodyStance	Follower;
};

var BSInteractionAnim InteractionAnim;

// only used in server
var transient bool    TradeDone;

var transient GearWeapon OldLeaderWeapon;
var transient GearWeapon OldFollowerWeapon;
/** Sound Cue **/
var SoundCue ThrowCue;
var SoundCue CatchCue;
var SoundCue MixCue;
/** are we playing toss animation - this only use toss for AI **/
var transient bool PlayTossAnimation;

/** Interpolate Give's (right/left) socket to Receiver's (right/left) socket and return the bone's desired transform **/
/** if UseGiverRightHand == TRUE, it will use right hand socket, otherwise, it will use lefthand **/
/** Alpha is interpolation amount from givers to receivers **/
simulated final native function vector InterpolatedPoints(GearPawn Giver, bool UseGiverRightHand, GearPawn Receiver, bool UseReceiverRightHand, FLOAT Alpha, out Rotator DesiredRotation);

/**
 * Determine if a pawn has a given weapon and verify it's not a stale slave weapon
 * 
 * @param GP - the pawn to inspect
 * 
 * @param GW - the weapon we're looking for
 * 
 * @return TRUE if the weapon is in the pawn's inventory
 */
function bool PawnHasWeapon(GearPawn GP, class<GearWeapon> GWC)
{
	local GearWeapon GW;

	GW = GearWeapon(GP.InvManager.FindInventoryType(GWC));

	// A stale slave weapon will be in EASlot_None
	if (GW != None && GW.CharacterSlot != EASlot_None)
	{
		return TRUE;
	}

	return FALSE;
}

/**
 * Do we have out an acceptable weapon and is there a nearby friendly offering his weapon?
 *
 * @return true if there is
 */
protected function bool InternalCanDoSpecialMove()
{
	local GearPawn GP;

	if (PawnOwner.IsDoingASpecialMove())
	{
		return FALSE;
	}

	if (PawnOwner.IsInCover() || PawnOwner.IsDBNO())
	{
		return FALSE;
	}

	if (PawnOwner.IsCarryingAHeavyWeapon())
	{
		return FALSE;
	}

	if (PawnOwner.MyGearWeapon != None && PawnOwner.MyGearWeapon.CharacterSlot != EASlot_RightShoulder && PawnOwner.MyGearWeapon.CharacterSlot != EASlot_LeftShoulder)
	{
		return FALSE;
	}

	foreach PawnOwner.VisibleCollidingActors(class'GearPawn', GP, PawnOwner.CoopInteractionDistance, PawnOwner.Location, TRUE)
	{
		if (PawnOwner.IsSameTeam(GP) && GP.IsDoingSpecialMove(SM_TradeWeapons) && vector(PawnOwner.Rotation) dot Normal(GP.Location - PawnOwner.Location) > 0)
		{
			// Make sure we don't already have the weapon being traded and that we have a unique offering (or nothing to give)
			if (PawnOwner.InvManager.FindInventoryType(GP.MyGearWeapon.Class) == None && (PawnOwner.MyGearWeapon == None || !PawnHasWeapon(GP, PawnOwner.MyGearWeapon.Class)))
			{
				return TRUE;
			}
		}
	}

	return FALSE;
}

 function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
 {
	// if server, reset variable
	if (PawnOwner.Role==Role_Authority)
	{
		TradeDone = FALSE;
	}

	if (PawnOwner.SpecialMoveFlags == 1)
	{
		PlayTossAnimation = FALSE;
	}
	else
	{
		PlayTossAnimation = TRUE;
	}

	// notify guds
	if (PawnOwner.WorldInfo.Game != None)
	{
		GearGame(PawnOwner.WorldInfo.Game).TriggerGUDEvent(GUDEvent_SwapWeaponsAccepted, PawnOwner);
	}

	Super.SpecialMoveStarted(bForced, PrevMove);
 }

function TradeWeapons()
{
	`LogSMExt(PawnOwner, "");

	if ( PawnOwner.Role == ROLE_Authority && TradeDone == FALSE )
	{
		// only server does this
		PawnOwner.ServerTradeWeapon(Follower);
		TradeDone = TRUE;
	}
}

function StartInteraction()
{
	`LogSMExt(PawnOwner, `showvar(PlayTossAnimation));

	if ( PlayTossAnimation )
	{
		// test just equip animation
		AlignDistance = VSize(PawnOwner.Location-Follower.Location);
		InteractionAnim.Leader.Stance[BS_FullBody].AnimName = 'AR_TradeWeapons_NPC1';
		InteractionAnim.Follower.Stance[BS_FullBody].AnimName = 'AR_TradeWeapons_NPC2';
	}
	else
	{
		AlignDistance = 75;
		InteractionAnim.Leader.Stance[BS_FullBody].AnimName = 'AR_TradeWeapons_Close';
		InteractionAnim.Follower.Stance[BS_FullBody].AnimName = 'AR_TradeWeapons_Close';
	}

	PawnOwner.BS_Play(InteractionAnim.Leader, 1.f, 0.25f, 0.25f);
	PawnOwner.BS_SetAnimEndNotify(InteractionAnim.Leader, TRUE);
 
	Follower.BS_Play(InteractionAnim.Follower, 1.f, 0.25f, 0.25f);
	Follower.BS_SetAnimEndNotify(InteractionAnim.Follower, TRUE);

	// Not 100% accurate but server will fix things later
	if (PawnOwner.Role != ROLE_Authority)
	{
		Follower.WeaponForWeaponSwap = Follower.MyGearWeapon;
	}

	if (!PawnHasWeapon(PawnOwner, Follower.WeaponForWeaponSwap.Class))
	{
		OldLeaderWeapon = PawnOwner.MyGearWeapon;
	}

	OldFollowerWeapon = Follower.WeaponForWeaponSwap;

	// if I don't send them inactive, replication will cause problem
	if (OldLeaderWeapon != None)
	{
		OldLeaderWeapon.GotoState('InActive');
	}

	OldFollowerWeapon.GotoState('InActive');
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	`LogSMExt(PawnOwner, `showvar(OldLeaderWeapon) @ `showvar(OldFollowerWeapon));

	PawnOwner.ZeroMovementVariables();
	Follower.ZeroMovementVariables();

	// Failsafe detach the old weapons, network conditions may cause the animation attach to occur
	//  after the server has told us to DetachWeapon() in ClientWeaponThrown()
	if (OldLeaderWeapon != None)
	{
		OldLeaderWeapon.DetachWeapon();
	}

	if (OldFollowerWeapon != None)
	{
		OldFollowerWeapon.DetachWeapon();
	}

	// Always trade weapons, the animation may not complete if one of the players dies
	TradeWeapons();

	// Make the AI choose whichever weapon they have left
	if (AIController(PawnOwner.Controller) != None && PawnOwner.Weapon == None)
	{
		GearInventoryManager(PawnOwner.InvManager).SetWeaponFromSlot(EASlot_RightShoulder);
		GearInventoryManager(PawnOwner.InvManager).SetWeaponFromSlot(EASlot_LeftShoulder);
	}
	if (AIController(Follower.Controller) != None && Follower.Weapon == None)
	{
		GearInventoryManager(Follower.InvManager).SetWeaponFromSlot(EASlot_RightShoulder);
		GearInventoryManager(Follower.InvManager).SetWeaponFromSlot(EASlot_LeftShoulder);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

function AnimNotify(AnimNodeSequence SeqNode, GearAnimNotify_SpecialMove NotifyObject)
{
	local GearPawn Leader;

	// ideally this is just cosmetic, nothing happened yet
	Leader = PawnOwner; 

	// attach Leader weapon to left bone
	if (NotifyObject.Info == 'SwapToLeftWeapBone')
	{
		if (OldLeaderWeapon != None)
		{
			OldLeaderWeapon.DetachWeapon();
			OldLeaderWeapon.AttachWeaponTo(Leader.Mesh, Leader.GetLeftHandSocketName());
		}
	}
	else if (NotifyObject.Info == 'DetachWeapon')
	{
		// detach from follower and attach to leader
		OldFollowerWeapon.DetachWeapon();
	
		if (OldLeaderWeapon != None)
		{
 			// detach from leader and attach to follower
			OldLeaderWeapon.DetachWeapon();
		}

		PlayMix();
	}
	else if (NotifyObject.Info == 'AttachWeapon')
	{
		// if you attach here, client doesn't like it. 
		// so instead of that, I trade at this point from server
		// there could be delay and latency for client to update, 
		// but from testing, it seems to work fine. Will come back to it when this becomes problem
//		OldFollowerWeapon.AttachWeaponTo(PawnOwner.Mesh, PawnOwner.GetRightHandSocketName());
//		OldLeaderWeapon.AttachWeaponTo(Follower.Mesh, Follower.GetRightHandSocketName());
		TradeWeapons();
	}

	Super.AnimNotify(SeqNode, NotifyObject);
}

simulated function DebugPause()
{
//	PCOwner.ConsoleCommand("Pause");
}

function DebugDrawSockets()
{
// 	local vector SocketLoc;
// 
// 	PawnOwner.Mesh.GetSocketWorldLocationAndRotation('RightHand', SocketLoc);
// 	PawnOwner.DrawDebugSphere(SocketLoc, 10, 2, 0, 0, 255, TRUE);
// 	PawnOwner.Mesh.GetSocketWorldLocationAndRotation('LeftHand', SocketLoc);
// 	PawnOwner.DrawDebugSphere(SocketLoc, 10, 2, 255, 0, 0, TRUE);
// 
// 	Follower.Mesh.GetSocketWorldLocationAndRotation('RightHand', SocketLoc);
// 	Follower.DrawDebugSphere(SocketLoc, 10, 2, 255, 255, 0, TRUE);
// 	Follower.Mesh.GetSocketWorldLocationAndRotation('LeftHand', SocketLoc);
// 	Follower.DrawDebugSphere(SocketLoc, 10, 2, 0, 0, 255, TRUE);
}

/** Notification when Follower is leaving his FollowerSpecialMove */
function OnFollowerLeavingSpecialMove()
{
	`LogSMExt(PawnOwner, "");

	PawnOwner.ZeroMovementVariables();
	Follower.ZeroMovementVariables();

	// if follower is still doing move, finish it
	if( PawnOwner.WorldInfo.NetMode != NM_Client )
	{
		PawnOwner.ServerEndSpecialMove(SM_TradeWeapons_Leader);
	}
}

/** Toss Animation notifiers **/
simulated function LeaderWeaponStart()
{
	local name BoneName;

	PlayThrow(PawnOwner);

	BoneName = PawnOwner.Mesh.GetSocketBoneName(PawnOwner.GetLeftHandSocketName());
	// assuming we don't have any relative loc/rot
	// if we do, we need to apply inverse matrix to get right location
	// for now we only try translation
	PawnOwner.LeftWeaponBone.BoneTranslation = PawnOwner.Mesh.GetBoneLocation(BoneName);

	PawnOwner.LeftWeaponBone.SetSkelControlStrength(1.0, 0.01);

	DebugDrawSockets();
	DebugPause();
}

simulated function LeaderWeaponLoop(FLOAT CurrentTime, FLOAT TotalDuration)
{
	local float Alpha;
	local vector DesiredPos;
	local rotator DesiredRotation;

	//`log("Leader Loop -"@CurrentTime@"-"@TotalDuration);
	Alpha = FClamp(CurrentTime/TotalDuration, 0.0f, 1.0f);
	DesiredPos = InterpolatedPoints(PawnOwner, FALSE, Follower, TRUE, Alpha, DesiredRotation);

	PawnOwner.LeftWeaponBone.bApplyTranslation = TRUE;
	PawnOwner.LeftWeaponBone.BoneTranslation = DesiredPos;
	PawnOwner.LeftWeaponBone.bApplyRotation = TRUE;
	PawnOwner.LeftWeaponBone.BoneRotation = DesiredRotation;
	DebugDrawSockets();
	DebugPause();
}

simulated function GiveWeaponToFollower()
{	
	if (OldLeaderWeapon != None)
	{
		OldLeaderWeapon.DetachWeapon();
		OldLeaderWeapon.AttachWeaponTo(Follower.Mesh, Follower.GetRightHandSocketName());
		//OldLeaderWeapon.SetOwner(Follower);
		// if you don't send it to 'InActive' state, client will cause trouble
		// since it has different two instances, it will send to putting down state, 
		// this causes weapon to be not activated and removed at the end
		OldLeaderWeapon.GotoState('InActive');
	}
}

simulated function GiveWeaponToLeader()
{
	// detach from follower and attach to leader
	OldFollowerWeapon.DetachWeapon();
	OldFollowerWeapon.AttachWeaponTo(PawnOwner.Mesh, PawnOwner.GetRightHandSocketName());

	if (OldLeaderWeapon != None)
	{
		// make sure leader weapon is still on left socket
		// in client, it keeps coming back to right hand
		OldLeaderWeapon.AttachWeaponTo(PawnOwner.Mesh, PawnOwner.GetLeftHandSocketName());
	}

	// if you don't send it to 'InActive' state, client will cause trouble
	// since it has different two instances, it will send to putting down state, 
	// this causes weapon to be not activated and removed at the end
	// doing this earlier now
	//OldFollowerWeapon.GotoState('InActive');
	//OldFollowerWeapon.SetOwner(PawnOwner);
}

/** Script Tick function. */
// function Tick(float DeltaTime)
// {
// 	if (PawnOwner.Mesh.IsComponentAttached(OldLeaderWeapon.Mesh))
// 	{
// 		`log("PawnOwner("@PawnOwner@") has own weapon:"@OldLeaderWeapon);
// 	}
// 	if (PawnOwner.Mesh.IsComponentAttached(OldFollowerWeapon.Mesh))
// 	{
// 		`log("PawnOwner("@PawnOwner@") has follower weapon:"@OldFollowerWeapon);
// 	}
// 	if (Follower.Mesh.IsComponentAttached(OldLeaderWeapon.Mesh))
// 	{
// 		`log("Follower("@Follower@") has leader weapon:"@OldLeaderWeapon);
// 	}
// 
// 	if (Follower.Mesh.IsComponentAttached(OldFollowerWeapon.Mesh))
// 	{
// 		`log("Follower("@Follower@") has own weapon:"@OldFollowerWeapon);
// 	}
// 
// 	`log("PawnOwner has MyGearweapon:"@PawnOwner.MyGearWeapon);
// 	`log("Follower has MyGearweapon:"@Follower.MyGearWeapon);
// }

simulated function LeaderWeaponEnd()
{
	PlayCatch(Follower);
	GiveWeaponToFollower();
	PawnOwner.LeftWeaponBone.bApplyTranslation = FALSE;
	PawnOwner.LeftWeaponBone.bApplyRotation = FALSE;
	PawnOwner.LeftWeaponBone.BoneTranslation = vect(0,0,0);
	PawnOwner.LeftWeaponBone.SetSkelControlStrength(0.0, 0.01);

	TradeWeapons();
	DebugDrawSockets();
	DebugPause();
}

simulated function FollowerWeaponStart()
{
	local name RightBone;

	PawnOwner.FlushPersistentDebugLines();
	PlayThrow(Follower);
	//`log("FollowerWeapon Start -"@Notifier.CurrentTime/Notifier.TotalDuration);

	// follower weapon comes to leader
	// this moves from follower right hand to leader right hand
	// target location - leader right bone
	// moving bone - follower right bone
	// initialize skelsinglebone location
	RightBone = Follower.Mesh.GetSocketBoneName(Follower.GetRightHandSocketName());
	// assuming we don't have any relative loc/rot
	// if we do, we need to apply inverse matrix to get right location
	// for now we only try translation
	Follower.RightWeaponBone.BoneTranslation = Follower.Mesh.GetBoneLocation(RightBone);

	Follower.RightWeaponBone.SetSkelControlStrength(1.0, 0.01);
	DebugDrawSockets();
	DebugPause();
}

simulated function FollowerWeaponLoop(FLOAT CurrentTime, FLOAT TotalDuration)
{
	local vector DesiredPos;
	local float Alpha;
	local rotator DesiredRotation;

	Alpha = FClamp(CurrentTime/TotalDuration, 0.0f, 1.0f);

	//`log("FollowerWeapon Loop -"@CurrentTime@"-"@TotalDuration);
	// interpolatea

	DesiredPos = InterpolatedPoints(Follower, TRUE, PawnOwner, TRUE, Alpha, DesiredRotation);

	Follower.RightWeaponBone.bApplyTranslation = TRUE;
	Follower.RightWeaponBone.BoneTranslation = DesiredPos;
	Follower.RightWeaponBone.bApplyRotation = TRUE;
	Follower.RightWeaponBone.BoneRotation = DesiredRotation;

	DebugDrawSockets();
	DebugPause();
}

simulated function FollowerWeaponEnd()
{
	//`log("FollowerWeapon End -"@Notifier.CurrentTime/Notifier.TotalDuration);
	PlayCatch(PawnOwner);
	GiveWeaponToLeader();

	Follower.RightWeaponBone.bApplyTranslation = FALSE;
	Follower.RightWeaponBone.bApplyRotation = FALSE;
	Follower.RightWeaponBone.BoneTranslation = vect(0,0,0);
	Follower.RightWeaponBone.SetSkelControlStrength(0.0, 0.01);
	DebugDrawSockets();
	DebugPause();
}

/** Play Sound functions **/
simulated function PlayMix()
{
	PawnOwner.PlaySound(MixCue);
}

simulated function PlayThrow(GearPawn Owner)
{
	Owner.PlaySound(ThrowCue);
}

simulated function PlayCatch(GearPawn Owner)
{
	Owner.PlaySound(CatchCue);
}

defaultproperties
{
	InteractionAnim = (Leader=(Stance=((Slot=BS_FullBody,AnimName="AR_TradeWeapons_Close"))), Follower=(Stance=((Slot=BS_FullBody,AnimName="AR_TradeWeapons_Close"))))

	bDisablePOIs=TRUE
	bAlignPawns=TRUE

	FollowerSpecialMove=SM_TradeWeapons_Follower

	ThrowCue = SoundCue'Foley_BodyMoves.TradeWeapons.TradeWeapons_ThrowCue'
	CatchCue = SoundCue'Foley_BodyMoves.TradeWeapons.TradeWeapons_CatchCue' 
	MixCue = SoundCue'Foley_BodyMoves.TradeWeapons.TradeWeapons_MixCue' 
	
	Action={(
		ActionName=TradeWeapons,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=83,V=0,UL=45,VL=32))),     // b button
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=242,V=0,UL=58,VL=55))) ) // swap arrows
		)}
}
