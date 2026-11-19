/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 
class NanoSpline_CradleTendril extends NanoSpline_CradleTendrilBase
	implements( NanoInterface_Interact );
	


/** Returns the UI component which we will then act upon. **/
simulated function InteractableComponent GetInteractableComponent()
{
	return None;
}

/** This is called when the interaction has completed successfully **/
simulated function InteractionSuccessfullyCompleted();

/** See if this object can be interacted with by this Pawn */
simulated function bool CanInteract(NanoPawn NP, ENanoInteractType Type)
{
	if( ( bMountPoint == TRUE ) 
		&& ( VSize(NP.Location - Location ) < NanoPawn_RebelsBase(NP).RadiusToCheckForCradleTendrils )
		&& ( NP.IsInState( 'CradleSurfing' ) == FALSE ) 
		)
	{
		return TRUE;
	}

	return FALSE;
}

/** Get tooltip for interacting */
simulated function string GetInteractToolTip( NanoPawn NP, out Texture2D out_TextureButtonToPrefix )
{
	out_TextureButtonToPrefix = Texture2D'UI_Common.button_B';
	return "to Mount the Tendril!";
}

/** Perform the interaction */
simulated function DoInteract(NanoPawn NPP, ENanoInteractType Type)
{
	// just do nothing for now
}




defaultproperties
{
	DeformMesh=StaticMesh'Nano_Proto_Cradle.SM.Mesh.S_MET_TubeSurf_proto'
	SurfRoll=90.0 // TubeSurf_proto mesh has conduit down Y

	ScaleX=1.0
	ScaleY=1.0

	SplineColor=(G=255,B=155,R=155,A=255)		

	Begin Object Name=Sprite
		Sprite=Texture2D'EditorResources.Spline.T_Loft_Spline_Surf'
	End Object

	// we need this so we can have this be in the octtree so we can use CollidingActors
	bCollideActors=TRUE 
	Begin Object Class=CylinderComponent NAME=CollisionCylinderComp
		CollideActors=TRUE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		CollisionRadius=+0040.000000
		CollisionHeight=+0040.000000
	End Object
	Components.Add(CollisionCylinderComp)

	Begin Object Class=StaticMeshComponent Name=AttachMesh1Comp
	    StaticMesh=StaticMesh'Nano_Proto_City_LOD_4.SM.Mesh.S_Proto_RailRing'
		Materials(0)=MaterialInstanceConstant'TempMaterials.M_SimpleTranslucent_Green'
		Scale3D=(X=1.0,Y=0.675,Z=0.675)
	End Object
	//AttachMesh1=AttachMesh1Comp
	//Components.Add(AttachMesh1Comp)


	Begin Object Class=StaticMeshComponent Name=AttachMesh2Comp
		StaticMesh=StaticMesh'Nano_Proto_City_LOD_4.SM.Mesh.S_Proto_RailRing'
		Materials(0)=MaterialInstanceConstant'TempMaterials.M_SimpleTranslucent_Green'
		Scale3D=(X=1.0,Y=0.333,Z=0.333)
	End Object
	//AttachMesh2=AttachMesh2Comp
	//Components.Add(AttachMesh2Comp)

	Begin Object Class=StaticMeshComponent Name=AttachMesh3Comp
	    StaticMesh=StaticMesh'Nano_Proto_City_LOD_4.SM.Mesh.S_Proto_RailRing'
		Materials(0)=MaterialInstanceConstant'TempMaterials.M_SimpleTranslucent_Green'
		Scale3D=(X=1.0,Y=0.165,Z=0.165)
		HiddenGame=TRUE
		HiddenEditor=TRUE
		CollideActors=FALSE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
	End Object
	//AttachMesh3=AttachMesh3Comp
	//Components.Add(AttachMesh3Comp)
}
