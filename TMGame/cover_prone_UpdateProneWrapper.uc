class cover_prone_UpdateProneWrapper extends CoreTask within animscripts_cover_prone;

// parameter
var float time;

// output

// local

state main
{
Begin:
	UpdateProne('prone_aim_feet_45up', 'prone_aim_feet_45down', 1, time, 1);
}
