class cover_stand_main extends CoreTask within animscripts_cover_stand;

state main
{
Begin:
	endon('killanimscript');
	
//	[[ self.exception[ 'cover_stand' ] ]]();
	
    trackScriptState('Cover Stand Main', "code");
    animscripts_utility.initialize('cover_stand');

	animscripts_cover_wall.cover_wall_think('stand');
}
