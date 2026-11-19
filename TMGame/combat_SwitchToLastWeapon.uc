class combat_SwitchToLastWeapon extends CoreTask within animscripts_combat;

// parameter
var name iSwapAnim;

// output

// local


state main
{
Begin:
	endon ('killanimscript');

	assert(lastWeapon != animscripts_utility.getAISidearmWeapon());
	assert(lastWeapon == animscripts_utility.getAIPrimaryWeapon() || lastWeapon == animscripts_utility.getAISecondaryWeapon());
	
	swapAnim = iSwapAnim;
	setFlaggedAnimKnobAllRestart('weapon swap', iSwapAnim, 'body', 1, 0.1, 1);
	DoNoteTracksPostCallbackWithEndon('weapon swap', NoteTracksPostCallback_HandlePutaway, 'end_weapon_swap');
	setAnim(swapAnim, 0);
	
	maps__gameskill.didSomethingOtherThanShooting();
}
