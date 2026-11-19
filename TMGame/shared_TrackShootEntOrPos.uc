class shared_TrackShootEntOrPos extends CoreTask within animscripts_shared;

state main
{
Begin:
	endon('killanimscript');
	endon('stop tracking');
	endon('melee');

	trackLoop('aim_2', 'aim_4', 'aim_6', 'aim_8');
}
