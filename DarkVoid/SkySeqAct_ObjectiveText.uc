class SkySeqAct_ObjectiveText extends SequenceAction;

var() string ObjectiveText;
var() bool DontAutoHide;
var() bool IncludeTutorial;

event Activated()
{
    local PlayerController PC;
    local SkyGameReplicationInfo GRI;

    PC = PlayerController(Pawn(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue()).Controller);
    // End:0x80
    if(PC == none)
    {
        PC = PlayerController(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
    }
    // End:0x8B
    if(PC == none)
    {
    }
    GRI = SkyGameReplicationInfo(PC.WorldInfo.GRI);
    // End:0x14A
    if(GRI != none)
    {
        // End:0x131
        if((PC != none) && SkyHUD(PC.myHUD) != none)
        {
            SkyHUD(PC.myHUD).bForceObjectiveView = DontAutoHide;
            // End:0x131
            if(IncludeTutorial)
            {
                SkyHUD(PC.myHUD).bNextObjectiveTutorial = true;
            }
        }
        GRI.SetCurrentObjectiveText(ObjectiveText);
    }
    //return;    
}
