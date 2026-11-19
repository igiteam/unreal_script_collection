class SkyAnimNotify_ExitVehicle extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bForceLeave;
var() bool bDisableCollision;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;

    P = SkyPawn(Owner);
    // End:0x70
    if((P != none) && P.DrivenVehicle != none)
    {
        P.DrivenVehicle.DriverLeave(bForceLeave);
        // End:0x70
        if(bDisableCollision)
        {
            P.SetCollision(false, false);
        }
    }
    //return;    
}
