class SkyAnimNotify_IntervehicFinalApproach extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bEnabled;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;

    // End:0x0D
    if(!bEnabled)
    {
        return;
    }
    P = SkyPawn(Owner);
    // End:0x4F
    if((P != none) && P.bGoingIntervehicular)
    {
        P.bIntervehicularFinalApproach = true;
    }
    //return;    
}
