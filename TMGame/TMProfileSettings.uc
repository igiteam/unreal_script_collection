/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

/**
 * List of profile settings for TM
 */
class TMProfileSettings extends OnlineProfileSettings
	native
	config(game)
	dependson(TMTypes);

// Generic Yes/No Enum
enum EGenericYesNo
{
	TMPID_VALUE_NO,
	TMPID_VALUE_YES
};

// Gore Level Enum
enum EGoreLevel
{
	GORE_NORMAL,
	GORE_LOW
};

// Announcer Setting Enum
enum EAnnouncerSetting
{
	ANNOUNCE_OFF,
	ANNOUNCE_MINIMAL,
	ANNOUNCE_FULL
};

// Network Type Enum
enum ENetworkType
{
	NETWORKTYPE_Unknown,
	NETWORKTYPE_Modem,
	NETWORKTYPE_ISDN,
	NETWORKTYPE_Cable,
	NETWORKTYPE_LAN
};

/** Post Processing Preset */
enum EPostProcessPreset
{
	PPP_Default,
	PPP_Muted,
	PPP_Vivid,
	PPP_Intense
};

/** Vehicle controls. */
enum ETMVehicleControls
{
	TMVC_Simple,
	TMVC_Normal,
	TMVC_Advanced
};

/** Text to speech mode. */
enum ETMTextToSpeechMode
{
	TTSM_None,
	TTSM_TeamOnly,
	TTSM_All
};

// Possible Digital Button Actions - This order matters, data is saved in the order of this array.
enum EDigitalButtonActions
{
	DBA_None,
	DBA_Fire,
	DBA_AltFire,
	DBA_Jump,
	DBA_Use,
	DBA_ToggleMelee,
	DBA_ShowScores,
	DBA_ShowMap,
	DBA_FeignDeath,
	DBA_ToggleSpeaking,
	DBA_ToggleMinimap,
	DBA_WeaponPicker,
	DBA_NextWeapon,
	DBA_BestWeapon,
	DBA_PrevWeapon,

	// The following actions aren't exposed on consoles and are used for PC keybinding.
	DBA_Duck,
	DBA_MoveForward,
	DBA_MoveBackward,
	DBA_StrafeLeft,
	DBA_StrafeRight,
	DBA_TurnLeft,
	DBA_TurnRight,
	DBA_SwitchWeapon1,
	DBA_SwitchWeapon2,
	DBA_SwitchWeapon3,
	DBA_SwitchWeapon4,
	DBA_SwitchWeapon5,
	DBA_SwitchWeapon6,
	DBA_SwitchWeapon7,
	DBA_SwitchWeapon8,
	DBA_SwitchWeapon9,
	DBA_SwitchWeapon10,
	DBA_ShrinkHUD,
	DBA_GrowHUD,
	DBA_Talk,
	DBA_TeamTalk,
	DBA_ShowCommandMenu,
	DBA_ShowMenu,
	DBA_ToggleTranslocator,
	DBA_JumpPC,
	DBA_BestWeaponPC,
	DBA_Horn,
};

/** Mapping of action enum to actually exec commands. */
var array<string> DigitalButtonActionsToCommandMapping;

// Possible Analog Stick Configurations
enum EAnalogStickActions
{
	ESA_Normal,
	ESA_SouthPaw,
	ESA_Legacy,
	ESA_LegacySouthPaw
};

/** Poassible crosshair types.*/
enum ECrosshairType
{
	CHT_Normal,
	CHT_Simple,
	CHT_None
};

/** Enum of bindable keys */
enum ETMBindableKeys
{
	TMBND_Unbound,	// Must be 0!
	TMBND_MouseX,
	TMBND_MouseY,
	TMBND_MouseScrollUp,
	TMBND_MouseScrollDown,
	TMBND_LeftMouseButton,
	TMBND_RightMouseButton,
	TMBND_MiddleMouseButton,
	TMBND_ThumbMouseButton,
	TMBND_ThumbMouseButton2,
	TMBND_BackSpace,
	TMBND_Tab,
	TMBND_Enter,
	TMBND_Pause,
	TMBND_CapsLock,
	TMBND_Escape,
	TMBND_SpaceBar,
	TMBND_PageUp,
	TMBND_PageDown,
	TMBND_End,
	TMBND_Home,
	TMBND_Left,
	TMBND_Up,
	TMBND_Right,
	TMBND_Down,
	TMBND_Insert,
	TMBND_Delete,
	TMBND_Zero,
	TMBND_One,
	TMBND_Two,
	TMBND_Three,
	TMBND_Four,
	TMBND_Five,
	TMBND_Six,
	TMBND_Seven,
	TMBND_Eight,
	TMBND_Nine,
	TMBND_A,
	TMBND_B,
	TMBND_C,
	TMBND_D,
	TMBND_E,
	TMBND_F,
	TMBND_G,
	TMBND_H,
	TMBND_I,
	TMBND_J,
	TMBND_K,
	TMBND_L,
	TMBND_M,
	TMBND_N,
	TMBND_O,
	TMBND_P,
	TMBND_Q,
	TMBND_R,
	TMBND_S,
	TMBND_T,
	TMBND_U,
	TMBND_V,
	TMBND_W,
	TMBND_X,
	TMBND_Y,
	TMBND_Z,
	TMBND_NumPadZero,
	TMBND_NumPadOne,
	TMBND_NumPadTwo,
	TMBND_NumPadThree,
	TMBND_NumPadFour,
	TMBND_NumPadFive,
	TMBND_NumPadSix,
	TMBND_NumPadSeven,
	TMBND_NumPadEight,
	TMBND_NumPadNine,
	TMBND_Multiply,
	TMBND_Add,
	TMBND_Subtract,
	TMBND_Decimal,
	TMBND_Divide,
	TMBND_F1,
	TMBND_F2,
	TMBND_F3,
	TMBND_F4,
	TMBND_F5,
	TMBND_F6,
	TMBND_F7,
	TMBND_F8,
	TMBND_F9,
	TMBND_F10,
	TMBND_F11,
	TMBND_F12,
	TMBND_NumLock,
	TMBND_ScrollLock,
	TMBND_LeftShift,
	TMBND_RightShift,
	TMBND_LeftControl,
	TMBND_RightControl,
	TMBND_LeftAlt,
	TMBND_RightAlt,
	TMBND_Semicolon,
	TMBND_Equals,
	TMBND_Comma,
	TMBND_Underscore,
	TMBND_Period,
	TMBND_Slash,
	TMBND_Tilde,
	TMBND_LeftBracket,
	TMBND_Backslash,
	TMBND_RightBracket,
	TMBND_Quote,

