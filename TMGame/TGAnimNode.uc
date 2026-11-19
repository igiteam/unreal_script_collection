class TGAnimNode extends AnimNodeBlendBase
	implements(IAnimNode)
	native(TGAnim)
	hidecategories(Object)
	abstract;

struct native ChildInfo
{
	var float TargetWeight;
	var float BlendTimeToGo;
};

var transient array<ChildInfo> ChildrenInfo;
/** Array of target weights for each child. Size must be the same as the Children array. */
var	transient array<float>		TargetWeight;

/** How long before current blend is complete (ie. active child reaches 100%) */
var	transient float				BlendTimeToGo;

/** Child currently active - that is, at or ramping up to 100%. */
var	transient INT					ActiveChildIndex;

/** Call play anim when active child is changed */
var() bool	bPlayActiveChild;

/**
 * If TRUE (Default), then when the node becomes relevant, the Active Child will be forced to full weight.
 * This is a general optimization, as multiple nodes tend to change state at the same time, this will
 * reduce the maximum number of blends and animation decompression done at the same time.
 * Setting it to FALSE, will let the node interpolate animation normally.
 */
var() bool	bForceChildFullWeightWhenBecomingRelevant;

/**
 * if TRUE, do not blend when the Skeletal Mesh is not visible.
 * Optimization to save on blending time when meshes are not rendered.
 * Instant switch instead.
 */
var() bool	bSkipBlendWhenNotRendered;

/** slider position, for animtree editor */
var const	float	SliderPosition;

var transient int Index;
var transient int Active;
var transient TGAnimNode Parent;
var transient int TickCount;
var transient float Rate;
var transient float myWeight;
var transient float myTargetWeight;
var transient float myBlendTimeToGo;

struct native ActiveList
{
	var array<int> Data;
};

var transient ActiveList active_list[2];
var transient int active_general_leaf;

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
// (cpptext)

native function ISetAnim(float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetAnimKnob(float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetAnimKnobAll(TGAnimNode root, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetAnimKnobAllLimited(TGAnimNode root, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetAnimKnobAllLimitedRestart(TGAnimNode root, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetAnimKnobAllRestart(TGAnimNode root, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetAnimKnobLimited(float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetAnimKnobLimitedRestart(float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetAnimKnobRestart(float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetAnimLimited(float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetAnimLimitedRestart(float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetAnimRestart(float weight = 1.0, float time = 0.2, float iRate = 1.0);

native function ISetFlaggedAnim(name notify, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnob(name notify, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnobAll(name notify, TGAnimNode root, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnobAllLimited(name notify, TGAnimNode root, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnobAllLimitedRestart(name notify, TGAnimNode root, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnobAllRestart(name notify, TGAnimNode root, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnobLimited(name notify, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnobLimitedRestart(name notify, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimKnobRestart(name notify, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimLimited(name notify, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimLimitedRestart(name notify, float weight = 1.0, float time = 0.2, float iRate = 1.0);
native function ISetFlaggedAnimRestart(name notify, float weight = 1.0, float time = 0.2, float iRate = 1.0);

native function IClearAnim(float time);
native function float IGetAnimTime();

function float IGetAnimLength()
{
	assert (false);
	return 0;
}

function vector IGetMoveDelta(float startTime, float endTime)
{
	return vect(0, 0, 0);
}

function float IGetAngleDelta(float startTime, float endTime)
{
	return 0;
}

function bool IAnimHasNoteTrack(name noteTrace, optional float startTime = 0.f, optional float endTime = 1.f)
{
	assert (false);
	return false;
}

