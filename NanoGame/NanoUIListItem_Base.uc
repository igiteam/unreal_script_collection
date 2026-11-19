/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoUIListItem_Base extends Object
	abstract;

/** Up pointer to page that owns this item */
var NanoUIPage_List ListPage;

/** Offset of text from origin (top left) of item */
var Vector2D    ItemTextOffset;

/** Whether to draw a frame around this item */
var bool        bDrawFrame;

/** Size for this item */
var vector2D    ItemSize;


/** Returns name to display for this item */
function string GetDisplayName()
{
	return "NONE";
}

/** Return color to use for drawing this item */
function color GetItemColor(NanoUIPage_List Page)
{
	if(ListPage.GetHighlightedItem() == self)
	{
		return MakeColor(255, 255, 255, 255);
	}
	else
	{
		return MakeColor(255, 255, 255, 180);
	}
}

/** Draw the icon for this entry at the specified location */
function DrawIcon(NanoUIPage_List Page, vector2d IconPos, vector2d IconSize)
{
	local Canvas Canvas;

	Canvas = Page.NanoHUD.Canvas;

	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.SetPos(IconPos.X, IconPos.Y);
}

/** Draw this item at the specified location */
function DrawItem(NanoUIPage_List Page, vector2d ItemOrigin)
{
	local Canvas Canvas;
	local vector2d IconPos, IconSize;
	local Color C;

	Canvas = Page.NanoHUD.Canvas;
	C = GetItemColor(Page);

	// Frame
	if(bDrawFrame)
	{
		Canvas.SetDrawColorStruct(C);
		Canvas.SetPos(ItemOrigin.X, ItemOrigin.Y);
		Canvas.DrawBox(ItemSize.X, ItemSize.Y) ;
	}

	// Icon
	Canvas.SetDrawColorStruct(C);
	IconPos.X = ItemOrigin.X + 5;
	IconPos.Y = ItemOrigin.Y + 5;
	IconSize.Y = ItemSize.Y - 10;
	IconSize.X = IconSize.Y;
	DrawIcon(Page, IconPos, IconSize);

	// Text
	Canvas.SetDrawColorStruct(C);
	Canvas.SetPos(ItemOrigin.X + ItemTextOffset.X, ItemOrigin.Y + ItemTextOffset.Y);
	Canvas.DrawText( GetDisplayName() );
}


defaultproperties
{
	bDrawFrame=TRUE
	ItemTextOffset=(X=40,Y=10)
	ItemSize=(X=285,Y=35)
}