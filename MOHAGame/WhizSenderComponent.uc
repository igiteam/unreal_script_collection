class WhizSenderComponent extends Component
    native;

var float Speed;
var bool bEnabled;
var SoundCue Sound;

// Export UWhizSenderComponent::execSendWhizEvent(FFrame&, void* const)
native function SendWhizEvent(Vector From, Vector To, int types);

defaultproperties
{
    Speed=1875.0000000
    bEnabled=true
}