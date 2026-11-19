class SkySeqAct_ObjectiveLocator extends SequenceAction
    native;

var deprecated string ObjectiveText;
var() string ObjectiveLabel;
var() bool bReplaceCurrent;
var deprecated bool bDisplayInGame;
var() bool DontAutoHide;
var() bool IncludeTutorial;
var SkyGameReplicationInfo RepInfo;
var() float FlashPeriod;
var() float FlashDuration;

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
    // End:0x156
    if(GRI != none)
    {
        SkyHUD(PC.myHUD).bForceObjectiveView = DontAutoHide;
        // End:0x10A
        if(IncludeTutorial)
        {
            SkyHUD(PC.myHUD).bNextObjectiveTutorial = true;
        }
        GRI.SetCurrentObjective(Actor(SeqVar_Object(VariableLinks[1].LinkedVariables[0]).GetObjectValue()), bReplaceCurrent, ObjectiveLabel);
    }
    //return;    
}

static event int GetObjClassVersion()
{
    return 2;
    //return ReturnValue;    
}

event SkyGameReplicationInfo GetRepInfo()
{
    local PlayerController PC;

    // End:0x11
    if(RepInfo != none)
    {
        return RepInfo;
    }
    PC = PlayerController(Pawn(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue()).Controller);
    // End:0x91
    if(PC == none)
    {
        PC = PlayerController(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
    }
    // End:0xA6
    if(PC == none)
    {
        RepInfo = none;        
    }
    else
    {
        RepInfo = SkyGameReplicationInfo(PC.WorldInfo.GRI);
    }
    return RepInfo;
    //return ReturnValue;    
}
