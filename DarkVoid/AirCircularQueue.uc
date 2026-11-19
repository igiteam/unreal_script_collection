class AirCircularQueue extends Object;

struct QueueItem
{
};

var transient int QueueSize;
var transient int SubmitIndex;
var transient int SubmitCount;
var transient array<Object> Items;

function Init(Class Type, int queuelength)
{
    local int I;

    QueueSize = queuelength;
    I = 0;
    J0x12:

    // End:0x45 [Loop If]
    if(I < QueueSize)
    {
        Items[I] = new (Outer) Type;
        I++;
        // [Loop Continue]
        goto J0x12;
    }
    //return;    
}

function Object Presubmit()
{
    return Items[SubmitIndex];
    //return ReturnValue;    
}

function Submit()
{
    SubmitIndex++;
    // End:0x1D
    if(SubmitIndex >= QueueSize)
    {
        SubmitIndex = 0;
    }
    SubmitCount++;
    //return;    
}

function Object Retrieve(int Index)
{
    local int realindex;

    // End:0x11
    if(Index >= QueueSize)
    {
        return none;
    }
    // End:0x22
    if(Index >= SubmitCount)
    {
        return none;
    }
    realindex = (SubmitIndex - 1) - Index;
    // End:0x4E
    if(realindex < 0)
    {
        realindex += QueueSize;
    }
    return Items[realindex];
    //return ReturnValue;    
}

function Reset()
{
    SubmitCount = 0;
    SubmitIndex = 0;
    //return;    
}
