class corner_GoToCover extends CoreTask within animscripts_corner;

// parameter
var name iCoverAnim;
var float iTransTime;
var float iPlayTime;

// output

// local
var float lCornerAngle;
var vector lCornerOrigin;
var float lDesiredYaw;

state main
{
Begin:
	lCornerAngle = animscripts_utility.GetNodeDirection();
	lCornerOrigin = animscripts_utility.GetNodeOrigin();
	
	lDesiredYaw = lCornerAngle + hideyawoffset;

	OrientMode('face angle', lDesiredYaw);

	animMode ('none');
	
	assert(iTransTime <= iPlayTime);
	
	animscripts_shared.moveToOriginOverTime(lCornerOrigin, iTransTime, true);
	setFlaggedAnimKnobAllRestart('coveranim', iCoverAnim, 'body', 1, iTransTime);
	animscripts_shared.DoNoteTracksForTime(iPlayTime, 'coveranim');
	
	while (AbsAngleClamp180(angles.yaw - lDesiredYaw) > 1)
	{
		animscripts_shared.DoNoteTracksForTime(0.1, 'coveranim');
	}
	
	animMode ('zonly_physics');

	if(cornerDirection == 'left')
		a.special = 'cover_left';
	else
		a.special = 'cover_right';
}
