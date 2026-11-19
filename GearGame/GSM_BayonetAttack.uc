
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_BayonetAttack extends GSM_InstantKillLeader_Base
	native(SpecialMoves);

/** Play attack from behind animation */
var bool				bAttackFromBehind;

/** Struct to store dueling animations. They are sync'd animations working in pairs. */
struct native BayonetAnim
{
	var()	BodyStance	    Leader;
	var()	BodyStance	    Follower;
};

/** Attach bone information - mostly for interpolation**/
var   Name            AttachBone;
var   vector          AttachBoneOffset;
var   rotator         AttachBoneRotator;
var   float           BlendInTime;
var transient float     CurrentBlendInTime;

/** Height based animations for front chainsaw attack, back and duel */
var BayonetAnim		FrontAttack, BackAttack;

/** Played Chainsaw height based animation */
var	BayonetAnim	PlayedAnim;
/** TRUE if we're playing a chainsaw height based animation */
var bool			bPlayingBayonetAnim;


/** whether we killed someone in ragdoll (so use anim that's closer to the ground) */
var bool bVictimWasKnockedDown;

// Camera Anims
var Array<CameraAnim>	FrontAttackCameraAnims, BackAttackCameraAnims;

var ParticleSystem      BloodEffect, LambentBloodEffect;

/** Kick/KickBack Anim for Lambent **/
var array<BodyStance>	    AttackerKickAnims;
var array<BodyStance>   	VictimKickBackAnims;
var transient BodyStance   	PlayedKickBackAnim;
var transient bool 		PlayKick;

/** Running speed/animation play rate modifier for single-player only */
var() config float SPSpeedModifier;

// C++ functions
cpptext
{
	virtual void PrePerformPhysics(FLOAT DeltaTime);
}

protected function bool InternalCanDoSpecialMove()
{
	// extra check to avoid potential weapon swap chainsaw exploits
	if (PawnOwner == None || GearWeap_RetroLancer(PawnOwner.Weapon) == None)
	{
		return FALSE;
	}
	return Super.InternalCanDoSpecialMove();
}

function bool CanInteractWithPawn(GearPawn OtherPawn)
{
	local float BayonetDuelFacingDotAngle;
	local vector LookDir;
	local vector PlayerDir;

	if (OtherPawn == None)
	{
		return false;
	}

	// if dead or dueling, then disallow instigating a new attack
	if (PawnOwner.Health <= 0 )
	{
		return false;
	}

	// if target is dead or dueling, then disallow instigating attack
	if (OtherPawn.Health <= 0 )
	{
		return false;
	}

	// ignore pawns doing dodge moves, unless they're dodging into us
	if (OtherPawn.IsDoingADodgeMove() && Normal(OtherPawn.Velocity) dot Normal(PawnOwner.Location - OtherPawn.Location) < 0.707) // ~45 degrees
	{
		return false;
	}

	// if target is being executed, don't do it
	if ( OtherPawn.IsBeingExecuted() )
	{
		return false;
	}

	if (!OtherPawn.CanBeBayonetAttacked())
	{
		return false;
	}

	// ignore invalid melee targets
	if (!PawnOwner.TargetIsValidMeleeTarget(OtherPawn, true, 1.25) || !OtherPawn.CanBeSpecialMeleeAttacked(PawnOwner) || !OtherPawn.CanBeChainsawAttacked())
	{
		return false;
	}

	// no chainsaw dueling if same team, even with friendly fire
	if (PawnOwner.GetTeamNum() == OtherPawn.GetTeamNum() && !OtherPawn.IsAHostage())
	{
		return false;
	}

	// ignore god mode targets
	if (OtherPawn.Controller != None && OtherPawn.Controller.bGodMode)
	{
		return false;
	}

	// if in single player, don't allow COG AI to be chainsawed unless DBNO
	if ( OtherPawn.Controller != None &&
		!OtherPawn.IsHumanControlled() && !OtherPawn.IsDBNO() && OtherPawn.GetTeamNum() == 0 &&
		GearGameSP_Base(OtherPawn.WorldInfo.Game) != None )
	{
		return false;
	}

	// Players facing each other test. Turn angle in degres to the result of a dot product.
	BayonetDuelFacingDotAngle = 0.f;

	// Test if we're facing the Other Pawn
	LookDir		= Vector(PawnOwner.GetBaseAimRotation());
	LookDir.Z	= 0.f;
	PlayerDir	= OtherPawn.Location - PawnOwner.Location;
	PlayerDir.Z = 0.f;
	if( (Normal(PlayerDir) dot Normal(LookDir)) < BayonetDuelFacingDotAngle )
	{
		return false;
	}

	// Kidnappers... Bayonet Hostage if taken from the front.
	if( OtherPawn.IsAKidnapper() )
	{
		PlayerDir	= Vector(OtherPawn.Rotation);
		PlayerDir.Z = 0.f;

		if( (Normal(PlayerDir) dot Normal(LookDir)) < 0.f )
		{
			return false;
		}
	}

	// Hostages... Bayonet Kidnapper if taken from the back
	if( OtherPawn.IsAHostage() )
	{
		PlayerDir	= Vector(OtherPawn.Rotation);
		PlayerDir.Z = 0.f;

		if( (Normal(PlayerDir) dot Normal(LookDir)) >= 0.f )
		{
			return false;
		}
	}

	// all good
	return true;
}

