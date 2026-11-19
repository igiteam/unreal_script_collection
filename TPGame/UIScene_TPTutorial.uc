class UIScene_TPTutorial extends UIScene_BaseHudScene;

var UILabel TutorialText;
struct KeyBindingPair
{
	var string Key;
	var string Binding;
};

var array<KeyBindingPair> Bindings;
var string NewText;

event InitScene()
{
    Super.InitScene();
	TutorialText = UILabel(FindChild('TutorialText', true));
	
	ReplaceButtons();
	SetVisibility(TRUE);
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	super.UpdateScene(DeltaTime, WorldInfo);
	TutorialText.StringRenderComponent.SetValue(NewText);
}

function ReplaceButtons()
{
	local int CurrConfig;
	local TPPlayerController myTPC;
	local int i;
	local string KeyName, LocKeyName;

	myTPC = GetPC();

	myTPC.ProfileSettings.GetProfileSettingValueId(class'TPProfileSettings'.const.ControllerConfigType, CurrConfig);
	NewText = TutorialText.StringRenderComponent.GetValue(true);

	if (GetWorldInfo().IsConsoleBuild() || myTPC.PlayerInput.bUsingGamepad)
	{
		// just need to do button swaps
		if (CurrConfig == TPCO_Alternate || CurrConfig == TPCO_AlternateSouthPaw)
		{
			NewText = Repl(NewText, "$", "#"); // $ = A
			NewText = Repl(NewText, "%", "$"); // % = B
			NewText = Repl(NewText, "#", "%");
		}

		if (CurrConfig == TPCO_DefaultSouthPaw || CurrConfig == TPCO_AlternateSouthPaw)
		{
			NewText = Repl(NewText, "?", "#"); // ? = RT
			NewText = Repl(NewText, "+", "("); // + = RB

			NewText = Repl(NewText, "&", "?"); // & = LT
			NewText = Repl(NewText, "*", "+"); // * = LB

			NewText = Repl(NewText, "#", "&");
			NewText = Repl(NewText, "(", "*");

			NewText = Repl(NewText, "{", "^"); // { = Press right stick, ^ = Press left (which does nothing unless southpaw)!
		}
		
		if( GetWorldInfo().IsPS3Build() )
		{
			//if( Left(NewText, 13)=="Vampir Sniper" )
			if( myTPC.TutorialMarkup == "<Strings:TPGame.Tutorials.NYES_IR>" )
			{
				//On PS3, for the Vampir Sniper string only, we replace the Right-stick icon with the R3 button.  You're killing me Larry...
				NewText = Repl(NewText, "{", "?");
			}
		}
	}
	else
	{
		// Keyboard binding fun!
		// First, replace ~ (DPAD grapple) symbol with moveforward/backward for the hax
		NewText = Repl(NewText, "~", "(/)");
		
		NewText = Repl(NewText, "^", "(");

		// Now go through our array and replace any keys with the corresponding binding
		for (i = 0; i < Bindings.Length; i++)
		{
			KeyName = string(myTPC.GetNonControllerBinding(Bindings[i].Binding));
			LocKeyName = class'UIScene_BindKeys'.static.GetLocalizedKeyName(KeyName);
			if (LocKeyName != "")
				NewText = Repl(NewText, Bindings[i].Key, "[" $ LocKeyName $ "]");
			else
				NewText = Repl(NewText, Bindings[i].Key, "[" $ KeyName $ "]");
		}
	}

	TutorialText.StringRenderComponent.SetValue(NewText);
}


