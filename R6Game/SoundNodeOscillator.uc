class SoundNodeOscillator extends SoundNode
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() noclear export editinline DistributionFloat Amplitude;
var() noclear export editinline DistributionFloat Frequency;
var() noclear export editinline DistributionFloat Offset;
var() noclear export editinline DistributionFloat Center;
var() bool bModulatePitch;
var() bool bModulateVolume;

defaultproperties
{
    // Reference: DistributionFloatUniform'Default__SoundNodeOscillator.DistributionAmplitude'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionAmplitude" class=Class'DistributionFloatUniform'
    end object
    Amplitude=DistributionAmplitude
    // Reference: DistributionFloatUniform'Default__SoundNodeOscillator.DistributionFrequency'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionFrequency" class=Class'DistributionFloatUniform'
    end object
    Frequency=DistributionFrequency
    // Reference: DistributionFloatUniform'Default__SoundNodeOscillator.DistributionOffset'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionOffset" class=Class'DistributionFloatUniform'
    end object
    Offset=DistributionOffset
    // Reference: DistributionFloatUniform'Default__SoundNodeOscillator.DistributionCenter'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionCenter" class=Class'DistributionFloatUniform'
    end object
    Center=DistributionCenter
}