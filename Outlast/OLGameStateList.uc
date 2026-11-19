class OLGameStateList extends Actor
	placeable
	native
	dependson(OLCheckpointList);

struct native OLGameState
{
	var() name Name;
	var() name AutoActivateOnCheckpointReached;
	var() bool bPersistAfterDeath;

	var transient bool bActivated;
};

var() array<OLGameState> GameStateList;
var() OutlastGameType GameType;

cpptext
{
	virtual void PostBeginPlay();
	virtual void BeginDestroy();
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	static UBOOL IsGameStateValid(const FName& gsName); 
	static UBOOL IsGameStateActivated(const FName& gsName); 
	static void ActivateGameState(const FName& gsName, UBOOL bTriggerApplyEvents);
	static void ApplyCheckpoint(); // activate all as prescribed by checkpoint (no deactivation). Trigger kismet ApplyGameState events.
	static void TriggerApplyGameStateEvent(class UOLSeqEvent_ApplyGameState* applyGSEvent);
	
	static void DisplayDebug(UCanvas* canvas);
	
	static TArray<FOLGameState>* GetGameStateList();
	static void SetGameStateList(const TArray<FName>& activatedGS);
	static FOLGameState* GetGS(const FName& gsName);

	static void SetEffectiveList(UBOOL bPlayingDLC);
}

native static function DumpGameState();
native static function ResetAllGameState(); // Resets everything (including persisting) - e.g. when loading a savegame
native static function OnPlayerDeath(); // reset all non-persisting, if checkpoint is unreached. does not trigger kismet.