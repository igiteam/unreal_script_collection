class MOHAAnimOIRManager extends MOHAAnimActivityBase
    native
    hidecategories(Object,Object,Object,Object,AnimNodeBlendList);

struct native OIRAnimInfo
{
    var() AnimTree AnimTree;
    var transient AnimTree AnimTreeInstance;
    var int AnimSetIndex;
    var float EntryDistance;
    var int AvailableEntries;

    structdefaultproperties
    {
        AnimTree=none
        AnimTreeInstance=none
        AnimSetIndex=0
        EntryDistance=0.0000000
        AvailableEntries=0
    }
};

var() editinline array<editinline OIRAnimInfo> OIRAnimInfoList;
var transient bool bIsInitialized;

// Export UMOHAAnimOIRManager::execCopyAndLink(FFrame&, void* const)
native function CopyAndLink(int OIRIndex, AnimTree newAnimTree, AnimSet newAnimSet);

// Export UMOHAAnimOIRManager::execGetIndexOf(FFrame&, void* const)
native function int GetIndexOf(AnimTree tree);

// Export UMOHAAnimOIRManager::execConnectOIR(FFrame&, void* const)
native function int ConnectOIR();

// Export UMOHAAnimOIRManager::execGetOIRDesiredEntryDistance(FFrame&, void* const)
native function float GetOIRDesiredEntryDistance(int OIRIndex);

defaultproperties
{
    bFixNumChildren=true
}