class GameEngine extends Engine
    transient
    native
    config(Engine);

enum eMenuType
{
    eMenuNone,                      // 0
    eMainMenu,                      // 1
    eInGameMenu,                    // 2
    eInGameMPMenu,                  // 3
    eInGameSplitMenu,               // 4
    ePecMenu,                       // 5
    eMenuType_MAX                   // 6
};

struct URL
{
    structcpptext
    {


	// Statics.
	static FString DefaultProtocol;
	static FString DefaultName;
	static FString DefaultMap;
	static FString DefaultLocalMap;
	static FString DefaultHost;
	static FString DefaultPortal;
	static FString DefaultMapExt;
	static FString DefaultSaveExt;
	static INT DefaultPort;

	// Constructors.
	FURL( const TCHAR* Filename=NULL );
	FURL( FURL* Base, const TCHAR* TextURL, ETravelType Type );
	static void StaticInit();
	static void StaticExit();

	// Functions.
	UBOOL IsInternal() const;
	UBOOL IsLocalInternal() const;
	UBOOL HasOption( const TCHAR* Test ) const;
	const TCHAR* GetOption( const TCHAR* Match, const TCHAR* Default ) const;
	void LoadURLConfig( const TCHAR* Section, const TCHAR* Filename=NULL );
	void SaveURLConfig( const TCHAR* Section, const TCHAR* Item, const TCHAR* Filename=NULL ) const;
	void AddOption( const TCHAR* Str );
	void RemoveOption( const TCHAR* Key, const TCHAR* Section = NULL, const TCHAR* Filename = NULL);
	FString String( UBOOL FullyQualified=0 ) const;
	friend FArchive& operator<<( FArchive& Ar, FURL& U );

	// Operators.
	UBOOL operator==( const FURL& Other ) const;

    }

    var string Protocol;
    var string Host;
    var int Port;
    var string Map;
    var array<string> Op;
    var string Portal;
    var int Valid;

    structdefaultproperties
    {
        Protocol=""
        Host=""
        Port=0
        Map=""
        Op=none
        Portal=""
        Valid=0
    }
};

var PendingLevel GPendingLevel;
var URL LastURL;
var string LastConnectURL;
var config array<config string> ServerActors;
var config array<config string> ServerPackages;
var string TravelURL;
var byte TravelType;
var bool m_bEnableReconnectAfterLoadMap;

defaultproperties
{
    LastURL=(Protocol="",Host="",Port=0,Map="",Op=none,Portal="",Valid=1)
}