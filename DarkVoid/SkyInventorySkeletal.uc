class SkyInventorySkeletal extends SkyInventory
    native;

struct native SActiveSkelControls
{
    var() name ControlName;
    var() float ControlStrength;

    structdefaultproperties
    {
        ControlName="None"
        ControlStrength=0.0000000
    }
};

var() export editinline SkeletalMeshComponent Mesh;
var transient array<AnimNodeSlot> SlotNodes;
var() array<SActiveSkelControls> ActiveSkelControls;

// Export USkyInventorySkeletal::execMAT_BeginAnimControl(FFrame&, void* const)
native function MAT_BeginAnimControl(array<AnimSet> InAnimSets);

// Export USkyInventorySkeletal::execMAT_SetAnimPosition(FFrame&, void* const)
native function MAT_SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping);

// Export USkyInventorySkeletal::execMAT_SetAnimWeights(FFrame&, void* const)
native function MAT_SetAnimWeights(array<AnimSlotInfo> SlotInfos);

// Export USkyInventorySkeletal::execMAT_FinishAnimControl(FFrame&, void* const)
native function MAT_FinishAnimControl();

// Export USkyInventorySkeletal::execUpdateSkelControls(FFrame&, void* const)
native function UpdateSkelControls();

simulated event BeginAnimControl(array<AnimSet> InAnimSets)
{
    MAT_BeginAnimControl(InAnimSets);
    //return;    
}

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping)
{
    MAT_SetAnimPosition(SlotName, ChannelIndex, InAnimSeqName, InPosition, bFireNotifies, bLooping);
    //return;    
}

simulated event SetAnimWeights(array<AnimSlotInfo> SlotInfos)
{
    MAT_SetAnimWeights(SlotInfos);
    //return;    
}

simulated event FinishAnimControl()
{
    MAT_FinishAnimControl();
    //return;    
}
