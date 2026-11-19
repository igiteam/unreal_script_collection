class SkyAnimNotify_PlayCustomAnim extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() InteractionAnimInfo AnimDatum;
var deprecated float BlendOutTime;
var() bool bOverride;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn SP;

    SP = SkyPawn(Owner);
    // End:0x36
    if(SP != none)
    {
        SP.PlayCustomAnim(AnimDatum, bOverride);
    }
    //return;    
}
