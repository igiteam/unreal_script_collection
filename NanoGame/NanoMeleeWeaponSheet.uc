/** 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoMeleeWeaponSheet extends NanoMeleeWeaponSheetBase within NanoWeap_Melee
	native(Weapon)
	config(Melee)
	abstract;

`define melee_log(msg)	`loginfo('Nano_Melee',`msg)




/** Debugging for showing the name of the current attack above the head of the attacker **/
var transient bool bDebugDrawAttackName;
var transient bool bDebugDrawAttackNameNonPlayer;
var	const Color DebugAttackNameColor_Blue;
var	const Color DebugAttackNameColor_LightBlue;



simulated function SetAttackAnimState( EAttackAnimState NewState )
{
	local NanoPawn Attacker;

	AttackAnimState = NewState;

	Attacker = NanoPawn(Instigator);
	if( AttackAnimState == AAS_None )
	{
		Outer.StopAttackAnim();
	}
	else if( AttackAnimState == AAS_PreAttack )
	{
		PlayPreAttackAnim( Attacker, AttackIdx, AttackSpeedScale );
	}
	else if( AttackAnimState == AAS_PreLoop )
	{
		PlayPreLoopAnim( Attacker, AttackIdx, AttackSpeedScale );
	}

	// do the actual attack here
	else if( AttackAnimState == AAS_Attack )
	{
		PlayAttackAnim( Attacker, AttackIdx, AttackSpeedScale );
	}
	else if( AttackAnimState == AAS_AttackHoldPose )
	{
		PlayAttackHoldAPoseAnim( Attacker, AttackIdx, AttackSpeedScale );
	}
	else if( AttackAnimState == AAS_AttackRecoverToReadyPosition )
	{
		PlayAttackRecoverToReadyPositionAnim( Attacker, AttackIdx, AttackSpeedScale );
	}


	else if( AttackAnimState == AAS_PostLoop )
	{
		PlayPostLoopAnim( Attacker, AttackIdx, AttackSpeedScale );
	}
	else if( AttackAnimState == AAS_PostAttack )
	{
		PlayPostAttackAnim( Attacker, AttackIdx, AttackSpeedScale );
	}
}




simulated function PlayPreAttackAnim( NanoPawn Attacker, int AttackIdx, optional float SpeedScale = 1.f )
{
	local float AnimTime;

	AnimTime = Attacker.FullBodySlot.PlayCustomAnim( MeleeAttacks[AttackIdx].PreAttackAnimName, MeleeAttacks[AttackIdx].PreAttackAnimRate * SpeedScale, 0.1f, -1.f, FALSE, TRUE );

	//`log( GetFuncName() @ `showvar(MeleeAttacks[AttackIdx].PreAttackAnimRate) @ `showvar(SpeedScale) @ `showvar(AnimTime) );

	if( AnimTime <= 0.f )
	{
		AnimTime = 0.1f;
	}
	SetTimer( AnimTime, FALSE, nameof(UpdateAttackAnimState), self );
	SetTimer( AnimTime, FALSE, nameof(PossiblyPlayAttackAnim) );

	HACKHACK_AllowInstantTransitionOnEndHoldPose = FALSE;
	HandleSpecialEvents( 'PlayPreAttackAnim' );
}


simulated function PlayPreLoopAnim( NanoPawn Attacker, int AttackIdx, optional float SpeedScale = 1.f )
{
	Attacker.FullBodySlot.PlayCustomAnim( MeleeAttacks[AttackIdx].PreLoopAttackAnimName, MeleeAttacks[AttackIdx].PreAttackAnimRate * SpeedScale, 0.1f, -1.f, TRUE, TRUE );
	SetTimer( 0.1f, FALSE, nameof(PossiblyPlayAttackAnim) );

	HACKHACK_AllowInstantTransitionOnEndHoldPose = FALSE;
	HandleSpecialEvents( 'PlayPreLoopAnim' );
}


