/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoThruster extends DynamicSMActor_Spawnable
	notplaceable;



var ParticleSystem PS_Thrusting;

var transient ParticleSystemComponent PSC_Thrusting;


function PostBeginPlay()
{
	Super.PostBeginPlay();


	PSC_Thrusting = new(self) class'ParticleSystemComponent';
	PSC_Thrusting.SetTemplate( PS_Thrusting );
	AttachComponent( PSC_Thrusting );
	PSC_Thrusting.ActivateSystem();
}




defaultproperties
{
	Begin Object Name=StaticMeshComponent0
		//StaticMesh=StaticMesh'Nano_Proto_B.SM.Mesh.S_GOW_Deco_SM_ManholeCover_Dup'
		Scale=10f
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		CollideActors=TRUE
		BlockActors=FALSE
		BlockRigidBody=FALSE
		//Rotation=(Pitch=16384)
	End Object

	bCollideActors=TRUE
	bBlockActors=FALSE

    PS_Thrusting=ParticleSystem'Effects_Gameplay.Fire.P_Propane_Tank_Flame'
    
}