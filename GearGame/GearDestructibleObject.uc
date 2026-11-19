/**
 * This should be utilized to place an object in the world and then make
 * and archetype out of it.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 **/

class GearDestructibleObject extends Actor
	placeable
	implements(Interface_NavMeshPathObstacle)
	implements(Interface_NavMeshPathObject)
	native;

/** Is this object chainsawable? */
var() protected bool bCanSpecialMeleeAttacked;

/** Chance to cause a cough when bumped */
var() protected float ChanceToCoughWhenBumped;

/** This sound is played all of the time the object is in the world.  (good for radios and such) **/
var() protected SoundCue		AmbientSoundCue;
var protected AudioComponent	AmbientSoundComponent;

/** Object version, used for updating content */
var const int	                ObjInstanceVersion;

/** Used to attach all of the components only once */
var transient bool				bComponentsSetUp;
/** True if the GDO is fully shut down */
var repnotify bool              bShutDown;

/** Used to update physics bodies only once */
var transient bool bInitRBPhysCalled;

/** TRUE if GDO is only vulnerable to damagetypes in VulnerableToDamageTypes list */
var() bool						bLimitDamageTypes;

/** TRUE if GDO will not destroy completely, but remain in last non-destroyed state */
var() bool						bAllowCompleteDestruction;

/** List of damage types that can affect this object.  Ignored if bLimitDamageTypes is false. */
var() array<class<DamageType> >	VulnerableToDamageType;

/** List of damage types that instantly destroy this object */
var() array<class<DamageType> >	InstaKillDamageType;

/** List of damage types to always ignore */
var() array<class<DamageType> >	IgnoreDamageType;

/** If bSelfDestructAll == TRUE for a damage mod, the object will be killed after this delay */
var() const float               SelfDestructAllDelay;

/**
 * Currently unused light environment.
 * Will most likely be used in the future to provide a higher quality lighting method than the default efficient precomputed lighting.
 */
var const LightEnvironmentComponent LightEnvironment;

/** Light environment shared by all actors spawned from this GDO, not actually used by the GDO itself */
var(GDOActorSpawnParams) const DynamicLightEnvironmentComponent LightEnvironmentToUseForActorSpawnParams;

/** Lighting channels used by all actors spawned from this GDO, not actually used by the GDO itself */
var(GDOActorSpawnParams) LightingChannelContainer LightingChannelsToUseForActorSpawnParams;

struct native MaterialReplaceMod
{
	var()	MaterialInterface	NewMaterial;

	/** Index in the Materials array to replace with NewMaterial when this action is activated. */
	var()	int					MaterialIndex;
};

struct native MITVMod
{
	/** The new MITV to apply */
	var()	MaterialInstanceTimeVarying	NewMITV;

	/** Index in the Materials array to apply the new MITV to. */
	var()	int					MaterialIndex;
};

struct native MaterialScalarParamMod
{
	var() MaterialInstanceConstant	MatInst;
	var() Name						ParamName;
	var() float						ScalarVal;
};

struct native MaterialTexParamMod
{
	var() MaterialInstanceConstant	MatInst;
	var() Name						ParamName;
	var() Texture					NewTexture;
};

struct native MaterialVectorParamMod
{
	var() MaterialInstanceConstant	MatInst;
	var() Name						ParamName;
	var() LinearColor				VectorVal;
};

/** Parameters to define an actor spawn. */
struct native ActorSpawnParams
{
	/** The actor factory doing the spawning */
	var() instanced ActorFactory	Factory;
	/** Positional offset for actor spawn loc.  Note this is relative to the subobject */
	var() vector					RelativeOffset;
	/** Rotational offset for actor spawn loc.  Note this is relative to the subobject  */
	var() rotator					RelativeRotation;
	/** How long before we forcibly destroy the spawned actor, in seconds.  <= 0 means don't destroy. */
	var() float						LifeTimeSeconds;
	/** Do not spawn if no local players are within this range */
	var() float                     MaxSpawnDist;

	structdefaultproperties
	{
		LifeTimeSeconds=30.0f
		MaxSpawnDist=1500.f
	}
};

struct native SplashDamageParams
{
	var() float				BaseDamage;
	var() float				DamageRadius;
	var() class<DamageType>	DamageType;
	var() float				Momentum;
};

struct native DestroyedEffectParams
{
	/** Emitters to spawn */
	var() ParticleSystem		ParticleEffect;
	/** Position offset for detroyed effect.  Note this is relative to the subobject  */
	var() vector				RelativeOffset;
	/** Rotational offset for destroyed effect.  Note this is relative to the subobject */
	var() rotator				RelativeRotation;
	/** Do not spawn if no local players are within this range */
	var() float                 MaxSpawnDist;
	/** Socket on which to attach this effect. Used in GearDynamicDestructibleObject only */
	var() Name                  SocketName;

	structdefaultproperties
	{
		MaxSpawnDist=4000.f
	}
};

/** new collision params */
//struct native CollisionMod
//{
//	var() bool bNewCollideActors;
//	var() bool bNewBlockActors;
//	var() bool bNewIgnoreEncroachers;
//};

/** describes a dependency of one subobject on a modification to another */
struct native ObjDamageModifierDependency
{
	/** which subobject we're talking about */
	var() Name			DependentSubObjName;

	/** If dependent subobject is above this health, it will be damaged to this level */
	var() float			MaxHealthToAllow;

