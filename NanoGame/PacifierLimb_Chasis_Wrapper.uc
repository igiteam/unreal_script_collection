/**
 * Pacifier Bot Limb - Chassis Wrapper Class
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 
class PacifierLimb_Chasis_Wrapper extends Pacifier_LimbBase;

struct LegInfo
{
	var() Name				SocketName;
	var() Vector			RelLoc;
	var() int				MaterialIndex;

	// Foot planting variables
	var() Name				TraceBoneName;
	var() Name				SkelCtrlLimbName;
	var() Name				FootBoneName;

	var() PacifierLimb_Leg	Leg;
};
var() array<LegInfo> Legs;
var() int	NumLegsDestroyed;



var() SkeletalMeshComponent		ChassisMesh;

/** Controller for chassis rotation updates */
var SkelControlSingleBone		ChassisRotCtrl;

/** Blend node to apply chassis offset to */
var	AnimNodeBlendDirectional	WalkBlendNode;
/** Amount of rotation offset to add to chassis */
var() Rotator						ChassisAddedRot;
/** Rotation of the bot last frame */
var() Rotator						LastMeshRotation;
/** Speed that the chassis interps back to zero */
var() config float				ChassisRotInterpSpeed;
/** Whether chassis should interp back toward zero or not */
var() bool						bZeroChassisRotation;

/** Amount of time to allow target to be under bot before doing aoe attack */
var() config float DelayedFireTime;

// SOUNDS
var protected SoundCue FootStepCue;
var protected SoundCue FootStepLayerCue;
var int				   NumStepsBeforeLayerSound;
var protected SoundCue RotAlignStartCue;
var protected SoundCue RotAlignEndCue;
var protected SoundCue LegDestroyedCue;

function InitLimb( NanoAI_PacifierBot C )
{
	local int LegIdx;

	Super.InitLimb( C );

	for( LegIdx = 0; LegIdx < Legs.Length; LegIdx++ )
	{
		Legs[LegIdx].Leg = Spawn(class'PacifierLimb_Leg', Owner );
		Legs[LegIdx].Leg.Chassis = self;
		Legs[LegIdx].Leg.MyInfo = Legs[LegIdx];
		Legs[LegIdx].Leg.InitLimb( C );
	}

	// Chassis follow same animations as torso
	ChassisMesh.SetParentAnimComponent( Bot.Mesh );

	WalkBlendNode = AnimNodeBlendDirectional(Bot.Mesh.FindAnimNode('WalkBlendNode'));

	// Init chassis rotation info
	ChassisRotCtrl = SkelControlSingleBone(Bot.Mesh.FindSkelControl('ChassisRotCtrl'));
	ChassisRotCtrl.BoneRotation = rot(0,0,0);
	LastMeshRotation = Bot.Rotation;
}

simulated function UpdateMesh( float DeltaTime )
{
	local Rotator RotDelta;
	local int LegIdx;

	if( Base != None )
	{
		// Get change in rotation since last frame
		RotDelta = Bot.Rotation - LastMeshRotation;
		LastMeshRotation = Bot.Rotation;

		// Offset change from last frame
		ChassisAddedRot.Yaw -= RotDelta.Yaw;
		// If chassis has rotated too far, set flag to zero the difference
		if( Abs(ChassisAddedRot.Yaw) > 16384 )
		{
			if( !bZeroChassisRotation )
			{
				PlaySound( RotAlignStartCue );
			}
 			bZeroChassisRotation = TRUE;
		}

		// Should zero chassis rotation
		if( bZeroChassisRotation )
		{
			// Interp back toward zero
			ChassisAddedRot = RInterpTo( ChassisAddedRot, rot(0,0,0), DeltaTime, ChassisRotInterpSpeed );
			// If close enough to zero, pop to finish and unmark the flag
			if( Abs(ChassisAddedRot.Yaw) < 182 )
			{
				ChassisAddedRot = rot(0,0,0);
				bZeroChassisRotation = FALSE;

				PlaySound( RotAlignEndCue );
			}
		}

		// Update additive roation to bone controller
		ChassisRotCtrl.BoneRotation = ChassisAddedRot;
		WalkBlendNode.RotationOffset.Yaw = -ChassisAddedRot.Yaw;

		for( LegIdx = 0; LegIdx < Legs.Length; LegIdx++ )
		{
			if( Legs[LegIdx].Leg == None )
				continue;

			Legs[LegIdx].Leg.UpdateMesh( DeltaTime );
			if( bZeroChassisRotation )
			{
				Legs[LegIdx].Leg.SkelCtrl_Leg.SetSkelControlStrength( 0.f, 0.0f );
			}
		}

//		DrawDebugLine( Bot.Location, Bot.Location + Vector(Bot.Rotation) * 512.f, 255, 0, 0 );
//		DrawDebugLine( Bot.Location, Bot.Location + Vector(ChassisAddedRot+Bot.Rotation) * 512.f, 0, 255, 0 );
	}
}

