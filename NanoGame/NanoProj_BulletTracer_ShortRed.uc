/**
 * Bullet tracer projectile
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProj_BulletTracer_ShortRed extends NanoProj_BulletTracer;



defaultproperties
{
	Begin Object Name=TracerMeshComp
		Scale3D=(X=0.12,Y=1.0,Z=1.0)
		StaticMesh=StaticMesh'COG_AssaultRifle.Mesh.S_Tracer_Short'
	End Object


	TracerDrawScale3D=(X=1.0f,Y=1.0f,Z=1.0f)

	Speed=8200

}