class SkyAnimNotify_RotateToCover extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

enum RotateToCoverDirection
{
    RotateToCover_Clockwise,        // 0
    RotateToCover_CounterClockwise, // 1
    RotateToCover_Shortest,         // 2
    RotateToCover_MAX               // 3
};

var() bool bOn;
var() bool ReverseCoverOrientation;
var() float RotateTime;
var() SkyAnimNotify_RotateToCover.RotateToCoverDirection Direction;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawnCoverUser P;

    P = SkyPawnCoverUser(Owner);
    // End:0xE6
    if(P != none)
    {
        // End:0x8F
        if(ReverseCoverOrientation && !P.EntryPhysics.ReverseEntryApplied)
        {
            P.EntryPhysics.FinalRotation.Yaw -= 32768;
            P.EntryPhysics.ReverseEntryApplied = true;
        }
        // End:0xBE
        if(int(Direction) == int(2))
        {
            P.RotateToCover(RotateTime, true);            
        }
        else
        {
            P.RotateToCover(RotateTime, false, int(Direction) == int(0));
        }
    }
    //return;    
}
