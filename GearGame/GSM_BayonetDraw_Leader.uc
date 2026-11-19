
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_BayonetDraw_Leader extends GSM_CQC_Killer_Base;

/** Play attack from behind animation */
var bool				bAttackFromBehind;

/** Struct to store dueling animations. They are sync'd animations working in pairs. */
var()	BodyStance	    LeaderAnim, FollowerAnim;
/** Camera Anim **/
var Array<CameraAnim>	LeaderCameraAnims, FollowerCameraAnims;
/** Camera Effect **/
var ParticleSystem      BloodEffect, LambentBloodEffect;

/** Both of them are killed **/
var transient bool      bBothKilled;

var Array<CameraAnim>	AttackCameraAnims;

protected function bool InternalCanDoSpecialMove()
{
	// extra check to avoid potential weapon swap chainsaw exploits
	if (PawnOwner == None || GearWeap_RetroLancer(PawnOwner.Weapon) == None)
	{
		return FALSE;
	}
	if ( PawnOwner.SpecialMove != SM_RoadieRunStab )
	{
		return FALSE;
	}
	return TRUE;
}

function bool CanInteractWithPawn(GearPawn OtherPawn)
{
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

	// ignore pawns doing dodge moves. They can escape executions.
	if( OtherPawn.IsDoingADodgeMove() )
	{
		return false;
	}

	// if target is being executed, don't do it
	if ( OtherPawn.IsBeingExecuted() )
	{
		return false;
	}

	if (OtherPawn.SpecialMove != SM_RoadieRunStab)
	{
		return false;
	}

	// no chainsaw dueling if same team, even with friendly fire
	if (PawnOwner.GetTeamNum() == OtherPawn.GetTeamNum())
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
	else if (NotifyObject.Info == 'KillBoth')
	{
		KillAll();
		bBothKilled = TRUE;
	}

	Super.AnimNotify(SeqNode, NotifyObject);
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

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	bBothKilled = FALSE;

	Super.SpecialMoveStarted(bForced, PrevMove);

	PawnOwner.SoundGroup.PlayEffortEx(PawnOwner, GearEffort_BayonetCharge, 0.0);

	PawnOwner.SetTimer(0.2f, FALSE, nameof(StopAlignPawn), self);
}

function StartInteraction()
{
	Super.StartInteraction();

	AnimLength = PawnOwner.BS_Play( LeaderAnim, 1.f, 0.f, -0.1f );
	if (AnimLength <= 0.f)
	{
		BayonetAnimEnd();
		return;
	}

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(LeaderAnim, TRUE);
	// Have animation forward root motion.
	PawnOwner.BS_SetRootBoneAxisOptions(LeaderAnim, RBA_Translate, RBA_Translate, RBA_Translate);
	// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
	PawnOwner.Mesh.RootMotionMode = RMM_Translate;

	AnimLength = Follower.BS_Play( FollowerAnim, 1.f, 0.f, -0.1f );

	if (AnimLength > 0.f)
	{
		// Enable end of animation notification. This is going to call SpecialMoveEnded()
		Follower.BS_SetAnimEndNotify(FollowerAnim, TRUE);
		// Have animation forward root motion.
		Follower.BS_SetRootBoneAxisOptions(FollowerAnim, RBA_Translate, RBA_Translate, RBA_Translate);
		// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
		Follower.Mesh.RootMotionMode = RMM_Translate;
	}

	PlayExecutionCameraAnim(AttackCameraAnims);
}

/**
 * Special Execution version.
 * Test to play same animation on victim.
 * WARNING: * ForcePitchCentering not reset for Follower
 *			* Follower's ViewTarget is set to the Leader.
 *
 * @param InCameraAnims - the list of anims to choose from
 *
 * @param LeaderAnimInst - a reference to the anim played on the leader
 * 
 * @param bViewFromLeaderPOV - true to make followers see the execution from the leader's perspective, false otherwise
 * 
 * @return True if it played an anim, false otherwise.
 */
function bool PlayExecutionCameraAnim(out const array<CameraAnim> InCameraAnims, optional out CameraAnimInst LeaderAnimInst, optional float InBlendInTime=0.25f, optional float InBlendOutTime=0.25f)
{
	local GearPC	FollowerPC;
	local int		AnimIdx;
	local CameraAnimInst FollowerAnimInst;
	//local ViewTargetTransitionParams TransitionParams;
	
	FollowerPC = GearPC(Follower.Controller);

	if( PCOwner != None )
	{
		AnimIdx = PCOwner.ChooseRandomCameraAnim(InCameraAnims);
	} 
	else if ( FollowerPC != None ) 
	{
		AnimIdx = FollowerPC.ChooseRandomCameraAnim(InCameraAnims);
	}
	else
	{
		AnimIdx = INDEX_NONE;		 
	}

	if (AnimIdx != INDEX_NONE)
	{
		if (PawnOwner.IsLocallyControlled())
		{
			LeaderAnimInst = PlayCameraAnim(PawnOwner, InCameraAnims[AnimIdx],,, InBlendInTime, InBlendOutTime);
		}

		// If Follower is human controlled, have him spectate his death from the killer's perspective
		// Also play the death camera
		if( Follower.IsLocallyControlled() )
		{
			FollowerAnimInst = PlayCameraAnim(Follower, InCameraAnims[AnimIdx],,, InBlendInTime, InBlendOutTime);
		}
	}

	return (FollowerAnimInst != None) || (LeaderAnimInst != None);
}


