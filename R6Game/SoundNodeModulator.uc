class SoundNodeModulator extends SoundNode
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() noclear export editinline DistributionFloat VolumeModulation;
var() noclear export editinline DistributionFloat PitchModulation;

defaultproperties
{
    // Reference: DistributionFloatUniform'Default__SoundNodeModulator.DistributionVolume'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionVolume" class=Class'DistributionFloatUniform'
        Min=0.9000000
        Max=1.1000000
    end object
    VolumeModulation=DistributionVolume
    // Reference: DistributionFloatUniform'Default__SoundNodeModulator.DistributionPitch'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionPitch" class=Class'DistributionFloatUniform'
        Min=0.9000000
        Max=1.1000000
    end object
    PitchModulation=DistributionPitch
}