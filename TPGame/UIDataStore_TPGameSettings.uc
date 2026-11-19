class UIDataStore_TPGameSettings extends UIDataStore_GameResource
	native
//	implements(UIListElementCellProvider)
	Config(Game);

//var config array<string> MapList;
/** Used to compare against list elements, we only return elements that have the same filter as us. */
var transient int CurrentFilter;

/** Whether or not we should attempt to save a checkpoint. */
var transient int ShouldSave;

/** Whether or not we've displayed the storage device error to the player yet. */
var transient int		DisplayedStorageDeviceError;

/** Used to determine which map we should load when the user starts the game. */
var transient string	CurrentMapName;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

