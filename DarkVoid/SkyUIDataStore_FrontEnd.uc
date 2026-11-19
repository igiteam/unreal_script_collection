class SkyUIDataStore_FrontEnd extends UIDataStore
    transient
    native
    config(Game);

var private native const noexport Pointer VfTable_IUIListElementProvider;
var private native const noexport Pointer VfTable_IUIListElementCellProvider;
var private native const noexport Pointer VfTable_FCallbackEventDevice;
var config array<config string> MP_Maps;
var transient string MP_Mode;
var transient string SPLIT_1IsIn;
var transient string SPLIT_2IsIn;
var transient string SPLIT_3IsIn;
var transient string SPLIT_4IsIn;
var transient string CurrentJournalEntry;
var transient SkyCustomControllerManager.ECustomControllerLayouts CurrentLayout;
var transient int CurrentBinding;
var transient name CurrentModifier;
var UIScene MainMenuScene;
var UIScene PauseMenuScene;
var UIScene CinePauseMenuScene;
var UIScene SavingProfileScene;
var transient UIScene OpenSavingProfileScene;
var UISkin UISkinRef;
var UIDataProvider_SkyGameSaves SaveGamesProvider;
var SkyCustomControllerManager CustomControllerProvider;
var transient array<CustomControllerLayout> DefaultControllerLayouts;
var transient SkyPlayerControllerBase CurrentController;
var transient int Resolutions;
var config int TexLOD;
var config int MeshLOD;
var config int Shadows;
var config int Decals;
var config int FPSSetting;
var config int NVTurbulence;
var config int NVEffects;
var config int NVStereo;

// Export USkyUIDataStore_FrontEnd::execGetResolutions(FFrame&, void* const)
native function GetResolutions();
