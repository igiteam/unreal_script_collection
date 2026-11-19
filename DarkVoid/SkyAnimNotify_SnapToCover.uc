class SkyAnimNotify_SnapToCover extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bDontAlignLocation;
var() bool bDontAlignRotation;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawnCoverUser P;

    P = SkyPawnCoverUser(Owner);
    // End:0x3B
    if(P != none)
    {
        P.MoveToCurrentCoverPosition(bDontAlignLocation, bDontAlignRotation);
    }
    //return;    
}
