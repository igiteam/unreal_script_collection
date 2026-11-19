class SPActorFactoryAI extends ActorFactoryAI
    native
    config(Editor)
    editinlinenew
    collapsecategories;

enum ESpPointSelection
{
    PointSelection_Normal,          // 0
    PointSelection_Random,          // 1
    PointSelection_Reverse,         // 2
    PointSelection_MAX              // 3
};

/** VARIABLE DECLARATIONS */
var() float MaxFactoryStartDelay;
var() float MinFactoryStartDelay;
/** Maximum pawns allowed in the level */
var() int MaxSpawnedCount;
/** Minimum time in seconds between */
var() float AdditionalRandomTimeBetweenSpawns;
var() float TimeBetweenSpawns;
/** Maximum pawns that may be spawned at the same time */
var() int MaxSpawnedAtOnce;
var() SPDestructibleProperties DestructibleProperties;
var() SPActorFactoryAI.ESpPointSelection PointSelection;
var() SPSpawnPoint.ESpPointGroup RestrictSpawnPointsTo;
/** Array for Special specific animsets */
var() array<AnimSet> SpecialAnimSets;
/** The profile to use */
var(ProfileSystem) SPRandomPedProfile PedProfile;
/** Set to true to use a user specified profile combination */
var(ProfileSystem) bool bUseUserCombination;
var bool bDeathCanResetCounter;
/** Skeletal Mesh ID of the profile to use if bUseUserCombination is set */
var(ProfileSystem) int UserSkelMeshID;
/** Material Combination ID of the profile to use if bUseUserCombination is set */
var(ProfileSystem) array<int> UserMtlCombinationID;
var int SpawnedCount;
var float RemainingDelay;
var int LastSpawnIdx;
/** SPPawn only.  Allows designer to define a debug string that can be displayed over the object in-game CPP TEXT                       NATIVE FUNCTION DECLARATIONS FUNCTION DECLARATIONS FUNCTIONS/STATES- BEGIN SECTION -  <SECTION NAME> <SECTION NAME>- END SECTION - ----------------------------------------------------------------------- Function: Description:---------------------------------------------------------------------------------------------------------------------------------------------- State: Description:----------------------------------------------------------------------- Default Properties */
var() string DebugTag;
