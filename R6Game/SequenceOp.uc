class SequenceOp extends SequenceObject
    abstract
    native
    hidecategories(Object);

struct SeqOpInputLink
{
    var string LinkDesc;
    var bool bHasImpulse;
    var bool bDisabled;
    var name LinkAction;
    var int DrawY;
    var bool bHidden;

    structdefaultproperties
    {
        LinkDesc=""
        bHasImpulse=false
        bDisabled=false
        LinkAction="None"
        DrawY=0
        bHidden=false
    }
};

struct SeqOpOutputInputLink
{
    var SequenceOp LinkedOp;
    var int InputLinkIdx;

    structdefaultproperties
    {
        LinkedOp=none
        InputLinkIdx=0
    }
};

struct SeqOpOutputLink
{
    var array<SeqOpOutputInputLink> Links;
    var string LinkDesc;
    var bool bHasImpulse;
    var bool bDisabled;
    var name LinkAction;
    var int DrawY;
    var bool bHidden;

    structdefaultproperties
    {
        Links=none
        LinkDesc=""
        bHasImpulse=false
        bDisabled=false
        LinkAction="None"
        DrawY=0
        bHidden=false
    }
};

struct SeqVarLink
{
    var class<SequenceVariable> ExpectedType;
    var array<SequenceVariable> LinkedVariables;
    var string LinkDesc;
    var name LinkVar;
    var name PropertyName;
    var bool bWriteable;
    var bool bHidden;
    var int MinVars;
    var int MaxVars;
    var int DrawX;
    var native const Pointer CachedProperty;

    structdefaultproperties
    {
        ExpectedType=Class'SequenceVariable'
        LinkedVariables=none
        LinkDesc=""
        LinkVar="None"
        PropertyName="None"
        bWriteable=false
        bHidden=false
        MinVars=1
        MaxVars=255
        DrawX=0
    }
};

struct SeqEventLink
{
    var class<SequenceEvent> ExpectedType;
    var array<SequenceEvent> LinkedEvents;
    var string LinkDesc;
    var int DrawX;
    var bool bHidden;

    structdefaultproperties
    {
        ExpectedType=Class'SequenceEvent'
        LinkedEvents=none
        LinkDesc=""
        DrawX=0
        bHidden=false
    }
};

var bool bActive;
var const bool bLatentExecution;
var array<SeqOpInputLink> InputLinks;
var array<SeqOpOutputLink> OutputLinks;
var array<SeqVarLink> VariableLinks;
var array<SeqEventLink> EventLinks;
var transient int ActivateCount;

// Export USequenceOp::execGetObjectVars(FFrame&, void* const)
native final function GetObjectVars(out array<Object> objVars, optional string inDesc);

// Export USequenceOp::execGetBoolVars(FFrame&, void* const)
native final function GetBoolVars(out array<byte> boolVars, optional string inDesc);

// Export USequenceOp::execLinkedVariables(FFrame&, void* const)
native final iterator function LinkedVariables(class<SequenceVariable> VarClass, out SequenceVariable OutVariable, optional string inDesc);

defaultproperties
{
    InputLinks[0]=(LinkDesc="In",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
}