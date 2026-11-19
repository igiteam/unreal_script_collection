/** 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoMeleeWeaponSheetBase extends Object within NanoWeap_Melee
	native(Weapon)
	config(Melee)
	abstract;

`define melee_log(msg)	`loginfo('Nano_Melee',`msg)



enum EAttackAnimState
{
	AAS_None,
	AAS_PreAttack,
	AAS_PreLoop,

	// this is the actual attack "anim"  which is a start/loop/end
	AAS_Attack, // start the actual attack which will have the anim notifies in it for damage
	AAS_AttackHoldPose, // holding the pose
	AAS_AttackRecoverToReadyPosition, // moving back to the ready position / maybe we transition to another attack


	AAS_PostLoop,
	AAS_PostAttack,
};




var transient EAttackAnimState	AttackAnimState;



enum EHitReactionType
{
	HRT_Any,
	HRT_HitOnly,
	HRT_DeathOnly,
};

/** If we did on this attack, then this is how we are going to look up the effect to play on the pawn (e.g. super lightning effect!) **/
enum EAttackEffectType
{
	AET_None,
	AET_BackwardStab,
};


/** Struct that maps named hit reaction given by attack to an actual MeleeHitReactionItem*/
struct native MeleeHitReactionHandle
{
	/** Name to search for in HitReactionList array */
	var Name                ReactionName;
	/** Class to associate this reaction with */
	var Name                VictimClass;
	/** Whether reaction is for death hit only */
	var EHitReactionType    ReactionType;
	/** Amount of damage this reaction does */
	var int                 Damage;
	/** Reaction ID for multiple reaction possibilities in one attack */
	var int                 ReactionID;

	/** Index into HitReactionList array - fixed up at load time */
	var int     ReactionIdx;

	structdefaultproperties
	{
		VictimClass=Actor
		ReactionIdx=-1
		ReactionID=-1
	}
};

struct native ComboItem
{
	/** Name of attack that this combo item should transition to */
	var() Name					ComboAttackName;
	/** Direction player must push on joy to get this combo */
	var() EComboJoyDirection	ComboAttackDirection;
	/** Button to press to activate this combo item */
	var() EGameButtons			ComboAttackButton;
	/** Must have done damage to continue to this combo */
	var() bool					bRequireDamageFromLastHit;
	/** Must have this melee skill level to do this combo branch */
	var() Byte					ReqMeleeSkillLevel;

	/** Direct index reference into MeleeAttacks... fixed up at load time using CombatAttackName */
	/** DO NOT SET IN CONFIG... it'll just get overwritten */
	var   int					ComboAttackIdx;

	structdefaultproperties
	{
		ComboAttackIdx=-1
		ComboAttackButton=GB_B
	}
};



struct native MeleeAttack
{
	// Name of the attack sequence
	var Name		AttackName;
	// Priority value assigned to this attack (0 == lowest priority)
	var Byte        AttackPriority;

	// Anim to optionally play before the attack
	var Name		PreAttackAnimName;
	/** The speed at which to play the pre anim attack.  So you can have a SLLOOOOOW wind up and then a normal attack anim playing**/
	var float 	    PreAttackAnimRate;

	/** The speed at which to play the post anim attack.  So you can have a SLLOOOOOW wind up and then a normal attack anim playing**/
	var float 	    PostAttackAnimRate;

	// Anim to optionally loop before the attack
	var Name		PreLoopAttackAnimName;
	// Anim to play for the attack
	var Name		AttackAnimName;
	// Time to skip forward for attack anim
	var float       AttackAnimStartTime;
	// Anim to optionally loop after the attack
	var Name		PostLoopAttackAnimName;
	// Anim to optionally play after the attack
	var Name		PostAttackAnimName;
	// Anim to optionally play after a missed attack
	var Name		PostAttackMissAnimName;
	// Anim to optionally play after a missed attack
	var Name		PostAttackHitAnimName;
	// Blend in time for attack (should remain short!)
	var float       AttackerBlendInTime;
	// Blend out time for attack
	var float       AttackerBlendOutTime;
	

