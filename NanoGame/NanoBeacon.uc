//=============================================================================
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================

class NanoBeacon extends NavigationPoint
	implements( NanoInterface_Objective )
	placeable;


var()	SkeletalMeshComponent		BeaconMesh;

var()	StaticMeshComponent			BeamMesh;

var()	bool						bBeaconEnabled;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	// Hide beam when disabled
	if(!bBeaconEnabled)
	{
		SetBeaconEnabled(FALSE);
	}
}

simulated function SetBeaconEnabled(bool bNewEnabled)
{
	BeamMesh.SetHidden(!bNewEnabled);
	bBeaconEnabled = bNewEnabled;
}

simulated function bool IsEnabled()
{
	return bBeaconEnabled;
}


/** Handler for Kismet toggle action */
simulated function OnToggle(SeqAct_Toggle action)
{
	if (action.InputLinks[0].bHasImpulse)
	{
		// on
		SetBeaconEnabled(TRUE);
	}
	else if (action.InputLinks[1].bHasImpulse)
	{
		// off
		SetBeaconEnabled(FALSE);
	}
	else if (action.InputLinks[2].bHasImpulse)
	{
		// toggle
		SetBeaconEnabled(!bBeaconEnabled);
	}
}


/** Sets whether this object is enabled or not */
simulated function SetEnabled( bool NewEnabledValue )
{
	SetBeaconEnabled( NewEnabledValue );
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	Super.Touch( Other, OtherComp, HitLocation, HitNormal );
}


/** Return location of objective, used by radar */
simulated function vector GetObjectiveLocation()
{
	return Location;
}

/** Returns the UI component which we will then act upon. **/
function UIIconComponent GetUIIconComponent()
{
	return None;
}




defaultproperties
{
	bBeaconEnabled=TRUE

	bCollideActors=TRUE
	bBlockActors=FALSE

	Begin Object NAME=CollisionCylinder
		CollisionRadius=+00080.000000
		CollisionHeight=+00080.000000
		CollideActors=TRUE
		BlockActors=FALSE		
	End Object
	
	Begin Object Class=SkeletalMeshComponent Name=BeaconMesh0
		bUpdateSkelWhenNotRendered=FALSE
		SkeletalMesh=SkeletalMesh'Nano_Proto_CTF.Mesh.S_CTF_Flag_IronGuard_Dup'
		PhysicsAsset=PhysicsAsset'Nano_Proto_CTF.Mesh.S_CTF_Flag_IronGuard_Physics_Dup'
		Translation=(Z=-40.0)
	End Object
	BeaconMesh=BeaconMesh0
	Components.Add(BeaconMesh0)


	Begin Object Class=StaticMeshComponent Name=BeamMesh0
		StaticMesh=Nano_Proto_CTF.Meshes.S_Onslaught_FX_GodBeam_Dup
		CollideActors=FALSE
		BlockActors=FALSE
		Translation=(Z=-200.0)
	End Object
	BeamMesh=BeamMesh0
	Components.Add(BeamMesh0)
}