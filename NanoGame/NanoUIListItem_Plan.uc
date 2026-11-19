/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * Entry for the NanoUIPage_Inventory page
 */
class NanoUIListItem_Plan extends NanoUIListItem_Base;

/** Information  */
var NanoPlanInfo    PlanInfo;


function string GetDisplayName()
{
	return PlanInfo.Plan.default.ForgeUIData.PlanName;
}

function color GetItemColor(NanoUIPage_List Page)
{
	local NanoPRI NPRI;
	local NanoUIPage_Inventory InvPage; 

	NPRI = ListPage.GetNanoPRI();
	InvPage = NanoUIPage_Inventory(Page);

	if( NPRI.PlanIsEquipped(PlanInfo.Plan) || InvPage.GetExistingBindSlotIndex(PlanInfo.Plan) != -1 )
	{
		return MakeColor(255, 225, 0, 255);
	}
	else
	{
		return Super.GetItemColor(Page);
	}
}

/** Draw the icon for this entry at the specified location */
function DrawIcon(NanoUIPage_List Page, vector2d IconPos, vector2d IconSize)
{
	local Canvas Canvas;
	local NanoUIPage_Inventory InvPage; 
	local int BindSlotIdx;
	local Texture2D DPadTex;

	Canvas = Page.NanoHUD.Canvas;
	InvPage = NanoUIPage_Inventory(Page);

	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.SetPos(IconPos.X, IconPos.Y);

	Page.NanoHUD.DrawTileCoords(PlanInfo.Plan.default.PlanIcon.IconTex, IconSize.X,IconSize.Y, PlanInfo.Plan.default.PlanIcon.Coords);

	// Draw d-pad binding
	BindSlotIdx = InvPage.GetExistingBindSlotIndex(PlanInfo.Plan);
	if( BindSlotIdx != -1 )
	{
		if(BindSlotIdx == 0)
		{
			DPadTex = Texture2D'UI_HUD.Menu.DPadU';
		}
		else if(BindSlotIdx == 1)
		{
			DPadTex = Texture2D'UI_HUD.Menu.DPadD';
		}
		else if(BindSlotIdx == 2)
		{
			DPadTex = Texture2D'UI_HUD.Menu.DPadL';
		}
		else if(BindSlotIdx == 3)
		{
			DPadTex = Texture2D'UI_HUD.Menu.DPadR';
		}

		Canvas.SetPos(IconPos.X + ItemSize.X - 10 - IconSize.X, IconPos.Y);
		Canvas.SetDrawColor(255,255,255,255);
		Canvas.DrawTile(DPadTex, IconSize.X, IconSize.Y, 0,0, 256,256);
	}
}

