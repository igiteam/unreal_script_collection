class TurokIrisSettingsActor extends Actor
    placeable
    hidecategories(Navigation)
    autoexpandcategories(IrisInformation);

var(IrisInformation) float mTargetAvgLuminance;
var(IrisInformation) float mAdaptSpeed;
var(IrisInformation) float mAdaptLuminanceMin;
var(IrisInformation) float mAdaptLuminanceMax;
var(IrisInformation) float mContrast;
var(IrisInformation) float mWhiteSquared;
var(IrisInformation) float mPercentageChangeClamp;
var(IrisInformation) bool mUseToneMapping;

simulated function OnSetTurokIris(@NULL Action)
{
    WorldInfo.DefaultTurokIrisSettings.mUseToneMapping = mUseToneMapping;
    WorldInfo.DefaultTurokIrisSettings.mTargetAvgLuminance = mTargetAvgLuminance;
    WorldInfo.DefaultTurokIrisSettings.mAdaptSpeed = mAdaptSpeed;
    WorldInfo.DefaultTurokIrisSettings.mAdaptLuminanceMin = mAdaptLuminanceMin;
    WorldInfo.DefaultTurokIrisSettings.mAdaptLuminanceMax = mAdaptLuminanceMax;
    WorldInfo.DefaultTurokIrisSettings.mContrast = mContrast;
    WorldInfo.DefaultTurokIrisSettings.mWhiteSquared = mWhiteSquared;
    WorldInfo.DefaultTurokIrisSettings.mPercentageChangeClamp = mPercentageChangeClamp;
    //return;    
}

defaultproperties
{
    mTargetAvgLuminance=0.0180000
    mAdaptSpeed=0.0400000
    mAdaptLuminanceMin=0.0080000
    mAdaptLuminanceMax=0.5000000
    mContrast=1.3000000
    mWhiteSquared=1.0000000
    mPercentageChangeClamp=0.3000000
    mUseToneMapping=true
    bStatic=true
    bNoDelete=true
    // Reference: SpriteComponent'Default__TurokIrisSettingsActor.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'TurokEditorResources.TurokIrisSettingsActor'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
}