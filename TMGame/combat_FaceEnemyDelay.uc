class combat_FaceEnemyDelay extends CoreTask within animscripts_combat;

// parameter
var float iDelay;

// output

// local

state main
{
Begin:
	endon('killanimscript');
	wait (iDelay);
	faceEnemyImmediately();
}
