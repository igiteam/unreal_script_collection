/**
 * Tracer Projectile
 * Base class for tracer-like projectile types.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearProj_Tracer extends GearProjectile
	abstract
	native(Weapon)
	transient;

/** Acceleration rate of projectile */
var()	float				AccelRate;
/** Mesh used by projectile */
var()	StaticMeshComponent	Mesh;
/** Time in seconds taken by the mesh to grow */
var()	float				MeshScaleUpTime;
/** Time in seconds taken by the mesh to shrink.  Calculated programamatically. */
var		transient float		MeshScaleDownTime;
/** Has mesh fully scaled up? */
var		bool				bScaledUp;
/** Is Mesh scaling down? */
var		bool				bScalingDown;
/** Current mesh scale. */
var		float				CurScale;

/** This is the draw scale 3D for this tracer **/
var vector TracerDrawScale3D;

/** added minimum lifetime after the projectile hits to stick around (for custom effects, defaults to 0) */
var transient float ExtraKeepAliveTime;

cpptext
{
	virtual void TickSpecial(FLOAT DeltaSeconds);
	virtual void FindBase()
	{
		// don't generally need a base for tracers; if we do, we'll set it manually
	}
}

/** Check on various replicated data and act accordingly. */
simulated event ReplicatedEvent( name VarName )
{
	Super.ReplicatedEvent(VarName);

	if (VarName == 'Velocity' || VarName == 'InitialFrameOfRefVelocity')
	{
		CalcTracerAccel();
	}
}

simulated protected function CalcTracerAccel()
{
	local vector AccelDir;

	// if adding base vel, we still want to accelerate along the local-frame component of the velocity
	AccelDir = bAddBaseVelocity ? (Velocity - InitialFrameOfRefVelocity) : Velocity;
	Acceleration = Normal(AccelDir) * AccelRate;
}

/** Overridden to set initial acceleration */
function Init(vector Direction)
{
	Super.Init(Direction);

	CalcTracerAccel();
	bScaledUp = false;
	bScalingDown = false;
	CurScale = 0.f;
	Mesh.SetHidden(false);
}


/**
 * If not on dedicated server, then freeze projectile and scale staticmesh down.
 * Because mesh can be big, and just destroying it is too harsh.
 * On Dedicated server, destroy right away.
 */

simulated event KillProjectile()
{
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		// calculate this so the tracer's apparent speed stays the same.
		// i.e. the tail doesn't appear to slow down just because the head stopped.
		MeshScaleDownTime = Abs((Mesh.Bounds.BoxExtent >> Rotation).X) * 2.0 * CurScale / VSize(Velocity);

		// Delay projectile's destruction until it has fully shrunk
		SetPhysics(PHYS_None);
		bScaledUp = true;
		bScalingDown = true;
		if (ExtraKeepAliveTime > 0.0)
		{
			SetTimer(ExtraKeepAliveTime, false, nameof(ScaleDownFinishedNotify));
		}
	}
	else
	{
		Destroy();
	}
}

/** Projectile's destruction */
simulated function Explode(vector HitLocation, vector HitNormal)
{
	SpawnImpactEffect(HitLocation, HitNormal);
	KillProjectile();
}

simulated function SpawnImpactEffect(vector HitLocation, vector HitNormal);

simulated event ScaleDownFinishedNotify()
{
	Destroy();
}

simulated event ScaleUpFinishedNotify()
{
	bScaledUp = true;
	SetDrawScale3D(TracerDrawScale3D);
}

defaultproperties
{
	TickGroup=TG_DuringAsyncWork
	MeshScaleUpTime=0.15

	// remove light environment from tracers
	Begin Object Name=MyLightEnvironment
		bEnabled=false
	End Object
	Components.Remove(MyLightEnvironment)
	ProjLightEnvironment=None

	TracerDrawScale3D=(X=1.0,Y=1.0,Z=1.0)
	ExtraKeepAliveTime=0.0
}
