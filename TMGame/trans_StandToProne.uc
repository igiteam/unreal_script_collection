class trans_StandToProne extends CoreTask within animscripts_trans;

// parameter

// output

// local
var float lProneTime;

state main
{
Begin:
//	assertEX(self.a.pose == 'stand', 'SetPoseMovement::StandToProne '+self.a.pose);
//	// I'd like to be able to assert that I'm stopped at this point, but until I get a better solution for 
//	// guys who are walking and running, this is used for them too.
////	assertEX(self.a.movement == 'stop', 'SetPoseMovement::StandToProne '+self.a.movement);
	endon (name("entered_pose" $ "prone"));

	lProneTime = 1.0;//0.5; // was 1
	PlayTransitionAnimationThread_WithoutWaitSetStates('stand_2_prone_onehand', 'prone', 'stop', false, , lProneTime, true);
	
	waittillmatch ('transAnimDone2', name("anim_pose = crouch"));
	wait (0); // so that the one in donotetracks gets hit first
	// cause the next pose is prone
	setProneAnimNodes(-45, 45, 'prone_legs_down', 'exposed_aiming', 'prone_legs_up');
	animscripts_utility.EnterProneWrapper(lProneTime); // make code start lerping in the prone orientation to ground
	a.movement = 'stop';

	ProneLegsStraightTree(0.2);
	animscripts_cover_prone.UpdateProneWrapper(0.1);
	waittillmatch ('transAnimDone2', 'end');

//// TODO: Find out if the above lines give the same functionality as below (notably the UpdateProne bit)
////	self SetProneAnimNodes(-45, 45, 'prone_legsdown', 'prone_legsstraight', 'prone_legsup');
////	self EnterProne(1.0); // make code start lerping in the prone orientation to ground
////
////	ProneLegsStraightTree(0.2);
////	self setflaggedanimknob('animdone', 'stand2prone_onehand', 1, .2, 1);
////	self animscripts\cover_prone::UpdateProneWrapper(0.1);
////	self waittill ('animdone');
////	self.a.pose = 'prone';
}
