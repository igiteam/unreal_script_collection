/**
 * Class to hold all of the "generic" just computation helper functions and such.
 * NanoWeap_Melee just had to much chaff in it.
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_MeleeBase extends NanoWeapon
	abstract
	dependson(NanoMeleeWeaponSheet)
	native(Weapon)
	config(Weapon);


`define sword_log(msg)	`loginfo('Nano_Melee',WorldInfo.TimeSeconds@`msg)


//////
struct native MeleeInputInfo
{
	var() float		RawJoyUp;
	var() float		RawJoyRight;
	var() Rotator	AttackDir;

	var() EGameButtons			ButtonPressed;
	var() EComboJoyDirection	ComboDir;

	structdefaultproperties
	{
		ButtonPressed=GB_Max
	}
};
var MeleeInputInfo	ComboInput;
var MeleeInputInfo	BufferedComboInput;

var EGameButtons    AttackButtonOne, AttackButtonTwo, AttackButtonThree;

var() class<NanoMeleeWeaponSheet> WeaponSheetClass;
var() transient editinline NanoMeleeWeaponSheet WeaponSheet;


/** Current attack, index into MeleeAttacks */
var transient int AttackIdx;
/** Rate scale applied to current attack animation - stored so victim can match play rate */
var transient float AttackSpeedScale;


var()	float	SwordCheckLen;


/** Desired rotation for pawn during current melee attack */
var transient Rotator AttackerDesiredRotation;

/** Next desired attack identifiers, set before calling StartFire() using accessor functions */
var transient EComboJoyDirection	DesiredAttackDirection;
var transient Name					DesiredAttackName;

var transient Vector LastThumbstickDir;

/** Debug name of last attack executed */
var transient Name					LastAttackName;
/** Attacker that was our targetted actor last time we started a melee attack */
var transient Actor					ComboTargetedActor;
var transient Actor					PendingComboTargetedActor;
var transient Actor					LastTargetedActor;


struct native VictimInfoItem
{
	/** Victim affected by the most resent attack */
	var() Actor	Victim;
	/** Hit ID from attack that caused collision */
	var() int   ReactionID;

	/** Whether attack has registered an impact with this victim yet */
	var() bool	bCollisionDetected;

	structdefaultproperties
	{
		ReactionID=-1
	}
};
/** List of victims affected by the most recent melee attack */
var transient array<VictimInfoItem>	VictimList;


var transient bool bLastHitConnected;
var transient bool bCurrentHitConnected;
var transient bool bTargetDodgedDuringHit;

/** Min distance needed from ground to change physics from falling */
var config float MinDistFromGroundToStopFalling;


/** Particle effect trail when swinging **/
var protected           array<ParticleSystem>           PS_Trail;
var protected transient array<ParticleSystemComponent>  PSC_Trail;
var                     array<Name>                     TrailSocket;


/** When you are dragging your sword on the ground you will play this. **/
var protected SoundCue SwordDragSound;
var transient protected AudioComponent AC_SwordDragSound;
var protected MaterialInstanceTimeVarying MITV_SwordDragMark;


function DoRadialBlurForDashAttack();


/** This will create and attach the Sword PSC that we will use elsewhere to give the sword tip some neat effects **/
function CreateSwordTrailEffects()
{
	local int Idx;

	for( Idx = 0; Idx < PS_Trail.Length; Idx++ )
	{
		if( PS_Trail[Idx] != None )
		{
			PSC_Trail[Idx].SetTemplate( PS_Trail[Idx] );
			SkeletalMeshComponent(Mesh).AttachComponentToSocket( PSC_Trail[Idx], TrailSocket[Idx] );
		}
	}

	if( SwordDragSound != none )
	{
		AC_SwordDragSound = new(self) class'AudioComponent';
		if( AC_SwordDragSound != none )
		{
			AC_SwordDragSound.SoundCue = SwordDragSound;
			SkeletalMeshComponent(Mesh).AttachComponentToSocket( AC_SwordDragSound,  TrailSocket[0] );
		}
	}
}

function CreateSwordBladeEffects()
{
}


