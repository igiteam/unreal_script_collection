class SoundNodeAttenuation extends SoundNode
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

enum SoundDistanceModel
{
    ATTENUATION_Linear,             // 0
    ATTENUATION_MAX                 // 1
};

var() SoundNodeAttenuation.SoundDistanceModel DistanceModel;
var() noclear export editinline DistributionFloat MinRadius;
var() noclear export editinline DistributionFloat MaxRadius;
var() bool bSpatialize;
var() bool bAttenuate;

defaultproperties
{
    // Reference: DistributionFloatUniform'Default__SoundNodeAttenuation.DistributionMinRadius'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionMinRadius" class=Class'DistributionFloatUniform'
        Min=400.0000000
        Max=400.0000000
    end object
    MinRadius=DistributionMinRadius
    // Reference: DistributionFloatUniform'Default__SoundNodeAttenuation.DistributionMaxRadius'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionMaxRadius" class=Class'DistributionFloatUniform'
        Min=5000.0000000
        Max=5000.0000000
    end object
    MaxRadius=DistributionMaxRadius
    bSpatialize=true
    bAttenuate=true
}