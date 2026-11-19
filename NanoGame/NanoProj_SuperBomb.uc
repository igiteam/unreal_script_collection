/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProj_SuperBomb extends NanoProj_ForgedRocket
	config(Weapon);


defaultproperties
{
	Begin Object Name=RocketStaticMesh0
    	StaticMesh=StaticMesh'MET_PacifierMechProto.SM.S_Proto_PacifierMech_Rocket'
		Scale=4.0f
		Rotation=(Yaw=,Pitch=-16384,Roll=0)
    End Object

	// explosion point light
	Begin Object Name=ExploLight0
	    Radius=16000.000000
		Brightness=1000.000000
		LightColor=(B=35,G=185,R=255,A=255)
		Translation=(X=16)
		CastShadows=FALSE
		CastStaticShadows=FALSE
		CastDynamicShadows=FALSE
		bForceDynamicLight=FALSE
		bEnabled=FALSE
	End Object


	Begin Object Name=ExploTemplate0

	    ExploLightFadeOutTime=5.0f

	    ExploShakeInnerRadius=20000
		ExploShakeOuterRadius=20000

	    FractureMeshRadius=20000
		FracturePartVel=500.0

	End Object

	LifeSpan=+10.000000

	Speed=1000
	MaxSpeed=1000

}