	/** Optimization to avoid searches.  Gets filled in on PostBeginPlay() */
	var transient int	DependentSubObjIdx;

	structdefaultproperties
	{
		DependentSubObjIdx=-1
	}
};

struct native CoverModParams
{
	/** index into AttachedCover array of which coverlink to modify */
	var() int		AttachedCoverIndex;

	/** set TRUE to disable this entire coverlink (SlotIndex is ignored) */
	var() bool		bDisableCoverLink;

	/** which slot to modify in the specified coverlink */
	var() int		SlotIndex;

	/** set TRUE to disable this cover slot */
	var() bool		bDisableSlot;

	/** If not CT_None, force slot to this type */
	var() ECoverType	NewCoverType;

	/** TRUE to cause the indicated vars in the cover slot to be updated */
	var() bool		bUpdateCanMantle;
	var() bool		bUpdateCanCoverSlip_Left;
	var() bool		bUpdateCanCoverSlip_Right;
	var() bool		bUpdateCanSwatTurn_Left;
	var() bool		bUpdateCanSwatTurn_Right;
	var() bool		bUpdateAllowPopup;
	var() bool		bUpdateLeanLeft;
	var() bool		bUpdateLeanRight;

	/** New values for coverslot vars.  Ignored unless the corresponding bUpdate* var above is TRUE */
	var() bool		bNewCanMantle;
	var() bool		bNewCanCoverSlip_Left;
	var() bool		bNewCanCoverSlip_Right;
	var() bool		bNewCanSwatTurn_Left;
	var() bool		bNewCanSwatTurn_Right;
	var() bool		bNewAllowPopup;
	var() bool		bNewLeanLeft;
	var() bool		bNewLeanRight;

	structdefaultproperties
	{
		NewCoverType=CT_None
	}
};

/** Contains data for an explosion to spawn upon damage */
struct native ExplosionMod
{
	/** Socket on which to spawn this explosion (for GearDynamicDestructibleObject) */
	var() Name	                SocketName;
	/** Explosion archetype to spawn */
	var() GearExplosionContent	ExplosionTemplate;
	/** Explosion archetype to spawn if triggered by explosive damage */
	var() GearExplosionContent  ExplosionTemplateLarge;
	/** Explosion damage */
	var() float                 Damage;
	/** Explosion damage radius */
	var() float                 DamageRadius;
	/** Translation offset */
	var() vector                RelativeLocation;
	/** Rotation offset */
	var() rotator				RelativeRotation;

	structdefaultproperties
	{
		RelativeLocation=(Z=10)
	}
};

/** A modification to be applied to a subobject after a certain damage threshold is reached. */
struct native ObjectDamageModifier
{
	/** Name that can use used to descriptively identify this mod. */
	var() const Name							DamageModName;

	/** apply this Modifier at or below this health */
	var() const float							HealthThreshold;

	/** New static mesh to swap to, or None */
	var() StaticMesh							NewMesh;

	/** Transient component that is used to represent this damage modifier during lighting builds. */
	var const transient private StaticMeshComponent LightingBuildComponent;

	/** Material changes */
	var() const array<MaterialReplaceMod>		MaterialReplacements;
	var() const array<MaterialScalarParamMod>	MaterialScalarParams;
	var() const array<MaterialTexParamMod>		MaterialTexParams;
	var() const array<MaterialVectorParamMod>	MaterialVectorParams;

	/** Sounds to play when applying this modifier */
	var() const array<SoundCue>					Sounds;

	/** TRUE to kill the subobject at this stage */
	var() const bool							bSelfDestruct;

	/** TRUE to stop any attached ambient sound */
	var() const bool							bStopAmbientSound;

	// maybe use this?  ParticleSystem'Effects_Level_SP_5.SP_Hospital.Effects.P_Wooden_Barrier_Split'
	var() array<DestroyedEffectParams>	DestroyedEffects;

	/** Set TRUE to forcibly disable attached cover (normal behavior is to reevaluate it */
	var() const bool							bForceDisableAttachedCover;

	/** actors that will be spawned */
	var() const array<ActorSpawnParams>			ActorsToSpawn;

	/** Potential splash damage (if the subj explodes or something) */
	var() const SplashDamageParams				SplashDamage;

	/** list of subobjects that are also affected by this modifier */
	var() const array<ObjDamageModifierDependency>	DependentSubObjs;

	/** modifications to make to attached cover */
	var() array<CoverModParams>					CoverMods;

	/** true when this stage has been applied */
	var transient bool							bApplied;

	/** index of the next actor to be spawned from ActorsToSpawn array */
	var transient int                           NextSpawnActorIdx;

	/** disables ALL cover associated with this object when this modifier is applied */
	var() const bool                            bDisableAllCover;

	/** changes ALL enabled cover associated with this object to MID when this modifier is applied */
	var() const bool                            bLowerAllCover;

	/** Explosion archetype to spawn */
	var() ExplosionMod                          ExploMod;

	/** TRUE to kill the object (all subobjects) at this stage */
	var() const bool							bSelfDestructAll;
};

struct native DestructibleSubobject
{
	/** name of the subobject.  should be unique, but not currently enforced */
	var() Name								SubObjName;

	/** the mesh */
	var() StaticMeshComponent				Mesh;

	/** mods that can be applied to this subobject */
	var() array<ObjectDamageModifier>		DamageMods;

