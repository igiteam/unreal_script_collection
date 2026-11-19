/**
 * NanoObjectPool
 *
 *   Our Object pool holder.  This should only ever be spawned on the client.  Right now we spawn
 * it from the NanoGRI.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 **/
class NanoObjectPool extends Actor
	native
	dependson(NanoTypes);



// this should be promoted to GameFramework.



/** Maximum number of tracers **/
const MAX_TRACERS = 20;

struct native TracerCacheDatum
{
	var int Type;

	var class<NanoProj_BulletTracer> TracerClass;

	/** Index of the most recently used tracer */
	var int ListIdx;

	/** List of tracers this weapon uses, for recycling */
	var NanoProj_BulletTracer List[MAX_TRACERS];
};

var transient TracerCacheDatum TracerCache[8]; // this is GearTypes.EWeaponTracerType EnumCount


// decal pooling

struct native DecalDatum
{
	var NanoDecal GD;
	/** The time this decal was spawned **/
	var float SpawnTime;
	/** The location where this decal was spawned.  We use this to determine if we should spawn decals near it **/
	var vector SpawnLoc;
	/** This is the distance away from another decal of this this type we must be away from so we can spawn ( this reduces having just a ton of decals all on top of each other which don't really add any visual quality and is actually really slow to render **/
	var float CanSpawnDistance;
};


struct native DecalPool
{
	var int MAX_DECALS;
	var int MAX_DECALS_bDropDetail;
	var int MAX_DECALS_bAggressiveLOD ;

	var array<DecalDatum> Decals; //[MAX_<TYPE>];
	var transient int DecalsIdx;
};

var transient DecalPool DecalPool_Blood;
var transient DecalPool DecalPool_Bullet;
var transient DecalPool DecalPool_Explosion;




//// Emitters for impact effects
const MAX_IMPACT_EMITTERS = 20;
const MAX_IMPACT_EMITTERS_SMALL = 10;


const MAX_IMPACT_PARTICLE_SYSTEMS = 20;
const MAX_IMPACT_PARTICLE_SYSTEMS_SMALL = 10;


struct native EmitterCacheDatum
{
	var int Type;

	/** We want to have different cache lines for effects so we need to store off the size of our line **/
	var int SizeOfList;

	var ParticleSystem ParticleSystemType;

	/** Index of the most recently used tracer */
	var int ListIdx;

	/** List of ParticleSystemComponent this weapon uses, for recycling */
	var ParticleSystemComponent PList[MAX_IMPACT_PARTICLE_SYSTEMS];

	/** List of Emitter this weapon uses, for recycling */
	var Emitter List[MAX_IMPACT_EMITTERS];

};

enum EWOPCacheTypes
{
	NOP_DEFAULT_GENERAL,
	NOP_MP5_IMPACT
};

/** default impacts (assaultCOG, assaultLocust), blood impacts, general pool **/
var transient array<EmitterCacheDatum> EmitterCache;







simulated event PreBeginPlay()
{
	CreatePools();
}


simulated event Destroyed()
{
	CleanUpPools();

	Super.Destroyed();
}


simulated final function CreatePools()
{
	EmitterCache.Length = EWOPCacheTypes.EnumCount;  // why do this here or not make this be static size above?
	//CreateMaterialInstanceConstants();
	CreateTracers();
 	CreateImpactEffects();
// 	CreateKActors();
// 	CreateDecals();
// 	CreatePathConstraintCache();
}


simulated final function CleanUpPools()
{
// 	CleanUpKActors();
// 	CleanupDecals();
 	CleanupEmitters();
// 	CleanupPathConstraints();
	CleanupTracers();
	// clean up the raindrops if we ever use them again

	// GC here
	WorldInfo.ForceGarbageCollection();
}


