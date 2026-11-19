class AdvAICmd_Attack_Throw extends EvilAICmd_Attack_Throw within EvilAIController;

var AdvAIController_Cover CoverAI;

static function bool Throw(EvilAIController AI)
{
    local AdvAICmd_Attack_Throw Cmd;

    Cmd = new (AI) Class'AdvAICmd_Attack_Throw';
    // End:0x8A
    if(Cmd != none)
    {
        Cmd.CoverAI = AdvAIController_Cover(AI);
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function FireFailure()
{
    GotoState('DelayFailure');
    //return;    
}

function Pushed()
{
    // End:0xF0
    if((CoverAI != none) && CoverAI.IsAtCover())
    {
        // End:0xA0
        if(!CoverAI.GetCoverAction(CoverAI.Cover, Outer.ShotTarget))
        {
            FireFailure();            
        }
        else
        {
            CoverAI.SetCoverAction(CoverAI.PendingFireLinkItem.SrcAction);
        }
    }
    super.Pushed();
    //return;    
}

function Popped()
{
    // End:0x53
    if((CoverAI != none) && CoverAI.IsAtCover())
    {
        CoverAI.ResetCoverAction();
    }
    super.Popped();
    //return;    
}
