class EvilAIReactManager extends Object within EvilAIController;

struct IntristicChannel
{
    var name ChannelName;
    var class<EvilAIReactChannel> ChannelClass;

    structdefaultproperties
    {
        ChannelName="None"
        ChannelClass=none
    }
};

var array<EvilAIReactChannel> Channels;
var array<IntristicChannel> IntrinsicChannels;
var array<EvilAIReactChannel> PollChannels;
var array<EvilAIReactChannel> BasicPerceptionChannels;
var class<EvilAIReactChannel> DefaultChannelClass;
var bool bAllReactionsSuppressed;

function Initialize()
{
    local EvilAIReactCondition ReactCondition;
    local class<EvilAIReactCondition> ReactConditionClass;

    // End:0x4C
    foreach Outer.DefaultReactConditions(ReactCondition)
    {
        ReactCondition.Initialize();        
    }    
    // End:0xB9
    foreach Outer.DefaultReactConditionClasses(ReactConditionClass)
    {
        ReactCondition = new (Outer) ReactConditionClass;
        ReactCondition.Initialize();        
    }    
    //return;    
}

function Wipe()
{
    local EvilAIReactChannel ReactChannel;
    local EvilAIReactCondition ReactCondition;

    // End:0x6E
    foreach Channels(ReactChannel)
    {
        // End:0x6C
        foreach ReactChannel.Reactions(ReactCondition)
        {
            ReactChannel.UnSubscribe(ReactCondition);            
        }                
    }    
    PollChannels.Remove(0, PollChannels.Length);
    Channels.Remove(0, Channels.Length);
    //return;    
}

function SuppressAllReactions()
{
    local EvilAIReactChannel ReactChannel;
    local EvilAIReactCondition ReactCondition;

    // End:0x65
    foreach Channels(ReactChannel)
    {
        // End:0x63
        foreach ReactChannel.Reactions(ReactCondition)
        {
            ReactCondition.Suppress();            
        }                
    }    
    //return;    
}

function BehaviorModeChanged(EvilTypes.EBehaviorMode InNewMode, EvilTypes.EBehaviorMode InOldMode)
{
    local EvilAIReactChannel ReactChannel;
    local EvilAIReactCondition ReactCondition;
    local EvilTypes.EBehaviorMode BehaviorMode;
    local bool bShouldSuppress, bShouldUnSuppress;

    // End:0x135
    foreach Channels(ReactChannel)
    {
        // End:0x133
        foreach ReactChannel.Reactions(ReactCondition)
        {
            bShouldSuppress = false;
            bShouldUnSuppress = false;
            // End:0xD6
            foreach ReactCondition.SuppressingBehaviors(BehaviorMode)
            {
                // End:0xAE
                if(int(InNewMode) == int(BehaviorMode))
                {
                    bShouldSuppress = true;
                }
                // End:0xD5
                if(int(InOldMode) == int(BehaviorMode))
                {
                    bShouldUnSuppress = true;
                }                
            }            
            // End:0x106
            if(bShouldSuppress)
            {
                ReactCondition.Suppress();                
            }
            else
            {
                // End:0x132
                if(bShouldUnSuppress)
                {
                    ReactCondition.UnSuppress();
                }
            }            
        }                
    }    
    //return;    
}

function UnSuppressAllReactions()
{
    local EvilAIReactChannel ReactChannel;
    local EvilAIReactCondition ReactCondition;

    // End:0x65
    foreach Channels(ReactChannel)
    {
        // End:0x63
        foreach ReactChannel.Reactions(ReactCondition)
        {
            ReactCondition.UnSuppress();            
        }                
    }    
    //return;    
}

