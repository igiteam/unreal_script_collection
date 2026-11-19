class SkyAnimNotify_MoveToCover extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bOn;
var() float TravelTime;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawnCoverUser P;

    P = SkyPawnCoverUser(Owner);
    // End:0x6F
    if(P != none)
    {
        // End:0x56
        if(int(P.GetCoverState()) == int(25))
        {
            P.TransitionToNextCoverSlot(TravelTime);            
        }
        else
        {
            P.MoveToCover(TravelTime);
        }
    }
    //return;    
}
