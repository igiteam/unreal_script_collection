class EvilAIcmd_Base_UtilActionSelector extends EvilAICmd_Base_UtilitySelectedCmd within EvilAIController;

var export editinline array<export editinline EvilUtilBasedAICmdMetaDataPacket> PossibleCommands;

function Pushed()
{
    super(EvilAICmd_Base_Combat).Pushed();
    GotoState('PickBestAction');
    //return;    
}

function int PickBestCommand()
{
    local int Idx;
    local float BestRating, CurRating;
    local int BestIdx;

    BestRating = -1.0000000;
    BestIdx = -1;
    Idx = 0;
    J0x29:

    // End:0x122 [Loop If]
    if(Idx < PossibleCommands.Length)
    {
        CurRating = PossibleCommands[Idx].CommandClass.static.EvaluateActivation(Outer, PossibleCommands[Idx]);
        PossibleCommands[Idx].ActualPriority = CurRating;
        // End:0x114
        if(CurRating > BestRating)
        {
            BestRating = CurRating;
            BestIdx = Idx;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x29;
    }
    return BestIdx;
    //return ReturnValue;    
}

function float PrePickBestCommand()
{
    return 0.0000000;
    //return ReturnValue;    
}

function float PostCommandExecution()
{
    return 0.1000000;
    //return ReturnValue;    
}

function bool ExecuteBestCommand()
{
    local int Best;

    Best = PickBestCommand();
    // End:0x82
    if(Best != -1)
    {
        return PossibleCommands[Best].CommandClass.static.InitUtilitySelectedCommand(Outer, PossibleCommands[Best]);
    }
    return false;
    //return ReturnValue;    
}

state PickBestAction
{Begin:

    Outer.Sleep(PrePickBestCommand());
    J0x22:

    // End:0x54 [Loop If]
    if(ExecuteBestCommand())
    {
        Outer.Sleep(PostCommandExecution());
        // [Loop Continue]
        goto J0x22;
    }
    Outer.AbortCommand(self);
    stop;            
}
