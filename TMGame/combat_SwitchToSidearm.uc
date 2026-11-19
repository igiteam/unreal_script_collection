class combat_SwitchToSidearm extends CoreTask within animscripts_combat;

// parameter
var name iSwapAnim;

// output

// local

state main
{
Begin:
	endon ('killanimscript');
	assert(sidearm != '');
	
	animscripts_combat_utility.putGunBackInHandOnKillAnimScript(true);

	swapAnim = iSwapAnim;
	setFlaggedAnimKnobAllRestart('weapon swap', iSwapAnim, 'body', 1, 0.2, 1);
	DoNoteTracksPostCallbackWithEndon('weapon swap', NoteTracksPostCallback_HandlePickup, 'end_weapon_swap');
	setAnim(swapAnim, 0);
	
	maps__gameskill.didSomethingOtherThanShooting();
}
