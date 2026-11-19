//=============================================================================
// InternetInfo: Parent class for Internet connection classes
//=============================================================================
class InternetInfo extends Info
	native
	transient;

//JP - Added for SysLink
event int GetBeaconCount()
{
    return (0);
}

event string GetBeaconAddress( int i );
event string GetBeaconText( int i );
event StartQuery( optional bool shouldCheckID, optional bool IsLive );
event StopQuery();