	/** Holding a Pose after the first "attack" portion of the animation. **/
	var Name        AttackAnim_HoldPoseName;
	/** The animation we play to return to the ready position after the HoldPose duration has ended. **/
	var Name        AttackAnim_RecoverToReadyPosition;


	/** 
	 * So for some attacks we want to have the pose "held" at the end.  Especially the third attack in the chain. 
     * @deprecated  these are probably deprecated due to the new way we are doing animations
	 **/
	var transient float           HoldAPoseDuration;

	/** Rate to play the attack animations at (hit reactions will also use them so they match up) */
	//var float		AttackAnimRate;

	/** Rate to play the attack animations at (hit reactions will also use them so they match up) */
	var float		AttackAnimRate_Start;

	/** Rate to play the attack animations at (hit reactions will also use them so they match up) */
	var float		AttackAnimRate_Hold;

	/** Rate to play the attack animations at (hit reactions will also use them so they match up) */
	var float		AttackAnimRate_End;


	/** Amount of time to wait after animation completes before attack officially ends */
	var float		PostAttackDelay;
	/** Scale attack damage traces */
	var float		AttackWeaponCheckScale;

	/** Root motion mode to put attacker in */
	var ERootMotionMode AttackRootMotionMode;
	/** Root motion bone options to apply to each axis for attacker animation */
	var ERootBoneAxis	AttackRootBoneOption[3]; // [X, Y, Z] axes
	/** Amount to scale attacker root motion movement */
	var float           AttackRootMotionScale;
	/** Amount of velocity to give the attacker on impact */
	var float			AttackerVelocityOnStart[3];
	/** Amount of velocity to give the attacker on impact */
	var float			AttackerVelocityOnImpact[3];
	/** Amount of velocity to give the attacker after the attack */
	var float			AttackerVelocityOnRelease[3];
	/** Desired yaw rotation offset from victim */
	var int				AttackerYawRotationOffset;

	/** List of handles to potential reactions of the victim */
	var array<MeleeHitReactionHandle> HitReaction;

	// combo attack! ( 0 == joy right, 1 == joy left, 2 == joy up, 3 == joy down )
	var array<ComboItem>	ComboAttacks;

	// lock pawn rotation while attacking
	var bool		bLockRotation;

	/** Conditions to allow this attack */
	/** Requires victim to do attack */		
	var bool		bReqVictim;
	/** Min/Max distance victim must be - only valid if bReqVictim == TRUE */
	var float		ReqMinVictimDist;
	var float		ReqMaxVictimDist;
	/** Min distance from the ground to be able to do this attack */
	var float		ReqMinDistFromGround;
	// Required physics state of the attacker for this attack to be allowed
	var ECondMeleePhysics ReqAttackerPhysics;
	// Required physics state of the victim for this attack to be allowed
	var ECondMeleePhysics ReqVictimPhysics;
	/** Requires attacker to be dashing */
	var bool		bReqDashing;

	/** 
	 *	Physics states to change attacker/victim to for duration of the attack... 
	 *	PHYS_Unused means do not modify physics 
	 */
	var() EPhysics	ChangeAttackerPhysicsOnStart, ChangeAttackerPhysicsOnImpact;

	/** List of named special events to handle during the attack */
	var() array<Name> SpecialEvents;

	/** The type of HIT/IMPACT effect to play **/
	var() EAttackEffectType AttackEffectType;

	/** The name of the GoreEffect to play when someone is killed by this attack. **/
	var() name OnDeathGoreType;

	structdefaultproperties
	{
		AttackWeaponCheckScale=1.f
		AttackerBlendInTime=-1.f
		AttackerBlendOutTime=-1.f
		AttackRootMotionScale=1.f

		PostAttackAnimRate=1.f
		AttackAnimRate_Start=1.f
		AttackAnimRate_Hold=1.f
		AttackAnimRate_End=1.f


		AttackRootMotionMode=RMM_Ignore
		AttackRootBoneOption(0)=RBA_Default
		AttackRootBoneOption(1)=RBA_Default
		AttackRootBoneOption(2)=RBA_Default

		// By default, do not change physics of attacker or victim
		ChangeAttackerPhysicsOnStart=PHYS_Unused
		ChangeAttackerPhysicsOnImpact=PHYS_Unused
	}	
};
/** List of melee attacks defined by this sheet */
var config array<MeleeAttack> MeleeAttacks;



