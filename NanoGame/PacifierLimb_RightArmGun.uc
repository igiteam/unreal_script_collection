/**
 * Pacifier Bot Limb - Right Arm Gun
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class PacifierLimb_RightArmGun extends PacifierLimb_GunBase;

defaultproperties
{
	SocketName=RightArmGun
	MuzzleSocketName=RightArmMuzzle
	AimOffsetNodeName=ArmGunAimOffset
	DefaultWeaponClass=class'NanoWeap_Pacifier_Minigun'

	MaterialIndex=5

	Begin Object Class=StaticMeshComponent Name=StaticMesh0
    	StaticMesh=StaticMesh'EngineMeshes.Cube'
		BlockZeroExtent=TRUE
		CollideActors=TRUE
		BlockActors=FALSE
		BlockRigidBody=FALSE
		HiddenGame=TRUE
		Scale3D=(X=1.25,Y=0.33,Z=0.33)
    End Object
	Components.Add(StaticMesh0)
	StaticMeshComp=StaticMesh0
	CollisionComponent=StaticMesh0
	RelLoc=(X=175,Y=25,Z=-10)

	MinMaxAimX=(X=-1.f,Y=1.f)
	MinMaxAimY=(X=-0.25f,Y=0.9f)
}