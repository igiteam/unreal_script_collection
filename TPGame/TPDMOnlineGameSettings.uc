class TPDMOnlineGameSettings extends OnlineGameSettings;

/** Dynamic values that can be exposed to match making */
const PROP_NonStandardOptions = 0x10000002;
const PROP_DedicatedServer = 0x10000001;

/** Set of localized string settings */
const LSS_MapName = 1;

/** Possible map name entries */
const MAPNAME_BRKNGRND_MP	= 0;
const MAPNAME_LABRATS_MP	= 1;
const MAPNAME_THEGHETTO_MP  = 3;
const MAPNAME_GASBAG_MP		= 2;

const GAME_MODE									  = 0x0000800B;
const GAME_MODE_DM								  = 0;
const GAME_MODE_TDM								  = 1;

var databinding string PlayerRatio;