/** Notification forwarded by GearAnimNotify_SpecialMove */
function AnimNotify(AnimNodeSequence SeqNode, GearAnimNotify_SpecialMove NotifyObject)
{
	if (NotifyObject.Info == 'SplashBayonetBloodOnScreen')
	{
		SplashBayonetBloodOnScreen();
		return;
	}
	else if (NotifyObject.Info == 'SpawnFX')
	{
		// spawn FX
		SpawnParticle((Follower != None && GearPawnFX_Lambent(Follower.GearPawnFX) != None) ? LambentBloodEffect : BloodEffect);
		return;
	}
	else if (NotifyObject.Info == 'KickPlayer')
	{
		// Kill Victim
		if ( PlayKick )
		{
			// play kick animation
			PlayKickAnimation();
		}
		return;
	}
	Super.AnimNotify(SeqNode, NotifyObject);
}

// Play attacker kick animation
function PlayKickAnimation()
{
	local float AnimLength;
	local BodyStance KickAnim;

	BayonetAnimEnd(TRUE);

	if (bAttackFromBehind)
	{
		KickAnim = AttackerKickAnims[EBackAttack];
	}
	else
	{
		KickAnim = AttackerKickAnims[EFrontAttack];
	}

	bPlayingBayonetAnim = FALSE;

	AnimLength = PawnOwner.BS_Play(KickAnim, SpeedModifier, SpeedModifier*0.25f, SpeedModifier*0.25f, FALSE);

	// If AnimLength is 0, it means the animation could not be found. So it's not safe to put a notify on it.
	if( AnimLength > 0.f )
	{
		// now kick is playing, play kickback anims
		PlayKickedBackAnimation();
	}
	else
	{
		DetachAndKillVictim(FALSE);
	}
}

// play victim's kick back animation
function PlayKickedBackAnimation()
{
	local float AnimLength;
	local GearAI FollowerAI;

	if (bAttackFromBehind)
	{
		PlayedKickBackAnim = VictimKickBackAnims[EBackAttack];
	}
	else
	{
		PlayedKickBackAnim = VictimKickBackAnims[EFrontAttack];
	}

	FollowerAI = GearAI(Follower.Controller);
	if ( FollowerAI!=none )
	{
		// turn off ledge check, so that it can fly away on ledge
		FollowerAI.bWantsLedgeCheck = FALSE;
	}

	AnimLength = Follower.BS_Play(PlayedKickBackAnim, SpeedModifier, SpeedModifier*0.25f, SpeedModifier*0.25f, FALSE);

	// If AnimLength is 0, it means the animation could not be found. So it's not safe to put a notify on it.
	if( AnimLength > 0.f )
	{

		Follower.Mesh.RootMotionAccelScale = vect(3, 3, 1);
		// Have animation root motion.
		Follower.BS_SetRootBoneAxisOptions(PlayedKickBackAnim, RBA_Translate, RBA_Translate);
		// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
		Follower.Mesh.RootMotionMode = RMM_Accel;
		// Finish a little bit earlier so that victim doesn't blend back to idle (standing up pose)
		PawnOwner.SetTimer(AnimLength-0.2f, FALSE, nameof(self.ClearKickedBackAnimation), self);
	}
	else
	{
		// finish this SM
		BayonetAnimEnd();
	}
}

