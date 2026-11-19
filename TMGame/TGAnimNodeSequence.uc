class TGAnimNodeSequence extends AnimNodeSequence
	implements(IAnimNode)
	native(TGAnim)
	hidecategories(Object);

var transient int Index;
var transient int Active;
var transient TGAnimNode Parent;
var transient int TickCount;
var transient float BaseRate;
var transient float myWeight;
var transient float myTargetWeight;
var transient float myBlendTimeToGo;
var() float RateModifier;

var transient name notify;
var transient name AnimName;

var(Debug) float debug_weight;
var(Debug) float debug_time;
var(Debug) float debug_rate;

var(Debug) bool debug_knob;
var(Debug) bool debug_all;
var(Debug) bool debug_limited;
var(Debug) bool debug_restart;
var(Debug) TGAnimNode debug_root;

var(Debug) bool debug_ISetAnim;
var(Debug) bool debug_IClearAnim;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function bool IsActive()
{
	if (myTargetWeight != 0 || myBlendTimeToGo > 0)
		return true;

	return myWeight > 0.001;
}

native function SetAnimName(name iSequenceName);

native function ISetAnim(float weight = 1.0, float time = 0.2, float r = 1.0);
native function ISetAnimKnob(float weight = 1.0, float time = 0.2, float r = 1.0);
native function ISetAnimKnobAll(TGAnimNode root, float weight = 1.0, float time = 0.2, float r = 1.0);
native function ISetAnimKnobAllLimited(TGAnimNode root, float weight = 1.0, float time = 0.2, float r = 1.0);
native function ISetAnimKnobAllLimitedRestart(TGAnimNode root, float weight = 1.0, float time = 0.2, float r = 1.0);
native function ISetAnimKnobAllRestart(TGAnimNode root, float weight = 1.0, float time = 0.2, float r = 1.0);
native function ISetAnimKnobLimited(float weight = 1.0, float time = 0.2, float r = 1.0);
native function ISetAnimKnobLimitedRestart(float weight = 1.0, float time = 0.2, float r = 1.0);
native function ISetAnimKnobRestart(float weight = 1.0, float time = 0.2, float r = 1.0);
native function ISetAnimLimited(float weight = 1.0, float time = 0.2, float r = 1.0);
native function ISetAnimLimitedRestart(float weight = 1.0, float time = 0.2, float r = 1.0);
native function ISetAnimRestart(float weight = 1.0, float time = 0.2, float r = 1.0);

native function ISetFlaggedAnim(name iNotify, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnob(name iNotify, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnobAll(name iNotify, TGAnimNode root, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnobAllLimited(name iNotify, TGAnimNode root, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnobAllLimitedRestart(name iNotify, TGAnimNode root, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnobAllRestart(name iNotify, TGAnimNode root, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnobLimited(name iNotify, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnobLimitedRestart(name iNotify, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnobRestart(name iNotify, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimLimited(name iNotify, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimLimitedRestart(name iNotify, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimRestart(name iNotify, float weight = 1.0, float time = 0.2, float iRate = 1.0);

native function IClearAnim(float time);
native function float IGetAnimTime();

native function float GetAnimLength();
native function vector GetMoveDelta(float iStartTime, float iEndTime);
native function float GetAngleDelta(float iStartTime, float iEndTime);
native function bool AnimHasNoteTrack(name noteTrack, optional float startTime = 0.f, optional float iendTime = 1.f);

function float IGetAnimLength()
{
	return GetAnimLength();
}

function vector IGetMoveDelta(float iStartTime, float iEndTime)
{
	return GetMoveDelta(iStartTime, iEndTime);
}

function float IGetAngleDelta(float iStartTime, float iEndTime)
{
	return GetAngleDelta(iStartTime, iEndTime);
}

function bool IAnimHasNoteTrack(name noteTrack, optional float startTime = 0.f, optional float iendTime = 1.f)
{
	return AnimHasNoteTrack(noteTrack, startTime, iendTime);
}

