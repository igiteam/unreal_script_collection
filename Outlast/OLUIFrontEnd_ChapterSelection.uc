class OLUIFrontEnd_ChapterSelection extends OLUIFrontEnd_Screen;

var localized string ChapterSelectionTitle;
var localized string LoadText;

var int SelectedIndex;
var transient array<string> SelectionNames;
var transient array<string> SelectionCPs;
var const array<string> MainChapters;
var const array<string> MainCPs;
var const array<string> DLCChapters;
var const array<string> DLCCPs;


var transient GFxClikWidget ChapterList;
var transient GFxClikWidget BackButton;
var transient GFxClikWidget LoadButton;
var transient GFxObject TitleLabel;

function OnTopMostView(optional bool bPlayOpenAnimation /* = false */)
{
	PopulateChapterList();
	Super.OnTopMostView(bPlayOpenAnimation);
}

function OnViewDeactivated()
{	
}

function Pop()
{
	if (MenuManager != none)
	{
		MenuManager.PopView();        
	}
}


function PopulateChapterList()
{
	local GFxObject Obj, DataProvider;
	local int bHasFinishedGame;
	local int bHasFinishedDLC;
	local int idx;
	local int i;

	GetOLPC().ProfileSettings.GetProfileSettingValueId(PSI_FinishedGame, bHasFinishedGame);
	GetOLPC().ProfileSettings.GetProfileSettingValueId(PSI_FinishedDLC, bHasFinishedDLC);

	DataProvider = CreateArray();
	SelectionNames.Length = 0;
	idx = 0;
	
	if (bHasFinishedGame == 1)
	{
		for (i = 0; i < MainChapters.length; ++i)
		{
			SelectionNames[idx] = Localize("Locations", MainChapters[i], "OLGame");
			SelectionCPs[idx] = MainCPs[i];
			Obj = CreateObject("Object");
			Obj.SetString("label", SelectionNames[idx]);
			DataProvider.SetElementObject(i, Obj);

			idx++;
		}
	}

	if (class'OLUtils'.static.IsDLCInstalled() && bHasFinishedDLC == 1)
	{
		for (i = 0; i < DLCChapters.length; ++i)
		{
			SelectionNames[idx] = "+ " $ Localize("Locations", DLCChapters[i], "OLGame");
			SelectionCPs[idx] = DLCCPs[i];
			Obj = CreateObject("Object");
			Obj.SetString("label", SelectionNames[idx]);
			DataProvider.SetElementObject(idx, Obj);

			idx++;
		}
	}

	ChapterList.SetObject("dataProvider", DataProvider);

	if (class'OLUtils'.static.IsConsole())
	{
		SelectedIndex = -1;
		ChapterList.SetFloat("selectedIndex", -1);
	}
	else
	{
		ChapterList.SetFloat("selectedIndex", 0);
		SetSelectedIndex(0);
	}
}

function ChapterListChanged(GFxClikWidget.EventData ev)
{
	local GFxObject Group;
	local GFxObject Button;
	local int Index;

	if (!class'OLUtils'.static.IsConsole())
	{
		Group = ChapterList.GetObject("group");

		if (Group == None)
		{
			return;
		}

		Button = Group.GetObject("selectedButton");

		if (Button == None)
		{
			return;
		}

		Index = int(Button.GetFloat("index"));

		if (SelectedIndex != Index)
		{
			SetSelectedIndex(Index);	
		}
	}
}


function SetSelectedIndex(int Index)
{
	SelectedIndex = Index;
}

function LoadSelectedChapter()
{
	local string StartCPName;

	if (SelectedIndex >= 0 && SelectedIndex < SelectionCPs.length)
	{
		StartCPName = SelectionCPs[SelectedIndex];

		`log("### SELECTED CHAPTER CP: " $ StartCPName);

		MenuManager.MainMenuView.StartCPName = StartCPName;
		MenuManager.DifficultySelectionView.bSpecificChapter = true;
		MenuManager.PushViewByName('DifficultySelectionScreen');
	}
}

private final function Press_Load(GFxClikWidget.EventData ev)
{
	LoadSelectedChapter();
}

function Press_Back(GFxClikWidget.EventData ev)
{
	Back();
}


event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	local int Index;

	if (class'OLUtils'.static.IsConsole() && ButtonName == 'XboxTypeS_A' && InputEvent == IE_Released)
	{
		Index = int(ChapterList.GetFloat("selectedIndex"));

		SetSelectedIndex(Index);
		LoadSelectedChapter();
		return true;
	}

	return super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{    
	local bool bWasHandled;
	bWasHandled = true;

	switch(WidgetName)
	{
	case ('backBtn'):
		BackButton = GFxClikWidget(Widget);
		BackButton.AddEventListener('CLIK_press', Press_Back);
		BackButton.SetString("label", BackText);
		break;
	case ('loadBtn'):
		LoadButton = GFxClikWidget(Widget);
		LoadButton.AddEventListener('CLIK_press', Press_Load);
		LoadButton.SetString("label", LoadText);
		break;
	case ('TitleLabel'):
		TitleLabel = Widget;
		TitleLabel.SetString("text", ChapterSelectionTitle);
		break;
	case ('saveList'):
		ChapterList = GFxClikWidget(Widget);
		PopulateChapterList();
		ChapterList.AddEventListener('CLIK_change', ChapterListChanged);
		ChapterList.AddEventListener('CLIK_itemDoubleClick', Press_Load);
		break;
	default:
		bWasHandled = false;
	}

	if (!bWasHandled)
	{
		bWasHandled = Super.WidgetInitialized(WidgetName, WidgetPath, Widget);  
	}
	return bWasHandled;
}

defaultproperties
{
	SubWidgetBindings.Add((WidgetName="backBtn",WidgetClass=class'GFxClikWidget'))
	SubWidgetBindings.Add((WidgetName="loadBtn",WidgetClass=class'GFxClikWidget'))
	SubWidgetBindings.Add((WidgetName="saveList",WidgetClass=class'GFxClikWidget'))

	MainChapters.Add("Admin");
	MainChapters.Add("Prison");
	MainChapters.Add("Sewer");
	MainChapters.Add("Male");
	MainChapters.Add("Courtyard");
	MainChapters.Add("Female");
	MainChapters.Add("AdminRevisit");
	MainChapters.Add("Lab");

	MainCPs.Add("StartGame");
	MainCPs.Add("Prison_Start");
	MainCPs.Add("Sewer_Start");
	MainCPs.Add("Male_Start");
	MainCPs.Add("Courtyard_Start");
	MainCPs.Add("Female_Start");
	MainCPs.Add("Revisit_Soldier1");
	MainCPs.Add("Lab_Start");
	
	DLCChapters.Add("DLC_Lab");
	DLCChapters.Add("DLC_Hospital");
	DLCChapters.Add("DLC_Courtyard1");
	DLCChapters.Add("DLC_Prison");
	DLCChapters.Add("DLC_Courtyard2");
	DLCChapters.Add("DLC_Building2");
	DLCChapters.Add("DLC_Exit");

	DLCCPs.Add("DLC_Start");
	DLCCPs.Add("Hospital_Start");
	DLCCPs.Add("Courtyard1_Start");
	DLCCPs.Add("PrisonRevisit_Start");
	DLCCPs.Add("Courtyard2_Start");
	DLCCPs.Add("Building2_Start");
	DLCCPs.Add("MaleRevisit_Start");
}
