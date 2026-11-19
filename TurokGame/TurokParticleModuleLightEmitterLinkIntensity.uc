class TurokParticleModuleLightEmitterLinkIntensity extends TurokParticleModuleLightEmitterLinkBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var() @NULL IntensityBase;
var() @NULL IntensityPerParticle;

defaultproperties
{
    IntensityBase=(Distribution=// Reference: DistributionFloatConstant'Default__TurokParticleModuleLightEmitterLinkIntensity.LightIntensityBase'
    begin object name=LightIntensityBase class=Class'Engine.DistributionFloatConstant'
    end object
    Distribution=LightIntensityBase,Type=0,Op=1,LookupTableNumElements=1,LookupTableElementSize=1,LookupTable=/* Array type was not detected. */,LookupTableTimeScale=0.0000000,LookupTableStartTime=0.0000000)
    IntensityPerParticle=(Distribution=// Reference: DistributionFloatConstant'Default__TurokParticleModuleLightEmitterLinkIntensity.LightIntensityPerParticle'
    begin object name=LightIntensityPerParticle class=Class'Engine.DistributionFloatConstant'
        Constant=0.1000000
    end object
    Distribution=LightIntensityPerParticle,Type=0,Op=1,LookupTableNumElements=1,LookupTableElementSize=1,LookupTable=/* Array type was not detected. */,LookupTableTimeScale=0.0000000,LookupTableStartTime=0.0000000)
    bUpdateModule=true
}