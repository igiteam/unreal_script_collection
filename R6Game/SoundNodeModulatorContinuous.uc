class SoundNodeModulatorContinuous extends SoundNode
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() noclear export editinline DistributionFloat VolumeModulation;
var() noclear export editinline DistributionFloat PitchModulation;

defaultproperties
{
    // Reference: DistributionFloatUniform'Default__SoundNodeModulatorContinuous.DistributionVolume'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionVolume" class=Class'DistributionFloatUniform'
        Min=1.0000000
        Max=1.0000000
    end object
    VolumeModulation=DistributionVolume
    // Reference: DistributionFloatUniform'Default__SoundNodeModulatorContinuous.DistributionPitch'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionPitch" class=Class'DistributionFloatUniform'
        Min=1.0000000
        Max=1.0000000
    end object
    PitchModulation=DistributionPitch
}