	/** hit points this subobject has by default */
	var() float								DefaultHealth;

	/**
	* This is a modifier that is autogenerated at initialization time which represents how to
	* get back to our original state
	* Used in MP to "heal" WDOs between rounds.
	*/
	var transient ObjectDamageModifier		UndoMod;

	/** Index of damage mod that is currently spawning effects / actors */
	var transient int	                    ActiveDamageModIdx;

	/** Most recent damage type this subobject was hit with */
	var transient class<DamageType>         LastHitDamageType;

	structdefaultproperties
	{
		DefaultHealth=50
		ActiveDamageModIdx=-1
	}
};

/** Array of objects that, as a collection, comprise this destructible object */
var() array<DestructibleSubobject>		SubObjects;

/** Static lighting info that should be applied with a damage modifier. */
struct native ObjectDamageModifierStaticLightingInfo
{
	var private const array<ShadowMap2D> ShadowMaps;
	var private const array<ShadowMap1D> ShadowVertexBuffers;
	var native private const LightMapRef LightMap;
	var private const array<guid> IrrelevantLights;

	structcpptext
	{
		friend FArchive& operator<<( FArchive& Ar, FObjectDamageModifierStaticLightingInfo& T );
	}
};

struct native SubObjectStaticLightingInfo
{
	/** Static lighting information for each damage modifier. */
	var const private array<ObjectDamageModifierStaticLightingInfo> StaticLightingInfos;

	/** Static lighting information for the original undamaged state of a DestructibleSubobject, applied in UnDestroy. */
	var const private ObjectDamageModifierStaticLightingInfo UndamagedStaticLightingInfo;
};

/**
 * Static lighting data for each SubObject.
 * This has to be in a separate array from SubObjects since it contains a native type with an overridden assignment operator (FLightmapRef),
 * And script does not respect assignment operators when passing by reference.
 */
var const private array<SubObjectStaticLightingInfo> SubObjectLightingInfos;

/**
 * Remaining hit point values for subobjects.
 * Parallel array to Subobjects.  Stored separately so it can be replicated.
 */
var array<float>					SubObjectHealths;

/** Stores how much damage each subobject has taken this frame.  Used to handle the case where a single damage call can damage multiple objects. */
var private transient array<float>	TempDamageCache;


/** The particle effect to play when chainsawing this GDO **/
var() ParticleSystem	PS_ChainsawAttack;

/** Sound to play for chainsaw ripping through the object. */
var() SoundCue			ChainSawRipSound;

/** Refs to cover that is provided by this object.  These coverlinks will be reevaluated when damage is applied. */
var() noimport array<CoverLink>	AttachedCover;

/** used to notify the client when the object should be repaired (because the game was reset) */
var repnotify byte ResetCount;

struct native ReplicatedDamageModInfo
{
	var byte ObjIdx;
	var byte ModIdx;
	var bool bPartial;

	structdefaultproperties
	{
		ObjIdx=255
		ModIdx=255
	}
};
var repnotify ReplicatedDamageModInfo ReplicatedDamageMods[32];

/**
 * Client list of processed damage mods, would just stick a variable in ReplicatedDamageMod, but
 * that will just get wiped by the server next time the array is updated.
 */
var byte ProcessedMods[32];

/** list of attached grenades to blow up when we are destroyed */
var array<GearProj_Grenade> AttachedGrenades;

/** Cached squared distance of nearest local player */
var transient float ClosestLocalPlayerSqDist;

