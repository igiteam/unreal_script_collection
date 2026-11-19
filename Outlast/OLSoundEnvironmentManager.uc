class OLSoundEnvironmentManager extends Object
	native
	inherits(FTickableObject)
	config(Game);

var transient array<OLSoundEnvironmentVolume> ListenerVolumes;
var transient array<OLSoundEnvironmentVolume> AllVolumes;
var bool bEnvironmentsDirty; // set when streaming volumes change
var bool bPendingDestroy; // prevents registering objects due to late callbacks when destroying

struct native VirtualizationNode
{
	var transient OLSoundConnectorComponent Connector;
	var float VirtualizableDistance; // from connector to sound - does not include from connector to listener
	var float DistToListener; // from connector's edge to listener
	var int Level; // number of subnodes to get to listener (0 - connects direct to listener)
};

struct native MultiPositionGroup
{
	var init string EventName;
	var native init array<OLSoundEmitter> Members;
};

var array<OLSoundEmitter> ActiveSources;
var array<MultiPositionGroup> ActiveGroups;

var OLSoundEnvironment DefaultSoundEnvironment;

var const name FadeRTPC;

var config bool bEnableSoundVirtualization;
var config float OcclusionApproachCoeff;
var config float ObstructionApproachCoeff;
var config float ObstructionRatioInSameVolume;
var config float MaxPathingDist;
var config float FreePathingDist;
var config float LockerOcclusion;
var config string LockerReverbEnvironment;

cpptext
{
public:
	
	typedef TArray<AOLSoundEnvironmentVolume*, TInlineAllocator< 64 > > SndEnvVolumeArray;
	typedef TArray<FVirtualizationNode, TInlineAllocator< 64 > > VirtNodeArray;
		
	virtual void Tick(FLOAT deltaTime);

	virtual UBOOL IsTickable() const 
	{
		return !HasAnyFlags( RF_Unreachable | RF_AsyncLoading ); 
	}

	void UpdateSoundPosition(AActor* actor, FVector& inout_Position, FVector& inout_Direction); // updates base location, and returns effective position (i.e. virtualized if applicable)
	UBOOL TryGetMultipleSourcePositions(AActor* actor, TArray<FVector>& out_Positions, TArray<FVector>& out_Directions); // returns true if there are multiple positions, otherwise returns false
	void UpdateFadeRTPC(FLOAT deltaTime);

	UOLSoundEmitter* GetSoundEmitterForActor(AActor* actor);
	UOLSoundEmitter* RegisterSoundEmitterForAmbientSound(AOLAmbientSound* ambientSound, UBOOL bIsActive);
	UOLSoundEmitter* RegisterSoundEmitterForAmbientSoundClone(AOLAmbientSoundClone* clone, UOLSoundEmitter* masterEmitter, UBOOL bIsActive);
	UOLSoundEmitter* RegisterSoundEmitterForSoundEmittingMeshActor(AOLSoundEmittingMeshActor* emittingMesh);
	UOLSoundEmitter* RegisterSoundEmitterForPawn(APawn* pawn);
	UOLSoundEmitter* RegisterSoundEmitterForSkeletalMeshActor(ASkeletalMeshActor* actor);
	void ConditionalRegisterSoundEmitterForDoor(AOLDoor* door);
	void UnregisterSoundEmitterForActor(AActor* actor);

	void UpdateSoundEmitterForActor(AActor* actor);

	UBOOL GetPlayerOcclusionForPawn(APawn* pawn, FLOAT& out_Distance, FLOAT& out_Occlusion); // returns the (approximate) occlusion from the player to another pawn, to assess player loudness
	UBOOL GetPlayerOcclusionForActor(AActor* actor, FLOAT& out_Distance, FLOAT& out_Occlusion, FLOAT& out_Obstruction);

	void DrawDebug(const FVector& baseLocation); // 3d
	void DisplayDebug(UCanvas* canvas); // text

private:

	enum { MaxGroupMembers = 64 };

	// Utils

	UOLSoundEmitter* RegisterSoundEmitterForActor(AActor* actor, UBOOL bActive, UBOOL bDynamic, UBOOL bAllowVirtualization);	
	void InitializeSoundEmitter(UOLSoundEmitter* sndSrc);
	void AddSoundEmittingMeshToMultiPositionGroup(UOLSoundEmitter* sndSrc, const FString& EventName);
	void RemoveFromMultiPositionGroup(UOLSoundEmitter* sndSrc);
	FMultiPositionGroup* GetGroupForEmitter(UOLSoundEmitter* sndSrc);
	void FilterVolumesByPriority(SndEnvVolumeArray& sndVolumes);

	void GetEnvironmentVolumes(const UOLSoundEmitter* sndSrc, SndEnvVolumeArray& sndVolumes);

	struct SoundPathingListenerInfo
	{
		FLOAT DirectDistToListener;
		const FVector* ListenerLocation;
	};

	UBOOL GetPathedAudioParams(	FLOAT& out_occlusion, 
											const FVector& srcLocation, 
											const SndEnvVolumeArray& srcVolumes, 
											const FVector& listenerLocation, 
											VirtNodeArray& virtualizationNodes);
	
	UBOOL FindPathToListener(		UOLSoundConnectorComponent* connector, 
											FLOAT totalDistance,
											const SoundPathingListenerInfo& listenerInfo, 
											FLOAT& out_occlusion, 
											INT& out_NbSubNodesToListener,											 											
											SndEnvVolumeArray& visitedVolumes, 
											VirtNodeArray& virtualizationNodes
											);

	FLOAT GetObstructionFactor(	UOLSoundEmitter* sndSrc,
											const SndEnvVolumeArray& srcVolumes);

	void FilterVirtualizationNodes(	const VirtNodeArray& virtualizationNodes, 
												const FVirtualizationNode*& level0Node, 
												const FVirtualizationNode*& level1Node, 
												FLOAT& baseWeight0, 
												FLOAT& baseWeight1);

	FVector GetVirtualizedLocation(UOLSoundEmitter* sndSrc, const FVirtualizationNode* virtualizationNode, FLOAT baseWeight, FVector& out_Pivot);

	// Updates

	void UpdateVirtualization(UOLSoundEmitter* sndSrc, const VirtNodeArray& virtualizationNodes);
	
	void UpdateDynamicAudioParams(UOLSoundEmitter* sndSrc, FLOAT deltaTime, UBOOL bInitialUpdate = FALSE); // Updates occlusion, obstruction, virtualization
	
	void UpdateReverb(UOLSoundEmitter* sndSrc);	
	void UpdateSoundEnvironmentForDynamicActor(UOLSoundEmitter* sndSrc, FLOAT deltaTime, UBOOL initialUpdate);
	void UpdateSoundEnvironmentForStaticActor(UOLSoundEmitter* sndSrc);

	void UpdateAllVolumes();
	void UpdateListenerVolumes();
	void UpdateMultiPositionSources(FLOAT deltaTime);

	void ListenerEnteredSoundEnvironment(UOLSoundEmitter* sndSrc, FSoundEnvVolumeData& params);
	void ListenerLeftSoundEnvironment(UOLSoundEmitter* sndSrc, FSoundEnvVolumeData& params);
	
	// Debug
	
	void UpdateDebugReverb(UOLSoundEmitter* sndSrc);
}

native function Cleanup();
native function ExitAllTouchingVolumes();

native static function OLSoundEnvironmentManager GetSoundEnvManager();

defaultproperties
{
	DefaultSoundEnvironment=OLSoundEnvironment'Reverb.Default_SoundEnvironment'
	FadeRTPC=RTPC_FadeToBlack
}