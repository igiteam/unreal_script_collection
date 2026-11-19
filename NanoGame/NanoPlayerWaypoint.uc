/**
 * NanoPlayerWaypoint
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPlayerWaypoint extends NanoTargetPoint;

var protected const DynamicLightEnvironmentComponent LightEnvironment;

defaultproperties
{
	bNoDelete=FALSE

	Begin Object Name=UIIconComponent0
		MiniMap=(bShown=TRUE,bShownEvenIfClamped=TRUE,DistancesToDrawIcon=(X=0,Y=20000),Icon=Texture2D'UI_HUD.MiniMap.MetaCorpPoliceCar',IconScale=0.125f,IconColor=(R=0,G=150,B=255,A=255))
	End Object


	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
	    bEnabled=TRUE
	End Object
	LightEnvironment=MyLightEnvironment
	Components.Add(MyLightEnvironment)

	// we prob want to put this into the UIIconComponent at some point
	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
	    StaticMesh=StaticMesh'Nano_Proto_City_LOD_4.SM.Mesh.S_Proto_GodBeam02'
		Materials(0)=MaterialInstanceConstant'Nano_Proto_IRIS.3D.MI_IRIS_Overlay_Objective_Player_Waypoint'
		BlockRigidBody=FALSE
		LightEnvironment=MyLightEnvironment
		bUsePrecomputedShadows=FALSE
		CollideActors=FALSE
		DepthPriorityGroup=SDPG_Foreground
	End Object
	Components.Add(StaticMeshComponent0)
}