cpptext
{
private:
	/** Attaches all of the subojects' components */
	void AttachSubobjectComponents(void);
	void SetupHealthVars();
	void GenerateUndo();
	void GenerateSubObjUndo(FDestructibleSubobject* SubObj);
	void ApplyDamageModInternal(INT SubObjIdx, FObjectDamageModifier* Mod, UBOOL bPartial, class AController* DamageInstigator);
	void SetSubObjectStaticMeshInternal(INT SubObjIdx, const FObjectDamageModifier& Modifier);
	void UpdateDamageMods();
public:
	virtual void PreSave();
	virtual void PostLoad();
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void PostEditChangeChainProperty(FPropertyChangedChainEvent& PropertyChangedEvent);
	virtual void AddReferencedObjects(TArray<UObject*>& ObjectArray);
	virtual void Serialize( FArchive& Ar );
	virtual void BeginDestroy();

	/**
	 * Used by various commandlets to purge editor only and platform-specific data from various objects
	 * 
	 * @param PlatformsToKeep Platforms for which to keep platform-specific data
	 * @param bStripLargeEditorData If TRUE, data used in the editor, but large enough to bloat download sizes, will be removed
	 */
	virtual void StripData(UE3::EPlatformType PlatformsToKeep, UBOOL bStripLargeEditorData);

	virtual void InvalidateLightingCache();
	virtual UBOOL GetActorStaticLightingInfo(TArray<FStaticLightingPrimitiveInfo>& PrimitiveInfos, const TArray<ULightComponent*>& InRelevantLights,const FLightingBuildOptions& Options);
	virtual void FinalizeStaticLighting();

    /* Overridden to setup collision for damage meshes that will eventually exist*/
	virtual void InitRBPhys();

	virtual UBOOL ShouldTrace(UPrimitiveComponent* Primitive,AActor *SourceActor, DWORD TraceFlags);
	virtual UBOOL ReachedBy(APawn* P, const FVector& TestPosition, const FVector& Dest);

	virtual void TickSpecial(FLOAT DeltaSeconds);

	/**
	* Used by the cooker to pre cache the convex data for static meshes within a given actor.
	* Overloaded to account for the damage meshes that replace the original static mesh
	* This data is stored with the level.
	* @param Level - The level the cache is in
	* @param TriByteCount - running total of memory usage for per-tri collision cache
	* @param TriMeshCount - running count of per-tri collision cache
	* @param HullByteCount - running total of memory usage for hull cache
	* @param HullCount - running count of hull cache
	*/
	virtual void BuildPhysStaticMeshCache(ULevel* Level,
										  INT& TriByteCount, INT& TriMeshCount, INT& HullByteCount, INT& HullCount);

	/**
	* Function that gets called from within Map_Check to allow this actor to check itself
	* for any potential errors and register them with map check dialog.
	*/
#if WITH_EDITOR
	virtual void CheckForErrors();
#endif

	//////////////////////////////////////////////////////////////////////////
	// Interface_NavMeshPathObject
	/**
	 * passthru function from edge to determine if the passed searcher supports this pathobject's movement
	 * @param Interface - the interface of the searcher
	 * @param CurPoly   - the poly being checked for support
	 * @param Edge      - the edge linked to this path object which is being considered
	 * @return TRUE if this path object supports the searcher
	 */
	virtual UBOOL Supports( const FNavMeshPathParams& PathParams,
							FNavMeshPolyBase* CurPoly,
							FNavMeshPathObjectEdge* Edge );
	// END Interface_NavMeshPathObject
	//////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////
	// Interface_NavMeshPathObstacle
	/**
	 * this function should populate out_polyshape with a list of verts which describe this object's
	 * convex bounding shape
	 * @param out_PolyShape - output array which holds the vertex buffer for this obstacle's bounding polyshape
	 * @return TRUE if this object should block things right now (FALSE means this obstacle shouldn't affect the mesh)
	 */
	virtual UBOOL GetBoundingShape(TArray<FVector>& out_PolyShape);

	/**
	 * when TRUE polys internal to this obstacle will be preserved, but still split. (useful for things like cost volumes that
	 * need to adjust cost but not completely destroy parts of the mesh
	 * @return TRUE if polys should be preserved internal to this obstacle
	 */
	virtual UBOOL PreserveInternalPolys() { return TRUE; }

	/**
	 * This function is called when an edge is going to be added connecting a polygon internal to this obstacle to another polygon which is not
	 * Default behavior just a normal edge, override to add special costs or behavior (e.g. link a pathobject to the obstacle)
	 * @param Status - current status of edges (e.g. what still needs adding)	 
	 * @param inV1 - vertex location of first vert in the edge
	 * @param inV2 - vertex location of second vert in the edge
	 * @param ConnectedPolys - the polys this edge links
	 * @param bEdgesNeedToBeDynamic - whether or not added edges need to be dynamic (e.g. we're adding edges between meshes)
	 * @param PolyAssocatedWithThisPO - the index into the connected polys array parmaeter which tells us which poly from that array is associated with this path object
	 * @(optional) param SupportedEdgeWidth - width of unit that this edge supports, defaults to -1.0f meaning the length of the edge itself will be used
	 * @(optional) param EdgeGroupID - ID of the edgegroup this edge is a part of (defaults to no group)
	 * @return returns an enum describing what just happened (what actions did we take) - used to determien what accompanying actions need to be taken 
	 *         by other obstacles and calling code
	 */
	virtual EEdgeHandlingStatus AddObstacleEdge( EEdgeHandlingStatus Status, const FVector& inV1, const FVector& inV2, TArray<FNavMeshPolyBase*>& ConnectedPolys, UBOOL bEdgesNeedToBeDynamic, INT PolyAssocatedWithThisPO, FLOAT SupportedEdgeWidth=-1.0f, BYTE EdgeGroupID=MAXBYTE);

	/**
	 * For debugging.  Verifies that this pathobject is still alive and well and not orphaned or deleted
	 * @return - TRUE If this path object is in good working order
	 */
	virtual UBOOL Verify()
	{
		return !IsPendingKill();
	}
	/**
	 * For debugging.  Verifies that this pathobject is still alive and well and not orphaned or deleted
	 * @return - TRUE If this path object is in good working order
	 */
	virtual UBOOL VerifyObstacle()
	{
		return Verify();
	}
	// END Interface_NavMeshPathObstacle
	//////////////////////////////////////////////////////////////////////////

	void SetCollisionForPathBuilding(UBOOL bNowPathBuilding);
};

replication
{
	if (Role == ROLE_Authority)
		ReplicatedDamageMods, ResetCount, bShutDown;
}

/** Returns TRUE if Destructible is still alive and not fully destroyed yet */
simulated native function bool IsAlive();

/**
 * Restores a WDO to it's pristine unmolested state.  Used between matches in TDM.
 */
simulated native function UnDestroy();

/** attach all subojects, generally get things ready for play */
simulated private native function SetupComponents();


/** Change the static mesh for this WDO to one stored in a DamageMod 
 *  
 * @param ObjIdx	index of subobject getting the mod
 * @param ModIdx	index into mod array indicating which mod to apply
 */
simulated native protected function SetSubObjectStaticMesh(int ObjIdx, int ModIdx);

