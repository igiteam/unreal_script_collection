class TurokParticleModuleLightIntensity extends TurokParticleModuleLightBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var() @NULL Intensity;

defaultproperties
{
    Intensity=(Distribution=// Reference: DistributionFloatConstant'Default__TurokParticleModuleLightIntensity.LightIntensity'
    begin object name=LightIntensity class=Class'Engine.DistributionFloatConstant'
        Constant=1.0000000
    end object
    Distribution=LightIntensity,Type=0,Op=1,LookupTableNumElements=1,LookupTableElementSize=1,LookupTable=/* Array type was not detected. */,LookupTableTimeScale=0.0000000,LookupTableStartTime=0.0000000)
    bUpdateModule=true
}