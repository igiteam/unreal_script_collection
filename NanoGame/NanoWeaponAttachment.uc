/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeaponAttachment extends Actor
	abstract;


// this is the UT3 style weapon where all of the non-owned "clientside" and effects type things are separated from the "logic" and "owner of the weapon" in the weapon.uc  (e.g.  ShakeView (from weapon firing doesn't need to occurr on for non owning clients' weapons


/** Weapon SkelMesh **/
var SkeletalMeshComponent Mesh;

/** Ref to the attachment uses for gameplay logic **/
var class<NanoWeapon> WeaponClass;



defaultproperties
{

	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	// Weapon SkeletalMesh
	Begin Object Class=SkeletalMeshComponent Name=NanoWeaponAttachmentMeshComp
		bOwnerNoSee=TRUE
		bOnlyOwnerSee=FALSE
		CollideActors=FALSE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
		MaxDrawDistance=4000
		bForceRefPose=1
		bUpdateSkelWhenNotRendered=FALSE
		bIgnoreControllersWhenNotRendered=TRUE
		bOverrideAttachmentOwnerVisibility=TRUE
		bAcceptsDynamicDecals=FALSE
		Animations=MeshSequenceA
	End Object
	Mesh=NanoWeaponAttachmentMeshComp


	TickGroup=TG_DuringAsyncWork
	NetUpdateFrequency=10
	RemoteRole=ROLE_None
	bReplicateInstigator=TRUE


}