/**
 * Apply one of the stored damage mods to this object.
 *
 * @param ObjIdx	index of subobject getting the mod
 * @param ModIdx	index into mod array indicating which mod to apply
 * @param bPartial	TRUE for partial application, used if more than one mod triggers
 *					in a frame.  Only 1 mod will be fully applied (to prevent overlapping
 *					sounds and whatnot.
 */
simulated native protected function ApplyDamageMod(int ObjIdx, int ModIdx, bool bPartial, optional Controller DamageInstigator);

/**
 * This function will remove all of the currently attached decals from the object.
 * Basically, we want to have decals attach to these objects and then on state change (due to damage usually), we will
 * just detach them all with the big particle effect that occurs it should not be noticeable.
 **/
simulated native protected function RemoveDecals();

/** one-time initializations.  basically intended to provide some native PostBeginPlay code. */
simulated native protected function OneTimeInit();

/** Let the nav mesh know that this object should be considered for pathing */
native function RegisterWithNavMesh(bool bRegister);

/**
 * This starts our ambient sound
 */
simulated event PostBeginPlay()
{
	OneTimeInit();

	RegisterWithNavMesh(TRUE);

	TempDamageCache.Length = SubObjectHealths.Length;

	if( AmbientSoundComponent != none )
	{
		AmbientSoundComponent.SoundCue = AmbientSoundCue;
		AmbientSoundComponent.Play();
	}

	// add to GRI
	if( GearGRI(WorldInfo.GRI) != None )
	{
		GearGRI(WorldInfo.GRI).Destructibles.AddItem(self);
	}
}

simulated event Destroyed()
{
	RegisterWithNavMesh(FALSE);

	// Remove from GRI
	if( GearGRI(WorldInfo.GRI) != None )
	{
		GearGRI(WorldInfo.GRI).Destructibles.RemoveItem(self);
	}

	Super.Destroyed();
}

simulated event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
	local GearPawn BumpedPawn;

	Super.Bump(Other, OtherComp, HitNormal);

	BumpedPawn = GearPawn(Other);
	if (BumpedPawn != None && BumpedPawn.BumpGDODamageType != None)
	{
		// Call TakeDamage with 0 because we only want to take bump damage if it is in the array of InstaKillDamageTypes
		TakeDamage(0, BumpedPawn.Controller, BumpedPawn.Location, vect(0,0,0), BumpedPawn.BumpGDODamageType,,BumpedPawn);

		if (FRand() < ChanceToCoughWhenBumped)
		{
			BumpedPawn.SoundGroup.PlayEffort(BumpedPawn, GearEffort_InSmokeCough);

			if (Role == ROLE_Authority)
			{
				BumpedPawn.ServerDoSpecialMove(SM_FaceShield);
			}
		}
	}
}

/** Apply damage to a subobject */
protected native function DamageSubObject(int ObjIdx, int Damage, Controller EventInstigator, class<DamageType> DamType);

/** "Turn off" this entire object */
simulated function ShutDownObject()
{
	local int Idx;
	local DestructibleSubobject CurrentSubobject;

	RegisterWithNavMesh(FALSE);
	bShutDown = true;

	// shut down all subobjects
	for (Idx=0; Idx<SubObjects.Length; ++Idx)
	{
		// compiler won't let us pass individual elements of a dynamic array as the value for an out parm, so use a local
		CurrentSubobject = SubObjects[Idx];
		ShutDownSubObject(CurrentSubobject);
		SubObjects[Idx] = CurrentSubobject;
	}

	// disable all attached cover
	for (Idx=0; Idx<AttachedCover.Length; ++Idx)
	{
		if (AttachedCover[Idx] != None)
		{
			AttachedCover[Idx].SetDisabled(TRUE);
		}
	}
}

/** "Turn off" this entire object after a delay */
simulated protected event DelayedShutDownObject()
{
	SetTimer(SelfDestructAllDelay, false, 'ShutDownObject');
}

/** "Turn off" a subobject, no mesh, no collision, nothing left */
simulated protected event ShutDownSubObject(const out DestructibleSubobject SubObj)
{
	SubObj.Mesh.SetHidden(TRUE);
	SubObj.Mesh.SetTraceBlocking(FALSE, FALSE);
	SubObj.Mesh.SetActorCollision(FALSE, FALSE);
	SubObj.Mesh.SetBlockRigidBody(FALSE);
}

simulated protected event UnShutDownObject()
{
	local int SubObjIdx, DamageModIdx;

	RegisterWithNavMesh(FALSE);
	RegisterWithNavMesh(TRUE);
	bShutDown = false;

	// Reset collision
	SetCollision(default.bCollideActors, default.bBlockActors, bIgnoreEncroachers);

	// @fixme: better to store original vals here instead of assuming
	// true across the board, in case that assumption is inaccurate
	for (SubObjIdx = 0; SubObjIdx < SubObjects.Length; ++SubObjIdx)
	{
		SubObjects[SubObjIdx].Mesh.SetHidden(FALSE);
		SubObjects[SubObjIdx].Mesh.SetTraceBlocking(TRUE, TRUE);
		SubObjects[SubObjIdx].Mesh.SetActorCollision(TRUE, TRUE);
		SubObjects[SubObjIdx].Mesh.SetBlockRigidBody(TRUE);

		// Reset vars for tracking damage mods
		SubObjects[SubObjIdx].ActiveDamageModIdx = -1;
		for (DamageModIdx = 0; DamageModIdx < SubObjects[SubObjIdx].DamageMods.length; ++DamageModIdx)
		{
			SubObjects[SubObjIdx].DamageMods[DamageModIdx].NextSpawnActorIdx = 0;
		}
	}

	// If a pawn is inside of this GDO now, teleport it
	if( Role == ROLE_Authority )
	{
		SetTimer(0.01, false, 'MoveCollidingPawns');
	}
}

