/**
  * The base class for the cleaver projectile
  *
  * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
  */
class GearProj_CleaverBase extends GearProjectile
	abstract;

/** Don't want HandleCollision() to be re-entrant (it does a setlocation()) */
var protected transient bool bProcessingCollision;

/** Block double spawning the pickup */
var repnotify protected bool bSpawnedPickup;

/** A reference to the cleaver inventory item since we're generating a pickup on the fly */
var	Inventory Inventory;

/** Saving the initial location allows throw distance calculations */
var protected vector InitialLocation;

/** Saving the initial rotation helps fixing the stuck rotation */
var protected rotator InitialRotation;

/** The class to use when spawning a cleaver pickup */
var const class<Inventory> DroppedCleaverClass;

/** The farthest away the cleaver should be able to stick into objects */
var protected config float MaxPenetrateDistance;

/** The farthest away the cleaver should be able to damage a pawn */
var protected config float MaxDamageDistance;

/** How long the cleaver should stay lodged in a pawn */
var protected config float MaxStickInPawnTime;

/** How long the cleaver should fly before gravity kicks in */
var protected config float MaxFlightTime;

/** Has MaxFlightTime expired? */
var protected bool bNotInFlight;

/** How much damage to inflict on hit */
var protected config float CleaverDamage;

/** Sound to play when the cleaver sticks in a pawn */
var SoundCue ImpaleSound;

/** Sound to play when the cleaver sticks into the world */
var SoundCue ImpactSurfaceSound;

/** Cleaver Mesh **/
var SkeletalMeshComponent CleaverMesh;

var repnotify bool bDelayedArc;

/** Dropped cleaver class **/
var const class<GearDroppedPickup_Cleaver> CleaverDroppedClass;

replication
{
	if (bNetInitial)
		bDelayedArc;

	if (bNetDirty)
		bSpawnedPickup;
}

function Init(vector Direction)
{
	Super.Init(Direction);
	if (Role == ROLE_Authority && Instigator != None && Instigator.IsHumanControlled())
	{
		DelayArc();
	}
}

simulated function DelayArc()
{
	bDelayedArc = true;
	Acceleration = vect(0,0,0);
	// start arch 1 second before
	SetTimer(MaxFlightTime, false, nameof(FlightExpired));
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(bDelayedArc))
	{
		if (bDelayedArc)
		{
			DelayArc();
		}
		else if (IsTimerActive(nameof(FlightExpired)))
		{
			ClearTimer(nameof(FlightExpired));
			FlightExpired();
		}
	}
	else if (VarName == nameof(bSpawnedPickup))
	{
		if (bSpawnedPickup)
		{
			SetHidden(true);
			CleaverMesh.SetHidden(true);
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

/** Save the inital location and rotation of the cleaver */
simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	InitialLocation = Location;
	InitialRotation = Rotation;
}

/** MaxFlightTime seconds have gone by, gravity kicks in */
function FlightExpired()
{
	bNotInFlight = true;
	Acceleration.Z = GetGravityZ() * GravityScale;

	bDelayedArc = false;
}

/**
* Called when the cleaver touches an Actor
*
* @param	Other - the Actor that the Cleaver collided with
*
* @param	OtherComp - the PrimitiveComponent of the colliding Actor
*
* @param	HitLocation - the point in space that the Cleaver and the Actor collided
*
* @param	HitNormal - the normal of the impact
*/
simulated singular event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	HandleCollision(Other, OtherComp, HitLocation, HitNormal);
}

/**
* Called when the cleaver bumps an Actor
*
* @param	Other - the Actor that the Cleaver collided with
*
* @param	OtherComp - the PrimitiveComponent of the colliding Actor
*
* @param	HitNormal - the normal of the impact
*/
simulated event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	HandleCollision( Other, OtherComp, Location, HitNormal );
}

/**
* Called when the cleaver hits a wall
*
* @param	Other - the Actor that the Cleaver collided with
*
* @param	OtherComp - the PrimitiveComponent of the colliding Actor
*
* @param	HitNormal - the normal of the impact
*/
simulated function HitWall( vector HitNormal, Actor Wall, PrimitiveComponent WallComp )
{
	HandleCollision( Wall, WallComp, Location, HitNormal );
}


/** Enable movement replication before the physics are disabled */
simulated protected function StopSimulating()
{
	RotationRate = rot(0,0,0);
	bReplicateMovement = true;
	bUpdateSimulatedPosition = true;
	Super.StopSimulating();
}

/** Make the cleaver handle stick out by moving it backwards and adjusting the rotation */
function FixPosition(vector HitLocation, vector Direction)
{
	SetLocation(HitLocation - Direction * 45.f);
}

