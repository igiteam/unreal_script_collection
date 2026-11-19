/**
 * Nano Weapon implementation
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeapon extends NanoWeaponBase
	abstract
	config(Weapon)
	native(Weapon);

// NOTE: we prob want to do the  UT3 style  Weapon (logic)  Attachment (clientside / effects / mesh )  break up 
var bool bAllowCameraSlide;

/** Name of animation to play when equipping this weapon */
var name EquipAnimName;

/** Constant weapon ID, mainly used for FX lookup */
var const EWeaponClass WeaponID;
var const NanoPerMapColorConfig GlobalDefaultColors;

var const class<NanoMissionReward_UnlockNanoPowerBase> UnlockNanoPowerClass;

/** Keep track of where the weapon is attached to. To prevent multiple attachments to the same socket. */
var transient Name SocketAttachedTo;

/** Whether or not to debug TODO: this should be move to GameFramework**/
var bool bDebugWeapon;


/** how much it costs to use this weapon's nano power **/
var config float NanoPowerCost;

// to get compiling
var bool bNoInteractionWhileEquipped;

/** If TRUE, you can start dashing while still holding this weapon */
var bool bCanDashWithWeapon;

var bool bUniqueSpawn;
var bool bAltFireWeapon;

/** The name of the weapon to display on the UI **/
var name WeaponUIName;

/** Material params to allow for the weapon to be ghosted or densed **/
var	transient MaterialInstanceConstant WeaponMIC;
var MaterialInterface MI_WeaponDense;
var MaterialInterface MI_WeaponGhost;



simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	if( Mesh != none )
	{
		WeaponMIC = Mesh.CreateAndSetMaterialInstanceConstant(0);
		class'NanoTypes'.static.SetMaterialInstanceToDefault( WeaponMIC );
	}
}



/**
* Returns active-reload damage multiplier for this weapon.  Can be affected by active reload
* (or anything else for that matter).
**/
simulated function float GetActiveReloadDamageMultiplier()
{
	return 0;
}

simulated function float GetExploRadiusMultiplier()
{
	return 0;
}


/** Returns TRUE if weapon wants to define focus loc, false otherwise. */
simulated function bool GetCameraDOFFocusLocation(out vector FocusLoc)
{
	return FALSE;
}

/** Weapon can make situational FOV adjustments if it so chooses */
simulated function float GetAdjustedFOV(float BaseFOV)
{
	//local NanoPawn	GP;
	//GP = NanoPawn(Instigator);

	//if (GP != None)
	//{
	//	if (GP.IsInAimingPose())
	//	{
	//		return BaseFOV + AimingFOVAdjustment;
	//	}
	//}

	return BaseFOV;
}




static function PrimitiveComponent GetPickupMesh(PickupFactory Factory)
{
	return default.DroppedPickupMesh;
}






/**
 * Attach Weapon Mesh to player's hand. This is not a slot attachment on the back,
 * but a full functioning weapon mesh in the player's hand to use.
 *
 * @param	SkeletalMeshComponent where to attach weapon
 * @param	SocketName of Socket to use in provided SkeletalMeshComponent
 */