/** Moves pawns that are standing on destroyed GDO when the GDO is reset between rounds */
function MoveCollidingPawns()
{
	local int SubObjIdx;
	local GearPawn GP;
	local array<Vector> ValidPositionOnMesh;

	for (SubObjIdx = 0; SubObjIdx < SubObjects.Length; ++SubObjIdx)
	{
		foreach CollidingActors(class'GearPawn', GP, SubObjects[SubObjIdx].Mesh.Bounds.SphereRadius, SubObjects[SubObjIdx].Mesh.Bounds.Origin)
		{
			if (GP.Controller != None && GP.Controller.NavigationHandle != None)
			{
				GP.Controller.NavigationHandle.GetValidPositionsForBox(GP.Location, 256.0f + SubObjects[SubObjIdx].Mesh.Bounds.SphereRadius, GP.GetCollisionExtent(), FALSE, ValidPositionOnMesh, 1);
				if (ValidPositionOnMesh.length > 0)
				{
					GP.SetLocation(ValidPositionOnMesh[0]);
				}
			}
		}
	}
}

simulated function TakeRadiusDamage
(
	Controller			InstigatedBy,
	float				BaseDamage,
	float				DamageRadius,
	class<DamageType>	DamageType,
	float				Momentum,
	vector				HurtOrigin,
	bool				bFullDamage,
	Actor				DamageCauser,
	optional float      DamageFalloffExponent=1.f
)
{
	local float		DamageScale, Dist, DamageToApply;
	local int		Idx, LinkIdx;
	local bool bInstakill;

	// clear damage cache so we can use it
	for (Idx=0; Idx<TempDamageCache.Length; ++Idx)
	{
		TempDamageCache[Idx] = 0.f;
	}

	for (Idx = 0; Idx < InstaKillDamageType.length; ++Idx)
	{
		if ( (DamageType == InstaKillDamageType[Idx]) || ClassIsChildOf(DamageType, InstaKillDamageType[Idx]) )
		{
			bInstakill = true;
			BaseDamage = 100000;
			break;
		}
	}

	// Check if this damage should be ignored completely
	for (Idx = 0; Idx < IgnoreDamageType.length; ++Idx)
	{
		if ( (DamageType == IgnoreDamageType[Idx]) || ClassIsChildOf(DamageType, IgnoreDamageType[Idx]) )
		{
			BaseDamage = 0;
			break;
		}
	}

	// calc damage for each subobject individually
	for (Idx = 0; Idx < SubObjects.Length; ++Idx)
	{
		if ( bFullDamage || bInstakill )
		{
			DamageScale = 1.f;
		}
		else
		{
			Dist = FClamp(VSize(SubObjects[Idx].Mesh.GetPosition() - HurtOrigin) - SubObjects[Idx].Mesh.Bounds.SphereRadius, 0.f, DamageRadius);
			DamageScale = 1.f - Dist/DamageRadius;
			DamageScale = DamageScale ** DamageFalloffExponent;
		}
		if (DamageScale > 0.f)
		{
			DamageToApply = (DamageScale * BaseDamage) - TempDamageCache[Idx];
			if (DamageToApply > 0.f)
			{
				DamageSubObject(Idx, DamageToApply, InstigatedBy, DamageType);
			}
		}
	}

	// If object is dead, unregister with navmesh
	if (!IsAlive())
	{
		RegisterWithNavMesh(FALSE);

		// Disable all CoverLinks
		for (LinkIdx = 0; LinkIdx < AttachedCover.length; ++LinkIdx)
		{
			if( !AttachedCover[LinkIdx].bDisabled )
			{
				AttachedCover[LinkIdx].SetDisabled(true);
			}
		}
	}

	// note TakeDamage doesn't get called -- will this be troublesome? (missing damage seqevents, etc)
}


