////////////////////////////////////////////
// TriggerChangeZoneParams.uc
////////////////////////////////////////////

class TriggerChangeZoneParams extends Trigger;

var(ZoneSound) editinline I3DL2Listener	ZoneEffect;
var(ZoneSound) Sound					StereoAmbience;
var(ZoneSound) ESoundZone				SoundZone;

//<kris>
var(DynamicGamma) bool AffectDynamicGamma;
var(DynamicGamma) float Bias;
var(DynamicGamma) float DarkClamp;
var(DynamicGamma) float LightClamp;
var(DynamicGamma) float DarkDT;
var(DynamicGamma) float LightDT;
var(DynamicGamma) float ContrastDT;
var(DynamicGamma) float DarkThreshold;
var(DynamicGamma) float LightThreshold;

//
// Called when something touches the trigger.
//
function Touch( actor Other )
{
	if( IsRelevant( Other ) )
	{
		Super.Touch( Other );

		// Change the sound properties inside of ZoneInfo
		region.zone.SetProps( ZoneEffect, StereoAmbience, SoundZone );

		if( AffectDynamicGamma )
		{
			region.zone.Bias = Bias;
			region.zone.DarkClamp = DarkClamp;
			region.zone.LightClamp = LightClamp;
			region.zone.DarkDT = DarkDT;
			region.zone.LightDT = LightDT;
			region.zone.ContrastDT = ContrastDT;
			region.zone.DarkThreshold = DarkThreshold;
			region.zone.LightThreshold = LightThreshold;
		}
	}
}

