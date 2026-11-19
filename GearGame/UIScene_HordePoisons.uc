/**
 * Horde Poisons Screen
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_HordePoisons extends GearGFxMoviePlayer;

// --- Widget References ------------------------------
/** Reference to the credits view, which serves as our interface to the credits widgets */
var transient GFxObject     HordePoisonView;

// --- Localized Strings ------------------------------
/** The prefix that displays before the multiplier */
var localized string        ModPrefix;

/**
 * Called whenever a new widget is initialized in the movie
 * 
 * @param   WidgetName      Flash instance name of the widget being initialized
 * @param   WidgetPath      Full path of the widget in the movie
 * @param   Widget          Reference to the widget that was initialized.  If this widget is bound via WidgetBindings, it will be of the appropriate subclass
 * 
 * @return  Whether or not this widget was handled
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch( WidgetName )
	{
		case 'HordePoisonView':
			HordePoisonView = Widget;
			InitializeView();
			break;
		default:
			return FALSE;
	}

	return TRUE;
}

/**
 * Called when the view becomes valid.  Populates the data provider, which drives the content on the poisons screen
 */
function InitializeView()
{
	local int ModIterator;
	local GearGRI_Horde GRI;
	local class<GearHordeExtendedMutator> MutClass;
	local GFxObject DataProvider, Element;

	// Fade in the view
	ActionScript_FadeIn();

	// Get the info for the mods
	GRI = GearGRI_Horde(GetGRI());
	if (GRI != None)
	{
		// Create the data provider
		DataProvider = CreateArray();

		// Iterate over the mutators, and populate the data provider
		for (ModIterator = 0; ModIterator < 4; ModIterator++)
		{
			MutClass = GRI.ExtendedMutators[ModIterator].MutatorClass;
			if (MutClass != None)
			{
				// Create an entry for this item
				Element = CreateObject("Object");

				// Populate the data provider with 
				Element.SetString("ModDesc", MutClass.default.MutatorName);
				Element.SetString("ModMult", MutClass.default.ShowMultiplier ? GetFormattedMuliplierString(GRI.ExtendedMutators[ModIterator].Multiplier) : " ");
				Element.SetString("Icon", PathName(MutClass.default.MutatorIcon));

				// Add the element to the data provider
				DataProvider.SetElementObject(ModIterator, Element);
			}
		}

		// Send the data provider to ActionScript
		ActionScript_SetDataProvider(DataProvider);
	}
}

/**
 * Called to close the view, which will eventually call Callback_DoneFadingOut when the scene is ready to be truly closed
 */
function CloseView()
{
	ActionScript_FadeOut();
}

/** Returns the formatted version of the multiplier */
final function string GetFormattedMuliplierString(float Multiplier)
{
	local string StringToDraw;
	local float Remainder;

	StringToDraw = ModPrefix;
	StringToDraw $= int(Multiplier);
	StringToDraw $= ".";
	Remainder = Multiplier - int(Multiplier);
	Remainder *= 10;
	StringToDraw $= int(Remainder);

	return StringToDraw;
}

//==============================================================
// ActionScript Stubs
//==============================================================
function ActionScript_FadeIn()
{
	HordePoisonView.ActionScriptVoid("FadeIn");
}

function ActionScript_FadeOut()
{
	HordePoisonView.ActionScriptVoid("FadeOut");
}

function ActionScript_SetDataProvider(GFxObject DataProvider)
{
	HordePoisonView.ActionScriptVoid("SetDataProvider");
}

function Callback_DoneFadingOut()
{
	local GearHUDInvasion_Base HUD;

	HUD = GearHUDInvasion_Base(Outer);
	if( HUD != None )
	{
		HUD.CloseHordeModScene();
	}
}

defaultproperties
{
	bCaptureInput=FALSE

	CaptureKeys.Empty()
}