event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int Idx, HitIdx, LinkIdx, DamageToApply;
	local bool bInstakill;

	// Check if this damage should instakill
	for ( Idx = 0; Idx < InstaKillDamageType.length; ++Idx )
	{
		if ( (DamageType == InstaKillDamageType[Idx]) || ClassIsChildOf(DamageType, InstaKillDamageType[Idx]) )
		{
			bInstakill = true;
			Damage = 100000;
			break;
		}
	}

	// Check if this damage should be ignored completely
	for (Idx = 0; Idx < IgnoreDamageType.length; ++Idx)
	{
		if ( (DamageType == IgnoreDamageType[Idx]) || ClassIsChildOf(DamageType, IgnoreDamageType[Idx]) )
		{
			Damage = 0;
			break;
		}
	}

	// Bail if there is no damage
	if( Damage <= 0 )
	{
		return;
	}

	// Search and find which subobject got hit
	// If this damage type should instakill, don't bother finding a HitIdx
	HitIdx = -1;
	if ( !bInstakill && HitInfo.HitComponent != None )
	{
		for (Idx=0; Idx<SubObjects.Length; ++Idx)
		{
			if (SubObjects[Idx].Mesh == HitInfo.HitComponent)
			{
				HitIdx = Idx;
				//`log("Got Subobject!");
				break;
			}
		}
	}

	if (HitIdx >= 0)
	{
		if (SubObjectHealths[HitIdx] > 0.f)
		{
			// hit a subobject, damage it
			DamageSubObject(HitIdx, Damage, EventInstigator, DamageType);
		}
	}
	else
	{
		// clear damage cache so we can use it
		for (Idx=0; Idx<TempDamageCache.Length; ++Idx)
		{
			TempDamageCache[Idx] = 0.f;
		}

		// no specific hit subobject, so hit them all equally
		for (Idx=0; Idx<SubObjects.Length; ++Idx)
		{
			DamageToApply = Damage - TempDamageCache[Idx];
			if (DamageToApply > 0.f)
			{
				DamageSubObject(Idx, DamageToApply, EventInstigator, DamageType);
			}
		}
	}

	// If object is dead, unregister with navmesh
	if (!IsAlive())
	{
		RegisterWithNavMesh(FALSE);

		// Disable all CoverLinks
		for (LinkIdx = 0; LinkIdx < AttachedCover.length; ++LinkIdx)
		{
			if( !AttachedCover[LinkIdx].bDisabled )
			{
				AttachedCover[LinkIdx].SetDisabled(true);
			}
		}
	}

	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

/** Fire the Destroyed kismet event, called when all subobjects are dead */
private event TriggerDestroyedEvent(Controller EventInstigator)
{
	TriggerEventClass(class'SeqEvent_Destroyed', EventInstigator);
}

simulated event ReplicatedEvent(name VarName)
{
	local int Idx;

	if (VarName == nameof(ReplicatedDamageMods))
	{
		// look for unprocessed replicated damage mods
		for (Idx = 0; Idx < ArrayCount(ProcessedMods) && Idx < ArrayCount(ReplicatedDamageMods); Idx++)
		{
			if (ProcessedMods[Idx] == 0 && ReplicatedDamageMods[Idx].ObjIdx != 255)
			{
				ProcessedMods[Idx] = 1;
				ApplyDamageMod(ReplicatedDamageMods[Idx].ObjIdx, ReplicatedDamageMods[Idx].ModIdx, ReplicatedDamageMods[Idx].bPartial);
			}
		}
	}
	else if (VarName == nameof(ResetCount) && ResetCount > 0)
	{
		UnDestroy();
	}
	else if (VarName == nameof(bShutDown))
	{
		if (bShutDown)
		{
			ShutDownObject();
		}
		else
		{
			UnShutDownObject();
		}
	}
}

/**
 * Fills in an empty slot in the replicated damage mod array to be
 * sent to the clients for simulation.
 */