/** Might need to mirror some of the members from here in NanoTypes.HitReactionInfo **/
struct native MeleeHitReactionItem
{
	var Name            ReactionName;

	/** Anim to play on victim */
	var Name			AnimName;
	/** Time to skip forward for hit anim */
	var float           AnimStartTime;
	/** Play rate for the reaction */
	var float           AnimRate;
	/** Whether victim hit anim should snap to CurrentTime of attacker anim */
	var bool			bSnapAnim;
	/** Whether victim should be attached to the 'MeleeAttach' socket for duration of this attack */
	var bool			bAttachVictim;
	/** Blend in time for victim (should remain short!) */
	var float           BlendInTime;
	/** Blend out time for victim */
	var float           BlendOutTime;
	/** whether or not the pawn should be force rotated to face the direction of the enemy**/
	var bool            bForceVictimToFaceAttacker;

	// looped anim data
	var Name            AnimNameStart;
	var Name            AnimNameLoop;
	/** How long we should loop for **/
	var float           AnimLoopTime;
	var Name            AnimNameEnd;


	/** Whether or not the foe is stunned after they have played the Hit Animation **/
	var bool            bPostHitReactionStunned;
	var float           PostHitReactionStunTime;
	var Name            PostHitReactionStunAnimName;

	/** How we are going to override the root motion curve type **/
	var ERootMotionCurveType OverrideRootMotionCurveType;
	/** Scale to apply to root motion of victim */
	var float           RootMotionScale;
	/** Root motion mode to put victim in */
	var ERootMotionMode RootMotionMode;
	/** Root motion bone options to apply to each axis for victim animation */
	var ERootBoneAxis	RootBoneOption[3]; // [X, Y, Z] axes
	/** Amount of velocity to give the victim on impact */
	var float			VelocityOnStart[3];

	/** 
	 *	Physics states to change (PHYS_Unused means do not modify physics)
	 */
	var() EPhysics	    PhysicsOnStart;

	structdefaultproperties
	{
		BlendInTime=-1.f
		BlendOutTime=-1.f
		bForceVictimToFaceAttacker=TRUE // by default we want to always have the victim face the attacker when they are hit

		OverrideRootMotionCurveType=RMCT_None
		RootMotionScale=1.f
		PhysicsOnStart=PHYS_Unused
	}
};
/** List of all possible hit reactions for this weapon */
var config array<MeleeHitReactionItem>  HitReactionList;




