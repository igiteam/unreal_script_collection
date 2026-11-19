/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class CitySecurityCamera_Base extends NanoPawnBase
	implements(NanoInterface_Targetable,NanoInterface_Spawner,NanoInterface_PatrolDestination)
	abstract
	config(Pawn)
	native(Pawn);

var config float RespawnTime;

/** Cached patrol destination */
var transient Vector CachedPatrolDest;

// Interface function stubs
event HandleSpawn(NanoPawnBase NewSpawn, int SlotIdx);
event bool GetSpawnSlot(out int out_SpawnSlotIdx, out vector out_SpawnLocation, out rotator out_SpawnRotation);
event RegisterFactory(SeqAct_AIFactory Factory);
event UnRegisterFactory(SeqAct_AIFactory Factory);

simulated event PreBeginPlay()
{
	// important that this comes before Super so mutators can modify it
	if( HealthMax == 0 )
	{
		HealthMax = default.Health;
	}

	Super.PreBeginPlay();
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	NanoGRI(WorldInfo.GRI).RegisterTargetableActor(self);
}

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	`if(`notdefined(FINAL_RELEASE))
		local PlayerController PC;
	`endif

		`log( self @ "Damage:" @ Damage );

	// call Actor's version to handle any SeqEvent_TakeDamage for scripting
	Super(Actor).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

	// just simple take damage
	Health -= Damage;

	`if(`notdefined(FINAL_RELEASE))
	if (bDebugDamageText || class'NanoGRI'.default.bDebugShowDamage)
	{
		foreach WorldInfo.AllControllers(class'PlayerController',PC)
		{
			PC.AddDebugText(string(Damage),self,5.f,vect(0,0,64.f) ,vect(64.f,64.f,256.f) * VRand(),class'HUD'.default.RedColor,TRUE);
		}
	}
	`endif

	if( Health <= 0 )
	{
		// died
		Died( InstigatedBy, damageType, HitLocation );
	}
}


function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	// activate death events
	TriggerEventClass( class'SeqEvent_Death', self );

	//NanoGRI(WorldInfo.GRI).ModifyChaosLevel( GetChaosZone(), class'NanoCausingChaosValues'.default.CameraDestroyed );

	SetHidden( TRUE );
	SetCollision( FALSE, FALSE, FALSE );

	SetTimer( RespawnTime, FALSE, nameof(RespawnThisCamera) );

	return TRUE;
}



/** This will restore this camera to a functioning state.  MetaCorp makes only the best self repairing cameras! **/
simulated function RespawnThisCamera()
{
	SetHidden( FALSE );
	SetCollision( TRUE, TRUE, FALSE );
	Health = default.Health;
}

simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return (`TimeSince(LastRenderTime) < 1.f && QT == TQT_None);
}


/** Returns the Targetable Octree component */
simulated function TargetableOctreeComponent GetTargetableOctreeComponent()
{
	local TargetableOctreeComponent TargetableComp;

	foreach AllOwnedComponents( class'TargetableOctreeComponent', TargetableComp )
	{
		return TargetableComp;
	}

	return None;
}



simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	return 10.f; // these should be pretty low
}


/////////////////////////////////////////////////////
/// INTERFACE: NanoInterface_PatrolDestination //////
/////////////////////////////////////////////////////
simulated function bool GetPatrolDestination( out Vector out_PatrolDest )
{
	local Vector StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor	HitActor;

	if( !IsZero( CachedPatrolDest ) )
	{
		out_PatrolDest = CachedPatrolDest;
		return TRUE;
	}

	StartTrace = Location + (Vector(Rotation) * -64.f);
	EndTrace = StartTrace + (vect(0,0,1) * -512.f);
	HitActor = Trace( HitLocation, HitNormal, EndTrace, StartTrace );
	if( HitActor != None )
	{
		out_PatrolDest = HitLocation + vect(0,0,32.f);
		CachedPatrolDest = out_PatrolDest;
		return TRUE;
	}

	return FALSE;
}

/** When this NanoPawn is targetted, which location should we focus on */
simulated event vector GetTargetedLocation()
{
	return Location;
}

/** Rotation of the target.  Useful to see if they are facing some dir **/
simulated event rotator GetRotation()
{
	return Rotation;
}

/** How fast the target is currently moving **/
simulated event vector GetVelocity()
{
	return Velocity;
}

/** Pass in a struct and then have the interface fill in a ton of different firing targetable data **/
simulated function GetFiringTargetableDatum( out FiringTargetableDatum Out_FiringTargetableDatum );

simulated event BoxSphereBounds GetTargetableBounds()
{
	return Mesh.Bounds;
}


simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook );

simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return FALSE;
}

defaultproperties
{
	// Network
	RemoteRole=ROLE_SimulatedProxy
	NetPriority=+00002.000000
	bUpdateSimulatedPosition=TRUE

	bCollideActors=FALSE
	bCollideWorld=TRUE
	bBlockActors=FALSE

	ControllerClass=None

	Begin Object Class=AnimNodeSequence Name=AnimNodeSeq0
	End Object

	Begin Object Class=SkeletalMeshComponent Name=CamBaseMesh
		BlockZeroExtent=TRUE
		CollideActors=FALSE
		BlockRigidBody=FALSE
		bIgnoreControllersWhenNotRendered=TRUE
		bAcceptsStaticDecals=TRUE
		bAcceptsDynamicDecals=TRUE
		bCullModulatedShadowOnBackfaces=FALSE
		bAllowAmbientOcclusion=TRUE
		MotionBlurScale=0.0
		LightEnvironment=MyLightEnvironment

		MinDistFactorForKinematicUpdate=0.2f
		bUpdateSkelWhenNotRendered=FALSE
		bTickAnimNodesWhenNotRendered=FALSE
	End Object
	Components.Add(CamBaseMesh)
	CollisionComponent=CamBaseMesh
	Mesh=CamBaseMesh
}
