class SkyAnimNotify_CockpitControl extends SkyAnimNotify_Reversible
    config(Engine)
    editinlinenew
    collapsecategories;

enum ECockpitControl
{
    Open_Cockpit,                   // 0
    Close_Cockpit,                  // 1
    ECockpitControl_MAX             // 2
};

var() SkyAnimNotify_CockpitControl.ECockpitControl Command;
var() bool immediate;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyAirVehicle SAV;
    local SkyPawn SP;

    SAV = SkyAirVehicle(Owner);
    // End:0x70
    if(SAV == none)
    {
        SP = SkyPawn(Owner);
        // End:0x70
        if(SP != none)
        {
            SAV = SkyAirVehicle(SP.DrivenVehicle);
            // End:0x70
            if(SAV == none)
            {
                SAV = SP.HijackTarget;
            }
        }
    }
    // End:0xC2
    if(SAV != none)
    {
        // End:0xA8
        if(int(Command) == int(0))
        {
            SAV.OpenCockpit(immediate);            
        }
        else
        {
            SAV.CloseCockpit(immediate);
        }
    }
    super(AnimNotify_Scripted).Notify(Owner, AnimSeqInstigator);
    //return;    
}

event Reverse(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyAirVehicle SAV;
    local SkyPawn SP;

    SAV = SkyAirVehicle(Owner);
    // End:0x70
    if(SAV == none)
    {
        SP = SkyPawn(Owner);
        // End:0x70
        if(SP != none)
        {
            SAV = SkyAirVehicle(SP.DrivenVehicle);
            // End:0x70
            if(SAV == none)
            {
                SAV = SP.HijackTarget;
            }
        }
    }
    // End:0xC2
    if(SAV != none)
    {
        // End:0xA8
        if(int(Command) == int(0))
        {
            SAV.CloseCockpit(immediate);            
        }
        else
        {
            SAV.OpenCockpit(immediate);
        }
    }
    super.Reverse(Owner, AnimSeqInstigator);
    //return;    
}
