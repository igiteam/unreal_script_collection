/**
 * This guy received various events and then will pop up a tutorial screen if those events come true.
 *
 * (e.g. you have just earned 1k exp.  Let's go buy some skills!,  You have some cash
 *
 *
 * To use: NanoGRI(WorldInfo.GRI).NTM.HandleTutorialEvent( ETutorialEventType, Amount );
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoTutorialManager extends Actor
	config(Game);


// would be nice to link these to MCP land 
// once we get MCP using enums we should be able to do that
// everything using enums and then we can look up by name in MCP 
// but pass around the "event type" enum to all of these various function
// so it it using MCP enums for how to handle things
enum ETutorialEventType
{
	EET_First1000EXP,
	EET_First1000Currency,
	EET_FirstRebelMindShare,
	EET_FirstReviveAtSafeHouse,
	EET_SomeoneGrabbedYourRebelHandPrint,
	EET_AssuranceGameStarted,
	EET_DailyPlay_12Nano,
	EET_DailyPlay_2ForgeCores,

	EET_SuperRebelBomb_Found,
	EET_SuperRebelBomb_UnlockedByMobile,
};

struct TutorialDatum
{
	var ETutorialEventType Type;
	var int AmountNeeded;

	var String Title;
	var array<string> BodyText;

	var float DelayTime;

	structdefaultproperties
	{
		DelayTime=5.0f
	}

};

var config array<TutorialDatum> Tutorials;



function HandleTutorialEvent( const ETutorialEventType InType, int InAmountJustGained )
{
	local NanoGRI NGRI;
	local NanoMCP MCP;
	local string UserName;
	local int CurrValue;
	local int AmountToTriggerTutorial;
	local bool bShowTutorial;
	local NanoPC PC;
	local string RebelHandPrintUser;

	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	MCP = NGRI.MCP;
	UserName = class'NanoTypes'.static.GetLocalPlayerUserName();

	// hack for now

	// get the value of the Type
	switch( InType )
	{
	case EET_First1000EXP:
		MCP.FindIntValue( UserName, class'NanoMCPKeys'.default.EXP, CurrValue );
		AmountToTriggerTutorial = 1000;
		break;

	case EET_First1000Currency:
		MCP.FindIntValue( UserName, class'NanoMCPKeys'.default.Currency, CurrValue );
		AmountToTriggerTutorial = 1000;
		break;

	case EET_FirstRebelMindShare:
		MCP.FindIntValue( UserName, class'NanoMCPKeys'.default.RebelMindShareLevel, CurrValue );
		AmountToTriggerTutorial = 1;
		break;

	case EET_FirstReviveAtSafeHouse:
		MCP.FindIntValue( UserName, class'NanoMCPKeys'.default.NumRevivesAtSafeHouse, CurrValue );
		AmountToTriggerTutorial = 1;
		break;

	case EET_SomeoneGrabbedYourRebelHandPrint:
		CurrValue = -10; // don't trigger by default

		MCP.FindStringValue( UserName, class'NanoMCPKeys'.default.RebelHandUsedBy, RebelHandPrintUser );
		if( RebelHandPrintUser != "" ) // if someone has grabbed it
		{
			Tutorials[InType].BodyText[0] = RebelHandPrintUser @ Tutorials[InType].BodyText[0];
			// auto trigger
			CurrValue = 0;
			AmountToTriggerTutorial = 0;
		}
		break;


	case EET_SuperRebelBomb_UnlockedByMobile:
		CurrValue = -10; // don't trigger by default

		MCP.FindStringValue( "", class'NanoMCPKeys'.default.RebelSuperBombForge_UnlockedBy, RebelHandPrintUser ); // looking to see if mobile sent a decrypted bomb back
	
		Tutorials[InType].BodyText[1] = RebelHandPrintUser $ Tutorials[InType].BodyText[1];
		// auto trigger
		CurrValue = 0;
		AmountToTriggerTutorial = 0;
		
		break;






	case EET_AssuranceGameStarted:
		CurrValue = 0;
		AmountToTriggerTutorial = 0;
		MCP.FindStringValue( UserName, class'NanoMCPKeys'.default.CurrentAssuranceGamePartner, RebelHandPrintUser );
		Tutorials[InType].BodyText[0] = Tutorials[InType].BodyText[0] @ RebelHandPrintUser;

		break;

	}

	// we want to check the previous value.

	// if we now have more than amount to trigger
	if( CurrValue >= AmountToTriggerTutorial )
	{
		// check to see if the previous amount was less than amount to trigger
		// if it is higher then we have already seen this tutorial
		// we need to use the < and not <= otherwise the second time we get an event we will display this also
		// so we fix that by checking to see if we ever landed on the amount exactly
		if( ( ( CurrValue - InAmountJustGained ) < AmountToTriggerTutorial )
			|| ( CurrValue == AmountToTriggerTutorial )
			)
		{
			bShowTutorial = TRUE;
		}
	}

	// trigger amount 1000
	// start at 0
	// earn 1000
	// -> We want trigger!
	// >=   YES
	// 1000 - 1000 <= 1000  YES
	//  TRIGGER
	//
	//  Earn 1
	//  -> we do not want trigger
	//  => yes
	//  1001 - 1  < 1000 YES

	// 999
	// 1


	if( bShowTutorial == TRUE )
	{

		PC = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetNanoPC();

		PC.MyNanoHUD.ShowTutorial( Tutorials[InType].Title, Tutorials[InType].BodyText, Tutorials[InType].DelayTime, TRUE );
	}

}




defaultproperties
{
}