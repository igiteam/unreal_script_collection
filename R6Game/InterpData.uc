class InterpData extends SequenceVariable
    native
    hidecategories(Object);

var float InterpLength;
var float PathBuildTime;
var export array<export InterpGroup> InterpGroups;
var export InterpCurveEdSetup CurveEdSetup;
var float EdSectionStart;
var float EdSectionEnd;

defaultproperties
{
    InterpLength=5.0000000
    EdSectionStart=1.0000000
    EdSectionEnd=2.0000000
    ObjName="Matinee Data"
    ObjColor=(R=255,G=128,B=0,A=255)
}