/** Go through the combo list for each attack and fixup the actual index reference */
simulated function FixupComboAttackReferences()
{
	local int CurrentIdx, ComboIdx;
	local Name AttackName;

	for( CurrentIdx = 0; CurrentIdx < WeaponSheet.MeleeAttacks.Length; CurrentIdx++ )
	{
		for( ComboIdx = 0; ComboIdx < WeaponSheet.MeleeAttacks[CurrentIdx].ComboAttacks.Length; ComboIdx++ )
		{
			AttackName = WeaponSheet.MeleeAttacks[CurrentIdx].ComboAttacks[ComboIdx].ComboAttackName;
			if( AttackName != '' )
			{
				WeaponSheet.MeleeAttacks[CurrentIdx].ComboAttacks[ComboIdx].ComboAttackIdx = WeaponSheet.MeleeAttacks.Find( 'AttackName', AttackName );
				if( WeaponSheet.MeleeAttacks[CurrentIdx].ComboAttacks[ComboIdx].ComboAttackIdx == -1 )
				{
					`log( "FAILED TO FIND COMBO ATTACK NAMED:"@AttackName@"in MeleeAttack"@WeaponSheet.MeleeAttacks[CurrentIdx].AttackName );
				}
			}
		}
	}
}

simulated function FixupHitRectionReferences()
{
	local int CurrentIdx, HitIdx;
	local Name HitReactionName;

	for( CurrentIdx = 0; CurrentIdx < WeaponSheet.MeleeAttacks.Length; CurrentIdx++ )
	{
		for( HitIdx = 0; HitIdx < WeaponSheet.MeleeAttacks[CurrentIdx].HitReaction.Length; HitIdx++ )
		{
			HitReactionName = WeaponSheet.MeleeAttacks[CurrentIdx].HitReaction[HitIdx].ReactionName;
			if( HitReactionName != '' )
			{
				WeaponSheet.MeleeAttacks[CurrentIdx].HitReaction[HitIdx].ReactionIdx = WeaponSheet.HitReactionList.Find( 'ReactionName', HitReactionName );
				if( WeaponSheet.MeleeAttacks[CurrentIdx].HitReaction[HitIdx].ReactionIdx == -1 )
				{
					`log( "FAILED TO FIND HIT REACTION NAMED:"@HitReactionName@"in MeleeAttack"@WeaponSheet.MeleeAttacks[CurrentIdx].AttackName );
				}
			}
		}
	}
}


/** 
 * Note: this interrogates the Anims and grabs out data from them.  So if you add new/mofify NanoAnimNotify_MeleeHoldPose you MUST MUST MUST
 * cause the MeleeSheet to be reloaded.   ReloadAllConfigFiles will do the trick
**/
simulated function FixupAnimNotifyHoldPoses()
{
	local int CurrentIdx;
	local float AnimSeqLength;
	local float HoldAPoseStartTime;
	local float HoldAPoseDuration;


	for( CurrentIdx = 0; CurrentIdx < WeaponSheet.MeleeAttacks.Length; CurrentIdx++ )
	{
		HoldAPoseDuration = 0.0f; // reset before we do anything
		HoldAPoseStartTime = 0.0f;

		// check the AttackAnim for old style attacks
		AnimSeqLength = CalcHoldPostTimeForAnAnim( WeaponSheet.MeleeAttacks[CurrentIdx].AttackAnimName, HoldAPoseStartTime, HoldAPoseDuration );

		if( HoldAPoseStartTime == 0.0f )
		{
			HoldAPoseStartTime = AnimSeqLength;
		}

		// check the HoldPoseName for new style attacks
		CalcHoldPostTimeForAnAnim( WeaponSheet.MeleeAttacks[CurrentIdx].AttackAnim_HoldPoseName, HoldAPoseStartTime, HoldAPoseDuration );


		WeaponSheet.MeleeAttacks[CurrentIdx].HoldAPoseDuration = HoldAPoseDuration;
		//WeaponSheet.MeleeAttacks[CurrentIdx].HoldAPoseStartTime = HoldAPoseStartTime;

		`log( "Final:" @ WeaponSheet.MeleeAttacks[CurrentIdx].AttackAnimName @ `showvar(WeaponSheet.MeleeAttacks[CurrentIdx].HoldAPoseDuration) );
	}
}


