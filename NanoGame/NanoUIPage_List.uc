/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoUIPage_List extends NanoUIPage_Base
	abstract;

/** List of all items */
var array<NanoUIListItem_Base>  Items;
/* List of currently  */
var array<NanoUIListItem_Base>  VisibleItems;

/** Index (into VisibleItems) of the current highlighted item */
var int                         HightlightItemIndex;

var()   vector2D	            ListOffset;
var     float                   ListItemSpacing;
var()   color                   ListCaratColor;

var     texture2d               ListUITex;

/** How many items should be drawn on the list */
var     int                     MaxItemsToDraw;

/** First item that we should start trying to draw */
var     int                     StartDrawAtItem;

/// PRIVATE API

/** See if any items are currently visible (ie. pass ShouldDisplayItem) */
private function bool AnyVisibleItems()
{
	local NanoUIListItem_Base Item;

	foreach Items( Item )
	{
		if( ShouldDisplayItem(Item) )
		{
			return TRUE;
		}
	}

	return FALSE;
}

/** Select the next visible item in the list */
private function SelectNextItemUp()
{
	// need to check that there is at least one or we infi loop
	if( !AnyVisibleItems() )
	{
		return;
	}

	// If at top of screen..
	if(HightlightItemIndex == StartDrawAtItem)
	{
		// See if we can scroll list up
		if(StartDrawAtItem > 0)
		{
			StartDrawAtItem--;
			HightlightItemIndex--;
		}
	}
	else
	{
		HightlightItemIndex--;
	}
}


private function SelectNextItemDown()
{
	// need to check that there is at least one or we infi loop
	if( !AnyVisibleItems() )
	{
		return;
	}

	// If at end of list..
	if(HightlightItemIndex == VisibleItems.length - 1)
	{
		// do nothing
	}
	// If at bottom of screen..
	else if(HightlightItemIndex == StartDrawAtItem + MaxItemsToDraw - 1)
	{
		// See if we can scroll list down
		if(StartDrawAtItem + MaxItemsToDraw - 1 < VisibleItems.length - 1)
		{
			StartDrawAtItem++;
			HightlightItemIndex++;
		}
	}
	else
	{
		HightlightItemIndex++;
	}
}



/////// PUBLIC API

function EmptyItemList()
{
	Items.Length = 0;
	UpdateVisibleList();
}

function AddListItem(NanoUIListItem_Base NewItem)
{
	// Save pointer to this page
	NewItem.ListPage = self;
	// Add to array
	Items.AddItem(NewItem);
	UpdateVisibleList();
}

/** Update the visible list when display criteria changes or items change */
function UpdateVisibleList()
{
	local int ItemIdx;
	local NanoUIListItem_Base Item;

	VisibleItems.Length = 0;

	for(ItemIdx = StartDrawAtItem; ItemIdx < Items.Length; ItemIdx++)
	{
		Item = Items[ItemIdx];

		if( ShouldDisplayItem(Item) )
		{
			VisibleItems.AddItem(Item);
		}
	}

	// make sure highlight is in range
	HightlightItemIndex = Clamp(HightlightItemIndex, 0, VisibleItems.length-1);
}

function NanoUIListItem_Base GetHighlightedItem()
{
	return VisibleItems[HightlightItemIndex];
}

function OnSelectItem(NanoUIListItem_Base Item)
{
	// Do something
}

// If item should be shown
function bool ShouldDisplayItem(NanoUIListItem_Base Item)
{
	return true;
}


///// NanoUIPage_Base interface


function HandlePageInput(name ButtonName)
{
	// Upgrades screen controls
	switch( ButtonName )
	{
	// navigation

	// we need to search for next visible item 
	case 'DPad_Up'		:	SelectNextItemUp();
							break;

	// we need to search for next visible item 
	case 'DPad_Down'	:	SelectNextItemDown();
							break;

	//case 'X'			:	UnlockPlan( CurrSelectedRow );
	//						break;
	
	case 'A'			:	OnSelectItem( VisibleItems[HightlightItemIndex] );
							break;
	}
}

function PageShown()
{
	// Ensure highlighted item is visible
	if( !ShouldDisplayItem(GetHighlightedItem()) )
	{
		SelectNextItemDown();
	}

	Super.PageShown();
}

function HighlightFirstVisibleItem()
{
	HightlightItemIndex = 0;
}

function PageHidden()
{
	Super.PageHidden();
}

function DrawPage()
{
	local int ItemIdx, NumToDraw;
	local vector2D ItemOrigin;
	local NanoUIListItem_Base Item;
	local Canvas Canvas;

	Super.DrawPage();

	Canvas = NanoHUD.Canvas;

	// Draw list of skills
	ItemOrigin = PageUIOrigin + ListOffset;
	NumToDraw = Min(VisibleItems.Length, MaxItemsToDraw);
	for(ItemIdx = StartDrawAtItem; ItemIdx < StartDrawAtItem + NumToDraw; ItemIdx++)
	{
		Item = VisibleItems[ItemIdx];

		Item.DrawItem(self, ItemOrigin);

		// Draw carat on selected row
		if(ItemIdx == HightlightItemIndex)
		{
			Canvas.SetPos(ItemOrigin.X-30, ItemOrigin.Y+4);
			Canvas.SetDrawColor(ListCaratColor.R, ListCaratColor.G, ListCaratColor.B);
			Canvas.DrawTile(ListUITex, 11,22, 339,2, 11,22);
		}	

		// Advance to next row
		ItemOrigin.Y += ListItemSpacing;
	}
}

defaultproperties
{
	ListUITex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_IngameMenu_Inventory'

	ListItemSpacing=48.0

	ListOffset=(X=65,Y=60)

	ListCaratColor=(R=255,G=225,B=0,A=255)

	MaxItemsToDraw=100
}