simulated function AttachWeaponTo( SkeletalMeshComponent MeshCpnt, optional Name SocketName )
{
	if ( bDebugWeapon && Instigator != none && Instigator.Controller != none && PlayerController(Instigator.Controller) != none )
	{
		`log("###"@self$"."@".AttachWeaponTo"@MeshCpnt@Instigator.IsFirstPerson());
	}

	SocketAttachedTo = SocketName;
	PerformWeaponAttachment(MeshCpnt, SocketName);
}


/** Called by AttachWeaponTo to perform weapon attachment after we're sure it's ok to do so. */
simulated function PerformWeaponAttachment(SkeletalMeshComponent MeshCpnt, optional Name SocketName)
{
	local SkeletalMeshComponent	SkelMesh;
	local Name      BoneName;
	//local NanoPawn P;

	// Add weapon specific animation sets
	// And remove unused ones.
	//P = NanoPawn(Instigator);
	SkelMesh = SkeletalMeshComponent(Mesh);

	`LogInv("MeshCpnt:" @ MeshCpnt @ "SocketName:" @ SocketName);

	BoneName = MeshCpnt.GetSocketBoneName(SocketName);
	// Attach Weapon mesh to player skelmesh
	if( Mesh != None && !MeshCpnt.IsComponentAttached(Mesh,BoneName) )
	{
		Mesh.SetScale3D(default.Mesh.Scale3D);

		// Set Shadow parent and light environment.
		Mesh.SetShadowParent(MeshCpnt);
		Mesh.SetLightEnvironment(NanoPawn(Instigator).LightEnvironment);

		MeshCpnt.AttachComponentToSocket(Mesh, SocketName);
	}

	if( SkelMesh != None )
	{
		if( SkelMesh.Animations != None )
		{
			UpdateAnimNodeReferences();
		}
		else
		{
			// AnimTree is not instanced right away, so set timer to cache nodes a little later.
			SetTimer(0.1f, FALSE, nameof(UpdateAnimNodeReferences));
		}
	}

	// should be turned into an SetUpEffects() function 
	AttachMuzzleEffectsComponents(SkelMesh);

	// attach shell ejection particle system
	//@todo. Should this not check the SkelMesh if
	//    ShouldUseMuzzleFlashSocketForShellEjectAttach() == false???
	if( PSC_ShellEject != None && !MeshCpnt.IsComponentAttached(PSC_ShellEject) )
	{
// 		if( !ShouldUseMuzzleFlashSocketForShellEjectAttach() )
// 		{
// 			MeshCpnt.AttachComponentToSocket(PSC_ShellEject, SocketName);
// 		}
// 		else
// 		{
// 			SkelMesh.AttachComponentToSocket(PSC_ShellEject, MuzzleSocketName);
// 		}

		SkelMesh.AttachComponentToSocket(PSC_ShellEject, ShellEjectSocketName);

		PSC_ShellEject.bJustAttached = true;

		HidePSC_ShellEject();
	}
}

simulated function PlayEquipAnimation(float BlendInTime)
{
	local NanoPawn NP;

	// Simple implementation for demo
	if( EquipAnimName != '' )
	{
		NP = NanoPawn(Instigator);
		NP.FullBodySlot.PlayCustomAnimByDuration(EquipAnimName, EquipTime, BlendInTime, EquipTime * 0.5f);
	}
}


simulated function UpdateAnimNodeReferences()
{
	local SkeletalMeshComponent WeaponSkelMesh;

	WeaponSkelMesh = SkeletalMeshComponent(Mesh);
	if( WeaponSkelMesh == None )
	{
		`DLog("Warning:" @ Self @ "has no SkeletalMesh");
		return;
	}

	// See if for whatever reason our weapon didn't instance our AnimTree
	if( WeaponSkelMesh.Animations == None && WeaponSkelMesh.AnimTreeTemplate != None )
	{
		`DLog("Warning: AnimTreeTemplate not instanced!!!" @ WeaponSkelMesh.AnimTreeTemplate @ "Instigator" @ Instigator @ "Controller:" @ GetWeaponController(Instigator));
		ScriptTrace();
 		WeaponSkelMesh.SetAnimTreeTemplate(WeaponSkelMesh.AnimTreeTemplate);
	}

	if( WeaponSkelMesh.Animations == None )
	{
		`DLog("Warning:" @ Self @ "has no Animations. AnimTreeTemplate:" @ WeaponSkelMesh.AnimTreeTemplate);
		return;
	}

	// Update our references
	CustomAnimNode = AnimNodeSlot(WeaponSkelMesh.FindAnimNode('CustomAnim'));
	AnimTreeRootNode = AnimTree(WeaponSkelMesh.Animations);
}


/**
* Detach weapon components from Instigator. Perform any clean up.
*/
simulated function DetachWeapon()
{
	local SkeletalMeshComponent	PawnMesh;
	local Pawn OwnerPawn;

	// Clear socket name, so we can attach again later.
	SocketAttachedTo = '';

	// Clear node references so AnimTree can be garbage collected.
	//CustomAnimNode = None;
	//AnimTreeRootNode = None;

	if( Instigator != None )
	{
		PawnMesh = Instigator.Mesh;
	}
	else
	{
		// if instigator is None but attachment is somehow still in place,
		// detach from whatever the weapon mesh thinks it's attached to
		OwnerPawn = Pawn(Owner);
		if (OwnerPawn != None)
		{
			PawnMesh = OwnerPawn.Mesh;
		}
	}

	if( Mesh != None )
	{
		// detach mesh from instigator
		if( PawnMesh != None && PawnMesh.IsComponentAttached(Mesh) )
		{
			PawnMesh.DetachComponent(Mesh);
		}

		// remove shadow parent and light environment, as this causes a nice little crash when garbage collection is performed.
		Mesh.SetShadowParent(None);
		Mesh.SetLightEnvironment(None);
	}

}


/** This will return whether or not were able to pay for the NanoPower.  If we were able to pay then it decrements the correct value **/
simulated function bool PayNanoPowerCost()
{
	return NanoPawn(Instigator).ConsumeNanoPower( NanoPowerCost );
}

simulated event Rotator GetAimRotation( Rotator AimRotation )
{
	return AimRotation;
}


defaultproperties
{
	bCanDashWithWeapon=TRUE

	// Weapon Mesh
	Begin Object Class=SkeletalMeshComponent Name=WeaponMeshComp
		CollideActors=FALSE
		bCastDynamicShadow=TRUE
		MotionBlurScale=0.0
		bUpdateSkelWhenNotRendered=FALSE
		bAcceptsDynamicDecals=FALSE // Each decal on them causes entire SkelMesh to be rerendered
	End Object

	bDebugWeapon=FALSE
	
}