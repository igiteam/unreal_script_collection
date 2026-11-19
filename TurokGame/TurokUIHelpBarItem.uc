class TurokUIHelpBarItem extends Object
    native;

var @NULL mLabel;
var @NULL mIcon;
var private float mFadeTime;
var private float mCurrentFade;
var private int mFadeDir;
var private bool mIsHidden;
var private bool mIsDimmed;
var private bool mIsButtonSet;

// Export UTurokUIHelpBarItem::execShow(FFrame&, void* const)
native function Show(optional bool bImmediately);

// Export UTurokUIHelpBarItem::execHide(FFrame&, void* const)
native function Hide(optional bool bImmediately);

// Export UTurokUIHelpBarItem::execDim(FFrame&, void* const)
native function Dim();

// Export UTurokUIHelpBarItem::execUnDim(FFrame&, void* const)
native function UnDim();

// Export UTurokUIHelpBarItem::execTick(FFrame&, void* const)
native function Tick(float elapsed);

defaultproperties
{
    mFadeTime=0.2500000
    mFadeDir=1
}