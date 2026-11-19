/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTCompositeTask extends OLBTTask
	abstract
	native(AI);

var OLBTBehavior CurrentBehavior;
var int CurrentChildIndex;

cpptext
{
	UOLBTCompositeNode& GetCompositeNode();
	UOLBTNode* GetCurrentChild();

	virtual void OnInitialize();
	virtual void OnTerminate(EStatus status);

	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL ) { return Status_Failure; }

	virtual void GetTreeState(TArray<FBehaviorState>& CurrentState); // Recursive through all Tasks.
	virtual UBOOL CompareTaskState(const UOLBTTask* Other);
}

function DisplayDebug(Canvas aCanvas, float XL, float XPos, out float out_YL, out float out_YPos)
{
	aCanvas.SetPos(XPos, out_YPos);

	if (string(Node.NodeName) == "None")
	{		
		aCanvas.DrawText(Name $ " : " $ CurrentChildIndex);
	}
	else
	{
		aCanvas.DrawText(Node.NodeName $ " (" $ Name $ ") : " $ CurrentChildIndex);		
	}
	out_YPos += out_YL;
	XPos += XL;

	if (CurrentBehavior != None && CurrentBehavior.Task != None)
	{
		CurrentBehavior.Task.DisplayDebug(aCanvas, XL, XPos, out_YL, out_YPos);
	}
}

defaultproperties
{
}