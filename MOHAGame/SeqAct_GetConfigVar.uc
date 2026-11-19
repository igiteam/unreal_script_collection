class SeqAct_GetConfigVar extends SeqAct_SetSequenceVariable
    native
    hidecategories(Object);

enum EConfigFile
{
    CONFIGFILE_EngineINI,           // 0
    CONFIGFILE_EditorINI,           // 1
    CONFIGFILE_EditorUserSettingsINI,// 2
    CONFIGFILE_InputINI,            // 3
    CONFIGFILE_GameINI,             // 4
    CONFIGFILE_JuiceINI,            // 5
    CONFIGFILE_PlayerINI,           // 6
    CONFIGFILE_WeaponINI,           // 7
    CONFIGFILE_MAX                  // 8
};

enum EVariableType
{
    VARIABLETYPE_Int,               // 0
    VARIABLETYPE_Bool,              // 1
    VARIABLETYPE_Float,             // 2
    VARIABLETYPE_String,            // 3
    VARIABLETYPE_MAX                // 4
};

var() SeqAct_GetConfigVar.EConfigFile ConfigFile;
var() SeqAct_GetConfigVar.EVariableType VariableType;
var() string ConfigSection;
var() string VariableName;
var int TargetInt;
var float TargetFloat;
var bool TargetBool;
var string TargetString;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="TargetString",LinkVar="None",PropertyName="TargetString",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="TargetFloat",LinkVar="None",PropertyName="TargetFloat",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Bool',LinkedVariables=none,LinkDesc="TargetBool",LinkVar="None",PropertyName="TargetBool",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[3]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="TargetInt",LinkVar="None",PropertyName="TargetInt",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Get Config Var"
}