class MOHACamMod_ScreenShake extends CameraModifier
    native;

enum EShakeParam
{
    ESP_OffsetRandom,               // 0
    ESP_OffsetZero,                 // 1
    ESP_MAX                         // 2
};

struct native ShakeParams
{
    var() MOHACamMod_ScreenShake.EShakeParam X;
    var() MOHACamMod_ScreenShake.EShakeParam Y;
    var() MOHACamMod_ScreenShake.EShakeParam Z;
    var const transient byte Padding;

    structdefaultproperties
    {
        X=0
        Y=0
        Z=0
        Padding=0
    }
};

struct native ScreenShakeStruct
{
    var() float TimeToGo;
    var() float TimeDuration;
    var() Vector RotAmplitude;
    var() Vector RotFrequency;
    var Vector RotSinOffset;
    var() ShakeParams RotParam;
    var() Vector LocAmplitude;
    var() Vector LocFrequency;
    var Vector LocSinOffset;
    var() ShakeParams LocParam;
    var() float FOVAmplitude;
    var() float FOVFrequency;
    var float FOVSinOffset;
    var() MOHACamMod_ScreenShake.EShakeParam FOVParam;

    structdefaultproperties
    {
        TimeToGo=0.0000000
        TimeDuration=1.0000000
        RotAmplitude=(X=100.0000000,Y=100.0000000,Z=200.0000000)
        RotFrequency=(X=10.0000000,Y=10.0000000,Z=25.0000000)
        RotSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RotParam=(X=0,Y=0,Z=0,Padding=0)
        LocAmplitude=(X=0.0000000,Y=3.0000000,Z=5.0000000)
        LocFrequency=(X=1.0000000,Y=10.0000000,Z=20.0000000)
        LocSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        LocParam=(X=0,Y=0,Z=0,Padding=0)
        FOVAmplitude=2.0000000
        FOVFrequency=5.0000000
        FOVSinOffset=0.0000000
        FOVParam=0
    }
};

var array<ScreenShakeStruct> Shakes;
var() ScreenShakeStruct TestShake;

final function AddScreenShake(ScreenShakeStruct NewShake)
{
    Shakes[Shakes.Length] = InitializeShake(NewShake);
    //return;    
}

final function ScreenShakeStruct InitializeShake(ScreenShakeStruct NewShake)
{
    NewShake.TimeToGo = NewShake.TimeDuration;
    // End:0xE1
    if(!IsZero(NewShake.RotAmplitude))
    {
        NewShake.RotSinOffset.X = InitializeOffset(NewShake.RotParam.X);
        NewShake.RotSinOffset.Y = InitializeOffset(NewShake.RotParam.Y);
        NewShake.RotSinOffset.Z = InitializeOffset(NewShake.RotParam.Z);
    }
    // End:0x1A3
    if(!IsZero(NewShake.LocAmplitude))
    {
        NewShake.LocSinOffset.X = InitializeOffset(NewShake.LocParam.X);
        NewShake.LocSinOffset.Y = InitializeOffset(NewShake.LocParam.Y);
        NewShake.LocSinOffset.Z = InitializeOffset(NewShake.LocParam.Z);
    }
    // End:0x1DF
    if(NewShake.FOVAmplitude != float(0))
    {
        NewShake.FOVSinOffset = InitializeOffset(NewShake.FOVParam);
    }
    return NewShake;
    //return ReturnValue;    
}

static final function float InitializeOffset(MOHACamMod_ScreenShake.EShakeParam param)
{
    switch(param)
    {
        // End:0x1F
        case 0:
            return (FRand() * float(2)) * 3.1415930;
            // End:0x30
            break;
        // End:0x2D
        case 1:
            return 0.0000000;
            // End:0x30
            break;
        // End:0xFFFF
        default:
            break;
    }
    return 0.0000000;
    //return ReturnValue;    
}

final function ScreenShakeStruct ComposeNewShake(float Duration, Vector newRotAmplitude, Vector newRotFrequency, Vector newLocAmplitude, Vector newLocFrequency, float newFOVAmplitude, float newFOVFrequency)
{
    local ScreenShakeStruct NewShake;

    NewShake.TimeDuration = Duration;
    NewShake.RotAmplitude = newRotAmplitude;
    NewShake.RotFrequency = newRotFrequency;
    NewShake.LocAmplitude = newLocAmplitude;
    NewShake.LocFrequency = newLocFrequency;
    NewShake.FOVAmplitude = newFOVAmplitude;
    NewShake.FOVFrequency = newFOVFrequency;
    NewShake.RotParam.X = 1;
    NewShake.RotParam.Y = 1;
    NewShake.RotParam.Z = 1;
    return NewShake;
    //return ReturnValue;    
}

function StartNewShake(float Duration, Vector newRotAmplitude, Vector newRotFrequency, Vector newLocAmplitude, Vector newLocFrequency, float newFOVAmplitude, float newFOVFrequency)
{
    local ScreenShakeStruct NewShake;

    // End:0x1A
    if(Duration == -1.0000000)
    {
        Shakes.Length = 0;        
    }
    else
    {
        NewShake = ComposeNewShake(Duration, newRotAmplitude, newRotFrequency, newLocAmplitude, newLocFrequency, newFOVAmplitude, newFOVFrequency);
        AddScreenShake(NewShake);
    }
    //return;    
}

function DumpShakeInfo(ScreenShakeStruct Shake)
{
    //return;    
}

// Export UMOHACamMod_ScreenShake::execUpdateScreenShake(FFrame&, void* const)
native function UpdateScreenShake(float DeltaTime, out ScreenShakeStruct Shake, out TPOV OutPOV);

function bool ModifyCamera(Camera Camera, float DeltaTime, out TPOV OutPOV)
{
    local int I;
    local ScreenShakeStruct lShake;

    super.ModifyCamera(Camera, DeltaTime, OutPOV);
    // End:0xCA
    if(Shakes.Length > 0)
    {
        I = 0;
        J0x28:

        // End:0x7D [Loop If]
        if(I < Shakes.Length)
        {
            lShake = Shakes[I];
            UpdateScreenShake(DeltaTime, lShake, OutPOV);
            Shakes[I] = lShake;
            I++;
            // [Loop Continue]
            goto J0x28;
        }
        I = Shakes.Length - 1;
        J0x8C:

        // End:0xCA [Loop If]
        if(I >= 0)
        {
            // End:0xC0
            if(Shakes[I].TimeToGo <= float(0))
            {
                Shakes.Remove(I, 1);
            }
            I--;
            // [Loop Continue]
            goto J0x8C;
        }
    }
    UpdateScreenShake(DeltaTime, TestShake, OutPOV);
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    TestShake=(TimeToGo=0.0000000,TimeDuration=1.0000000,RotAmplitude=(X=100.0000000,Y=100.0000000,Z=200.0000000),RotFrequency=(X=10.0000000,Y=10.0000000,Z=25.0000000),RotSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotParam=(X=0,Y=0,Z=0,Padding=0),LocAmplitude=(X=0.0000000,Y=3.0000000,Z=5.0000000),LocFrequency=(X=1.0000000,Y=10.0000000,Z=20.0000000),LocSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),LocParam=(X=0,Y=0,Z=0,Padding=0),FOVAmplitude=2.0000000,FOVFrequency=5.0000000,FOVSinOffset=0.0000000,FOVParam=0)
}