/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoUIPage_WeaponMods extends NanoUIPage_Base;


var transient int	SelectedWeaponModificationIndex;
var transient class<NanoWeapon>  SelectedWeaponModificationWeaponClass;
var transient class<NanoWeaponModifier> SelectedWeaponModificationWeaponModifierClass;

/**
 *  Since the set of weapon modifications is variable based on what plans we have we need to store this after one time of rendering
 *  the ui.
 **/
var transient int WeaponModificationsCount;

/** Draw one skill */
simulated function DrawWeaponModification( class<NanoWeapon> CurrWeapon, class<NanoWeaponModifier> WeaponMod, float DrawY, bool bSelected)
{
	local NanoPRI NPRI;
	local Texture2D IconTex;
	local vector2D IconOrigin, IconSize, BlobOrigin;
	local string WeaponModName;
	local int i;
	local int AmmoModLevel;
	local class<NanoWeaponModifier> ModFromPRI;
	local Canvas Canvas;

	Canvas = NanoHUD.Canvas;
	NPRI = GetNanoPRI();

	// Draw carat if this is the selected row
	if(bSelected)
	{
		Canvas.SetPos(PageUIOrigin.X+60, DrawY);
		Canvas.DrawTile(Texture2D'EngineResources.WhiteSquareTexture', 10, 32, 0.0, 0.0, 1.0, 1.0, PageUICaratLColor);
	}

	// Get icon info and draw it
	IconTex = WeaponMod.static.GetIconInfo(IconOrigin, IconSize);
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.SetPos(PageUIOrigin.X+75, DrawY);
	Canvas.DrawTile(IconTex, 32, 32, IconOrigin.X, IconOrigin.Y, IconSize.X, IconSize.Y);

	// Draw name of skill
	WeaponModName = WeaponMod.default.WeaponModifierName;
	Canvas.SetDrawColor(PageUITextColor.R, PageUITextColor.G, PageUITextColor.B, 255);
	Canvas.SetPos(PageUIOrigin.X+115, DrawY+5);
	Canvas.DrawText(WeaponModName, FALSE,,, TextRenderInfo);


	// Draw blobs indicating skill progression
	for( i = 0; i < WeaponMod.static.GetMaxModLevelUI(); ++i )
	{
		// so for here we need to go find this specific WeaponMod in the PRI's current set of weapon mods
		// and see if it is there and what the value it has currently is


		ModFromPRI = NPRI.GetModClass( CurrWeapon, WeaponMod, AmmoModLevel );

		if( ( i <= AmmoModLevel ) && ( ModFromPRI == WeaponMod ) )
		{
		    BlobOrigin.X = 0;
			BlobOrigin.Y = 132;
		}
		else
		{
			BlobOrigin.X = 20;
			BlobOrigin.Y = 132;
		}

		Canvas.SetDrawColor(255, 255, 255, 255);
		Canvas.SetPos(PageUIOrigin.X + 300 + (20*i), DrawY);
		Canvas.DrawTile(PageUIBlobTexture, 16, 32, BlobOrigin.X, BlobOrigin.Y, 16, 32);
	}
}


/** Move selection to earlier visible skill */
simulated function SelectPreviousWeaponModification(NanoPRI NPRI)
{
	local int i;
	for(i=SelectedWeaponModificationIndex-1; i >= 0; i--)
	{
		SelectedWeaponModificationIndex = i;
		return;
	}
}

/** Move selection to later visible skill */
simulated function SelectNextWeaponModification(NanoPRI NPRI)
{
	local int i;
	for(i=SelectedWeaponModificationIndex+1; i < WeaponModificationsCount; i++)
	{
		SelectedWeaponModificationIndex = i;
		return;
	}
}


/** Try and spend the points required to upgrade the currently selected skill */
simulated function AttemptUpgradeSelectedWeaponModification()
{
	local NanoPRI NPRI;
	local int CurrModLevel;

	// Grab the current selected skill
	NPRI = GetNanoPRI();
	NPRI.GetModClass( SelectedWeaponModificationWeaponClass, SelectedWeaponModificationWeaponModifierClass, CurrModLevel );

	//
	NPRI.ModifyWeaponModifications( SelectedWeaponModificationWeaponClass, SelectedWeaponModificationWeaponModifierClass, CurrModLevel+1 );
}

/** Try and spend the points required to upgrade the currently selected skill */
simulated function AttemptDowngradeSelectedWeaponModification()
{
	local NanoPRI NPRI;
	local int CurrModLevel;

	// Grab the current selected skill
	NPRI = GetNanoPRI();
	NPRI.GetModClass( SelectedWeaponModificationWeaponClass, SelectedWeaponModificationWeaponModifierClass, CurrModLevel );

	//
	NPRI.ModifyWeaponModifications( SelectedWeaponModificationWeaponClass, SelectedWeaponModificationWeaponModifierClass, CurrModLevel-1 );
}

///// NanoUIPage_Base interface


function HandlePageInput(name ButtonName)
{
	local NanoPRI NPRI;

	NPRI = GetNanoPRI();

	switch( ButtonName )
	{
	case 'DPad_Up':
		SelectPreviousWeaponModification(NPRI);
		break;

	case 'DPad_Down':
		SelectNextWeaponModification(NPRI);
		break;

	case 'A':
	case 'DPad_Right':
		AttemptUpgradeSelectedWeaponModification();
		break;

	case 'X':
	case 'DPad_Left':
		AttemptDowngradeSelectedWeaponModification();
		break;
	}
}

