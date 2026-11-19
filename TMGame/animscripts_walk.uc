class animscripts_walk extends Object within HodAI
	dependson(animscripts_utility)
	dependson(general_human);

function MoveWalk(optional bool newThread = false)
{
	run (new(self) class'walk_MoveWalk', newThread);
}

function DoWalkAnim(name iWalkAnim, optional bool newThread = false)
{
	local walk_DoWalkAnim task;
	task = new(self) class'walk_DoWalkAnim';
	task.iWalkAnim = iWalkAnim;
	run (task, newThread);
}

function bool GetStandWalkAnim(out name oAnim, out float oRate)
{
	if ((isDefined(walk_combatanim)) && (animscripts_utility.IsInCombat()))
	{
		if ((randomint(10) < 2) && (isDefined(walk_combatanim2)))
		{
			oRate = animscripts_move.walk_combatanim2_rate;
			oAnim = walk_combatanim2;
			return true;
		}
		else
		{
			oRate = animscripts_move.walk_combatanim_rate;
			oAnim = walk_combatanim;
			return true;
		}
	}
	else if ((isDefined(walk_noncombatanim)) && (!animscripts_utility.IsInCombat()))
	{
		if ((randomint(10) < 2) && (isDefined(walk_noncombatanim2)))
		{
			oRate = animscripts_move.walk_noncombatanim2_rate;
			oAnim = walk_noncombatanim2;
			return true;
		}
		else
		{
			oRate = animscripts_move.walk_noncombatanim_rate;
			oAnim = walk_noncombatanim;
			return true;
		}
	}
	else
	{
		oRate = 1.f;
		oAnim = 'stand_walk_F';
		return false;
	}
}