	// Gamepad keys
	TMBND_LeftStickX,
	TMBND_LeftStickY,
	TMBND_LeftStick_Click,
	TMBND_RightStick_X,
	TMBND_RightStick_Y,
	TMBND_RightStick_Click,
	TMBND_ButtonA,			// accept button
	TMBND_ButtonB,			// cancel button
	TMBND_ButtonX,			// option button 1
	TMBND_ButtonY,			// option button 2
	TMBND_LeftShoulder,
	TMBND_RightShoulder,
	TMBND_LeftTrigger,
	TMBND_RightTrigger,
	TMBND_Start,
	TMBND_Select,
	TMBND_DPad_Up,
	TMBND_DPad_Down,
	TMBND_DPad_Left,
	TMBND_DPad_Right,

	TMBND_SpecialX,
	TMBND_SpecialY,
	TMBND_SpecialZ,
	TMBND_SpecialW
};
var transient array<name>	KeyMappingArray;	/** Mapping of enums to keynames. */

// Profile settings ids definitions
const TMPID_CustomCharString = 301;
const TMPID_UnlockedCharacters = 302;

// Audio
const TMPID_SFXVolume = 360;
const TMPID_MusicVolume = 361;
const TMPID_VoiceVolume = 362;
const TMPID_AnnouncerVolume = 363;
const TMPID_AnnounceSetting = 364;
const TMPID_AutoTaunt = 365;
const TMPID_MessageBeep = 366;
const TMPID_TextToSpeechMode = 367;
const TMPID_AmbianceVolume = 368;

// Video
const TMPID_Gamma = 380;
const TMPID_PostProcessPreset = 381;
const TMPID_ScreenResolutionX = 382;
const TMPID_ScreenResolutionY = 383;
const TMPID_DefaultFOV = 384;
const TMPID_Subtitles = 385;

// Game
const TMPID_ViewBob = 400;
const TMPID_GoreLevel = 401;
const TMPID_DodgingEnabled = 402;
const TMPID_WeaponSwitchOnPickup = 403;


// Network
const TMPID_Alias = 404;
const TMPID_ClanTag = 405;
const TMPID_NetworkConnection = 406;
const TMPID_DynamicNetspeed = 407;
const TMPID_SpeechRecognition = 408;
const TMPID_ServerDescription = 409;
const TMPID_AllowCustomCharacters = 410;
const TMPID_FirstTimeMultiplayer = 411;

// Input
const TMPID_MouseSmoothing = 420;
const TMPID_ReduceMouseLag = 421;
const TMPID_EnableJoystick = 422;
const TMPID_MouseSensitivityGame = 423;
const TMPID_MouseSensitivityMenus = 424;
const TMPID_MouseSmoothingStrength = 425;
const TMPID_MouseAccelTreshold = 426;
const TMPID_DodgeDoubleClickTime = 427;
const TMPID_TurningAccelerationFactor = 428;

const TMPID_GamepadBinding_ButtonA = 429;
const TMPID_GamepadBinding_ButtonB = 430;
const TMPID_GamepadBinding_ButtonX = 431;
const TMPID_GamepadBinding_ButtonY = 432;
const TMPID_GamepadBinding_Back = 433;
const TMPID_GamepadBinding_RightBumper = 434;
const TMPID_GamepadBinding_LeftBumper = 435;
const TMPID_GamepadBinding_RightTrigger = 436;
const TMPID_GamepadBinding_LeftTrigger = 437;
const TMPID_GamepadBinding_RightThumbstickPressed = 438;
const TMPID_GamepadBinding_LeftThumbstickPressed = 439;
const TMPID_GamepadBinding_DPadUp = 440;
const TMPID_GamepadBinding_DPadDown = 441;
const TMPID_GamepadBinding_DPadLeft = 442;
const TMPID_GamepadBinding_DPadRight = 443;

const TMPID_GamepadBinding_AnalogStickPreset = 444;

const TMPID_ControllerSensitivityMultiplier = 450;
const TMPID_AutoCenterPitch = 451;
const TMPID_AutoCenterVehiclePitch = 452;
const TMPID_TiltSensing = 453;
const TMPID_VehicleControls = 454;
const TMPID_EnableHardwarePhysics = 455;

// Weapons
const TMPID_WeaponHand = 460;
const TMPID_SmallWeapons = 461;
const TMPID_DisplayWeaponBar = 462;
const TMPID_ShowOnlyAvailableWeapons = 463;

const TMPID_RocketLauncherPriority = 464;
const TMPID_BioRiflePriority = 465;
const TMPID_FlakCannonPriority = 466;
const TMPID_SniperRiflePriority = 467;
const TMPID_LinkGunPriority = 468;
const TMPID_EnforcerPriority = 469;
const TMPID_ShockRiflePriority = 470;
const TMPID_StingerPriority = 471;
const TMPID_RedeemerPriority = 473;

const TMPID_CrosshairType = 474;

// HUD
const TMPID_ShowMap = 480;
const TMPID_ShowClock = 481;
const TMPID_ShowDoll = 482;
const TMPID_ShowAmmo = 483;
const TMPID_ShowPowerups = 484;
const TMPID_ShowScoring = 485;
const TMPID_ShowLeaderboard = 486;
const TMPID_RotateMap = 487;
const TMPID_ShowVehicleArmorCount = 488;

