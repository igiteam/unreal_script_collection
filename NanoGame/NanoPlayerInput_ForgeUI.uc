/**
 * NanoPlayerInput
 * Nano player input post processing
 *
 // for 1st person game we probably want to grab the UT3 PlayerInput code  as that has all of the fast acceleration and such that UT3 needed
 // also it is partially c++'d.  
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPlayerInput_ForgeUI extends NanoPlayerInput_Base
	dependson(NanoPawn)
	transient;

/** Sets the input handlers for the button handling list - set by subclasses */
event InitializeButtonHandlingHandlers()
{
// 	InputButtonDataList[GB_A].ButtonHandler					= HandleButtonInput_A;
// 	InputButtonDataList[GB_X].ButtonHandler					= HandleButtonInput_X;
// 	InputButtonDataList[GB_Y].ButtonHandler					= HandleButtonInput_Y;
// 	InputButtonDataList[GB_B].ButtonHandler					= HandleButtonInput_B;
// 	InputButtonDataList[GB_Start].ButtonHandler				= HandleButtonInput_Start;
// 	InputButtonDataList[GB_Back].ButtonHandler				= HandleButtonInput_Back;
// 	InputButtonDataList[GB_LeftTrigger].ButtonHandler		= HandleButtonInput_LeftTrigger;
// 	InputButtonDataList[GB_LeftBumper].ButtonHandler		= HandleButtonInput_LeftBumper;
//	InputButtonDataList[GB_RightTrigger].ButtonHandler		= HandleButtonInput_RightTrigger;
// 	InputButtonDataList[GB_RightBumper].ButtonHandler		= HandleButtonInput_RightBumper;
 	InputButtonDataList[GB_DPad_Up].ButtonHandler			= HandleButtonInput_DPad_Up;
// 	InputButtonDataList[GB_DPad_Left].ButtonHandler			= HandleButtonInput_DPad_Left;
 	InputButtonDataList[GB_DPad_Down].ButtonHandler			= HandleButtonInput_DPad_Down;
// 	InputButtonDataList[GB_DPad_Right].ButtonHandler		= HandleButtonInput_DPad_Right;
// 	InputButtonDataList[GB_LeftStick_Push].ButtonHandler	= HandleButtonInput_LeftStickButton;
// 	InputButtonDataList[GB_RightStick_Push].ButtonHandler	= HandleButtonInput_RightStickButton;
}

function PreProcessInput(float DeltaTime)
{
	Super.PreProcessInput(DeltaTime);
	ZeroAllStickInput();
}

/** Forge/fire selected weapon */
// function HandleButtonInput_RightTrigger( bool bPressed, optional bool bDblClickMove )
// {
// 	local class<NanoPlan> NewPlan;
// 	if (bPressed)
// 	{
// 		// select the selected thing in the ui and close
// 		NewPlan = Outer.MyNanoHUD.GetSelectedForgeUIItem();
// 		Outer.MyNanoHUD.ShowForgeUI(false);
// 		Outer.MyNanoHUD.ShowWeaponSelectUI(false);
// 
// 		NanoPRI(PlayerReplicationInfo).EquipNanoPlan(NewPlan);
// 		NewPlan.static.Forge(MyNP);
// 	}
// }

function HandleButtonInput_DPad_Down( bool bPressed, optional bool bDblClickMove )
{
	local class<NanoPlan> NewPlan;

	if (!bPressed)
	{
		NewPlan = Outer.MyNanoHUD.GetSelectedForgeUIItem();
		NanoPRI(PlayerReplicationInfo).EquipNanoPlan(NewPlan);

		Outer.PopPlayerInput(self);
		Outer.MyNanoHUD.ShowForgeUI(false);
	}
}

function HandleButtonInput_DPad_Up( bool bPressed, optional bool bDblClickMove )
{
	local class<NanoPlan> NewPlan;

	if (!bPressed)
	{
		NewPlan = Outer.MyNanoHUD.GetSelectedForgeUIItem();
		NanoPRI(PlayerReplicationInfo).EquipNanoPlan(NewPlan);
		MyNP.StartForge(NewPlan);

		Outer.PopPlayerInput(self);
		Outer.MyNanoHUD.ShowWeaponSelectUI(false);
	}
}

defaultproperties
{
}