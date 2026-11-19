/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProj_TeslaCoil extends NanoProjectile
	config(Weapon);

/** The skel mesh comp for the sword */
var SkeletalMeshComponent MeshComp;

/** Maximum number of bounces */
var() const protected int MaxBounceCount;
/** Number of times grenade has bounced */
var	protected transient int	BounceCount;

/** Which teslas coil class to spawn **/
var class<TeslaCoil> TeslaCoilClass;

var SoundCue ImpaledIntoGroundSound;

/************************************************************************************
 * Collision
 ***********************************************************************************/

simulated event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	HandleCollision( Other, OtherComp, Location, HitNormal );
}

simulated function HitWall( vector HitNormal, Actor Wall, PrimitiveComponent WallComp )
{
	HandleCollision( Wall, WallComp, Location, HitNormal );
}

/** Handle collision */
simulated function HandleCollision( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	//`log(self@"** hit!"@Other@OtherComp@HitNormal@HitLocation);
	if( Other != None && Physics == PHYS_Projectile )
	{
		// a bit of a hack, massage data for pawns
		if ( (Pawn(Other) != None) && (SkeletalMeshComponent(OtherComp) != None) )
		{
			HitNormal = HitLocation - Other.Location;
			HitNormal.Z = 0.f;
			HitNormal = Normal(HitNormal);
		}

		Bounce(HitLocation, HitNormal, Other);
	}
}


/**
 * Reflect grenade off a wall
 *
 * @param	HitLocation
 * @param	HitNormal
 */
simulated function Bounce(Vector HitLocation, Vector HitNormal, Actor Other)
{
	if((Normal(Velocity) Dot HitNormal) > 0.4)
	{
		return;
	}

	if( bBounce && BounceCount >= MaxBounceCount )
	{
		StopBounce(HitNormal);
		return;
	}

}

/** Called when grenade stops bouncing and comes to rest. */
simulated function StopBounce(vector HitNormal)
{
	bBounce = FALSE;

	PlaySound( ImpaledIntoGroundSound );
    Spawn( TeslaCoilClass,,, Location + vector(Rotation) * 128.f + vect(0,0,1) * - 88, rot(0,0,0) );
	Destroy();  // kill off self
}

defaultproperties
{
	Begin Object Class=SkeletalMeshComponent Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'MET_TeslaStick.SK_MET_TeslaStick'
		PhysicsAsset=PhysicsAsset'MET_TeslaStick.SK_MET_TeslaStick_Physics'
		HiddenGame=FALSE
		CastShadow=FALSE
		CollideActors=TRUE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
		bDisableAllRigidBody=TRUE
		Scale=1.0
		LightEnvironment=MyLightEnvironment
		bAcceptsDynamicDecals=FALSE
		bUpdateSkelWhenNotRendered=FALSE
	End Object
	MeshComp=WeaponMeshComp
	Components.Add(WeaponMeshComp)

	TrailTemplate=ParticleSystem'Nano_WeaponFX.Sword.Effects.P_FX_SwordThrownTrail'

	LifeSpan=+0020.000000

	bPerformGravity=TRUE
	GravityScale=1.0f
	Speed=100000 // seems this is also related to the pain

	InFlightSoundTemplate=SoundCue'Weapon_Tesla.Stick.Tesla_In_Air_LoopCue'

    MaxBounceCount=0
	bBounce=TRUE

	ImpaledIntoGroundSound=SoundCue'Weapon_Tesla.Stick.Tesla_LandCue'

	TeslaCoilClass=class'TeslaCoil'
}