// clear kick back info and finish this
function ClearKickedBackAnimation()
{
	// Turn off Root motion on animation node
	Follower.Mesh.RootMotionAccelScale = Vect(1,1,1);
	Follower.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
	Follower.BS_SetRootBoneAxisOptions(PlayedKickBackAnim, RBA_Discard, RBA_Discard, RBA_Discard);
	// Turn off anim end notify
	PawnOwner.BS_SetAnimEndNotify(PlayedKickBackAnim, FALSE);

	// finish this SM
	BayonetAnimEnd();
}

function SpawnParticle( const ParticleSystem PS )
{
	local vector Loc;
	local rotator Rot;
	local ParticleSystemComponent PSC;

	if( !PawnOwner.EffectIsRelevant(PawnOwner.Location, false, 1000.0, 200.0) )
	{
		return;
	}

	if (PawnOwner.WorldInfo.GRI.ShouldShowGore())
	{
		PawnOwner.Mesh.GetSocketWorldLocationAndRotation( 'RightHand', Loc, Rot );
		PSC = PawnOwner.WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(PS, PawnOwner.Mesh, 'RightHand', TRUE);
		PSC.SetLODLevel(GearGRI(PawnOwner.WorldInfo.GRI).GetLODLevelToUse(PSC.Template, Loc));
	}
}
/** Splash some blood on the screen! - used by anim notifies **/
function SplashBayonetBloodOnScreen()
{
	if (PawnOwner != None)
	{
		PawnOwner.SplashBayonetCameraBlood();
	}
}

/**
 * Pack flags needed for chainsaw attack special move.
 * These are replicated so they're consistent on all netmodes.
 */
static function INT PackBayonetAttackFlags(optional GearPawn Attacker, optional GearPawn Victim)
{
	local INT		PackedFlags;
	local Vector	AttackerDir, VictimDir;
	local bool		bInAttackFromBehind;

	// If not from a duel and chainsawing a pawn, figure out if we're doing the chainsaw from behind animation
	if(Attacker != None && Victim != None )
	{
		AttackerDir = Vector(Attacker.GetBaseAimRotation());
		VictimDir = Vector(Victim.Rotation);
		AttackerDir.Z = 0.f;
		VictimDir.Z = 0.f;

		if( (Normal(AttackerDir) dot Normal(VictimDir)) > 0 )
		{
			bInAttackFromBehind = TRUE;
		}
	}

	PackedFlags = int(bInAttackFromBehind);

	//`log(GetFuncName() @ "PackedFlags:" @ PackedFlags @ "bInFromDuel:" @ bInFromDuel @ "bInLeaderWonDuel:" @ bInLeaderWonDuel @ "bInAttackFromBehind:" @ bInAttackFromBehind);
	return PackedFlags;
}

