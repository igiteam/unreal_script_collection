class VehicleBrainState extends OIRBrainState;

state Working
{
    function ChildBeginState(name PreviousStateName)
    {
        super.ChildBeginState(PreviousStateName);
        RegisterAxonNamedScriptEventListener('LeaveVehicle', DelayDeparture);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AxonAnimService'Default__VehicleBrainState.AnimService0'
    begin object name=AnimService0
    end object
    AnimService=AnimService0
    fDepartureDelay=2.5000000
    EventServices=/* Array type was not detected. */
}