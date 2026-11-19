class PointLightFlicker extends PointLightMovable;

var() float Frequency;
var float Brightness;
var float TargetBrightness;

simulated function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    Brightness = LightComponent.Brightness;
    Enable('Tick');
    SetTimer(Frequency, true, 'Flicker');
    //return;    
}

function Flicker()
{
    TargetBrightness = FRand();
    //return;    
}

simulated function Tick(float DeltaTime)
{
    // End:0x26
    if(Abs(Brightness - TargetBrightness) < 0.2100000)
    {
        Brightness = TargetBrightness;        
    }
    else
    {
        // End:0x44
        if(Brightness < TargetBrightness)
        {
            Brightness += 0.2000000;            
        }
        else
        {
            Brightness -= 0.2000000;
        }
    }
    LightComponent.SetLightProperties(Brightness, LightComponent.LightColor, LightComponent.Function);
    super(Actor).Tick(DeltaTime);
    //return;    
}
