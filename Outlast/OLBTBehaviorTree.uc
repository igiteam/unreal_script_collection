/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTBehaviorTree extends Object
	native(AI);

var OLBTRootNode RootNode;

/** Used to avoid editing the same BehaviorTree in multiple BehaviorTreeEditors at the same time. */
var		editoronly transient bool	bBeingEdited;

defaultproperties
{
}
