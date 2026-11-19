class UIString extends UIRoot
    transient
    native;

var native transient array<Pointer> Nodes;
var export editinline UIStyle_Combo DefaultStringStyle;
var transient UIRoot.ETextClipMode StringClipMode;

// Export UUIString::execSetValue(FFrame&, void* const)
native final function bool SetValue(string InputString, optional bool bIgnoreMarkup);

// Export UUIString::execGetValue(FFrame&, void* const)
native final function string GetValue(optional bool bReturnProcessedText);

defaultproperties
{
    // Reference: UIStyle_Combo'Default__UIString.StringComboStyle'
    begin object name="StringComboStyle" class=Class'UIStyle_Combo'
    end object
    DefaultStringStyle=StringComboStyle
}