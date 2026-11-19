class trans_ProneToCrouch extends CoreTask within animscripts_trans;

state main
{
Begin:
//	assertEX(self.a.pose == 'prone', 'SetPoseMovement::StandToCrouch '+self.a.pose);

	// Decide which idle animation to do
	animscripts_utility.randomizeIdleSet();

	OrientMode ('face current');	// We don't want to rotate arbitrarily until we've actually stood up.
	animscripts_utility.ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
	ProneLegsStraightTree(0.1);
	animscripts_cover_prone.UpdateProneWrapper(0.1);
	PlayTransitionAnimation(SetCustomAnim(exposed_modern, 'prone_2_crouch'), 'crouch', 'stop', true);

//// TODO: Find out if the above lines give the same functionality as below (notably the UpdateProne bit)
////	self exitprone(1.0); // make code stop lerping in the prone orientation to ground
////
////	ProneLegsStraightTree(0.1);
////	self setflaggedanimknob('animdone', %prone2crouch_straight, 1, .1, 1);
////	self animscripts\cover_prone::UpdateProneWrapper(0.1);
////	self waittill ('animdone');
////	self.a.pose = 'crouch';
}