simulated function PlayAttackAnim( NanoPawn Attacker, int AttackIdx, optional float SpeedScale = 1.f )
{
	local float AnimTime;
	local float BlendTime;
	local string AttackNameDebug;
	local string HitReactionName, DeathReactionName;

	BlendTime = MeleeAttacks[AttackIdx].AttackerBlendInTime;
	if( BlendTime < 0.f )
	{
		BlendTime = 0.1f;
	}

	// check to see if we are doing an attack that is going to have a Hold Pose at the end
	if( MeleeAttacks[AttackIdx].HoldAPoseDuration != 0.0f )
	{
		AnimTime = Attacker.FullBodySlot.PlayCustomAnim( MeleeAttacks[AttackIdx].AttackAnimName, MeleeAttacks[AttackIdx].AttackAnimRate_Start * SpeedScale, BlendTime, -1.f, FALSE, TRUE, MeleeAttacks[AttackIdx].AttackAnimStartTime );

		// get the actual time as we are holding a pose for a bit
		//AnimTime = MeleeAttacks[AttackIdx].HoldAPoseStartTime + MeleeAttacks[AttackIdx].HoldAPoseDuration;

		//`log( "PlayAttackAnim:"  @ `showvar(MeleeAttacks[AttackIdx].HoldAPoseDuration) @ `showvar(SpeedScale) );

		// so now we set some timers which are going to tell the pawn to pause playing
		//Attacker.SetTimer( MeleeAttacks[AttackIdx].HoldAPoseStartTime, FALSE, nameof(Attacker.StartHoldPose) ); 
		//Attacker.SetTimer( MeleeAttacks[AttackIdx].HoldAPoseStartTime + MeleeAttacks[AttackIdx].HoldAPoseDuration, FALSE, nameof(Attacker.EndHoldPose) ); 
	}
	// do the normal anim playing
	else
	{
		AnimTime = Attacker.FullBodySlot.PlayCustomAnim( MeleeAttacks[AttackIdx].AttackAnimName, MeleeAttacks[AttackIdx].AttackAnimRate_Start * SpeedScale, BlendTime, -1.f, FALSE, TRUE, MeleeAttacks[AttackIdx].AttackAnimStartTime );
	}


	if( AnimTime <= 0.f )
	{
		AnimTime = 0.1f;
	}

	`log( "PLAYATTACKANIM:" @ `showvar(AttackIdx) @ MeleeAttacks[AttackIdx].AttackName @ MeleeAttacks[AttackIdx].AttackAnimName @ MeleeAttacks[AttackIdx].AttackAnimRate_Start @ `showvar(AnimTime) @ `showvar(MeleeAttacks[AttackIdx].HoldAPoseDuration) );

	if( bDebugDrawAttackName == TRUE )
	{
		if( ( Attacker.IsHumanControlled() == TRUE ) || ( bDebugDrawAttackNameNonPlayer == TRUE ) )
		{
			AttackNameDebug = string(MeleeAttacks[AttackIdx].AttackName );

			NanoGRI(Attacker.WorldInfo.GRI).GetNanoPC().AddDebugText( AttackNameDebug, Attacker, 5.f, vect(0,0,64.f), vect(0.0f,0.0f,64.f), DebugAttackNameColor_Blue, TRUE, FALSE, FALSE, class'Engine'.static.GetMediumFont() );


			if( MeleeAttacks[AttackIdx].HitReaction.Length > 0 )
			{
				HitReactionName = string(MeleeAttacks[AttackIdx].HitReaction[0].ReactionName);
				AttackNameDebug = "H:" $ HitReactionName;
			}

			if( MeleeAttacks[AttackIdx].HitReaction.Length > 1 )
			{
				DeathReactionName = string(MeleeAttacks[AttackIdx].HitReaction[1].ReactionName);
				AttackNameDebug $= " D:" $ DeathReactionName;
			}	

			NanoGRI(Attacker.WorldInfo.GRI).GetNanoPC().AddDebugText( AttackNameDebug, Attacker, 5.f, vect(0,0,64.f), vect(0.0f,0.0f,64.f), DebugAttackNameColor_LightBlue, TRUE, FALSE, FALSE, class'Engine'.static.GetMediumFont() );
		}
	}

	// debug for finding out how we get to actually play a anim
	// also check:
	// Function NanoGame.NanoAnimNotify_ComboSuccessTransition:Notify
	// Function NanoGame.NanoWeap_Melee:Attacking.ComboSuccessTransition
	//Function NanoGame.NanoWeap_Melee:Attacking.BeginState
	//Function NanoGame.NanoWeaponBase:WeaponFiring.BeginState
	//Function Engine.Weapon:WeaponFiring.BeginState
	//Function Engine.Weapon:FireAmmunition
	//Function NanoGame.NanoWeap_Melee:Attacking.CustomFire
	//Function NanoGame.NanoWeap_Melee:Attacking.StartMeleeAttack
	//Function NanoGame.NanoWeap_Melee:Attacking.ExecuteMeleeAttack
	//Function NanoGame.NanoWeap_Melee:Attacking.PlayAttackAnim
	//Function NanoGame.NanoMeleeWeaponSheet:InitAttackAnim
	//Function NanoGame.NanoMeleeWeaponSheet:SetAttackAnimState
	//Function NanoGame.NanoMeleeWeaponSheet:PlayAttackAnim
	
	ScriptTrace();



	Attacker.MeleeAttackAnimDuration = AnimTime;
	SetTimer( AnimTime, FALSE, nameof(UpdateAttackAnimState), self ); 
	ClearTimer(nameof(PossiblyPlayAttackAnim));
	Attacker.ClearTimer(nameof(Attacker.EndHoldPose));

	Attacker.bIsSwordDashing = FALSE;

	HACKHACK_AllowInstantTransitionOnEndHoldPose = FALSE;
	HandleSpecialEvents( 'PlayAttackAnim' );
}


