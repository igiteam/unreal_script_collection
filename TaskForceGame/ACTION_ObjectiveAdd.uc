class ACTION_ObjectiveAdd extends ScriptedAction;

const SECONDARY_OBJECTIVE_DIFF = 2;

var() int ID;
var() localized string ObjectiveText;
var() localized string ObjectiveDescription;
var() localized string ObjectiveDescriptionB;
var() localized string ObjectiveDescriptionC;
var() bool IsSecondary;

function bool InitActionFor(ScriptedController C)
{
	local SFRMPlayerController pc;

//	log("ACTION_ObjectiveAdd hit");

	if (IsSecondary && (C.Level.Game.GameDifficulty < SECONDARY_OBJECTIVE_DIFF))
	{
		return false;
	}

	if ((ID != -1) && (ObjectiveText!=""))
	{
		ForEach C.DynamicActors(class'SFRMPlayerController', pc)
		{
			pc.ObjectiveManager.AddObjective(ID, ObjectiveText, ObjectiveDescription, ObjectiveDescriptionB, ObjectiveDescriptionC);
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
    ActionString="Add Objective"
}