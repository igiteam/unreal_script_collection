/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class ItemSpawnable_Skel extends KAssetSpawnable;

/** Reference back to the ItemSpawnableClass that has the data **/
var class<ItemSpawnable> SpawnableItemClass;

/** The sound to play when the item is shot off **/
var SoundCue BeingShotOffSound;

/** When the item hits the ground for the first time **/
var SoundCue ImpactingGround;

var DynamicLightEnvironmentComponent LightEnvironment;

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
	if( SpawnableItemClass != None && SpawnableItemClass.default.BeingShotOffSound != none )
	{
		PlaySound( BeingShotOffSound, TRUE, TRUE, TRUE, Location );
	}
}


/**  When helmet hits the ground play a sound and then turn off the RB collision notifications **/
event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
				const out CollisionImpactData RigidCollisionData, int ContactIndex )
{
	if( SpawnableItemClass != None && SpawnableItemClass.default.ImpactingGround != none )
	{
		PlaySound( ImpactingGround, TRUE, TRUE, TRUE, Location );
	}
	SkeletalMeshComponent.SetNotifyRigidBodyCollision( FALSE );
}


/** This will turn off collision of the item. **/
simulated function TurnCollisionOff()
{
	CollisionComponent.SetBlockRigidBody( FALSE );
}


/** This will turn on collision of the item. **/
simulated function TurnCollisionOn()
{
	CollisionComponent.SetBlockRigidBody( TRUE );
	CollisionComponent.WakeRigidBody();
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
	LightEnvironment=MyLightEnvironment
	
	
	// defaults for all spawnable items
	Begin Object Name=KAssetSkelMeshComponent
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
}
