class EvilAIReactChannel extends Object;

var name ChannelName;
var bool bChannelSuppressed;
var bool bNeedsPoll;
var array<EvilAIReactCondition> Reactions;
var array<EvilAIReactCondition> UnblockReactions;

function Subscribe(EvilAIReactCondition Condition, optional bool bAsUnblockingChannel = false)
{
    // End:0x2B
    if(bAsUnblockingChannel)
    {
        UnblockReactions.AddItem(Condition);        
    }
    else
    {
        Reactions.AddItem(Condition);
    }
    Condition.SubscribedChannels.AddItem(ChannelName);
    //return;    
}

function UnSubscribe(EvilAIReactCondition Condition)
{
    Reactions.RemoveItem(Condition);
    Condition.SubscribedChannels.RemoveItem(ChannelName);
    //return;    
}

function EvilAIReactCondition SuppressReactionByType(class<EvilAIReactCondition> ReactConditionType)
{
    local EvilAIReactCondition cond;

    cond = FindReactionByType(ReactConditionType);
    // End:0x4B
    if(cond != none)
    {
        cond.Suppress();
    }
    return cond;
    //return ReturnValue;    
}

function EvilAIReactCondition UnSuppressReactionByType(class<EvilAIReactCondition> ReactConditionType)
{
    local EvilAIReactCondition cond;

    cond = FindReactionByType(ReactConditionType);
    // End:0x4B
    if(cond != none)
    {
        cond.UnSuppress();
    }
    return cond;
    //return ReturnValue;    
}

function EvilAIReactCondition FindReactionByType(class<EvilAIReactCondition> ReactConditionClass)
{
    local EvilAIReactCondition Condition;

    // End:0x4F
    foreach Reactions(Condition)
    {
        // End:0x4E
        if(Condition.Class == ReactConditionClass)
        {            
            return Condition;
        }        
    }    
    return none;
    //return ReturnValue;    
}

function NudgeChannel(Actor InInstigator)
{
    local EvilAIReactCondition reaction;

    // End:0x93
    if(!bChannelSuppressed)
    {
        // End:0x50
        foreach UnblockReactions(reaction)
        {
            reaction.UnblockReaction(InInstigator, self);            
        }        
        // End:0x92
        foreach Reactions(reaction)
        {
            reaction.ConditionalCheckActivate(InInstigator, self);            
        }        
    }
    //return;    
}

function Suppress()
{
    bChannelSuppressed = true;
    //return;    
}

function UnSuppress()
{
    bChannelSuppressed = false;
    //return;    
}

function Poll(float DeltaTime)
{
    //return;    
}

function Init(name InChannelName)
{
    ChannelName = InChannelName;
    //return;    
}