simulated function SetAttackAnimState( EAttackAnimState NewState )
{
	`warn( "BAD BAD!!! someone didn't extend this class!" );
}

simulated function UpdateAttackAnimState()
{
	ClearTimer( nameof(UpdateAttackAnimState), self );

	// we need to clear the timers we set but we don't have an ATTACKER HERE?!?!?
	//ClearTimer( nameof(StartHoldPose), self );
	//ClearTimer( nameof(HoldAPoseDuration), self );

	if( AttackAnimState == AAS_None )
	{
		if( MeleeAttacks[AttackIdx].PreAttackAnimName != '' )
		{
			SetAttackAnimState( AAS_PreAttack );
		}
		// Otherwise, start loop if there is one
		else if( MeleeAttacks[AttackIdx].PreLoopAttackAnimName != '' )
		{
			SetAttackAnimState( AAS_PreLoop );
		}
		// Otherwise, go right to the attack
		else
		{
			SetAttackAnimState( AAS_Attack );
		}
	}
	// If was in preattack anim
	else if( AttackAnimState == AAS_PreAttack )
	{
		// Start loop if there is one
		if( MeleeAttacks[AttackIdx].PreLoopAttackAnimName != '' )
		{
			SetAttackAnimState( AAS_PreLoop );
		}
		// Otherwise, go right to the attack
		else
		{
			SetAttackAnimState( AAS_Attack );
		}
	}
	// If was in preloop anim
	else if( AttackAnimState == AAS_PreLoop )
	{
		// Go right to the attack
		SetAttackAnimState( AAS_Attack );
	}

	// If was in attack anim
	else if( AttackAnimState == AAS_Attack )
	{
		// Start hold pose if there is one
		if( MeleeAttacks[AttackIdx].AttackAnim_HoldPoseName != '' )
		{
			SetAttackAnimState( AAS_AttackHoldPose );
		}
		// Otherwise, go to the hold pose if there is one
		else if( MeleeAttacks[AttackIdx].AttackAnim_RecoverToReadyPosition != '' )
		{
			`log( "Attack to recover" );
			SetAttackAnimState( AAS_AttackRecoverToReadyPosition );
		}
		// Start loop if there is one
		else if( MeleeAttacks[AttackIdx].PostLoopAttackAnimName != '' )
		{
			SetAttackAnimState( AAS_PostLoop );
		}
		// Otherwise, go to the loop if there is one
		else if( GetPostAttackAnim() != '' )
		{
			SetAttackAnimState( AAS_PostAttack );
		}
		// Otherwise, end the attack
		else
		{
			//`log( "shit AAS_AttackHoldPose" );
			SetAttackAnimState( AAS_None );
		}
	}

	else if( AttackAnimState == AAS_AttackHoldPose )
	{
		// Otherwise, go to the hold pose if there is one
		if( MeleeAttacks[AttackIdx].AttackAnim_RecoverToReadyPosition != '' )
		{
			`log( "hold to recover" );
			SetAttackAnimState( AAS_AttackRecoverToReadyPosition );
		}
		// Start loop if there is one
		else if( MeleeAttacks[AttackIdx].PostLoopAttackAnimName != '' )
		{
			SetAttackAnimState( AAS_PostLoop );
		}
		// Otherwise, go to the loop if there is one
		else if( GetPostAttackAnim() != '' )
		{
			SetAttackAnimState( AAS_PostAttack );
		}
		// Otherwise, end the attack
		else
		{
			//`log( "AAS_None case AAS_AttackHoldPose" );
			SetAttackAnimState( AAS_None );
		}
	}

	else if( AttackAnimState == AAS_AttackRecoverToReadyPosition )
	{
		// Start loop if there is one
		if( MeleeAttacks[AttackIdx].PostLoopAttackAnimName != '' )
		{
			SetAttackAnimState( AAS_PostLoop );
		}
		// Otherwise, go to the loop if there is one
		else if( GetPostAttackAnim() != '' )
		{
			SetAttackAnimState( AAS_PostAttack );
		}
		// Otherwise, end the attack
		else
		{
			//`log( "AAS_None case  AAS_AttackRecoverToReadyPosition" );
			SetAttackAnimState( AAS_None );
		}
	}
	// If was in postloop anim
	else if( AttackAnimState == AAS_PostLoop )
	{
		// Goto post attack if there is one
		if( GetPostAttackAnim() != '' )
		{
			SetAttackAnimState( AAS_PostAttack );
		}
		// Otherwise, end the attack
		else
		{
			SetAttackAnimState( AAS_None );
		}
	}
	// End the attack
	else if( AttackAnimState == AAS_PostAttack )
	{
		SetAttackAnimState( AAS_None );
	}
}








simulated function float GetAttackLength()
{
	local float Result;

	if( MeleeAttacks[AttackIdx].PreAttackAnimName != '' )
	{
		Result += Instigator.Mesh.GetAnimLength(MeleeAttacks[AttackIdx].PreAttackAnimName);
	}
	Result += Instigator.Mesh.GetAnimLength(MeleeAttacks[AttackIdx].AttackAnimName);
	if( GetPostAttackAnim() != '' )
	{
		Result += Instigator.Mesh.GetAnimLength(GetPostAttackAnim());
	}

	return Result;
}