/** Unpack Special move flags */
function UnpackSpecialMoveFlags()
{
	bAttackFromBehind = bool(PawnOwner.SpecialMoveFlags & 1);

	//`log(GetFuncName() @ "PackedFlags:" @ PawnOwner.SpecialMoveFlags @ "bFromDuel:" @ bFromDuel @ "bLeaderWonDuel:" @ bLeaderWonDuel @ "bAttackFromBehind:" @ bAttackFromBehind);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearWeap_RetroLancer Rifle;
	local bool bVictimWasHostage;

	bAlignPawns = TRUE;
	bAlignLeaderRotation=FALSE;
	bAlignFollowerRotation=FALSE;

	// Reset variables
	bPlayingBayonetAnim = FALSE;
	bVictimWasKnockedDown = ( PawnOwner.InteractionPawn.Physics == PHYS_RigidBody ||
				(PawnOwner.PreviousSpecialMove == SM_RecoverFromRagdoll && PawnOwner.Mesh.PhysicsWeight > 0.5) );

	bVictimWasHostage = PawnOwner.InteractionPawn.IsAHostage();

	// Unpack SpecialMove flags
	UnpackSpecialMoveFlags();

	Super.SpecialMoveStarted(bForced, PrevMove);
	if ( PawnOwner.WorldInfo.NetMode != NM_Client && Follower.bShouldChainsawAttackInstantKillMe && !bVictimWasHostage &&
		Follower.IsGameplayRelevant() && GearPRI(Follower.PlayerReplicationInfo) != None )
	{
		// and award the execution
		if (!Follower.bWasDBNO)
		{
			// translate the remaining health as damage done
			GearPRI(Follower.PlayerReplicationInfo).ScoreHit(GearPRI(PawnOwner.PlayerReplicationInfo), Follower.DefaultHealth, Follower.Health, Follower.Health, class'GDT_Bayonet', PawnOwner);
			// and insta kill
			GearPRI(PawnOwner.PlayerReplicationInfo).ScoreInstantKill(GearPRI(Follower.PlayerReplicationInfo), class'GDT_Bayonet', GDT_NORMAL);
		}
		else
		{
			// otherwise it's just an execution
			GearPRI(PawnOwner.PlayerReplicationInfo).ScoreExecution(GearPRI(Follower.PlayerReplicationInfo), class'GDT_Bayonet', GDT_NORMAL);
		}
 	}

	PawnOwner.SoundGroup.PlayEffortEx(PawnOwner, GearEffort_BayonetCharge, 0.0);

	if(Pawnowner.MyGearAI != none)
	{
		Pawnowner.MyGearAI.DoMeleeAttack();
	}

	// make sure the weapon stays selected
	if (PawnOwner.IsLocallyControlled())
	{
		Rifle = GearWeap_RetroLancer(PawnOwner.FindInventoryType(class'GearWeap_RetroLancer', true));
		if (Rifle != None && (PawnOwner.Weapon != Rifle || PawnOwner.InvManager.PendingWeapon != None))
		{
			PawnOwner.InvManager.SetCurrentWeapon(Rifle);
		}
	}

// test debug functions for special case testing
//	PawnOwner.SetTimer(FRand()*2.f, FALSE, nameOf(self.TestFunction), self);
}

// test debug functions for special case testing
//function TestFunction()
//{
//	if (Follower!=none)
//	{
//		Follower.Died(Follower.Controller, class'GDT_Suicide', Follower.Location);
//	}
//}

function StartInteraction()
{
	bAlignPawns = FALSE;
	bAlignLeaderRotation=FALSE;
	bAlignFollowerRotation=FALSE;

	// Check if the follower should be kicked after the chainsawing
	PlayKick = Follower.bWantChainsawKick;

	// If we're going to kill this Pawn, make sure we're the only ones triggering the kill
	if( Follower.bShouldChainsawAttackInstantKillMe )
	{
		Follower.SpecialMoves[Follower.SpecialMove].bOnlyInteractionPawnCanDamageMe = TRUE;
	}

	// clear movement
	PawnOwner.ZeroMovementVariables();

	if( bAttackFromBehind )
	{
		PlayBayonetAnim(BackAttack);
		// For now play CameraAnim randomly. It should eventually handle collision.
		PlayExecutionCameraAnim(BackAttackCameraAnims);
		bAlignFollowerLookSameDirAsMe = TRUE;
	}
	// Front attack
	else
	{
		PlayBayonetAnim(FrontAttack);
		// Play execution Camera Animation.
		PlayExecutionCameraAnim(FrontAttackCameraAnims);
		bAlignFollowerLookSameDirAsMe = FALSE;
	}
}


