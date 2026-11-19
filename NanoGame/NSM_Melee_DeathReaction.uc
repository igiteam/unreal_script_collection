/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Melee_DeathReaction extends NSM_Melee_HitReaction;

var transient float DeathAnimBlendStartTime;
var transient bool  bDeathAnimTickedOnce;
var transient bool  bDeathAnimBlendToMotors;

function GetHitReactionStruct( out HitReactionInfo out_HRI )
{
	out_HRI = MyNP.DeathReaction;
}

function bool CanOverrideSpecialMove( Name InMove )
{
	return FALSE;
}

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	MyNP.RagdollTransitionTime = GetRagdollTransitionTime( HRI.Position, HRI.PlayRate );
	DeathAnimBlendStartTime = MyNP.WorldInfo.TimeSeconds;

	//`log( `location@`showvar(HRI.Position) @ `showvar(DeathAnimBlendStartTime) @ `showvar(MyNP.RagdollTransitionTime) );
}


// so if we are dying we never want the special move to end.
// If it ends then pawn will end up in some frozen state and look lame
function EndThisSpecialMove()
{

}


simulated function float GetRagdollTransitionTime( float CurPos, optional float AnimRate = 1.f )
{
	local array<float> TransitionOptions;
	local float TransitionTime;
	local AnimSequence AnimSeq;

	if( HRI.AnimName != '' )
	{
		// Give death animation a chance to specify a range of time to allow ragdoll transition to occur
		AnimSeq = MyNP.Mesh.FindAnimSequence( HRI.AnimName );
		if( AnimSeq != None )
		{
			while( CurPos >= 0.f )
			{
				CurPos = AnimSeq.GetNotifyTimeByClass( class'NanoAnimNotify_RagdollTransition', AnimRate, CurPos );
				if( CurPos >= 0.f )
				{
					TransitionOptions.AddItem( CurPos );
				}
			}
		}

		if( TransitionOptions.Length > 0 )
		{
			TransitionTime = TransitionOptions[Rand(TransitionOptions.Length)];
		}
	}

	if( TransitionOptions.Length <= 0 )
	{
		`log( `location@"No ragdoll transition notifies"@HRI.AnimName );
		TransitionTime = RandRange( 0.25f, 1.5f );
	}

	return TransitionTime;
}

simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	CheckActivateDeathAnimMotors( DeltaTime );
}

simulated function CheckActivateDeathAnimMotors( float DeltaTime )
{
	//`log( `showvar(MyNP.RagdollTransitionTime) @ `showvar(MyNP.Physics) );
	if( MyNP.RagdollTransitionTime > 0.f )
	{
		MyNP.RagdollTransitionTime -= DeltaTime;
		if( MyNP.RagdollTransitionTime <= 0.f )
		{
			// If playing a death animation... transition to rigid body physics/anim blending after root motion has stopped
			if( !bDeathAnimBlendToMotors && MyNP.Health <= 0 && MyNP.DeathReaction.AnimName != '' && MyNP.FullBodySlot != None )
			{
				if( bDeathAnimTickedOnce )
				{
					//`log( "do DeathAnimBlendToMotors" );
					DeathAnimBlendToMotors();
				}
				//`log( "bDeathAnimTickedOnce" );
				bDeathAnimTickedOnce = TRUE;
			}
		}
	}
	else if( MyNP.Physics != PHYS_RigidBody )
	{
		//`log( "DeathAnimRagDoll");
		DeathAnimRagDoll();
	}
}

