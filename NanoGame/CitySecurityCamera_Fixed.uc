/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class CitySecurityCamera_Fixed extends CitySecurityCamera_Base
	placeable;

/** Aim offset node used to look around */
var	transient AnimNodeAimOffset AimNode;
/** Control used to hide wires when not broken */
//var	transient SkelControlSingleBone WireScaleControl;
/** Material instance - used to control  */
var transient MaterialInstanceConstant CamMIC;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// Grab the aiming node
	AimNode = AnimNodeAimOffset(Mesh.FindAnimNode('AimNode'));

	// Get control for hiding wires, and make sure its active (hiding them)
	//WireScaleControl = SkelControlSingleBone(Mesh.FindSkelControl('WireScale'));
	//WireScaleControl.SetSkelControlActive(TRUE);

	// Create MIC for this cam, and set to peaceful state
	CamMIC = Mesh.CreateAndSetMaterialInstanceConstant(0);
	SetChaosDisplayTier(ECT_Tier0);
}

simulated event Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	// Calc aiming by looking at difference between controller rotation and the camera actors rotation
	if((AimNode != None) && (Controller != None))
	{
		AimNode.Aim.X = NormalizeRotAxis(Controller.Rotation.Yaw - Rotation.Yaw)/16384.0;
		AimNode.Aim.Y = NormalizeRotAxis(Controller.Rotation.Pitch)/16384.0;

		/* DEBUGGING (without controller)
		AimNode.Aim.X = ((WorldInfo.TimeSeconds % 2.0) - 1.0);
		if((WorldInfo.Timeseconds % 1.0) > 0.5)
		{
			SetChaosDisplayTier(ECT_Tier1);
		}
		else
		{
			SetChaosDisplayTier(ECT_Tier5);
		}
		*/
	}
}

/** Used to set the material param to turn lights on camera on, to indicate current chaos level */
simulated function SetChaosDisplayTier(EChaosTier Tier)
{
	local float Param;
	Param = 0.0;

	switch (Tier)
	{
	case ECT_Tier0:
		Param = -0.04;
		break;
	case ECT_Tier1:
		Param = -0.04;
		break;
	case ECT_Tier2:
		Param = -0.3;
		break;
	case ECT_Tier3:
		Param = -0.4;
		break;
	case ECT_Tier4:
		Param = -0.5;
		break;
	case ECT_Tier5:
		Param = -0.8;
		break;
	}

	CamMIC.SetScalarParameterValue('ChaosAmount', Param);
}

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	// Support firing death event
	TriggerEventClass( class'SeqEvent_Death', self );

	// Tell chaos manager
	//NanoGRI(WorldInfo.GRI).ModifyChaosLevel( GetChaosZone(), class'NanoCausingChaosValues'.default.CameraDestroyed );

	// Turn off light
	CamMIC.SetScalarParameterValue('ChaosAmount', 0.0);

	// Show wires
	//WireScaleControl.SetSkelControlActive(FALSE);

	// Turn on physics
	Mesh.SetHasPhysicsAssetInstance(TRUE);
	SetPhysics(PHYS_RigidBody);
	Mesh.WakeRigidBody();
	Mesh.PhysicsWeight = 1.0;

	// Turn off collision
	SetCollision( FALSE, FALSE, FALSE );

	return TRUE;
}

defaultproperties
{
	bNoEncroachCheck=TRUE

	// this camera collides with asset
	Begin Object Name=CollisionCylinder
		BlockZeroExtent=FALSE
	End Object


	Begin Object Name=CamBaseMesh
		SkeletalMesh=SkeletalMesh'Nano_Proto_SecurityCamera_DC.Proto_SecurityCamera_DC'
		PhysicsAsset=PhysicsAsset'Nano_Proto_SecurityCamera_DC.Proto_SecurityCamera_DC_Physics'
		AnimTreeTemplate=AnimTree'Nano_Proto_SecurityCamera_DC.AT_SecurityCam'
		//AnimSets(0)=AnimSet'MET_TattleCam.AS_MET_TattleCam_Base'
		Rotation=(Yaw=-16384)
		bSyncActorLocationToRootRigidBody=FALSE
		BlockZeroExtent=TRUE
		CollideActors=TRUE
		BlockRigidBody=TRUE
		RBChannel=RBCC_Pawn
		RBCollideWithChannels=(Default=TRUE)
		LightEnvironment=MyLightEnvironment
	End Object
}