function PlayBayonetAnim(BayonetAnim InBayonetAnim, optional bool bSkipVictim)
{
	local float PlaybackLength;
	local float AnimLength;

	// Save which animations we're playing
	PlayedAnim = InBayonetAnim;
	bPlayingBayonetAnim = true;

	AnimLength = SetBayonetAnims(PawnOwner, InBayonetAnim.Leader, 0.2);

	if (!bSkipVictim)
	{
		SetBayonetAnims(Follower, InBayonetAnim.Follower, 0.2);

		// Don't play a scream in Died()
		Follower.bDisableDeathScreams = true;
		Follower.SoundGroup.PlayEffort(Follower, GearEffort_BayonetImpaled, true, true);
	}


	PlaybackLength = AnimLength - 0.2;
	if (PlaybackLength > 0.0)
	{
		AwardBonusXP(PlaybackLength);
		PawnOwner.SetTimer(PlaybackLength, false, nameof(BayonetAnimEnd), self);
	}
	else
	{
		BayonetAnimEnd();
	}

	// calculate distance
	CurrentBlendInTime = 0.0;
}

function float SetBayonetAnims(GearPawn GP, BodyStance Anim, float BlendTime)
{
	local float AnimLength;
	if( GearGameSP_Base(GP.WorldInfo.Game) != None )
	{
		AnimLength = GP.BS_Play( Anim, SPSpeedModifier, 0.f, -0.1f );
	}
	else
	{
		AnimLength = GP.BS_Play( Anim, 1.f, 0.f, -0.1f );
	}
	return AnimLength;
}

function StopBayonetAnim()
{
	bPlayingBayonetAnim = FALSE;
	// Clear Timer just in case.
	PawnOwner.ClearTimer('BayonetAnimEnd', Self);

	PawnOwner.BS_Stop( PlayedAnim.Leader, 0.25f );
	Follower.BS_Stop( PlayedAnim.Follower, 0.25f );
}

function BayonetAnimEnd(optional bool bDoNotFinishSM)
{
	StopBayonetAnim();

	DetachPawn(Follower);

	if ( !bDoNotFinishSM )
	{
		DetachAndKillVictim(FALSE);

		// Stop special move if not already doinga so.
		if( !PawnOwner.bEndingSpecialMove )
		{
			PawnOwner.EndSpecialMove();
		}
	}
}

