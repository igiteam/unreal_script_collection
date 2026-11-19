/**
 * NanoInventoryManager
 * Nano inventory definition
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoInventoryManager extends NanoInventoryManagerBase
	config(Weapon)
	DependsOn(NanoTypes,NanoWeapon);


var transient bool bShowUpgradesScreen;


/** Current selected upgrade in Upgrades Menu */
var transient int CurrSelectedRow;


var vector2D	UpgradeUIOrigin;
var Material	UpgradeBackground;

var Texture2D   UpgradeUITex;
var Texture2D   UpgradeUITabTex;

var() vector2D	UpgradeUIListOffset;
var() Vector2D  UpgradeUIListTextOffset;
var() float     UpgradeUIPlanSpacing;
var() color     UpgradeUICaratColor;


/**
 * Gives InventoryManager a chance to trap player input.
 * Returns true if input should be trapped, false if not.
 */
simulated function bool FilterButtonInput(Name ButtonName,bool bPressed,int ButtonIdx)
{
	local NanoPC PC;
	local NanoPRI NPRI;

	PC = NanoPC(Instigator.Controller);

	if( ( bShowUpgradesScreen == TRUE ) && ( PC != none ) && ( bPressed == TRUE ) )
	{
		NPRI = NanoPawn(Owner).GetPRI();	
	
		//`log( "NanoInventoryManager Received ButtonName: " @ ButtonName );

		// Upgrades screen controls
		switch( ButtonName )
		{
		// navigation

		// we need to search for next unlockable plan
		case 'DPad_Up'		:	SelectNextUnlockablePlanUp( NPRI );
								return TRUE;
		// we need to search for next unlockable plan
		case 'DPad_Down'	:	SelectNextUnlockablePlanDown( NPRI );
								return TRUE;

		case 'X'			:	UnlockPlan( CurrSelectedRow );					
								return TRUE;
		
		case 'A'			:	EquipPlan( CurrSelectedRow );					
								return TRUE;

		case 'B'			:	bShowUpgradesScreen = FALSE;                    
								return TRUE;

		case 'Y'			:	return FALSE;
	
		}

		// trap all input when buying upgrades
		return TRUE;
	}

	return TRUE;
}



function bool AnyLockedPlans( NanoPRI NPRI )
{
	local bool Retval;
	local NanoPlanInfo PlanInfo;

	foreach NPRI.OwnedPlans( PlanInfo )
	{
		if( PlanInfo.bUnlocked == FALSE )
		{
			Retval = TRUE;
			break;
		}
	}


	return Retval;
}

function SelectNextUnlockablePlanUp( NanoPRI NPRI )
{
	// need to check that there is at least one locked plan or we infi loop
	if( AnyLockedPlans( NPRI ) == FALSE )
	{
		return;
	}

	do
	{
		CurrSelectedRow = CurrSelectedRow <= 0 ? NPRI.OwnedPlans.length-1 : CurrSelectedRow-1;
	}until ( NPRI.OwnedPlans[CurrSelectedRow].bUnlocked == FALSE );
}


function SelectNextUnlockablePlanDown( NanoPRI NPRI )
{
	// need to check that there is at least one locked plan or we infi loop
	if( AnyLockedPlans( NPRI ) == FALSE )
	{
		return;
	}


	do
	{
		CurrSelectedRow = ++CurrSelectedRow % NPRI.OwnedPlans.length;
	}until ( NPRI.OwnedPlans[CurrSelectedRow].bUnlocked == FALSE );
}


/** Hook called from HUD actor. Gives access to HUD and Canvas */
simulated function DrawNanoHUD( NanoHUD_Base H )
{
	// do not draw inventory HUD if we're not viewing our character.
	if( Pawn(Owner) != PlayerController(Pawn(Owner).Controller).ViewTarget )
	{
		return;
	}

	super.DrawHUD( H );

	if( bShowUpgradesScreen == TRUE )
	{
		DrawUpgradesScreen( H );
	}
}


simulated function SetFirstAvailItemInList()
{
	CurrSelectedRow = 0;
	SelectNextUnlockablePlanDown( NanoPawn(Owner).GetPRI() ) ;
}


