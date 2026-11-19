class OLTutorialManager extends Object
	native
	config(Game);

var config bool bTutorialsEnabled;

var int CurrentId; // Used so that stale calls to Remove() don't clear a newer tutorial
var string TutorialText; // localized

var array<string> CompletedTutorials; // localized

var bool bActiveTutorial;
var float TutorialItemTimestamp; // when > 0, will automatically deactivate the item

var bool bBatteryTutorialComplete;
var bool bClimbUpTutorialComplete;
var bool bDocumentTutorialComplete;

var int ClimbUpTutorialItemIdx;

var const float DefaultTutorialDuration;

var localized string BatteriesTutorialText;
var localized string ClimbUpTutorialText_Keyboard;
var localized string ClimbUpTutorialText_Gamepad;

var const name DocumentTutorialTextId;

cpptext
{	
	INT AddItem(const FString& text); // Externally managed duration (AddItem/RemoveItem). Localized text. Returns the id	
	UBOOL RemoveItem(INT id);
	INT AddPunctualItem(const FString& text); // Automatically managed duration. Localized text.

	void BatteryTutorial();
	void ClimbUpTutorial();
	void ConditionalClimbUpTutorialCompleted();
	void ConditionalDocumentTutorial();

	void Tick(FLOAT deltaTime);

	void ClearAll();
}

native function Clear();

defaultproperties
{
	CurrentId=1
	DefaultTutorialDuration=5.0
	DocumentTutorialTextId=Tutorial_Documents
}