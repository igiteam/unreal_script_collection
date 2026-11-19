class CombatProxyMenuManager extends ProxyMenuManager
	native
	noexport;

struct Op
{
	var string key;
	var string val;
};

struct URL
{
	var string map;
	var string gt;
	var array<Op> op;
};

var const int mpt;
var const URL travelURL;
var const bool botMatch;
var const bool privateGame;
var const bool moviesLoaded;
var const bool hasAcceptedInvite;
var const array<int> listeners;
var const int viewport;
var const int client;
var const int controllerDisconnected;
var const int ethernetCableDisconnected;
var const XboxLiveMgr.XBLFriendsInfo friendInfo;
var const XboxLiveMgr.XBLPlayerInfo playerInfo;
var const int liveError;
var const array<string> Messages;
var const int voiceBuffer;
var const int voiceBufferSize;
var const int voiceDuration;
var MSCHelper mscHelp;

native function HandleLiveError( int error );
native event AutoLoadMenus();
native event SetControllerStatus( bool On );
native function PreRender( Canvas canvas );
native function NotifyLevelChange();
native event Tick( float delta );
native function OnAttractMovieLoop();
native function LoadProfileFromURL(); // SFRMSinglePlayer and SFRMMenuGT call this

native simulated event LocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional String CriticalString );

