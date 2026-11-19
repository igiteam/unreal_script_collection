/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn_LocustBoomerButcherBase extends GearPawn_LocustBoomerBase
	abstract
	config(Pawn);

/** Item Held by that character */
var class<ItemSpawnable>	HeldItem;
var StaticMeshComponent		HeldItemStaticMesh;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	SetupHeldItem();
}

simulated function SetupHeldItem()
{
	local SpawnableItemDatum ItemDatum;

	ItemDatum = HeldItem.static.GetSpawnableItemDatum();

	if( ItemDatum.TheMesh != None )
	{
		// figure out the mesh to attach
		HeldItemStaticMesh.SetStaticMesh( ItemDatum.TheMesh );

		// need to possibly adjust the location (e.g. goggles)
		//`log( "Setting trans: " $ ItemDatum.Translation $ " for " $ ItemDatum.TheMesh @ AttachmentClasses[eATTACHTYPE_Helmet] );
		HeldItemStaticMesh.SetTranslation( ItemDatum.Translation );
		HeldItemStaticMesh.SetRotation( ItemDatum.Rotation );

		// attach the head mesh to the body
		HeldItemStaticMesh.SetShadowParent(Mesh);
		HeldItemStaticMesh.SetLightEnvironment(LightEnvironment);
		HeldItemStaticMesh.SetHidden(FALSE);
		Mesh.AttachComponentToSocket(HeldItemStaticMesh, ItemDatum.AttachSocketName);

		//`DLog("Attached" @ ItemDatum.TheMesh @ "to" @  ItemDatum.AttachSocketName);
	}
	else
	{
		`DLog("ItemDatum.TheMesh == None!!");
	}
}

simulated function HideMesh()
{
	Super.HideMesh();

	if( HeldItemStaticMesh != None )
	{
		HeldItemStaticMesh.SetHidden(TRUE);
	}
}

simulated function SetDepthPriorityGroup(ESceneDepthPriorityGroup NewDepthPriorityGroup)
{
	local bool bUseViewOwnerDepthPriorityGroup;

	Super.SetDepthPriorityGroup( NewDepthPriorityGroup );

	// If we're a kidnapper or a hostage, ignore DepthPriorityGroup setting
	// As this is creating sorting issues because both actors are not owned by the same viewport.
	// We don't really care because you can't go in cover in this context.
	if( IsAHostage() || IsAKidnapper() )
	{
		NewDepthPriorityGroup = SDPG_World;
	}

	if( Mesh != None )
	{
		bUseViewOwnerDepthPriorityGroup = NewDepthPriorityGroup != SDPG_World;
		if( HeldItemStaticMesh != None )
		{
			HeldItemStaticMesh.SetViewOwnerDepthPriorityGroup(bUseViewOwnerDepthPriorityGroup, NewDepthPriorityGroup);
		}
	}
}

/** Remove the held cleaver */
simulated function RemoveHeldItem()
{
	HeldItemStaticMesh.SetHidden( TRUE );
	Mesh.DetachComponent(HeldItemStaticMesh);
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	Super.PlayDying(DamageType, HitLoc);

	RemoveHeldItem();
}

simulated function bool IsControllerFireInputPressed(byte InFiringMode)
{
	// use primary fire as another input to trigger melee
	if (InFiringMode == 0)
	{
		return false;
	}
	else if (InFiringMode == class'GearWeapon'.const.MELEE_ATTACK_FIREMODE)
	{
		return bWantsToMelee || (PlayerController(Controller) != None && Controller.bFire == 1);
	}
	else
	{
		return Super.IsControllerFireInputPressed(InFiringMode);
	}
}

simulated function bool ShouldPreventTargeting()
{
	return TRUE;
}


simulated function MeleeAttackStarted(GearWeapon Weap)
{
	// Butchers don't telegraph so just play the line at the same time as firing
	if (Role == ROLE_Authority)
	{
		if (bDoPCTelegraphAttack && WorldInfo.TimeSeconds - LastPCTelegraphAttackTime > 3.0)
		{
			TelegraphAttack();
			LastPCTelegraphAttackTime = WorldInfo.TimeSeconds;
		}
		bDoPCTelegraphAttack = false;
	}

	super.MeleeAttackStarted(Weap);
}

simulated function MeleeAttackEnded(GearWeapon Weap)
{
	bDoPCTelegraphAttack = true;

	super.MeleeAttackEnded(Weap);
}

