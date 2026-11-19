class PKAIcmd_Base_UtilActionSelector extends EvilAIcmd_Base_UtilActionSelector within PKAIController;

var int CurrentCommandIndex;
var int BestCommandIndex;

function Pushed()
{
    super.Pushed();
    InitPossibleCommandsMeta();
    //return;    
}

function InitPossibleCommandsMeta()
{
    local EvilUtilBasedAICmdMetaDataPacket MetaData;

    // End:0x10E
    foreach PossibleCommands(MetaData)
    {
        // End:0x10D
        if(ClassIsChildOf(MetaData.CommandClass, Class'PKAICmd_Base_UtilitySelectedCmd'))
        {
            MetaData.ActualPriority = class<PKAICmd_Base_UtilitySelectedCmd>(MetaData.CommandClass).default.InitPriority;
            MetaData.LastDeactivationTime = class<PKAICmd_Base_UtilitySelectedCmd>(MetaData.CommandClass).static.GetInitLastDeactivationTime(Outer, MetaData);
        }        
    }    
    //return;    
}

function OnUpdate()
{
    local float PreDelay;

    PreDelay = PrePickBestCommand();
    // End:0x65
    if(Outer.DelayToHunt > 0.0000000)
    {
        Outer.DelayToHunt -= PreDelay;
    }
    // End:0xA7
    if(PreDelay > 0.0000000)
    {
        Outer.SetTimer(PreDelay, false, 'ExecuteBestCommandWrapper', self);        
    }
    else
    {
        ExecuteBestCommandWrapper();
    }
    //return;    
}

function ExecuteBestCommandWrapper()
{
    local float PostDelay;

    // End:0x21
    if(ExecuteBestCommand())
    {
        PostDelay = PostCommandExecution();
    }
    // End:0x72
    if(Outer.DelayToHunt > 0.0000000)
    {
        Outer.DelayToHunt -= PostDelay;
    }
    // End:0xB4
    if(PostDelay > 0.0000000)
    {
        Outer.SetTimer(PostDelay, false, 'OnUpdate', self);        
    }
    else
    {
        OnUpdate();
    }
    //return;    
}

function float PrePickBestCommand()
{
    return 0.0500000;
    //return ReturnValue;    
}

function float PostCommandExecution()
{
    return 0.0500000;
    //return ReturnValue;    
}

function bool ExecuteBestCommand()
{
    local PKAICmd_Base_UtilitySelectedCmd Cmd;

    Cmd = GetActivePKAction();
    // End:0x1F5
    if(Outer.bAllowCombatTransitions)
    {
        // End:0xD6
        if(CurrentCommandIndex != -1)
        {
            // End:0xD6
            if((Cmd != none) && Cmd.ShouldDeactivate())
            {
                PossibleCommands[CurrentCommandIndex].CommandClass.static.DeactivateUtilitySelectedCommand(Outer, PossibleCommands[CurrentCommandIndex]);
            }
        }
        BestCommandIndex = PickBestCommand();
        // End:0x1F5
        if((BestCommandIndex != -1) && BestCommandIndex != CurrentCommandIndex)
        {
            // End:0x183
            if(CurrentCommandIndex != -1)
            {
                PossibleCommands[CurrentCommandIndex].CommandClass.static.DeactivateUtilitySelectedCommand(Outer, PossibleCommands[CurrentCommandIndex]);
            }
            // End:0x1F5
            if(PossibleCommands[BestCommandIndex].CommandClass.static.InitUtilitySelectedCommand(Outer, PossibleCommands[BestCommandIndex]))
            {
                CurrentCommandIndex = BestCommandIndex;
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function PKAICmd_Base_UtilitySelectedCmd GetActivePKAction()
{
    // End:0x25
    if(ChildCommand != none)
    {
        return PKAICmd_Base_UtilitySelectedCmd(ChildCommand);        
    }
    else
    {
        return none;
    }
    //return ReturnValue;    
}

state PickBestAction
{Begin:

    OnUpdate();
    stop;        
}

defaultproperties
{
    CurrentCommandIndex=-1
}