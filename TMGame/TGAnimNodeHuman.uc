class TGAnimNodeHuman extends TGAnimNodeRoot
	native(TGAnim)
	hidecategories(Object);


var transient init array<IAnimNode> anim_nodes;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function float TGetAnimLength(name node)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	return anim_nodes[HumanAnimID(node)].IGetAnimLength();
}

function vector TGetMoveDelta(name node, float startTime, float endTime)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	return anim_nodes[HumanAnimID(node)].IGetMoveDelta(startTime, endTime);
}

function float TGetAngleDelta(name node, float startTime, float endTime)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	return anim_nodes[HumanAnimID(node)].IGetAngleDelta(startTime, endTime);
}

function bool TAnimHasNoteTrack(name node, name note_track, optional float startTime = 0.f, optional float endTime = 1.f)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	return anim_nodes[HumanAnimID(node)].IAnimHasNoteTrack(note_track, startTime, endTime);
}

function float TGetAnimTime(name node)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	return anim_nodes[HumanAnimID(node)].IGetAnimTime();
}

function TSetAnim(name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetAnim(weight, time, iRate);
}

function TSetAnimKnob(name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetAnimKnob(weight, time, iRate);
}

function TSetAnimKnobAll(name node, name root, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(root) < anim_nodes.length);
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetAnimKnobAll(anim_nodes[HumanAnimID(root)], weight, time, iRate);
}

function TSetAnimKnobAllLimited(name node, name root, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(root) < anim_nodes.length);
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetAnimKnobAllLimited(anim_nodes[HumanAnimID(root)], weight, time, iRate);
}

function TSetAnimKnobAllLimitedRestart(name node, name root, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(root) < anim_nodes.length);
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetAnimKnobAllLimitedRestart(anim_nodes[HumanAnimID(root)], weight, time, iRate);
}

function TSetAnimKnobAllRestart(name node, name root, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(root) < anim_nodes.length);
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetAnimKnobAllRestart(anim_nodes[HumanAnimID(root)], weight, time, iRate);
}

function TSetAnimKnobLimited(name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetAnimKnobLimited(weight, time, iRate);
}

function TSetAnimKnobLimitedRestart(name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetAnimKnobLimitedRestart(weight, time, iRate);
}

function TSetAnimKnobRestart(name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetAnimKnobRestart(weight, time, iRate);
}

function TSetAnimLimited(name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetAnimLimited(weight, time, iRate);
}

function TSetAnimLimitedRestart(name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetAnimLimitedRestart(weight, time, iRate);
}

function TSetAnimRestart(name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetAnimRestart(weight, time, iRate);
}

function TSetFlaggedAnim(name notify, name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetFlaggedAnim(notify, weight, time, iRate);
}

function TSetFlaggedAnimKnob(name notify, name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetFlaggedAnimKnob(notify, weight, time, iRate);
}

function TSetFlaggedAnimKnobAll(name notify, name node, name root, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(root) < anim_nodes.length);
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetFlaggedAnimKnobAll(notify, anim_nodes[HumanAnimID(root)], weight, time, iRate);
}

function TSetFlaggedAnimKnobAllLimited(name notify, name node, name root, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(root) < anim_nodes.length);
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetFlaggedAnimKnobAllLimited(notify, anim_nodes[HumanAnimID(root)], weight, time, iRate);
}

function TSetFlaggedAnimKnobAllLimitedRestart(name notify, name node, name root, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(root) < anim_nodes.length);
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetFlaggedAnimKnobAllLimitedRestart(notify, anim_nodes[HumanAnimID(root)], weight, time, iRate);
}

function TSetFlaggedAnimKnobAllRestart(name notify, name node, name root, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(root) < anim_nodes.length);
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetFlaggedAnimKnobAllRestart(notify, anim_nodes[HumanAnimID(root)], weight, time, iRate);
}

function TSetFlaggedAnimKnobLimited(name notify, name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetFlaggedAnimKnobLimited(notify, weight, time, iRate);
}

function TSetFlaggedAnimKnobLimitedRestart(name notify, name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetFlaggedAnimKnobLimitedRestart(notify, weight, time, iRate);
}

function TSetFlaggedAnimKnobRestart(name notify, name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetFlaggedAnimKnobRestart(notify, weight, time, iRate);
}

function TSetFlaggedAnimLimited(name notify, name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetFlaggedAnimLimited(notify, weight, time, iRate);
}

function TSetFlaggedAnimLimitedRestart(name notify, name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetFlaggedAnimLimitedRestart(notify, weight, time, iRate);
}

function TSetFlaggedAnimRestart(name notify, name node, float weight = 1.0, float time = 0.2, float iRate = 1.0)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].ISetFlaggedAnimRestart(notify, weight, time, iRate);
}

function TClearAnim(name node, float time)
{
	assert(HumanAnimID(node) < anim_nodes.length);
	assert(anim_nodes[HumanAnimID(node)] != none);
	anim_nodes[HumanAnimID(node)].IClearAnim(time);
}

event RegisterNode(AnimNode node, optional name iName)
{
	local int id;

	//if (anim_nodes.length == 0)
	//	anim_nodes.Add(HumanAnimID(''));

	if (iName == '')
		iName = node.NodeName;
	id = HumanAnimID(iName, true);
	if (id >= anim_nodes.length)
	{
		anim_nodes.Add(id - anim_nodes.length + 1);
	}

	anim_nodes[id] = IAnimNode(node);
}

native function int HumanAnimID(name n, optional bool newID = false);

