class SwatGUIConfig extends Core.Object
    native
    config(SwatGuiState)
    HideCategories(Object)
    dependsOn(SwatStartPointBase);

import enum Pocket from Engine.HandheldEquipment;
import enum EEntryType from SwatStartPointBase;
import enum EMPMode from Engine.Repo;


//TODO: move this somewhere else
enum eDifficultyLevel
{
    DIFFICULTY_Easy,
    DIFFICULTY_Normal,
    DIFFICULTY_Hard,
    DIFFICULTY_Elite,
};

var(Difficulty) Config Localized String DifficultyString[eDifficultyLevel.EnumCount];
var(Difficulty) Config int DifficultyScoreRequirement[eDifficultyLevel.EnumCount];
var(Difficulty) Config eDifficultyLevel CurrentDifficulty;

//////////////////////////////////////////////////////////////////////////////////////
// Campaigns & SP Missions
//////////////////////////////////////////////////////////////////////////////////////
var(Missions) EditConst EditInline SwatMission CurrentMission   "The current mission selected for Single Player";

//these specify the campaign
var(Missions) config            array<Name>     MissionName     "Name used for this mission";
var(Missions) config localized  array<string>   FriendlyName    "Friendly name to display in the gui";

var(Missions) private Config    Name            LastMissionPlayedName           "The Name of the last mission that was played in Single Player";
var(Missions) private Config    String          LastMissionPlayedFriendlyName   "The friendly name of the last mission that was played in Single Player";
var(Missions) private Config    CustomScenario  LastMissionPlayedCustomScenario "The last Custom Scenario that was played in Single Player";

var(Missions) private           Name            CurrentMissionName           "The Name of the last mission that was played in Single Player";
var(Missions) private           String          CurrentMissionFriendlyName   "The friendly name of the last mission that was played in Single Player";
var(Missions) private           CustomScenario  CurrentMissionCustomScenario "The last Custom Scenario that was played in Single Player";

var(Missions) config array<Name> MissionResultNames;
var(Missions) array<MissionResults> MissionResults;

var(Missions) private EditConst EditInline CustomScenarioPack CurrentCustomScenarioPack   "The current CustomScenarioPack selected for Single Player";
var(Missions) private EditConst EditInline String PakName   "The name of the current CustomScenarioPack selected for Single Player";
var(Missions) private EditConst EditInline String PakFriendlyName   "The name of the current CustomScenarioPack selected for Single Player in friendly display format (without extension)";
var(Missions) private EditConst EditInline String PakExtension "The extension of the current CustomScenarioPack selected for Single Player";
var(Missions) private EditConst EditInline String ScenarioName "The current CustomScenario selected for Single Player";

// This value indicates which set of start points (primary or secondary)
// officers and players should use when entering a single player map.
var(Missions) private EEntryType DesiredSPEntryPoint;

var(Missions) Config Bool bEverRanTraining "true if the player ever ran training or click through it";


//////////////////////////////////////////////////////////////////////////////////////
// Loadout Options
//////////////////////////////////////////////////////////////////////////////////////
enum eNetworkValidity
{
    NETVALID_None,
    NETVALID_SPOnly,
    NETVALID_MPOnly,
    NETVALID_All,
};

var(Equipment) editconst array<SwatEquipmentSpec> AvailableEquipmentPockets "Specifies other available equipment";
var(Equipment) config array<String> CustomEquipmentLoadouts "Specifies custom equipment loadouts";
var(Equipment) localized config array<String> CustomEquipmentLoadoutFriendlyNames "Specifies custom equipment loadouts";
var(Equipment) config array<bool> LoadoutIsUndeletable "Specifies whether the loadout is undeletable";

//////////////////////////////////////////////////////////////////////////////////////
// Key Config Settings
//////////////////////////////////////////////////////////////////////////////////////
enum eCommandCategory
{
    COMCAT_Movement,
    COMCAT_Interactions,
    COMCAT_Chat,
    COMCAT_Reserved,
};

var(KeyConfigSettings) config           array<string>   CommandString "The string corresponding to the command this Input Function struct is representing";
var(KeyConfigSettings) config localized array<string>   LocalizedCommandString "The localized string corresponding to the command this Input Function struct is representing";
var(KeyConfigSettings) config array<eCommandCategory>   CommandCategory "The category of this command";

//////////////////////////////////////////////////////////////////////////////////////
// Audio Settings
//////////////////////////////////////////////////////////////////////////////////////
var(AudioSettings) config localized array<string> AudioVirtualizationChoices "Choices for audio virtualization";
var(AudioSettings) config localized array<string> SoundQualityChoices "Choices for sound quality";

//////////////////////////////////////////////////////////////////////////////////////
// Video Settings
//////////////////////////////////////////////////////////////////////////////////////
var(VideoSettings) config localized array<string> ScreenResolutionChoices "Choices for screen resolution";
var(VideoSettings) config localized array<string> TextureDetailChoices "Choices for texture detail";
var(VideoSettings) config localized array<string> OtherDetailChoices "Choices for other detail";
var(VideoSettings) config localized array<string> RenderDetailChoices "Choices for generic render detail";
var(VideoSettings) config localized array<string> PixelShaderChoices "Choices for pixel shaders";
var(VideoSettings) config localized array<string> RealtimeMirrorChoices "Choices for Realtime Mirrors";

