class SkyAnimNotify_EnterHijackVehicle extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bTakeover;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;

    P = SkyPawn(Owner);
    // End:0xF1
    if((P != none) && P.HijackTarget != none)
    {
        P.HijackTarget.bHijackChangingDrivers = true;
        // End:0xBC
        if(((P.HijackTarget.Driver != none) && P.HijackTarget.Driver != P) && bTakeover)
        {
            P.HijackTarget.DriverLeave(true);
        }
        P.OverrideVehicleEnter = true;
        P.HijackTarget.TryToDrive(P);
    }
    //return;    
}
