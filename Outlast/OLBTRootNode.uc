/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTRootNode extends OLBTCompositeNode
	native(AI);

cpptext
{
	/* for editor use. */
	virtual FIntPoint GetConnectionLocation(INT ConnType, INT ConnIndex);
	virtual void DrawNode(FCanvas* Canvas, const TArray<UOLBTNode*>& SelectedNodes);
};

defaultproperties
{
	TaskType=class'OLBTRootTask'

	Children(0)=(Name="Child")
	bFixNumChildren=TRUE;
}