//////////////////////////////////////////////////////////////////////////////////////
// Network Settings
//////////////////////////////////////////////////////////////////////////////////////

enum eVoiceType
{
    VOICETYPE_Random,
    VOICETYPE_Lead,
    VOICETYPE_OfficerRedOne,
    VOICETYPE_OfficerRedTwo,
    VOICETYPE_OfficerBlueOne,
    VOICETYPE_OfficerBlueTwo,
    VOICETYPE_VIP,
};


var(MPSettings) config localized array<string> VoiceTypeChoices "Choices for network voicetypes";
var(MPSettings) config           eVoiceType     PreferredVoiceType "Selected voicetype for network games";

// Caches the voice type to use when the user chooses "random" in the GUI. 
// If it's set to RANDOM, then it will be re-cached when next queried
var                               eVoiceType     CachedRandomVoice; 

var(MPSettings) config localized array<string> NetworkConnectionChoices "Choices for network connection";
var(MPSettings) config           array<int>    NetworkConnectionSpeeds "Speeds for network connection";
var(MPSettings) config           int           NetSpeedSelection "Selected speed for network connection";

var(MPSettings) Config float MPPostMissionTime "Time (in seconds) between when the round has been completed and the MPPage is brought up";
var(MPSettings) Config float MPPollingDelay "Time (in seconds) between information polls in MP";
var(MPSettings) bool    FirstTimeThrough "Simple switch to determine if the player is entering the server";

var(MPSettings) array<string> AvailableMPMaps "Choices for MP maps to play";

var(MPSettings) private Config string SwatMapFileExtension "File extension for swat maps";
var(MPSettings) private Config string SwatMPMapNamePrefix "Prefix for multiplayer maps (typically MP)";

var(MPSettings) Config localized string TDMDescription "Gametype Team Deathmatch game description. Newlines should be seperated by | (for now)";
var(MPSettings) Config localized string VIPDescription "Gametype VIP Escort game description. Newlines should be seperated by | (for now)";
var(MPSettings) Config localized string BombDescription "Gametype Diffuse Da Bomb game description. Newlines should be seperated by | (for now)";
var(MPSettings) Config localized string COOPDescription "Gametype COOP description. Newlines should be seperated by | (for now)";

var(MPSettings) Config localized string TDMFriendlyName "Gametype Team Deathmatch game FriendlyName.";
var(MPSettings) Config localized string VIPFriendlyName "Gametype VIP Escort game FriendlyName.";
var(MPSettings) Config localized string BombFriendlyName "Gametype Diffuse Da Bomb game FriendlyName.";
var(MPSettings) Config localized string COOPFriendlyName "Gametype COOP FriendlyName.";

var(MPSettings) Config localized string MPSuspectsWinMessage "The message to display when the suspects win";
var(MPSettings) Config localized string MPSWATWinMessage "The message to display when the SWAT team wins";
var(MPSettings) Config localized string MPTieMessage "The message to display when the game ends in a tie";


//////////////////////////////////////////////////////////////////////////////////////
// Game Settings
//////////////////////////////////////////////////////////////////////////////////////
var(GameSettings) Config Localized String MPName "The name the player will use for Multiplayer Games";
#if IG_CAPTIONS 
var(GameSettings) Config Bool bShowSubtitles "If true, subtitles will be displayed for in-game audio";
#endif
var(GameSettings) Config Bool bShowHelp "If true, help text will be displayed for each control";
var(GameSettings) Config Bool bAlwaysRun "If true, the player will run by default rather than walk";

var(GameSettings) int MPNameLength "The max length of the name the player will use for Multiplayer Games";
var(GameSettings) localized String MPNameAllowableCharSet "The allowable character set for the name the player will use for Multiplayer Games";

//////////////////////////////////////////////////////////////////////////////////////
// HUD Settings
//////////////////////////////////////////////////////////////////////////////////////
enum ECommandInterfaceStyle
{
    CommandInterface_Invalid,
    CommandInterface_Classic,
    CommandInterface_Graphic
};

var(HUDSettings) config ECommandInterfaceStyle CommandInterfaceStyle;
var(HUDSettings) EditConst ECommandInterfaceStyle CurrentCommandInterfaceStyle;
var(HUDSettings) Config int MessageDisplayTime "Time (in seconds) for messages to be displayed on the hud";
var(HUDSettings) Config int GCIButtonMode "Button Mode currently selected for the Graphical Command Interface";
var(HUDSettings) Config bool bUseExitMenu "Exit pad displayed the Graphical Command Interface";


//////////////////////////////////////////////////////////////////////////////////////
// Server Settings
//////////////////////////////////////////////////////////////////////////////////////

