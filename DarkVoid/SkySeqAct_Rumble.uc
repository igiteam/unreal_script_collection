class SkySeqAct_Rumble extends SequenceAction;

var() editinline ForceFeedbackWaveform Rumble;

event Activated()
{
    local PlayerController PC;

    PC = PlayerController(SkyPawn(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue()).Controller);
    // End:0x8F
    if(PC == none)
    {
        PC = PlayerController(SkyVehicle(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue()).Controller);
    }
    PC.ClientPlayForceFeedbackWaveform(Rumble);
    //return;    
}
