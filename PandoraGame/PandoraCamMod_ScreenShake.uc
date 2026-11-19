class PandoraCamMod_ScreenShake extends CameraModifier
    native;

enum EShakeParam
{
    ESP_OffsetRandom,               // 0
    ESP_OffsetZero,                 // 1
    ESP_MAX                         // 2
};

struct native ShakeParams
{
    /** Shake vector params */
    var() PandoraCamMod_ScreenShake.EShakeParam X;
    /** Shake vector params */
    var() PandoraCamMod_ScreenShake.EShakeParam Y;
    /** Shake vector params */
    var() PandoraCamMod_ScreenShake.EShakeParam Z;
    var const transient byte Padding;

    structdefaultproperties
    {
        X=ESP_OffsetRandom
        Y=ESP_OffsetRandom
        Z=ESP_OffsetRandom
        Padding=0
    }
};

struct native ScreenShakeStruct
{
    /** Time in seconds to go until current screen shake is finished */
    var() float TimeToGo;
    /** Duration in seconds of current screen shake */
    var() float TimeDuration;
    /** view rotation amplitude */
    var() Vector RotAmplitude;
    /** view rotation frequency */
    var() Vector RotFrequency;
    var Vector RotSinOffset;
    /** rotation parameters */
    var() ShakeParams RotParam;
    /** view offset amplitude */
    var() Vector LocAmplitude;
    /** view offset frequency */
    var() Vector LocFrequency;
    var Vector LocSinOffset;
    /** location parameters */
    var() ShakeParams LocParam;
    /** FOV amplitude */
    var() float FOVAmplitude;
    /** FOV frequency */
    var() float FOVFrequency;
    var float FOVSinOffset;
    /** FOV parameters */
    var() PandoraCamMod_ScreenShake.EShakeParam FOVParam;
    /** Takes this much time to stop */
    var() float OnStopBlendOutTime;
    var name Id;

    structdefaultproperties
    {
        TimeToGo=0.0000000
        TimeDuration=1.0000000
        RotAmplitude=(X=100.0000000,Y=100.0000000,Z=200.0000000)
        RotFrequency=(X=10.0000000,Y=10.0000000,Z=25.0000000)
        RotSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RotParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0)
        LocAmplitude=(X=0.0000000,Y=3.0000000,Z=5.0000000)
        LocFrequency=(X=1.0000000,Y=10.0000000,Z=20.0000000)
        LocSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        LocParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0)
        FOVAmplitude=2.0000000
        FOVFrequency=5.0000000
        FOVSinOffset=0.0000000
        FOVParam=ESP_OffsetRandom
        OnStopBlendOutTime=1.0000000
        Id="None"
    }
};

var array<ScreenShakeStruct> Shakes;
/** Always active ScreenShake for testing purposes */
var() ScreenShakeStruct TestShake;

// Export UPandoraCamMod_ScreenShake::execInitializeShake(FFrame&, void* const)
native final function InitializeShake(out ScreenShakeStruct NewShake);

// Export UPandoraCamMod_ScreenShake::execInitializeOffset(FFrame&, void* const)
native static final function float InitializeOffset(PandoraCamMod_ScreenShake.EShakeParam Param);

// Export UPandoraCamMod_ScreenShake::execAddScreenShake(FFrame&, void* const)
native static final function AddScreenShake(out ScreenShakeStruct NewShake);

final function StopAllShakes()
{
    local int I;

    I = Shakes.Length - 1;
    J0x0F:

    // End:0x30 [Loop If]
    if(I >= 0)
    {
        Shakes.Remove(I, 1);
        I--;
        // [Loop Continue]
        goto J0x0F;
    }
    //return;    
}

final function RemoveShakeById(name inId)
{
    local int I;

    I = Shakes.Length - 1;
    J0x0F:

    // End:0xF1 [Loop If]
    if(I >= 0)
    {
        // End:0xE7
        if((Shakes[I].Id != 'None') && Shakes[I].Id == inId)
        {
            // End:0xDB
            if(Shakes[I].OnStopBlendOutTime > float(0))
            {
                Shakes[I].TimeToGo = Shakes[I].OnStopBlendOutTime;
                Shakes[I].TimeDuration = Shakes[I].OnStopBlendOutTime;
                // [Explicit Continue]
                goto J0xE7;
            }
            Shakes.Remove(I, 1);
        }
        J0xE7:

        I--;
        // [Loop Continue]
        goto J0x0F;
    }
    //return;    
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

// Export UPandoraCamMod_ScreenShake::execUpdateScreenShake(FFrame&, void* const)
native function UpdateScreenShake(float DeltaTime, out ScreenShakeStruct Shake, out TPOV OutPOV);

function bool ModifyCamera(Camera Camera, float DeltaTime, out TPOV OutPOV)
{
    local int I;
    local ScreenShakeStruct CurrentScreenShake;

    super.ModifyCamera(Camera, DeltaTime, OutPOV);
    // End:0xCB
    if(Shakes.Length > 0)
    {
        I = 0;
        J0x28:

        // End:0x7D [Loop If]
        if(I < Shakes.Length)
        {
            CurrentScreenShake = Shakes[I];
            UpdateScreenShake(DeltaTime, CurrentScreenShake, OutPOV);
            Shakes[I] = CurrentScreenShake;
            I++;
            // [Loop Continue]
            goto J0x28;
        }
        I = Shakes.Length - 1;
        J0x8C:

        // End:0xCB [Loop If]
        if(I >= 0)
        {
            // End:0xC1
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
    TestShake=(TimeToGo=0.0000000,TimeDuration=1.0000000,RotAmplitude=(X=100.0000000,Y=100.0000000,Z=200.0000000),RotFrequency=(X=10.0000000,Y=10.0000000,Z=25.0000000),RotSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),LocAmplitude=(X=0.0000000,Y=3.0000000,Z=5.0000000),LocFrequency=(X=1.0000000,Y=10.0000000,Z=20.0000000),LocSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),LocParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),FOVAmplitude=2.0000000,FOVFrequency=5.0000000,FOVSinOffset=0.0000000,FOVParam=ESP_OffsetRandom,OnStopBlendOutTime=1.0000000,Id="None")
}