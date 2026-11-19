class trans_CrouchRunToProne extends CoreTask within animscripts_trans;

// parameter

// output

// local
var float lProneTime;
var name lRunDirection;
var name lDiveAnim;
var vector lLocalDeltaVector;
var vector lEndPoint;

state main
{
Begin:
//	assertEX((self.a.pose == 'crouch')||(self.a.pose == 'stand'), 'SetPoseMovement::CrouchRunToProne '+self.a.pose);
//	assertEX((self.a.movement == 'run'||self.a.movement == 'walk'), 'SetPoseMovement::CrouchRunToProne '+self.a.movement);
	
	lProneTime = 1.0;//0.5; // was 1
	setProneAnimNodes(-45, 45, 'prone_legs_down', 'exposed_aiming', 'prone_legs_up');
	animscripts_utility.EnterProneWrapper(lProneTime); // make code start lerping in the prone orientation to ground

	ProneLegsStraightTree(0.2);
	animscripts_cover_prone.UpdateProneWrapper(0.1);

	lRunDirection = animscripts_utility.getQuadrant(getMotionAngle());
	
	lDiveAnim = SetCustomAnim(exposed_modern, 'crouch_2_prone');
	
	lLocalDeltaVector = GetMoveDelta (lDiveAnim, 0, 1);
	lEndPoint = LocalToWorldCoords(lLocalDeltaVector);
	if (maymovetopoint(lEndPoint))
	{
		PlayTransitionAnimation(lDiveAnim, 'prone', 'stop', , ,lProneTime);
	}
	else
	{
		//thread [[anim.println]]('Can't dive to prone.');#/
		PlayTransitionAnimation(SetCustomAnim(exposed_modern, 'crouch_2_prone_nodelta'), 'prone', 'stop', , , lProneTime);
	}
}
