/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 **/
class GearPawn_LocustNemaslugBase extends GearPawn_LocustCreatureBase
	abstract
	config(Pawn);

var SoundCue	AmbientSoundCue;

var BodyStance	BS_HitReaction;

/**
 * So for non extreme content we are not gore exploding this guy.  Which leaves this semi large mesh lying aruond with no real feedback
 * that you have killed him.  So we play this effect to "replace" the gore explosion.
 **/
var ParticleSystem PS_NonExtremeContentDeathEffect;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(RandRange(2,5),FALSE,nameof(AmbientSounds));
}

simulated function AmbientSounds()
{
	PlaySound(AmbientSoundCue);
	SetTimer(RandRange(2,5),FALSE,nameof(AmbientSounds));
}

simulated function bool CanBeSpecialMeleeAttacked( GearPawn Attacker )
{
	return false;
}

function Knockdown( optional vector RBLinearVelocity, optional vector RBAngularVelocity, optional vector RadialOrigin,
			optional float RadialRadius, optional float RadialStrength, optional vector PointImpulse,
			optional vector PointImpulsePosition, optional name PointImpulseBoneName );

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	ClearTimer(nameof(AmbientSounds));
	return Super.Died(Killer,DamageType,HitLocation);
}

function ANIM_NOTIFY_DoMeleeDamage()
{
	local GearWeap_NemaSlugMelee	Wpn;
	local float Tolerance;
	local actor HitActor;
	local vector HitNormal,HitLocation;
	local vector Start, End;

	if( IsDoingSpecialMove(GSM_SwipeAttack) )
	{
		Wpn = GearWeap_NemaSlugMelee(Weapon);
		Tolerance = Controller.Enemy.GetCollisionRadius() + GetAIMeleeAttackRange();

		if( Wpn != None )
		{
			Start = Location;
			End = Start + vector(Rotation) * Tolerance;
			Start += Normal(End-Start) * GetCollisionRadius();
			HitActor = Trace(HitLocation,HitNormal,End,Start,TRUE,vect(25.f,25.f,25.f));

			if(HitActor == Controller.Enemy)
			{
				Wpn.DoMeleeDamage( Controller.Enemy, Controller.Enemy.Location, 1.f );
			}
			//`log(GetFuncName()@HitActor);
		}
	}
}

/** Play Hit Reaction animation */
simulated function bool PlayHitReactionAnimation(ImpactInfo Impact)
{
	BS_HitReaction.Stance.Length = 1; // Array of struct needs to be pre-sized.
	BS_HitReaction.Stance[0].Slot = BS_FullBody;
	BS_HitReaction.Stance[0].AnimName = 'NS_HitReact';
	BS_PlayByDuration(BS_HitReaction,0.5f,0.3,0.33f,true,true);
	SetTimer(0.25f,FALSE,nameof(StopHitReact));
	return true;
}

simulated function StopHitReact()
{
	BS_Stop(BS_HitReaction,0.33f);
}

/** blow up guy when he is dead **/
simulated function PlayDeath(class<GearDamageType> GearDamageType, vector HitLoc)
{
	// Abort current special move
	if( IsDoingASpecialMove() )
	{
		EndSpecialMove();
	}

	Super.PlayDeath( class'GDT_Explosive', HitLoc );

	// this is non gore so we are just going to scale the dead body out and play a particle effect to help sell the "death"
	// safety net for when somehow the create gore skeleton/goreexplosion doesn't occur correctly
	if( !bHasGoreExploded )
	{
		PlayNonGoreDeath( GearDamageType, HitLoc );
	}
}

/** This will play the non blood and gore explosion Death.  Which right now is a particle and then quickly fading out**/
simulated function PlayNonGoreDeath(class<GearDamageType> GearDamageType, vector HitLoc)
{
	// particle effect here
	WorldInfo.MyEmitterPool.SpawnEmitter(PS_NonExtremeContentDeathEffect, Location, Rotation);
	SetTimer( 2.0f, FALSE, nameof(GoreAroundTooLong) );
}

function float GetAIAccuracyModWhenTargetingMe(GearAI GuyTargetingMe)
{
	return 0.5f;
}

simulated function vector GetMeleeHitTestLocation()
{
	return Location + vect(0,0,40);
}

defaultproperties
{
	ControllerClass=class'GearAI_NemaSlug'

	Begin Object Name=MyLightEnvironment
		bSynthesizeSHLight=FALSE
	End Object

	Begin Object Name=GearPawnMesh
		bHasPhysicsAssetInstance=TRUE
	End Object

	Begin Object Name=CollisionCylinder
		CollisionHeight=+0042.000000
	End Object

	Health=25

	bCanDoRun2Cover=FALSE
	bCanDBNO=FALSE
	bRespondToExplosions=FALSE

	HearingThreshold=6000.f
	PelvisBoneName=none

	AimAttractors(0)=(OuterRadius=96.f,InnerRadius=32.f,BoneName="NC_Head")

	SpecialMoveClasses(GSM_SwipeAttack)	=class'GSM_NemaSlug_Melee'
	SpecialMoveClasses(SM_Emerge_Type1)	=class'GSM_Nemaslug_Emerge'

	bNoDeathGUDSEvent=TRUE

	BaseEyeHeight=10
	EyeHeight=10
}