simulated function DetatchLimb()
{
	local AnimTree ParentTree, Tree;

	Super.DetatchLimb();

	ParentTree = AnimTree(Bot.Mesh.Animations);
	Tree = AnimTree(ChassisMesh.Animations);

	if( ParentTree == None || Tree == None )
	{
		return;
	}

	// Call save pose on parent
	ParentTree.SetUseSavedPose( TRUE );
	// Copy it over to Chassis and set flag
	Tree.SavedPose = ParentTree.SavedPose;
	Tree.bUseSavedPose = TRUE;
	// Unset flag on parent
	ParentTree.SetUseSavedPose( FALSE );
	// Detach anims from parent component
	ChassisMesh.SetParentAnimComponent( None );
	// Match translation of Chassis to parent translation
	ChassisMesh.SetTranslation(vect(0,0,-88));
	// Clear base
	SetBase( None );

	StopFire();
}

simulated function bool AbleToFire()
{
	return (NumLegsDestroyed < 2);
}


/** Override to allow delayed attack on target */
function FireWeapon()
{
	if( !IsTimerActive( nameof(DelayFireWeapon) ) )
	{
		RegisterAsActiveAttacker();
		SetTimer( DelayedFireTime, FALSE, nameof(DelayFireWeapon) );
	}
}

/** Delayed fire timer has expired */
function DelayFireWeapon()
{
	// If target is still in range - do the attack
	if( FireTarget != None && VSize(FireTarget.Location-Bot.Location) <= MaxTargetDist )
	{
		Weapon.StartFire(0);
		NextAllowFireTime = WorldInfo.TimeSeconds + GetRefireDelay();
	}
	// Otherwise, abort
	else
	{
		StopFire();
	}
}

function StopFire()
{
	ClearTimer( nameof(DelayFireWeapon) );
	Super.StopFire();
}

simulated function bool PreventBotMovement()
{
	local int LegIdx;

	if( IsTimerActive( nameof(DelayFireWeapon) ) )
	{
		return TRUE;
	}
	
	if( Base == Bot )
	{
		if( NumLegsDestroyed >= 2 )
		{
			return TRUE;
		}	
		for( LegIdx = 0; LegIdx < Legs.Length; LegIdx++ )
		{
			if( Legs[LegIdx].Leg.IsDensed() )
			{
				return TRUE;
			}
		}
	}

	return FALSE;
}

/** Called each time a leg is destroyed */
simulated event NotifyLimbDestroyed()
{
	NumLegsDestroyed++;
	if( NumLegsDestroyed >= 2 )
	{
		StopFire();
		Bot.bChassisDestroyed = TRUE;
	}

	PlaySound( LegDestroyedCue );
}

simulated event HandleFootStep( int FootDown )
{
	local bool bLift;

	if( FootDown < 0 )
	{
		bLift = TRUE;
	}
	FootDown = Abs(FootDown) - 1;
	if( Legs[FootDown].Leg != None )
	{
		Legs[FootDown].Leg.PlayFootStep( bLift );

		if( !bLift )
		{
			PlaySound( FootStepCue );
			NumStepsBeforeLayerSound--;
			if( NumStepsBeforeLayerSound <= 0 )
			{
				PlaySound( FootStepLayerCue );
				NumStepsBeforeLayerSound = 4 + Rand(4);
			}
		}
	}

/*
		if( FootDown == 0 && !bLift )
		{
			DebugFreezeGame();
		}
*/	
}

