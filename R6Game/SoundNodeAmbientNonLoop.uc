class SoundNodeAmbientNonLoop extends SoundNodeAmbient
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

struct AmbientSoundSlot
{
    var() SoundNodeWave Wave;
    var() float PitchScale;
    var() float VolumeScale;
    var() float Weight;

    structdefaultproperties
    {
        Wave=none
        PitchScale=1.0000000
        VolumeScale=1.0000000
        Weight=1.0000000
    }
};

var() noclear export editinline DistributionFloat DelayTime;
var() array<AmbientSoundSlot> SoundSlots;

defaultproperties
{
    // Reference: DistributionFloatUniform'Default__SoundNodeAmbientNonLoop.DistributionDelayTime'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionDelayTime" class=Class'DistributionFloatUniform'
        Min=1.0000000
        Max=1.0000000
    end object
    DelayTime=DistributionDelayTime
}