event UpdatePlayerPosition(float DeltaTime)
{
	// adjust relative location/rotation
	// I need to wait until now since I need to make sure animation is playing
	// if not, the player will attach to the other root since b_MF_Attach is still on root
	if ( bPlayingBayonetAnim && CurrentBlendInTime == 0.f && Follower!=none )
	{
		// now animation is playing. Don't do this too early, follower will attach to root of attacker
		if (bAttackFromBehind)
		{
			AttachFollowerToLeader(AttachBone, -Follower.default.Mesh.Translation, MakeRotator(0, -16384, 0));
		}
		else
		{
			AttachFollowerToLeader(AttachBone, -Follower.default.Mesh.Translation, MakeRotator(0, 16384, 0));
		}
	}

	CurrentBlendInTime += DeltaTime;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	if ( bPlayingBayonetAnim )
	{
		StopBayonetAnim();
	}

	// if it didn't die yet, something went wrong
	DetachAndKillVictim(TRUE);

	// check to see if the player was holding fire
	if (PCOwner != None && PCOwner.IsLocalPlayerController() && PCOwner.IsButtonActive(GB_RightTrigger,TRUE))
	{
		PCOwner.bFire = 1;
	}

	// Trigger the pickup delegates in the GearPC
	if (PCOwner != None)
	{
		PCOwner.TriggerGearEventDelegates(eGED_BayonetKill);

		// also ensure melee adhesion is cleared
		PCOwner.StopMeleeAdhesion();
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

function DetachAndKillVictim(bool bInterrupted)
{
	if( Follower != None )
	{
		// if follower is based on current pawn, detach
		if (Follower.Base == PawnOwner)
		{
			DetachPawn(Follower);
		}

		// is follower still alive?
		if ( Follower.Health > 0 )
		{
			// clear, so that it doesnt' spawn gore explosion effect
			// looks so fake blood.
			Follower.BloodGoreExplosionTemplate = none;
			if( PawnOwner.WorldInfo.NetMode != NM_Client && Follower.IsGameplayRelevant() )
			{
				// Notification that the chainsaw attack ended.
				Follower.BayonetAttackedEndedNotification(PawnOwner);
				if( Follower.bShouldChainsawAttackInstantKillMe && !Follower.bUnlimitedHealth && !Follower.InGodMode() )
				{
					Follower.bPlayDeathAnimations = FALSE;
					Follower.TearOffMomentum = Normal(Follower.Location - PawnOwner.Location);
					Follower.KickPawnOffTurret();
					// if interrupted, gib it
					if (bInterrupted)
					{
						Follower.Died(PawnOwner.Controller, class'GDT_BayonetGib', Follower.Location);
					}
					else
					{
						Follower.Died(PawnOwner.Controller, class'GDT_Bayonet', Follower.Location);
					}
				}
				else
				{
					Follower.ServerEndSpecialMove(FollowerSpecialMove);
				}
			}
		}
	}
}

/** Notification when Follower is leaving his FollowerSpecialMove */
function OnFollowerLeavingSpecialMove()
{
	if( bPlayingBayonetAnim )
	{
		StopBayonetAnim();
	}

	// Make sure victim is detached and dead
	DetachAndKillVictim(TRUE);

	// If victim has been kicked out of her special move unintentionally, then abort attack.
	if( PawnOwner.WorldInfo.NetMode != NM_Client && !PawnOwner.bEndingSpecialMove )
	{
		PawnOwner.ServerEndSpecialMove();
	}
}

defaultproperties
{
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bAlignPawns=TRUE
	FollowerSpecialMove=SM_BayonetVictim

	FrontAttack=(Leader=(Stance=((Slot=BS_FullBody,AnimName="RL_Melee_Stab_Kill"))),Follower=(Stance=((Slot=BS_FullBody,AnimName="RL_Melee_Stab_Death_Front"))))
	FrontAttackCameraAnims(0)=CameraAnim'COG_MarcusFenix.Camera_Anims.RL_Melee_Stab_A_Cam01'

	BackAttack=(Leader=(Stance=((Slot=BS_FullBody,AnimName="RL_Melee_Stab_Kill"))),Follower=(Stance=((Slot=BS_FullBody,AnimName="RL_Melee_Stab_Death_Back"))))
	BackAttackCameraAnims(0)=CameraAnim'COG_MarcusFenix.Camera_Anims.RL_Melee_Stab_A_Cam01'

	AttachBone="b_MF_Attach"
	BlendInTime=0.3f

	bDisablePOIs=TRUE

	BloodEffect = ParticleSystem'Effects_Gameplay.Executions.P_Retro_Lancer_Charge_Stab'
	LambentBloodEffect = ParticleSystem'Effects_Gameplay.Executions.P_Retro_Lancer_Charge_Stab_Lambent'

	AttackerKickAnims(EFrontAttack)=(Stance=((Slot=BS_FullBody,AnimName="AR_Melee_Saw_Kick")))
	AttackerKickAnims(EBackAttack)=(Stance=((Slot=BS_FullBody,AnimName="AR_Melee_Saw_Behind_Kick")))
	VictimKickBackAnims(EFrontAttack)=(Stance=((Slot=BS_FullBody,AnimName="AR_Melee_Saw_Kick_Death")))
	VictimKickBackAnims(EBackAttack)=(Stance=((Slot=BS_FullBody,AnimName="AR_Melee_Saw_Behind_Kick_Death")))

	bUseUnsynchedServerMove = TRUE

	bAlignLeaderRotation=FALSE
	bAlignFollowerRotation=FALSE

	AlignDistance = 102
}