function DeathAnimBlendToMotors()
{
	local Actor PawnBase;
	local vector HitLoc, HitNormal;

	bDeathAnimBlendToMotors = TRUE;	

	PawnBase = MyNP.Base;
	if( PawnBase == None )
	{
		PawnBase = MyNP.Trace( HitLoc, HitNormal, MyNP.Location + vect(0,0,-128.f), MyNP.Location );
	}
	//`log(`showvar(PawnBase)@`showvar(PawnBase.bMovable)@`showvar(MyNP.bHasBrokenConstraints));

	// Setup a bunch of springs to have physics match animation (as long as we are standing on non-moving thing)
	// Don't do it if we have broken constraints. We could figure out which ones are broken... For now, just do nothing.
	if( PawnBase != None && !PawnBase.bMovable && !MyNP.bHasBrokenConstraints )
	{
		SetSpringForBone(MyNP.PelvisBoneName, TRUE);
		SetSpringForBone(MyNP.RightHandBoneName, TRUE);
		SetSpringForBone(MyNP.LeftHandBoneName, TRUE);
		SetSpringForBone(MyNP.LeftFootBoneName, TRUE);
		SetSpringForBone(MyNP.RightFootBoneName, TRUE);

		// If we're not in rag doll physics, then we need to setup a few things.
		if( MyNP.Physics != PHYS_RigidBody )
		{
			// Unfix all bodies from kinematic data.
			// So now we switch to being fully physical
			MyNP.Mesh.PhysicsAssetInstance.SetAllBodiesFixed(FALSE);

			// Add velocity of base upon death.
			MyNP.AddBaseLinearVelocityUponWhenGoingRagDoll();

			// Allow all ragdoll bodies to collide with all physics objects (ie allow collision with things marked RigidBodyIgnorePawns)
			MyNP.Mesh.SetRBChannel(RBCC_Nothing);
			MyNP.Mesh.SetRBCollidesWithChannel(RBCC_Pawn, FALSE);

			// Wake up physics
			MyNP.Mesh.WakeRigidBody();
		}

		// Set physics to be updated from Kinematic data
		MyNP.Mesh.bUpdateJointsFromAnimation = TRUE;
		MyNP.Mesh.bUpdateKinematicBonesFromAnimation = TRUE;

		// Turn on motors
		MyNP.Mesh.PhysicsAssetInstance.SetAllMotorsAngularDriveParams( MyNP.RagdollAngularMotorSpring, MyNP.RagdollAngularMotorDamping, MyNP.RagdollAngularMotorForceLimit, MyNP.Mesh, TRUE);
		MyNP.Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(TRUE, TRUE, MyNP.Mesh, TRUE);

		// If Pawn had broken constraints, then we need to make sure child bodies and joints are not turned back into kinematic state
		if( MyNP.bHasBrokenConstraints )
		{
			MyNP.Mesh.UpdateMeshForBrokenConstraints();
		}

		// Set when we turn motors off, and ignore animation
		if( MyNP.RagdollTransitionTime <= 0.f )
		{
			DeathAnimRagDoll();
		}

		// Decrease joint limits, to prevent nasty poses once in complete rag doll.
		if( !MyNP.bIsGore && MyNP.ScaleLimitTimeToGo <= 0 )
		{
			MyNP.ReduceConstraintLimits();
		}
		MyNP.ReduceMotorStrength();
	}
	else
	{
		// If we're not in rag doll physics, then we need to setup a few things.
		if( MyNP.Physics != PHYS_RigidBody )
		{
			// Unfix all bodies from kinematic data.
			// So now we switch to being fully physical
			MyNP.Mesh.PhysicsAssetInstance.SetAllBodiesFixed(FALSE);

			// Add velocity of base upon death.
			MyNP.AddBaseLinearVelocityUponWhenGoingRagDoll();

			// Turn off collision on cylinder component and switch to skeleton physics
			MyNP.CollisionComponent = MyNP.Mesh;

			// Allow all ragdoll bodies to collide with all physics objects (ie allow collision with things marked RigidBodyIgnorePawns)
			MyNP.Mesh.SetRBChannel(RBCC_Nothing);
			MyNP.Mesh.SetRBCollidesWithChannel(RBCC_Pawn, FALSE);

			// Wake up physics
			MyNP.Mesh.WakeRigidBody();
		}

		// Set Physics weight to 1
		MyNP.Mesh.PhysicsWeight = 1.f;

		// Set physics to be updated from Kinematic data
		MyNP.Mesh.bUpdateJointsFromAnimation = TRUE;
		MyNP.Mesh.bUpdateKinematicBonesFromAnimation = TRUE;

		// Turn on motors
		MyNP.Mesh.PhysicsAssetInstance.SetAllMotorsAngularDriveParams( MyNP.RagdollAngularMotorSpring, MyNP.RagdollAngularMotorDamping, MyNP.RagdollAngularMotorForceLimit, MyNP.Mesh, TRUE );
		MyNP.Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive( TRUE, TRUE, MyNP.Mesh, TRUE );

		// If Pawn had broken constraints, then we need to make sure child bodies and joints are not turned back into kinematic state
		if( MyNP.bHasBrokenConstraints )
		{
			MyNP.Mesh.UpdateMeshForBrokenConstraints();
		}
		// straight to ragdoll
		DeathAnimRagDoll();
	}
}