/////////////////////////////////////////////////////
//////// INTERFACE: NanoInterface_Targetable /////////
/////////////////////////////////////////////////////
simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return FALSE;
}


defaultproperties
{
	Legs(0)=(SocketName=Leg_FR,RelLoc=(X=150,Y=0,Z=0),MaterialIndex=3,SkelCtrlLimbName=FrontRightLimb,TraceBoneName=b_IK_Front_Right,FootBoneName=b_Leg_Front_Right_03)
	Legs(1)=(SocketName=Leg_BR,RelLoc=(X=150,Y=0,Z=0),MaterialIndex=4,SkelCtrlLimbName=BackRightLimb,TraceBoneName=b_IK_Back_Right,FootBoneName=b_Leg_Back_Right_03)
	Legs(2)=(SocketName=Leg_FL,RelLoc=(X=150,Y=0,Z=0),MaterialIndex=1,SkelCtrlLimbName=FrontLeftLimb,TraceBoneName=b_IK_Front_Left,FootBoneName=b_Leg_Front_Left_03)
	Legs(3)=(SocketName=Leg_BL,RelLoc=(X=150,Y=0,Z=0),MaterialIndex=2,SkelCtrlLimbName=BackLeftLimb,TraceBoneName=b_IK_Back_Left,FootBoneName=b_Leg_Back_Left_03)
	
	DefaultWeaponClass=class'NanoWeap_Pacifier_Chassis'
	
	Begin Object Class=SkeletalMeshComponent Name=ChassisSkeletalMesh0
    	SkeletalMesh=SkeletalMesh'MET_PacifierMechProto.SK_MET_PacifierMechProto_Legs'
		AnimTreeTemplate=AnimTree'MET_PacifierMechProto.AT_PacifierMechProto'
		AnimSets.Empty()
		AnimSets.Add(AnimSet'MET_PacifierMechProto.AS_MET_PacifierMechProto')
		Scale3D=(X=1.0f,Y=1.0f,Z=1.0f)

		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		CollideActors=TRUE
		BlockRigidBody=TRUE
		RBChannel=RBCC_Pawn
		RBCollideWithChannels=(Default=TRUE,Pawn=TRUE,DeadPawn=TRUE,BlockingVolume=TRUE,EffectPhysics=TRUE,FracturedMeshPart=TRUE,SoftBody=TRUE)
		bIgnoreControllersWhenNotRendered=TRUE
//		LightEnvironment=MyLightEnvironment
		MinDistFactorForKinematicUpdate=0.2
		bAcceptsStaticDecals=FALSE
		bAcceptsDynamicDecals=TRUE
		bCullModulatedShadowOnBackfaces=FALSE
		bAllowAmbientOcclusion=FALSE
		MotionBlurScale=0.0

		bUpdateSkelWhenNotRendered=FALSE
		bTickAnimNodesWhenNotRendered=FALSE
    End Object
	Components.Add(ChassisSkeletalMesh0)
	ChassisMesh=ChassisSkeletalMesh0

	bIgnoreBaseRotation=TRUE

	// Sounds
	FootStepCue=SoundCue'Vehicle_PacBot.PacBot.PacBot_Footstep_Cue'
	FootStepLayerCue=SoundCue'Vehicle_PacBot.PacBot.PacBot_Footstep_Layer_Cue'
	RotAlignStartCue=SoundCue'Vehicle_PacBot.PacBot.PacBot_Body_RotateStart_Cue'
	RotAlignEndCue=SoundCue'Vehicle_PacBot.PacBot.PacBot_Body_RotateStop_Cue'
	LegDestroyedCue=SoundCue'Vehicle_PacBot.PacBot.PacBot_Body_LegShootOut_Cue'
}
