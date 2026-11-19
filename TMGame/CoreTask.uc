class CoreTask extends Object
	native(Core);

var const CoreThread OwnerThread;
var const bool IsFinished;
var const bool InLatent;

struct native EndonElement
{
	var CoreObject obj;
	var name note;
};

var const array<EndonElement> EndonList;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native latent function wait(float seconds);
native latent function _return(optional bool has_output = false);

final event _OnReturn(CoreTask task)
{
	OnReturn(task);
}

function OnReturn(CoreTask task);

final event _OnNotify(name note, CoreNotify data)
{
	OnNotify(note, data);
}

function OnNotify(name note, CoreNotify data);

final event _OnEndon(name note)
{
	OnEndon(note);
}

function OnEndon(name note);

final event _EnterPoint()
{
	EnterPoint();
}

function EnterPoint()
{
	GotoState('main');
}

state main
{
Begin:
}

function Dump()
{
	;
}