/** Check to see if it should spawn Pickups **/
simulated function CheckSpawnPickup()
{
	local GearPawn GP;
	GP = GearPawn(Base);

	// if Pawn is dead or it's not DBNO anymore or he's hostage
	if ( GP==none || GP.Mesh==none || GP.Mesh.HiddenGame )
	{
		// weapon keep disappearing isn't happy - spawning it again
		SpawnPickup(FALSE);
		ClearTimer(nameof(CheckSpawnPickup));
	}
}
/** Destroy the projectile and spawn a cleaver pickup */
function SpawnPickup(bool bHit, optional vector HitLoc, optional vector HitNormal)
{
	local GearDroppedPickup_Cleaver CleaverPickup;
	local vector DropLocation;
	local rotator DropRotation;

	if (bSpawnedPickup)
		return;

	bSpawnedPickup = true;

	ClearTimer(nameof(CheckSpawnPickup));
	ClearTimer(nameof(SpawnPickup));
	SetHidden(TRUE);
	SetBase(none);
	CleaverMesh.SetHidden(TRUE);

	StopSimulating();

	DropLocation = Location;
	DropRotation = Rotation;

	if (FindSpot(vect(50, 50, 20), DropLocation))
	{
		// try to spawn @ current location
		// FIXME: this code has to be more smart about where to spawn
		// Try all different direction to find best spot to spawn
		CleaverPickup = Spawn(CleaverDroppedClass,,,DropLocation, DropRotation);
	}
	// if failed, we should try other spots, try higher
	else 
	{
		// don't want to lose weapon
		DropLocation.Z += 20;

		if ( FindSpot(vect(50, 50, 20), DropLocation) )
		{
			// if spawning at current location fails, try a bit higher
			// when the bump notification comes, it is usually too late, so trying a bit highre will give more change to spawn
			// better solution in the future is to find box that can spawn correctly
			CleaverPickup = Spawn(CleaverDroppedClass,,,DropLocation, DropRotation);
		}
		else
		{
			// don't want to lose weapon
			// randomly pick up X location. Last try
			DropLocation.X += 50;

			if ( FindSpot(vect(50, 50, 20), DropLocation) )
			{
				// if spawning at current location fails, try a bit higher
				// when the bump notification comes, it is usually too late, so trying a bit highre will give more change to spawn
				// better solution in the future is to find box that can spawn correctly
				CleaverPickup = Spawn(CleaverDroppedClass,,,DropLocation, DropRotation);
			}
		}
	}

	if (CleaverPickup != none)
	{
		// add collision so that it detects early
		CleaverPickup.SetPhysics(PHYS_Falling);
		CleaverPickup.Inventory = Inventory;
		CleaverPickup.InventoryClass = DroppedCleaverClass;
		if (bHit == FALSE)
		{
			// if not hit yet, just keep go
			CleaverPickup.Velocity = vect(0, 0, 0);
		}
		else
		{
			//P.Velocity = HitNormal;
			CleaverPickup.Velocity = Velocity;
		}

		CleaverPickup.Instigator = Instigator;
		CleaverPickup.SetDefaultMesh();
	}

	// if I destroy now, it won't replicate, so I'll destroy a bit later
	// so that client has to hide mesh properly first before it gets destroyed
	// otherwise client will see two meshes
	SetTimer(0.5f, FALSE, 'DestroyProjectile');
}

/* Destroy projectile **/
simulated function DestroyProjectile()
{
	Destroy();
}
/**
  * Determine whether to stick into an object or bounce and spawn a cleaver pickup
  *
  * @param	Other - the Actor that the Cleaver collided with
  *
  * @param	OtherComp - the PrimitiveComponent of the colliding Actor
  *
  *	@param	HitLocation - the point in space that the Cleaver and the Actor collided
  *
  *	@param	HitNormal - the normal of the impact
  */
