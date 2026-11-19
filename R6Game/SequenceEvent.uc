class SequenceEvent extends SequenceOp
    abstract
    native
    hidecategories(Object);

struct ActionsLinkedToUs
{
    var int m_ConnIdx;
    var SequenceAction m_SeqAction;

    structdefaultproperties
    {
        m_ConnIdx=0
        m_SeqAction=none
    }
};

var Actor Originator;
var transient Actor Instigator;
var transient float ActivationTime;
var transient int TriggerCount;
var() int MaxTriggerCount;
var() float ReTriggerDelay;
var() bool bEnabled;
var() bool bPlayerOnly;
var() bool bRainbowOnly;
var bool m_bDuplicatedEvent;
var() const bool bClientSideOnly;
var bool sbEnabled;
var(Register) bool bAlwaysActivated;
var(Register) bool bOnlyModifiedByToggling;
var() byte Priority;
var int MaxWidth;
var transient bool bRegistered;
var array<ActionsLinkedToUs> m_arrActionsLinkedToUs;

event bool IsAlwaysActivated()
{
    return bAlwaysActivated;
    return;
}

event RegisterEvent()
{
    return;
}

// Export USequenceEvent::execCheckActivate(FFrame&, void* const)
native function bool CheckActivate(Actor InOriginator, Actor InInstigator, optional bool bTest, const optional out array<int> ActivateIndices);

defaultproperties
{
    MaxTriggerCount=1
    bEnabled=true
    bPlayerOnly=true
    InputLinks=none
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjColor=(R=255,G=0,B=0,A=255)
}