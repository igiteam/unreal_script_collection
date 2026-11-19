class trans_CrouchToProne extends CoreTask within animscripts_trans;

state main
{
Begin:
//	assertEX(self.a.pose == 'crouch', 'SetPoseMovement::CrouchToProne '+self.a.pose);
//	// I'd like to be able to assert that I'm stopped at this point, but until I get a better solution for 
//	// guys who are walking and running, this is used for them too.
////	assertEX(self.a.movement == 'stop', 'SetPoseMovement::CrouchToProne '+self.a.movement);

	setProneAnimNodes(-45, 45, 'prone_legs_down', 'exposed_aiming', 'prone_legs_up');
	animscripts_utility.EnterProneWrapper(1.0); // make code start lerping in the prone orientation to ground

	ProneLegsStraightTree(0.3);
	animscripts_cover_prone.UpdateProneWrapper(0.1);
	PlayTransitionAnimation(SetCustomAnim(exposed_modern, 'crouch_2_prone'), 'prone', 'stop', true);

//// TODO: Find out if the above lines give the same functionality as below (notably the UpdateProne bit)
////	self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
////	self EnterProne(1.0); // make code start lerping in the prone orientation to ground
////
////	ProneLegsStraightTree(0.3);
////	self setflaggedanimknob('animdone', %crouch_2_prone, 1, .3, 1);
////	self animscripts\cover_prone::UpdateProneWrapper(0.1);
////	self waittill ('animdone');
////	self.a.pose = 'prone';
}
