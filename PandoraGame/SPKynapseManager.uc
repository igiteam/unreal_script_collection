class SPKynapseManager extends Actor
    transient
    native
    notplaceable;

const SmallPathObjectMemoryPoolIndex = 0;
const MediumPathObjectMemoryPoolIndex = 1;
const LargePathObjectMemoryPoolIndex = 2;
const AIEntityObjectMemoryPoolIndex = 3;

enum EKynapseMemoryPoolType
{
    ekmpDefault,                    // 0
    ekmpAIMemoryPool,               // 1
    ekmpPlayerMemoryPool,           // 2
    ekmpSmallPathObjectMemoryPool,  // 3
    ekmpMediumPathObjectMemoryPool, // 4
    ekmpLargePathObjectMemoryPool,  // 5
    ekmpKynapseEntityDefinitionScrathPadPool,// 6
    ekmpKynapseGraphAndMeshMemoryPool,// 7
    ekmpFlightPathObjectMemoryPool, // 8
    EKynapseMemoryPoolType_MAX      // 9
};

struct native SPVertexObjectLink
{
    var array<Actor> ClosestObjects;

    structdefaultproperties
    {
        ClosestObjects=none
    }
};

struct native SPVertexObjectArray
{
    var array<SPVertexObjectLink> PerVertexObjectLinks;

    structdefaultproperties
    {
        PerVertexObjectLinks=none
    }
};

struct native SPEntityFreeListDescriptor
{
    var int blockSize;
    var int blockCount;

    structdefaultproperties
    {
        blockSize=0
        blockCount=0
    }
};

var private native const noexport Pointer VfTable_FTickableObject;
/** VARIABLE DECLARATIONS The current kynapse data. This gets swapped out every time a new kynapse sublevel is loaded. */
var(Kynapse) transient SPKynapseLevelData CurrentLevelData;
var export editinline transient SPLineBatchComponent AIMeshLineBatchers[8];
var export editinline transient SPLineBatchComponent GraphLineBatchers[8];
var export editinline transient SPLineBatchComponent LineBatcherAIPath;
var export editinline transient SPLineBatchComponent LineBatcherPathObjects;
var export editinline transient SPLineBatchComponent LineBatcherMisc;
var export editinline SPDirectFlightPlanner m_flightPlanner;
var transient bool m_bIsEditor;
var private transient bool m_bActive;
var private transient bool m_bNeedsReinit;
var transient bool m_bValid;
var native Pointer FlightAnchorManager;
var native Pointer WorldDef;
var transient array<SPVertexObjectArray> VertexObjectLinks;
var transient array<Pointer> CachedGraphPointers;
var array<SPEntityFreeListDescriptor> m_entityFreeListDescriptors;
var transient array<Pointer> m_entityFreeLists;
var native transient Pointer m_KynapseEntityDefinitionScratchPadPool;
var native transient Pointer m_GraphAndMeshPool;
var native transient Pointer m_DefaultPoolAllocator;
var native transient Pointer m_EngineAllocator;
var native transient array<Pointer> m_allocatorStack;

simulated function PostBeginPlay()
{
    //return;    
}

event Destroyed()
{
    //return;    
}

// Export USPKynapseManager::execGetKynapseRenderPathsState(FFrame&, void* const)
native function bool GetKynapseRenderPathsState();
