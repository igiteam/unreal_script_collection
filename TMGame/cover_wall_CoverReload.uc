class cover_wall_CoverReload extends BoolTask within animscripts_cover_wall;

state main
{
Begin:
	animscripts_combat_utility.Reload(2.0, animscripts_utility.animArray('reload')); // (reload no matter what)
	_return (true);
}