enum eConnectionType
{
    CONNECTION_Modem,
    CONNECTION_Cable,
    CONNECTION_DSL,
    CONNECTION_T1,
    CONNECTION_T3,
    CONNECTION_OC3,
};


//Generic Server Settings Information
var                 config String         AdminPassword "Admin Password for the server for authenticating users";

var(ServerSettings) editinline array<MapRotation> MapList "Maplists to cycle through - 1 per gametype";


struct native ServerFilters
{
    var() config int            MaxPing "Filter by max ping, -1 = dont filter by ping";
    var() config bool           bFull "Filter out full servers if true";
    var() config bool           bPassworded "Filter out passworded servers if true";
    var() config bool           bFilterGametype "Filter out gametype servers if true";
    var() config EMPMode        GameType "What game type to filter by";
    var() config bool           bHideIncompatibleVersions "Filter out incompatible by version servers if true";
    var() config bool           bHideIncompatibleMods "Filter out incompatible by mod servers if true";
};

var(ServerSettings) config ServerFilters theServerFilters "The current server filters";
var(ServerSettings) config bool          bViewingGameSpy "If true, the client is viewing the server list provided by GameSpy";


//////////////////////////////////////////////////////////////////////////////////////
// Game State
//////////////////////////////////////////////////////////////////////////////////////

enum eSwatGameState
{
    GAMESTATE_None,             //Not in game at all, GUI only
    GAMESTATE_EntryLoading,     //Currently loading the entry level
    GAMESTATE_LevelLoading,     //Currently loading a (non-entry) level
    GAMESTATE_PreGame,          //Level has loaded but round not yet begun
    GAMESTATE_MidGame,          //Game in progress
    GAMESTATE_PostGame,         //Level completed
    GAMESTATE_ClientTravel,     //Client is travelling to the new map on the server
    GAMESTATE_ConnectionFailed, //Client failed to connect to the server (remote OR local)
};

enum eSwatGameRole
{
    GAMEROLE_None,              //Not doing much of anything, GUI exclusive
    GAMEROLE_SP_Campaign,       //Playing through a campaign
    GAMEROLE_SP_Custom,         //Playing a custom mission
    GAMEROLE_SP_Other,          //Playing anything else on own (training)
    GAMEROLE_MP_Host,           //Playing as the host/admin in a MP game
    GAMEROLE_MP_Client,         //Playing as the client in a MP game
};

var(SwatGame) eSwatGameState SwatGameState;
var(SwatGame) eSwatGameRole  SwatGameRole;

var(SwatGame) config float CriticalMomentDelay "The amount of time after a critical moment to wait until popping out of the action (eg. to give players time to die)";

overloaded function Construct()
{
    local int i;
    
    AssertWithDescription( MissionName.Length == FriendlyName.Length, "The number of campaign MissionNames specified in SwatGUIState.ini does not match the number of FriendlyNames" );
    AssertWithDescription( MissionName.Length > 0, "There must be at least one valid campaign MissionNames specified in SwatGUIState.ini" );

    for( i = 0; i < Pocket.EnumCount; i++ )
    {
        AvailableEquipmentPockets[i] = new(,string(GetEnum(Pocket,i))) class'SwatGame.SwatEquipmentSpec';
    }
    
    AssertWithDescription( CustomEquipmentLoadoutFriendlyNames.Length == CustomEquipmentLoadouts.Length, "The number of Custom Loadouts does not match the number of Friendly Names specified in SwatGUIState.ini!");
    
	//TODO: clean this up later
    LoadLastMissionPlayed();
    
    //custom mission results
    for (i=0; i<MissionResultNames.Length; i++)
    {
        MissionResults[i] = new(,string(MissionResultNames[i])) class'SwatGame.MissionResults';

        Assert(MissionResults[i] != None);
    }
    
    for( i = 0; i < EMPMode.EnumCount; i++ )
    {
        MapList[i] = new(,string(GetEnum(EMPMode,i))) class'SwatGame.MapRotation';
    }
}

