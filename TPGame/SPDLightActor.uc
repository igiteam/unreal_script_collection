//***********************************************************************
// Class:		SPDLightActor
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

class SPDLightActor extends PointLightMovable
	Placeable;

var PointLightComponent PointLight;

// DK added for testing flickering light
struct SineWave {
	var () float CycleTime;
	var () float Min;
	var () float Max;
};
var (Flicker) SineWave Waves[3];
var (Flicker) float FadeInTime;
var (Flicker) float FadeOutTime;
var (Flicker) float LifeSpanLimit;
var (Flicker) SineWave OffsetX;
var (Flicker) SineWave OffsetY;
var (Flicker) SineWave OffsetZ;
var float ElapsedTime;

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

//***********************************************************************
// CPP TEXT
//***********************************************************************

//***********************************************************************
// NATIVE FUNCTION DECLARATIONS
//***********************************************************************

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

function float ScaleSineWave(float Time, float CycleTime, float Min, float Max)
{
	return Sin(Time * ((2*PI) / CycleTime)) * 0.5f * (Max-Min) + Min;
}

// DK added for testing flickering light
event Tick( float DeltaTime )
{
	local int WavesIdx;
	local float SineWaveTotal;
	local float Scale;
	local vector NewLocation;
	//////////////////
	local LightComponent lcomponent;
	local PointLightComponent pcomponent;
	lcomponent = GetLightComponent();
	pcomponent = PointLightComponent(lcomponent);
	///////////////////
	
	if (lcomponent != None)
	{
		if (pcomponent != None)
		{
			if (LifeSpanLimit > 0)
			{
				if (ElapsedTime < LifeSpanLimit)
				{
					if (ElapsedTime < FadeInTime) // always fade in
					{
						Scale = ElapsedTime / FadeInTime;
					}
					else if (ElapsedTime >= LifeSpanLimit - FadeOutTime) // only fade out if you die (LifeSpanLimit=0:live forever)
					{
						Scale = 1.0f - (ElapsedTime - (LifeSpanLimit - FadeOutTime)) / FadeOutTime;
					}
					else
					{
						Scale = 1.0f;
					}
				}
				else
				{
					Destroy();
				}
			}
			else
			{
				Scale = 1.0f;
			}
			for (WavesIdx=0; WavesIdx < 3; WavesIdx++)
			{
				SineWaveTotal += ScaleSineWave(ElapsedTime, Waves[WavesIdx].CycleTime, Waves[WavesIdx].Min, Waves[WavesIdx].Max);
			}
			SineWaveTotal /= 3; // average all the sine waves
			//PointLight.Brightness = Scale * SineWaveTotal;
			PointLight.SetLightProperties( Scale * SineWaveTotal, , );
			NewLocation.X = ScaleSineWave(ElapsedTime, OffsetX.CycleTime, OffsetX.Min, OffsetX.Max);
			NewLocation.Y = ScaleSineWave(ElapsedTime, OffsetY.CycleTime, OffsetY.Min, OffsetY.Max);
			NewLocation.Z = ScaleSineWave(ElapsedTime, OffsetZ.CycleTime, OffsetZ.Min, OffsetZ.Max);
			pcomponent.SetTranslation(NewLocation);

			ElapsedTime += DeltaTime;
		}
	}
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function SetBrightness( float Brightness )
{
	//PointLight.Brightness = Brightness;
	PointLight.SetLightProperties( Brightness, , );
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function SetRadius( float Radius )
{
	PointLight.Radius = Radius;
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function SetColor( color LightColor )
{
	//PointLight.LightColor = LightColor;
	PointLight.SetLightProperties( , LightColor, );
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function float GetBrightness()
{
	return PointLight.Brightness;
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function float GetRadius()
{
	return PointLight.Radius;
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function color GetColor()
{
	return PointLight.LightColor;
}