// PC Keybindings
const TMPID_KeyAction_1 = 	501;
const TMPID_KeyAction_2 = 	502;
const TMPID_KeyAction_3 = 	503;
const TMPID_KeyAction_4 = 	504;
const TMPID_KeyAction_5 = 	505;
const TMPID_KeyAction_6 = 	506;
const TMPID_KeyAction_7 = 	507;
const TMPID_KeyAction_8 = 	508;
const TMPID_KeyAction_9 = 	509;
const TMPID_KeyAction_10 = 	510;
const TMPID_KeyAction_11 = 	511;
const TMPID_KeyAction_12 = 	512;
const TMPID_KeyAction_13 = 	513;
const TMPID_KeyAction_14 = 	514;
const TMPID_KeyAction_15 = 	515;
const TMPID_KeyAction_16 = 	516;
const TMPID_KeyAction_17 = 	517;
const TMPID_KeyAction_18 = 	518;
const TMPID_KeyAction_19 = 	519;
const TMPID_KeyAction_20 = 	520;
const TMPID_KeyAction_21 = 	521;
const TMPID_KeyAction_22 = 	522;
const TMPID_KeyAction_23 = 	523;
const TMPID_KeyAction_24 = 	524;
const TMPID_KeyAction_25 = 	525;
const TMPID_KeyAction_26 = 	526;
const TMPID_KeyAction_27 = 	527;
const TMPID_KeyAction_28 = 	528;
const TMPID_KeyAction_29 = 	529;
const TMPID_KeyAction_30 = 	530;
const TMPID_KeyAction_31 = 	531;
const TMPID_KeyAction_32 = 	532;
const TMPID_KeyAction_33 = 	533;
const TMPID_KeyAction_34 = 	534;
const TMPID_KeyAction_35 = 	535;
const TMPID_KeyAction_36 = 	536;
const TMPID_KeyAction_37 = 	537;
const TMPID_KeyAction_38 = 	538;
const TMPID_KeyAction_39 = 	539;
const TMPID_KeyAction_40 = 	540;
const TMPID_KeyAction_41 = 	541;
const TMPID_KeyAction_42 = 	542;
const TMPID_KeyAction_43 = 	543;
const TMPID_KeyAction_44 = 	544;
const TMPID_KeyAction_45 = 	545;
const TMPID_KeyAction_46 = 	546;
const TMPID_KeyAction_47 = 	547;
const TMPID_KeyAction_48 = 	548;
const TMPID_KeyAction_49 = 	549;



//TM Achievements
enum ETMUnlockType
{
	EUnlockType_Count,
	EUnlockType_Bitmask
};

//Onslaught/Warfare
const TMPID_PopupMapOnDeath=700;


struct native AchievementData
{
	//What achievement is this
	var ETMGameAchievements Id;

	//How this unlock criteria is interpreted
	var ETMUnlockType UnlockType;

	//How many times must we do this to 'unlock' or a bitmask of unlock condition
	var int UnlockCriteria;
};

var array<AchievementData> AchievementsArray;

const TMAID_Achievement_Start = 800;
const TMAID_ACHIEVEMENT_CAMPAIGN_CompleteAllTraining = 801;
const TMAID_ACHIEVEMENT_CAMPAIGN_DeployLeviathan = 802;
const TMAID_ACHIEVEMENT_CAMPAIGN_DefeatLauren = 803;
const TMAID_ACHIEVEMENT_CAMPAIGN_SignTreaty = 804;
const TMAID_ACHIEVEMENT_CAMPAIGN_DefeatSelig = 805;
const TMAID_ACHIEVEMENT_CAMPAIGN_LiandriMainframe = 806;
const TMAID_ACHIEVEMENT_CAMPAIGN_HijackDarkwalker = 807;
const TMAID_ACHIEVEMENT_CAMPAIGN_ControlTarydium = 808;
const TMAID_ACHIEVEMENT_CAMPAIGN_StealNecrisTech = 809;
const TMAID_ACHIEVEMENT_CAMPAIGN_ReachOmicron = 810;
const TMAID_ACHIEVEMENT_CAMPAIGN_DefeatLoque = 811;
const TMAID_ACHIEVEMENT_CAMPAIGN_SignTreatyExpert = 812;
const TMAID_ACHIEVEMENT_CAMPAIGN_LiandriMainframeExpert = 813;
const TMAID_ACHIEVEMENT_CAMPAIGN_ReachOmicronExpert = 814;
const TMAID_ACHIEVEMENT_CAMPAIGN_DefeatLoqueExpert = 815;
const TMAID_ACHIEVEMENT_CAMPAIGN_DefeatLaurenGodlike = 816;
const TMAID_ACHIEVEMENT_CAMPAIGN_DefeatSeligGodlike = 817;
const TMAID_ACHIEVEMENT_CAMPAIGN_DefeatMatrixGodlike = 818;
const TMAID_ACHIEVEMENT_CAMPAIGN_DefeatLoqueGodlike = 819;
const TMAID_ACHIEVEMENT_COOP_Complete1 = 820;
const TMAID_ACHIEVEMENT_COOP_Complete10 = 821;
const TMAID_ACHIEVEMENT_COOP_CompleteCampaign = 822;
const TMAID_ACHIEVEMENT_IA_EveryGameMode = 823;
const TMAID_ACHIEVEMENT_IA_Untouchable = 824;
const TMAID_ACHIEVEMENT_EXPLORE_AllPowerups = 825;
const TMAID_ACHIEVEMENT_EXPLORE_EveryMutator = 826;
const TMAID_ACHIEVEMENT_EXPLORE_EveryWeaponKill = 827;
const TMAID_ACHIEVEMENT_WEAPON_BrainSurgeon = 828;
const TMAID_ACHIEVEMENT_WEAPON_ShockTherapy = 829;
const TMAID_ACHIEVEMENT_WEAPON_GooGod = 830;
const TMAID_ACHIEVEMENT_WEAPON_Pistolero = 831;
const TMAID_ACHIEVEMENT_WEAPON_Hammerhead = 832;
const TMAID_ACHIEVEMENT_WEAPON_StrongestLink = 833;
const TMAID_ACHIEVEMENT_WEAPON_BombSquad = 834;
const TMAID_ACHIEVEMENT_WEAPON_BigGameHunter = 835;
const TMAID_ACHIEVEMENT_VEHICLE_Hoverboard = 836;
const TMAID_ACHIEVEMENT_VEHICLE_Armadillo = 837;
const TMAID_ACHIEVEMENT_VEHICLE_Gunner = 838;
const TMAID_ACHIEVEMENT_VEHICLE_Ace = 839;
const TMAID_ACHIEVEMENT_VEHICLE_Deathwish = 840;
const TMAID_ACHIEVEMENT_HUMILIATION_SerialKiller = 841;
const TMAID_ACHIEVEMENT_HUMILIATION_SirSlaysALot = 842;
const TMAID_ACHIEVEMENT_HUMILIATION_PathOfDestruction = 843;
const TMAID_ACHIEVEMENT_HUMILIATION_Deity = 844;
const TMAID_ACHIEVEMENT_VERSUS_GetItOn = 845;
const TMAID_ACHIEVEMENT_VERSUS_SameTeam = 846;
const TMAID_ACHIEVEMENT_VERSUS_Nemecide = 847;
const TMAID_ACHIEVEMENT_VERSUS_AroundTheWorld = 848;
const TMAID_ACHIEVEMENT_VERSUS_Dedication = 849;
const TMAID_ACHIEVEMENT_VERSUS_MeetInterestingPeople = 850;
const TMAID_ACHIEVEMENT_VERSUS_GetALife = 851;
const TMAID_ACHIEVEMENT_VERSUS_KillGetALifers = 852;
const TMAID_ACHIEVEMENT_RANKED_RememberYourFirst = 853;
const TMAID_ACHIEVEMENT_RANKED_DontHateThePlayer = 854;
const TMAID_ACHIEVEMENT_RANKED_MixItUp = 855;
const TMAID_ACHIEVEMENT_RANKED_HatTrick = 856;
const TMAID_ACHIEVEMENT_RANKED_BloodSweatTears = 857;
const TMAID_ACHIEVEMENT_RANKED_TenFootPole = 858;
const TMAID_Achievement_End = 859;



