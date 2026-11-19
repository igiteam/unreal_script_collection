class ActionLoop extends Action
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var() deepcopy editinline Array<Action> loopActions;

function setParentScript(Script s)
{
	local int i;

	super.setParentScript(s);
	
	for (i = 0; i < loopActions.Length; ++i)
			loopActions[i].setParentScript(s);
}

// execute
latent function Variable execute()
{
	local int i;
	
	super.execute();

	parentScript.enterLoop();
	
	while (true)
	{
		for (i = 0; i < loopActions.Length; ++i)
		{
			if (parentScript.keepLooping())
			{
					loopActions[i].execute();
			}
			else
			{
				goto END_LOOP;
			}
		}
	}

END_LOOP:
	return None;
}

// editorDisplayString
function editorDisplayString(out string s)
{
	s = "Loop";
}








// Decompiled with UE Explorer.
defaultproperties
{
    actionDisplayName="Loop Statement"
    actionHelp="Continually loop over loopActions until ActionExitLoop is executed."
    category="Script"
}