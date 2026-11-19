//-----------------------------------------------------------
// base on HD_GFx_GameSetting.fla
//-----------------------------------------------------------

class HDGameSetting extends Object
	  config(Engine)
	  dependson(HDSystemSet,TMProfileSettings);

var array<string> Resolution_Array;

// variable
var transient GFxObject HD_GameSettingMC;
var transient GFxObject HD_Set_ControlMC;
var transient GFxObject HD_Set_VideoAudioMC;

var transient GFxObject HD_Set_Control_MouseSensitivity;

var transient GFxObject HD_Set_VideoAudio_MusicVolume;
var transient GFxObject HD_Set_VideoAudio_SoundEffectVolume;
var transient GFxObject HD_Set_VideoAudio_VoiceVolume;
var transient GFxObject HD_Set_VideoAudio_Chatting;
var transient GFxObject HD_Set_VideoAudio_FullScreen;
var transient GFxObject HD_Set_VideoAudio_Resolution;
var transient GFxObject HD_Set_VideoAudio_Quality;
var transient GFxObject HD_Set_VideoAudio_Brightness;

var float Audio_MusicVolume;              // Audio volume, 0 - 1(0.5)
var float Audio_SoundEffectVolume;        // Sound effect, 0 - 1(0.5)
var float Audio_VoiceVolume;              // Voice volume, 0 - 1(0.6)
var int Audio_Chatting;                 // Chatting (1)

var int Video_FullScreen;               // Fullscreen
var int Video_Resolution;             // Resolution
var int Video_Quality;               // Quanlity
var float Video_Brightness;              // Brightness, 1.0~3.0(2.2 is default)

var int Control_MouseSensitivity;

var config array<string> Control_KeySetting;       // Control set

var array<string> Control_KeySetting_tmp;

struct ChangedNameMap
{
	var int     index;
	var Name    value;
};
var array<ChangedNameMap>                   ChangedNameMapArray;
var array<Name>                             CommandNameArray;

var HDEntryPlayerController PlayerController;
var TMProfileSettings Profile;
var HDPlayerInput PlayerInput;
var HDSystemSet SystemSet;

var Array<string> ResolutionString;

var int iCurrentPage;  // 1 for control, 2 for VideoAudio

function InitControlSetting ()
{
	if (iCurrentPage != 2)
	{
	   // Set resolution
	   ResolutionString = CheckSystemSet ();

	   GetSystemVideoSet ();

	   GetMouseSensitivity ();
	   Control_KeySetting_tmp      = Control_KeySetting;
	}

	iCurrentPage = 1;

	HD_Set_ControlMC = HD_GameSettingMC.GetObject("Control_KeySetting");
	HD_Set_Control_MouseSensitivity = HD_Set_ControlMC.GetObject("Control_MouseSensitivity");

	HD_Set_Control_MouseSensitivity.SetFloat("value", float(Control_MouseSensitivity));
}

