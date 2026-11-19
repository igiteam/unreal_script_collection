class SPAnimBaseNode extends AnimNodeBlendList
    native;

struct native ChildEndEventMap
{
    /** Structure Declarations */
    var() int ChildIndex;
    /** Structure Declarations */
    var() name functionName;
    var bool endEventSent;

    structdefaultproperties
    {
        ChildIndex=0
        functionName="None"
        endEventSent=false
    }
};

var float m_desiredBlendTime;
var transient bool m_bBecameRelevantThisFrame;
var bool m_bPreventMultipleEndEvents;
var bool m_bChildEndedThisTick;
/** When a child ends, its end event will get sent only one time total. */
var() bool m_bSendSingleEventForChildEnd;
var transient bool m_bInitialized;
var transient bool m_bForceParentCaresAboutEndEvents;
/** array of events to send when specific children end */
var() export editinline array<export editinline ChildEndEventMap> m_childEvents;

function int GetChildIndexByName(name childName)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x47 [Loop If]
    if(I < Children.Length)
    {
        // End:0x3D
        if(childName == Children[I].Name)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}
