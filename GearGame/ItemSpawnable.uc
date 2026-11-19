/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class ItemSpawnable extends KActorSpawnable
	abstract;

/** This is the struct for a spawnable item **/
struct SpawnableItemDatum
{
	/**
	 * The Socket name we are going to attach this to.
	 * when we say: "head" we really mean the HeadSocketName as some guys have completely different
	 * notions/names for the socket that represents the "head".  So there is look up to handle that layer of indirection
	 * in GearInfantry.
	 *
	 **/
	var name AttachSocketName;

	/** The actual StaticMesh to attach and to eventually probably spawn **/
	var StaticMesh TheMesh;

	/** The actual SkelMesh to attach and to eventually probably spawn **/
	var SkeletalMesh TheSkelMesh;
	var PhysicsAsset ThePhysAsset;


	/** Some of the helmets need to be translated up.  (e.g. goggles)  For the most part this should be 0,0,0 and the content should be fixed **/
	var vector Translation;

	/** Rotation offset for the attachment */
	var rotator Rotation;

	/** This is the template for the Particle Effect that this item has **/
	var ParticleSystem PS_PersistentEffect;

	/** The scale to set this item to **/
	var float ItemScale;

	/** if not None, override material for slot 0 */
	var MaterialInterface TheMaterial;

	structdefaultproperties
	{
		ItemScale=1.0f;
	}
};

/** The item info for this node **/
var SpawnableItemDatum SpawnableData;


/** This struct is used for the item types that are choosing randomly from the set of items **/
struct SpawnableClassesDatum
{
	/** The percentage to spawn this item. **/
	var float PercentageToSpawn;

	/** The class to use for the random choice **/
	var class<ItemSpawnable> ItemClass;
};

/** This is used for the Random types as we can't replicate out a "random" class to clients as the results will be random on all clients! **/
var array<SpawnableClassesDatum> SpawnableClassesData;

/** The sound to play when the item is shot off **/
var SoundCue BeingShotOffSound;

/** When the item hits the ground for the first time **/
var SoundCue ImpactingGround;

/** Whether or not the item can be shot off */
var bool bCanBeShotOff;

auto state TimeTilDestroySelf
{

begin:
	sleep( 0.1f );
	SetHidden(FALSE);

	sleep( 15.0f );
	Destroy();
}


/** Sound to play when the item is shot off **/
simulated function PlayShotOffSound()
{
	if( BeingShotOffSound != none )
	{
		PlaySound( BeingShotOffSound, TRUE, TRUE, TRUE, Location );
	}
}


/**  When helmet hits the ground play a sound and then turn off the RB collision notifications **/
event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
				const out CollisionImpactData RigidCollisionData, int ContactIndex )
{
	if( ImpactingGround != none )
	{
		PlaySound( ImpactingGround, TRUE, TRUE, TRUE, Location );
	}
	StaticMeshComponent.SetNotifyRigidBodyCollision( FALSE );
}


/** This will turn off collision of the item. **/
simulated function TurnCollisionOff()
{
	CollisionComponent.SetBlockRigidBody( FALSE );
	CollisionComponent.SetRBChannel( RBCC_Nothing ); // nothing will request to collide with us

	CollisionComponent.SetRBCollidesWithChannel( RBCC_Default, FALSE );
	CollisionComponent.SetRBCollidesWithChannel( RBCC_BlockingVolume, FALSE );
	CollisionComponent.SetRBCollidesWithChannel( RBCC_Pawn, FALSE );
	CollisionComponent.SetRBCollidesWithChannel( RBCC_Vehicle, FALSE );
	CollisionComponent.SetRBCollidesWithChannel( RBCC_GameplayPhysics, FALSE );
	CollisionComponent.SetRBCollidesWithChannel( RBCC_EffectPhysics, FALSE );

	ReattachComponent(CollisionComponent);
}


/** This will turn on collision of the item. **/
simulated function TurnCollisionOn()
{
	CollisionComponent.SetBlockRigidBody( TRUE );

	CollisionComponent.SetRBCollidesWithChannel( RBCC_Default, TRUE );
	CollisionComponent.SetRBCollidesWithChannel( RBCC_BlockingVolume, TRUE );
	CollisionComponent.SetRBCollidesWithChannel( RBCC_Pawn, TRUE );
	CollisionComponent.SetRBCollidesWithChannel( RBCC_Vehicle, TRUE );
	CollisionComponent.SetRBCollidesWithChannel( RBCC_GameplayPhysics, TRUE );
	CollisionComponent.SetRBCollidesWithChannel( RBCC_EffectPhysics, TRUE );

	ReattachComponent(CollisionComponent);

	CollisionComponent.WakeRigidBody();
}