function InitVideoAudioSetting ()
{
	local GFxObject ResolutionDataProvider;
	local int Idx;

	iCurrentPage = 2;
	// Set volumes
	HD_Set_VideoAudioMC = HD_GameSettingMC.GetObject("VideoAudio_Setting");

	HD_Set_VideoAudio_MusicVolume       = HD_Set_VideoAudioMC.GetObject("AudioSetting_MusicVolume");
	HD_Set_VideoAudio_SoundEffectVolume = HD_Set_VideoAudioMC.GetObject("AudioSetting_SoundEffectVolume");
	HD_Set_VideoAudio_VoiceVolume       = HD_Set_VideoAudioMC.GetObject("AudioSetting_VoiceVolume");
	HD_Set_VideoAudio_Chatting          = HD_Set_VideoAudioMC.GetObject("AudioSetting_Chatting");

	HD_Set_VideoAudio_FullScreen        = HD_Set_VideoAudioMC.GetObject("VideoSetting_FullScreen");
	HD_Set_VideoAudio_Resolution        = HD_Set_VideoAudioMC.GetObject("VideoSetting_Resolution");
	HD_Set_VideoAudio_Quality           = HD_Set_VideoAudioMC.GetObject("VideoSetting_Quality");
	HD_Set_VideoAudio_Brightness        = HD_Set_VideoAudioMC.GetObject("VideoSetting_Brightness");

//  Use Array fill HD_Set_VideoAudio_Resolution
	ResolutionDataProvider = HD_Set_VideoAudio_Resolution.Outer.CreateArray();

	for(Idx=0;Idx<ResolutionString.Length;Idx++)
		 {
		  ResolutionDataProvider.SetElementString(Idx,ResolutionString[Idx]);
		 }
	HD_Set_VideoAudio_Resolution.SetObject("dataProvider", ResolutionDataProvider);

	HD_Set_VideoAudio_MusicVolume.SetFloat("value", Audio_MusicVolume*100.0f);
	HD_Set_VideoAudio_SoundEffectVolume.SetFloat("value", Audio_SoundEffectVolume*100.0f);
	HD_Set_VideoAudio_VoiceVolume.SetFloat("value", Audio_VoiceVolume*100.0f);
	HD_Set_VideoAudio_Chatting.SetFloat("_selectedIndex", float(Audio_Chatting));

	HD_Set_VideoAudio_FullScreen.SetFloat("_selectedIndex", float(Video_FullScreen));
	HD_Set_VideoAudio_Resolution.SetFloat("_selectedIndex", Video_Resolution);
	HD_Set_VideoAudio_Quality.SetFloat("_selectedIndex", float(Video_Quality));
	HD_Set_VideoAudio_Brightness.SetFloat("value", (Video_Brightness-1.0f)*50.0f);
	HD_Set_VideoAudio_Resolution.ActionScriptVoid("invalidateData"); //Updata Show Message
}

function SetControlValue ()
{
	Control_MouseSensitivity = int(HD_Set_Control_MouseSensitivity.GetFloat("value"));
}

function SetVideoAudioValue ()
{
	Audio_MusicVolume       = HD_Set_VideoAudio_MusicVolume.GetFloat("value")/100.0f;
	Audio_SoundEffectVolume = HD_Set_VideoAudio_SoundEffectVolume.GetFloat("value")/100.0f;
	Audio_VoiceVolume       = HD_Set_VideoAudio_VoiceVolume.GetFloat("value")/100.0f;
	Audio_Chatting          = int(HD_Set_VideoAudio_Chatting.GetFloat("_selectedIndex"));

	Video_FullScreen        = int(HD_Set_VideoAudio_FullScreen.GetFloat("_selectedIndex"));
	Video_Resolution        = int(HD_Set_VideoAudio_Resolution.GetFloat("_selectedIndex"));
	Video_Quality           = int(HD_Set_VideoAudio_Quality.GetFloat("_selectedIndex"));
	Video_Brightness        = HD_Set_VideoAudio_Brightness.GetFloat("value")/50.0f+1.0f;
}

function ResetSetting ()
{
	GetSystemVideoSet ();
	GetMouseSensitivity ();
	Control_KeySetting_tmp  = Control_KeySetting;

	if (iCurrentPage == 1)
	{
		HD_Set_Control_MouseSensitivity.SetFloat("value", float(Control_MouseSensitivity));
	}
	else if (iCurrentPage == 2)
	{
		HD_Set_VideoAudio_MusicVolume.SetFloat("value", Audio_MusicVolume*100.0f);
		HD_Set_VideoAudio_SoundEffectVolume.SetFloat("value", Audio_SoundEffectVolume*100.0f);
		HD_Set_VideoAudio_VoiceVolume.SetFloat("value", Audio_VoiceVolume*100.0f);
		HD_Set_VideoAudio_Chatting.SetFloat("selectedIndex", float(Audio_Chatting));

		HD_Set_VideoAudio_FullScreen.SetFloat("selectedIndex", float(Video_FullScreen));
		HD_Set_VideoAudio_Resolution.SetFloat("selectedIndex", float(Video_Resolution));
		HD_Set_VideoAudio_Quality.SetFloat("selectedIndex", float(Video_Quality));
		HD_Set_VideoAudio_Brightness.SetFloat("value", (Video_Brightness-1.0f)*50.0f);
	}
}

