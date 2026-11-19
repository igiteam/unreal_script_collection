class SkySeqAct_DisableEnterVehicleAnim extends SequenceAction;

event Activated()
{
    local SkyPawn SP;

    SP = SkyPawn(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
    // End:0x50
    if(SP != none)
    {
        SP.OverrideVehicleEnter = true;
    }
    //return;    
}