// ===================================================================
// Single Player Keys
// ===================================================================

/**
 * PersistentKeys are meant to be tied to in-game events and persist across
 * different missions.  The mission manager can use these keys to determine next
 * course of action and kismet can query for a key and act accordingly (TBD).
 * Current we have room for 20 persistent keys.
 *
 * To Add a persistent key, extend the enum below.
 */

enum ESinglePlayerPersistentKeys
{
	ESPKey_None,
	ESPKey_DarkWalkerUnlock,
	ESPKey_CanStealNecris,
	ESPKey_IronGuardUpgrade,
	ESPKey_LiandriUpgrade,
	ESPKey_MAX
};

const PSI_PersistentKeySlot0	= 200;
const PSI_PersistentKeySlot1	= 201;
const PSI_PersistentKeySlot2	= 202;
const PSI_PersistentKeySlot3	= 203;
const PSI_PersistentKeySlot4	= 204;
const PSI_PersistentKeySlot5	= 205;
const PSI_PersistentKeySlot6	= 206;
const PSI_PersistentKeySlot7	= 207;
const PSI_PersistentKeySlot8	= 208;
const PSI_PersistentKeySlot9	= 209;
const PSI_PersistentKeySlot10	= 210;
const PSI_PersistentKeySlot11	= 211;
const PSI_PersistentKeySlot12	= 212;
const PSI_PersistentKeySlot13	= 213;
const PSI_PersistentKeySlot14	= 214;
const PSI_PersistentKeySlot15	= 215;
const PSI_PersistentKeySlot16	= 216;
const PSI_PersistentKeySlot17	= 217;
const PSI_PersistentKeySlot18	= 218;
const PSI_PersistentKeySlot19	= 219;

const PSI_PersistentKeyMAX		= 220;	// When adding a persistent key slot, make sure you update the max
										// otherwise the new slot won't be processed

enum ESinglePlayerSkillLevels
{
	ESPSKILL_SkillLevel0,
	ESPSKILL_SkillLevel1,
	ESPSKILL_SkillLevel2,
	ESPSKILL_SkillLevel3,
	ESPSKILL_SkillLevelMAX
};

const PSI_SinglePlayerMapMaskA = 245;
const PSI_SinglePlayerMapMaskB = 246;

const PSI_SinglePlayerSkillLevel = 250;
const PSI_SinglePlayerCurrentMission=251;
const PSI_SinglePlayerCurrentMissionResult=252;

const PSI_ModifierCardDeck0	 = 270;
const PSI_ModifierCardDeck1  = 271;
const PSI_ModifierCardDeck2  = 272;
const PSI_ModifierCardDeck3  = 273;
const PSI_ModifierCardDeck4  = 274;
const PSI_ModifierCardDeck5  = 275;
const PSI_ModifierCardDeck6  = 276;
const PSI_ModifierCardDeck7  = 277;
const PSI_ModifierCardDeck8  = 278;
const PSI_ModifierCardDeck9  = 279;
const PSI_ModifierCardDeck10 = 280;
const PSI_ModifierCardDeck11 = 281;
const PSI_ModifierCardDeck12 = 282;
const PSI_ModifierCardDeck13 = 283;
const PSI_ModifierCardDeck14 = 284;
const PSI_ModifierCardDeck15 = 285;
const PSI_ModifierCardDeck16 = 286;
const PSI_ModifierCardDeck17 = 287;
const PSI_ModifierCardDeck18 = 288;
const PSI_ModifierCardDeck19 = 289;
const PSI_ModifierCardEnd	 = 290;

/** Holds which chapters have been unlocked */
const PSI_ChapterMask = 299;

var array<name> CampaignBoneNames;


/**
 * Checks to see if a bone has already been visited (ie: you have completed this mission
 *
 * @Param 	MaskA	The First part of the mask
 * @Param 	MaskA	The Second part of the mask
 */
function GetBoneMask(out int MaskA, out int MaskB)
{
	local int a,b;

	GetProfileSettingValueInt(PSI_SinglePlayerMapMaskA,A);
	GetProfileSettingValueInt(PSI_SinglePlayerMapMaskB,B);

	MaskA = A;
	MaskB = B;
}

