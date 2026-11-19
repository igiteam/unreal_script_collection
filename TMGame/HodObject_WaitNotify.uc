class HodObject_WaitNotify extends CoreTask within HodObject;

// parameter
var float time;
var name note;

// output

// local

state main
{
Begin:
	wait (time);
	notify (note);
}
