class SkyAnimNotify_AirVehicleThrottle extends SkyAnimNotify_Reversible
    config(Engine)
    editinlinenew
    collapsecategories;

var() float Throttle;
var() float Period;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyAirVehicle SAV;

    SAV = SkyAirVehicle(Owner);
    // End:0x5F
    if(SAV != none)
    {
        SAV.bOverrideThrottle = true;
        SAV.OverrideThrottleSetting = Throttle;
        SAV.SetTimer(Period, false, 'OverrideThrottleEnd');
    }
    super(AnimNotify_Scripted).Notify(Owner, AnimSeqInstigator);
    //return;    
}

event Reverse(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyAirVehicle SAV;

    SAV = SkyAirVehicle(Owner);
    // End:0x2F
    if(SAV != none)
    {
        SAV.OverrideThrottleEnd();
    }
    super.Reverse(Owner, AnimSeqInstigator);
    //return;    
}
