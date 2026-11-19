/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoDroppedWeapon extends KAsset
	native;


var transient class<NanoWeaponBase> WeaponClass;

var transient AudioComponent AC_InFlightSound;

/** How much ammo this dropped weapon contains */
var transient int AmmoAmount;

cpptext
{
	virtual UBOOL IgnoreBlockingBy( const AActor *Other) const;
}



simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	NanoGRI(WorldInfo.GRI).SpawnANanoOrb( class'NanoAbsorbOrb_Weapon', self, TRUE );
}



simulated function ActivateInFlightSounds()
{
	if( ( WeaponClass != none ) && ( SkeletalMeshComponent != none ) )
	{
		if( WeaponClass.default.SoundToPlayWhileFlyingThroughAirBeforeImpactGround != none )
		{
			AC_InFlightSound = new(self) class'AudioComponent';
			if( AC_InFlightSound != none )
			{
				AC_InFlightSound.SoundCue = WeaponClass.default.SoundToPlayWhileFlyingThroughAirBeforeImpactGround;
				AttachComponent( AC_InFlightSound );
				AC_InFlightSound.FadeIn( 0.100f, 1.0f );
			}
		}
	}
}


simulated event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
								   const out CollisionImpactData RigidCollisionData, int ContactIndex )
{
	// once we hit one thing don't fire off anymore hits
	if( SkeletalMeshComponent != none )
	{
		SkeletalMeshComponent.SetNotifyRigidBodyCollision( FALSE );
	}

	if ( EffectIsRelevant( Location, FALSE, 4000.0) )
	{
		if( WeaponClass != none )
		{
			if( WeaponClass.default.WeaponDropSound != none )
			{
				PlaySound( WeaponClass.default.WeaponDropSound, TRUE );
			}
		}
	}

	if( AC_InFlightSound != none )
	{
		AC_InFlightSound.FadeOut( 0.100f, 0.0f );
	}
}

// When touched by an actor.
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local NanoPawn NP;

	// If touched by a player pawn, let him pick this up.
	NP = NanoPawn(Other);
	if( (AmmoAmount > 0) && (NP != None) && NP.IsHumanControlled() )
	{
		//`log("PICKUP"@WeaponClass@"GIVING"@AmmoAmount@"TO"@NP);

		NP.Controller.PlaySound(SoundCue'Weapon_AssaultRifle.Weapons.GenericWeaponPickup03Cue');
		NP.GiveAmmo(class<NanoWeapon>(WeaponClass), AmmoAmount, FALSE);
		Destroy(); // destroy this pickup once picked up!
	}
}


defaultproperties
{
	Begin Object Name=KAssetSkelMeshComponent
		CollideActors=true
		BlockActors=false
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		BlockRigidBody=true
		bHasPhysicsAssetInstance=true
		bUpdateKinematicBonesFromAnimation=false
		PhysicsWeight=1.0
		RBChannel=RBCC_Nothing
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE)
		LightEnvironment=MyLightEnvironment
		bSkipAllUpdateWhenPhysicsAsleep=TRUE
		ScriptRigidBodyCollisionThreshold=5.0
		bNotifyRigidBodyCollision=TRUE
		bAcceptsDynamicDecals=FALSE
	End Object

	bNoDelete=FALSE // this makes this be the same as KAssetSpawnable even tho it extends KAsset
	LifeSpan=45.f
}
