class cover_behavior_IdleThread extends CoreTask within animscripts_cover_behavior;

// parameter
var CBCIdle iIdleCallBack;

// output

// local

state main
{
Begin:
	endon('killanimscript');
	iIdleCallBack.Execute();
}
