class TurokParticleModuleLightEmitterLinkRadius extends TurokParticleModuleLightEmitterLinkBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var() @NULL RadiusBase;
var() @NULL RadiusModifier;

defaultproperties
{
    RadiusBase=(Distribution=// Reference: DistributionFloatConstant'Default__TurokParticleModuleLightEmitterLinkRadius.LightRadiusBase'
    begin object name=LightRadiusBase class=Class'Engine.DistributionFloatConstant'
    end object
    Distribution=LightRadiusBase,Type=0,Op=1,LookupTableNumElements=1,LookupTableElementSize=1,LookupTable=/* Array type was not detected. */,LookupTableTimeScale=0.0000000,LookupTableStartTime=0.0000000)
    RadiusModifier=(Distribution=// Reference: DistributionFloatConstant'Default__TurokParticleModuleLightEmitterLinkRadius.LightRadiusModifier'
    begin object name=LightRadiusModifier class=Class'Engine.DistributionFloatConstant'
        Constant=1.0000000
    end object
    Distribution=LightRadiusModifier,Type=0,Op=1,LookupTableNumElements=1,LookupTableElementSize=1,LookupTable=/* Array type was not detected. */,LookupTableTimeScale=0.0000000,LookupTableStartTime=0.0000000)
    bUpdateModule=true
}