function PageShown()
{

}

function PageHidden()
{

}

function DrawPage()
{
	local NanoPRI NPRI;
	local int WpnIdx;
	local int i;
	local float DrawY, SvdX, SvdY;
	local class<NanoWeaponModifier> CurrentWeaponMod;
	local Canvas Canvas;

	local array< class<NanoWeaponModifier> > ListOfModifiers;
	local array< class<NanoWeapon> > ListOfWeaponsWeHaveModifiersFor;

	local class<NanoWeapon> CurrWeapon;

	Super.DrawPage();

	DrawButtonHelpBar(PageUIOrigin.X, PageUIOrigin.Y, "UPGRADE", TRUE, "DOWNGRADE", TRUE);

	NPRI = GetNanoPRI();
	Canvas = NanoHUD.Canvas;

	DrawY = PageUIOrigin.Y + 20;


	// this is some pain here guys!
	// so we need to go over all of the Modifiers we have and get the weapons they can modify
	// and once we have that we need to then look and see if we have that weapon
	// and if we have that weapon then we need to display it here with all of the modifiers we have
	// for now we will just do a whole ton of O(N) instead of making a large number of maps of maps of maps
	//

	// find all of the modifiers we have
	ListOfModifiers = NPRI.GetAllWeaponModifiers();

	ListOfWeaponsWeHaveModifiersFor = NPRI.GetWeaponsWeHaveModifiersFor();

	WeaponModificationsCount = 0;

	for( WpnIdx = 0; WpnIdx < ListOfWeaponsWeHaveModifiersFor.length; ++WpnIdx )
	{
		CurrWeapon = ListOfWeaponsWeHaveModifiersFor[WpnIdx];

		Canvas.SetPos(PageUIOrigin.X+60, DrawY);
		Canvas.SetDrawColor(128, 128, 128, 255);
		Canvas.DrawText(CurrWeapon.default.WeaponUIName, TRUE,,, TextRenderInfo);
		Canvas.SetDrawColor(255, 255, 255, 255);

		DrawY += 20.0;

		// so now check to see if any of our modifiers can modify this weapon
		for( i = 0; i < ListOfModifiers.length; ++i )
		{
			// if this modifier can modify CurrWeapon
			if( ListOfModifiers[i].default.WeaponsThisCanModify.Find( CurrWeapon ) != INDEX_NONE )
			{
				DrawWeaponModification( CurrWeapon, ListOfModifiers[i], DrawY, (SelectedWeaponModificationIndex == WeaponModificationsCount) );

				DrawY += 40.0;

				if( SelectedWeaponModificationIndex == WeaponModificationsCount )
				{
					CurrentWeaponMod = ListOfModifiers[i];
					SelectedWeaponModificationWeaponClass = CurrWeapon;
					SelectedWeaponModificationWeaponModifierClass = CurrentWeaponMod;
				}

				WeaponModificationsCount++;
			}
		}
	}




	// Draw remaining XP
	//Canvas.SetPos(SkillsUIOrigin.X+60, SkillsUIOrigin.Y+450);
	//Canvas.SetDrawColor(255, 255, 0, 255);
	//Canvas.DrawText("Available Xp:"@NPRI.AvailableXP,TRUE,,,TRUE);
	//if (CurrentSkill.CanSetSkill(TRUE,CurrentSkill.SkillLevel+1))
	//{
	//	Canvas.DrawText("Xp to upgrade:"@CurrentSkill.SkillLevels[CurrentSkill.SkillLevel].XPToNextLevel,TRUE,,,TRUE);
	//}
	//else
	//{
	//	Canvas.DrawText("Xp to upgrade: <no upgrade available>",TRUE,,,TRUE);
	//}

	// draw skill level description if available
	if( ( CurrentWeaponMod != none ) && (CurrentWeaponMod.default.WeaponModifierDescription != "") )
	{
		Canvas.SetPos(PageUIOrigin.X+400, PageUIOrigin.Y+20);
		Canvas.SetDrawColor(255, 255, 255, 255);
		Canvas.DrawText("Description:", TRUE,,, TextRenderInfo);
		SvdX = Canvas.CurX;
		SvdY = Canvas.CurY;
		Canvas.SetDrawColor(77,77,77,128);
		Canvas.DrawTile(Texture2D'EngineResources.WhiteSquareTexture',375,150,0,0,1.f,1.f);
		Canvas.SetPos(SvdX+5,SvdY+5);
		SvdX = Canvas.ClipX;
		Canvas.SetClip(PageUIOrigin.X+400+375,Canvas.ClipY);
		Canvas.SetDrawColor(255, 255, 255, 255);
		Canvas.DrawText(CurrentWeaponMod.default.WeaponModifierDescription, TRUE,,, TextRenderInfo);

		//if (CurrentSkill.CanSetSkill(TRUE,CurrentSkill.SkillLevel+1))
		//{
		//	Canvas.SetPos(Canvas.CurX,Canvas.CurY+15);
		//	Canvas.DrawText("Next level:"@CurrentSkill.SkillLevels[CurrentSkill.SkillLevel+1].SkillDescription,TRUE,,,TRUE);
		//}
		Canvas.SetClip(SvdX,Canvas.ClipY);
	}

}

defaultproperties
{
	PageName="MODS"
}