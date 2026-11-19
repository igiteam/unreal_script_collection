class SkyAnimNotify_StartDeathEffects extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn SP;

    SP = SkyPawn(Owner);
    // End:0x1B
    if(SP != none)
    {
    }
    //return;    
}
