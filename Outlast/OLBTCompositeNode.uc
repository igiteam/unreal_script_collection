/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTCompositeNode extends OLBTNode
	abstract
	native(AI);

struct native OLBTNodeChild
{
	var Name Name;
	var editinline export OLBTNode Node;

	/* for editor use */
	var	editoronly int DrawY;
};

var editfixedsize editinline export array<OLBTNodeChild> Children;
var	bool bFixNumChildren;

cpptext
{
	virtual void GetNodesInternal(TArray<UOLBTNode*>& Nodes);

	void RenameChildConnectors();
	void OnAddChild(INT ChildNum);
	void OnRemoveChild(INT ChildNum);

	/* for editor use. */
	virtual FIntPoint GetConnectionLocation(INT ConnType, INT ConnIndex);
	virtual void DrawNode(FCanvas* Canvas, const TArray<UOLBTNode*>& SelectedNodes);
};

defaultproperties
{
	CategoryDesc="Composite Nodes"
}