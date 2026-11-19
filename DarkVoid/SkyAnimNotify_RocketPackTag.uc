class SkyAnimNotify_RocketPackTag extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() SkyItem_RocketPack.RocketPackTags Tag;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    // End:0x54
    if((SkyPawn(Owner) != none) && SkyPawn(Owner).RocketPack != none)
    {
        SkyPawn(Owner).RocketPack.RocketPackPlayTag(Tag);
    }
    //return;    
}
