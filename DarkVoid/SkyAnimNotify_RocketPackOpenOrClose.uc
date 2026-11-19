class SkyAnimNotify_RocketPackOpenOrClose extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool Open;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    // End:0x6F
    if((SkyPawn(Owner) != none) && SkyPawn(Owner).RocketPack != none)
    {
        SkyPawn(Owner).NotifyRocketPacking = Open;
        // End:0x6F
        if(Open == false)
        {
            SkyPawn(Owner).SetRocketPackState(0);
        }
    }
    //return;    
}