/** Master function to draw upgrades screen. */
simulated function DrawUpgradesScreen(NanoHUD_Base HUD)
{
	local int PlanIdx;
	local vector2D PlanOrigin;
	local NanoPRI NPRI;
	local NanoPlanInfo PlanInfo;


	NPRI = NanoPawn(Owner).GetPRI();

	// Draw background
	HUD.Canvas.SetPos(UpgradeUIOrigin.X, UpgradeUIOrigin.Y);
	HUD.Canvas.SetDrawColor(255, 255, 255, 255);
	HUD.Canvas.DrawMaterialTile(UpgradeBackground, 1024, 512, 0, 0, 1, 1);
	
	//class'NanoGame.NanoUIPage_Base'.static.DrawButtonHelpBar(HUD.Canvas, UpgradeUIOrigin.X, UpgradeUIOrigin.Y, "", PlanIsEquippable(CurrSelectedRow), "DECRYPT", PlanIsUnlockable(CurrSelectedRow));
	
	// Draw amount of cash you have
	HUD.Canvas.SetDrawColor(255, 255, 255, 255);
	HUD.Canvas.SetPos(UpgradeUIOrigin.X + 480, UpgradeUIOrigin.Y + 50 );
	HUD.Canvas.DrawText("Currency: "$NPRI.AmountOfCurrencyOwned);
	
	// Draw list of skills
	PlanOrigin = UpgradeUIOrigin + UpgradeUIListOffset;
	for(PlanIdx = 0; PlanIdx < NPRI.OwnedPlans.Length; PlanIdx++)
	{
		PlanInfo = NPRI.OwnedPlans[PlanIdx];

		// don't draw if the plan is already unlocked
		if( PlanInfo.bUnlocked == TRUE )
		{
			//`log( "Continue" @ `showvar(NPRI.OwnedPlans.Length) @ `showvar(PlanIdx) @ `showvar(PlanInfo.Plan) );
			continue;
		}

		//`log( "Drawing" @ `showvar(NPRI.OwnedPlans.Length) @ `showvar(PlanIdx) @ `showvar(PlanInfo.Plan) );


		// Box for plan
		HUD.Canvas.SetDrawColor(255, 255, 255, 180);
		HUD.Canvas.SetPos(PlanOrigin.X, PlanOrigin.Y);
		HUD.Canvas.DrawTile(UpgradeUITex, 285,52, 0,0, 285,52);

		// Set color, based on equipped status
		HUD.Canvas.SetDrawColor(255, 255, 255, NPRI.PlanIsEquipped(PlanInfo.Plan) ? 255 : 128);		

		// icon for plan
		HUD.Canvas.SetPos(PlanOrigin.X + 13, PlanOrigin.Y + 5);
		HUD.DrawTileCoords(PlanInfo.Plan.default.PlanIcon.IconTex, 26,26, PlanInfo.Plan.default.PlanIcon.Coords);	
			
		// Name of plan (brighter if equipped)
		HUD.Canvas.SetPos(PlanOrigin.X + UpgradeUIListTextOffset.X, PlanOrigin.Y + UpgradeUIListTextOffset.Y);
		HUD.Canvas.DrawText(PlanInfo.Plan.default.PlanName);

		// If not unlocked, 
		if(!PlanInfo.bUnlocked)
		{
			// ..draw locked padlock icon in red 
			HUD.Canvas.SetPos(PlanOrigin.X + 260, PlanOrigin.Y + 5);
			HUD.Canvas.SetDrawColor(177, 45, 45, 255);
			HUD.Canvas.DrawTile(UpgradeUITex, 19,24, 316,2, 19,24);

			// ..and price
			HUD.Canvas.SetPos(PlanOrigin.X + UpgradeUIListTextOffset.X, PlanOrigin.Y + 34);
		
			// if we can't afford it draw it in red
			if( PlanInfo.Plan.default.UnlockCost > NPRI.AmountOfCurrencyOwned )
			{
				HUD.Canvas.SetDrawColor(255, 0, 0, 255);
			}
			else
			{
				HUD.Canvas.SetDrawColor(255, 255, 255, 255);
			}

			HUD.Canvas.DrawText(""$PlanInfo.Plan.default.UnlockCost);
		}
		else
		{
			// ..draw unlocked padlock icon 
			HUD.Canvas.SetPos(PlanOrigin.X + 260, PlanOrigin.Y + 5);
			HUD.Canvas.SetDrawColor(255, 255, 255, 255);
			HUD.Canvas.DrawTile(UpgradeUITex, 19,24, 293,2, 19,24);
		}

		// Draw icon for weapon slot
		HUD.Canvas.SetDrawColor(255, 255, 255, NPRI.PlanIsEquipped(PlanInfo.Plan) ? 255 : 128);				
		HUD.Canvas.SetPos(PlanOrigin.X + 46, PlanOrigin.Y + 6);
		DrawPlanSlotIcon(HUD, PlanInfo.Plan.default.PlanSlot, 22,22);

		// Draw carat on selected row
		if(PlanIdx == CurrSelectedRow)
		{
			HUD.Canvas.SetPos(PlanOrigin.X-30, PlanOrigin.Y+4);
			HUD.Canvas.SetDrawColor(UpgradeUICaratColor.R, UpgradeUICaratColor.G, UpgradeUICaratColor.B);
			HUD.Canvas.DrawTile(UpgradeUITabTex, 11,22, 339,2, 11,22);
		}	

		// Advance to next row
		PlanOrigin.Y += UpgradeUIPlanSpacing;
	}
}

