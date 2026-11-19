class trans_PlayTransitionAnimationThread_WithoutWaitSetStates extends CoreTask within animscripts_trans;

// parameter
var name itransAnim;
var name endPose;
var name endMovement;
var bool endAiming;
var name finalAnim;
var float rate;

// output

// local

state main
{
Begin:
	endon ('killanimscript'); // the threaded one needs this or it wont die
	endon (name("entered_pose" $ endPose));
	PlayTransitionAnimationFunc(itransAnim, endPose, endMovement, endAiming, finalAnim, rate, false);
}
