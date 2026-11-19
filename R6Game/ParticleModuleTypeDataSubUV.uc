class ParticleModuleTypeDataSubUV extends ParticleModuleTypeDataBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

enum ESubUVInterpMethod
{
    PSSUVIM_Linear,                 // 0
    PSSUVIM_Linear_Blend,           // 1
    PSSUVIM_Random,                 // 2
    PSSUVIM_Random_Blend,           // 3
    PSSUVIM_MAX                     // 4
};

var(Particle) int SubImages_Horizontal;
var(Particle) int SubImages_Vertical;
var(Particle) ParticleModuleTypeDataSubUV.ESubUVInterpMethod InterpolationMethod;
var bool DirectUV;

defaultproperties
{
    SubImages_Horizontal=1
    SubImages_Vertical=1
}