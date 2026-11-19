class ACTION_JitteryMeshChangeState extends ScriptedAction;

var() Name	JitteryStaticMeshTag;

struct NewStateParams
{
	var() int	JitterFunctionIndex;
	var() bool	Pause;
	var() bool	Reverse;
};

var() array<NewStateParams> NewFunctionState;

function bool InitActionFor(ScriptedController C)
{
	Local JitteryStaticMesh JSM;
	local int i;
	
	ForEach C.DynamicActors(class'JitteryStaticMesh', JSM, JitteryStaticMeshTag)
	{
		for(i=0;i < NewFunctionState.Length; i++)
		{
			JSM.ChangeState(NewFunctionState[i].JitterFunctionIndex,NewFunctionState[i].Pause,NewFunctionState[i].Reverse);
		}
	}
	return false;	
}

function string GetActionString()
{
	return ActionString;
}


// Decompiled with UE Explorer.
defaultproperties
{
    NewFunctionState[0]=(JitterFunctionIndex=0,Pause=false,Reverse=false)
    ActionString="Jittery Mesh Change State"
}