///////////////////////////////////////////////////////////////////////////////
//
// SwatOfficerStart.uc - the SwatOfficerStart class
// Placed object that spawns officers when we begin the game

class SwatOfficerStart extends SwatStartPointBase
    placeable
	native;
///////////////////////////////////////////////////////////////////////////////

enum EOfficerStartType
{
	RedOneStart,
	RedTwoStart,
	BlueOneStart,
	BlueTwoStart
};

var() EOfficerStartType OfficerStartType;

var   private Texture	OfficerStartPointIcons[EOfficerStartType.EnumCount];
var   private bool		bOfficerStartCheckedForNumberErrors;

///////////////////////////////////////////////////////////////////////////////

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

///////////////////////////////////////////////////////////////////////////////

private function class<SwatOfficer> GetOfficerClass()
{
	switch (OfficerStartType)
	{
		case RedOneStart:
			return class'OfficerRedOne';
		case RedTwoStart:
			return class'OfficerRedTwo';
		case BlueOneStart:
			return class'OfficerBlueOne';
		case BlueTwoStart:
			return class'OfficerBlueTwo';
	}
}

function SpawnOfficer()
{
	local SwatOfficer SpawnedOfficer;
	SpawnedOfficer = Spawn(GetOfficerClass(),,,Location,Rotation);
	assertWithDescription((SpawnedOfficer != None), "SwatOfficerStart::SpawnOfficer - "@name@" could not spawn an officer at location:"@Location);
}

///////////////////////////////////////////////////////////////////////////////









// Decompiled with UE Explorer.
defaultproperties
{
    OfficerStartPointIcons[0]=Texture'SWAT4editorTex.R1start'
    OfficerStartPointIcons[1]=Texture'SWAT4editorTex.R2start'
    OfficerStartPointIcons[2]=Texture'SWAT4editorTex.B1start'
    OfficerStartPointIcons[3]=Texture'SWAT4editorTex.B2start'
    Texture=Texture'SWAT4editorTex.R1start'
}