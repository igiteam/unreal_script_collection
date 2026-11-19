class SequenceObject extends Object
    abstract
    native
    hidecategories(Object);

var const int ObjClassVersion;
var const int ObjInstanceVersion;
var const Sequence ParentSequence;
var int ObjPosX;
var int ObjPosY;
var string ObjName;
var string ObjCategory;
var Color ObjColor;
var() string ObjComment;
var bool bDrawFirst;
var bool bDrawLast;
var() bool bOutputObjCommentToScreen;
var int DrawWidth;
var int DrawHeight;

// Export USequenceObject::execScriptLog(FFrame&, void* const)
native final function ScriptLog(string LogText);

// Export USequenceObject::execGetWorldInfo(FFrame&, void* const)
native final function WorldInfo GetWorldInfo();

defaultproperties
{
    ObjClassVersion=1
    ObjName="Undefined"
    ObjColor=(R=255,G=255,B=255,A=255)
}