/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * UIWIdget_CachedUILabel.uc
 * A UI label that stores a copy of its value, so that SetCachedText/HTMLText() can be called without fear of taking the Unreal -> GFx penalty unless the string has changed.
 */

class UIWidget_CachedUILabel extends GFxObject;

/** This is the cached value of the string.  Any time SetCachedText() or SetCachedHTMLText() is called, this is updated with the new contents of the label before being sent to GFx */
var private transient string    CachedValue;

/** Whether or not CachedValue has been updated with the value of the string, via calling SetCachedText/HTMLText().  If this is FALSE, then the displayed string is NOT guaranteed to be CachedValue */
var private transient bool      bInitialized;


/**
 *  Has this label been initialized by UnrealScript?  If so, CachedValue reflects what is being displayed by the label.  If not, CachedValue does NOT necessarily reflect what is in the label
 * 
 *  @return TRUE if the label has been set by Unreal, FALSE if not
 */
function bool IsInitialized()
{
	return bInitialized;
}

/**
 *  Sets the text for this label if the value is different than the cached value that we have stored
 *  
 *  @param  NewValue    The new value to send to the label
 */
function SetCachedText(coerce string NewValue)
{
	if( !bInitialized || (CachedValue != NewValue) )
	{
		bInitialized = TRUE;

		CachedValue = NewValue;
		ActionScript_SetCachedText(NewValue);
	}
}

/**
 *  Sets the HTML text for this label if the value is different than the cached value that we have stored
 *  
 *  @param  NewValue    The new value to send to the label
 */
function SetCachedHTMLText(coerce string NewValue)
{
	if( !bInitialized || (CachedValue != NewValue) )
	{
		bInitialized = TRUE;

		CachedValue = NewValue;
		ActionScript_SetCachedHTMLText(NewValue);
	}
}

/**
 *  Stub for calling the ActionScript function SetCachedText(), which updates the value of the label
 *  
 *  @param     NewValue     The new string to put in the label (plain text)
 */
private function ActionScript_SetCachedText(string NewValue)
{
	ActionScriptVoid("SetCachedText");
}

/**
 *  Stub for calling the ActionScript function SetCachedHTMLText(), which updates the value of the label using HTML
 *  
 *  @param     NewValue     The new string to put in the label (HTML)
 */
private function ActionScript_SetCachedHTMLText(string NewValue)
{
	ActionScriptVoid("SetCachedHTMLText");
}