class AdvAICmd_MoveToCover extends EvilAICommand within AdvAIController_Cover;

var CoverInfo CoverGoal;
var CoverSlot CoverSlot;

function Pushed()
{
    super.Pushed();
    // End:0x65
    if(CoverGoal != Outer.Cover)
    {
        Outer.ClaimCover(CoverGoal);
    }
    DoMove();
    //return;    
}

function DoMove()
{
    local Vector CoverLocation;

    Outer.bReachedCover = false;
    Outer.SetAcquireCover(0);
    // End:0x78
    if(!Outer.HasValidCover())
    {
        GotoState('DelayFailure');        
    }
    else
    {
        // End:0xD3
        if(Outer.IsAtCover())
        {
            Outer.CoverGoal = CoverGoal;
            GotoState('DelaySuccess');            
        }
        else
        {
            CoverLocation = CoverGoal.Link.GetSlotLocation(CoverGoal.SlotIdx);
            // End:0x1C5
            if(Outer.IsGoalCollidingWithOtherPawns(CoverLocation, Outer.MyEvilPawn.GetCollisionRadius() * float(2)) && !Outer.IsCoveringForced())
            {
                GotoState('DelayFailure');
            }
            Outer.CoverGoal = CoverGoal;
            Outer.MyEvilPawn.bMovingToCover = true;
            Outer.SetMovePoint(CoverLocation, Outer.MyEvilPawn.GetCollisionRadius());
        }
    }
    //return;    
}

static function bool MoveToCoverLink(EvilAIController AI, CoverLink InCoverLink, optional int InSlotIdx = -1)
{
    local AdvAICmd_MoveToCover Cmd;
    local AdvAIController_Cover CoverAI;
    local CoverInfo NewCoverGoal;

    // End:0x23
    if(InSlotIdx < 0)
    {
        InSlotIdx = 0;
    }
    CoverAI = AdvAIController_Cover(AI);
    // End:0x1AA
    if(((CoverAI != none) && InCoverLink != none) && InSlotIdx >= 0)
    {
        Cmd = new (CoverAI) Class'AdvAICmd_MoveToCover';
        // End:0x1AA
        if(Cmd != none)
        {
            NewCoverGoal.Link = InCoverLink;
            NewCoverGoal.SlotIdx = InSlotIdx;
            Cmd.CoverGoal = NewCoverGoal;
            Cmd.CoverSlot = NewCoverGoal.Link.Slots[NewCoverGoal.SlotIdx];
            CoverAI.PushCommand(Cmd);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

static function bool MoveToCover(EvilAIController AI, CoverInfo NewCoverGoal)
{
    local AdvAICmd_MoveToCover Cmd;
    local AdvAIController_Cover CoverAI;

    CoverAI = AdvAIController_Cover(AI);
    // End:0x161
    if(((CoverAI != none) && NewCoverGoal.Link != none) && NewCoverGoal.SlotIdx >= 0)
    {
        Cmd = new (CoverAI) Class'AdvAICmd_MoveToCover';
        // End:0x161
        if(Cmd != none)
        {
            Cmd.CoverGoal = NewCoverGoal;
            Cmd.CoverSlot = NewCoverGoal.Link.Slots[NewCoverGoal.SlotIdx];
            CoverAI.PushCommand(Cmd);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function Resumed(name OldCommandName)
{
    super(GameAICommand).Resumed(OldCommandName);
    // End:0x1E4
    if((ChildStatus == 'Success') && (Outer.Cover.Link != none) || Outer.ClaimCover(CoverGoal))
    {
        // End:0x18F
        if(CoverGoal.Link.Slots[CoverGoal.SlotIdx].SlotOwner != Outer.MyEvilPawn)
        {
            Outer.AbortCommand(self);
            Outer.NotifyCoverDisabled(CoverGoal.Link, CoverGoal.SlotIdx);
            return;
        }
        Outer.NotifyReachedCover();
        Status = 'Success';
        Outer.PopCommand(self);        
    }
    else
    {
        Status = 'Failure';
        Outer.PopCommand(self);
    }
    //return;    
}

function Popped()
{
    super(GameAICommand).Popped();
    // End:0xDB
    if(Status == 'Success')
    {
        Outer.EnterCoverTime = Outer.WorldInfo.TimeSeconds;
        Outer.CoveringTimeout = RandRange(Outer.MinCoverTimeout, Outer.MaxCoverTimeout);        
    }
    else
    {
        Outer.UnClaimCover();
    }
    Outer.ClearCoverGoal();
    Outer.MyEvilPawn.bMovingToCover = false;
    //return;    
}

state DelaySuccess
{
    function Resumed(name OldCommandName)
    {
        super(GameAICommand).Resumed(OldCommandName);
        //return;        
    }
    stop;    
}

state DelayFailure
{
    function Resumed(name OldCommandName)
    {
        super(GameAICommand).Resumed(OldCommandName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    CoverSlot=none
}