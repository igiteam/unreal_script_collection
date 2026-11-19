class TurokAnimTransitionGraphItemBlend extends TurokAnimTransitionGraphItemInterrupt
    native
    hidecategories(Object,Interrupt,Object);

var(AngleOffset) float mAngleOffset;
var(Animation) float mBlendInPercent;
var(Animation) byte mCurveType;
var(Animation) float mRateScale;
var(ParitalBlend) bool mbComponentSpaceBlend;
var(PartialBlend) bool mbDontBlendStartBone;
var(ParitalBlend) name mBlendStartBone;
var(PartialBlend) float mIncreasePerBone;
var(blend) name mBlendName;
var(blend) float mChild2Weight;

event float GraphBlend(@NULL aiInterface)
{
    // End:0x34
    if(NotEqual_InterfaceInterface(TurokAnimInterfaceGraphEvents(aiInterface), TurokAnimInterfaceGraphEvents(none)))
    {
        return TurokAnimInterfaceGraphEvents(aiInterface).GraphBlend(self);
    }
    return mChild2Weight;
    //return ReturnValue;    
}

defaultproperties
{
    mBlendInPercent=0.1000000
    mRateScale=1.0000000
    mIncreasePerBone=1.0000000
    mOutputs=/* Array type was not detected. */
}