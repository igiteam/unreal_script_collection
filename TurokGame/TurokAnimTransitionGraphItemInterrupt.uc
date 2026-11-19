class TurokAnimTransitionGraphItemInterrupt extends TurokAnimTransitionGraphItem
    abstract
    native
    hidecategories(Object,Interrupt);

var(Interrupt) name mInterruptName;
var(Interrupt) float mAnimInterruptRangeBeginPercent;
var(Interrupt) float mAnimInterruptRangeEndPercent;
var(Interrupt) bool mbPreviewInterrupt;
var(Interrupt) float mPreviewInterruptPercent;
var transient bool mbInterrupt;

event bool GraphInterrupt(@NULL aiInterface, byte actorType)
{
    // End:0x39
    if(NotEqual_InterfaceInterface(TurokAnimInterfaceGraphEvents(aiInterface), TurokAnimInterfaceGraphEvents(none)))
    {
        return TurokAnimInterfaceGraphEvents(aiInterface).GraphInterrupt(self, actorType);
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    mAnimInterruptRangeEndPercent=1.0000000
    mPreviewInterruptPercent=0.5000000
}