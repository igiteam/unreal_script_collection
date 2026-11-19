//***********************************************************************
// Class:		SPDAction_SpawnLight
// Description:
// Created By:  Asim Naseer, Spark Unlimited 2005
//***********************************************************************

class SPDAction_SpawnLight extends SPDAction_SpawnActor
	editinlinenew
	NotPlaceable;

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

// DK removed for testing flickering light
//var (SPDAction) float Brightness;

var (SPDAction) color LightColor;
var (SPDAction) float Radius;

// DK added for testing flickering light
struct SineWave {
	var () float CycleTime;
	var () float Min;
	var () float Max;
};
var (Flicker) SineWave Waves[3];
var (Flicker) SineWave OffsetX;
var (Flicker) SineWave OffsetY;
var (Flicker) SineWave OffsetZ;
var (Flicker) float FadeInTime;
var (Flicker) float FadeOutTime;


//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )
{
	local SPDLightActor newLight;
	local LightComponent lcomponent;
	local PointLightComponent pcomponent;
	// DK added for testing flickering light
	local int WavesIdx;


	newLight = SPDLightActor( CreateActor( manager, actor, DamageInfo ) );
	if ( newLight != None )
	{
		// DK added for testing flickering light
		for (WavesIdx=0; WavesIdx < 3; WavesIdx++)
		{
			newLight.Waves[WavesIdx].CycleTime = Waves[WavesIdx].CycleTime;
			newLight.Waves[WavesIdx].Min       = Waves[WavesIdx].Min;
			newLight.Waves[WavesIdx].Max       = Waves[WavesIdx].Max;
		}
		newLight.OffsetX.CycleTime = OffsetX.CycleTime;
		newLight.OffsetX.Min       = OffsetX.Min;
		newLight.OffsetX.Max       = OffsetX.Max;
		newLight.OffsetY.CycleTime = OffsetY.CycleTime;
		newLight.OffsetY.Min       = OffsetY.Min;
		newLight.OffsetY.Max       = OffsetY.Max;
		newLight.OffsetZ.CycleTime = OffsetZ.CycleTime;
		newLight.OffsetZ.Min       = OffsetZ.Min;
		newLight.OffsetZ.Max       = OffsetZ.Max;
		newLight.FadeInTime = FadeInTime;
		newLight.FadeOutTime = FadeOutTime;
		newLight.LifeSpanLimit = LifeSpanLimit;
		
		lcomponent = newLight.GetLightComponent();
		if ( lcomponent != None )
		{
			pcomponent = PointLightComponent( lcomponent );
			if ( pcomponent != None )
			{
				pcomponent.Radius = Radius;
			}
			// DK removed for testing flickering light
			//lcomponent.Brightness = Brightness;
			//lcomponent.Brightness = 0.0f;
			
			//lcomponent.LightColor = LightColor;
			lcomponent.SetLightProperties( , LightColor, );
			lcomponent.SetEnabled(TRUE);
		}

		FindBestSpotForSpawnLocation(newLight);
	}
	return SPDActionState_Done;
}

//***********************************************************************
// Default Properties
//***********************************************************************