simulated function float GetAttackPosition( AnimNodeSequence AnimSeqNode )
{
	local float Time, PreTime;

	if( MeleeAttacks[AttackIdx].PreAttackAnimName != '' )
	{
		Time = Instigator.Mesh.GetAnimLength(MeleeAttacks[AttackIdx].PreAttackAnimName);
		if( AnimSeqNode.AnimSeqName == MeleeAttacks[AttackIdx].PreAttackAnimName )
		{
			return PreTime + AnimSeqNode.CurrentTime;
		}
		else
		{
			PreTime += Time;
		}
	}

	Time = Instigator.Mesh.GetAnimLength(MeleeAttacks[AttackIdx].AttackAnimName);
	if( AnimSeqNode.AnimSeqName == MeleeAttacks[AttackIdx].AttackAnimName )
	{
		return PreTime + AnimSeqNode.CurrentTime;
	}
	else
	{
		PreTime += Time;
	}

	if( GetPostAttackAnim() != '' )
	{
		Time = Instigator.Mesh.GetAnimLength(GetPostAttackAnim());
		if( AnimSeqNode.AnimSeqName == GetPostAttackAnim() )
		{
			return PreTime + AnimSeqNode.CurrentTime;
		}
		else
		{
			PreTime += Time;
		}

	}

	return PreTime;
}




simulated function float GetNotifyTime( class<AnimNotify> NotifyClass, float SpeedScale, optional float StartPosition, optional out AnimNotify out_Notify, optional out float out_Duration )
{
	local float PreTime, Time;
	local AnimSequence AnimSeq;
	local bool bFound;

	if( MeleeAttacks[AttackIdx].PreAttackAnimName != '' )
	{
		AnimSeq = Instigator.Mesh.FindAnimSequence( MeleeAttacks[AttackIdx].PreAttackAnimName );
		if( AnimSeq != None )
		{
			Time = AnimSeq.GetNotifyTimeByClass( NotifyClass, SpeedScale,, out_Notify, out_Duration );
			if( Time < 0.f )
			{
				PreTime += Instigator.Mesh.GetAnimLength(MeleeAttacks[AttackIdx].PreAttackAnimName) / SpeedScale;
			}
			else if( (Time + PreTime) > StartPosition )
			{
				bFound = TRUE;
			}
		}
	}

	if( !bFound )
	{
		AnimSeq = Instigator.Mesh.FindAnimSequence( MeleeAttacks[AttackIdx].AttackAnimName );
		if( AnimSeq != None )
		{
			Time = AnimSeq.GetNotifyTimeByClass( NotifyClass, SpeedScale, StartPosition, out_Notify, out_Duration );
			if( Time < 0.f )
			{
				PreTime += Instigator.Mesh.GetAnimLength(MeleeAttacks[AttackIdx].AttackAnimName) / SpeedScale;
			}
			else if( (Time + PreTime) > StartPosition )
			{
				bFound = TRUE;
			}
		}
	}

	if( !bFound )
	{
		AnimSeq = Instigator.Mesh.FindAnimSequence( GetPostAttackAnim() );
		if( AnimSeq != None )
		{
			Time = AnimSeq.GetNotifyTimeByClass( NotifyClass, SpeedScale,, out_Notify, out_Duration );
			if( Time < 0.f )
			{
				PreTime += Instigator.Mesh.GetAnimLength(GetPostAttackAnim()) / SpeedScale;
			}
			else if( (Time + PreTime) > StartPosition )
			{
				bFound = TRUE;
			}
		}
	}

	return (bFound ? (PreTime + Time) : -1.f);
}



simulated function Name GetPostAttackAnim()
{
	local Name AnimName;
	local NanoInterface_Targetable NTI;
	local bool bMiss;

	NTI = NanoInterface_Targetable(ComboTargetedActor);
	if( !bHasDoneDamage || NTI == None || !NTI.IsTargetable() )
	{
		bMiss = TRUE;
	}

	AnimName = MeleeAttacks[AttackIdx].PostAttackAnimName;
	if( bMiss && MeleeAttacks[AttackIdx].PostAttackMissAnimName != '' ) 
	{
		AnimName = MeleeAttacks[AttackIdx].PostAttackMissAnimName;
	}
	else if( !bMiss && MeleeAttacks[AttackIdx].PostAttackHitAnimName != '' )
	{
		AnimName = MeleeAttacks[AttackIdx].PostAttackHitAnimName;
	}

	return AnimName;
}