/** This will clean up up all of the emitters we have. **/
simulated final function CleanupEmitters()
{
	local int Idx;
	local int Jdx;

	// for each type of emitter
	for( Idx = 0; Idx < EmitterCache.Length; ++Idx )
	{
		// destroy the PSCs
		for( Jdx = 0; Jdx < MAX_IMPACT_PARTICLE_SYSTEMS; ++Jdx )
		{
			if( EmitterCache[Idx].PList[Jdx] != none )
			{
				EmitterCache[Idx].PList[Jdx].ResetToDefaults();
				EmitterCache[Idx].PList[Jdx] = none;
			}
		}

		// destroy the Emitters
		for( Jdx = 0; Jdx < MAX_IMPACT_EMITTERS; ++Jdx )
		{
			if( EmitterCache[Idx].List[Jdx] != none )
			{
				EmitterCache[Idx].List[Jdx].Destroy();
				EmitterCache[Idx].List[Jdx] = none;
			}
		}
	}
}




simulated final function CleanupTracers()
{
	local int Idx;
	local int Jdx;

	for( Idx = 0; Idx < 8; ++Idx )  // this is GearTypes.EWeaponTracerType EnumCount
	{
		for( Jdx = 0; Jdx < MAX_TRACERS; ++Jdx )
		{
			if( TracerCache[Idx].List[Jdx] != none )
			{
				TracerCache[Idx].List[Jdx].Destroy();
				TracerCache[Idx].List[Jdx] = none;
			}
		}
	}
}




// NOTE:  we probably want to call this on first usage of an effect so we are datadriven
simulated final function CreateImpactEffects()
{
	// emitters
	//CreateEmitter_List(NOP_DEFAULT_GENERAL,				ParticleSystem'COG_AssaultRifle.Effects.P_COG_AssaultRifle_Impact', MAX_IMPACT_EMITTERS, TRUE );

	CreateEmitter_List(NOP_MP5_IMPACT,				ParticleSystem'COG_AssaultRifle.Effects.P_COG_AssaultRifle_Impact', MAX_IMPACT_EMITTERS, TRUE );

	//CreatePS_List(NOP_DEFAULT_GENERAL,			ParticleSystem'COG_AssaultRifle.Effects.P_COG_AssaultRifle_Impact', MAX_IMPACT_PARTICLE_SYSTEMS, TRUE );
	CreatePS_List(NOP_MP5_IMPACT,			ParticleSystem'COG_AssaultRifle.Effects.P_COG_AssaultRifle_Impact', MAX_IMPACT_PARTICLE_SYSTEMS, TRUE );
}


simulated final function CreateEmitter_List(int EffectType, ParticleSystem PSTemplate, int NumToCreate, bool bForceCreate )
{
	local int Idx;
	local Emitter Emit;

	EmitterCache[EffectType].SizeOfList = NumToCreate;
	EmitterCache[EffectType].Type = EffectType;
	EmitterCache[EffectType].ParticleSystemType = PSTemplate;

	if( bForceCreate == TRUE )
	{
		for( Idx = 0; Idx < NumToCreate; Idx++)
		{
			Emit = EmitterCache[EffectType].List[Idx];
			CreateEmitter_Worker( EffectType, PSTemplate, Emit );
			EmitterCache[EffectType].List[Idx] = Emit;
		}
	}
}



simulated final function CreateEmitter_Worker(int EffectType, ParticleSystem PSTemplate, out Emitter Emit )
{
	local int Idx;

	`if(`notdefined(FINAL_RELEASE))
		if( PSTemplate == None )
		{
			`warn( GetFuncName() @ "PSTemplate was" @ PSTemplate );
			ScriptTrace();
		}
		`endif


			switch (EffectType)
		{
			default:
				if( PSTemplate.bUseFixedRelativeBoundingBox == FALSE )
				{
					PSTemplate.FixedRelativeBoundingBox.IsValid = 1;
					PSTemplate.FixedRelativeBoundingBox.Min.X = -64;
					PSTemplate.FixedRelativeBoundingBox.Min.Y = -64;
					PSTemplate.FixedRelativeBoundingBox.Min.Z = -64;
					PSTemplate.FixedRelativeBoundingBox.Max.X =  64;
					PSTemplate.FixedRelativeBoundingBox.Max.Y =  64;
					PSTemplate.FixedRelativeBoundingBox.Max.Z =  64;

					PSTemplate.bUseFixedRelativeBoundingBox = TRUE;

					//`warn( "bUseFixedRelativeBoundingBox==FALSE PSTemplate was" @ PSTemplate );
				}
				break;
		}

		Emit = Spawn( class'SpawnedNanoEmitter', self );
		Emit.LifeSpan = 0;
		NanoEmitter(Emit).HideSelf();
		Emit.ParticleSystemComponent.bAutoActivate = FALSE;
		Emit.ParticleSystemComponent.OnSystemFinished = SpawnedNanoEmitter(Emit).HideBecauseFinished;
		Emit.SetTemplate( PSTemplate, FALSE );


		Emit.ParticleSystemComponent.LODMethod		    = PARTICLESYSTEMLODMETHOD_DirectSet;
		Emit.ParticleSystemComponent.bOverrideLODMethod = TRUE;

		for( Idx = 0; Idx < Emit.ParticleSystemComponent.EmitterInstances.Length; Idx++)
		{
			Emit.ParticleSystemComponent.SetKillOnDeactivate( Idx, FALSE );
			Emit.ParticleSystemComponent.SetKillOnCompleted( Idx, FALSE );
		}
}


