class corner_CornerReload extends BoolTask within animscripts_corner;

// parameter
var name lReloadAnim;

state main
{
Begin:
	assert(animscripts_utility.animArrayAnyExist('reload'));
	
	lReloadAnim = SetCustomAnim(misc_modern, animscripts_utility.animArrayPickRandom('reload'));
	setFlaggedAnimKnobRestart('cornerReload', lReloadAnim, 1, 0.2);
	
	animscripts_shared.DoNoteTracks('cornerReload');
	
	animscripts_weaponList.RefillClip();
	
	setAnimRestart(SetCustomAnim(misc_modern, animscripts_utility.animarray('hide_idle')), 1, 0.2);
	clearAnim(lReloadAnim, 0.2);
	
	_return (true);
}
