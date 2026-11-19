class SkyAnimNotify_SetIK extends SkyAnimNotify_Reversible
    native
    config(Engine)
    editinlinenew
    collapsecategories;

enum EAnimNotifySetIK
{
    IK_Enable,                      // 0
    IK_Disable,                     // 1
    IK_MAX                          // 2
};

var() SkyAnimNotify_SetIK.EAnimNotifySetIK IKMode;
var() array<name> IKControls;

event Reverse(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    ReverseIKControls(Owner);
    super.Reverse(Owner, AnimSeqInstigator);
    //return;    
}

// Export USkyAnimNotify_SetIK::execReverseIKControls(FFrame&, void* const)
native function ReverseIKControls(Actor Owner);

// Export USkyAnimNotify_SetIK::execSetIK(FFrame&, void* const)
native function SetIK(Pawn P, bool Enable);