function SuppressReactionByType(class<EvilAIReactCondition> _ReactCondition, optional name ChannelName = 'None')
{
    local EvilAIReactChannel ReactChannel;
    local EvilAIReactCondition ReactCondition;

    // End:0x9E
    foreach Channels(ReactChannel)
    {
        // End:0x9C
        foreach ReactChannel.Reactions(ReactCondition)
        {
            // End:0x9B
            if(ReactCondition.Class == _ReactCondition)
            {
                ReactCondition.Suppress();
            }            
        }                
    }    
    //return;    
}

function UnSuppressReactionByType(class<EvilAIReactCondition> _ReactCondition)
{
    local EvilAIReactChannel ReactChannel;
    local EvilAIReactCondition ReactCondition;

    // End:0x91
    foreach Channels(ReactChannel)
    {
        // End:0x8F
        foreach ReactChannel.Reactions(ReactCondition)
        {
            // End:0x8E
            if(ReactCondition.Class == _ReactCondition)
            {
                ReactCondition.UnSuppress();
            }            
        }                
    }    
    //return;    
}

function UnSubscribeReactionByType(class<EvilAIReactCondition> _ReactCondition)
{
    local EvilAIReactChannel ReactChannel;
    local EvilAIReactCondition ReactCondition;

    // End:0x9A
    foreach Channels(ReactChannel)
    {
        // End:0x98
        foreach ReactChannel.Reactions(ReactCondition)
        {
            // End:0x97
            if(ReactCondition.Class == _ReactCondition)
            {
                ReactChannel.UnSubscribe(ReactCondition);
            }            
        }                
    }    
    //return;    
}

function Poll(float DeltaTime)
{
    local EvilAIReactChannel Channel;

    // End:0x40
    foreach PollChannels(Channel)
    {
        Channel.Poll(DeltaTime);        
    }    
    //return;    
}

function Subscribe(EvilAIReactCondition Condition, name ChannelName, optional bool bAsUnblockingChannel = false)
{
    local EvilAIReactChannel FoundChan;

    FoundChan = GetChannelFor(ChannelName);
    // End:0xB3
    if(Condition != none)
    {
        // End:0x7E
        if(FoundChan == none)
        {
            FoundChan = new GetClassForChannelName(ChannelName);
            InitializeChannel(ChannelName, FoundChan);
        }
        FoundChan.Subscribe(Condition, bAsUnblockingChannel);        
    }
    //return;    
}

function UnSubscribe(EvilAIReactCondition Condition, name ChannelName)
{
    local EvilAIReactChannel FoundChan;

    FoundChan = GetChannelFor(ChannelName);
    // End:0x57
    if(FoundChan != none)
    {
        FoundChan.UnSubscribe(Condition);        
    }
    //return;    
}

function SuppressAllChannels()
{
    local EvilAIReactChannel Channel;

    // End:0x37
    foreach Channels(Channel)
    {
        Channel.Suppress();        
    }    
    //return;    
}

function UnSuppressAllChannels()
{
    local EvilAIReactChannel Channel;

    // End:0x37
    foreach Channels(Channel)
    {
        Channel.UnSuppress();        
    }    
    //return;    
}

function SuppressChannel(name ChannelName)
{
    local EvilAIReactChannel FoundChan;

    FoundChan = GetChannelFor(ChannelName);
    // End:0x4B
    if(FoundChan != none)
    {
        FoundChan.Suppress();
    }
    //return;    
}

function UnSuppressChannel(name ChannelName)
{
    local EvilAIReactChannel FoundChan;

    FoundChan = GetChannelFor(ChannelName);
    // End:0x4B
    if(FoundChan != none)
    {
        FoundChan.UnSuppress();
    }
    //return;    
}

function SuppressAll()
{
    bAllReactionsSuppressed = true;
    //return;    
}

function UnSuppressAll()
{
    bAllReactionsSuppressed = false;
    //return;    
}

function InitializeChannel(name ChannelName, EvilAIReactChannel ReactChannel)
{
    ReactChannel.Init(ChannelName);
    Channels.AddItem(ReactChannel);
    // End:0x76
    if(ReactChannel.bNeedsPoll)
    {
        PollChannels.AddItem(ReactChannel);
    }
    //return;    
}