simulated final function CreatePS_List(int EffectType, ParticleSystem PSTemplate, int NumToCreate, bool bForceCreate )
{
	local int Idx;
	local ParticleSystemComponent PSC;

	EmitterCache[EffectType].SizeOfList = NumToCreate;
	EmitterCache[EffectType].Type = EffectType;
	EmitterCache[EffectType].ParticleSystemType = PSTemplate;

	if (bForceCreate)
	{
		for( Idx = 0; Idx < NumToCreate; Idx++)
		{
			PSC = EmitterCache[EffectType].PList[Idx];
			CreatePS_Worker( EffectType, PSTemplate, PSC );
			EmitterCache[EffectType].PList[Idx] = PSC;
		}
	}
}


simulated final function CreatePS_Worker(int EffectType, ParticleSystem PSTemplate, out ParticleSystemComponent PSC )
{
	local int Idx;

	`if(`notdefined(FINAL_RELEASE))
		if( PSTemplate == None )
		{
			`warn( GetFuncName() @ "PSTemplate was" @ PSTemplate );
			ScriptTrace();
		}
		`endif


			switch (EffectType)
		{
			default:
				if( PSTemplate.bUseFixedRelativeBoundingBox == FALSE )
				{
					PSTemplate.FixedRelativeBoundingBox.IsValid = 1;
					PSTemplate.FixedRelativeBoundingBox.Min.X = -64;
					PSTemplate.FixedRelativeBoundingBox.Min.Y = -64;
					PSTemplate.FixedRelativeBoundingBox.Min.Z = -64;
					PSTemplate.FixedRelativeBoundingBox.Max.X =  64;
					PSTemplate.FixedRelativeBoundingBox.Max.Y =  64;
					PSTemplate.FixedRelativeBoundingBox.Max.Z =  64;

					PSTemplate.bUseFixedRelativeBoundingBox = TRUE;

					//`warn( "bUseFixedRelativeBoundingBox==FALSE PSTemplate was" @ PSTemplate );
				}
				break;
		}


		PSC = new(self) class'NanoParticleSystemComponent';
		PSC.bAutoActivate = FALSE;
		PSC.SetTemplate( PSTemplate );

		PSC.LODMethod				= PARTICLESYSTEMLODMETHOD_DirectSet;
		PSC.bIsCachedInPool			= TRUE;
		PSC.bOverrideLODMethod      = TRUE;
		PSC.SetTickGroup( TG_PostUpdateWork ); // this is needed to make certain ParticleSystemComponents get attached at the correct location on physicy skeletal meshes
		PSC.OnSystemFinished = PoolPSCFinished;

		for( Idx = 0; Idx < PSC.EmitterInstances.Length; Idx++ )
		{
			PSC.SetKillOnDeactivate( Idx, FALSE );
			PSC.SetKillOnCompleted( Idx, FALSE );
		}
}

simulated final function PoolPSCFinished(ParticleSystemComponent FinishedComponent)
{
	FinishedComponent.DetachFromAny();
}



