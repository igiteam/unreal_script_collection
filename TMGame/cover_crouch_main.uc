class cover_crouch_main extends CoreTask within animscripts_cover_crouch;

state main
{
Begin:
	endon('killanimscript');
	
    trackScriptState('Cover Crouch Main', "code");
    animscripts_utility.initialize('cover_crouch');

	animscripts_cover_wall.cover_wall_think('crouch');
}
