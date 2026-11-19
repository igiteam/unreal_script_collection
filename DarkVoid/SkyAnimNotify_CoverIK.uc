class SkyAnimNotify_CoverIK extends SkyAnimNotify_Reversible
    native
    config(Engine)
    editinlinenew
    collapsecategories;

var() SkyAnimNotify_SetIK.EAnimNotifySetIK IKMode;
var() array<name> IKControls;

event Reverse(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    ReverseIKControls(Owner);
    super.Reverse(Owner, AnimSeqInstigator);
    //return;    
}

// Export USkyAnimNotify_CoverIK::execReverseIKControls(FFrame&, void* const)
native function ReverseIKControls(Actor Owner);

// Export USkyAnimNotify_CoverIK::execSetIK(FFrame&, void* const)
native function SetIK(SkyPawnCoverUser Pawn, bool Enable);
