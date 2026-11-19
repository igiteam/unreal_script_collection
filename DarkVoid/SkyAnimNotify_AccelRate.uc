class SkyAnimNotify_AccelRate extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() float AccelRate;
var() bool bRestoreToDefault;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;

    P = SkyPawn(Owner);
    // End:0x7F
    if(P != none)
    {
        // End:0x58
        if(bRestoreToDefault)
        {
            P.bForceAccelRate = false;
            P.AccelRate = P.default.AccelRate;            
        }
        else
        {
            P.bForceAccelRate = true;
            P.AccelRate = AccelRate;
        }
    }
    //return;    
}