/**
 * Flags a bone as having been visited
 *
 * @Param	BoneNAme		The Bone to flag
 */

function BoneHasBeenVisited(name BoneName)
{
	local int BoneIndex;
	local int SavedMask, BoneMask;
	local int SettingIndex;

	if (BoneName != '')
	{
		BoneIndex = CampaignBoneNames.Find(BoneName);

		if ( BoneIndex != INDEX_None )
		{
			SettingIndex = (BoneIndex > 31) ? PSI_SinglePlayerMapMaskB : PSI_SinglePlayerMapMaskA;

			GetProfileSettingValueInt(SettingIndex,SavedMask);
			BoneMask = (BoneIndex > 31) ? (1 << BoneIndex-32) : (1 << BoneIndex);

			SavedMask = SavedMask | BoneMask;
			SetProfileSettingValueInt(SettingIndex,SavedMask);
		}
	}
}

/**
 * Get's a list of bones that have been visited
 *
 * Param	MaskA			The first part of the bone mask
 * Param 	MaskB			The Second part of the bone mask
 * Param	OUT BoneList	returns the list of bones
 *
 */
static function GetListOfVisitedBones(int MaskA, int MaskB, out array<name> BoneList)
{
	local int i,j,cnt;
	local int SavedMask;
	local int BoneMask;

	for (j=0;j<2;j++)
	{
		SavedMask = (j>0) ? MaskB : MaskA;;
		for (i=0;i<32;i++)
		{
			BoneMask = 1 << i;
			if ( (SavedMask & BoneMask) > 0 )
			{
				Cnt++;
				BoneList.Length = Cnt;
				BoneList[Cnt-1] = Default.CampaignBoneNames[ (j * 32 + i) ];
			}
		}
	}
}

// ===================================================================
// Single Player Keys Accessors
// ===================================================================

/**
 * Check to see if a Persistent Key has been set.
 *
 * @Param	SearchKey		The Persistent Key to look for
 * @Param	PSI_Index		<Optional Out> returns the PSI Index for the slot holding the key
 *
 * @Returns true if the key exists, false if it doesn't
 */
function bool HasPersistentKey(ESinglePlayerPersistentKeys SearchKey, optional out int PSI_Index)
{
	local int Value;

	if (SearchKey != ESPKey_None)
	{
		for (PSI_Index = PSI_PersistentKeySlot0; PSI_Index < PSI_PersistentKeyMAX; PSI_Index++)
		{
			GetProfileSettingValueInt( PSI_Index, Value );
			if ( Value == SearchKey )
			{
				return true;
			}
		}
	}
	return false;
}

/**
 * Add a PersistentKey
 *
 * @Param	AddKey		The Persistent Key to add
 * @Returns true if successful.
 *
 */
function bool AddPersistentKey(ESinglePlayerPersistentKeys AddKey)
{
	local int PSI_Index, Value;

	// Make sure the key does not exist first

	if ( HasPersistentKey(AddKey) )
	{
//		`log("[SinglePlayer] Persistent Key"@AddKey@"already exists.");
		return false;
	}

	// Find the first available slot

	for (PSI_Index = PSI_PersistentKeySlot0; PSI_Index < PSI_PersistentKeyMAX; PSI_Index++)
	{
		GetProfileSettingValueInt( PSI_Index, Value );
		if ( Value == ESPKey_None )
		{
//			`log("[SinglePlayer] Adding Persistent Key"@AddKey);
			SetProfileSettingValueInt( PSI_Index, AddKey );
			return true;
		}
	}

//	`log("[SinglePlayer] Persistent Key Slots Filled");
	return false;
}


/**
 * Remove a PersistentKey
 *
 * @Param	RemoveKey		The Persistent Key to remove
 * @returns true if successful
 */
function bool RemovePersistentKey(ESinglePlayerPersistentKeys RemoveKey)
{
	local iNT PSI_Index;


	if ( HasPersistentKey(RemoveKey, PSI_Index) )
	{
//		`log("[SinglePlayer] Removing Persistent Key"@RemoveKey);
		SetProfileSettingValueInt( PSI_Index, ESPKey_None );
		return true;
	}

	return false;
}

function int GetChapterMask()
{
	local int Value;
	GetProfileSettingValueInt( PSI_ChapterMask, value);
	return Value;
}

function SetChapterMask(int NewMask)
{
	SetProfileSettingValueInt( PSI_ChapterMask, NewMask );
}

function bool AreAnyChaptersUnlocked()
{
	local int Value;
	GetProfileSettingValueInt( PSI_ChapterMask, Value);
	return Value != 0;
}



function bool IsChapterUnlocked(int ChapterIndex)
{
	local int Mask,Value;

	Mask = 1 << ChapterIndex;
	GetProfileSettingValueInt( PSI_ChapterMask, Value );

	return ( (Value & Mask) != 0);
}

function UnlockChapter(int ChapterIndex)
{
	local int Mask,Value;

//	`log("[SinglePlayer] Unlocking Chapter"@ChapterIndex);

	Mask = 1 << (ChapterIndex-1);
	GetProfileSettingValueInt( PSI_ChapterMask, Value );
	Value = Value | Mask;


	SetProfileSettingValueInt( PSI_ChapterMAsk, Value );
}

function GetDeck(out array<name> Deck, out array<int> CardCount)
{
}

/**
 * Achievements stored in profile
 */

// Update an achievement int32 by by treating it as a bitmask
// for stats like "complete all campaign", etc
native function bool UpdateAchievementBitMask(int AchievementId, int BitMask);

// Increment the particular achievement by Count
// basically maintains a count of how many times this achievement was accomplished
native function bool UpdateAchievementCount(int AchievementId, optional int Count=1);

// Returns the value stored with this particular achievement
native function bool GetAchievementValue(int AchievementId, out int Value);

// Set the value for this particular achievement
native function bool SetAchievementValue(int AchievementId, int Value);

// Get the unlock criteria for this achievement
native function bool GetAchievementUnlockCriteria(int AchievementId, out int UnlockCriteria);

// Set the map that was just won for the 'Around the World' Achievement
native function bool UpdateAroundTheWorld(INT MapContextId);

