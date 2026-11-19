class combat_DoTurnNotetracks extends CoreTask within animscripts_combat;

state main
{
Begin:
	endon('turning_isnt_working');
	endon('can_stop_turning');
	
	makeSureTurnWorks(true);
	animscripts_shared.DoNoteTracks('turn');
}
