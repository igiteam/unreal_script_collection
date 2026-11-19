/**
 * Pacifier Bot Limb - Base class for all miniguns
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class PacifierLimb_GunBase extends Pacifier_LimbBase
	implements(NanoInterface_JuggleTarget);

/** Whether gun has been stuck by a sword or not */
var NanoProj_ThrownSword ImpaledSword;
/** Defines the explosion. */
var() instanced editinline NanoExplosion	ExplosionTemplate;
/** Damage taken by an impaled sword */
var() config int DamageByImpaledSword;

/** Aim offset variables */
var() Name	AimOffsetNodeName;
var() editinline AnimNodeAimOffset AimOffsetNode;
var() vector2d	MinMaxAimX;
var() vector2d	MinMaxAimY;
var() vector2d	DesiredAim;

function InitLimb( NanoAI_PacifierBot C )
{
	Super.InitLimb( C );

	AimOffsetNode = AnimNodeAimOffset(Bot.Mesh.FindAnimNode( AimOffsetNodeName ));
}

simulated function UpdateMesh( float DeltaTime )
{
	local Vector VectToTarget;

	if( AimOffsetNode != None && bEnabled )
	{
		if( FireTarget != None )
		{
			VectToTarget = Normal(FireTargetLocation-Location) << Bot.Rotation;
			DesiredAim.X = FClamp( NormalizeRotAxis(Rotator(VectToTarget).Yaw)/16384.f, MinMaxAimX.X, MinMaxAimX.Y );
			DesiredAim.Y = FClamp( NormalizeRotAxis(Rotator(VectToTarget).Pitch)/16384.f, MinMaxAimY.X, MinMaxAimY.Y );
		}
		else
		{
			DesiredAim.X = 0;
			DesiredAim.Y = 0;
		}
		AimOffsetNode.Aim.X = FInterpTo( AimOffsetNode.Aim.X, DesiredAim.X, DeltaTime, 10 );
		AimOffsetNode.Aim.Y = FInterpTo( AimOffsetNode.Aim.Y, DesiredAim.Y, DeltaTime, 10 );
	}
}

/** Whether this target is a valid juggle target */
simulated function bool IsValidJuggleTarget()
{
	return (Health > 0 && FireTarget != None);
}


simulated function ResolveJuggleVars( Controller InstigatedBy, out float out_JuggleMag, out float out_JuggleZ, out Vector out_JuggleDir, bool bShootingFromAbove )
{
	local NanoPC PC;
	local Vector HitDir;

	// If shot by a player -- give them a chance to steer the juggle if it is active
	PC = NanoPC(InstigatedBy);
	if( PC != None )
	{
		HitDir = out_JuggleDir;
		out_JuggleDir = vect(0,0,0);
		if( PC.GetActivelyJuggledActor() == self )
		{
			if( PC.PlayerInput.RawJoyLookUp > 0.5f )
			{
				out_JuggleZ = -out_JuggleZ;
			}
			if( PC.PlayerInput.RawJoyLookRight > 0.5f )
			{
				out_JuggleDir.Y += 1.f;
				out_JuggleZ = 0.f;
			}
			else if( PC.PlayerInput.RawJoyLookRight < -0.5f )
			{
				out_JuggleDir.Y -= 1.f;
				out_JuggleZ = 0.f;
			}
			out_JuggleDir = Normal(out_JuggleDir);
			if( !IsZero( out_JuggleDir ) )
			{
				out_JuggleDir = out_JuggleDir >> Rotator(HitDir);
			}
			else
			{
				out_JuggleMag = 0.f;
			}
		}
		else
		{
			out_JuggleMag = 0.f;
		}
	}
}

function ApplyJuggle( float JuggleMag, float JuggleZ, Vector Dir, optional NanoPawn Juggler, optional bool bDoKnockBack )
{
	bJuggled = TRUE;
	FireTargetLocation += Dir * JuggleMag * 0.5;
	FireTargetLocation.Z += JuggleZ;

	SetTimer( 2.f, FALSE, nameof(ClearJuggle) );

	if( Juggler != None )
	{
		Juggler.LastCausedJuggleTime = WorldInfo.TimeSeconds;
		Juggler.LastCausedJuggleActor = self;
	}
}

function ClearJuggle()
{
	ClearTimer(nameof(ClearJuggle));
	bJuggled = FALSE;
}


function FireWeapon()
{
	local NanoExplosionActor ExplosionActor;

	ClearJuggle();

	// If gun is impaled by a sword... instead of firing, trigger explosion!
	if( ImpaledSword != None )
	{
		ExplosionActor = Spawn(class'NanoExplosionActor',,, Location, Rotator(vect(0,0,1)));
		if( ExplosionActor != None )
		{
			ExplosionActor.Instigator = Bot;
			ExplosionActor.InstigatorController = Bot.Controller;

			ExplosionTemplate.HitActor		= Bot;
			ExplosionTemplate.HitLocation	= Location;
			ExplosionTemplate.HitNormal		= vect(0,0,1);

			ExplosionActor.Attachee = Bot;
			ExplosionTemplate.bAttachExplosionEmitterToAttachee = TRUE;
			ExplosionActor.SetBase(Bot);

			ExplosionActor.Explode(ExplosionTemplate);
		}

		// Do damage to limb
		TakeDamage( DamageByImpaledSword, ImpaledSword.InstigatorController, ImpaledSword.Location, vect(0,0,0), class'NDT_Bomb',, ImpaledSword );
		// Cleanup sword actor
		ImpaledSword.Destroy();
		ImpaledSword = None;
		// Prevent firing for a little bit
		NextAllowFireTime = WorldInfo.TimeSeconds + GetRefireDelay();
	}
	else
	{
		Super.FireWeapon();
	}
}

function GetWeaponFireInfo( out Vector out_FireStart, out Rotator out_FireDir, optional out Actor out_Target )
{
	Super.GetWeaponFireInfo( out_FireStart, out_FireDir, out_Target );
	if( CurrNanoState == ENS_Dense )
	{
		out_FireDir = Rotator(vect(0,0,-1));
	}
}

simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword )
{
	// Handle double swords... just destroy the old one
	if( ImpaledSword != None )
	{
		ImpaledSword.Destroy();
	}
	ImpaledSword = Sword;

	if( Weapon != None && Weapon.IsFiring() )
	{
		StopFire();
	}
}

simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return FALSE;
}

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if( DamageType == class'NDT_NanoSwordThrown' )
	{
//		`log( self@GetFuncName()@Damage@InstigatedBy@DamageType@DamageCauser );
		Damage = 0;
	}

	Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser );
}


/////////////////////////////////////////////////////
//////// INTERFACE: NanoInterface_PowerAffect ////////
/////////////////////////////////////////////////////
simulated function bool CanBeDensed()
{
	return (CurrNanoState != ENS_Dense);
}

defaultproperties
{
	Begin Object Class=NanoExplosion Name=ExploTemplate0
		ParticleEmitterTemplate=ParticleSystem'Nano_WeaponFX.Missile.Effects.P_FX_MissileExplosion_01'
		ExplosionSound=SoundCue'Weapon_Pistol.Pistol.Pistol_FirePlayer_Cue'

		MyDamageType=class'NDT_Bomb'
		MomentumTransferScale=1.f	// Scale momentum defined in DamageType
	End Object
	ExplosionTemplate=ExploTemplate0

	MinMaxAimX=(X=-1.f,Y=1.f)
	MinMaxAimY=(X=-1.f,Y=1.f)
}
