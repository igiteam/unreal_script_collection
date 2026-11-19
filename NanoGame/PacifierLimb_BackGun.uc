/**
 * Pacifier Bot Limb - Back Gun
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class PacifierLimb_BackGun extends PacifierLimb_GunBase;

defaultproperties
{
	SocketName=BackGun
	MuzzleSocketName=BackGunMuzzle
	AimOffsetNodeName=BackGunAimOffset
	DefaultWeaponClass=class'NanoWeap_Pacifier_Minigun'

	MaterialIndex=1
	
	Begin Object Class=StaticMeshComponent Name=StaticMesh0
    	StaticMesh=StaticMesh'EngineMeshes.Cube'
		BlockZeroExtent=TRUE
		CollideActors=TRUE
		BlockActors=FALSE
		BlockRigidBody=FALSE
		HiddenGame=TRUE
		Scale3D=(X=1.0,Y=0.25,Z=0.25)
    End Object
	Components.Add(StaticMesh0)
	StaticMeshComp=StaticMesh0
	CollisionComponent=StaticMesh0
	RelLoc=(X=50,Y=0,Z=0)

	MinMaxAimX=(X=-0.2f,Y=0.12f)
	MinMaxAimY=(X=-0.15f,Y=0.75f)
}