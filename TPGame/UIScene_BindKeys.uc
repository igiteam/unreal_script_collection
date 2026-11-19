class UIScene_BindKeys extends UIScene_BaseFrontEnd;

struct BindInfo
{
	var name LabelName;
	var string BindCommand;
	var UILabel myLabel;
};

var array<BindInfo> BindLabels;

struct KeyName
{
	var string Key;
	var string Datastore;
};
var array<KeyName> KeyNames;
var UIScene_GrabKey GrabKeyScene;
var int CurrentIndex;

event InitScene()
{
	local int i;
	super.InitScene();

	for (i = 0; i < BindLabels.Length; i++)
	{
		BindLabels[i].myLabel = UILabel(FindChild(BindLabels[i].LabelName, true));
	}

	RefreshBindingLabels();
}

event SceneActivated( bool bInitialActivation )
{
	super.SceneActivated(bInitialActivation);
	RefreshBindingLabels();
}

static function string GetLocalizedKeyName(string myKeyName)
{
	local int i;
	for (i = 0; i < default.KeyNames.Length; i++)
	{
		if (default.KeyNames[i].Key ~= myKeyName)
			return Localize("OptionsGrabKey", default.KeyNames[i].Datastore, "TPGame");
	}

	return "";
}

function RefreshBindingLabels()
{
	local int i;
	local string NewVal;
	local string LocalizedVal;
	//`log("Calling REFRESHBINDINGLABELS!!");
	//`log("myTPC is"@myTPC@"length is"@BindLabels.Length);
	if (myTPC != None)
	{
		for (i = 0; i < BindLabels.Length; i++)
		{
			NewVal = string(myTPC.GetNonControllerBinding(BindLabels[i].BindCommand));
			if (NewVal == "LeftShift")
				NewVal = "Shift";

			LocalizedVal = static.GetLocalizedKeyName(NewVal);
			if (LocalizedVal != "")
				BindLabels[i].myLabel.SetValue(LocalizedVal);
			else
				BindLabels[i].myLabel.SetValue(NewVal);

			if (NewVal == "None")
			{
				BindLabels[i].myLabel.StringRenderComponent.SetColor(MakeLinearColor(1.0f, 0.0f, 0.0f, 1.0f));
			}
			else
			{
				BindLabels[i].myLabel.StringRenderComponent.SetColor(MakeLinearColor(1.0f, 1.0f, 1.0f, 1.0f));
			}
		}
	}
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	CurrentIndex = MenuIndex;
	DisplayGrabKey(MenuItems[MenuIndex].wMenuButton.GetDatastoreBinding());
}

function DisplayGrabKey(string BindMarkup)
{
	local UIScene TempScene;
	local UIScene_GrabKey KeyScene;
	
	if ( SceneClient.OpenScene( GrabKeyScene, LocPlayer, TempScene ) )
	{
		FadeInactive();
		KeyScene = UIScene_GrabKey(TempScene);
		if (KeyScene != None)
		{
			KeyScene.FadeIn(true);
			KeyScene.SetVisibility(true);
			KeyScene.OnSceneClose = Restore;
			KeyScene.SetKeyDatastoreBinding(BindMarkup);

			KeyScene.OnResults = OnGrabKeyResults;
		}
	}
}

function OnGrabKeyResults(int PlayerIndex, name ReturnButton)
{
	if (ReturnButton != '')
	{
		//`log("Binding"@string(ReturnButton)@"to"@BindLabels[CurrentIndex].BindCommand);
		myTPC.SetNonControllerBinding(ReturnButton, BindLabels[CurrentIndex].BindCommand);
		RefreshBindingLabels();
	}
}