private function float CalcHoldPostTimeForAnAnim( const Name AnimName, out float HoldAPoseStartTime, out float HoldAPoseDuration  )
{
	local AnimSequence AnimSeq;
	local int i;

	AnimSeq = NanoPawn_Infantry(Instigator).Mesh.FindAnimSequence( AnimName );
	if( AnimSeq == None )
	{
		`warn( GetFuncName() @ "AttackAnim_HoldPoseName not found" @ `showvar(AnimName) );
		return 0.0f;
	}

	`log( "  Adding HoldAPoseDuration for:" @ `showvar(AnimName) );
	// we look through the notifies to find the end that corresponds to this start
	for( i = 0; i < AnimSeq.Notifies.length; i++ )
	{
		// First notify of desired class after this 'start'
		if( ClassIsChildOf(AnimSeq.Notifies[i].Notify.Class, class'NanoAnimNotify_MeleeHoldPose'))
		{
			HoldAPoseDuration += NanoAnimNotify_MeleeHoldPose(AnimSeq.Notifies[i].Notify).DurationToHold;
			`log( "  Added:" @ `showvar(NanoAnimNotify_MeleeHoldPose(AnimSeq.Notifies[i].Notify).DurationToHold) @ " Total:" @ `showvar(HoldAPoseDuration) );

			HoldAPoseStartTime += AnimSeq.Notifies[i].Time;

			return AnimSeq.SequenceLength;
		}
	}

	return 0.0f;
}



/** Set next attack by joystick direction - will filter into combo list if necessary */
simulated function SetDesiredAttackDirection( EComboJoyDirection inAttackDir )
{
	DesiredAttackDirection = inAttackDir;
	DesiredAttackName = '';
}
/** Set next attack by specific name */
simulated function SetDesiredAttackName( Name inAttackName )
{
	DesiredAttackDirection = CJD_None;
	DesiredAttackName = inAttackName;
}


simulated function bool IsTooCloseToGroundToStopFall( NanoPawn NP )
{
	local Actor HitActor;
	local Vector HitLocation, HitNormal;

	if( NP.Physics == PHYS_Falling || NP.Physics == PHYS_None )
	{
		HitActor = NP.Trace( HitLocation, HitNormal, NP.Location - (MinDistFromGroundToStopFalling * vect(0,0,1)), NP.Location, FALSE, NP.GetCollisionExtent() );
		if( HitActor != None )
		{
			return TRUE;
		}
	}
	return FALSE;
}

simulated function float GetDistFromTargt( Actor T )
{
	local float Dist2D;
	local Pawn	TargPawn;

	if( T != None )
	{
		Dist2D   = VSize2D(Instigator.Location - T.Location);
		Dist2D  -= Instigator.GetCollisionRadius();
		TargPawn = Pawn(T); // pawncast
		if( TargPawn != None )
		{
			Dist2D -= TargPawn.GetCollisionRadius();
		}
	}
	return Dist2D;
}



simulated function UpdateAttackerDesiredRotation( optional bool bCheckPlayerInput )
{
	local NanoPC PC;
	local Vector CamLoc;
	local Rotator CamRot;
	local NanoPawn NP;

	// Default rotation is our current rotation
	AttackerDesiredRotation = Instigator.Rotation;
	// If we are attacking a target, turn toward it
	if( ComboTargetedActor != None )
	{
		AttackerDesiredRotation = Rotator(ComboTargetedActor.Location - Instigator.Location);
	}

	PC = NanoPC(Instigator.Controller);
	if( PC != None )
	{
		//debug
		PC.UpdateDebugMeleeTargets();

		NP = NanoPawn(Instigator);
		if( bCheckPlayerInput ) 
		{
			// Store old thumb stick input for release checks later
			LastThumbstickDir.X = PC.PlayerInput.RawJoyUp;
			LastThumbstickDir.Y = PC.PlayerInput.RawJoyRight;

			if( !NP.bPreventRotationInputInMeleeAttack && (Abs(PC.PlayerInput.RawJoyUp) > 0.2f || Abs(PC.PlayerInput.RawJoyRight) > 0.2f) ) 
			{
				PC.GetActorEyesViewPoint( CamLoc, CamRot );
				AttackerDesiredRotation = Rotator(LastThumbstickDir >> CamRot);
			}

			// If no combo target, use input direction
			if(	ComboTargetedActor == None )
			{
				AttackerDesiredRotation = ComboInput.AttackDir;
			}
		}

		if( ( NanoInterface_Targetable(ComboTargetedActor) == none ) || ( NanoInterface_Targetable(ComboTargetedActor).IsTargetable() == TRUE ) )
		{
			if (ComboTargetedActor != LastTargetedActor)
			{
				PC.SetTargetedActor( ComboTargetedActor );
				bLastHitConnected = FALSE;
			}
		}
	}

	AttackerDesiredRotation.Yaw  += WeaponSheet.MeleeAttacks[AttackIdx].AttackerYawRotationOffset;
	AttackerDesiredRotation.Pitch = 0;
	AttackerDesiredRotation.Roll  = 0;

	`sword_log( `location@`showvar(ComboTargetedActor)@`showvar(ComboInput.AttackDir)@`showvar(AttackerDesiredRotation) );

	//debug
	// Store last attacked target
	if( ComboTargetedActor != None )
	{
		LastTargetedActor = ComboTargetedActor;
	}
}




simulated function bool IsInAttackRange( Actor TargetedActor )
{
	local float DistRequired, Dist2D, DistZ, ThreshZ;
	local NanoPawn NP;
	local Pawn TargetedPawn;

	if( TargetedActor != None )
	{
		NP = NanoPawn(Instigator);

		DistZ = TargetedActor.Location.Z - NP.Location.Z;
		ThreshZ = NP.GetCollisionHeight() * 0.75f;
		if( Abs(DistZ) > ThreshZ )
		{
			return FALSE;
		}

		// calc rough distance desired
		DistRequired = Instigator.GetCollisionRadius();
		TargetedPawn = Pawn(TargetedActor); // pawncast
		if( TargetedPawn != None && TargetedPawn.CylinderComponent != None )
		{
			DistRequired += TargetedPawn.GetCollisionRadius();
		}
		else
		{
			DistRequired *= 2.f;
		}
		// extend slightly by attack duration + buffers
		DistRequired += NP.SwordDistanceBuffer;
		Dist2D = VSize2D(TargetedActor.Location - NP.Location);

		//`log(`location@`showvar(DistRequired)@`showvar(Dist2D)@`TimeSince(AttackStartTime)@`showvar(TargetedActor));

		return (Dist2D < DistRequired);
	}
	return TRUE;
}


simulated function bool CheckReleasedThumbStick()
{
	local NanoPC PC;
	local Vector ThumbstickDir;
	local float ThumbDot;

	PC = NanoPC(Instigator.Controller);
	if( PC != None )
	{
		ThumbstickDir.X = PC.PlayerInput.RawJoyUp;
		ThumbstickDir.Y = PC.PlayerInput.RawJoyRight;
		if( Abs(ThumbstickDir.X) < 0.3f && Abs(ThumbstickDir.Y) < 0.3f )
		{
			return TRUE;
		}
		ThumbDot = LastThumbstickDir DOT ThumbstickDir;
		if( ThumbDot < 0.5f )
		{
			return TRUE;
		}
		return FALSE;
	}

	return TRUE;
}



simulated function SetVictimCollision( Actor Victim, int inReactionID )
{
	local int Idx;
	Idx = VictimList.Find( 'Victim', Victim );
	if( Idx < 0 )
	{
		Idx = VictimList.Length;
		VictimList.Length = Idx + 1;
		VictimList[Idx].Victim = Victim;
	}
	VictimList[Idx].bCollisionDetected = TRUE;
	VictimList[Idx].ReactionID = inReactionID;
}




simulated function bool HasAttackCollidedWithVictim( Actor Victim, optional int inReactionID = -1)
{
	local int Idx;
	Idx = VictimList.Find( 'Victim', Victim );
	if( Idx >= 0 && (inReactionID < 0 || inReactionID == VictimList[Idx].ReactionID))
	{
		return VictimList[Idx].bCollisionDetected;
	}
	return FALSE;
}



simulated function SetVelocityToInterceptTarget()
{
	local NanoPawn NP;

	NP = NanoPawn(Instigator);
	if( NP != None )
	{
		NP.bIsSwordDashing = TRUE;
	}

	DoRadialBlurForDashAttack();
}




/** This is a helper function to get the TraceDirs for Melee attacks **/
simulated function GetTraceVars( out vector WeaponBase, out vector WeaponDir, out float WeaponCheckLen )
{
	local NanoPawn NP;

	NP = NanoPawn(Instigator);

	WeaponBase = MatrixGetOrigin(Mesh.LocalToWorld);
	WeaponDir = MatrixGetAxis(Mesh.LocalToWorld, AXIS_Z);

	WeaponCheckLen = SwordCheckLen + NP.SwordDistanceBuffer/2.f;
}



simulated function bool IsOwningClient()
{
	return (WorldInfo.NetMode == NM_Standalone || (Instigator != None && Instigator.IsLocallyControlled()));
}
