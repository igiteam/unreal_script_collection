class SkyAnimNotify_Thrashing extends SkyAnimNotify_Reversible
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bOn;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyGrippableActor SGA;

    SGA = SkyGrippableActor(Owner);
    // End:0x35
    if(SGA != none)
    {
        SGA.SetThrashing(bOn);
    }
    super(AnimNotify_Scripted).Notify(Owner, AnimSeqInstigator);
    //return;    
}

event Reverse(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyGrippableActor SGA;

    SGA = SkyGrippableActor(Owner);
    // End:0x37
    if(SGA != none)
    {
        SGA.SetThrashing(!bOn);
    }
    super.Reverse(Owner, AnimSeqInstigator);
    //return;    
}