function class<EvilAIReactChannel> GetClassForChannelName(name ChannelName)
{
    local IntristicChannel Channel;

    // End:0x60
    foreach IntrinsicChannels(Channel)
    {
        // End:0x5F
        if(Channel.ChannelName == ChannelName)
        {            
            return Channel.ChannelClass;
        }        
    }    
    return DefaultChannelClass;
    //return ReturnValue;    
}

function EvilAIReactChannel GetChannelFor(name ChannelName)
{
    local EvilAIReactChannel Channel;

    // End:0x4F
    foreach Channels(Channel)
    {
        // End:0x4E
        if(Channel.ChannelName == ChannelName)
        {            
            return Channel;
        }        
    }    
    return none;
    //return ReturnValue;    
}

function name GetNameForPerception(EvilAIController.EPerceptionType InPT)
{
    switch(InPT)
    {
        // End:0x22
        case 4:
            return 'SightPlayer';
        // End:0x31
        case 0:
            return 'Sight';
        // End:0x40
        case 1:
            return 'Hearing';
        // End:0x45
        case 2:
        // End:0x54
        case 3:
            return 'Force';
        // End:0xFFFF
        default:
            return 'Unknown';
            break;
    }
    //return ReturnValue;    
}

function NudgeChannel(Actor InInstigator, name ChannelName)
{
    local EvilAIReactChannel FoundChan;

    // End:0x63
    if(!bAllReactionsSuppressed)
    {
        FoundChan = GetChannelFor(ChannelName);
        // End:0x63
        if(FoundChan != none)
        {
            FoundChan.NudgeChannel(InInstigator);
        }
    }
    //return;    
}

function NudgePerceptionChannel(Actor InInstigator, EvilAIController.EPerceptionType Pt)
{
    local EvilAIReactChannel FoundChan;

    // End:0x127
    if(!bAllReactionsSuppressed)
    {
        // End:0x68
        if((int(Pt) < BasicPerceptionChannels.Length) && BasicPerceptionChannels[int(Pt)] != none)
        {
            FoundChan = BasicPerceptionChannels[int(Pt)];            
        }
        else
        {
            FoundChan = GetChannelFor(GetNameForPerception(Pt));
            // End:0xD1
            if(BasicPerceptionChannels.Length <= int(Pt))
            {
                BasicPerceptionChannels.Add((int(Pt) + int(1)) - BasicPerceptionChannels.Length);
            }
            BasicPerceptionChannels[int(Pt)] = FoundChan;
        }
        // End:0x127
        if(FoundChan != none)
        {
            FoundChan.NudgeChannel(InInstigator);
        }
    }
    //return;    
}

function IncomingDamage(Pawn DamageInstigator, bool bDirectDamage, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Vector LastInstigatorLoc, optional int DamageAmt, optional name ChannelName = 'Damage')
{
    local EvilAIReactChan_Damage DamageChannel;

    DamageChannel = EvilAIReactChan_Damage(GetChannelFor(ChannelName));
    // End:0x155
    if(DamageChannel != none)
    {
        DamageChannel.DamageInstigator = DamageInstigator;
        DamageChannel.bDirectDamage = bDirectDamage;
        DamageChannel.DamageType = DamageType;
        DamageChannel.HitInfo = HitInfo;
        DamageChannel.LastInstigatorLoc = LastInstigatorLoc;
        DamageChannel.DamageAmt = float(DamageAmt);
        NudgeChannel(DamageInstigator, ChannelName);
    }
    //return;    
}

defaultproperties
{
    IntrinsicChannels[0]=(ChannelName="Damage",ChannelClass=Class'EvilAIReactChan_Damage')
    IntrinsicChannels[1]=(ChannelName="Timer",ChannelClass=Class'EvilAIReactChan_Timer')
    DefaultChannelClass=Class'EvilAIReactChannel'
}