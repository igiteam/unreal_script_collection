/**
 * Base class for the kryll bat
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class KryllBatBase extends Actor
	abstract;

/** The skeletal mesh of the bat */
var() SkeletalMeshComponent		SKM;

/** Material the bats use */
var MaterialInstanceConstant    KryllMat;

/** How fast the bat is moving */
var	float						Speed;

/** How much the bat should try to avoid other bats */
var	float						AvoidanceFactor;

/** Scream sound */
var AudioComponent				ScreamSound;

/** The flock we belong to */
var protected KryllFlockBase	FlockOwner;

/** Replicated version of FlockOwner, network layer can send multiple copies so need to manually block re-entrancy */
var protected repnotify KryllFlockBase RepFlockOwner;

replication
{
	if (Role == ROLE_Authority)
		AvoidanceFactor, Speed, RepFlockOwner;
}

/**
 * Register a bat with the flock when replication tells us which one we belong to
 * 
 * @param VarName - the name of the replicated variable
 */
simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'RepFlockOwner')
	{
		if ((RepFlockOwner != None) && (FlockOwner != RepFlockOwner))
		{
//			`log(self@GetFuncName()@"registering bat"@RepFlockOwner@RepFlockOwner.FlockArray.Length);
			RepFlockOwner.RegisterBat(self);
		}
		FlockOwner = RepFlockOwner;
	}
	else
	{
		super.ReplicatedEvent(VarName);
	}
}

/** Set up our material */
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

	KryllMat = new(Outer) class'MaterialInstanceConstant';
	KryllMat.SetParent(SKM.GetMaterial(0));
	SKM.SetMaterial(0, KryllMat);

	// Keep the flapping out of sync with the rest of the flock
    SetTimer(FRand() * 2.0f, false);
}

/**
 * Register with the flock and set that up to replicate to clients
 * 
 * @param Flock - which flock to register with
 */
function SetFlockOwner(KryllFlockBase Flock)
{
	// clients will do this when FlockOwner replicates
	if (Role == ROLE_Authority)
	{
		FlockOwner = Flock;
		RepFlockOwner = Flock;		// will trigger replication to clients
		FlockOwner.RegisterBat(self);
//		`log(self@GetFuncName()@"registering bat"@FlockOwner@FlockOwner.FlockArray.Length);
	}
}

/** Play the flap animation */
simulated event Timer()
{
    SKM.PlayAnim('Flap_A',, true);
}

/** Drop from sky */
simulated function KryllFall()
{
	SetPhysics(PHYS_Falling);
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bAlwaysRelevant=true
	bReplicateMovement=FALSE

    bStatic=FALSE
    bNoDelete=FALSE

   	bBlockActors=FALSE
	bCollideActors=TRUE
	bCollideWorld=FALSE

	Physics=PHYS_Projectile
}