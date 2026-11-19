/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTBehavior extends Object
	native(AI);

enum EStatus
{
	Status_Invalid,
	Status_Success,
	Status_Failure,
	Status_Running,
	Status_ReachedCurrent,
};

struct native BehaviorState
{
	var OLBTTask Task;
};

var OLBTNode Node;
var OLBTTask Task;
var EStatus CurrentStatus;

cpptext
{
	void Setup(UOLBTNode* aNode, AOLBot* aBot);
	void Teardown();

	EStatus Tick( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL);

	void GetTreeState(TArray<FBehaviorState>& CurrentState);

	static UBOOL CompareTreeStates(const TArray<FBehaviorState>* TreeA, const TArray<FBehaviorState>* TreeB);
}

defaultproperties
{
	Node = None
	Task = None
	CurrentStatus = Status_Invalid
}