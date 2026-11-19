class trans_ProneToCrouchRun extends CoreTask within animscripts_trans;

state main
{
Begin:
	assert(a.pose == 'prone');

	OrientMode('face current');	// We don't want to rotate arbitrarily until we've actually stood up.
	animscripts_utility.ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
	ProneLegsStraightTree(0.2);
	animscripts_cover_prone.UpdateProneWrapper(0.1);
	PlayTransitionAnimation('prone_2_crouch_run', 'crouch', 'run', false, 'crouch_walk_F');
}
