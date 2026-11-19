class SkyInteractionButtonMashCountRequest extends SkyInteractionButtonMashRequest
    native
    editinlinenew;

var() float TimeOut;
var() float MashCount;
var const name InputTimer;
var transient bool bInputAllowed;
var transient bool bTimedOut;

// Export USkyInteractionButtonMashCountRequest::execScoreCanBeTallied(FFrame&, void* const)
native function bool ScoreCanBeTallied();

// Export USkyInteractionButtonMashCountRequest::execRequestInstigatorInput(FFrame&, void* const)
native function RequestInstigatorInput();

// Export USkyInteractionButtonMashCountRequest::execInputTimeout(FFrame&, void* const)
native function InputTimeout();
