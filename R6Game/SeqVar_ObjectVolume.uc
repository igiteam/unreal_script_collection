class SeqVar_ObjectVolume extends SeqVar_Object
    native
    hidecategories(Object);

var float LastUpdateTime;
var array<Object> ContainedObjects;
var() array< Class > ExcludeClassList;
var() bool bCollidingOnly;

defaultproperties
{
    ExcludeClassList[0]=Class'Trigger'
    ExcludeClassList[1]=Class'Volume'
    bCollidingOnly=true
    ObjName="Object Volume"
}