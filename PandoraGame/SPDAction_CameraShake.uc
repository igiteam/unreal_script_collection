class SPDAction_CameraShake extends SPDAction
    editinlinenew
    collapsecategories;

/** VARIABLE DECLARATIONS */
var() ScreenShakeStruct CameraShake;
var() float InfluenceRadius;
var() float GlobalScale;
var() float GlobalAmplitudeScale;
var() float GlobalFrequencyScale;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local PlayerController PCFound, PC;
    local float ShakeDist;
    local ScreenShakeStruct TempCameraShake;
    local float AmplitudeScale, FrequencyScale;

    // End:0x1CC
    if(Actor != none)
    {
        // End:0xBE
        foreach Manager.GetWorldInfo().AllControllers(Class'Engine.PlayerController', PC)
        {
            // End:0xBD
            if((PC.Pawn != none) && PandoraPlayerController(PC.Pawn.Controller) != none)
            {
                ShakeDist = VSize(Actor.Location - PC.Pawn.Location);
                // End:0xBD
                if(ShakeDist < InfluenceRadius)
                {
                    PCFound = PC;
                    // End:0xBE
                    break;
                }
            }            
        }        
        // End:0x1CC
        if(PCFound != none)
        {
            AmplitudeScale = GlobalScale * GlobalAmplitudeScale;
            FrequencyScale = GlobalScale * GlobalFrequencyScale;
            TempCameraShake = CameraShake;
            TempCameraShake.TimeDuration *= GlobalScale;
            TempCameraShake.RotAmplitude *= AmplitudeScale;
            TempCameraShake.RotFrequency *= FrequencyScale;
            TempCameraShake.LocAmplitude *= AmplitudeScale;
            TempCameraShake.LocFrequency *= FrequencyScale;
            TempCameraShake.FOVAmplitude *= AmplitudeScale;
            TempCameraShake.FOVFrequency *= FrequencyScale;
            PandoraPlayerController(PCFound.Pawn.Controller).PlayCameraShake(TempCameraShake);
        }
    }
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    CameraShake=(TimeToGo=0.0000000,TimeDuration=1.0000000,RotAmplitude=(X=100.0000000,Y=100.0000000,Z=200.0000000),RotFrequency=(X=10.0000000,Y=10.0000000,Z=25.0000000),RotSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),LocAmplitude=(X=0.0000000,Y=3.0000000,Z=5.0000000),LocFrequency=(X=1.0000000,Y=10.0000000,Z=20.0000000),LocSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),LocParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),FOVAmplitude=2.0000000,FOVFrequency=5.0000000,FOVSinOffset=0.0000000,FOVParam=ESP_OffsetRandom,OnStopBlendOutTime=1.0000000,Id="None")
    GlobalScale=1.0000000
    GlobalAmplitudeScale=1.0000000
    GlobalFrequencyScale=1.0000000
    Action="Shake Camera"
}