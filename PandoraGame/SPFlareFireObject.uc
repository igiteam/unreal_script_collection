class SPFlareFireObject extends SPFireObject
    placeable;

/** local location of light */
var() Vector lightLocation;
var() float LightBrightness;
var() float LightRadius;
var() int lightRed;
var() int lightGreen;
var() int lightBlue;
var() float flareBurnTime;
var() float ScaleFactor;

function AddLight()
{
    local SPDLightActorNoCastShadow lightActor;

    lightLocation += Location;
    lightActor = Spawn(Class'SPDLightActorNoCastShadow',,, lightLocation);
    // End:0xF6
    if(lightActor != none)
    {
        lightActor.LifeSpan = self.LifeSpan;
        lightActor.SetBrightness(LightBrightness);
        lightActor.SetRadius(LightRadius);
        lightActor.SetColor(MakeColor(byte(lightRed), byte(lightGreen), byte(lightBlue), 255));
        lightActor.SetBase(self);
        lightActor.SetOwner(self);
        LightObject = lightActor;
        LightObject.bKillDuringLevelTransition = true;
    }
    //return;    
}
