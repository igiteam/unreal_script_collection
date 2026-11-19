/**
 * The FrontEnd class that kicks off the main movie
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_SiegeCharSelect extends GearGFxMoviePlayer;

//Labels
var GFxObject NumPoints_Label;
//var GFxObject PointsRemaining_Label;
//var GFxObject SelectedCharName_Label;
var GFxObject ButtonA_Label;
var GFxObject WaveNum_Label;
var GFxObject Enemies_Label;
var GFxObject EnemiesNum_Label;

//CharSelect Tiles
var UIWidget_SiegeCharSelectTiles CharTilesMovie;

//The containing object for all of our widgets. Used to provide easy access to actionscriptscript functionality.
var GFxObject MainBag;

//References to the category labels
var array<GFxObject> CategoryLabels;


//Localized Strings
var localized array<String> CategoryStrings;
var localized String Purchase_String;
var localized String PointsRemaining_String;
var localized String Wave_String;
var localized String Enemies_String;

//The Siege Game we are currently playing
var class<GearGameSiege_Base> SiegeGameClass;

//References to the character portraits.
var array<Texture2D> CharacterPortraits;

/** set when a character has been selected and the UI is closing */
var bool bCharacterSelected;

/** Initialized widget callback
 *  @return Returns true if the callback is handled at this level
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local int CategoryLabelIndex;
	local string CategoryNumber, Temp;

	`log("SiegeCharSelect WidgetInitialized: "$WidgetName,,'GearsUI');
	switch (WidgetName)
	{
	case 'MainBag':
		MainBag = Widget;
		break;
	case 'NumPoints_Label':
		NumPoints_Label = Widget;
		break;
	/*
	case 'PointsRemaining_Label':
		PointsRemaining_Label = Widget;
		PointsRemaining_Label.SetString("text",PointsRemaining_String);
		break;
	case 'SelectedCharName_Label':
		SelectedCharName_Label = Widget;
		break;
	*/
	case 'CharacterTiles':
		CharTilesMovie = UIWidget_SiegeCharSelectTiles(Widget);
		CharTilesMovie.SiegeCharSelectScene = self;
		CharTilesMovie.SiegeGameClass = SiegeGameClass;
		SetWidgetPathBinding(CharTilesMovie, WidgetPath);
		break;
	case 'Category':
		Temp = Mid(WidgetPath, InStr(WidgetPath,"catBag")+6);
		CategoryNumber = Left(Temp,InStr(Temp,"."));
		CategoryLabelIndex = int(CategoryNumber);
		if (CategoryLabels.Length < CategoryLabelIndex)
		{
			CategoryLabels.Length = CategoryLabelIndex;
		}
		CategoryLabels[CategoryLabelIndex-1] = Widget;
		Widget.SetString("text", CategoryStrings[CategoryLabelIndex-1]);
		break;
	case 'ButtonAText':
		ButtonA_Label = Widget;
		ButtonA_Label.SetString("htmlText",Purchase_String);
		break;
	case 'WaveNum':
		WaveNum_Label = Widget;
		UpdateWave();
		break;
	case 'Enemies_Label':
		Enemies_Label = Widget;
		Enemies_Label.SetString("text",Enemies_String);
		break;
	case 'EnemyValue_Label':
		EnemiesNum_Label = Widget;
		UpdateEnemyCount();
		break;
	default:
		return false;
	}
	return true;
}

//Let the tile list know its time to rock and roll.
function PostWidgetInit()
{
	CharTilesMovie.SubPostWidgetInit();
	//SelectedCharName_Label.SetString("text",CharTilesMovie.DataProvider.GetElementMemberString(CharTilesMovie.FirstFocus,"Name"));
}

