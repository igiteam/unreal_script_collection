class LevelStreaming extends Object
    abstract
    native
    editinlinenew;

var() const editconst name PackageName;
var const transient Level LoadedLevel;
var() const Vector Offset;
var const Vector OldOffset;
var const transient bool bIsVisible;
var const transient bool bHasLoadRequestPending;
var const bool bShouldBeVisibleInEditor;
var const bool bBoundingBoxVisible;
var const bool bLocked;
var const bool bShouldBlockOnLoad;

defaultproperties
{
    bShouldBeVisibleInEditor=true
}