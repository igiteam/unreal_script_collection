class AdvAICmd_MoveToGoal extends EvilAICmd_MoveToGoal within AdvAIController;

static function bool MoveToGoal(EvilAIController AI, Actor InGoal, optional float InGoalDistance = 0.0000000, optional bool bInUpdateGoal = true, optional bool bInForceWalk = false, optional bool bInShiftDestination = false, optional bool bInDontChangeFocusOnMove, optional bool bInForceDirectMove)
{
    local AdvAICmd_MoveToGoal Cmd;
    local AdvAIController AdvAI;

    AdvAI = AdvAIController(AI);
    // End:0x22B
    if((AdvAI != none) && AdvAI.Pawn != none)
    {
        Cmd = new (AdvAI) default.Class;
        Cmd.GoalDistance = InGoalDistance;
        Cmd.SavedGoalDistance = InGoalDistance;
        Cmd.bUpdateGoal = bInUpdateGoal;
        Cmd.MovePoint = vect(0.0000000, 0.0000000, 0.0000000);
        Cmd.MoveGoal = InGoal;
        Cmd.bForceWalk = bInForceWalk;
        Cmd.bShiftDestination = bInShiftDestination;
        Cmd.bDontChangeFocusOnMove = bInDontChangeFocusOnMove;
        Cmd.bForceDirectMove = bInForceDirectMove;
        AdvAI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

static function bool MoveToPoint(EvilAIController AI, Vector InMovePoint, optional float InGoalDistance = 0.0000000, optional bool bInForceWalk = false, optional bool bInForceDirectMove)
{
    local AdvAICmd_MoveToGoal Cmd;
    local AdvAIController AdvAI;

    AdvAI = AdvAIController(AI);
    // End:0x18F
    if((AdvAI != none) && AdvAI.Pawn != none)
    {
        Cmd = new (AdvAI) Class'AdvAICmd_MoveToGoal';
        Cmd.GoalDistance = InGoalDistance;
        Cmd.bUpdateGoal = false;
        Cmd.MoveGoal = none;
        Cmd.MovePoint = InMovePoint;
        Cmd.bForceWalk = bInForceWalk;
        Cmd.bForceDirectMove = bInForceDirectMove;
        AdvAI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Resumed(name OldCommandName)
{
    super(GameAICommand).Resumed(OldCommandName);
    // End:0x13C
    if((ChildStatus == 'Success') || OldCommandName == 'AdvAICmd_Move_CoverSlip')
    {
        // End:0x8F
        if(OldCommandName == 'AdvAICmd_Move_Run2Cover')
        {
            Status = 'Success';
            Outer.PopCommand(self);
            return;
        }
        Outer.MyEvilPawn.DestinationOffset = FMax(0.0000000, GoalDistance - ReachedDestinatonThresholdAdjust);
        // End:0xFA
        if(HasReachedMoveGoal())
        {
            ExitWithSuccess();            
        }
        else
        {
            Outer.PauseTimer(false, 'CheckMoveMode', self);
            CheckMoveModeToMaster();
            ReEvaluatePath();
        }        
    }
    else
    {
        Status = 'Aborted';
        Outer.PopCommand(self);
    }
    //return;    
}

function StartingMove(bool DirectMove, Actor Dest, optional bool NormalMoveOnPath = false)
{
    bIsDirectMove = DirectMove;
    Outer.MyEvilPawn.UnregisterNavmeshObstacle();
    // End:0xA9
    if(!Outer.MyEvilPawn.bMovingToCover)
    {
        Outer.InvalidateCover(true);
    }
    // End:0x15B
    if(AdvAIController_Cover(Outer) != none)
    {
        // End:0x126
        if(Outer.NavigationHandle.GetPathCacheLength() == 0)
        {
            AdvAIController_Cover(Outer).ResetCoverType();            
        }
        else
        {
            // End:0x15B
            if(NormalMoveOnPath)
            {
                AdvAIController_Cover(Outer).ResetCoverType();
            }
        }
    }
    //return;    
}

function TryToRun2Cover(bool bDirectMove, optional bool bForce = false)
{
    local AdvAIController_Cover CoverOwner;
    local CoverInfo DestCover;
    local CoverLink DestCoverLink;
    local bool bForcedCover;

    CoverOwner = AdvAIController_Cover(Outer);
    // End:0x6F
    if((bForce && CoverOwner != none) && CoverOwner.CanRun2Cover())
    {
        bForcedCover = true;
    }
    // End:0x7E
    if(CoverOwner != none)
    {
    }
    // End:0x269
    if((CoverOwner != none) && CoverOwner.bShouldRun2Cover || bForcedCover)
    {
        CoverOwner.bShouldRun2Cover = false;
        DestCover = ((CoverOwner.CoverGoal.Link != none) ? CoverOwner.CoverGoal : CoverOwner.Cover);
        DestCoverLink = DestCover.Link;
        // End:0x269
        if(((DestCoverLink != none) && DestCoverLink.IsEnabled()) && DestCoverLink.Slots[DestCover.SlotIdx].SlotOwner == Outer.MyEvilPawn)
        {
            Outer.BeginRun2Cover(CoverOwner.CoverGoal);
        }
    }
    //return;    
}

function ExitWithSuccess()
{
    MoveGoal = none;
    super(EvilAICommand).ExitWithSuccess();
    //return;    
}
