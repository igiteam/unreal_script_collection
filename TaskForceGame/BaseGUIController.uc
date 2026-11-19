// ====================================================================
//  Class:  Engine.BaseGUIController
//
//  This is just a stub class that should be subclassed to support menus.
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class BaseGUIController extends Interaction
		Native
		transient;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// Delegates
Delegate OnAdminReply(string Reply);	// Called By PlayerController

event bool OpenMenu( string NewMenuName, optional string param )
{
	return false;
}

event AutoLoadMenus();	// Subclass me

event bool CloseMenu()
{
	return true;
}

event CloseAll();

event bool ShowMessageBox( string DialogName );

event SetControllerStatus( bool On );

event InitializeController();	// Should be subclassed.

event bool NeedsMenuResolution(); // Big Hack that should be subclassed
event SetRequiredGameResolution(string GameRes);


// Decompiled with UE Explorer.
defaultproperties
{
    bActive=false
    bNativeEvents=true
}