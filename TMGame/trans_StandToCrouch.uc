class trans_StandToCrouch extends CoreTask within animscripts_trans;

// parameter

// output

// local
var float lCrouchSpeed;

state main
{
Begin:
//	assertEX(self.a.pose == 'stand', 'SetPoseMovement::StandToCrouch '+self.a.pose);
//	assertEX(self.a.movement == 'stop', 'SetPoseMovement::StandToCrouch '+self.a.movement);
	
	// Decide which idle animation to do
	animscripts_utility.randomizeIdleSet();
	
	lCrouchSpeed = 1;
	if (fastCrouch)
	{
		lCrouchSpeed = 1.8;
		fastCrouch = false;
	}
	
	//PlayTransitionAnimation(transAnim, endPose, endMovement, endAiming, finalAnim)
	PlayTransitionAnimation(SetCustomAnim(exposed_modern, 'stand_2_crouch'), 'crouch', 'stop', false, '', lCrouchSpeed);
	
//	self clearanim('shoot', 0);	// This stops the stand aiming residue from showing up when we crouch aim.
}
