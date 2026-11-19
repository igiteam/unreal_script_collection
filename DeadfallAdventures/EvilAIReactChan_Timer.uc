class EvilAIReactChan_Timer extends EvilAIReactChannel;

function Poll(float DeltaTime)
{
    local EvilAIReactCondition cond;

    // End:0x40B
    if(!bChannelSuppressed && Reactions.Length > 0)
    {
        // End:0x215
        foreach Reactions(cond)
        {
            // End:0x214
            if((cond != none) && (cond.Outer.WorldInfo.TimeSeconds - cond.TimerLastActivationTime) > cond.RealTimerInterval)
            {
                cond.ConditionalCheckActivate(none, self);
                cond.TimerLastActivationTime = cond.Outer.WorldInfo.TimeSeconds;
                switch(cond.TimerMode)
                {
                    // End:0x211
                    case 2:
                        cond.RealTimerInterval = RandRange(cond.TimerStartInverval, cond.TimerStartInverval + cond.TimerInterval);
                        // End:0x214
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
            }
            else
            {                
            }/* !MISMATCHING REMOVE, tried ForEach got Type:Else Position:0x214! */            
            // End:0x40A
            foreach UnblockReactions(cond)
            {
                // End:0x409
                if((cond != none) && (cond.Outer.WorldInfo.TimeSeconds - cond.TimerLastActivationTime) > cond.RealTimerInterval)
                {
                    cond.UnblockReaction(none, self);
                    cond.TimerLastActivationTime = cond.Outer.WorldInfo.TimeSeconds;
                    switch(cond.TimerMode)
                    {
                        // End:0x406
                        case 2:
                            cond.RealTimerInterval = RandRange(cond.TimerStartInverval, cond.TimerStartInverval + cond.TimerInterval);
                            // End:0x409
                            break;
                        // End:0xFFFF
                        default:
                            break;
                    }
                }
                else
                {                    
                }/* !MISMATCHING REMOVE, tried ForEach got Type:Else Position:0x409! */                
            }/* !MISMATCHING REMOVE, tried If got Type:ForEach Position:0x216! */
            //return;            
        }/* !MISMATCHING REMOVE, tried Else got Type:ForEach Position:0x021! */
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x000! */
}

function Subscribe(EvilAIReactCondition Condition, optional bool bAsUnblockingChannel)
{
    // End:0x216
    if(Condition != none)
    {
        Condition.TimerLastActivationTime = Condition.Outer.WorldInfo.TimeSeconds;
        super.Subscribe(Condition, bAsUnblockingChannel);
        switch(Condition.TimerMode)
        {
            // End:0x121
            case 0:
                Condition.RealTimerInterval = Condition.TimerStartInverval + Condition.TimerInterval;
                // End:0x216
                break;
            // End:0x126
            case 2:
            // End:0x1B3
            case 1:
                Condition.RealTimerInterval = RandRange(Condition.TimerStartInverval, Condition.TimerStartInverval + Condition.TimerInterval);
                // End:0x216
                break;
            // End:0xFFFF
            default:
                Condition.RealTimerInterval = Condition.TimerStartInverval + Condition.TimerInterval;
                // End:0x216
                break;
                break;
        }
    }
    //return;    
}

defaultproperties
{
    bNeedsPoll=true
}