class APA_FullBodyHitReaction extends EPA_FullBodyHitReaction;

function bool CanOverrideActionWith(byte NewAction)
{
    local bool Result;

    Result = (((int(NewAction) == 3) || int(NewAction) == 1) || int(NewAction) == 55) && int(CurrentAST) != int(105);
    return Result;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    return super.CanOverrideAction(inAction) && int(inAction) != 55;
    //return ReturnValue;    
}
