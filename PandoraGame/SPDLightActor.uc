class SPDLightActor extends PointLight
    native;

var export editinline PointLightComponent PointLight;
var float fadeDownTime;
var float fadeDownStartTime;
var float fadeDownEndTime;

function SetBrightness(float Brightness)
{
    PointLight.SetLightProperties(Brightness, PointLight.LightColor, PointLight.Function);
    //return;    
}

function SetRadius(float Radius)
{
    PointLight.Radius = Radius;
    //return;    
}

function SetColor(Color LightColor)
{
    PointLight.SetLightProperties(PointLight.Brightness, LightColor, PointLight.Function);
    //return;    
}

function float GetBrightness()
{
    return PointLight.Brightness;
    //return ReturnValue;    
}

function float GetRadius()
{
    return PointLight.Radius;
    //return ReturnValue;    
}

function Color GetColor()
{
    return PointLight.LightColor;
    //return ReturnValue;    
}

simulated function FadeDown(float TimeSec)
{
    //return;    
}

auto simulated state Waiting
{
    simulated function FadeDown(float TimeSec)
    {
        fadeDownTime = TimeSec;
        GotoState('StateFadeDown');
        //return;        
    }
    stop;    
}

simulated state StateFadeDown
{
    simulated function BeginState(name PreviousStateName)
    {
        fadeDownStartTime = WorldInfo.TimeSeconds;
        fadeDownEndTime = fadeDownStartTime + fadeDownTime;
        SetTimer(0.0160000, true, 'FadeDownLight');
        //return;        
    }

    simulated function FadeDownLight()
    {
        local float Brightness;

        // End:0xE9
        if(PointLight != none)
        {
            Brightness = PointLight.Brightness;
            // End:0x92
            if(WorldInfo.TimeSeconds < fadeDownEndTime)
            {
                Brightness = (fadeDownEndTime - WorldInfo.TimeSeconds) / fadeDownTime;
                PointLight.SetLightProperties(Brightness, PointLight.LightColor, PointLight.Function);                
            }
            else
            {
                PointLight.SetLightProperties(0.0000000, PointLight.LightColor, PointLight.Function);
                PointLight.SetEnabled(false);
                ClearTimer('FadeDownLight');
                Destroy();
            }
        }
        //return;        
    }
    stop;    
}
