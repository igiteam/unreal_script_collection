class CCLevelInfo extends Actor
    native
    placeable
    hidecategories(Navigation,Attachment,Collision,Object);

struct native CCNationalitySettings
{
    var() init array<init int> ValidVoiceIDs;
    var() CCChannelAudio.ENationality Nationality;

    structdefaultproperties
    {
        ValidVoiceIDs=none
        Nationality=1
    }
};

var() CCPerformanceSet2 PerformanceSet;
var() export editinline array<export editinline CCNationalitySettings> NationalitySettings;
var(Debug) float PACloseToCameraThresh;

defaultproperties
{
    PACloseToCameraThresh=20.0000000
    // Reference: SpriteComponent'Default__CCLevelInfo.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'MOHAEngineMaterials.CCLevelInfo'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
}