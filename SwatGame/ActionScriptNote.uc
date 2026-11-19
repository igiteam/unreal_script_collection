class ActionScriptNote extends Action;

var() actionnoresolve String note;

// execute
latent function Variable execute()
{
	return None;
}

// editorDisplayString
function editorDisplayString(out string s)
{
	s = note;
}








// Decompiled with UE Explorer.
defaultproperties
{
    actionDisplayName="Script Note"
    actionHelp="Does nothing at runtime, but allows for notes to be added to a script"
    category="Other"
}