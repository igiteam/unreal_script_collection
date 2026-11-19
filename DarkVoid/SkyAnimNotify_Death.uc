class SkyAnimNotify_Death extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() SkyPawn.EDamageSource Source;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    // End:0x2E
    if(SkyPawn(Owner) != none)
    {
        SkyPawn(Owner).AnimNotifyDeath(Source);
    }
    //return;    
}
