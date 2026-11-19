/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoUIPage_Skills extends NanoUIPage_Base;


var transient int	SelectedSkillIndex;

/** Try and spend the points required to upgrade the currently selected skill */
simulated function AttemptUpgradeSelectedSkill()
{
	local NanoSkill Skill;

	// Grab the current selected skill
	Skill = GetNanoPawn().SkillList[SelectedSkillIndex].Skill;
	Skill.SetSkillLevel(FALSE, Skill.SkillLevel+1);
}

/** Try and spend the points required to upgrade the currently selected skill */
simulated function AttemptDowngradeSelectedSkill()
{
	local NanoSkill Skill;
	// Grab the current selected skill
	Skill = GetNanoPawn().SkillList[SelectedSkillIndex].Skill;
	Skill.SetSkillLevel(FALSE, Skill.SkillLevel-1);
}

simulated function MaxUpgradeAllSkills()
{
	local int SkillIdx;
	local NanoSkill Skill;
	local NanoPC PC;

	PC = GetNanoPC();
	for( SkillIdx = 0; SkillIdx < PC.MyNP.SkillList.Length; SkillIdx++ )
	{
		Skill = PC.MyNP.SkillList[SkillIdx].Skill;
		Skill.SetSkillLevel( TRUE, 99 );
	}
}


/** Draw one skill */
simulated function DrawSkill(NanoSkill Skill, float DrawY, bool bSelected)
{
	local Texture2D IconTex;
	local vector2D IconOrigin, IconSize, BlobOrigin;
	local string SkillName;
	local int i;
	local Canvas Canvas;

	Canvas = NanoHUD.Canvas;

	// Draw carat if this is the selected row
	if(bSelected)
	{
		Canvas.SetPos(PageUIOrigin.X+60, DrawY);
		Canvas.DrawTile(Texture2D'EngineResources.WhiteSquareTexture', 10, 32, 0.0, 0.0, 1.0, 1.0, PageUICaratLColor);
	}

	// Get icon info and draw it
	IconTex = Skill.GetIconInfo(IconOrigin, IconSize);
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.SetPos(PageUIOrigin.X+75, DrawY);
	Canvas.DrawTile(IconTex, 32, 32, IconOrigin.X, IconOrigin.Y, IconSize.X, IconSize.Y);

	// Draw name of skill
	SkillName = Skill.GetCurrentSkillName();
	Canvas.SetDrawColor(PageUITextColor.R, PageUITextColor.G, PageUITextColor.B, 255);
	Canvas.SetPos(PageUIOrigin.X+115, DrawY+5);
	Canvas.DrawText(SkillName, FALSE,,, TextRenderInfo);

	// Draw blobs indicating skill progression
	for(i=0; i<Skill.SkillLevels.length; i++)
	{
		if(i<=Skill.SkillLevel) // so this is busted as it implies that you automatically get a skill point
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
simulated function SelectPreviousSkill( NanoPawn NP )
{
	local int i;
	for( i = SelectedSkillIndex-1; i >= 0; i-- )
	{
		if( !NP.SkillList[i].Skill.bHideFromSkillUI)
		{
			SelectedSkillIndex = i;
			return;
		}
	}
}

/** Move selection to later visible skill */
simulated function SelectNextSkill(NanoPawn NP)
{
	local int i;
	for( i = SelectedSkillIndex + 1; i < NP.SkillList.Length; i++ )
	{
		if( !NP.SkillList[i].Skill.bHideFromSkillUI)
		{
			SelectedSkillIndex = i;
			return;
		}
	}
}

///// NanoUIPage_Base interface

function HandlePageInput(name ButtonName)
{
	local NanoPawn NP;

	NP = GetNanoPawn();
	switch( ButtonName )
	{
		case 'DPad_Up':
			SelectPreviousSkill(NP);
			break;

		case 'DPad_Down':
			SelectNextSkill(NP);
			break;

		case 'A':
		case 'DPad_Right':
			AttemptUpgradeSelectedSkill();
			break;

		case 'X':
		case 'DPad_Left':
			AttemptDowngradeSelectedSkill();
			break;

		case 'Y':
			MaxUpgradeAllSkills();
			break;
	}
}

function PageShown()
{
	local NanoPawn NP;

	// Make sure selected skill is visible
	NP = GetNanoPawn();
	if( NP != None && NP.SkillList[SelectedSkillIndex].Skill.bHideFromSkillUI )
	{
		SelectNextSkill(NP);
	}
}

function PageHidden()
{

}

function DrawPage()
{
	local NanoPRI NPRI;
	local int i;
	local float DrawY, SvdX, SvdY;
	local NanoSkill CurrentSkill;
	local NanoPawn NP;
	local Canvas Canvas;

	Super.DrawPage();

	DrawButtonHelpBar(PageUIOrigin.X, PageUIOrigin.Y, "UPGRADE", TRUE, "DOWNGRADE", TRUE);

	Canvas = NanoHUD.Canvas;
	NPRI = GetNanoPRI();
	NP = GetNanoPawn();

	DrawY = PageUIOrigin.Y + 20;
	for( i = 0; i < NP.SkillList.Length; i++ )
	{
		if( !NP.SkillList[i].Skill.bHideFromSkillUI )
		{
			DrawSkill( NP.SkillList[i].Skill, DrawY, (SelectedSkillIndex == i) );

			DrawY += 40.0;
		}
	}

	CurrentSkill = NP.SkillList[SelectedSkillIndex].Skill;

	// Draw remaining XP
	Canvas.SetPos(PageUIOrigin.X+60, PageUIOrigin.Y+450);
	Canvas.SetDrawColor(255, 255, 0, 255);
	Canvas.DrawText("Available XP:" @ NPRI.GetAvailEXP(), TRUE,,, TextRenderInfo);

	if (CurrentSkill.CanSetSkill(FALSE,CurrentSkill.SkillLevel+1))
	{
		// we are zero based so show level as 1 based
		Canvas.DrawText("XP to upgrade to level:"@CurrentSkill.SkillLevel+2@ " " @CurrentSkill.SkillLevels[CurrentSkill.SkillLevel+1].XPToNextLevel, TRUE,,, TextRenderInfo);
	}
	else
	{
		//Canvas.DrawText("Xp to upgrade: <no upgrade available>", TRUE,,, TextRenderInfo);
	}

	// draw skill level description if available
	if (CurrentSkill.SkillLevels[CurrentSkill.SkillLevel].SkillDescription != "")
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
		Canvas.DrawText(CurrentSkill.SkillLevels[CurrentSkill.SkillLevel].SkillDescription, TRUE,,, TextRenderInfo);
		if (CurrentSkill.CanSetSkill(TRUE,CurrentSkill.SkillLevel+1))
		{
			Canvas.SetPos(Canvas.CurX,Canvas.CurY+15);
			Canvas.DrawText("Next level:" @ CurrentSkill.SkillLevels[CurrentSkill.SkillLevel + 1].SkillDescription, TRUE,,, TextRenderInfo);
		}
		Canvas.SetClip(SvdX,Canvas.ClipY);
	}
}

defaultproperties
{
	PageName="SKILLS"
}
