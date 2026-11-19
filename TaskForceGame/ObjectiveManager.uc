class ObjectiveManager extends Object within SFRMPlayerController
	native;
//class ObjectiveManager extends Object;

struct native export ObjectiveData
{
	var int ID;
	var string Text;
	var string Description;
	var string DescriptionB;
	var string DescriptionC;
	var EObjectiveStatus Status;
};

const MAX_OBJECTIVES = 11;

var ObjectiveData Objectives[MAX_OBJECTIVES];
var SFRMPlayerController Owner;

function ObjectiveData GetObjectiveData(int idx)
{
	return Objectives[idx];
}

function Init(SFRMPlayerController creator)
{
	local int i;
	
	Owner = creator;
	
	for (i=0; i<MAX_OBJECTIVES; i++)
	{
		ClearObjective(i);
	}
}

function bool VerifyCompletion()
{
	Local int i;
	
	//Do LOD check and return true if LOD is below HARD (2)
	if(Level.Game.GameDifficulty < 2)
	{
		return true;
	}
	
	
	for(i=0; i < MAX_OBJECTIVES; i++)
	{
		if( (Objectives[i].ID != -1) && 
			(Objectives[i].Status == OBJ_Incomplete) )
		{
			BasicHUD(Owner.myHud).ObjectivesIncomplete();
			return false;
		}
	}
	return true;
}

function AddObjective(int ID, string Text, string Description, string DescriptionB, string DescriptionC)
{
	if (ID >= MAX_OBJECTIVES)
	{
		log("Add objective with ID too large: " $ ID @ Text);
		return;
	}

//	log("Add objective: " $ ID @ Text);
	if (Objectives[ID].ID == -1)
	{
		Objectives[ID].ID = ID;
		Objectives[ID].Text = Text;
		Objectives[ID].Description = Description;
		Objectives[ID].DescriptionB = DescriptionB;
		Objectives[ID].DescriptionC = DescriptionC;
		Objectives[ID].Status = OBJ_Incomplete;
	}
	else
	{
		log("Tried to add objective in filled slot " $ ID);
	}

	BasicHUD(Owner.myHUD).ObjectivesUpdated(Text);
//FIXME_OLDMENUS
//	MenuManager(Owner.Player.BasePlayerMenu).GetObjectivesMenu().MostRecentID = ID;
}

function RemoveObjective(int ID)
{
	if (ID >= MAX_OBJECTIVES)
	{
		log("Remove objective with ID too large: " $ ID);
		return;
	}

	ClearObjective(ID);

	BasicHUD(Owner.myHUD).ObjectivesUpdated("");
}

function SetObjectiveText(int ID, string newText, string newDescription, string newDescriptionB, string newDescriptionC)
{
	if (ID >= MAX_OBJECTIVES)
	{
		log("SetObjectiveText with ID too large: " $ ID $ newText);
		return;
	}

	if (Objectives[ID].ID != -1)
	{
		if (newText != "")
		{
			Objectives[ID].Text = newText;
		}
		
		if (newDescription != "")
		{
			Objectives[ID].Description = newDescription;
		}
		
		if (newDescriptionB != "")
		{
			Objectives[ID].DescriptionB = newDescriptionB;
		}
		
		if (newDescriptionC != "")
		{
			Objectives[ID].DescriptionC = newDescriptionC;
		}
	}
	else
	{
		log("Set text on invalid objective " $ ID);
	}

	BasicHUD(Owner.myHUD).ObjectivesUpdated ( Objectives[ID].Text );
}

function SetObjectiveStatus(int ID, EObjectiveStatus newStatus)
{
	if (ID >= MAX_OBJECTIVES)
	{
		log("SetObjectiveStatus with ID too large: " $ ID);
		return;
	}

	if (Objectives[ID].ID != -1)
	{
		Objectives[ID].Status = newStatus;
	}
	else
	{
		log("Set status on invalid objective " $ ID);
	}

	BasicHUD(Owner.myHUD).ObjectivesUpdated("");
}

//Utility funtions
function ClearObjective(int ID)
{
	Objectives[ID].ID = -1;
	Objectives[ID].Text = "";
	Objectives[ID].Status = OBJ_Incomplete;
}
