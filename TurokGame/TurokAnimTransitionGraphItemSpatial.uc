class TurokAnimTransitionGraphItemSpatial extends TurokAnimTransitionGraphItemInterrupt
    native
    hidecategories(Object,Interrupt,Object);

var(AngleOffset) float mAngleOffset;
var(Animation) @NULL mSpatialAsset;
var(Animation) byte mCurveType;
var(Animation) float mBlendInPercent;
var(Animation) float mStartPercent;
var(Animation) float mEndPercent;
var(Animation) float mRateScale;
var(Animation) bool mbTriggerNotifiesBeforeStartTime;
var(ContactProperties) float mContactRadius;

event @NULL OnGraphSpatialTarget(@NULL playbackInterface)
{
    // End:0x33
    if(NotEqual_InterfaceInterface(TurokAnimInterfaceGraphPlayback(playbackInterface), TurokAnimInterfaceGraphPlayback(none)))
    {
        return TurokAnimInterfaceGraphPlayback(playbackInterface).OnGraphSpatialTarget();
    }
    return vect(0.0000000, 0.0000000, 0.0000000);
    //return ReturnValue;    
}

defaultproperties
{
    mBlendInPercent=0.1000000
    mEndPercent=1.0000000
    mRateScale=1.0000000
    mbTriggerNotifiesBeforeStartTime=true
    mContactRadius=16.0000000
    mOutputs=/* Array type was not detected. */
}