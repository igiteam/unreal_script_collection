class SPDAction_ChangePointLight extends SPDAction_Latent
    native
    editinlinenew
    collapsecategories;

struct native BrighnessChangeType
{
    /** STRUCT DECLARATIONS */
    var() float Value;
    /** STRUCT DECLARATIONS */
    var() bool bEnabled;

    structdefaultproperties
    {
        Value=0.0000000
        bEnabled=false
    }
};

struct native ColorChangeType
{
    var() Color Value;
    var() bool bEnabled;

    structdefaultproperties
    {
        Value=(R=0,G=0,B=0,A=0)
        bEnabled=false
    }
};

struct native RadiusChangeType
{
    var() float Value;
    var() bool bEnabled;

    structdefaultproperties
    {
        Value=0.0000000
        bEnabled=false
    }
};

struct native SPDAction_ChangePointLight_Transient
{
    var Color InitialColor;
    var float InitialBrightness;
    var float InitialRadius;
    var float Counter;

    structdefaultproperties
    {
        InitialColor=(R=0,G=0,B=0,A=0)
        InitialBrightness=0.0000000
        InitialRadius=0.0000000
        Counter=0.0000000
    }
};

/** VARIABLE DECLARATIONS */
var(SPDAction) BrighnessChangeType Brightness;
var(SPDAction) ColorChangeType LightColor;
var(SPDAction) RadiusChangeType Radius;
var(SPDAction) float TimeInSeconds;
var SPDAction_ChangePointLight_Transient Data;

// Export USPDAction_ChangePointLight::execPushDataNative(FFrame&, void* const)
native function PushDataNative(SPDProcessManager Manager);

// Export USPDAction_ChangePointLight::execPopDataNative(FFrame&, void* const)
native function PopDataNative(SPDProcessManager Manager);

event SPDProcessManager.SPDActionState Enter(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local SPDLightActor lightActor;

    // End:0x10
    if(TimeInSeconds <= float(0))
    {
        return 1;
    }
    lightActor = SPDLightActor(Actor);
    // End:0x2E
    if(lightActor == none)
    {
        return 1;
    }
    Data.Counter = TimeInSeconds;
    Data.InitialBrightness = lightActor.GetBrightness();
    Data.InitialColor = lightActor.GetColor();
    Data.InitialRadius = lightActor.GetRadius();
    return 0;
    //return ReturnValue;    
}

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local SPDLightActor lightActor;
    local Color NewColor;
    local float NewRadius, NewBrightness, Alpha;

    Data.Counter -= ElapsedTime;
    // End:0x28A
    if(Data.Counter > 0.0000000)
    {
        Alpha = Data.Counter / TimeInSeconds;
        lightActor = SPDLightActor(Actor);
        // End:0xC8
        if(Brightness.bEnabled)
        {
            NewBrightness = (Brightness.Value * (1.0000000 - Alpha)) + (Data.InitialBrightness * Alpha);
            lightActor.SetBrightness(NewBrightness);
        }
        // End:0x221
        if(LightColor.bEnabled)
        {
            NewColor.R = byte((float(LightColor.Value.R) * (1.0000000 - Alpha)) + (float(Data.InitialColor.R) * Alpha));
            NewColor.G = byte((float(LightColor.Value.G) * (1.0000000 - Alpha)) + (float(Data.InitialColor.G) * Alpha));
            NewColor.B = byte((float(LightColor.Value.B) * (1.0000000 - Alpha)) + (float(Data.InitialColor.B) * Alpha));
            lightActor.SetColor(NewColor);
        }
        // End:0x284
        if(Radius.bEnabled)
        {
            NewRadius = (Radius.Value * (1.0000000 - Alpha)) + Data.InitialRadius;
            lightActor.SetRadius(NewRadius);
        }
        return 0;        
    }
    else
    {
        return 1;
    }
    //return ReturnValue;    
}

event Exit(Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local SPDLightActor lightActor;

    lightActor = SPDLightActor(Actor);
    // End:0x1D
    if(lightActor == none)
    {
        return;
    }
    // End:0x55
    if(Brightness.bEnabled)
    {
        lightActor.SetBrightness(Brightness.Value);
    }
    // End:0x8D
    if(LightColor.bEnabled)
    {
        lightActor.SetColor(LightColor.Value);
    }
    // End:0xC5
    if(Radius.bEnabled)
    {
        lightActor.SetRadius(Radius.Value);
    }
    //return;    
}

defaultproperties
{
    Brightness=(Value=1.0000000,bEnabled=false)
    LightColor=(Value=(R=255,G=255,B=255,A=0),bEnabled=false)
    Radius=(Value=1000.0000000,bEnabled=false)
    TimeInSeconds=1.0000000
    Action="Action Change Point Light - Changes the lights attributes over time"
}