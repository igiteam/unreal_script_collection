class SkyAnimNotify_SetHijackAttenuation extends SkyAnimNotify_Reversible
    native
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bEnableAttenuation;

// Export USkyAnimNotify_SetHijackAttenuation::execSetAttenuation(FFrame&, void* const)
native function SetAttenuation(bool Enable, Actor Owner);

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    SetAttenuation(bEnableAttenuation, AnimSeqInstigator.SkelComponent.Owner);
    super(AnimNotify_Scripted).Notify(Owner, AnimSeqInstigator);
    //return;    
}

event Reverse(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    SetAttenuation(!bEnableAttenuation, AnimSeqInstigator.SkelComponent.Owner);
    super.Reverse(Owner, AnimSeqInstigator);
    //return;    
}
