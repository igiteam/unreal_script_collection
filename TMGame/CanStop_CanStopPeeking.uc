class CanStop_CanStopPeeking extends DelegateCanStop;

function bool Execute()
{
	return animscripts_corner.CanStopPeeking();
}