simulated function bool ShouldPlayVictimImpactAnim( NanoPawn Victim, NanoPawn Attacker )
{
	if( Victim.Health <= 0 )
	{
		return FALSE;
	}

	if( Victim.InteractionType == PAWNINTER_Grab )
	{
		return FALSE;
	}

	if( Victim.IsSameTeam(Attacker) )
	{
		return FALSE;
	}

	if( Victim.IsHumanControlled() && (Victim.bDodging || Victim.bPlayingHitReaction) )
	{
		return FALSE;
	}

	if( Victim.IsHumanControlled() && Victim.Physics != PHYS_Walking && Victim.Physics != PHYS_None )
	{
		return FALSE;
	}

	return TRUE;
}



// Check out NanoTypes HitReactionInfo for where this data is being pushed to
simulated function PushReactionToHitReactionInfo( NanoPawn Attacker, out HitReactionInfo out_HRI, int ReactionIdx, const out Vector HitLocation, const out Vector HitNormal, const out Vector HitDirection, Byte AttackPriority )
{
	// Animation
	out_HRI.AnimName            = HitReactionList[ReactionIdx].AnimName;
	out_HRI.PlayRate            = HitReactionList[ReactionIdx].AnimRate;
	out_HRI.Position            = (HitReactionList[ReactionIdx].bSnapAnim ? Attacker.FullBodySlot.GetCustomAnimNodeSeq().CurrentTime : HitReactionList[ReactionIdx].AnimStartTime);
	out_HRI.BlendInTime         = 0.0f;
	out_HRI.BlendOutTime        = 0.0f;
	out_HRI.EndPositionOffset   = 0.0f;


	out_HRI.AnimNameStart            = HitReactionList[ReactionIdx].AnimNameStart;
	out_HRI.AnimNameLoop            = HitReactionList[ReactionIdx].AnimNameLoop;
	out_HRI.AnimLoopTime            = HitReactionList[ReactionIdx].AnimLoopTime;
	out_HRI.AnimNameEnd            = HitReactionList[ReactionIdx].AnimNameEnd;


	out_HRI.bPostHitReactionStunned       = HitReactionList[ReactionIdx].bPostHitReactionStunned;
	out_HRI.PostHitReactionStunTime       = HitReactionList[ReactionIdx].PostHitReactionStunTime;
	out_HRI.PostHitReactionStunAnimName   = HitReactionList[ReactionIdx].PostHitReactionStunAnimName;


	// Root motion
	out_HRI.OverrideRootMotionCurveType     = HitReactionList[ReactionIdx].OverrideRootMotionCurveType;
	out_HRI.RootMotionScale     = HitReactionList[ReactionIdx].RootMotionScale;
	out_HRI.RootMotionMode      = HitReactionList[ReactionIdx].RootMotionMode;
	out_HRI.RootBoneOption[0]   = HitReactionList[ReactionIdx].RootBoneOption[0];
	out_HRI.RootBoneOption[1]   = HitReactionList[ReactionIdx].RootBoneOption[1];
	out_HRI.RootBoneOption[2]   = HitReactionList[ReactionIdx].RootBoneOption[2];

	// Physics
	out_HRI.PhysicsOnStart      = HitReactionList[ReactionIdx].PhysicsOnStart;
	out_HRI.VelocityOnStart.X   = HitReactionList[ReactionIdx].VelocityOnStart[0];
	out_HRI.VelocityOnStart.Y   = HitReactionList[ReactionIdx].VelocityOnStart[1];
	out_HRI.VelocityOnStart.Z   = HitReactionList[ReactionIdx].VelocityOnStart[2];

	// Impact Info
	out_HRI.HitLocation         = HitLocation;
	out_HRI.HitDirection        = HitDirection;
	out_HRI.HitNormal           = HitNormal;

	// Other
	out_HRI.Attacker            = Attacker;
	out_HRI.bAI_MeleeDisengage  = TRUE;
	out_HRI.AttackPriority      = AttackPriority;
}


