/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTTask extends Object
	abstract
	native(AI);

var OLBTNode Node;
var OLBot Owner;

cpptext
{
	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL ) { return Status_Failure; }

	virtual void OnInitialize() {}
	virtual void OnTerminate(EStatus status);

	virtual UBOOL IsLatentTask() { return FALSE; }

	virtual void GetTreeState(TArray<FBehaviorState>& CurrentState); // Recursive through all Tasks.
	virtual void AddTaskState(TArray<FBehaviorState>& CurrentState); // Adds data for this task.
	
	virtual UBOOL CompareTaskState(const UOLBTTask* Other) { return GetClass() == Other->GetClass(); }
}

function DisplayDebug(Canvas aCanvas, float XL, float XPos, out float out_YL, out float out_YPos)
{
	aCanvas.SetPos(XPos, out_YPos);

	if (string(Node.NodeName) == "None")
	{	
		aCanvas.DrawText(Name);
	}
	else
	{
		aCanvas.DrawText(Node.NodeName $ " (" $ Name $ ")");		
	}
}

defaultproperties
{
	Node = None
}