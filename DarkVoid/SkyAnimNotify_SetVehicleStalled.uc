class SkyAnimNotify_SetVehicleStalled extends SkyAnimNotify_Reversible
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bStallVehicle;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyVehicle SV;

    SV = IdentifyVehicleTarget(Owner);
    // End:0x3A
    if(SV != none)
    {
        SV.SetStalled(bStallVehicle);
    }
    super(AnimNotify_Scripted).Notify(Owner, AnimSeqInstigator);
    //return;    
}

event Reverse(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyVehicle SV;

    SV = IdentifyVehicleTarget(Owner);
    // End:0x3C
    if(SV != none)
    {
        SV.SetStalled(!bStallVehicle);
    }
    super.Reverse(Owner, AnimSeqInstigator);
    //return;    
}

function SkyVehicle IdentifyVehicleTarget(Actor Owner)
{
    local SkyVehicle SV;
    local SkyPawn SP;

    SV = SkyVehicle(Owner);
    // End:0x70
    if(SV == none)
    {
        SP = SkyPawn(Owner);
        // End:0x70
        if(SP != none)
        {
            SV = SkyVehicle(SP.DrivenVehicle);
            // End:0x70
            if(SV == none)
            {
                SV = SP.HijackTarget;
            }
        }
    }
    return SV;
    //return ReturnValue;    
}
