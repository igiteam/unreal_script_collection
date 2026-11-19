/**
 * Event which is activated when some pawn has a line of sight to an LOS trigger.
 * Originator: the trigger that owns this event
 * Instigator: the Pawn of the Player that saw the LOS trigger which owns this event
 */
class SeqEvent_TPLOS extends SequenceEvent;

/** Angle from the screen center before activating this event */
var() float AngleCenterDegrees;

/** Distance from the trigger before activating this event */
var() float TriggerDistance;

/** Force a clear line of sight to the trigger? */
var() bool bCheckForObstructions;

