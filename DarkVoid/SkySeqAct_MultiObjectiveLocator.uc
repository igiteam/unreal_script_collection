class SkySeqAct_MultiObjectiveLocator extends SequenceAction
    native;

enum EDisplayProgressType
{
    EDCT_NONE,                      // 0
    EDCT_COUNT_DOWN,                // 1
    EDCT_COUNT_UP,                  // 2
    EDCT_COUNT_DOWN_WITH_TOTAL,     // 3
    EDCT_COUNT_UP_WITH_TOTAL,       // 4
    EDCT_MAX                        // 5
};

struct native SDisplayText
{
    var() string BeginningText;
    var() string EndingText;

    structdefaultproperties
    {
        BeginningText=""
        EndingText=""
    }
};

struct native ObjectiveEntry
{
    var() string Name;
    var() string Label;
    var transient bool bDisabled;

    structdefaultproperties
    {
        Name=""
        Label=""
        bDisabled=false
    }
};

var() SDisplayText TextSingular;
var() SDisplayText TextPlural;
var() string TextLastOne;
var() SkySeqAct_MultiObjectiveLocator.EDisplayProgressType TextCountType;
var() array<ObjectiveEntry> Objectives;
var SkyGameReplicationInfo RepInfo;
var transient bool bGotActivated;
var() bool DontAutoHide;
var() bool IncludeTutorial;
var() bool bReplaceCurrent;
var() float FlashPeriod;
var() float FlashDuration;

// Export USkySeqAct_MultiObjectiveLocator::execGetObjectivesLeft(FFrame&, void* const)
native function int GetObjectivesLeft();

event ActivateObjectives()
{
    local SkyGameReplicationInfo SGRI;
    local int I;
    local Actor ObjectiveActor;
    local PlayerController PC;

    PC = PlayerController(Pawn(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue()).Controller);
    // End:0x80
    if(PC == none)
    {
        PC = PlayerController(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
    }
    SGRI = GetRepInfo();
    // End:0x1D6
    if(SGRI != none)
    {
        // End:0xBB
        if(bReplaceCurrent)
        {
            SGRI.SetCurrentObjective();
        }
        I = 0;
        J0xC2:

        // End:0x1D6 [Loop If]
        if(I < Objectives.Length)
        {
            Objectives[I].bDisabled = false;
            ObjectiveActor = Actor(SeqVar_Object(VariableLinks[I + 1].LinkedVariables[0]).GetObjectValue());
            // End:0x19C
            if((PC != none) && SkyHUD(PC.myHUD) != none)
            {
                SkyHUD(PC.myHUD).bForceObjectiveView = DontAutoHide;
                // End:0x19C
                if(IncludeTutorial)
                {
                    SkyHUD(PC.myHUD).bNextObjectiveTutorial = true;
                }
            }
            SGRI.SetCurrentObjective(ObjectiveActor, false, Objectives[I].Label);
            ++I;
            // [Loop Continue]
            goto J0xC2;
        }
    }
    bGotActivated = true;
    //return;    
}

function string GetObjectiveText()
{
    local string Result;

    // End:0x2C
    if(((GetObjectivesLeft()) == 1) && TextLastOne != "")
    {
        Result = TextLastOne;        
    }
    else
    {
        // End:0x86
        if(ShouldUseSingularText())
        {
            Result = TextSingular.BeginningText;
            Result = Result @ (GetMiddleText());
            Result = Result @ TextSingular.EndingText;            
        }
        else
        {
            Result = TextPlural.BeginningText;
            Result = Result @ (GetMiddleText());
            Result = Result @ TextPlural.EndingText;
        }
    }
    return Result;
    //return ReturnValue;    
}

function bool ShouldUseSingularText()
{
    local bool bResult;
    local int NumLeft, NumSoFar;

    bResult = false;
    NumLeft = GetObjectivesLeft();
    NumSoFar = Objectives.Length - NumLeft;
    // End:0x53
    if((int(TextCountType) == int(1)) && NumLeft == 1)
    {
        bResult = true;        
    }
    else
    {
        // End:0x7B
        if((int(TextCountType) == int(3)) && NumLeft == 1)
        {
            bResult = true;            
        }
        else
        {
            // End:0xA3
            if((int(TextCountType) == int(2)) && NumSoFar == 1)
            {
                bResult = true;                
            }
            else
            {
                // End:0xC8
                if((int(TextCountType) == int(4)) && NumSoFar == 1)
                {
                    bResult = true;
                }
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

function string GetMiddleText()
{
    local int NumLeft, Total;

    NumLeft = GetObjectivesLeft();
    Total = Objectives.Length;
    switch(TextCountType)
    {
        // End:0x2C
        case 0:
            return "";
        // End:0x39
        case 1:
            return string(NumLeft);
        // End:0x54
        case 3:
            return (string(NumLeft) @ "/") @ string(Total);
        // End:0x68
        case 2:
            return string(Total - NumLeft);
        // End:0x8A
        case 4:
            return (string(Total - NumLeft) @ "/") @ string(Total);
        // End:0xFFFF
        default:
            return "";
            break;
    }
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

event ClearObjective(Actor Objective)
{
    local SkyGameReplicationInfo SGRI;

    SGRI = GetRepInfo();
    // End:0x3F
    if((SGRI != none) && bGotActivated)
    {
        SGRI.ClearObjective(Objective);
    }
    //return;    
}

event UpdateObjectiveText()
{
    local SkyGameReplicationInfo SGRI;

    SGRI = GetRepInfo();
    // End:0x44
    if((SGRI != none) && bGotActivated)
    {
        SGRI.SetCurrentObjectiveText(GetObjectiveText());
    }
    //return;    
}

static event int GetObjClassVersion()
{
    return 4;
    //return ReturnValue;    
}
