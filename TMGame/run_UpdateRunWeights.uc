class run_UpdateRunWeights extends CoreTask within animscripts_run;

// parameter
var name notifyString;
var name frontAnim;
var name backAnim;
var name leftAnim;
var name rightAnim;

// output

// local

state main
{
Begin:
	endon('killanimscript');
	endon(notifyString);
	
	if (gettime() == a.scriptStartTime)
	{
		// our motion angle might change very quickly as we start to run, so reset the anim weights after one frame
		UpdateRunWeightsOnce(frontAnim, backAnim, leftAnim, rightAnim);
		wait(0.05);
	}
	
	while (true)
	{
		UpdateRunWeightsOnce(frontAnim, backAnim, leftAnim, rightAnim);
		wait(0.2);
	}
}