function DeathAnimRagDoll()
{
`if(`notdefined(FINAL_RELEASE))
	if( MyNP.bDebug )
	{
		`log(MyNP.WorldInfo.TimeSeconds @ self @ class @ GetFuncName() @ "switching to rag doll");
		ScriptTrace();
	}
`endif

	if( MyNP.bHasDoneDeathAnimRagDoll == TRUE )
	{
		`log( "DeathAnimRagDoll has already been called once.  We are not doing it again." );
		`log( "More than likely there is an animation that is being played that does not have a RagDoll transition point set." @  `showvar(HRI.AnimName) @ `showvar(MyNP) );
		return;
	}


	MyNP.bHasDoneDeathAnimRagDoll = TRUE;

	// Turn off bone springs
	SetSpringForBone(MyNP.PelvisBoneName, FALSE);
	SetSpringForBone(MyNP.RightHandBoneName, FALSE);
	SetSpringForBone(MyNP.LeftHandBoneName, FALSE);
	SetSpringForBone(MyNP.LeftFootBoneName, FALSE);
	SetSpringForBone(MyNP.RightFootBoneName, FALSE);

	// Setup Pawn to be in rag doll physics
	MyNP.TurnToRagDollPhysics();

	MyNP.StopAllAnimations();

	// Decrease joint limits, to prevent nasty poses once in complete rag doll.
	if( !MyNP.bIsGore && MyNP.ScaleLimitTimeToGo <= 0 )
	{
		MyNP.ReduceConstraintLimits();
	}
	MyNP.ReduceMotorStrength();


	// give it a lil kick yo
	if( VSize(MyNP.PostDeathImpulseVector) > 0.0f )
	{
		//`log( `showvar(MyNP.PostDeathImpulseVector) @ `showvar(MyNP.PostDeathImpulseBoneName) );
		MyNP.Mesh.AddImpulse( MyNP.PostDeathImpulseVector, , MyNP.PostDeathImpulseBoneName, TRUE );
	}

}

/**
 * Creates a spring between physics reprensation of bone and animated position.
 * To have physics match animation.
 */
final function SetSpringForBone( Name InBoneName, bool bEnable )
{
	local int				BoneIndex;
	local matrix			BoneMatrix;
	local RB_BodyInstance	BoneBody;

	// Filter through sockets and bones. Make sure we have a valid bone name to use.
	InBoneName = MyNP.Mesh.GetSocketBoneName(InBoneName);

	if( InBoneName == '' )
	{
		`Warn(MyNP.WorldInfo.TimeSeconds @ self @ class @ GetFuncName() @ "Has non existing Bone or Socket named:" @ InBoneName @ "Unable to create HipBodyInstance!");
		return;
	}

	BoneIndex = MyNP.Mesh.MatchRefBone(InBoneName);
	if( BoneIndex != INDEX_NONE )
	{
		BoneMatrix = MyNP.Mesh.GetBoneMatrix(BoneIndex);
		BoneBody = MyNP.Mesh.FindBodyInstanceNamed(InBoneName);

		if( BoneBody != None )
		{
			BoneBody.EnableBoneSpring(bEnable, bEnable, BoneMatrix);
			if( bEnable )
			{
				BoneBody.OverextensionThreshold	= 50.f;
				BoneBody.SetBoneSpringParams(10000.f, 500.f, 10000.f, 500.f);
				BoneBody.bDisableOnOverExtension = TRUE;
			}
		}
		else
		{
			`Warn(MyNP.WorldInfo.TimeSeconds @ self @ class @ GetFuncName() @ "BodyInstance not found for BoneName:" @ InBoneName);
		}
	}
	else
	{
		`Warn(MyNP.WorldInfo.TimeSeconds @ self @ class @ GetFuncName() @ "Has non existing Index for BoneName:" @ InBoneName @ "Unable to create BodyInstance!");
	}
}



defaultproperties
{
}