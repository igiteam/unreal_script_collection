class AIBroadcastManager extends Object;

struct StimulusData
{
    var() Pawn Instigator;
    var() Pawn BroadcastInstigator;
    var() EvilAIController Receiver;
    var() EvilTypes.EPerceptionType PerceptionType;
    var() name EventName;
    var() float TimeoutTime;

    structdefaultproperties
    {
        Instigator=none
        BroadcastInstigator=none
        Receiver=none
        PerceptionType=EPerceptionType.PT_Sight
        EventName="None"
        TimeoutTime=0.0000000
    }
};

var() bool bShouldBeEnabled;
var() const bool bDebug;
var() const float UpdateInterval;
var array<StimulusData> StimulusQueue;
var() const int MaxStimulusQueueLength;
var() const int MaxSendedStimulusesInUpdate;
var array<StimulusData> SendedStimulusQueue;
var int MergedStimuluses;
var int TimeoutedStimuluses;
var int DiscardedStimuluses;
var int MaxStimulusQueueUsedLength;
var Actor CachedOwner;

function Activate(Actor Owner)
{
    CachedOwner = Owner;
    // End:0x4E
    if(CachedOwner != none)
    {
        CachedOwner.SetTimer(UpdateInterval, true, 'Update', self);
    }
    //return;    
}

function bool IsActive()
{
    return ((CachedOwner != none) && CachedOwner.IsTimerActive('Update', self)) && bShouldBeEnabled;
    //return ReturnValue;    
}