/**
* This will retrieve an Emitter from our pool.
*
* NOTE: turn this into an object pool where we cache the various types of particle systems
**/
simulated final function Emitter GetImpactEmitter(ParticleSystem PS_Type, vector SpawnLocation, rotator SpawnRotation)
{
	local Emitter Result;
	local EmitterCacheDatum Datum;
	local int PoolIndex;

	if( PS_Type == ParticleSystem'COG_AssaultRifle.Effects.P_COG_AssaultRifle_Impact' )
	{
		PoolIndex = NOP_MP5_IMPACT;
	}

	else
	{
		//`log( "ParticleSystem NOT CACHED: GetImpactEmitter PS_Type: " $ PS_Type );
		PoolIndex = NOP_DEFAULT_GENERAL;
	}


	Datum = EmitterCache[PoolIndex];
	if( PoolIndex != NOP_DEFAULT_GENERAL )
	{
		Result = GetImpactEmitter_Worker( Datum, SpawnLocation, SpawnRotation, none );
	}
	else // we are using the general pool so send in the PS_Type
	{
		Result = GetImpactEmitter_Worker( Datum, SpawnLocation, SpawnRotation, PS_Type );
	}

	EmitterCache[PoolIndex] = Datum;

	//`log( "Emitter PS_Type: " $ PS_Type @ Result.ParticleSystemComponent.Template.bUseFixedRelativeBoundingBox );
	//ScriptTrace();
	return Result;
}


simulated final function Emitter GetImpactEmitter_Worker( out EmitterCacheDatum TheDatum, vector SpawnLocation, rotator SpawnRotation, ParticleSystem PS_Type )
{
	local Emitter Emit;
	local int Jdx;

	if( ++TheDatum.ListIdx >= TheDatum.SizeOfList )
	{
		TheDatum.ListIdx = 0;
	}

	Emit = TheDatum.List[TheDatum.ListIdx];

	// Spawn a new component if the one in the cache has been destroyed. This can happen if the actor the component is attached to
	// gets destroyed and henceforth is marked as pending kill.
	// @todo also prob need to check if NOT RF_Unreachable  (e.g. the outer of this PSC was somehow destroyed and is not marked RF_PendingKill yet)
	if( Emit == none || Emit.bDeleteMe )
	{
		if( PS_Type == none )
		{
			CreateEmitter_Worker( TheDatum.Type, TheDatum.ParticleSystemType, Emit );
			//`log( "newing a Emit of type CACHED: " $  TheDatum.ParticleSystemType );
		}
		else
		{
			CreateEmitter_Worker( TheDatum.Type, PS_Type, Emit );
			//`log( "newing a Emit of type GENERAL: " $  PS_Type );
		}

		TheDatum.List[TheDatum.ListIdx] = Emit;
	}

	Emit.SetTickIsDisabled(false);

	Emit.SetBase( none );

	//Emit.SetAbsolute( TRUE, TRUE, FALSE );
	//Emit.SetTranslation( SpawnLocation );
	//Emit.SetRotation( SpawnRotation );

	Emit.SetLocation( SpawnLocation );
	Emit.SetRotation( SpawnRotation );


	Emit.SetDrawScale( 1.0 ); // reset this in case caller changed it

	// we check to see if we are getting a non default impact and then if we are
	// we have to SetTemplate on it as the set of all none defaults share their
	// own cache
	if( PS_Type != none )
	{
		Emit.SetTemplate( PS_Type, FALSE ); // this will ActivateSystem if you do not explicitly set ParticleSystemComponent.bAutoActivate = FALSE;
		//`log( "GetImpactEmitter_Worker:  having to SetTemplate :-(  Previous: " $ Emit.ParticleSystemComponent.Template $ " New: " $ PS_Type $ PS_Type.bUseFixedRelativeBoundingBox );
		for( Jdx = 0; Jdx < Emit.ParticleSystemComponent.EmitterInstances.Length; ++Jdx )
		{
			Emit.ParticleSystemComponent.SetKillOnDeactivate(Jdx,FALSE);
			Emit.ParticleSystemComponent.SetKillOnCompleted(Jdx,FALSE);
		}

	}

	Emit.ClearTimer( nameof(Emit.HideSelf) );
	Emit.SetHidden(FALSE);

	//`log( "GetImpactEmitter_Worker: " $ TheDatum.ListIdx $ " PS_Type: " $ PS_Type );

	//Emit.ParticleSystemComponent.bIsCachedInPool = TRUE;

	Emit.ParticleSystemComponent.SetLODLevel( NanoGRI(WorldInfo.GRI).GetLODLevelToUse(Emit.ParticleSystemComponent.Template, SpawnLocation ));

	// global safety catch for misbehaving particles.  Usually the OnSystemFinished will do the correct thing
	Emit.SetTimer( 15.0f, FALSE, nameof(Emit.HideSelf) );

	return Emit;
}


