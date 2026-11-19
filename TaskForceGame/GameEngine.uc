//=============================================================================
// GameEngine: The game subsystem.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class GameEngine extends Engine
	native
	noexport
	transient;

// URL structure.
struct URL
{
	var string			Protocol,	// Protocol, i.e. "unreal" or "http".
						Host;		// Optional hostname, i.e. "204.157.115.40" or "unreal.epicgames.com", blank if local.
	var int				Port;		// Optional host port.
	var string			Map;		// Map name, i.e. "SkyCity", default is "Index".
	var array<string>	Op;			// Options.
	var string			Portal;		// Portal to enter through, default is "".
	var int 			Valid;
};

var Level			GLevel,
					GEntry;
var PendingLevel	GPendingLevel;
//var PlayerController LevelLoadingController; // Added by Demiurge (LevelLoading)
var LevelLoadController LevelLoadingController; // Added by Demiurge (LevelLoading)
var	int					LevelLoadingTotalActorCount; // Added by Demiurge (LevelLoading)
var int					LevelLoadingActorCount; // Added by Demiurge (LevelLoading)
var URL				LastURL;
var config array<string>	ServerActors,
					ServerPackages;

var array<object> DummyArray;	// Do not modify
var object        DummyObject;  // Do not modify