simulated function HandleCollision( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local Pawn			HitPawn;
	local TraceHitInfo	HitInfo;
	local float			ThrowDistance;

	// make sure we haven't stopped moving already
	if (Physics != PHYS_Projectile)
	{
		return;
	}

	if (bProcessingCollision || Other == None || Other == Instigator || Other.bTearOff || Other.IsA('Trigger'))
	{
		// shouldn't collide with instigator
		return;
	}

//	`log("Handle Collision on Cleaver with "@Other);

//	DebugFreezeGame();

	// We're way too far for the throw to be effective.
	if (bNotInFlight)
	{
		SpawnPickup(TRUE, HitLocation, HitNormal);
		return;
	}

	HitPawn		= Pawn(Other);

	ThrowDistance = VSize(Location - InitialLocation);

	//DrawDebugSphere(HitLocation, 10, 10, 0, 255, 0, true );
	//DrawDebugSphere(HitLocation - ThrowDir * 45, 10, 10, 255, 255, 255, true );

	bProcessingCollision = true;

	if( HitPawn != None || Other.bProjTarget || Other.bWorldGeometry || Other.bBlockActors )
	{
		// stick into whatever we hit
		if( HitPawn != None )
		{
			if (ThrowDistance < MaxPenetrateDistance && !GearPawn(HitPawn).IsDBNO() && !Instigator.IsSameTeam(HitPawn))
			{
				CheckHitInfo( HitInfo, HitPawn.Mesh, Normal(Velocity), HitLocation );

				// remove dot check. Confusing why it hits sometimes but don't other times
				if (HitInfo.BoneName != '' && GearPawn(HitPawn).CanDoSpecialMove(SM_CleaverStabbed))
				{
					// This must happen before TakeDamage is called. If we do this special move while DBNO, it messes things up.
					GearPawn(HitPawn).DoSpecialMove(SM_CleaverStabbed, TRUE);
				}

				HitPawn.TakeDamage(CleaverDamage,InstigatorController,HitLocation,vect(0,0,1.f),class'GDT_Cleaver',HitInfo);
				AttachToActor(HitPawn);
				SetTimer(0.5f, TRUE, nameof(CheckSpawnPickup));

			}
			else
			{
				if (ThrowDistance < MaxDamageDistance)
				{
					HitPawn.TakeDamage(CleaverDamage,InstigatorController,HitLocation,vect(0,0,1.f),class'GDT_Cleaver');
				}

				SpawnPickup(TRUE, HitLocation, HitNormal);
			}
		}
		else
		{
			if (ThrowDistance < MaxPenetrateDistance && Other.bWorldGeometry)
			{
				AttachToActor(Other);
				// Don't spawn a pickup when the projectile is destroyed
				bSpawnedPickup = true;
			}
			else
			{
				// No more sticking on geometry
				// after discussion @ Lee P, it's not going to stick to geometry. 
				// It will just spawn pickups
				SpawnPickup(TRUE, HitLocation, HitNormal);
			}
		}
	}

	bProcessingCollision = false;
}

simulated function AttachToActor(Actor Attachee)
{
	local SkeletalMeshComponent VictimMesh;
	local vector HitLoc, HitNorm, ToPawn;
	local TraceHitInfo HitInfo;
	local Name BoneName;
	local Pawn AttacheePawn;

	if(Role == ROLE_Authority)
	{
		// Handle case of attaching to SMCA - just use WorldInfo instead.
		if( StaticMeshCollectionActor(Attachee) != None)
		{
			Attachee = WorldInfo;
		}
	}


	SetPhysics(PHYS_None);
	SetCollision(FALSE,FALSE);
	StopSimulating();

	// Attach to pawn case
	AttacheePawn = Pawn(Attachee);
	if (AttacheePawn != None)
	{
		PlaySound(ImpaleSound);
		VictimMesh = AttacheePawn.Mesh;

		// Do a trace and see if hit a bone we can attach to
		if(TraceComponent(HitLoc, HitNorm, VictimMesh, Attachee.Location + vect(0,0,45), Location,, HitInfo))
		{
			// Got a bone - set location on the bone surface and using hit normal
			SetRotation(rotator(HitNorm) + rot(0,32768,0));
			SetLocation(HitLoc + (0.5 * 30*HitNorm)); // Put nade a bit closer on pawns
			// Note the bone name to return it
			BoneName = HitInfo.BoneName;

			SetBase(Attachee,, VictimMesh, BoneName);
		}
		// No bone hit - we just attach to the pawn
		else
		{
			// Get direction nade -> Pawn
			ToPawn = Normal((Attachee.Location + vect(0,0,30)) - Location);
			// Put it kind of in the pawn
			SetLocation(Attachee.Location - (20.0 * ToPawn));
			// And pointing the way we threw it
			SetRotation(rotator(ToPawn) + rot(0,32768,0));
			// Attach to actor
			SetBase(Attachee);
		}
	}
	// Attach to non-Pawn
	else
	{
		PlaySound(ImpactSurfaceSound);
		SetBase(Attachee);
	}

	StopInFlightAudio();

	if (TrailEmitter != None)
	{
		TrailEmitter.Destroy();
		TrailEmitter = None;
	}
}

// if base is non, and didn't spawn pick up yet, pickup
event BaseChange()
{
	if (Base == none)
	{
		SpawnPickup(FALSE);
	}

	Super.BaseChange();
}

defaultproperties
{
	Speed=1500
	MaxSpeed=2000

	Physics=PHYS_Projectile
	bHardAttach=TRUE

	bNetTemporary=false
	RemoteRole=ROLE_SimulatedProxy

	Lifespan=40.0
	bNetInitialRotation=true
	bCollideComplex=true
	
	Begin Object Name=CollisionCylinder
		CollideActors=TRUE
		// add collision so that it detects early
		CollisionRadius=50
		CollisionHeight=20
	End Object

	GravityScale=0.65f
}