// Set the gametype just won for 'Mix It Up' Achievement
native function bool IncrementMixItUp(INT GameType);

// Set the gametype just played for 'Get It On' Achivement
native function bool UpdateGetItOn(INT MapContextId);


/**
 * @Param MissionID		- Returns the Mission ID for the current mission
 * @Param MissionResult - Returns the results for the last mission.
 */
function GetCurrentMissionData(out int MissionID, out int MissionResult)
{
	GetProfileSettingValueInt(PSI_SinglePlayerCurrentMission,MissionID);
	GetProfileSettingValueInt(PSI_SinglePlayerCurrentMissionResult,MissionResult);
}

function SetCurrentMissionData(int NewMissionID, int bNewMissionResult)
{
	SetProfileSettingValueInt(PSI_SinglePlayerCurrentMission,NewMissionID);
	SetProfileSettingValueInt(PSI_SinglePlayerCurrentMissionResult,bNewMissionResult);
}

function int GetCampaignSkillLevel()
{
	local int CMIdx;
	GetProfileSettingValueInt(PSI_SinglePlayerSkillLevel, CMIdx);
	return CMIdx;
}

function SetCampaignSkillLevel(int NewSkillLevel)
{
	SetProfileSettingValueInt(PSI_SinglePlayerSkillLevel, NewSkillLevel);
}

/**
 * @Returns true if a game is in progress
 */

function bool bGameInProgress()
{
	local int IDX, R;
	GetCurrentMissionData(IDX,R);
	return (IDX >= 0);
}

/**
 * Resets the single player game profile settings for a new game
 */
function NewGame()
{
	local int i;

	for (i=PSI_PersistentKeySlot0;i< PSI_PersistentKeyMAX; i++)
	{
		SetProfileSettingValueInt(i,ESPKey_None);
	}

	// Reset the Map Mask
	SetProfileSettingValueInt(PSI_SinglePlayerMapMaskA,0);
	SetProfileSettingValueInt(PSI_SinglePlayerMapMaskB,0);

	SetProfileSettingValueInt(PSI_SinglePlayerSkillLevel,1);
	SetCurrentMissionData(0,0);
}
/**
 * Returns the integer value of a profile setting given its name.
 *
 * @return Whether or not the value was retrieved
 */
function bool GetProfileSettingValueIntByName(name SettingName, out int OutValue)
{
	local bool bResult;
	local int SettingId;

	bResult = FALSE;

	if(GetProfileSettingId(SettingName,SettingId))
	{
		bResult = GetProfileSettingValueInt(SettingId, OutValue);
	}

	return bResult;
}

/**
 * Returns the float value of a profile setting given its name.
 *
 * @return Whether or not the value was retrieved
 */
function bool GetProfileSettingValueFloatByName(name SettingName, out float OutValue)
{
	local bool bResult;
	local int SettingId;

	bResult = FALSE;

	if(GetProfileSettingId(SettingName,SettingId))
	{
		bResult = GetProfileSettingValueFloat(SettingId, OutValue);
	}

	return bResult;
}

/**
 * Returns the string value of a profile setting given its name.
 *
 * @return Whether or not the value was retrieved
 */
function bool GetProfileSettingValueStringByName(name SettingName, out string OutValue)
{
	local bool bResult;
	local int SettingId;

	bResult = FALSE;

	if(GetProfileSettingId(SettingName,SettingId))
	{
		bResult = GetProfileSettingValue(SettingId, OutValue);
	}

	return bResult;
}

/**
 * Returns the Id mapped value of a profile setting given its name.
 *
 * @return Whether or not the value was retrieved
 */
function bool GetProfileSettingValueIdByName(name SettingName, out int OutValue)
{
	local bool bResult;
	local int SettingId;

	bResult = FALSE;

	if(GetProfileSettingId(SettingName,SettingId))
	{
		bResult = GetProfileSettingValueId(SettingId, OutValue);
	}

	return bResult;
}

/**
 * Sets the specified profile id back to its default value.
 *
 * @param ProfileId	Profile setting to reset to default.
 */
native function ResetToDefault(int ProfileId);


/**
 * Resets the current keybindings for the specified playerowner to the defaults specified in the INI.
 *
 * @param InPlayerOwner	Player to get the default keybindings for.
 */
native static function ResetKeysToDefault(optional LocalPlayer InPlayerOwner);

/**
 * Stores key settings in the profile using the player input object provided.
 *
 * @param PInput	Player input to get bindings from.
 */
function StoreKeysUsingPlayerInput(optional PlayerInput PInput=None)
{
	local int BindingIdx, CommandIdx, ToBindIdx;
	local int NumTotalBinds, NumCurrBinds;
	local name KeyBinds[2];
	local array<KeyBind> Bindings;

	if(PInput==None)
	{
		Bindings=class'PlayerInput'.default.Bindings;
	}
	else
	{
		Bindings=PInput.Bindings;
	}

	NumTotalBinds = 2;

	// Loop through all of the commands in the profile.
	for ( CommandIdx = 0; CommandIdx<DigitalButtonActionsToCommandMapping.length; CommandIdx++ )
	{
		// Init the local binding data.
		NumCurrBinds = 0;
		for ( ToBindIdx = 0; ToBindIdx < NumTotalBinds; ToBindIdx++ )
		{
			KeyBinds[ToBindIdx] = '';
		}

		// Loop through all of the binds and find the commands that match the one we are currently trying to set in the profile.
		for( BindingIdx = Bindings.length-1; BindingIdx >= 0; BindingIdx-- )
		{
			// Found one so mark the index in our local array.
			if (Bindings[BindingIdx].Command == DigitalButtonActionsToCommandMapping[CommandIdx])
			{
				KeyBinds[NumCurrBinds++] = Bindings[BindingIdx].Name;
			}

			// Make sure we only mark NumTotoalBinds worth of binds.
			if ( NumCurrBinds >= NumTotalBinds )
			{
				break;
			}
		}

		// Now set them in the profile.
		SetKeyBindingUsingCommand( DigitalButtonActionsToCommandMapping[CommandIdx], KeyBinds[0], KeyBinds[1] );
	}
}


