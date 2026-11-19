class trans_PlayTransitionAnimationFunc extends CoreTask within animscripts_trans;

// parameter
var name itransAnim;
var name endPose;
var name endMovement;
var bool endAiming;
var name finalAnim;
var float rate;
var bool waitSetStatesEnabled;

// output

// local

state main
{
Begin:
	// Use a second thread to set the anim state halfway through the animation
	if (waitSetStatesEnabled)
		WaitSetStates(Getanimlength(itransAnim)/2.0, 'killtimerscript', endPose, true);

	// Play the anim
	// setflaggedanimknoball(notifyName, anim, rootAnim, goalWeight, goalTime, rate) 
	SetFlaggedAnimKnobAllRestart('transAnimDone2', itransAnim, 'body', 1, 0.2, rate);
	if (a.pose == '')
		pose = 'undefined';
	if (a.movement == '')
		movement = 'undefined';

	animscripts_shared.DoNoteTracks('transAnimDone2');

	// In case we finished earlier than we expected (eg the animation was already playing before we started), 
	// set the variables and kill the other thread.
	notify('killtimerscript');
	a.pose = endPose;
	notify(name("entered_pose" $ endPose));

	a.movement = endMovement;
	if (endAiming)
		a.alertness = 'aiming';
	else
		a.alertness = 'casual';

	if (finalAnim != '')
	{
		// setflaggedanimknoball(notifyName, anim, rootAnim, goalWeight, goalTime, rate) 
		SetAnimKnobAll(finalAnim, 'body', 1, 0.3, rate);	// Set the animation instantly
	}
}
