/**
 * Bullet tracer projectile
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearProj_BulletTracer extends GearProj_Tracer
	native(Weapon);

var protected transient vector DestinationLoc;

var bool bAllowTracersMovingFromTarget;

/** ref to attached PSC (if there is one) */
var transient ParticleSystemComponent AttachedPSC;

cpptext
{
	virtual void TickSpecial(FLOAT DeltaSeconds);
}

function InitTracer(vector Start, vector End)
{
	local vector Direction;

	DestinationLoc = End;

	Direction = End - Start;
	Super.Init(Normal(Direction));

	LifeSpan = 0.0;

	SetHidden(false);
	Mesh.SetHidden(false);
	SetPhysics(PHYS_Projectile);
	SetTickIsDisabled(false);
}

function Recycle()
{
	local GearEmitterPool GEP;
	SetHidden(TRUE);
	Mesh.SetHidden(TRUE);
	SetTickIsDisabled(true);

	bScaledUp		= TRUE;
	bScalingDown	= FALSE;
	bAllowTracersMovingFromTarget = default.bAllowTracersMovingFromTarget;
	ExtraKeepAliveTime = default.ExtraKeepAliveTime;
	SetOwner(None);

	SetPhysics(PHYS_None);

	ClearTimer('WakeProjectile');

	GEP = GearEmitterPool(WorldInfo.MyEmitterPool);
	if( AttachedPSC != none )
	{
		GEP.OnParticleSystemFinished(AttachedPSC);
		AttachedPSC=none;
	}

	GEP.ReturnTracer(self);
}

function Reset()
{
	Recycle();
}

simulated event KillProjectile()
{
	if (!bAllowTracersMovingFromTarget)
	{
		SetLocation(DestinationLoc);
	}
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		Super.KillProjectile();
	}
	else
	{
		Recycle();
	}
}

simulated event ScaleDownFinishedNotify()
{
	Recycle();
}

/** Just in case. */
simulated event OutsideWorldBounds()
{
	Recycle();
}

/** Overridden because we don't want to explode on Pawns */
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	// Do not allow self damage
	if( Other == Instigator )
	{
		return;
	}

	// If can deal damage, then do so and destroy projectile. Otherwise, check if laser can bounce off.
	if( !Other.IsA('Projectile') ||	Other.bProjTarget )
	{
		if( Pawn(Other) != None )
		{
			// don't spawn impact effect on Pawns, just destroy.
			Recycle();
		}
		else
		{
			Explode(HitLocation, HitNormal);
		}
	}
}

defaultproperties
{
	bCollideWhenPlacing=FALSE
	Lifespan=0

	AccelRate=15000
	Speed=3500
	MaxSpeed=15000
	Damage=0
	MomentumTransfer=0
	MyDamageType=class'GDT_Ballistic'

	Begin Object Class=StaticMeshComponent Name=TracerMeshComp
		StaticMesh=StaticMesh'COG_AssaultRifle.Mesh.S_Tracer_New'
		HiddenGame=FALSE
		CastShadow=FALSE
		CollideActors=FALSE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
		bDisableAllRigidBody=TRUE
		Scale3D=(X=1.0,Y=1.0,Z=1.0)
		bAcceptsLights=FALSE
		bAcceptsDynamicLights=FALSE
		bCastDynamicShadow=FALSE
		bAcceptsStaticDecals=FALSE
		bAcceptsDynamicDecals=FALSE
	End Object
	Mesh=TracerMeshComp
	Components.Add(TracerMeshComp)

	RemoteRole=ROLE_None
	bNetInitialRotation=TRUE

	bCollideActors=FALSE
	bCollideWorld=FALSE
}