//Callback from actionscript when a character was selected
function Callback_CharacterWasSelected(int CharIndex)
{
	local GearPC_Siege MyPC;
	local class<Pawn> PawnClass;

	bCharacterSelected = true;

	MyPC = GearPC_Siege(GetPC());
	if (MyPC != none)
	{
		//Remember who we selected for next time
		MyPC.LastCharSelected = CharIndex;
		MyPC.ServerChooseClass(CharIndex);
		// Figure out the pawn class so we can prestream the textures
		PawnClass = class'GearGameSiege_Base'.static.DeterminePawnClass(CharIndex);
		if (PawnClass != None)
		{
			MyPC.ClientPrestreamTexturesFor(PawnClass);
		}
		else
		{
			`Warn("Invalid Siege character selected");
		}
	}
}

//Callback from actionscript when the pause menu should be opened
function Callback_OpenPauseMenu()
{
	local GearPC_Siege MyPC;

	`log("SiegeCharSelect OpenPauseMenu",,'GearsUI');

	MyPC = GearPC_Siege(GetPC());
	MyPC.MyGearHud.PauseGame();
}

//Callback from actionscript when the scene has finished fading out
function Callback_DoneFadingOut()
{
	local GearPC_Siege MyPC;

	MyPC = GearPC_Siege(GetPC());
	MyPC.CharSelectMovie = None;
	Close();
}

//Update everything in the UI to take into account the number of points you have
function UpdateNumPoints()
{
	local ASValue AValue;
	local Array<ASValue> args;
	local int PointsLeft;
	local GearPC_Siege GPC_S;
	local GearPRI_Siege PRI_S;

	CharTilesMovie.UpdateLockedStatus();

	PointsLeft = -1;
	GPC_S = GearPC_Siege(GetPC());
	if (GPC_S != NONE)
	{
		PRI_S = GearPRI_Siege(GPC_S.PlayerReplicationInfo);
		if (PRI_S != NONE)
		{
			PointsLeft = PRI_S.WavePointsRemaining;
		}
	}

	AValue.s = PointsRemaining_String;
	AValue.Type = AS_String;
	args.AddItem(AValue);
	AValue.n = PointsLeft;
	AValue.Type = AS_Number;
	args.AddItem(AValue);
	MainBag.Invoke("UpdatePoints",args);
}

//Update the wave label to the current wave
function UpdateWave(optional int WaveNum=-1)
{
	local GearGRI_Horde GRI;
	local PlayerController PC;

	PC = GetPC();
	if (WaveNum == -1)
	{
		GRI = GearGRI_Horde(PC.WorldInfo.GRI);
		if(GRI != None)
		{
			WaveNum = GRI.InvasionCurrentWaveIndex;
		}
	}

	WaveNum_Label.SetString("text",Wave_String@String(WaveNum));
}

//Update the enmies lable to the current num of enemies
function UpdateEnemyCount(optional int EnemyCount=-1)
{
	local GearGRI_Horde GRI;
	local PlayerController PC;

	PC = GetPC();
	if (EnemyCount == -1 && PC != None)
	{
		GRI = GearGRI_Horde(PC.WorldInfo.GRI);
		if(GRI != None)
		{
			EnemyCount = GRI.EnemiesLeftThisRound;
		}
	}

	EnemiesNum_Label.SetString("text",String(EnemyCount));
}

//Something has happened with the other players, update their status indicators
function OtherPlayersStatusChanged()
{
	if (CharTilesMovie != none)
	{
		CharTilesMovie.OtherPlayersStatusChanged(true);
	}
}

/** 
 * Overridden so we can eat input we don't want the front end to get
 *
 * @param   ControllerId    The Id of the controller that the input came from
 * @param   ButtonName      The name of the button that was hit
 * @param   InputEvent      What type of input event was this (e.g. pressed, released)
 * 
 * @return  TRUE if the input should be trapped and not passed on, FALSE to pass it on to GFx for handling
 */
event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	// Eat the BACK button
	if (ButtonName == 'XboxTypeS_Back')
	{
		return true;
	}

	return false;
}

defaultproperties
{
	WidgetBindings.Add((WidgetName="CharacterTiles",WidgetClass=class'UIWidget_SiegeCharSelectTiles'))

	CaptureKeys.Empty()
	CaptureKeys(0)=XboxTypeS_Start
	CaptureKeys(1)=XboxTypeS_A
	CaptureKeys(2)=XboxTypeS_B
	CaptureKeys(3)=XboxTypeS_X
	CaptureKeys(4)=XboxTypeS_Y
	CaptureKeys(5)=XboxTypeS_DPad_Up
	CaptureKeys(6)=XboxTypeS_DPad_Down
	CaptureKeys(7)=XboxTypeS_DPad_Right
	CaptureKeys(8)=XboxTypeS_DPad_Left
	CaptureKeys(9)=Gamepad_LeftStick_Up
	CaptureKeys(10)=Gamepad_LeftStick_Down
	CaptureKeys(11)=Gamepad_LeftStick_Right
	CaptureKeys(12)=Gamepad_LeftStick_Left

	bEnableMenuPostProcess=TRUE
	bPostProcessForAllLocalPlayers=TRUE
}
