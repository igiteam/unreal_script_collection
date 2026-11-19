class ACTION_ObjectiveText extends ScriptedAction;

var() int ID;
var() localized string NewText;
var() localized string NewDescription;
var() localized string NewDescriptionB;
var() localized string NewDescriptionC;

function bool InitActionFor(ScriptedController C)
{
	local SFRMPlayerController pc;

	if ((ID != -1) && ((NewText!="") || (NewDescription!="")))
	{
		ForEach C.DynamicActors(class'SFRMPlayerController', pc)
		{
			pc.ObjectiveManager.SetObjectiveText(ID, NewText, NewDescription, NewDescriptionB, NewDescriptionC);
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
    Id=-1
    ActionString="Set Objective Text"
}