//////////////////////////////////////////////////////////////////////////////////////
// Accessors
//////////////////////////////////////////////////////////////////////////////////////
function SetCurrentMission( Name MissionName, optional string FriendlyName, optional CustomScenario CustomScenario )
{
log("[ckline] >>> SwatGUIConfig::SetCurrentMission('"$MissionName$"', '"$FriendlyName$"', '"$CustomScenario$"')");
    if( CurrentMission != None && 
        CurrentMission.Name == MissionName && 
        CurrentMission.FriendlyName == FriendlyName && 
        CurrentMission.CustomScenario == CustomScenario )
    {
        log("[carlos] >>> SwatGUIConfig::SetCurrentMission() desired mission is already the current mission");
        return;
    }
    if( CurrentMission != None )
    {
        CurrentMission.Release();
        CurrentMission=None;
    }
    if( MissionName == '' )
    {
log("[ckline] >>> SwatGUIConfig::SetCurrentMission(): CurrentMission is now None");
        return;
    }
        
    CurrentMission = new( None, string(MissionName) ) class'SwatGame.SwatMission';
    Assert(CurrentMission != None);
    CurrentMission.AddRef();

    if( CustomScenario != None )
        SetScenarioName( FriendlyName );
        
    CurrentMission.Initialize( FriendlyName, CustomScenario );

    //the the new one as the Last played immediately    
    CurrentMissionName = CurrentMission.Name;
    CurrentMissionFriendlyName = CurrentMission.FriendlyName;
    CurrentMissionCustomScenario = CurrentMission.CustomScenario;

    //set the default entry point
    if( CurrentMission.EntryOptionTitle.Length < 2 )
    {
        //only primary entry is available
        SetDesiredEntryPoint( ET_Primary );
    }
    else if( CustomScenario != None && CustomScenario.SpecifyStartPoint )
    {
        if( CustomScenario.UseSecondaryStartPoint )
            SetDesiredEntryPoint( ET_Secondary );
        else
            SetDesiredEntryPoint( ET_Primary );
    }
    
log("[ckline] >>> SwatGUIConfig::SetCurrentMission(): CurrentMission is now '"$CurrentMission$"'");

    SetCurrentCommandInterfaceStyle( CommandInterfaceStyle );    
}

function ResetCurrentMission()
{
    SetCurrentMission( CurrentMissionName, CurrentMissionFriendlyName, CurrentMissionCustomScenario );
}

function ClearCurrentMission()
{
    SetCurrentMission( '' );
}

function LoadLastMissionPlayed()
{
    //dkaplan: this is totally a hack to load something other than training if instant action is clicked
	if( LastMissionPlayedName != '' && LastMissionPlayedName != 'SP-Training' )
	    SetCurrentMission( LastMissionPlayedName, LastMissionPlayedFriendlyName, LastMissionPlayedCustomScenario );
	else
        SetCurrentMission( MissionName[0], FriendlyName[0] );

    AssertWithDescription( CurrentMission != None, "Failed to load a CurrentMission on GuiConfig LoadLastMissionPlayed().  The InstantAction option may not be available." );
}

function SaveLastMissionPlayed()
{
    LastMissionPlayedName = CurrentMissionName;
    LastMissionPlayedFriendlyName = CurrentMissionFriendlyName;
    LastMissionPlayedCustomScenario = CurrentMissionCustomScenario;
    SaveConfig();
}

function string GetGameDescription( EMPMode type )
{
    switch (type)
    {
        case MPM_BarricadedSuspects:
            return TDMDescription;
            break;
        case MPM_VIPEscort:
            return VIPDescription;
            break;
        case MPM_RapidDeployment:
            return BombDescription;
            break;
        case MPM_COOP:
            return COOPDescription;
            break;
    }
}

function string GetGameModeName( EMPMode type )
{
    switch (type)
    {
        case MPM_BarricadedSuspects:
            return TDMFriendlyName;
            break;
        case MPM_VIPEscort:
            return VIPFriendlyName;
            break;
        case MPM_RapidDeployment:
            return BombFriendlyName;
            break;
        case MPM_COOP:
            return COOPFriendlyName;
            break;
    }
}

function string GetGameModeNameFromNonlocalizedString( string NonlocalizedString )
{
    if ( NonlocalizedString == "Rapid Deployment" )
        return BombFriendlyName;
    else if ( NonlocalizedString == "VIP Escort" )
        return VIPFriendlyName;
    else if ( NonlocalizedString == "CO-OP" )
        return COOPFriendlyName;
    else
        return TDMFriendlyName;
}

function String GetDifficultyString( eDifficultyLevel difficulty )
{
    return DifficultyString[difficulty];
}

final function MissionEnded(name Mission, eDifficultyLevel difficulty, bool Completed, int Score)
{
    local int index;

    index = GetMissionIndex(Mission);
    
    if( (index >= MissionResults.length) ) //mission was never played before
    {
        MissionResults[index] = new(,string(Mission)) class'SwatGame.MissionResults';
        MissionResultNames[index] = Mission;
    }
    
    Assert( MissionResults[index] != None );

    //add this mission result
    MissionResults[index].AddResult( difficulty, Completed, Score );

    SaveConfig();
}

//returns the MissionResults of the specified Mission.
//if the mission was played, then MissionResults.Mission will equal the Mission argument.
//otherwise, MissionResults is empty (ie. MissionResults.Mission is None)
final function MissionResults GetMissionResults(name Mission)
{
    local int index;

    index = GetMissionIndex(Mission);
log( "[dkaplan] getting mission results for mission " $ Mission $ ", index = " $ index );

    //(GetMissionIndex() returns MissionResults.length if Mission is not found.)
    return MissionResults[index];
}

//returns the index of Mission in MissionResults, or MissionResults.length if not found.
private function int GetMissionIndex(name Mission)
{
    local int i;

    for (i=0; i<MissionResults.length; ++i)
        if (MissionResults[i] != None && MissionResultNames[i] == Mission)
            break;

    return i;
}

function Name GetCurrentMissionName()
{
    return CurrentMissionName;
}

