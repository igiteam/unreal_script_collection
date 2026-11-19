class TurokAnimTransitionGraphItemAnim extends TurokAnimTransitionGraphItemInterrupt
    native
    hidecategories(Object,Interrupt,Object);

var(AngleOffset) float mAngleOffset;
var(Animation) name mAnimation;
var(Animation) byte mCurveType;
var(Animation) float mBlendInPercent;
var(Animation) float mStartPercent;
var(Animation) float mEndPercent;
var(Animation) float mRateScale;
var(Animation) bool mbTriggerNotifiesBeforeStartTime;
var(ContactPoint) bool mbHasContactPoint;
var(Mirror) bool mbMirror;
var private array mbIsCooked;
var(ContactProperties) float mContactRadius;
var(ContactProperties) name mContactLocator;
var private array mDuration;
var private array mRootMotion;
var private array mContactPoint;

defaultproperties
{
    mBlendInPercent=0.1000000
    mEndPercent=1.0000000
    mRateScale=1.0000000
    mbTriggerNotifiesBeforeStartTime=true
    mContactRadius=16.0000000
    mContactLocator="jt_Aux1_C"
    mOutputs=/* Array type was not detected. */
}