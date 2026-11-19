class AAGunBrainState extends OIRBrainState;

state Working
{
    function ChildBeginState(name PreviousStateName)
    {
        super.ChildBeginState(PreviousStateName);
        RegisterAxonNamedScriptEventListener('DismountGun', DestroyTransplantBrain);
        RegisterAxonSubstateStimulus('PlayerPresence', 'PlayerPresence', LeaveOIR, 'Spine1');
        RegisterAxonSubstateStimulus('PlayerShoot', 'PlayerShoot', LeaveOIR, 'Spine1');
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AxonAnimService'Default__AAGunBrainState.AnimService0'
    begin object name=AnimService0
    end object
    AnimService=AnimService0
    iSuppressionLevel=16
    EventServices=/* Array type was not detected. */
}