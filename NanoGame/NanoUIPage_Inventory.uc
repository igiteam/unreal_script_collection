/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoUIPage_Inventory extends NanoUIPage_List;

/** Type of plans we are currently looking at  */
var ENanoPlanSlot   FilterType;

var bool bWaitingDPadPress;

simulated function AssignPlanToBindSlot(int SlotIndex)
{
	local NanoPRI NPRI;
	local NanoUIListItem_Plan PlanItem;
	local int CurrentSlotIdx;

	NPRI = GetNanoPRI();
	PlanItem = NanoUIListItem_Plan(GetHighlightedItem());

	// if this is replacing a plan that we are actively using, change active to this one
	if(NPRI.UtilityPlan == PlanItem.PlanInfo.Plan)
	{
		NPRI.EquipNanoPlan(PlanItem.PlanInfo.Plan);
	}

	// Make sure not already using plan in another slot, empty if so
	CurrentSlotIdx = GetExistingBindSlotIndex(PlanItem.PlanInfo.Plan);
	if(CurrentSlotIdx != -1)
	{
		NPRI.QuickBindPlans[CurrentSlotIdx] = None;
	}

	// Store into slot
	NPRI.QuickBindPlans[SlotIndex] = PlanItem.PlanInfo.Plan;

	// Stop waiting for d-pad input
	bWaitingDPadPress = FALSE;
}



simulated function int GetExistingBindSlotIndex(class<NanoPlan> CheckPlan)
{
	local NanoPRI NPRI;
	local int i;

	NPRI = GetNanoPRI();


	for(i=0; i<4; i++)
	{
		if(NPRI.QuickBindPlans[i] == CheckPlan)
		{
			return i;
		}
	}

	return -1;
}

///// NanoUIPage_List interface

/** Equip specified plan */
simulated function OnSelectItem( NanoUIListItem_Base Item )
{
	local NanoUIListItem_Plan PlanItem;
	local NanoPRI NPRI;

	PlanItem = NanoUIListItem_Plan(Item);

	// For utility plans, you have to pick a d-pad 'slot'
	if(PlanItem.PlanInfo.Plan.default.PlanSlot == EPS_Utility)
	{
		bWaitingDPadPress = TRUE;
	}
	// For gun/melee plans, equip now
	else
	{
		NPRI = GetNanoPRI();
		NPRI.EquipNanoPlan(PlanItem.PlanInfo.Plan);
	}
}



function bool ShouldDisplayItem(NanoUIListItem_Base Item)
{
	local NanoUIListItem_Plan PlanItem;

	PlanItem = NanoUIListItem_Plan(Item);

	// Only show unlocked, utility plans
	return (PlanItem.PlanInfo.bUnlocked && PlanItem.PlanInfo.Plan.default.PlanSlot == FilterType);
}

function SelectNextFilter(bool bForward)
{
	switch(FilterType)
	{
	case EPS_Utility:   FilterType = (bForward) ? EPS_Gun : EPS_Melee;
						break;

	case EPS_Gun:       FilterType = (bForward) ? EPS_Melee : EPS_Utility;
						break;

	case EPS_Melee:     FilterType = (bForward) ? EPS_Utility : EPS_Gun;
						break;
	}

	// tell list filtering has changed
	UpdateVisibleList();
}

/** Get the name of the current filter */
function string GetFilterString()
{
	if(FilterType == EPS_Utility)
	{
		return "Free Forge";
	}
	else if(FilterType == EPS_Gun)
	{
		return "Gun";
	}
	else if(FilterType == EPS_Melee)
	{
		return "Melee";
	}

	return "";
}


///// NanoUIPage_Base interface

