/**
 * Pacifier Bot Limb - Shoulder Gun
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class PacifierLimb_ShoulderGun extends PacifierLimb_GunBase;

defaultproperties
{
	SocketName=RightShoulderGun
	MuzzleSocketName=RightShoulderMuzzle
	AimOffsetNodeName=ShoulderGunAimOffset
	DefaultWeaponClass=class'NanoWeap_Pacifier_Minigun'

	MaterialIndex=4

	Begin Object Class=StaticMeshComponent Name=StaticMesh0
    	StaticMesh=StaticMesh'EngineMeshes.Cube'
		BlockZeroExtent=TRUE
		CollideActors=TRUE
		BlockActors=FALSE
		BlockRigidBody=FALSE
		HiddenGame=TRUE
		Scale3D=(X=1.25,Y=0.25,Z=0.25)
    End Object
	Components.Add(StaticMesh0)
	StaticMeshComp=StaticMesh0
	CollisionComponent=StaticMesh0
	RelLoc=(X=100,Y=0,Z=0)

	MinMaxAimX=(X=-0.11f,Y=1.f)
	MinMaxAimY=(X=-0.6f,Y=0.8f)
}