class OLSoundEmitter extends Object 
	native;

var Actor Actor;

var bool bActive;
var bool bDirty; // for static actors, whether something changed so that they need to be updated
var bool bDynamic; // whether the actor needs to be constantly updated (i.e. Pawns) - assume that the Touching array can be used to find volumes (bCollideActors is set)
var bool bAllowVirtualization;

struct native SoundEnvVolumeData
{
	var transient OLSoundEnvironmentVolume SoundEnvVolume;

	var bool bActive;	// whether the sound source is inside the volume
	var bool bFadeFromBorder; // whether to consider the border point and fade from it (true when walking into the sound env volume, false for static actors or when spawning inside a volume)
	var vector BorderPoint;	// entry or exit point, to fade on distance	
	var float LastActiveEnvContrib; // Used to smoothly blend contrib when leaving a volume that wasn't fully activated
};

var init array<SoundEnvVolumeData> SoundEnvironments;
var float CurrentOcclusion;
var float TargetOcclusion;
var float CurrentObstruction;
var float TargetObstruction;
var float LastObstructionCheckTime;
var float LastOcclusionCheckTime;

var vector BaseLocation; // Base location, before virtualization

var bool bVirtualized;
var vector VirtualizedLocation;	

var bool bInMultiPositionGroup;
var bool bGroupMaster;
var init string GroupEventName;

struct native AuxBusInfo
{
	var init string BusName;
	var float BusValue;
};

var init array<AuxBusInfo> ReverbBusInfos;

// Any info that only serves as debug
struct native EmitterDebugInfo
{
	var init string ReverbA;
	var float ReverbAContrib;
	var init string ReverbB;
	var float ReverbBContrib;
	var vector VirtualizationPivot;
	var float DirectDistToListener;
	var float VirtualizedDist;
	var bool bConnected;
};

var EmitterDebugInfo DebugInfo;
