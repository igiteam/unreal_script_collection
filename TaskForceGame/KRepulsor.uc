class KRepulsor extends Actor
	native;

var()	bool	bEnableRepulsion;
var()	vector	CheckDir; // In owner ref frame
var()	float	CheckDist;
var()	float	Softness;
var()	float	PenScale;

// Used internally for Karma stuff - DO NOT CHANGE!
var		transient const int		KContact;  


// Decompiled with UE Explorer.
defaultproperties
{
    CheckDir=(X=0.0000000,Y=0.0000000,Z=-1.0000000)
    CheckDist=50.0000000
    Softness=0.1000000
    PenScale=1.0000000
    RemoteRole=0
    bHardAttach=true
    bBlockZeroExtentTraces=false
    bBlockNonZeroExtentTraces=false
}