simulated final function ParticleSystemComponent GetImpactParticleSystemComponent( ParticleSystem PS_Type )
{
	local ParticleSystemComponent Result;
	local EmitterCacheDatum Datum;
	local int PoolIndex;

	if( PS_Type == ParticleSystem'COG_AssaultRifle.Effects.P_COG_AssaultRifle_Impact' )
	{
		PoolIndex = NOP_MP5_IMPACT;
	}
	else
	{
		//`log( "ParticleSystem NOT CACHED: ParticleSystemComponent PS_Type: " $ PS_Type );
		PoolIndex = NOP_DEFAULT_GENERAL;
	}


	Datum = EmitterCache[PoolIndex];
	if( PoolIndex != NOP_DEFAULT_GENERAL )
	{
		Result = GetImpactParticleSystemComponent_Worker( Datum, none );
	}
	else // we are using the general pool so send in the PS_Type
	{
		Result = GetImpactParticleSystemComponent_Worker( Datum, PS_Type );
	}
	EmitterCache[PoolIndex] = Datum;

	//`log( "PSC PS_Type: " $ PS_Type @ Result.Template.bUseFixedRelativeBoundingBox );
	//ScriptTrace();
	return Result;
}


// need to do this as the particle components are attached to the mob
simulated final function ParticleSystemComponent GetImpactParticleSystemComponent_Worker( out EmitterCacheDatum TheDatum, ParticleSystem PS_Type )
{
	local ParticleSystemComponent PSC;
	local int Jdx;

	if( ++TheDatum.ListIdx >= TheDatum.SizeOfList  )
	{
		TheDatum.ListIdx = 0;
	}

	PSC = TheDatum.PList[TheDatum.ListIdx];

	// Spawn a new component if the one in the cache has been destroyed. This can happen if the actor the component is attached to
	// gets destroyed and henceforth is marked as pending kill.
	// @todo also prob need to check if NOT RF_Unreachable  (e.g. the outer of this PSC was somehow destroyed and is not marked RF_PendingKill yet)
	if( PSC == none || PSC.IsPendingKill() )
	{
		if( PS_Type == none )
		{
			CreatePS_Worker( TheDatum.Type, TheDatum.ParticleSystemType, PSC );
			//`log( "newing a PSC of type CACHED: " $  TheDatum.ParticleSystemType );
		}
		else
		{
			CreatePS_Worker( TheDatum.Type, PS_Type, PSC );
			//`log( "newing a PSC of type GENERAL: " $  PS_Type );
		}
		// Replace entry in cache.

		TheDatum.PList[TheDatum.ListIdx] = PSC;
		//`log( "newing a PSC of type: " $  TheDatum.ParticleSystemType  $ " PSC: " $ PSC.Template );
	}

	// Detach from existing actor if we're re-using.
	if( PSC.Owner != none )
	{
		//`log( "Detaching component from: " $ PSC.Owner $ " PSC: " $ PSC.Template );
		PSC.Owner.DetachComponent( PSC );
	}

	PSC.SetHidden( FALSE );

	if( PS_Type != none )
	{
		//`log( "GetImpactParticleSystemComponent_Worker:  having to SetTemplate :-(  Previous: " $ PSC.Template $ " New: " $ PS_Type  $ PS_Type.bUseFixedRelativeBoundingBox );
		PSC.SetTemplate( PS_Type );

		for( Jdx = 0; Jdx < PSC.EmitterInstances.Length; ++Jdx )
		{
			PSC.SetKillOnDeactivate(Jdx,FALSE);
			PSC.SetKillOnCompleted(Jdx,FALSE);
		}

	}

	//`log( TheDatum.ListIdx @ TheDatum.SizeOfList );

	//PSC.OnSystemFinished = OnParticleSystemFinished_Hider;


	return PSC;
}






