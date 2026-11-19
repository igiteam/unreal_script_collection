// extend UIAction if this action should be UI Kismet Action instead of a Level Kismet Action
class FhSeqAct_HelpMessage extends SequenceAction;

/** The Message you wish to display */
var() string displayMessage;

/** The duration in seconds to display the message */
var() float  displayTime;

/** The color to display the message in */
var() Color  displayColor;

/** The relative screen position of the message. (.5, .5) is the screen center. Refers to the upper left corner of the displayed text. */
var() Vector displayPosition;

/** The Font for the message */
var() Font   displayFont;


event Activated()
	{
	local FHPlayerController pc;
	pc = FHPlayerController(GetWorldInfo().GetALocalPlayerController());
	pc.DrawGameMessage (displayMessage, displayTime, displayColor, displayPosition, displayFont);
	}


// Decompiled with UE Explorer.
defaultproperties
{
    DisplayTime=4.0000000
    DisplayColor=(R=255,G=255,B=255,A=255)
    displayPosition=(X=0.0200000,Y=0.7500000,Z=0.0000000)
    ObjName="Show Help Message"
    ObjCategory="Forever Hunted"
}