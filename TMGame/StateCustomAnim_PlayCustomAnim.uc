class StateCustomAnim_PlayCustomAnim extends CoreTask within HodAI_DoCustomAnim;

var int i;
var Actor lDirActor;

state main
{
Begin:
	endon ('killanimscript');
	endon (iState.action.Name);

	if (iState.action.bUseRootMotion)
		AnimMode('gravity');
	else
		AnimMode('none');

	lDirActor = iState.action.DirActor;
	if (Controller(lDirActor) != none)
		lDirActor = Controller(lDirActor).Pawn;
	if (lDirActor == none)
		OrientMode('face current');
	else
		OrientMode('face angle', VectorToAngles(lDirActor.Location - origin).yaw);

	i = 0;
	if (custom_slot[0].IsActive())
		i = 1;

	;
	custom_slot[i].bLooping = iState.action.bLooping;
	custom_slot[i].SetAnimName(iState.action.AnimName);
	SetFlaggedAnimKnobAllRestart('custom_anim', custom_slot[i].NodeName, 'body', 1.f, iState.action.BlendInTime, iState.action.Rate);

	if (iState.action.PlayMode == AnimPM_Duration)
	{
		animscripts_shared.DoNoteTracksForTime(iState.action.Duration, 'custom_anim');
	}
	else
	{
		animscripts_shared.DoNoteTracks('custom_anim');
	}

	switch (iState.action.end_pose)
	{
	case AnimEP_Stand: a.pose = 'stand'; break;
	case AnimEP_Crouch: a.pose = 'crouch'; break;
	case AnimEP_Prone: a.pose = 'prone'; break;
	default: break;
	}

	switch (iState.action.end_movement)
	{
	case AnimEM_Stop: a.movement = 'stop'; break;
	case AnimEM_Walk: a.movement = 'walk'; break;
	case AnimEM_Run: a.movement = 'run'; break;
	default: break;
	}
}