function ApplySetting ()
{
	if (iCurrentPage == 1)
	{
	   Control_MouseSensitivity = int(HD_Set_Control_MouseSensitivity.GetFloat("value"));
	}
	else if (iCurrentPage == 2)
	{
	   Audio_MusicVolume       = HD_Set_VideoAudio_MusicVolume.GetFloat("value")/100.0f;
	   Audio_SoundEffectVolume = HD_Set_VideoAudio_SoundEffectVolume.GetFloat("value")/100.0f;
	   Audio_VoiceVolume       = HD_Set_VideoAudio_VoiceVolume.GetFloat("value")/100.0f;
	   Audio_Chatting          = int(HD_Set_VideoAudio_Chatting.GetFloat("selectedIndex"));

	   Video_FullScreen        = int(HD_Set_VideoAudio_FullScreen.GetFloat("selectedIndex"));
	   Video_Resolution        = int(HD_Set_VideoAudio_Resolution.GetFloat("selectedIndex"));
	   Video_Quality          = int(HD_Set_VideoAudio_Quality.GetFloat("selectedIndex"));
	   Video_Brightness        = HD_Set_VideoAudio_Brightness.GetFloat("value")/50.0f+1.0f;
	}

	// set key binding
	SetMouseSensitivity ();

	CompareKeyBindingChange();
	// copy temp setting to config setting
	Control_KeySetting = Control_KeySetting_tmp;

	SetKeyBinding ();

	// Video
	SetSystemVideoSet ();
}
function CompareKeyBindingChange()
{
	local int index;
	local Name nameOld, nameTmp;
	local ChangedNameMap tempMap;
	for ( index = 0; index < Control_KeySetting.Length; ++index )
	{
		nameOld = name( Control_KeySetting[index] );
		nameTmp = name( Control_KeySetting_tmp[index] );
		if ( nameOld != nameTmp )
		{
			tempMap.index = index;
			tempMap.value = nameOld;
			ChangedNameMapArray[ChangedNameMapArray.Length] = tempMap;
		}
	}
}

function SaveSetting ()
{
	SaveConfig ();
}

function SetSystemVideoSet ()
{
	local string sRes;
	local int xPos;
	sRes = ResolutionString[Video_Resolution];
	if(sRes != "")
	 {
	  xPos = InStr(sRes,"x");
	  SystemSet.ResX = int(Left(sRes,xPos));
	  SystemSet.ResY = int(Right(sRes,Len(sRes)-xPos-1));
	 }


	SystemSet.bFullScreen = bool(Video_FullScreen);
	SystemSet.Gamma = Video_Brightness;

	if (Video_Quality == 0)
	{
	 SystemSet.GraphLevel = GL_LOW;
	}
	else if (Video_Quality == 1)
	{
	 SystemSet.GraphLevel = GL_MID;
	}
	else if (Video_Quality == 2)
	{
	 SystemSet.GraphLevel = GL_HIGH;
	}

	SystemSet.CommitGraphicsSet();
}

function GetSystemVideoSet ()
{
   local int Idx;
   local string CurrRes;
   SystemSet.GetCurGraphicsSet ();


   if (SystemSet.bFullScreen)
   {
	Video_FullScreen = 1;
   }
   else
   {
	Video_FullScreen = 0;
   }
   CurrRes = SystemSet.ResX $ "x" $ SystemSet.ResY;

   for(Idx=0;Idx<ResolutionString.Length;Idx++)
	{

	   if (CurrRes ==ResolutionString[Idx] )
	   {
		Video_Resolution = Idx;
		Break;
	   }
	}

   Video_Brightness = SystemSet.Gamma;

   if (SystemSet.GraphLevel == GL_LOW)
   {
	Video_Quality = 0;
   }
   else if (SystemSet.GraphLevel == GL_MID)
   {
	Video_Quality = 1;
   }
   else if (SystemSet.GraphLevel == GL_HIGH)
   {
	Video_Quality = 2;
   }
}

function GetMouseSensitivity ()
{
	// Mouse Sensitivity (Game)
	if(Profile.GetProfileSettingValueIntByName('MouseSensitivityGame', Control_MouseSensitivity))
	{
		// Fix up non-patch values
		if ( Control_MouseSensitivity < 11 )  // Mouse sensitivity is between 0-100
		{
			Control_MouseSensitivity = 5 * Control_MouseSensitivity * 100;
		}
		Control_MouseSensitivity = Control_MouseSensitivity / 100;
	}
}

function SetMouseSensitivity ()
{
	if (Control_MouseSensitivity / 5 < 11)
	   {
		Profile.SetProfileSettingValueInt(423, Control_MouseSensitivity * 100); // TMPID_MouseSensitivityGame = 423
	   }

	PlayerController.PlayerInput.MouseSensitivity = Control_MouseSensitivity;
}

