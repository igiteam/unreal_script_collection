class CoreThread extends Object within CoreSystem
	native(Core);

var const CoreThread NextThread;
var const CoreThread PrevThread;

var const double WakeupTime;
var const bool IsActive;
var const init array<CoreTask> TaskList;

var const CoreObject WaitingObject;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native final function Run(CoreTask task);

function Dump()
{
	local int i;

	;

	for (i = 0; i < TaskList.Length; ++ i)
	{
		TaskList[i].Dump();
	}
	;
}
