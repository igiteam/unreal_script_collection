/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAntenna extends NanoAntennaBase
	placeable;


defaultproperties
{
	Begin Object Name=AntennaMesh_0
		SkeletalMesh=SkeletalMesh'GEN_Antenna.SK_GEN_Antenna'
		PhysicsAsset=PhysicsAsset'GEN_Antenna.SK_GEN_Antenna_Physics'
		AnimTreeTemplate=AnimTree'GEN_Antenna.AT_Antenna'
		AnimSets.Add(AnimSet'GEN_Antenna.AS_GEN_Antenna');
		Rotation=(Yaw=-16384)
	End Object
	Components.Add(AntennaMesh_0)
	Mesh=AntennaMesh_0
	CollisionComponent=AntennaMesh_0
}