/**
 * Sets all of the profile settings to their default values
 */
event SetToDefaults()
{
	local string DefaultStringValue;

	Super.SetToDefaults();

	DefaultStringValue = "";

	// Resets keys to default values.
	ResetKeysToDefault();
	StoreKeysUsingPlayerInput();

	//SetProfileSettingValueFloat(TMPID_RocketLauncherPriority, class'TMWeap_RocketLauncher'.default.Priority);
	//SetProfileSettingValueFloat(TMPID_ShockRiflePriority, class'TMWeap_ShockRifle'.default.Priority);
	//SetProfileSettingValueFloat(TMPID_LinkGunPriority, class'TMWeap_LinkGun'.default.Priority);
	
	if ( !class'WorldInfo'.static.IsConsoleBuild() )
	{
		SetProfileSettingValueId(TMPID_ShowVehicleArmorCount, TMPID_VALUE_YES);
	}

	SetProfileSettingValue(TMPID_ClanTag, DefaultStringValue);
	SetProfileSettingValue(TMPID_Alias, DefaultStringValue);
	SetProfileSettingValue(TMPID_ServerDescription, DefaultStringValue);

	SetProfileSettingValueId(TMPID_SmallWeapons, class'TMWeapon'.default.bSmallWeapons ? TMPID_VALUE_YES : TMPID_VALUE_NO);
}

/**
 * Looks up a keybinding name given an enum value
 *
 * @param KeyName	Key name to look up the enum for.
 *
 * @return Returns the name for the key if it exists, or '' otherwise.
 */
function name FindKeyName(ETMBindableKeys KeyEnum)
{
	local name Result;

	if(KeyEnum < KeyMappingArray.length)
	{
		Result = KeyMappingArray[KeyEnum];
	}
	else
	{
		Result = '';
	}

	return Result;
}

/**
 * Looks up a keybinding enum value given its name.
 *
 * @param KeyName	Key name to look up the enum for.
 *
 * @return Returns the enum value for the key or INDEX_NONE if none was found.
 */
function int FindKeyEnum(name KeyName)
{
	local int KeyIdx;
	local int Result;

	Result = INDEX_NONE;

	for(KeyIdx=0; KeyIdx<KeyMappingArray.length; KeyIdx++)
	{
		if(KeyMappingArray[KeyIdx]==KeyName)
		{
			Result = KeyIdx;
			break;
		}
	}

	return Result;
}

/**
 * Returns the profile ID for a digital button action.
 *
 * @param KeyAction		Action to return a profile ID for.
 *
 * @return	Returns the profile ID for the action.
 */
function int GetProfileIDForDBA(EDigitalButtonActions KeyAction)
{
	local int ProfileId;
	ProfileId = TMPID_KeyAction_1+KeyAction;
	;
	return ProfileId;
}

/**
 * Attempts to find a digital button action enum using a string command
 *
 * @param Command	Command to find
 *
 * @return an EDigitalButtonAction enum value if one exists, INDEX_NONE otherwise.
 */
function int GetDBAFromCommand(string Command)
{
	local int Result;
	local int CommandIdx;

	Result = INDEX_NONE;

	for(CommandIdx=0; CommandIdx<DigitalButtonActionsToCommandMapping.length; CommandIdx++)
	{
		if(DigitalButtonActionsToCommandMapping[CommandIdx]==Command)
		{
			Result = CommandIdx;
			break;
		}
	}

	return Result;
}

/**
 * Sets a binding for a specified command.
 *
 * @param KeyAction		DBA to bind
 * @param KeyBinding1	Key to bind #1
 * @param KeyBinding2	Key to bind #2
 * @param KeyBinding3	Key to bind #3
 * @param KeyBinding4	Key to bind #4
 */
function SetKeyBindingUsingCommand(string KeyCommand, name KeyBinding, optional name KeyBinding2='', optional name KeyBinding3='', optional name KeyBinding4='')
{
	local int KeyAction;

	KeyAction = GetDBAFromCommand(KeyCommand);

	if(KeyAction != INDEX_NONE)
	{
		SetKeyBinding(EDigitalButtonActions(KeyAction), KeyBinding, KeyBinding2, KeyBinding3, KeyBinding4);
	}
}

/**
 * Sets a binding for a specified key action.
 *
 * @param KeyAction		DBA to bind
 * @param KeyBinding1	Key to bind #1
 * @param KeyBinding2	Key to bind #2
 * @param KeyBinding3	Key to bind #3
 * @param KeyBinding4	Key to bind #4
 */
function SetKeyBinding(EDigitalButtonActions KeyAction, name KeyBinding, optional name KeyBinding2='', optional name KeyBinding3='', optional name KeyBinding4='')
{
	local int KeyBindingValue[4];
	local int FinalProfileValue;
	local int KeyEnumValue;
	local int BindingIdx;

	KeyBindingValue[0]=0;
	KeyBindingValue[1]=0;
	KeyBindingValue[2]=0;
	KeyBindingValue[3]=0;

	// Key binding 1
	if(KeyBinding != '')
	{
		KeyEnumValue = FindKeyEnum(KeyBinding);

		if(KeyEnumValue != INDEX_NONE)
		{
			KeyBindingValue[3]=KeyEnumValue;
		}
	}

	// Key binding 2
	if(KeyBinding2 != '')
	{
		KeyEnumValue = FindKeyEnum(KeyBinding2);

		if(KeyEnumValue != INDEX_NONE)
		{
			KeyBindingValue[2]=KeyEnumValue;
		}
	}

	// Key binding 3
	if(KeyBinding3 != '')
	{
		KeyEnumValue = FindKeyEnum(KeyBinding3);

		if(KeyEnumValue != INDEX_NONE)
		{
			KeyBindingValue[1]=KeyEnumValue;
		}
	}

	// Key binding 4
	if(KeyBinding4 != '')
	{
		KeyEnumValue = FindKeyEnum(KeyBinding4);

		if(KeyEnumValue != INDEX_NONE)
		{
			KeyBindingValue[0]=KeyEnumValue;
		}
	}

	// Save the value to the profile
	FinalProfileValue=0;
	for(BindingIdx=0;BindingIdx<4;BindingIdx++)
	{
		FinalProfileValue = FinalProfileValue | (KeyBindingValue[BindingIdx]<<(BindingIdx*8));
	}
	SetProfileSettingValueInt(GetProfileIDForDBA(KeyAction), FinalProfileValue);
}

