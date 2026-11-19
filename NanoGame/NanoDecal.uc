/**
 * Custom decal class for Nanos to simplify the process a bit.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoDecal extends DecalComponent
	native
	dependson(NanoTypes,NanoDecalManager);

/** The vast majority of our decals have an MITV/MIC attached to them.  So we are just going to store that here.  So we don't have to keep allocating it **/
var transient MaterialInstanceTimeVarying MITV_Decal;

/** Pawn that owns us basically */
var transient Pawn Instigator;

cpptext
{
	virtual void Tick(FLOAT DeltaTime)
	{
		Super::Tick(DeltaTime);
		LifeSpan -= DeltaTime;
		if (LifeSpan <= 0.f)
		{
			DetachFromAny();
		}
		else
		{
			eventTick(DeltaTime);
		}
	}
}

/** Debug logging for decals, just uncomment the following line and all the debug logging will be enabled */
//`define DEBUG_DECALS
`if(`isdefined(DEBUG_DECALS))
    `define DecalLog(text)     `Log("["$self@GetFuncName()$"]"@`text,,'Decal');
`else
    `define DecalLog(text)
`endif


/** Should each decal randomly alter rotation? */
var transient bool bRandomizeRotation;

/** Should each decal randomly scale the width/height? */
var transient bool bRandomizeScaling;
var transient vector2d RandomScalingRange;

/** Whether or not the decals should use the fast path to attach **/
var transient bool ClipDecalsUsingFastPath;

var float LifeSpan;



/** minimum thickness for explosion decals */
var float MinExplosionThickness;
/** minimum thickness for impact decals */
var float MinImpactThickness;

/** Because perf is slow for attached decals to FracturedMeshes we are going to have a percentage change to spawn them. **/
var float PercentToSpawnOnFracturedMesh;

/**
 * Stub for any decals that have time-based functionality (blood pools, etc).
 */
simulated event Tick(float DeltaTime);

/**
 * Contains any shared initialization between all attachment methods.
 */
simulated protected function SharedAttachmentInit(Actor TargetAttachment, vector RayDir)
{
	local float RandomScale;
	`DecalLog("Target:"@TargetAttachment);
	if (bRandomizeRotation)
	{
		DecalRotation = FRand() * 360.f;
	}
	if (bRandomizeScaling)
	{
		RandomScale = GetRangeValueByPct(RandomScalingRange,FRand());
		Width *= RandomScale;
		Height *= RandomScale;
	}
}

/**
 * Simplified interface for attaching decals to surfaces (bsp/meshes).
 */
final simulated function AttachToSurface(Pawn Pawn, vector TraceLocation, vector TraceDirection, float TraceMagnitude)
{
	local Actor HitActor;
	local vector HitL, HitN;
	local TraceHitInfo HitInfo;

	if (Pawn != None)
	{
		Instigator = Pawn;
		HitActor = Pawn.Trace(HitL, HitN, TraceLocation + TraceDirection * TraceMagnitude * 2.f, TraceLocation, FALSE, vect(0,0,0), HitInfo, class'Actor'.const.TRACEFLAG_PhysicsVolumes);
		//Pawn.DrawDebugLine( TraceLocation, TraceLocation + TraceDirection * TraceMagnitude * 2.f, 255, 0, 0, TRUE);

		if (HitActor != None)
		{
			`DecalLog("Hit:"@HitActor);
			// if we've hit the world,
			if (HitActor.bStatic)
			{
				// redirect to the GRI so that we're attached to a non-static actor (and will properly receive ticks)
				HitActor = Pawn.WorldInfo.GRI;
			}
			Location = HitL;
			Orientation = rotator(-HitN);
			DecalRotation = 0;
			HitComponent = HitInfo.HitComponent;
			HitBone = HitInfo.BoneName;

			if( ClipDecalsUsingFastPath == TRUE )
			{
				HitNodeIndex = HitInfo.Item;
				HitLevelIndex = HitInfo.LevelIndex;
				bNoClip = FALSE;
			}
			else
			{
				HitNodeIndex = INDEX_NONE;
				HitLevelIndex = INDEX_NONE;
				bNoClip = TRUE;
			}

			FracturedStaticMeshComponentIndex = HitInfo.Item;

			//`log( HitActor @ "HitInfo.HitComponent" @ HitInfo.HitComponent @ "HitInfo.Item" @ HitInfo.Item @ "HitInfo.LevelIndex" @ HitInfo.LevelIndex );

			// shared init
			SharedAttachmentInit(HitActor,TraceDirection);
			// actual attachment
			HitActor.AttachComponent(self);
			MITV_Decal.SetDuration( LifeSpan );
		}
		else
		{
			`DecalLog("Failed to hit anything");
		}
	}
}

/**
 * Helpful method of statically creating decals and attaching.
 */
final static simulated function NanoDecal StaticAttachToSurface(class<NanoDecal> DecalClass, Pawn Pawn, vector TraceLocation, vector TraceDirection, float TraceMagnitude, const out ImpactInfo Impact, DecalData SourceDecalInfo)
{
	local NanoDecal Decal;

	if (Pawn != None)
	{
		Decal = NanoDecalManager(Pawn.WorldInfo.MyDecalManager).SpawnDecalMinimal(Impact.HitLocation, 60.0f, 25.0f); // hack for the size
		if( Decal != none )
		{
			if (SourceDecalInfo.bIsValid)
			{
				Decal.CopyFromSource(SourceDecalInfo, Impact);
			}

			Decal.AttachToSurface(Pawn,TraceLocation,TraceDirection,TraceMagnitude);
		}
	}
	return Decal;
}
/**
 * Simplified interface for attaching decals from a ImpactInfo struct.
 */
final simulated function AttachFromImpact(Pawn InInstigator, const out ImpactInfo Impact)
{
	local Actor HitActor;

	`DecalLog("InInstigator:"@InInstigator@", HitActor:"@Impact.HitActor);

	HitActor = (Impact.HitActor.bStatic) ? Impact.HitActor.WorldInfo.GRI : Impact.HitActor;

	// we do a percent check here to see if we should spawn on the fractured static mesh or not
	if( ( FracturedStaticMeshActor(HitActor) != None ) && ( FRand() > PercentToSpawnOnFracturedMesh ) )
	{
		return;
	}

	Instigator = InInstigator;
	Location = Impact.HitLocation;
	Orientation = rotator(-Impact.HitNormal);
	DecalRotation = 0;
	HitComponent = Impact.HitInfo.HitComponent;
	HitBone = Impact.HitInfo.BoneName;

	if( ClipDecalsUsingFastPath == TRUE )
	{
		HitNodeIndex = Impact.HitInfo.Item;
		HitLevelIndex = Impact.HitInfo.LevelIndex;
	}
	else
	{
		HitNodeIndex = INDEX_NONE;
		HitLevelIndex = INDEX_NONE;
	}

	FracturedStaticMeshComponentIndex = Impact.HitInfo.Item;

	//`log( HitActor @ "Impact.HitInfo.HitComponent" @ Impact.HitInfo.HitComponent @ "Impact.HitInfo.Item" @ Impact.HitInfo.Item @ "Impact.HitInfo.LevelIndex" @ Impact.HitInfo.LevelIndex );

	// shared init
	SharedAttachmentInit(HitActor, Impact.RayDir);
	// actual attachment
	HitActor.AttachComponent(self);
}

/**
 * Helpful method of statically creating decals and attaching via ImpactInfo.
 */
final static simulated function NanoDecal StaticAttachFromImpact(class<NanoDecal> DecalClass, Pawn InInstigator, const out ImpactInfo Impact, optional DecalData SourceDecalInfo)
{
	local NanoDecal Decal;

	if (Impact.HitActor != None && InInstigator != None )
	{
		// HACK
		Decal = NanoDecal(InInstigator.WorldInfo.MyDecalManager.SpawnDecal(
			SourceDecalInfo.DecalMaterial
			, Impact.HitLocation
			, rotator(-Impact.HitNormal)
			, 10.0f
			, 10.0f
			, 10.0f
			, TRUE 
			));

		if( Decal != none )
		{
			if (SourceDecalInfo.bIsValid)
			{
				Decal.CopyFromSource(SourceDecalInfo, Impact);
			}

			Decal.AttachFromImpact(InInstigator,Impact);
			//Decal.SetLightEnvironment( Pawn.LightEnvironment );
		}
	}


	return Decal;
}

/**
 * Copy the relevant properties from a DecalInfo source (NanoPhysicaGlobalBloodInfolMaterial).
 */
final simulated protected function CopyFromSource( const out DecalData Source, const out ImpactInfo Impact )
{
	if( MaterialInstanceTimeVarying(Source.DecalMaterial) != none )
	{
		if( MITV_Decal == none )
		{
			MITV_Decal = new(self) class'MaterialInstanceTimeVarying';
		}
		MITV_Decal.SetParent( Source.DecalMaterial );
		SetDecalMaterial(MITV_Decal);
	}
	else
	{
		SetDecalMaterial(Source.DecalMaterial);
	}

	Width = Source.Width;
	Height = Source.Height;
	FarPlane = Max(Source.Thickness,MinImpactThickness) * 0.5;
	NearPlane = -FarPlane;

	bRandomizeRotation = Source.bRandomizeRotation;
	bRandomizeScaling = TRUE;
	RandomScalingRange = Source.RandomScalingRange;
	ClipDecalsUsingFastPath = Source.ClipDecalsUsingFastPath;
}


/** This is a nice helper function which is used to return a random decal from a passed in array **/
function static DecalData GetRandomDecalMaterial( const array<DecalData> DecalDataArray )
{
	local DecalData DecalData;

	if( DecalDataArray.Length > 0 )
	{
		return DecalDataArray[ Rand( DecalDataArray.Length ) ];
	}

	return DecalData;
}



defaultproperties
{
	MaxDrawDistance=4000

	// slightly larger depth bias (2X of default) to prevent z-fighting with static level-placed decals
	DepthBias=-0.0001

	BackfaceAngle=-0.001			
	bProjectOnBackfaces=TRUE

	// this is needed a the owner of this decal is "hidden" as it is a global entity @see UDecalComponent::IsEnabled()
	bIgnoreOwnerHidden=TRUE 
	bStaticDecal=FALSE
	LifeSpan=999999.0

	BlendRange=(X=80,Y=90)

	MinExplosionThickness=40
	MinImpactThickness=10

	PercentToSpawnOnFracturedMesh=0.60f
}
