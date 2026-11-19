class corner_Flinch extends BoolTask within animscripts_corner;

state main
{
Begin:
	if (!animscripts_utility.animArrayAnyExist('hide_idle_flinch'))
		_return (false);
	
	playIdleAnimation(SetCustomAnim(misc_modern, animscripts_utility.animArrayPickRandom('hide_idle_flinch')), true);
	
	_return (true);
}
