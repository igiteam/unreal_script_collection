class SkyAnimNotify_PlayKnightHover extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bEnableHoverSound;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn_WatcherSuit Knight;

    Knight = SkyPawn_WatcherSuit(Owner);
    // End:0x32
    if(Knight != none)
    {
        Knight.bShouldPlayHoverLoop = bEnableHoverSound;
    }
    //return;    
}