function SetCustomScenarioPackData( CustomScenarioPack Pak, optional string pakN, optional string pakFN, optional string pakExt )
{
    CurrentCustomScenarioPack = Pak;
    PakName = pakN;
    PakFriendlyName = pakFN;
    PakExtension = pakExt;
}

function CustomScenarioPack GetCustomScenarioPack()
{
    return CurrentCustomScenarioPack;
}

function String GetPakName()
{
    return PakName;
}

function SetScenarioName( string inScenarioName )
{
    ScenarioName = inScenarioName;
}

function String GetScenarioName()
{
    return ScenarioName;
}

function String GetPakFriendlyName()
{
    return PakFriendlyName;
}

function String GetPakExtension()
{
    return PakExtension;
}

function SetCurrentCommandInterfaceStyle(ECommandInterfaceStyle Style)
{
    if( CurrentMission == None || CurrentMission.Name != 'SP-Training' )
        CurrentCommandInterfaceStyle = Style;
    else
        CurrentCommandInterfaceStyle = CommandInterface_Graphic;
}

// Set whether the player and his team should start from the primary or
// secondary set of entry points in a single player mission.
final function SetDesiredEntryPoint(EEntryType EntrySet) 
{
	DesiredSPEntryPoint = EntrySet; 

	if (EntrySet == ET_Primary)
		log("Desired entry point was set to PRIMARY");
	else
		log("Desired entry point was set to SECONDARY");
}

final function EEntryType GetDesiredEntryPoint() 
{
	return DesiredSPEntryPoint; 
}

final function Name GetTagForVoiceType( eVoiceType Type )
{
    switch( Type )
    {
        case VOICETYPE_VIP:
            return 'VIP';
        case VOICETYPE_Lead:
            return 'Lead';
        case VOICETYPE_OfficerRedOne:
            return 'OfficerRedOne';
        case VOICETYPE_OfficerRedTwo:
            return 'OfficerRedTwo';
        case VOICETYPE_OfficerBlueOne:
            return 'OfficerBlueOne';
        case VOICETYPE_OfficerBlueTwo:
            return 'OfficerBlueTwo';
    }
    return '';
}

final function eVoiceType GetVoiceTypeForCurrentPlayer()
{
    local eVoiceType Voice;
    
	//log("GetVoiceTypeForCurrentPlayer() Preferred type =  "$GetEnum(eVoiceType, PreferredVoiceType));
    
	if( PreferredVoiceType == eVoiceType.VOICETYPE_Random )
	{
	    if (CachedRandomVoice == eVoiceType.VOICETYPE_Random) // random voice has not yet been chosen
        {
            // choose a random voice to use consistently until the next time the 
            // user changes back and forth from a specific voice to the "random"
            // option in the GUI
            CachedRandomVoice = eVoiceType( Rand( eVoiceType.EnumCount - 2 ) + 1 );
            
		    //log("Caching a new consistent random voice: "$GetEnum(eVoiceType, CachedRandomVoice));
        }

        Voice = CachedRandomVoice;
	}
    else
        Voice = PreferredVoiceType;

    //log("GetVoiceTypeForCurrentPlayer() returning "$GetEnum(eVoiceType, Voice));

    return Voice;
}













































