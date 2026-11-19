class CoreSystem extends Actor
	native(Core);

var CoreThread ThreadList_WaitFrame;
var CoreThread ThreadList_Wait;
var CoreThread ThreadList_Suspend;

var CoreThread CurrentThreadList;
var CoreThread CurrentThread;
var CoreTask CurrentTask;

var CoreThread ThreadList_WaitFrame_Last;

var double CurrentTime;

var const bool DoLatent;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

event PreBeginPlay()
{
	ThreadList_Wait = new(self) class'CoreThread';
	ThreadList_WaitFrame = new(self) class'CoreThread';
	ThreadList_Suspend = new(self) class'CoreThread';

	CurrentThreadList = new(self) class'CoreThread';

	ThreadList_WaitFrame_Last = ThreadList_WaitFrame;
}

function CoreObject NewObject(class<CoreObject> spawnClass)
{
	local CoreObject obj;

	obj = new(self) spawnClass;
	obj.Construct();

	return obj;
}

function AIArrayStruct GetAIArray()
{
	local AIArrayStruct ret;
	local TGAI AI;

	foreach WorldInfo.AllControllers(class'TGAI',AI)
	{
		ret.data.AddItem(AI.MyTGPawn.hod);
	}

	return ret;
}

private event CoreThread NewThread()
{
	return new(self) class'CoreThread';
}

native function Run(CoreTask task, bool bNewThread);

function Dump()
{
	local CoreThread lThread;
	local int lThreadCount;

	;
	lThread = ThreadList_WaitFrame.NextThread;
	lThreadCount = 0;
	while (lThread != none)
	{
		lThread.Dump();
		lThread = lThread.NextThread;
		lThreadCount ++;
	}
	;
	;

	;
	lThread = ThreadList_Wait.NextThread;
	lThreadCount = 0;
	while (lThread != none)
	{
		lThread.Dump();
		lThread = lThread.NextThread;
		lThreadCount ++;
	}
	;
	;

	;
	lThread = ThreadList_Suspend.NextThread;
	lThreadCount = 0;
	while (lThread != none)
	{
		lThread.Dump();
		lThread = lThread.NextThread;
		lThreadCount ++;
	}
	;
	;
}

