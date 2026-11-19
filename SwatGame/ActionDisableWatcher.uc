class ActionDisableWatcher extends ActionSetWatcherEnabled;

// editorDisplayString
function editorDisplayString(out string s)
{
	s = "Disable watcher " $ propertyDisplayString('scriptName') $ "." $ propertyDisplayString('watcherName');
}








// Decompiled with UE Explorer.
defaultproperties
{
    actionDisplayName="Disable Watcher"
    actionHelp="Disables a watcher in a given script"
    category="Watch"
}