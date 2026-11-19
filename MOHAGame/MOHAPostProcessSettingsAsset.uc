class MOHAPostProcessSettingsAsset extends Object
    native;

struct native MOHAPostProcessSettings
{
    var() Vector HighLights;
    var() Vector MidTones;
    var() Vector Shadows;
    var() float Desaturation;
    var() float InterpInTime;
    var() float FlatTime;
    var() float InterpOutTime;

    structdefaultproperties
    {
        HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000)
        MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000)
        Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Desaturation=0.0000000
        InterpInTime=0.2500000
        FlatTime=0.5000000
        InterpOutTime=0.2500000
    }
};

var(LowHealth) MOHAPostProcessSettings LowHealth_StartSettings;
var(LowHealth) MOHAPostProcessSettings LowHealth_EndSettings;
var(LowHealth) MOHAPostProcessSettings LowHealth_HBSettings;
var(LowHealth) float LowHealth_HBStartSpeed;
var(LowHealth) int LowHealth_Priority;
var(Dying) MOHAPostProcessSettings Dying_Settings;
var(Dying) Texture2D Dying_CurveTexture;
var(Dying) int Dying_Priority;
var(Medkit) MOHAPostProcessSettings Medkit_Settings;
var(Medkit) Texture2D Medkit_CurveTexture;
var(Medkit) int Medkit_Priority;
var(ItemPickup) MOHAPostProcessSettings ItemPickup_Settings;
var(ItemPickup) Texture2D ItemPickup_CurveTexture;
var(ItemPickup) int ItemPickup_Priority;
var(Explosion) MOHAPostProcessSettings Explosion_LowSettings;
var(Explosion) MOHAPostProcessSettings Explosion_HighSettings;
var(Explosion) Texture2D Explosion_SecondCurveTexture;
var(Explosion) MOHAPostProcessSettings Explosion_FlashSettings;
var(Explosion) Texture2D Explosion_FlashCurveTexture;
var(Explosion) float Explosion_DistanceRadius;
var(Explosion) bool Explosion_ScaleTimeBasedOnDistance;
var(Explosion) bool Explosion_ScaleEffectStrengthBasedOnDistance;
var(Explosion) float Explosion_DoubleVisionExtreme;
var(Explosion) float Explosion_DoubleVisionVariance;
var(Explosion) float Explosion_Frequency;
var(Explosion) float Explosion_VarianceFrequency;
var(Explosion) float Explosion_DoubleVisionSpeedUp;
var(Explosion) int Explosion_Priority;
var(MeleeHit) MOHAPostProcessSettings MeleeHit_FirstSettings;
var(MeleeHit) Texture2D MeleeHit_FirstCurveTexture;
var(MeleeHit) MOHAPostProcessSettings MeleeHit_SecondSettings;
var(MeleeHit) Texture2D MeleeHit_SecondCurveTexture;
var(MeleeHit) float MeleeHit_DoubleVisionExtreme;
var(MeleeHit) float MeleeHit_DoubleVisionVariance;
var(MeleeHit) float MeleeHit_Frequency;
var(MeleeHit) float MeleeHit_VarianceFrequency;
var(MeleeHit) float MeleeHit_DoubleVisionSpeedUp;
var(MeleeHit) int MeleeHit_Priority;
var(SpotLight) MOHAPostProcessSettings SpotLight_Settings;
var(SpotLight) Texture2D SpotLight_CurveTexture;
var(SpotLight) int SpotLight_Priority;
var(BulletHit) MOHAPostProcessSettings BulletHit_Settings;
var(BulletHit) Texture2D BulletHit_CurveTexture;
var(BulletHit) int BulletHit_Priority;

defaultproperties
{
    LowHealth_StartSettings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    LowHealth_EndSettings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    LowHealth_HBSettings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    Dying_Settings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    Medkit_Settings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    ItemPickup_Settings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    Explosion_LowSettings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    Explosion_HighSettings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    Explosion_FlashSettings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    MeleeHit_FirstSettings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    MeleeHit_SecondSettings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    SpotLight_Settings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    BulletHit_Settings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
}