class SeqAct_OnScreenTextPersistent extends SequenceAction
    abstract
    native;

var bool bIsCompleted;
/** The Title and Message to display.  You setup them in kismet editor use markup */
var() bool bShowTitle;
/** Flag for "Move and Look" tutorial */
var() bool bLookMoveTutorial;
var() string TitleMarkUpString;
var() string MessageMarkUpString;
/** The scene to display for this text */
var() UIScene Scene;
/**  
 *Time in seconds we want this text dialog on the screen
 * If the value is 0.f then this dialog is to remain open and doesn't have a duration.
 */
var() float DialogDuration;
/** Button index to look up the Input Key for clearing the on screen text display */
var() PandoraPlayerInput.ECommand CommandIndex;
var PandoraPlayerController DisplayedInPlayerController;

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 1;
    //return ReturnValue;    
}
