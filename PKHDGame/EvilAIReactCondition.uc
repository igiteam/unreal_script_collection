class EvilAIReactCondition extends Object within EvilAIController
    abstract;

var bool bSuppressed;
var bool bOneTimeOnly;
var bool bBlockAfterOutput;
var bool bBlockOnInit;
var bool bBlocked;
var float BlockEndTime;
var() array<name> AutoSubscribedChannels;
var() array<name> AutoSubscribedUnBlockingChannels;
var array<name> SubscribedChannels;
var() float TimerInterval;
var() float TimerStartInverval;
var float RealTimerInterval;
var float TimerLastActivationTime;
var EvilTypes.EReactTimerMode TimerMode;
var array<EvilTypes.EBehaviorMode> SuppressingBehaviors;

function ConditionalCheckActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    // End:0x5D
    if((!bSuppressed && !bBlocked) && ShouldActivate(InInstigator, OriginatingChannel))
    {
        Activate(InInstigator, OriginatingChannel);
    }
    //return;    
}

function UnblockReaction(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    // End:0x4A
    if(bBlocked)
    {
        BlockEndTime = Outer.WorldInfo.TimeSeconds;
    }
    bBlocked = false;
    //return;    
}

function SubscribeToMyChannels()
{
    local name ChannelName;

    // End:0x57
    foreach AutoSubscribedChannels(ChannelName)
    {
        Outer.ReactionManager.Subscribe(self, ChannelName);        
    }    
    //return;    
}

function SubscribeToUnblockingChannels()
{
    local name ChannelName;

    // End:0x57
    foreach AutoSubscribedUnBlockingChannels(ChannelName)
    {
        Outer.ReactionManager.Subscribe(self, ChannelName, true);        
    }    
    //return;    
}

function UnSubscribeAll()
{
    local name ChannelName;

    // End:0x56
    foreach SubscribedChannels(ChannelName)
    {
        Outer.ReactionManager.UnSubscribe(self, ChannelName);        
    }    
    //return;    
}

function Suppress()
{
    bSuppressed = true;
    //return;    
}

function UnSuppress()
{
    bSuppressed = false;
    //return;    
}

function Initialize()
{
    SubscribeToMyChannels();
    SubscribeToUnblockingChannels();
    // End:0x2D
    if(bBlockOnInit)
    {
        bBlocked = true;
    }
    //return;    
}

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    return true;
    //return ReturnValue;    
}

function Activate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    // End:0x17
    if(bOneTimeOnly)
    {
        UnSubscribeAll();
    }
    // End:0x30
    if(bBlockAfterOutput)
    {
        bBlocked = true;
    }
    //return;    
}

defaultproperties
{
    TimerLastActivationTime=-1.0000000
}