/**
 * This will return the static mesh for this spawnable type.  We use this function
 * in order to push the resources needed for the helmets to the content package where possible.
 **/
simulated static function SpawnableItemDatum GetSpawnableItemDatum()
{
	return default.SpawnableData;
}


/**
* This will return the static mesh for this spawnable type.  We use this function
* in order to push the resources needed for the helmets to the content package where possible.
*	@param Infantry - the gearpawn_infantry this item will be spawned for
*	@param Slot - The attachment slot this item is trying to get into
*
*	@return None if there is no spawnable item class that can work for the given infantry in the given slot, otherwise a class of type ItemSpawnable
**/
simulated static function class<ItemSpawnable> GetSpawnableItemClass(GearPawn_Infantry Infantry, EAttachmentType Slot)
{
	if( IsRandom() )
	{
		return GetSpawnableItemClassRandom(Infantry, Slot);
	}
	else
	{
		if (IsCompatible(Infantry,Slot))
		{
			return default.class;
		}
		else
		{
			return None;
		}
	}
}

/** Returns whether or not this ItemSpawnable is always the same class, or is randomized
 *	@return	True if random, false otherwise
 */
simulated static function bool IsRandom()
{
	return (default.SpawnableClassesData.length > 0);
}


/**
* This will return the static mesh for this spawnable type.  We use this function
* in order to push the resources needed for the helmets to the content package where possible.
**/
protected simulated static function class<ItemSpawnable> GetSpawnableItemClassRandom(GearPawn_Infantry Infantry, EAttachmentType Slot)
{
	local float Percent;
	local float CurrPercent;
	local array<SpawnableClassesDatum> CulledArray;
	local SpawnableClassesDatum Data;
	local float PercentageScale;

	PercentageScale = 0.0f;

	//Find only the valid entries
	foreach default.SpawnableClassesData(Data)
	{
		if (Data.ItemClass.static.IsCompatible(Infantry,Slot))
		{
			CulledArray.AddItem(Data);
			PercentageScale += Data.PercentageToSpawn;
		}
	}

	Percent = FRand();
	Percent = Percent*PercentageScale;

	foreach CulledArray(Data)
	{
		CurrPercent += Data.PercentageToSpawn;

		if( Percent <= CurrPercent )
		{
			//`log( "item translation " $  default.SpawnableData[Idx].Translation );
			return Data.ItemClass.static.GetSpawnableItemClass(Infantry, Slot);
		}

	}
	// else nothing was valid, return None
	return None;
}

/** Function to allow this item to determine if it is compatible with the other attachments on a gearpawn
 *	@param Infantry	- The guy we want to check to see if this attachment is compatible with
 *	@param Slot - The attachment slot that this item is attempting to go into
 *	@return	Whether or not it is compatible
 *
 *	At this level it only checks to make sure that the slot it wants to go in is not already being used.
 */
simulated static function bool IsCompatible(GearPawn_Infantry Infantry, EAttachmentType Slot)
{
	//If this object is already there, then it must be valid
	if (Infantry.AttachmentClasses[Slot] == default.class)
	{
		return True;
	}

	//If there is something already in the slot that it wants, then it is NOT valid.
	if (Infantry.AttachmentClasses[Slot] != None
		&& Infantry.AttachmentClasses[Slot] != class'ItemSpawnable')
	{
		return False;
	}

	return True;
}



defaultproperties
{
	RemoteRole=ROLE_None
	Physics=PHYS_RigidBody

	Begin Object Name=MyLightEnvironment
		LightShadowMode=LightShadow_Modulate
		bSynthesizeSHLight=TRUE
		ModShadowFadeoutTime=0.75f
	End Object


	// defaults for all spawnable items
	Begin Object Name=StaticMeshComponent0
		CastShadow=FALSE
		bCastDynamicShadow=FALSE

		BlockNonZeroExtent=FALSE
		CollideActors=TRUE
		BlockRigidBody=TRUE

		bNotifyRigidBodyCollision=TRUE
		ScriptRigidBodyCollisionThreshold=10.0
	End Object

	bNoEncroachCheck=TRUE
	bCollideWorld=FALSE  // we want the gib to use the rigidbody collision.  Setting this to TRUE means that unreal physics will try to control
	bCollideActors=TRUE
	bBlockActors=FALSE

	bCanBeShotOff=TRUE
}
