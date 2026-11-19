class pain_DoPainAnim extends CoreTask within animscripts_pain;

// parameter
var name iPainAnim;
// output

// local 

state main
{
Begin:
	setflaggedanimknob('painanim', SetCustomAnim(misc_modern, iPainAnim), 1, 0.3, 1);
	animscripts_shared.DoNoteTracks ('painanim');
}
