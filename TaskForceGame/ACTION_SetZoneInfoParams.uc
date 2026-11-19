class ACTION_SetZoneInfoParams extends ScriptedAction;

struct ZoneLightStruct {

	var() bool	bChangeAmbientLight;
	var() byte	AmbientBrightness, 
				AmbientHue, 
				AmbientSaturation;
				
	var() color	DistanceFogColor;
	var() float	DistanceFogStart,
				DistanceFogEnd,
				DistanceFogBlendTime;
				
	var() bool	bChangeEnvMap;
	var() float	TexUPanSpeed,
				TexVPanSpeed;
};

struct ZoneSoundStruct {

	var() bool			bChangeSound;
	var() editinline	I3DL2Listener ZoneEffect;
	var() Sound			StereoAmbience;
	var() ESoundZone	SoundZone;
};

struct ZoneInfoParams {

	var() localized String	LocationName;
	
	var() bool				bChangeKillZ;
	var() float				KillZ;
	var() EKillZType		KillZType;
	var() bool				bSoftKillZ;
		
	var() bool				bChangeDistanceFog;
	var() bool				bClearToFogColor;
	var() bool				bDistanceFog;

	var() ZoneLightStruct	ZoneLight;
	var() ZoneSoundStruct	ZoneSound;
};

var(Action) name						ZoneInfoTag;
var(ZOneInfo) editinline ZoneInfoParams	NewParams;

function bool InitActionFor ( ScriptedController C ) {
		
	local ZoneInfo MyZoneInfo;

	
	if ( ZoneInfoTag != '' ) {
	
		// find the ZoneInfo
		ForEach C.AllActors ( class'ZoneInfo', MyZoneInfo, ZoneInfoTag )
			break;
			
		if ( MyZoneInfo != None ) {
		
			ChangeZoneInfoParams ( MyZoneInfo, C );
		}
	}
	return false;
}

function ChangeZoneInfoParams ( ZoneInfo CurrZoneInfo, ScriptedController C ) {

	local PlayerController pc;
	
	if ( CurrZoneInfo != None ) {
	
		if ( NewParams.LocationName != "" ) {
		
			CurrZoneInfo.LocationName = NewParams.LocationName;
		}
	
		// Kill Z Settings
		if ( NewParams.bChangeKillZ ) {
		
			CurrZoneInfo.KillZ = NewParams.KillZ;
			CurrZoneInfo.KillZType = NewParams.KillZType;
			CurrZoneInfo.bSoftKillZ = NewParams.bSoftKillZ;
		}
		
		// Distance Fog Settings
		if ( NewParams.bChangeDistanceFog ) {
								
			CurrZoneInfo.bDistanceFog = NewParams.bDistanceFog;
			CurrZoneInfo.DistanceFogColor = NewParams.ZoneLight.DistanceFogColor;
			CurrZoneInfo.DistanceFogStart = NewParams.ZoneLight.DistanceFogStart;
			CurrZoneInfo.DistanceFogEnd = NewParams.ZoneLight.DistanceFogEnd;
			CurrZoneInfo.DistanceFogBlendTime = NewParams.ZoneLight.DistanceFogBlendTime;
			
			ForEach C.AllActors ( class'PlayerController', pc )
				break;
		
			if ( pc != None ) {
			
				if ( pc.Pawn != None && pc.Pawn.Region.Zone == CurrZoneInfo ) 
				{
					pc.TimeSinceLastFogChange = 0;
				}
			}
		}

		// Ambient Light Settings
		if ( NewParams.ZoneLight.bChangeAmbientLight ) {

			CurrZoneInfo.AmbientBrightness = NewParams.ZoneLight.AmbientBrightness;
			CurrZoneInfo.AmbientHue = NewParams.ZoneLight.AmbientHue;
			CurrZoneInfo.AmbientSaturation = NewParams.ZoneLight.AmbientSaturation;
		}
				
		// Env Map Settings (that aren't const)
		if ( NewParams.ZoneLight.bChangeEnvMap ) {
		
			CurrZoneInfo.TexUPanSpeed = NewParams.ZoneLight.TexUPanSpeed;
			CurrZoneInfo.TexVPanSpeed = NewParams.ZoneLight.TexVPanSpeed;
		}
		
		// Zone Sound Settings
		if ( NewParams.ZoneSound.bChangeSound ) {
		
			CurrZoneInfo.ZoneEffect = NewParams.ZoneSound.ZoneEffect;
			CurrZoneInfo.StereoAmbience = NewParams.ZoneSound.StereoAmbience;
			CurrZoneInfo.SoundZone = NewParams.ZoneSound.SoundZone;
		}
	}
}

function string GetActionString ( ) {

	return ActionString;
}


// Decompiled with UE Explorer.
defaultproperties
{
    ActionString="set zone info params"
}