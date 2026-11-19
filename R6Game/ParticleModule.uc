class ParticleModule extends Object
    abstract
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum EModuleType
{
    EPMT_General,                   // 0
    EPMT_TypeData,                  // 1
    EPMT_Beam,                      // 2
    EPMT_Trail,                     // 3
    EPMT_MAX                        // 4
};

enum EParticleSourceSelectionMethod
{
    EPSSM_Random,                   // 0
    EPSSM_Sequential,               // 1
    EPSSM_MAX                       // 2
};

var bool bSpawnModule;
var bool bUpdateModule;
var bool bCurvesAsColor;
var bool b3DDrawMode;
var bool bSupported3DDrawMode;
var bool bEnabled;
var bool bEditable;
var(Cascade) Color ModuleEditorColor;

defaultproperties
{
    bEnabled=true
    bEditable=true
}