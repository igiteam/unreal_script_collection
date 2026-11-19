class APA_FullBodyHitReactionNPC extends EPA_FullBodyHitReaction;

function bool CanOverrideActionWith(byte NewAction)
{
    local bool Result;

    Result = super.CanOverrideActionWith(NewAction) && int(NewAction) != 1;
    return Result;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    return super.CanOverrideAction(inAction) && int(inAction) != 1;
    //return ReturnValue;    
}
