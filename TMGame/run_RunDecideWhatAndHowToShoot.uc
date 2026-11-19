class run_RunDecideWhatAndHowToShoot extends CoreTask within animscripts_run;

state main
{
Begin:
	endon('killanimscript');
	endon('end_shoot_while_moving');
	animscripts_shoot_behavior.decideWhatAndHowToShoot('normal');
}