simulated function PlayAttackHoldAPoseAnim( NanoPawn Attacker, int AttackIdx, optional float SpeedScale = 1.f )
{
	//local AnimSequence AnimSeq;
	//local float RateToPlay;
	local float AnimTime;
	//local float HoldPoseTime;

	// we need to figure out the rate at which to play the anim to match the hold pose
	//AnimSeq = Attacker.Mesh.FindAnimSequence( MeleeAttacks[AttackIdx].AttackAnim_HoldPoseName );

	//HoldPoseTime = FMax( 0.1f, MeleeAttacks[AttackIdx].HoldAPoseDuration );

	//RateToPlay = AnimSeq.SequenceLength / (AnimSeq.SequenceLength + HoldPoseTime);

	//AnimTime = Attacker.FullBodySlot.PlayCustomAnim( MeleeAttacks[AttackIdx].AttackAnim_HoldPoseName, RateToPlay * SpeedScale, 0.033f, 0.033f, FALSE, TRUE );

	// play at full rate and then let the anim notify sloooooww it down
	AnimTime = Attacker.FullBodySlot.PlayCustomAnim( MeleeAttacks[AttackIdx].AttackAnim_HoldPoseName, MeleeAttacks[AttackIdx].AttackAnimRate_Hold * SpeedScale, 0.033f, -1.0f, FALSE, TRUE );

	//`log( "PlayAttackHoldAPoseAnim" @ MeleeAttacks[AttackIdx].AttackAnim_HoldPoseName @ `showvar(AnimSeq.SequenceLength) @ `showvar(HoldPoseTime) @ `showvar(AnimTime) );
	//@ `showvar(RateToPlay * SpeedScale) 

	if( AnimTime <= 0.f )
	{
		AnimTime = 0.1f;
	}

	`log( "PlayAttackHoldAPoseAnim" @ `showvar(AnimTime) @ `showvar(MeleeAttacks[AttackIdx].HoldAPoseDuration) );


	AnimTime += FMax( 0.1f, MeleeAttacks[AttackIdx].HoldAPoseDuration );

	SetTimer( AnimTime, FALSE, nameof(PossiblyPlayAttackRecoverToReadyPositionAnim) );

	`log( "==== PlayAttackHoldAPoseAnim ====" );
	ScriptTrace();

	HACKHACK_AllowInstantTransitionOnEndHoldPose = TRUE;

	HandleSpecialEvents( 'PlayAttackHoldAPoseAnim' );
}


simulated function PlayAttackRecoverToReadyPositionAnim( NanoPawn Attacker, int AttackIdx, optional float SpeedScale = 1.f )
{
	local float AnimTime;

	`log( "" );
	`log( "PlayAttackRecoverToReadyPositionAnim" @ MeleeAttacks[AttackIdx].AttackAnim_RecoverToReadyPosition );
	ScriptTrace();

	AnimTime = Attacker.FullBodySlot.PlayCustomAnim( MeleeAttacks[AttackIdx].AttackAnim_RecoverToReadyPosition, MeleeAttacks[AttackIdx].AttackAnimRate_End * SpeedScale, 0.033f, -1.0f, FALSE, TRUE );

	if( AnimTime <= 0.f )
	{
		AnimTime = 0.1f;
	}

	SetTimer( AnimTime, FALSE, nameof(PossiblyPlayPostAttackAnim) );

	HACKHACK_AllowInstantTransitionOnEndHoldPose = FALSE;
	HandleSpecialEvents( 'PlayAttackRecoverToReadyPositionAnim' );
}


