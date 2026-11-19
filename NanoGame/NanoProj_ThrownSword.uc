/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProj_ThrownSword extends NanoProj_ThrownWeapon
	config(Weapon);

/** How fast the sword projectile moves */
var	config float	SwordThrowSpeed;

/** Pointer to pawn impaled on sword */
var NanoInterface_Targetable ImpaledRef;


/** The location/rotation that sword was at when it impaled something */
var transient vector ImpaledLocation;
var transient rotator ImpaledRotation;

/** The perch point that is spawned when a sword is thrown into a wall. **/
var NanoSpringPoint_Spawnable PerchPoint;
var name PerchSocketName;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	Speed = SwordThrowSpeed;
}

/** When you touch something (like another player) see if we should impale them */
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local NanoPawn NP;
	local NanoInterface_Targetable NTI;
	local Rotator PawnRot;

	// Don't stick to Lyrik
	if( Other == Instigator )
		return;

	NP = NanoPawn(Other);
	NTI = NanoInterface_Targetable(Other);
	// Either its not a NanoPawn, or its a NanoPawn that is alive and vulnerable
	if( (ImpaledRef == None) && (NTI != None) && (NP == None || (NP.Health > 0 && !NP.bPawnInvulnerable)) )
	{
		if( ( NP != None ) && (NP.bHasShield) )
		{
			NP.Knockdown(1.f);
			DestroyedFromHittingAnImmovableObjectEffects();
			Destroy();
		}
		else
		{
			PlaySound(SoundCue'Weapon_Sword.Sword.Sword_StickInWall_Body_Cue',TRUE);
			// Do enough damage to insta-kill (TODO: always?)
			Other.TakeDamage(100000, Instigator.Controller, HitLocation, Velocity, class'NanoGame.NDT_NanoSwordThrown',,self);

			// so here we want to do the toque bow-esque fly through people!
			// if we hit a bot just keep going!!
			// TODO: add in head shots or other crazy line of dudes throwing
			if( NanoPawn_MetaCorp_SentryBotBase(Other) != none )
			{
				return;
			}

			// If we killed the pawn - attach to projectile (see also NanoPawn.PlayDying)
			if( NP != None && NP.Health <= 0)
			{
				NP.SetHardAttach(TRUE);
	
				PawnRot = rotator(vect(-1,0,0) >> Rotation);
				NP.SetRotation(PawnRot);
				NP.SetBase(self);
			}
			else
			{
				SetPhysics(PHYS_None);
				Velocity = vect(0,0,0);
				Acceleration = vect(0,0,0);

				CreateSwordPerchPoint();
			}

			ImpaledLocation = Location;
			ImpaledRotation = Rotation;
			ImpaledRef = NTI;

			if( NTI != None )
			{
				NTI.NotifyImpaledBySword( self );
			}
		}
	}
}

/** When you hit a wall - stop */
simulated singular event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	local NanoInterface_Targetable NTI;

	// Play sound (depending on if we have someone impaled)
	if(ImpaledRef == none)
	{
		PlaySound(SoundCue'Weapon_Sword.Sword.Sword_Surface_StickIn_Cue');
	}
	else
	{
		PlaySound(SoundCue'Weapon_Sword.Sword.Sword_StickInWall_Body_Cue');
	}
		

	SetPhysics(PHYS_None);
	Velocity = vect(0,0,0);
	Acceleration = vect(0,0,0);

	CreateSwordPerchPoint();

	NTI = NanoInterface_Targetable(Wall);

	if( NTI != none )
	{
		Wall.TakeDamage( 100000, Instigator.Controller, Location, Velocity, class'NanoGame.NDT_NanoSwordThrown',,self);
	}
}


function CreateSwordPerchPoint()
{
	local Vector PerchLoc;
	local Rotator PerchRot;

	// so here spawn a perch point
	MeshComp.GetSocketWorldLocationAndRotation( PerchSocketName, PerchLoc, PerchRot );
	PerchPoint = Spawn( class'NanoSpringPoint_Spawnable', self,, PerchLoc,,, TRUE );
	PerchPoint.SetBase( self,, MeshComp, PerchSocketName );
	PerchPoint.LifeSpan = LifeSpan;
}


simulated event GetActorEyesViewPoint( out vector out_Location, out Rotator out_Rotation )
{
	if(ImpaledRef == None)
	{
		out_Location = Location + (FollowCameraOffset >> Rotation);
		out_Rotation = Rotation;
	}
	else
	{
		out_Location = ImpaledLocation + (FollowCameraOffset >> ImpaledRotation);
		out_Rotation = ImpaledRotation;
	}
}

defaultproperties
{
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'REB_Talon.SK_REB_Talon'
		PhysicsAsset=PhysicsAsset'REB_Talon.SK_REB_Talon_Physics'
		Rotation=(Pitch=16384,Yaw=32768)
		Translation=(X=-64,Y=0,Z=0)
	End Object

	TrailTemplate=ParticleSystem'Nano_WeaponFX.Sword.Effects.P_FX_SwordThrownTrail'

	PerchSocketName="PerchPoint"
	LifeSpan=360
}