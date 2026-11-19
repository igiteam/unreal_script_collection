class ActionEnableWatcher extends ActionSetWatcherEnabled;

// editorDisplayString
function editorDisplayString(out string s)
{
	s = "Enable watcher " $ propertyDisplayString('scriptName') $ "." $ propertyDisplayString('watcherName');
}








// Decompiled with UE Explorer.
defaultproperties
{
    Enabled=true
    actionDisplayName="Enable Watcher"
    actionHelp="Enables a watcher in a given script"
    category="Watch"
}