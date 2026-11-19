class SkySeqAct_ShowDebug extends SequenceAction;

var() name DebugType;

event Activated()
{
    local PlayerController PC;

    PC = PlayerController(Pawn(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue()).Controller);
    // End:0x80
    if(PC == none)
    {
        PC = PlayerController(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
    }
    // End:0x133
    if((PC != none) && PC.myHUD != none)
    {
        // End:0xE8
        if(!PC.myHUD.bShowDebugInfo)
        {
            PC.myHUD.ShowDebug('None');
        }
        // End:0x133
        if(!PC.myHUD.ShouldDisplayDebug(DebugType))
        {
            PC.myHUD.ShowDebug(DebugType);
        }
    }
    //return;    
}