function SetKeyBinding ()
{
	// local Array<EDigitalButtonActions> KeyCommandArray;
	local Array<name> KeyMappingArray;
	local int i;
	local Name      OldName, ChangedName, CommandName;

	for (i=0; i<22; i++)
	{
	 if (Control_KeySetting[i] == "Mouse Left")
	 {
	  KeyMappingArray[i] = name("LeftMouseButton");
	 }
	 else if (Control_KeySetting[i] == "Mouse Right")
	 {
	  KeyMappingArray[i] = name("RightMouseButton");
	 }
	 else if (Control_KeySetting[i] == "LeftShift")
	 {
	  KeyMappingArray[i] = name("LeftShift");
	 }
	 else if (Control_KeySetting[i] == "LeftControl")
	 {
	  KeyMappingArray[i] = name("LeftControl");
	 }
	 else if (Control_KeySetting[i] == "LeftAlt")
	 {
	  KeyMappingArray[i] = name("LeftAlt");
	 }
	 else if (Control_KeySetting[i] == "Space")
	 {
	  KeyMappingArray[i] = name("SpaceBar");
	 }
	 else if (Control_KeySetting[i] == "Arrow Left")
	 {
	  KeyMappingArray[i] = name("Left");
	 }
	 else if (Control_KeySetting[i] == "Arrow Right")
	 {
	  KeyMappingArray[i] = name("Right");
	 }
	 else if (Control_KeySetting[i] == "Arrow Up")
	 {
	  KeyMappingArray[i] = name("Up");
	 }
	 else if (Control_KeySetting[i] == "Arrow Down")
	 {
	  KeyMappingArray[i] = name("Down");
	 }
	 else if (Control_KeySetting[i] == "Caps Lock")
	 {
	  KeyMappingArray[i] = name("Caps Lock");
	 }
	 else if (Control_KeySetting[i] == ";")
	 {
	  KeyMappingArray[i] = name("Semicolon");
	 }
	 else if (Control_KeySetting[i] == "=")
	 {
	  KeyMappingArray[i] = name("Equals");
	 }
	 else if (Control_KeySetting[i] == ",")
	 {
	  KeyMappingArray[i] = name("Comma");
	 }
	 else if (Control_KeySetting[i] == "-")
	 {
	  KeyMappingArray[i] = name("Underscore");
	 }
	 else if (Control_KeySetting[i] == "'")
	 {
	  KeyMappingArray[i] = name("Quote");
	 }
	 else if (Control_KeySetting[i] == ".")
	 {
	  KeyMappingArray[i] = name("Period");
	 }
	 else if (Control_KeySetting[i] == "/")
	 {
	  KeyMappingArray[i] = name("Slash");
	 }
	 else if (Control_KeySetting[i] == "`")
	 {
	  KeyMappingArray[i] = name("Tilde");
	 }
	 else if (Control_KeySetting[i] == "\\")
	 {
	  KeyMappingArray[i] = name("Backslash");
	 }
	 else if (Control_KeySetting[i] == "[")
	 {
	  KeyMappingArray[i] = name("LeftBracket");
	 }
	 else if (Control_KeySetting[i] == "]")
	 {
	  KeyMappingArray[i] = name("RightBracket");
	 }
	 else
	 {
	  KeyMappingArray[i] = name(Control_KeySetting[i]);
	 }
	}

	/*KeyCommandArray[0]  = DBA_MoveForward;     // ??
	KeyCommandArray[1]  = DBA_MoveBackward;    // ??
	KeyCommandArray[2]  = DBA_StrafeLeft;      // ??
	KeyCommandArray[3]  = DBA_StrafeRight;     // ??
	KeyCommandArray[4]  = DBA_Jump;            // ??
	KeyCommandArray[5]  = DBA_Duck;            // ??
	KeyCommandArray[6]  = DBA_Prone;           // ??
	KeyCommandArray[7]  = DBA_Fire;            // ??
	KeyCommandArray[8]  = DBA_ZoomFireMode;    // ??
	// KeyCommandArray[9]  = GBA_ToggleMelee;  // ????
	// KeyCommandArray[10] = DBA_Jump;         // ????
	KeyCommandArray[11] = DBA_Reload;          // ??
	KeyCommandArray[12] = DBA_Horn;            // ??
	KeyCommandArray[13] = DBA_FragGrenade;     // ??
	// KeyCommandArray[14] = DBA_Horn;            // ????
	KeyCommandArray[15] = ToggleNightVision;   // ???
	KeyCommandArray[16] = DBA_ToggleTelescope; // ???
	KeyCommandArray[17] = ToggleGasMask;       // ????
	KeyCommandArray[18] = DBA_Use;             // ????
	KeyCommandArray[19] = DBA_Talk;            // ??
	KeyCommandArray[20] = DBA_TeamTalk;        // ????
 */


//	PlayerInput.HDSetBind(KeyMappingArray[0], "GBA_MoveForward");
//	PlayerInput.HDSetBind(KeyMappingArray[1], "GBA_Backward");
//	PlayerInput.HDSetBind(KeyMappingArray[2], "GBA_StrafeLeft");
//	PlayerInput.HDSetBind(KeyMappingArray[3], "GBA_StrafeRight");
//	PlayerInput.HDSetBind(KeyMappingArray[4], "GBA_Jump");
//	PlayerInput.HDSetBind(KeyMappingArray[5], "GBA_Duck");
//	PlayerInput.HDSetBind(KeyMappingArray[6], "GBA_Prone");
//	// PlayerInput.SetBind(KeyMappingArray[7], "GBA_Fire");
//	// PlayerInput.SetBind(KeyMappingArray[8], "GBA_ZoomFireMode");
//	PlayerInput.HDSetBind(KeyMappingArray[9], "GBA_ToggleMelee");
//	// PlayerInput.SetBind(KeyMappingArray[10],
//	PlayerInput.HDSetBind(KeyMappingArray[11], "GBA_Reload");
//	PlayerInput.HDSetBind(KeyMappingArray[12], "GBA_Sprint");
//	PlayerInput.HDSetBind(KeyMappingArray[13], "GBA_FragGrenade");
//	// PlayerInput.SetBind(KeyMappingArray[14], "GBA_FlashGrenade");
//	PlayerInput.HDSetBind(KeyMappingArray[15], "ToggleNightVision");
//	PlayerInput.HDSetBind(KeyMappingArray[16], "GBA_ToggleTelescope");
//	PlayerInput.HDSetBind(KeyMappingArray[17], "ToggleGasMask");
//	PlayerInput.HDSetBind(KeyMappingArray[18], "GBA_Use|GBA_PickupItem");
//	PlayerInput.HDSetBind(KeyMappingArray[19], "GBA_Talk");
//	PlayerInput.HDSetBind(KeyMappingArray[20], "GBA_TeamTalk");
//	PlayerInput.HDSetBind(KeyMappingArray[21], "GBA_SwitchFireType");

  for ( i = 0; i < ChangedNameMapArray.Length; ++i )
  {
      OldName = ChangedNameMapArray[i].value;
      ChangedName = KeyMappingArray[ChangedNameMapArray[i].index];
      CommandName = CommandNameArray[ChangedNameMapArray[i].index];
      PlayerInput.SwitchBindName( oldName, ChangedName, CommandName );
  }
  	ChangedNameMapArray.Length = 0;
	PlayerInput.SaveConfig();
}

function Array<string> CheckSystemSet ()
{
//    local int i, iRet;
	local Array<string> kSet;
	local int i;
	SystemSet.GetPossibleScreenResolutions(kSet);
		for (i=0; i<kSet.length; i++)
		{
		   if (int(Left(kSet[i],4))>1920)
		   {
			   kSet.Remove(i,kSet.length);
			   break;
		   }
		}
		for (i=0; i<kSet.length; i++)
		{
		   if (int(Left(kSet[i],4))>640&& (i-1)>0 )
		   {
			   kSet.Remove(0,i-1);
			   break;
		   }
		}
	return kSet;
//
//    iRet = 0;
//    for (i=0; i<kSet.length; i++)
//    {
//       if (kSet[i] == "640x480")
//       {
//           iRet = iRet | 1;
//       }
//       else if (kSet[i] == "800x600")
//       {
//           iRet = iRet | 2;
//       }
//       else if (kSet[i] == "1024x768")
//       {
//           iRet = iRet | 4;
//       }
//       else if (kSet[i] == "1280x720")
//       {
//           iRet = iRet | 8;
//       }
//    }
//
//    return iRet;
}