simulated final function NanoDecal GetDecal_Blood( const out vector SpawnLocation )
{
	return GetDecal_Worker( DecalPool_Blood.DecalsIdx, DecalPool_Blood, DecalPool_Blood.Decals, SpawnLocation );
}

simulated final function NanoDecal GetDecal_Bullet( const out vector SpawnLocation )
{
	return GetDecal_Worker( DecalPool_Bullet.DecalsIdx, DecalPool_Bullet, DecalPool_Bullet.Decals, SpawnLocation );
}

simulated final function NanoDecal GetDecal_Explosion( const out vector SpawnLocation )
{
	return GetDecal_Worker( DecalPool_Explosion.DecalsIdx, DecalPool_Explosion, DecalPool_Explosion.Decals, SpawnLocation );
}


/**
* This is our generic Decal Cache worker.  All of our indiv functions call this so we can modify it as we want and everyone will
* get the benefit.
*
**/
private native simulated final function NanoDecal GetDecal_Worker( out int CurrIdx, const out DecalPool TheDecalPool, out array<DecalDatum> DecalList, const out vector SpawnLocation );





simulated final function CreateTracers()
{
	local int Idx;

	for( Idx = 0; Idx < MAX_TRACERS; ++Idx )
	{
		CreateTracer_Worker( WTT_LongSkinny, class'NanoProj_BulletTracer', Idx, TRUE );
		CreateTracer_Worker( WTT_ShortBullet, class'NanoProj_BulletTracer_ShortRed', Idx, TRUE );
	}
}

simulated final function CreateTracer_Worker( EWeaponTracerType TracerType, class<NanoProj_BulletTracer> TracerClass, int Idx, bool bForceCreate )
{
	local vector SpawnLocation;

	// 262144 is HALF_WORLD_MAX @see engine.h
	SpawnLocation = vect(262144,262144,262144);

	// always set the TracerClass
	TracerCache[TracerType].TracerClass = TracerClass;

	if( bForceCreate == TRUE )
	{
		TracerCache[TracerType].List[Idx] = Spawn( TracerClass, self, , SpawnLocation );
		TracerCache[TracerType].List[Idx].SetDrawScale3D( TracerClass.default.TracerDrawScale3D );
		TracerCache[TracerType].List[Idx].Recycle();
	}
}





simulated final function NanoProj_BulletTracer GetTracer( EWeaponTracerType TracerType, byte ActiveReloadTier, vector SpawnLocation, rotator SpawnRotation )
{
	return GetTracer_Worker( TracerCache[TracerType], TracerType, ActiveReloadTier, SpawnLocation, SpawnRotation );
}




simulated final protected function NanoProj_BulletTracer GetTracer_Worker( out TracerCacheDatum TheDatum, EWeaponTracerType TracerType, byte ActiveReloadTier, vector SpawnLocation, rotator SpawnRotation )
{
	local NanoProj_BulletTracer PBT;

	if( ++TheDatum.ListIdx >= MAX_TRACERS )
	{
		TheDatum.ListIdx = 0;
	}

	//`log( "GetTracer_Worker: " $ TheDatum.ListIdx $ " SpawnLocation: " $ SpawnLocation $ " " $ TheDatum.List[TheDatum.ListIdx] );

	PBT = TheDatum.List[TheDatum.ListIdx];

	// if we need to spawn one of these
	if( ( PBT == none ) || ( PBT.bDeleteMe ) )
	{
		CreateTracer_Worker( TracerType, TheDatum.TracerClass, TheDatum.ListIdx, TRUE );
		PBT = TheDatum.List[TheDatum.ListIdx];
	}

	// otherwise unhide the existing one and set to the new location
	PBT.SetLocation( SpawnLocation );
	PBT.SetRotation( SpawnRotation );
	PBT.SetPhysics( PHYS_Projectile );

	PBT.SetTickIsDisabled(false);

	return PBT;
}



defaultproperties
{

}