/**
 * Unbinds the specified key.
 *
 * @param PInput	Player input to operate on
 * @param BindName	Key to unbind
 */
function UnbindKey(PlayerInput PInput, name BindName)
{
	local int BindingIdx;

	for(BindingIdx = 0;BindingIdx < PInput.Bindings.Length;BindingIdx++)
	{
		if(PInput.Bindings[BindingIdx].Name == BindName)
		{
			PInput.Bindings.Remove(BindingIdx, 1);
			PInput.SaveConfig();
			break;
		}
	}
}

/**
 * Applies all possible bindings to the specified player input.
 *
 * @param InPlayerInput		PlayerInput to bind keys on
 */
function ApplyAllKeyBindings(PlayerInput PInput)
{
	local int BindingIdx;
	local name KeyName;
	local string KeyCommand;
	local int CurrentProfileValue;

	if ( !class'WorldInfo'.static.IsConsoleBuild() )
	{
		RemoveDBABindings( PInput );

		//Key bindings
		for(BindingIdx=0; BindingIdx<DBA_MAX; BindingIdx++)
		{
			ApplyKeyBinding(PInput, EDigitalButtonActions(BindingIdx));
		}

		//Joystick bindings
		for( BindingIdx = class'TMConsolePlayerController'.default.ProfileSettingToUE3BindingMapping360.length-1; BindingIdx >= 0; BindingIdx-- )
		{
			if( GetProfileSettingValueIdByName( class'TMConsolePlayerController'.default.ProfileSettingToUE3BindingMapping360[BindingIdx].ProfileSettingName, CurrentProfileValue) )
			{
				//SettingName = class'TMConsolePlayerController'.default.ProfileSettingToUE3BindingMapping360[BindingIdx].ProfileSettingName;
				KeyName = class'TMConsolePlayerController'.default.ProfileSettingToUE3BindingMapping360[BindingIdx].UE3BindingName;
				KeyCommand = DigitalButtonActionsToCommandMapping[CurrentProfileValue];

				//`Log("### - Applying joy binding setting:"@SettingName@"Key:"@KeyName@"Command:"@KeyCommand);
				PInput.SetBind(KeyName, KeyCommand);
			}
		}

	}
}

/**
 * Applies a key binding to the given player input, rebinds keys that are already bound, doesn't unbind keys already assigned to the action.
 *
 * @param InPlayerInput		PlayerInput to bind keys on
 * @param KeyBinding		Action to bind keys for.
 */
function ApplyKeyBinding(PlayerInput PInput, EDigitalButtonActions KeyBinding)
{
	local int KeyBindingValue;
	local int CurrentProfileValue;
	local name KeyName;
	local string KeyCommand;
	local int BindingIdx;

	if(GetProfileSettingValueInt(GetProfileIDForDBA(KeyBinding), CurrentProfileValue))
	{
		// Unpack value
		for(BindingIdx=0;BindingIdx<4;BindingIdx++)
		{
			KeyBindingValue = 0xFF & (CurrentProfileValue>>(BindingIdx*8));
			KeyName = FindKeyName(ETMBindableKeys(KeyBindingValue));
			KeyCommand = DigitalButtonActionsToCommandMapping[KeyBinding];

			// Unbind the current value first
			if(KeyBindingValue != 0 && KeyName != '' && Len(KeyCommand)>0)
			{
				//`Log("### - Applying keybinding Key:"@KeyName@"Command:"@KeyCommand);
				PInput.SetBind(KeyName, KeyCommand);
			}
		}
	}
}

/** Removes any binds the profile manages. */
function RemoveDBABindings( PlayerInput PInput )
{
	local int BindingIdx, DBAIdx;

	for ( BindingIdx = 0; BindingIdx < PInput.Bindings.length; BindingIdx++ )
	{
		for ( DBAIdx = 0; DBAIdx < DigitalButtonActionsToCommandMapping.length; DBAIdx++ )
		{
			if ( PInput.Bindings[BindingIdx].Command == DigitalButtonActionsToCommandMapping[DBAIdx] )
			{
				//`Log("### - Removing keybinding Key:"@PInput.Bindings[BindingIdx].Name@"Command:"@DigitalButtonActionsToCommandMapping[DBAIdx]);
				PInput.Bindings.Remove(BindingIdx, 1);
				BindingIdx--;
				break;
			}
		}
	}
}

/** Whether an action has been bound or not. */
function bool ActionIsBound(EDigitalButtonActions ActionIdx)
{
	local int Idx, Value;

	for ( Idx = TMPID_GamepadBinding_ButtonA; Idx <= TMPID_GamepadBinding_DPadRight; Idx++ )
	{
		if ( GetProfileSettingValueId(Idx, Value) )
		{
			if ( Value == ActionIdx )
			{
				return true;
			}
		}
	}

	return false;
}

// Returns the string of an action name.
function string GetActionName(EDigitalButtonActions ActionIdx)
{
	local string ActionName;
	local int ProfileSettingIDIndex, Idx;

	ActionName = "";

	for ( ProfileSettingIDIndex = 0; ProfileSettingIDIndex < ProfileMappings.length; ProfileSettingIDIndex++ )
	{
		if ( ProfileMappings[ProfileSettingIDIndex].Id == TMPID_GamepadBinding_ButtonA )
		{
			for ( Idx = 0; Idx < ProfileMappings[ProfileSettingIDIndex].ValueMappings.Length; Idx++ )
			{
				if (ProfileMappings[ProfileSettingIDIndex].ValueMappings[Idx].Id == int(ActionIdx))
				{
					ActionName = string(ProfileMappings[ProfileSettingIDIndex].ValueMappings[Idx].Name);
					break;
				}
			}
		}
	}

	return ActionName;
}