function BayonetAnimEnd()
{
	// Clear Timer just in case.
	PawnOwner.ClearTimer('BayonetAnimEnd', Self);

	PawnOwner.BS_Stop( LeaderAnim, 0.25f );
	Follower.BS_Stop( FollowerAnim, 0.25f );
}

function StopAlignPawn()
{
	bAlignPawns = FALSE;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	PawnOwner.ClearTimer(nameof(StopAlignPawn), self);
	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(LeaderAnim, FALSE);
	// Have animation forward root motion.
	PawnOwner.BS_SetRootBoneAxisOptions(LeaderAnim, RBA_Default, RBA_Default, RBA_Default);
	// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;

	if (Follower != None)
	{
		// Enable end of animation notification. This is going to call SpecialMoveEnded()
		Follower.BS_SetAnimEndNotify(FollowerAnim, FALSE);
		// Have animation forward root motion.
		Follower.BS_SetRootBoneAxisOptions(FollowerAnim, RBA_Default, RBA_Default, RBA_Default);
		// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
		Follower.Mesh.RootMotionMode = Follower.default.Mesh.RootMotionMode;
	}

	if (!bBothKilled)
	{
		BayonetAnimEnd();
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

function PreKillVictim();

function KillAll()
{
	local GearPRI PawnOwnerPRI, VictimPRI;

	if ( PawnOwner.Role == ROLE_Authority )
	{
		// kill em both
		PawnOwnerPRI = GearPRI(PawnOwner.PlayerReplicationInfo);
		VictimPRI = GearPRI(Follower.PlayerReplicationInfo);

		// credit to us
		VictimPRI.ScoreHit(PawnOwnerPRI, Follower.DefaultHealth, Follower.Health, Follower.Health, class'GDT_Bayonet', PawnOwner);
		PawnOwnerPRI.ScoreInstantKill(VictimPRI, class'GDT_Bayonet', GDT_NORMAL);
		// credit to them
		PawnOwnerPRI.ScoreHit(VictimPRI, PawnOwner.DefaultHealth, PawnOwner.Health, PawnOwner.Health, class'GDT_Bayonet', Follower);
		VictimPRI.ScoreInstantKill(PawnOwnerPRI, class'GDT_Bayonet', GDT_NORMAL);

		if( Follower.bShouldChainsawAttackInstantKillMe && !Follower.bUnlimitedHealth && !Follower.InGodMode() )
		{
			Follower.bPlayDeathAnimations = FALSE;
			Follower.Died(PawnOwner.Controller, class'GDT_Bayonet', Follower.Location);
		}
		else
		{
			Follower.EndSpecialMove(FollowerSpecialMove);
		}

		if( PawnOwner.bShouldChainsawAttackInstantKillMe && !PawnOwner.bUnlimitedHealth && !PawnOwner.InGodMode() )
		{
			PawnOwner.bPlayDeathAnimations = FALSE;
			PawnOwner.Died(Follower.Controller, class'GDT_Bayonet', PawnOwner.Location);
		}
		else
		{
			PawnOwner.EndSpecialMove();
		}
	}
}

/** Notification when Follower is leaving his FollowerSpecialMove */
function OnFollowerLeavingSpecialMove()
{
	if( bBothKilled == FALSE )
	{
		// safety kill, if somehow this fails to kill the owner
		if( PawnOwner.WorldInfo.NetMode != NM_Client && PawnOwner.IsGameplayRelevant() )
		{
			`warn("victim special move forcing Died(), this shouldn't happen");
			ScriptTrace();
			if( Follower != None )
			{
				Follower.Died(PawnOwner.Controller, class'GDT_BayonetGib', Follower.Location);
			}

			if( PawnOwner != None )
			{
				if (Follower!=none)
				{
					PawnOwner.Died(Follower.Controller, class'GDT_BayonetGib', PawnOwner.Location);
				}
				else
				{
					PawnOwner.Died(none, class'GDT_BayonetGib', PawnOwner.Location);
				}
			}
		}	

		bBothKilled = TRUE;
	}

	// If victim has been kicked out of her special move unintentionally, then abort attack.
	if( PawnOwner.WorldInfo.NetMode != NM_Client && !PawnOwner.bEndingSpecialMove )
	{
		PawnOwner.ServerEndSpecialMove();
	}
}

function PlaceOnMarkers();

defaultproperties
{
	bAlignPawns = TRUE
	bAlignLeaderRotation = FALSE
	bAlignFollowerRotation = FALSE
	AlignDistance = 40;
	FollowerSpecialMove=SM_BayonetDraw_Follower

	LeaderAnim=(Stance=((Slot=BS_FullBody,AnimName="RL_Joust_Death_a")))
	FollowerAnim=(Stance=((Slot=BS_FullBody,AnimName="RL_Joust_Death_b")))

	bDisablePOIs=TRUE
	bDisableLook=TRUE
	bDisableMovement=TRUE

	BloodEffect = ParticleSystem'Effects_Gameplay.Executions.P_Retro_Lancer_Charge_Stab'
	LambentBloodEffect = ParticleSystem'Effects_Gameplay.Executions.P_Retro_Lancer_Charge_Stab_Lambent'

	bUseUnsynchedServerMove = TRUE

	AttackCameraAnims(0)=CameraAnim'COG_MarcusFenix.Camera_Anims.RL_Joust_Death_Cam01'
	AttackCameraAnims(1)=CameraAnim'COG_MarcusFenix.Camera_Anims.RL_Joust_Death_Cam02'
	AttackCameraAnims(2)=CameraAnim'COG_MarcusFenix.Camera_Anims.RL_Joust_Death_Cam03'
}