// Decompiled with UE Explorer.
defaultproperties
{
    DifficultyString[0]="Easy"
    DifficultyString[1]="Normal"
    DifficultyString[2]="Hard"
    DifficultyString[3]="Elite"
    DifficultyScoreRequirement[1]=50
    DifficultyScoreRequirement[2]=75
    DifficultyScoreRequirement[3]=95
    CurrentDifficulty=1
    MissionName[0]="SP-FoodWall"
    MissionName[1]="SP-FairfaxResidence"
    MissionName[2]="SP-ConvenienceStore"
    MissionName[3]="SP-ABomb"
    MissionName[4]="SP-AutoGarage"
    MissionName[5]="SP-RedLibrary"
    MissionName[6]="SP-Casino"
    MissionName[7]="SP-JewelryHeist"
    MissionName[8]="SP-Tenement"
    MissionName[9]="SP-Hospital"
    MissionName[10]="SP-ArmsDeal"
    MissionName[11]="SP-Hotel"
    MissionName[12]="SP-DNA"
    FriendlyName[0]="Food Wall Restaurant"
    FriendlyName[1]="Fairfax Residence"
    FriendlyName[2]="Qwik Fuel Convenience Store"
    FriendlyName[3]="A-Bomb Nightclub"
    FriendlyName[4]="Victory Imports Auto Center"
    FriendlyName[5]="Red Library Offices"
    FriendlyName[6]="Northside Vending and Amusements"
    FriendlyName[7]="DuPlessis Wholesale Diamond Center"
    FriendlyName[8]="Children of Taronne Tenement"
    FriendlyName[9]="St. Michael's Medical Center"
    FriendlyName[10]="The Wolcott Projects"
    FriendlyName[11]="Old Granite Hotel"
    FriendlyName[12]="Mt. Threshold Research Center"
    LastMissionPlayedName="SP-Training"
    LastMissionPlayedFriendlyName="Training"
    CustomEquipmentLoadouts[0]="Assaulter_JHP"
    CustomEquipmentLoadouts[1]="Assaulter_FMJ"
    CustomEquipmentLoadouts[2]="CQB_Specialist"
    CustomEquipmentLoadouts[3]="Breacher"
    CustomEquipmentLoadouts[4]="Scout"
    CustomEquipmentLoadouts[5]="Pacifier"
    CustomEquipmentLoadouts[6]="LessLethal"
    CustomEquipmentLoadoutFriendlyNames[0]="Assaulter (JHP)"
    CustomEquipmentLoadoutFriendlyNames[1]="Assaulter (FMJ)"
    CustomEquipmentLoadoutFriendlyNames[2]="CQB Specialist"
    CustomEquipmentLoadoutFriendlyNames[3]="Breacher"
    CustomEquipmentLoadoutFriendlyNames[4]="Scout"
    CustomEquipmentLoadoutFriendlyNames[5]="Pacifier"
    CustomEquipmentLoadoutFriendlyNames[6]="Less Lethal Specialist"
    LoadoutIsUndeletable[0]=true
    LoadoutIsUndeletable[1]=true
    LoadoutIsUndeletable[2]=true
    LoadoutIsUndeletable[3]=true
    LoadoutIsUndeletable[4]=true
    LoadoutIsUndeletable[5]=true
    LoadoutIsUndeletable[6]=true
    CommandString[0]="CommandOrEquip Row_FunctionKeys 1"
    CommandString[1]="CommandOrEquip Row_FunctionKeys 2"
    CommandString[2]="CommandOrEquip Row_FunctionKeys 3"
    CommandString[3]="CommandOrEquip Row_FunctionKeys 4"
    CommandString[4]="CommandOrEquip Row_FunctionKeys 5"
    CommandString[5]="CommandOrEquip Row_FunctionKeys 6"
    CommandString[6]="CommandOrEquip Row_FunctionKeys 7"
    CommandString[7]="CommandOrEquip Row_FunctionKeys 8"
    CommandString[8]="CommandOrEquip Row_FunctionKeys 9"
    CommandString[9]="CommandOrEquip Row_FunctionKeys 10"
    CommandString[10]="CommandOrEquip Row_NumberKeys 1"
    CommandString[11]="CommandOrEquip Row_NumberKeys 2"
    CommandString[12]="CommandOrEquip Row_NumberKeys 3"
    CommandString[13]="CommandOrEquip Row_NumberKeys 4"
    CommandString[14]="CommandOrEquip Row_NumberKeys 5"
    CommandString[15]="CommandOrEquip Row_NumberKeys 6"
    CommandString[16]="CommandOrEquip Row_NumberKeys 7"
    CommandString[17]="CommandOrEquip Row_NumberKeys 8"
    CommandString[18]="CommandOrEquip Row_NumberKeys 9"
    CommandString[19]="CommandOrEquip Row_NumberKeys 10"
    CommandString[20]="PlayerCommandInterfaceBack"
    CommandString[21]="GiveCommand 11 | ShrinkHUD"
    CommandString[22]="GUICloseMenu"
    CommandString[23]="Fire"
    CommandString[24]="Reload"
    CommandString[25]="EquipSlot 11"
    CommandString[26]="NextFireMode"
    CommandString[27]="ToggleZoom"
    CommandString[28]="ToggleFlashlight"
    CommandString[29]="IssueComplianceOrInteract"
    CommandString[30]="CommandInterfaceNextGroup"
    CommandString[31]="ShowViewport Red"
    CommandString[32]="ShowViewport Blue"
    CommandString[33]="ShowViewport Sniper"
    CommandString[34]="HideViewport"
    CommandString[35]="ControlViewportAlias"
    CommandString[36]="ShowInGamePopup"
    CommandString[37]="OpenGraphicCommandInterface | RightMouseAlias"
    CommandString[38]="GiveDefaultCommand"
    CommandString[39]="EquipNextSlot"
    CommandString[40]="EquipPrevSlot"
    CommandString[41]="ScrollCommand Up"
    CommandString[42]="ScrollCommand Down"
    CommandString[43]="MoveForward"
    CommandString[44]="MoveBackward"
    CommandString[45]="StrafeLeft"
    CommandString[46]="StrafeRight"
    CommandString[47]="LeanLeft"
    CommandString[48]="LeanRight"
    CommandString[49]="Running"
    CommandString[50]="Duck"
    CommandString[51]="ToggleRunning 0"
    CommandString[52]="ToggleCrouching 0"
    CommandString[53]="OpenHudChat 1"
    CommandString[54]="OpenHudChat 0"
    CommandString[55]="ScrollChatUp"
    CommandString[56]="ScrollChatDown"
    CommandString[57]="ScrollChatPageUp"
    CommandString[58]="ScrollChatPageDown"
    CommandString[59]="ScrollChatToHome"
    CommandString[60]="ScrollChatToEnd"
    LocalizedCommandString[0]="Classic: Primary Weapon"
    LocalizedCommandString[1]="Classic: Secondary Weapon"
    LocalizedCommandString[2]="Classic: Flashbang Grenade"
    LocalizedCommandString[3]="Classic: CS Gas Grenade"
    LocalizedCommandString[4]="Classic: Sting Grenade"
    LocalizedCommandString[5]="Classic: Pepper Spray"
    LocalizedCommandString[6]="Classic: Breaching"
    LocalizedCommandString[7]="Classic: Toolkit"
    LocalizedCommandString[8]="Classic: Optiwand"
    LocalizedCommandString[9]="Classic: Wedge"
    LocalizedCommandString[10]="Graphic: Primary Weapon"
    LocalizedCommandString[11]="Graphic: Secondary Weapon"
    LocalizedCommandString[12]="Graphic: Flashbang Grenade"
    LocalizedCommandString[13]="Graphic: CS Gas Grenade"
    LocalizedCommandString[14]="Graphic: Sting Grenade"
    LocalizedCommandString[15]="Graphic: Pepper Spray"
    LocalizedCommandString[16]="Graphic: Breaching"
    LocalizedCommandString[17]="Graphic: Toolkit"
    LocalizedCommandString[18]="Graphic: Optiwand"
    LocalizedCommandString[19]="Graphic: Wedge"
    LocalizedCommandString[20]="Classic: Back"
    LocalizedCommandString[21]="Classic: Deploy"
    LocalizedCommandString[22]="Open/Close Menus"
    LocalizedCommandString[23]="Fire"
    LocalizedCommandString[24]="Reload"
    LocalizedCommandString[25]="Equip Handcuffs"
    LocalizedCommandString[26]="Change Firing Mode"
    LocalizedCommandString[27]="Zoom"
    LocalizedCommandString[28]="Toggle Flashlight"
    LocalizedCommandString[29]="Use"
    LocalizedCommandString[30]="Change command group"
    LocalizedCommandString[31]="Toggle Red team Viewports"
    LocalizedCommandString[32]="Toggle Blue team Viewports"
    LocalizedCommandString[33]="Toggle Sniper Viewports"
    LocalizedCommandString[34]="Deactivate Viewports"
    LocalizedCommandString[35]="Control Viewports"
    LocalizedCommandString[36]="Display Objectives & Scores"
    LocalizedCommandString[37]="Open Graphic Command Interface"
    LocalizedCommandString[38]="Give Quick Command"
    LocalizedCommandString[39]="Equip Next Weapon"
    LocalizedCommandString[40]="Equip Previous Weapon"
    LocalizedCommandString[41]="Scroll Command Up"
    LocalizedCommandString[42]="Scroll Command Down"
    LocalizedCommandString[43]="Move Forward"
    LocalizedCommandString[44]="Move Backward"
    LocalizedCommandString[45]="Sidestep Left"
    LocalizedCommandString[46]="Sidestep Right"
    LocalizedCommandString[47]="Lean Left"
    LocalizedCommandString[48]="Lean Right"
    LocalizedCommandString[49]="Run/Walk"
    LocalizedCommandString[50]="Crouch"
    LocalizedCommandString[51]="Toggle Run/Walk"
    LocalizedCommandString[52]="Toggle Crouch"
    LocalizedCommandString[53]="Say"
    LocalizedCommandString[54]="Team Say"
    LocalizedCommandString[55]="Scroll Chat Up"
    LocalizedCommandString[56]="Scroll Chat Down"
    LocalizedCommandString[57]="Scroll Chat Page Up"
    LocalizedCommandString[58]="Scroll Chat Page Down"
    LocalizedCommandString[59]="Scroll Chat To Home"
    LocalizedCommandString[60]="Scroll Chat To End"
    CommandCategory[0]=3
    CommandCategory[1]=3
    CommandCategory[2]=3
    CommandCategory[3]=3
    CommandCategory[4]=3
    CommandCategory[5]=3
    CommandCategory[6]=3
    CommandCategory[7]=3
    CommandCategory[8]=3
    CommandCategory[9]=3
    CommandCategory[10]=3
    CommandCategory[11]=3
    CommandCategory[12]=3
    CommandCategory[13]=3
    CommandCategory[14]=3
    CommandCategory[15]=3
    CommandCategory[16]=3
    CommandCategory[17]=3
    CommandCategory[18]=3
    CommandCategory[19]=3
    CommandCategory[20]=3
    CommandCategory[21]=3
    CommandCategory[22]=3
    CommandCategory[23]=1
    CommandCategory[24]=1
    CommandCategory[25]=1
    CommandCategory[26]=1
    CommandCategory[27]=1
    CommandCategory[28]=1
    CommandCategory[29]=1
    CommandCategory[30]=2
    CommandCategory[31]=2
    CommandCategory[32]=2
    CommandCategory[33]=2
    CommandCategory[34]=2
    CommandCategory[35]=2
    CommandCategory[36]=1
    CommandCategory[37]=2
    CommandCategory[38]=2
    CommandCategory[39]=1
    CommandCategory[40]=1
    CommandCategory[41]=2
    CommandCategory[42]=2
    CommandCategory[43]=0
    CommandCategory[44]=0
    CommandCategory[45]=0
    CommandCategory[46]=0
    CommandCategory[47]=0
    CommandCategory[48]=0
    CommandCategory[49]=0
    CommandCategory[50]=0
    CommandCategory[51]=0
    CommandCategory[52]=0
    CommandCategory[53]=2
    CommandCategory[54]=2
    CommandCategory[55]=2
    CommandCategory[56]=2
    CommandCategory[57]=2
    CommandCategory[58]=2
    CommandCategory[59]=2
    CommandCategory[60]=2
    AudioVirtualizationChoices[0]="None"
    AudioVirtualizationChoices[1]="Low HRTF"
    AudioVirtualizationChoices[2]="High HRTF"
    SoundQualityChoices[0]="Low"
    SoundQualityChoices[1]="High"
    ScreenResolutionChoices[0]="800x600"
    ScreenResolutionChoices[1]="1024x768"
    ScreenResolutionChoices[2]="1280x1024"
    ScreenResolutionChoices[3]="1600x1200"
    TextureDetailChoices[0]="Low"
    TextureDetailChoices[1]="Medium"
    TextureDetailChoices[2]="High"
    OtherDetailChoices[0]="Off"
    OtherDetailChoices[1]="Low"
    OtherDetailChoices[2]="Medium"
    OtherDetailChoices[3]="High"
    RenderDetailChoices[0]="Custom"
    RenderDetailChoices[1]="Low"
    RenderDetailChoices[2]="Medium"
    RenderDetailChoices[3]="High"
    RenderDetailChoices[4]="Very High"
    PixelShaderChoices[0]="No"
    PixelShaderChoices[1]="Yes"
    RealtimeMirrorChoices[0]="No"
    RealtimeMirrorChoices[1]="Yes"
    VoiceTypeChoices[0]="Random"
    VoiceTypeChoices[1]="Lead"
    VoiceTypeChoices[2]="Reynolds"
    VoiceTypeChoices[3]="Girard"
    VoiceTypeChoices[4]="Fields"
    VoiceTypeChoices[5]="Jackson"
    NetworkConnectionChoices[0]="Modem"
    NetworkConnectionChoices[1]="ISDN"
    NetworkConnectionChoices[2]="Cable/ADSL"
    NetworkConnectionChoices[3]="LAN/T1"
    NetworkConnectionSpeeds[0]=2600
    NetworkConnectionSpeeds[1]=5000
    NetworkConnectionSpeeds[2]=10000
    NetworkConnectionSpeeds[3]=15000
    NetSpeedSelection=2
    MPPostMissionTime=9.0000000
    MPPollingDelay=0.2500000
    FirstTimeThrough=true
    SwatMapFileExtension=".s4m"
    SwatMPMapNamePrefix="MP"
    TDMDescription="The goal is to kill or arrest as many members of the opposite team as possible.  Kills are worth 1 point, arrests are worth 5 points.||The first team to reach the score limit wins.  If the time limit is reached, the team with the most points at the end of the round wins."
    VIPDescription="One player on the SWAT team is randomly chosen to be the VIP.  SWAT must escort the VIP to the escape point on the other side of the map.  The suspects must capture the VIP.  They must then hold him hostage for 2 minutes.  SWAT players can use the toolkit to release the VIP.  After the two minutes are up, the suspects must assassinate the VIP to win the game.||SWAT wins if the VIP escapes, or if the suspects kill the VIP before capturing and holding him."
    BombDescription="Three to five bombs are randomly spawned in the map.  SWAT must use the toolkit to defuse all of the bombs before the round ends.  The Suspects must defend the bombs and prevent them from being disabled.  Once all of the bombs are defused SWAT wins.  If the round timer expires while a bomb is still active, the Suspects win."
    COOPDescription="Play single player missions with a group of up to five officers."
    TDMFriendlyName="Barricaded Suspects"
    VIPFriendlyName="VIP Escort"
    BombFriendlyName="Rapid Deployment"
    COOPFriendlyName="CO-OP"
    MPSuspectsWinMessage="The Suspects have won the round!"
    MPSWATWinMessage="SWAT has won the round!"
    MPTieMessage="The game ended in a tie."
    MPName="Player"
    bShowHelp=true
    bAlwaysRun=true
    MPNameLength=30
    MPNameAllowableCharSet="abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ()<>{}|_!^"
    CommandInterfaceStyle=2
    MessageDisplayTime=15
    GCIButtonMode=2
    bUseExitMenu=true
    theServerFilters=(MaxPing=-1,bFull=false,bPassworded=false,bFilterGametype=false,GameType=0,bHideIncompatibleVersions=false,bHideIncompatibleMods=false)
    CriticalMomentDelay=5.0000000
}