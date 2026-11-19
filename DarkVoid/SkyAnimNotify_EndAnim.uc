class SkyAnimNotify_EndAnim extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bFireAnimEndEarly;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    // End:0x29
    if(SkyAnimNodeSequence(AnimSeqInstigator) != none)
    {
        SkyAnimNodeSequence(AnimSeqInstigator).OnEndAnimNotify();
    }
    //return;    
}
