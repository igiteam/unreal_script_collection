class SkyCoverLink extends CoverLink
    native;

var() Vector ShufflePlayerOffset;
var() SkyCoverCameraActor CoverCamera;
var() editconst array<editconst name> SlotMaterialTypes;
var bool bMovingCoverLink;

// Export USkyCoverLink::execAutoAdjustSlot(FFrame&, void* const)
native simulated function bool AutoAdjustSlot(int SlotIdx, bool bOnlyCheckLeans);

// Export USkyCoverLink::execGetCoverOrientation(FFrame&, void* const)
native simulated function CoverLink.ECoverOrientation GetCoverOrientation();

// Export USkyCoverLink::execConstructCoverMeshComponent(FFrame&, void* const)
native simulated function CoverMeshComponent ConstructCoverMeshComponent();

// Export USkyCoverLink::execGetSlotMeshType(FFrame&, void* const)
native simulated function int GetSlotMeshType(int SlotIdx);

// Export USkyCoverLink::execCalcAlignDist(FFrame&, void* const)
native simulated function float CalcAlignDist(int SlotIdx);

// Export USkyCoverLink::execGetSlotPlayerOffset(FFrame&, void* const)
native simulated function Vector GetSlotPlayerOffset(int SlotIdx);

// Export USkyCoverLink::execAlignedToActor(FFrame&, void* const)
native simulated function AlignedToActor(Actor ABase, int SlotIdx);

simulated event Destroyed()
{
    local int Idx;
    local SkyPawnCoverUser SP;

    Idx = 0;
    J0x07:

    // End:0x57 [Loop If]
    if(Idx < Claims.Length)
    {
        SP = SkyPawnCoverUser(Claims[Idx]);
        // End:0x4C
        if(SP != none)
        {
            SP.NotifyCoverGone();
        }
        Claims.Remove(0, 1);
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}