simulated function InitAttackAnim( NanoPawn Attacker, int AttackIdx, optional float SpeedScale = 1.f )
{
	local Vector AtkVel;

	if( Attacker.InteractionPawn != None )
	{
		Attacker.EndSpecialMove();
	}

	Attacker.SetDesiredRotation( AttackerDesiredRotation, FALSE, FALSE, 0.1f );
	// Immediately snap to desired rotation when attack starts (update in tick afterward)
	Attacker.SetRotation( AttackerDesiredRotation );

	// Stop running animations
	Attacker.RunningFullBodySlot.StopCustomAnim(0.1f);
	Attacker.FallingFullBodySlot.StopCustomAnim(0.1f);

	// Ignore root motion for other slot anim so blend doesn't cause a pop
	Attacker.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	if( MeleeAttacks[AttackIdx].PreAttackAnimName != '' )
	{
		SetAttackAnimState( AAS_PreAttack );
	}
	else if( MeleeAttacks[AttackIdx].PreLoopAttackAnimName != '' )
	{
		SetAttackAnimState( AAS_PreLoop );
	}
	else
	{
		SetAttackAnimState( AAS_Attack );
	}


	// Play anim and return duration
	//	BlendInTime = 0.1f;
	//	AnimTime = Attacker.FullBodySlot.PlayCustomAnim( AnimName, MeleeAttacks[AttackIdx].AttackAnimRate * SpeedScale, BlendInTime, -1.f, bLoop, TRUE );

	// Setup root motion
	Attacker.Mesh.RootMotionMode = MeleeAttacks[AttackIdx].AttackRootMotionMode;
	Attacker.FullBodySlot.SetRootBoneAxisOption( MeleeAttacks[AttackIdx].AttackRootBoneOption[0], MeleeAttacks[AttackIdx].AttackRootBoneOption[1], MeleeAttacks[AttackIdx].AttackRootBoneOption[2] );

	if( MeleeAttacks[AttackIdx].ChangeAttackerPhysicsOnStart != PHYS_Unused && !IsTooCloseToGroundToStopFall(Attacker) )
	{
		Attacker.SetPhysics(MeleeAttacks[AttackIdx].ChangeAttackerPhysicsOnStart);
	}

	if( WeaponSheet.MeleeAttacks[AttackIdx].bLockRotation )
	{
		Attacker.LockDesiredRotation( TRUE );
	}

	AtkVel.X = MeleeAttacks[AttackIdx].AttackerVelocityOnStart[0];
	AtkVel.Y = MeleeAttacks[AttackIdx].AttackerVelocityOnStart[1];
	AtkVel.Z = MeleeAttacks[AttackIdx].AttackerVelocityOnStart[2];
	if( !IsZero(AtkVel) )
	{
		AtkVel = AtkVel >> Attacker.Rotation;
		Attacker.Velocity = AtkVel;
	}

	//SetTimer(AnimTime,FALSE,nameof(StopAttackAnim));

	//debug
	`melee_log(`location@`showvar(Attacker)@`showvar(AttackIdx)@`showvar(AtkVel)@MeleeAttacks[AttackIdx].AttackAnimName );
}



/** return value is damage done */
simulated function int InitVictimReactionAnim( NanoPawn Victim, int AttackIdx, NanoPawn Attacker, float SpeedScale, Vector HitLocation, Vector HitNormal, Vector HitDirection, optional byte ReactionID, optional bool bForceGore )
{
	local int HR, DR, Idx;
	local array<int> HRL, DRL;
	local name OverrideDeathAnimName;
	local rotator VictimDesiredRotation;

	for( Idx = 0; Idx < MeleeAttacks[AttackIdx].HitReaction.Length; Idx++ )
	{
		if( MeleeAttacks[AttackIdx].HitReaction[Idx].ReactionIdx < 0 || ReactionID != MeleeAttacks[AttackIdx].HitReaction[Idx].ReactionID )
		{
			continue;
		}

		if( Victim.IsA( MeleeAttacks[AttackIdx].HitReaction[Idx].VictimClass ) )
		{
			if( (MeleeAttacks[AttackIdx].HitReaction[Idx].ReactionType == HRT_Any ||
				MeleeAttacks[AttackIdx].HitReaction[Idx].ReactionType == HRT_HitOnly) )
			{
				HRL[HRL.Length] = Idx;
			}

			if( (MeleeAttacks[AttackIdx].HitReaction[Idx].ReactionType == HRT_Any ||
				MeleeAttacks[AttackIdx].HitReaction[Idx].ReactionType == HRT_DeathOnly) )
			{
				DRL[DRL.Length] = Idx;
			}
		}
	}

	HR = HRL[Rand(HRL.Length)];
	DR = DRL[Rand(DRL.Length)];

	// this fills in the various structs that eventually TakeDamage's PlayHitReaction will call
	PushReactionToHitReactionInfo( Attacker, Victim.HitReaction,   MeleeAttacks[AttackIdx].HitReaction[HR].ReactionIdx, HitLocation, HitNormal, HitDirection, MeleeAttacks[AttackIdx].AttackPriority );
	PushReactionToHitReactionInfo( Attacker, Victim.DeathReaction, MeleeAttacks[AttackIdx].HitReaction[DR].ReactionIdx, HitLocation, HitNormal, HitDirection, MeleeAttacks[AttackIdx].AttackPriority );

	if( NanoGRI(Victim.WorldInfo.GRI).NGM.ShouldPlayNanoGoreEffect( FALSE, MeleeAttacks[AttackIdx].OnDeathGoreType, Victim, HitLocation, HitNormal, bForceGore, OverrideDeathAnimName ) )
	{
		Victim.DeathReaction.AnimName = OverrideDeathAnimName;
	}


	// I think we might always want to do this.  Because otherwise we need way more animations to nicely "turn" the character and then
	// blend into the correct hit anim?  (maybe some of the "to be used one after another combo" hit reactions might not want this
	if( HitReactionList[MeleeAttacks[AttackIdx].HitReaction[HR].ReactionIdx].bForceVictimToFaceAttacker == TRUE )
	{
		VictimDesiredRotation = Rotator(Attacker.Location - Victim.Location);

		// here we want to snap the victim's pawn to face the attacker so we can play the "correct" hit anim
		Victim.SetDesiredRotation( VictimDesiredRotation, FALSE, FALSE, 0.1f );
		// Immediately snap to desired rotation when attack starts (update in tick afterward)
		Victim.SetRotation( VictimDesiredRotation );
	}


	return MeleeAttacks[AttackIdx].HitReaction[HR].Damage;
}


simulated function PlayVictimImpactAnim( NanoPawn Victim, int AttackIdx, NanoPawn Attacker, float SpeedScale, optional Vector HitLocation, optional Vector HitDirection )
{
	local Vector AtkVel;
	local NanoAI AI;
	local Rotator R;

	if( ShouldPlayVictimImpactAnim( Victim, Attacker ) )
	{
		Victim.PlayHitReaction( Victim.HitReaction );
	}

/*	
 	if( MeleeAttacks[AttackIdx].bAttachVictim )
	{
		Victim.SetBase( Attacker,,Attacker.Mesh, 'b_MF_Attach' );
		Victim.SetRelativeLocation( Victim.Location - Victim.Mesh.GetBoneLocation( 'b_MF_Root' ) );
	}
*/

	AI = NanoAI(Victim.Controller);
	if( AI != None && AI.bTargetDummy && Victim.Physics != PHYS_Falling )
	{
		AI.SetFocalPoint( Attacker.Location );
		R.Yaw = Rotator(Attacker.Location-Victim.Location).Yaw;
		AI.Pawn.SetRotation( R );
	}

	if( MeleeAttacks[AttackIdx].ChangeAttackerPhysicsOnImpact != PHYS_Unused && !IsTooCloseToGroundToStopFall(Attacker) )
	{
		Attacker.SetPhysics(MeleeAttacks[AttackIdx].ChangeAttackerPhysicsOnImpact);
	}

	AtkVel.X = MeleeAttacks[AttackIdx].AttackerVelocityOnImpact[0];
	AtkVel.Y = MeleeAttacks[AttackIdx].AttackerVelocityOnImpact[1];
	AtkVel.Z = MeleeAttacks[AttackIdx].AttackerVelocityOnImpact[2];
	if( !IsZero(AtkVel) )
	{
		AtkVel = AtkVel >> Attacker.Rotation;
		Attacker.Velocity = AtkVel;
	}

	Attacker.bIsSwordDashing = FALSE;

	//debug
	`melee_log(`location@`showvar(Victim)@`showvar(Attacker)@`showvar(AttackIdx)@`showvar(Victim.Physics) );
}




defaultproperties
{

}