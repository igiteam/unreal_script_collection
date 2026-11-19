/**
 * This class is spawned when we want to have orbitals in the world that are going to cause people to slip and slide on them.
 * We need to have this "manager" class as the weapon can be thrown away, new orbitals spawned, co-op player could die off, etc.
 * So this guy persists for the time the orbitals last updating the "fall down areas" every time period.
 * 
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoOrbitalsRestingInWorld extends Actor
	native(Weapon);

/** These are the orbitals that this guy will be managing **/
var ParticleSystemComponent PSC_Orbitals;

/** Amount of time between update in creating the fall down areas **/
var float TimeBetweenUpdates;

/** When we last updated **/
var transient float NextUpdateTime;


var transient array<NanoVolume_OrbitalsOnGround> SlipVolumes;

/** This is the decal that is spawned when the orbitals melt into their slick version **/
var protected MaterialInterface MI_SlickDecal;


simulated event Init( ParticleSystemComponent InPSC_Orbitals )
{
	`log( "NanoOrbitalsRestingInWorld" @ InPSC_Orbitals );
	PSC_Orbitals = InPSC_Orbitals;
	CreateOrbitalFallDownAreas();
	PSC_Orbitals.KillParticlesForced();
}


simulated event Tick( float DeltaTime )
{
	local NanoVolume_OrbitalsOnGround SV;

	Super.Tick( DeltaTime );

    // if we should do the update
	if( WorldInfo.TimeSeconds > NextUpdateTime )
	{
 		NextUpdateTime = WorldInfo.TimeSeconds + TimeBetweenUpdates;

		// just delete all of the previous ones
 		// this breaks having some immunity for falling as we no longer have a volume in which we already fell in (we can prob do a distance based check)
		foreach SlipVolumes(SV)
		{
			SV.Destroy();
		}
    	SlipVolumes.Length = 0;


 		CreateOrbitalFallDownAreas(); // this should be an update instead of create
	}
}



/** This will create the areas where the orbitals currently are that will cause mobs to fall down. **/
native function CreateOrbitalFallDownAreas();


/** This will actually spawn the object which represents the "fall down" area. **/
simulated event SpawnOrbitalsOnGround( float LifeSpanOfArea, const out vector SpawnLocation, const out vector Extent )
{
	local NanoVolume_OrbitalsOnGround Vol;
    local float XScale, YScale;
	local vector NewScale3D;

	`log( "SpawnOrbitalsOnGround" @ SpawnLocation @ Extent );

	// check to make certain we have an actual valid volume
    if( ( VSize(SpawnLocation) > 0.0f ) && ( VSize(Extent) > 0.0f ) )
    {
	
		// we spawn them 15 higher than ground so we don't have hundreds of touch events from all of the orbitals
    	Vol = Spawn( class'NanoVolume_OrbitalsOnGround',,,SpawnLocation+Vect(0,0,15),,, TRUE );

    	Vol.LifeSpan = LifeSpanOfArea;

		XScale = Extent.X / 128.0f;
		YScale = Extent.Y / 128.0f;
   
		NewScale3D.X = YScale;
		NewScale3D.Y = XScale;
		NewScale3D.Z = Vol.CollisionComponent.Scale3D.Z;

  	    `log( "  " @ NewScale3D @ Vol.Location );

		Vol.CollisionComponent.SetScale3D( NewScale3D );

        SlipVolumes.AddItem( Vol );
    }
}



/** This is the Delegate for the Decal Choice Policy for LeaveADecal **/
protected simulated delegate DecalChoice_Default1( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	local DecalData DD;

	DD.Width=64.0f;
	DD.Height=64.0f;

	DD.DecalMaterial = MI_SlickDecal;

	out_DecalRotation = 0.15 * 360.0f;

	out_DecalData = DD;	
}

/** This is the Delegate for the MITV Params Policy for LeaveADecal **/
protected simulated delegate DecalTimeVaryingParams_Default( out MaterialInstance MI_Decal )
{

}


protected simulated delegate DecalTrace_StraightDown( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	//`log( "DecalTrace_StraightDown" );

	out_TraceStart = ForceStartLocation;

	out_TraceDest = out_TraceStart - (64.0f * vect(0,0,1));

	//DrawDebugLine(out_TraceStart,out_TraceDest,255,0,0,TRUE);
}


simulated event LeaveAMeltedOrbitalDecal( const out vector OrbitalLocation )
{
	NanoGRI(WorldInfo.GRI).LeaveADecalWorld( DecalTrace_StraightDown, DecalChoice_Default1, DecalTimeVaryingParams_Default, OrbitalLocation );
}




defaultproperties
{
	NextUpdateTime=9999999 // set to be huge for first run so we trigger the if
	TimeBetweenUpdates=10.0f

	MI_SlickDecal=MaterialInterface'Nano_Proto_Decals.Orbitals_Slick'
}