/** Util to draw icon for a slot - call SetPos before calling this function */
simulated function DrawPlanSlotIcon(HUD HUD, ENanoPlanSlot Slot, float XL, float YL)
{
	if(Slot == EPS_Gun)
	{
		HUD.Canvas.DrawTile(UpgradeUITabTex, XL,YL, 314,29, 22,22);
	}
	else if(Slot == EPS_Melee)
	{
		HUD.Canvas.DrawTile(UpgradeUITabTex, XL,YL, 290,29, 22,22);
	}
	else if(Slot == EPS_Utility)
	{
		HUD.Canvas.DrawTile(UpgradeUITabTex, XL,YL, 338,29, 22,22);
	}
}

/** Util to see if a particular plan can be unlocked */
simulated function bool PlanIsUnlockable( byte InCurrSelectedRow )
{
	local NanoPRI NPRI;
	local NanoPlanInfo PlanInfo;
	
	NPRI = NanoPawn(Owner).GetPRI();
	PlanInfo = NPRI.OwnedPlans[InCurrSelectedRow];

	// If not already unlocked, and can afford it, ok
	return((!PlanInfo.bUnlocked) && (PlanInfo.Plan.default.UnlockCost <= NPRI.AmountOfCurrencyOwned));
}

/** Unlock specified plan */
simulated function UnlockPlan( byte InCurrSelectedRow )
{
	local NanoPRI NPRI;
	local NanoPlanInfo PlanInfo;
	
	NPRI = NanoPawn(Owner).GetPRI();
	PlanInfo = NPRI.OwnedPlans[InCurrSelectedRow];

	if(PlanIsUnlockable(InCurrSelectedRow))
	{
		NPRI.OwnedPlans[InCurrSelectedRow].bUnlocked = true;
		
		// take money for unlock
		NPRI.AwardCurrency( -PlanInfo.Plan.default.UnlockCost, "Paying for Plan Decrypt" );
	}
}

/** Util to see if a particular plan can be unlocked */
simulated function bool PlanIsEquippable( byte InCurrSelectedRow )
{
	local NanoPRI NPRI;
	local NanoPlanInfo PlanInfo;
	local string Error;
	
	NPRI = NanoPawn(Owner).GetPRI();
	PlanInfo = NPRI.OwnedPlans[InCurrSelectedRow];

	return(NPRI.PlanCanBeEquippedInSlot(PlanInfo.Plan, PlanInfo.Plan.default.PlanSlot, Error));
}

/** Equip specified plan */
simulated function EquipPlan( byte InCurrSelectedRow )
{
	local NanoPRI NPRI;
	local NanoPlanInfo PlanInfo;
	
	NPRI = NanoPawn(Owner).GetPRI();
	PlanInfo = NPRI.OwnedPlans[InCurrSelectedRow];

	if(PlanIsEquippable(InCurrSelectedRow))
	{
		NPRI.EquipNanoPlan(PlanInfo.Plan);
	}
}



defaultproperties
{
	bMustHoldWeapon=FALSE
	
	UpgradeUIOrigin=(X=128,Y=104)
	UpgradeUIListOffset=(X=65,Y=40)
	UpgradeUIListTextOffset=(X=80,Y=10)
	UpgradeUIPlanSpacing=70.0
	
	UpgradeBackground=Material'Nano_ProtoHUD_Ingame.M_UI_HUD_Ingame_Menu_Background'
	UpgradeUITex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_IngameMenu_Inventory'
	UpgradeUITabTex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_IngameMenu_Inventory'
	UpgradeUICaratColor=(R=25,G=25,B=230,A=255)
}