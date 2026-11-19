class animscripts_cover_stand extends Object within HodAI;

function main(optional bool newThread = false)
{
	run (new(self) class'cover_stand_main', newThread);
}
