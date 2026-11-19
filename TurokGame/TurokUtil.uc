class TurokUtil extends Object
    native;

enum ETurokWeapon
{
    ETW_None,                       // 0
    ETW_Bow,                        // 1
    ETW_Chaingun,                   // 2
    ETW_Fireblade,                  // 3
    ETW_Handgun,                    // 4
    ETW_JeepTurret,                 // 5
    ETW_WeaponTurret,               // 6
    ETW_Knife,                      // 7
    ETW_Railgun,                    // 8
    ETW_Rpg,                        // 9
    ETW_Shotgun,                    // 10
    ETW_Smg,                        // 11
    ETW_SniperRifle,                // 12
    ETW_TripleShotgun,              // 13
    ETW_Unknown,                    // 14
    ETW_Tazer,                      // 15
    ETW_Shredder,                   // 16
    ETW_StickyGun,                  // 17
    ETW_DualWield,                  // 18
    ETW_FragGrenade,                // 19
    ETW_MAX                         // 20
};

// Export UTurokUtil::execIsMultiplayerGame(FFrame&, void* const)
native static final function bool IsMultiplayerGame();

// Export UTurokUtil::execGetEngineTransition(FFrame&, void* const)
native static final function byte GetEngineTransition();

// Export UTurokUtil::execIsLocalPackage(FFrame&, void* const)
native static final function bool IsLocalPackage(string Package);

// Export UTurokUtil::execExecEngineCommand(FFrame&, void* const)
native static final function string ExecEngineCommand(string Command);

// Export UTurokUtil::execGetRotation(FFrame&, void* const)
native static final function @NULL GetRotation(@NULL A);

// Export UTurokUtil::execGetRelativeAngle(FFrame&, void* const)
native static final function float GetRelativeAngle(@NULL A, @NULL B);

// Export UTurokUtil::execHH_MM_SS_Time(FFrame&, void* const)
native static final function string HH_MM_SS_Time(int Seconds);

// Export UTurokUtil::execFormatTime(FFrame&, void* const)
native static final function string FormatTime(int Seconds);

// Export UTurokUtil::execFormatTimeMs(FFrame&, void* const)
native static final function string FormatTimeMs(int milliseconds);