function bool AddToStimulusQueue(Pawn Instigator, Pawn BroadcastInstigator, EvilAIController Receiver, EvilTypes.EPerceptionType Pt, optional name EventName, optional float TimeoutDuration = 1.5000000)
{
    local StimulusData StimData;
    local int InsertIndex;
    local bool bResult;

    WriteStimulusData(StimData, Instigator, BroadcastInstigator, Receiver, Pt, EventName, TimeoutDuration);
    bResult = ShouldAddToSimulusQueue(StimData);
    InsertIndex = FindInsertIndexFor(StimData);
    // End:0xEC
    if(bResult)
    {
        // End:0xD1
        if(InsertIndex > -1)
        {
            StimulusQueue.InsertItem(InsertIndex, StimData);                        
        }
        else
        {
            // End:0xE9
            if(bDebug)
            {
                MergedStimuluses++;
            }
        }        
    }
    else
    {
        // End:0x176
        if(InsertIndex > -1)
        {
            // End:0x14F
            if(InsertIndex < StimulusQueue.Length)
            {
                StimulusQueue.InsertItem(InsertIndex, StimData);                
                StimulusQueue.Remove(StimulusQueue.Length - 1, 1);                
            }
            // End:0x167
            if(bDebug)
            {
                DiscardedStimuluses++;
            }
            bResult = true;            
        }
        else
        {
            bResult = true;
            // End:0x19A
            if(bDebug)
            {
                MergedStimuluses++;
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

function int FindInsertIndexFor(const out StimulusData StimData, optional bool bMergeWithSendedQueue = true)
{
    local int Index, InsertIndex;

    // End:0x23
    if(StimulusQueue.Length <= 0)
    {
        InsertIndex = 0;        
    }
    else
    {
        InsertIndex = 0;
        Index = StimulusQueue.Length - 1;
        J0x45:

        // End:0xF3 [Loop If]
        if(Index >= 0)
        {
            // End:0x8E
            if(CompareForRedundantData(StimData, StimulusQueue, Index))
            {
                InsertIndex = -1;
                // [Explicit Break]
                goto J0xF3;
            }
            // End:0xE5
            if((InsertIndex < Index) && (ShouldBroadcastFirst(StimData, StimulusQueue, Index)) >= 0)
            {
                InsertIndex = Index;
            }
            Index--;
            // [Loop Continue]
            goto J0x45;
        }
        J0xF3:

        // End:0x192
        if(((InsertIndex > -1) && bMergeWithSendedQueue) && SendedStimulusQueue.Length > 0)
        {
            Index = 0;
            J0x132:

            // End:0x192 [Loop If]
            if(Index < SendedStimulusQueue.Length)
            {
                // End:0x184
                if(CompareForRedundantData(StimData, SendedStimulusQueue, Index))
                {
                    InsertIndex = -1;
                    // [Explicit Break]
                    goto J0x192;
                }
                Index++;
                // [Loop Continue]
                goto J0x132;
            }
        }
    }
    J0x192:

    return InsertIndex;
    //return ReturnValue;    
}

function bool ShouldAddToSimulusQueue(const out StimulusData StimData)
{
    return StimulusQueue.Length < MaxStimulusQueueLength;
    //return ReturnValue;    
}

function bool CompareForRedundantData(const out StimulusData FirstStimData, const out array<StimulusData> SecondStimDataList, const out int SecondStimDataIndex)
{
    return ((FirstStimData.Instigator == SecondStimDataList[SecondStimDataIndex].Instigator) && int(FirstStimData.PerceptionType) == int(SecondStimDataList[SecondStimDataIndex].PerceptionType)) && FirstStimData.Receiver == SecondStimDataList[SecondStimDataIndex].Receiver;
    //return ReturnValue;    
}

function bool WriteStimulusData(out StimulusData StimData, Pawn Instigator, Pawn BroadcastInstigator, EvilAIController Receiver, EvilTypes.EPerceptionType Pt, optional name EventName, optional float TimeoutDuration = 1.0000000)
{
    StimData.Instigator = Instigator;
    StimData.BroadcastInstigator = BroadcastInstigator;
    StimData.Receiver = Receiver;
    StimData.PerceptionType = Pt;
    StimData.EventName = EventName;
    StimData.TimeoutTime = Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds + TimeoutDuration;
    return true;
    //return ReturnValue;    
}

function int ShouldBroadcastFirst(const out StimulusData FirstStimData, const out array<StimulusData> SecondStimDataList, const out int SecondStimDataIndex)
{
    return Round(10.0000000 * (SecondStimDataList[SecondStimDataIndex].TimeoutTime - FirstStimData.TimeoutTime));
    //return ReturnValue;    
}

function Update()
{
    // End:0x17
    if(bShouldBeEnabled)
    {
        BroadcastStimulusQueue();
    }
    //return;    
}

function BroadcastStimulusQueue()
{
    local int Index;

    SendedStimulusQueue.Length = 0;
    // End:0x45
    if(bDebug)
    {
        // End:0x45
        if(StimulusQueue.Length > MaxStimulusQueueUsedLength)
        {
            MaxStimulusQueueUsedLength = StimulusQueue.Length;
        }
    }
    J0x45:

    // End:0x168 [Loop If]
    if((SendedStimulusQueue.Length < MaxSendedStimulusesInUpdate) && StimulusQueue.Length > 0)
    {
        Index = StimulusQueue.Length - 1;
        // End:0xFF
        if(CachedOwner.WorldInfo.TimeSeconds > StimulusQueue[Index].TimeoutTime)
        {
            // End:0xFC
            if(bDebug)
            {
                TimeoutedStimuluses++;
            }            
        }
        else
        {
            // End:0x12F
            if(!SendStimulusFromQueue(Index))
            {
                // End:0x12F
                if(bDebug)
                {
                    DiscardedStimuluses++;
                }
            }
        }
        SendedStimulusQueue.InsertItem(0, StimulusQueue[Index]);        
        StimulusQueue.Remove(Index, 1);        
        // [Loop Continue]
        goto J0x45;
    }
    //return;    
}

function bool SendStimulusFromQueue(int Index)
{
    local EvilAIController Receiver;
    local Pawn Instigator, BroadcastInstigator;
    local EvilTypes.EPerceptionType Pt;
    local name EventName;
    local bool bResult;

    // End:0x18C
    if((Index > -1) && Index < StimulusQueue.Length)
    {
        Receiver = StimulusQueue[Index].Receiver;
        Instigator = StimulusQueue[Index].Instigator;
        Pt = StimulusQueue[Index].PerceptionType;
        EventName = StimulusQueue[Index].EventName;
        BroadcastInstigator = StimulusQueue[Index].BroadcastInstigator;
        // End:0x18C
        if((Receiver != none) && Instigator != none)
        {
            Receiver.ReceiveStimulus(BroadcastInstigator, Instigator, Pt, EventName);
            bResult = true;
        }
    }
    return bResult;
    //return ReturnValue;    
}

defaultproperties
{
    bShouldBeEnabled=true
    UpdateInterval=0.2000000
    MaxStimulusQueueLength=50
    MaxSendedStimulusesInUpdate=4
}