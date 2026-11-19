class SoundNodeAmbient extends SoundNode
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() SoundNodeAttenuation.SoundDistanceModel DistanceModel;
var() noclear export editinline DistributionFloat MinRadius;
var() noclear export editinline DistributionFloat MaxRadius;
var() bool bSpatialize;
var() bool bAttenuate;
var() SoundNodeWave Wave;
var() noclear export editinline DistributionFloat VolumeModulation;
var() noclear export editinline DistributionFloat PitchModulation;

defaultproperties
{
    // Reference: DistributionFloatUniform'Default__SoundNodeAmbient.DistributionMinRadius'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionMinRadius" class=Class'DistributionFloatUniform'
        Min=400.0000000
        Max=400.0000000
    end object
    MinRadius=DistributionMinRadius
    // Reference: DistributionFloatUniform'Default__SoundNodeAmbient.DistributionMaxRadius'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionMaxRadius" class=Class'DistributionFloatUniform'
        Min=5000.0000000
        Max=5000.0000000
    end object
    MaxRadius=DistributionMaxRadius
    bSpatialize=true
    bAttenuate=true
    // Reference: DistributionFloatUniform'Default__SoundNodeAmbient.DistributionVolume'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionVolume" class=Class'DistributionFloatUniform'
        Min=1.0000000
        Max=1.0000000
    end object
    VolumeModulation=DistributionVolume
    // Reference: DistributionFloatUniform'Default__SoundNodeAmbient.DistributionPitch'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionPitch" class=Class'DistributionFloatUniform'
        Min=1.0000000
        Max=1.0000000
    end object
    PitchModulation=DistributionPitch
}