function HandlePageInput(name ButtonName)
{
	if(bWaitingDPadPress)
	{
		// Binding plan to slot
		switch( ButtonName )
		{
		case 'DPad_Up'	    :   AssignPlanToBindSlot(0);
								break;

		case 'DPad_Down'	:	AssignPlanToBindSlot(1);
								break;

		case 'DPad_Left'	:	AssignPlanToBindSlot(2);
								break;

		case 'DPad_Right'	:	AssignPlanToBindSlot(3);
								break;
		}
	}
	else
	{
		// Upgrades screen controls
		switch( ButtonName )
		{
		// navigation

		// we need to search for next visible item 
		case 'DPad_Left'	:	SelectNextFilter(FALSE);
								break;

		// we need to search for next visible item 
		case 'DPad_Right'	:	SelectNextFilter(TRUE);
								break;
		}

		Super.HandlePageInput(ButtonName);
	}
}

function PageShown()
{
	local NanoPRI NPRI;
	local NanoUIListItem_Plan NewPlanItem;
	local NanoPlanInfo PlanInfo;

	FilterType = EPS_Utility;

	EmptyItemList();

	NPRI = GetNanoPRI();	
	foreach NPRI.OwnedPlans( PlanInfo )
	{
		NewPlanItem = new(self) class'NanoUIListItem_Plan';
		NewPlanItem.PlanInfo = PlanInfo;

		AddListItem(NewPlanItem);
	}

	HighlightFirstVisibleItem();

	Super.PageShown();
}

function PageHidden()
{
	Super.PageHidden();
}


function DrawPage()
{
	local Canvas Canvas;
	local NanoUIListItem_Plan PlanItem;
	local class<NanoPlan_WeaponBase> WeapPlan;
	local float AmmoFrac;
	local int InGunAmmo, SpareAmmo;
	local NanoPawn NP;

	Super.DrawPage();

	Canvas = NanoHUD.Canvas;
	PlanItem = NanoUIListItem_Plan(GetHighlightedItem());
	

	Canvas.Font = class'Engine'.Static.GetSmallFont();
	Canvas.SetDrawColor(255, 255, 255, 255);

	// Draw current type of plans we are looking at
	Canvas.SetPos(PageUIOrigin.X + 65, PageUIOrigin.Y + 40);
	Canvas.DrawText( GetFilterString() );


	// Draw info for current plan

	// plan name
	Canvas.SetPos(PageUIOrigin.X + 400, PageUIOrigin.Y + 40);
	Canvas.DrawText(PlanItem.PlanInfo.Plan.default.ForgeUIData.PlanName);

	// plan desc
	Canvas.SetPos(PageUIOrigin.X + 400, PageUIOrigin.Y + 60);
	Canvas.DrawText(PlanItem.PlanInfo.Plan.default.ForgeUIData.PlanDescription);

	// Special stuff for weapon drawing
	if(FilterType == EPS_Gun)
	{
		WeapPlan = class<NanoPlan_WeaponBase>(PlanItem.PlanInfo.Plan);

		Canvas.SetPos(PageUIOrigin.X + 400, PageUIOrigin.Y + 80);

		Canvas.SetDrawColor(255, 255, 255);
		Canvas.DrawBox(400, 10);

		NP = GetNanoPawn();
		NP.GetAmmoForWeapon(WeapPlan.default.WeaponClass, InGunAmmo, SpareAmmo);
		AmmoFrac = float(SpareAmmo)/float(WeapPlan.default.WeaponClass.default.WeaponMaxSpareAmmo);
		AmmoFrac = FClamp(AmmoFrac, 0.0, 1.0);

		Canvas.SetDrawColor(255, 129, 12);
		Canvas.DrawRect(400.0*AmmoFrac, 10);

		Canvas.SetPos(PageUIOrigin.X + 400, PageUIOrigin.Y + 90);
		Canvas.SetDrawColor(255, 255, 255);
		Canvas.DrawText(SpareAmmo);
	}

	// Draw box if waiting to bind plan
	if(bWaitingDPadPress)
	{
		NanoHUD.DrawMessageBox("Press D-Pad Direction to bind plan", "");
	}
}

defaultproperties
{
	PageName="PLANS"

	MaxItemsToDraw=9
}