simulated function PlayPostLoopAnim( NanoPawn Attacker, int AttackIdx, optional float SpeedScale = 1.f )
{
	local float AnimTime;
	AnimTime = Attacker.FullBodySlot.PlayCustomAnim( MeleeAttacks[AttackIdx].PostLoopAttackAnimName, MeleeAttacks[AttackIdx].PostAttackAnimRate * SpeedScale, 0.1f, -1.f, TRUE, TRUE );
	if( AnimTime <= 0.f )
	{
		AnimTime = 0.1f;
	}
	SetTimer( AnimTime, FALSE, nameof(PossiblyPlayPostAttackAnim) );

	HACKHACK_AllowInstantTransitionOnEndHoldPose = FALSE;
	HandleSpecialEvents( 'PlayPostLoopAnim' );
}


simulated function PlayPostAttackAnim( NanoPawn Attacker, int AttackIdx, optional float SpeedScale = 1.f )
{
	local float AnimTime;
	local Name AnimName;
	
	AnimName = GetPostAttackAnim();

	AnimTime = Attacker.FullBodySlot.PlayCustomAnim( AnimName, MeleeAttacks[AttackIdx].PostAttackAnimRate * SpeedScale, 0.1f, -1.f, FALSE, TRUE );
	if( AnimTime <= 0.f )
	{
		AnimTime = 0.1f;
	}
	SetTimer( AnimTime, FALSE, nameof(UpdateAttackAnimState), self ); 
	ClearTimer(nameof(PossiblyPlayPostAttackAnim));

	HACKHACK_AllowInstantTransitionOnEndHoldPose = FALSE;
	HandleSpecialEvents( 'PlayPostAttackAnim' );
}


simulated function StopAttackAnim( NanoPawn Attacker, int AttackIdx )
{
	local Vector AtkVel;
	local float BlendTime;

	HACKHACK_AllowInstantTransitionOnEndHoldPose = FALSE;

	if( AttackIdx != -1 )
	{
		BlendTime = MeleeAttacks[AttackIdx].AttackerBlendOutTime;
	}

	if( BlendTime < 0.f )
	{
		BlendTime = 0.1f;
	}

	// Cleanup root motion
	Attacker.Mesh.RootMotionMode = Attacker.default.Mesh.RootMotionMode;
	Attacker.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );
	Attacker.FullBodySlot.StopCustomAnim( BlendTime );
	
	if( AttackIdx != -1 )
	{
		if( WeaponSheet.MeleeAttacks[AttackIdx].bLockRotation )
		{
			Attacker.LockDesiredRotation( FALSE );
		}
	}

	if( !Attacker.IsHumanControlled() )
	{
		Attacker.Velocity = vect(0,0,0);
		Attacker.Acceleration = vect(0,0,0);
	}


	if( AttackIdx != -1 )
	{
		AtkVel.X = MeleeAttacks[AttackIdx].AttackerVelocityOnRelease[0];
		AtkVel.Y = MeleeAttacks[AttackIdx].AttackerVelocityOnRelease[1];
		AtkVel.Z = MeleeAttacks[AttackIdx].AttackerVelocityOnRelease[2];
	}


	if( !IsZero(AtkVel) )
	{
		AtkVel = AtkVel >> Attacker.Rotation;
		Attacker.Velocity = AtkVel;
	}

	if( AttackIdx != -1 )
	{
		//debug
		`melee_log(`location@`showvar(Attacker)@`showvar(AttackIdx)@`showvar(AtkVel) );
	}
}


simulated function AttackRecover_AllowLeftStickInput()
{
	// seems to already work. 
	//`log( "AttackRecover_AllowLeftStickInput" );
}








defaultproperties
{
	DebugAttackNameColor_Blue=(R=0,G=0,B=255,A=255)
	DebugAttackNameColor_LightBlue=(R=175,G=238,B=238,A=255)
}