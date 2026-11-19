class SkyAnimNotify_StartInterp extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() float InterpTime;
var() float Accel;
var() float Speed;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn SP;

    SP = SkyPawn(Owner);
    // End:0x43
    if(SP != none)
    {
        SP.NotifyStartInterpolation(Speed, Accel, InterpTime, AnimSeqInstigator);
    }
    //return;    
}
