class MessageTimerExpired extends Engine.Message;

// editorDisplay
static function string editorDisplay(Name triggeredBy, Message filter)
{
	return "The timer for " $ triggeredBy $ " expires";
}






// Decompiled with UE Explorer.
defaultproperties
{
    specificTo=Class'Script'
}