event ReplicateDamageMod(int ObjIdx, int ModIdx, bool bPartial)
{
	local int Idx;
	local ReplicatedDamageModInfo NewMod;

	if ( (ObjIdx < 0) || (ObjIdx > 255)
		|| (ModIdx < 0) || (ModIdx > 255) )
	{
		`warn(self$" replicatedamagemod out of bounds "$ObjIdx@ModIdx);
		return;
	}

	// assign a full struct to workaround the bNetDirty issue with struct arrays
	NewMod.ObjIdx = ObjIdx;
	NewMod.ModIdx = ModIdx;
	NewMod.bPartial = bPartial;
	// find first available
	for (Idx = 0; Idx < ArrayCount(ReplicatedDamageMods); Idx++)
	{
		if (ReplicatedDamageMods[Idx].ObjIdx == 255)
		{
			ReplicatedDamageMods[Idx] = NewMod;
			break;
		}
	}
	// immediate net update
	bForceNetUpdate = TRUE;
}

event ApplySplashDamage(const out vector Origin, const out SplashDamageParams DamageParams)
{
	if (Role == ROLE_Authority)
	{
		HurtRadius(DamageParams.BaseDamage, DamageParams.DamageRadius, DamageParams.DamageType, DamageParams.Momentum, Origin, self);
	}
}

/** Causes any associated DamageModApplied kismet events to be fired */
event bool TriggerDamageModAppliedEvent(const out DestructibleSubobject SubObj, const out ObjectDamageModifier Mod, Controller DamageInstigator)
{
	local int Idx, ActivateCnt;
	local SeqEvt_WDODamageModApplied Evt;

	for (Idx = 0; Idx < GeneratedEvents.Length; Idx++)
	{
		Evt = SeqEvt_WDODamageModApplied(GeneratedEvents[Idx]);

		if (Evt != None)
		{
			if ( (Evt.SubObjectName == SubObj.SubObjName) && (Evt.DamageModName == Mod.DamageModName) )
			{
				if (GeneratedEvents[Idx].CheckActivate(self, DamageInstigator))
				{
					ActivateCnt++;
				}
			}
		}
	}

	return (ActivateCnt > 0);
}

/** Spawns the explosion associated with the passed in damage mod */
simulated event Explosion(const out DestructibleSubobject SubObj, const out ObjectDamageModifier Mod)
{
	local vector EffectLoc;
	local quat EffectRot;
	local GearExplosion ExplosionTemplate;
	local GearExplosionActor ExplosionActor;

	// Spawn explosion if necessary
	if( Mod.ExploMod.ExplosionTemplate != None )
	{
		ExplosionTemplate = new class'GearExplosion';
		if( Mod.ExploMod.ExplosionTemplateLarge != None &&
			ClassIsChildOf(SubObj.LastHitDamageType, class'GDT_Explosive') )
		{
			ExplosionTemplate.ContentTemplate = Mod.ExploMod.ExplosionTemplateLarge;
		}
		else
		{
			ExplosionTemplate.ContentTemplate = Mod.ExploMod.ExplosionTemplate;
		}
		ExplosionTemplate.InitFromContentTemplate();
		ExplosionTemplate.Damage = Mod.ExploMod.Damage;
		ExplosionTemplate.DamageRadius = Mod.ExploMod.DamageRadius;
		ExplosionTemplate.DamageFalloffExponent = 1.0f;

		EffectLoc = Location + (Mod.ExploMod.RelativeLocation >> Rotation);
		EffectRot = QuatProduct(QuatFromRotator(Rotation), QuatFromRotator(Mod.ExploMod.RelativeRotation));

		ExplosionTemplate.ActorToIgnoreForDamage = self;
		ExplosionTemplate.DamageDelay = 0.01f;
		ExplosionActor = Spawn(class'GearExplosionActor', self,, EffectLoc, QuatToRotator(EffectRot));
		ExplosionActor.Explode(ExplosionTemplate);
	}
}

/** set ResetCount to zero so it doesn't get applied for JIP clients, which is a problem since they
 * will also get post-reset replicated properties simultaneously and have no reasonable way to resolve it
 */
final function ClearResetCount()
{
	ResetCount = 0;
}

function Reset()
{
	RemoveDecals();
	UnDestroy();
	ResetCount++;
	bForceNetUpdate = TRUE;
	// chance to replicate
	SetTimer(1.0, false, nameof(ClearResetCount));
}

simulated function bool CanBeSpecialMeleeAttacked( GearPawn Attacker )
{
	local int Idx;

	if (bCanSpecialMeleeAttacked)
	{
		for (Idx = 0; Idx < SubObjectHealths.Length; Idx++)
		{
			if (SubObjectHealths[Idx] > 0)
			{
				return TRUE;
			}
		}
	}

	return FALSE;
}

function bool ShouldSaveForCheckpoint()
{
	return false;
}

defaultproperties
{
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Actor'
		HiddenGame=True
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
	End Object
	Components.Add(Sprite)

	Begin Object Class=AudioComponent Name=AmbientSoundComponent0
	    bAutoPlay=TRUE
	    bStopWhenOwnerDestroyed=TRUE
	End Object
	AmbientSoundComponent=AmbientSoundComponent0
	Components.Add(AmbientSoundComponent0)

	// no physics by default
	Physics=PHYS_None
	bMovable=FALSE

	// many of these properties are pulled in from KActor
	// since this class was originally derived from KActor
	RemoteRole=ROLE_SimulatedProxy
	bNoDelete=TRUE
	bWorldGeometry=false

	bNetInitialRotation=true
	bStatic=false
	bCollideWorld=false
	bProjTarget=true
	bBlockActors=true

	bAlwaysRelevant=true
	bSkipActorPropertyReplication=false
	bUpdateSimulatedPosition=true
	bReplicateMovement=true
	NetUpdateFrequency=1

	bCollideActors=true
	bNoEncroachCheck=true
	bBlocksTeleport=true
	bBlocksNavigation=true

	bEdShouldSnap=true
	bGameRelevant=true
	bPathColliding=false

	bConsiderAllStaticMeshComponentsForStreaming=true

	bAllowCompleteDestruction=true
	SelfDestructAllDelay=0.2f

	IgnoreDamageType.Add(class'GDT_InkGrenade')
	IgnoreDamageType.Add(class'GDT_FireExtinguisherSpray')

	SupportedEvents.Add(class'SeqEvt_WDODamageModApplied')

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=false // will be enabled in SetSubObjectStaticMesh, precomputed lighting is used until the static mesh is changed
		bCastShadows=false // there will be a static shadow so no need to cast a dynamic shadow
		// Use cheap shadowing from the environment
		bUseBooleanEnvironmentShadowing=true
		bSynthesizeSHLight=false
		bDynamic=false // using a static light environment to save update time
		bForceNonCompositeDynamicLights=TRUE // needed since we are using a static light environment
		TickGroup=TG_DuringAsyncWork
	End Object
	LightEnvironment=MyLightEnvironment


	LightingChannelsToUseForActorSpawnParams=(bInitialized=TRUE,Static=TRUE,Unnamed_1=TRUE)
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment2
		bEnabled=FALSE // will be enabled when the first actor is spawned in ApplyDamageModInternal
		bCastShadows=FALSE
		// Use cheap shadowing from the environment
		bUseBooleanEnvironmentShadowing=true
		bDynamic=FALSE
		bForceNonCompositeDynamicLights=TRUE // needed since we are using a static light environment, otherwise dynamic lights won't have any affect
		TickGroup=TG_DuringAsyncWork
	End Object
	LightEnvironmentToUseForActorSpawnParams=MyLightEnvironment2
	Components.Add(MyLightEnvironment2)

	bCanSpecialMeleeAttacked=TRUE

	PS_ChainsawAttack=ParticleSystem'Effects_Gameplay.Chainsaw.P_Chainsaw_GDO' // waiting on effects to give us a good effect

	bCanBeDamaged=TRUE
}


