class ACTION_TutorialMessage extends ScriptedAction;

var(Action) localized string Message;
var(Action) int MessageTime;
var class<LocalMessage> MessageClass;

function string GetActionString()
{
	return ActionString@Message;
}

function bool InitActionFor(ScriptedController C)
{
	Super.InitActionFor(C);

	C.Level.Game.BroadcastLocalized( C, MessageClass,, None, None, self );

	return false;	
}



// Decompiled with UE Explorer.
defaultproperties
{
    MessageTime=3
    MessageClass=Class'ZombieWeaponMessage'
    ActionString="TutorialMessage"
}