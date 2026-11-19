interface IAnimNode
	native(TGAnim);

enum TGAnimNodeType
{
	TGANT_General,
	TGANT_Additive,
};

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

native function ISetAnim(float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetAnimKnob(float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetAnimKnobAll(TGAnimNode root, float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetAnimKnobAllLimited(TGAnimNode root, float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetAnimKnobAllLimitedRestart(TGAnimNode root, float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetAnimKnobAllRestart(TGAnimNode root, float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetAnimKnobLimited(float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetAnimKnobLimitedRestart(float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetAnimKnobRestart(float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetAnimLimited(float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetAnimLimitedRestart(float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetAnimRestart(float weight = 1.0, float time = 0.2, float rate = 1.0);

native function ISetFlaggedAnim(name notify, float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetFlaggedAnimKnob(name notify, float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetFlaggedAnimKnobAll(name notify, TGAnimNode root, float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetFlaggedAnimKnobAllLimited(name notify, TGAnimNode root, float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetFlaggedAnimKnobAllLimitedRestart(name notify, TGAnimNode root, float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetFlaggedAnimKnobAllRestart(name notify, TGAnimNode root, float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetFlaggedAnimKnobLimited(name notify, float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetFlaggedAnimKnobLimitedRestart(name notify, float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetFlaggedAnimKnobRestart(name notify, float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetFlaggedAnimLimited(name notify, float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetFlaggedAnimLimitedRestart(name notify, float weight = 1.0, float time = 0.2, float rate = 1.0);
native function ISetFlaggedAnimRestart(name notify, float weight = 1.0, float time = 0.2, float rate = 1.0);

native function IClearAnim(float time);
native function float IGetAnimTime();

function float IGetAnimLength();
function vector IGetMoveDelta(float startTime, float endTime);
function float IGetAngleDelta(float startTime, float endTime);
function bool IAnimHasNoteTrack(name noteTrace, optional float startTime = 0.f, optional float endTime = 1.f);
