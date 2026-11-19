class SkyAnimNotify_Disintegrate extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var array<SVisualEffectParams> Effects;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn SP;

    SP = SkyPawn(Owner);
    // End:0x39
    if(SP != none)
    {
        SP.AddEffectVisualEffect(Effects, Owner);
    }
    //return;    
}
