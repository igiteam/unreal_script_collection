
class TPSquad extends ReplicationInfo
	native;

//***********************************************************************
// INCLUDES
//***********************************************************************
//`include( Core\LoggingUPPMacros.uci ) // to use logging preprocessor macros












 







































#linenumber 9

//***********************************************************************
// MACROS
//***********************************************************************
//`define AILOG(c,t)

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************
enum ETPSquadCommands
{
	ETPSC_SquadCommand_None,
	ETPSC_SquadCommand_DefendArea
	//ADD new squad commands here...
};

enum ETPSquadCommandPriority
{
	ETPCP_SquadCommandPriority_None,
	ETPCP_SquadCommandPriority_Low,
	ETPCP_SquadCommandPriority_Medium,
	ETPCP_SquadCommandPriority_High
	//ADD new priorities here...
};

enum ETPDefendAreaDestAssignment
{
	ETPSDDA_DefensivePositions,
	ETPSDDA_ForwardPositions
};

struct SquadCommandDefendArea_Params
{
	var Volume							defendAreaVolume;	/** The volume we are trying to defend */
	var Trigger_Dynamic					defendAreaDynamicVolume;
	var ETPSquadCommandPriority			commandPriority;	/** The priority of the squad command */
	var ETPDefendAreaDestAssignment		destAssignment;
	var float							attackDistWhileDefendingArea;
};

enum ETPDefendAreaZones
{
    ETPDAZ_Front,
    ETPDAZ_Right,
    ETPDAZ_Left,
    ETPDAZ_Back,
    ETPDAZ_Maximus
};

struct native DefendAreaZoneInfo
{
    var ETPDefendAreaZones eZoneIdx;
    var int numOccupiedCover;
    var int numOccupiedNonCoverNodes;
};


//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************
var name m_squadName;					/** name of the squad */
var TPTeamInfo m_team;					/** The team this squad belongs to */
var array<Controller> m_members;		/** List of players in the squad */
var float m_morale;						/** Current squad morale level */
var array<int> m_damageReceivedCount;	/** Number of times this squad has been damaged since last update */
var array<int> m_damageGivenCount;		/** Number of times this squad has applied damage since last update */
var float m_damageReceivedFrequency;
var float m_damageGivenFrequency;

//Squad command
var ETPSquadCommands m_squadCommand;				/** Current squad command executing */
var ETPSquadCommandPriority m_squadCommandPriority;	/** The priority of the current squad command */

//Squad command DefendArea
var Volume m_defendAreaVolume;						        /** The volume we are trying to defend */
var Trigger_Dynamic m_defendAreaDynamicVolume;
var ETPDefendAreaDestAssignment m_defendAreaDestAssignment;
var array<NavigationPoint> m_defendAreaNodes;
var array<DefendAreaZoneInfo> m_defendAreaZoneInfo;
var vector m_defendAreaLastLoc;
var vector m_defendAreaOrientationLastLoc;
var rotator m_defendAreaDynamicOrientation; //Dynamic defend area's rotation is based on velccity vector...
var float m_attackDistWhileDefendingArea;

//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// NATIVE FUNCTION DECLARATIONS
//***********************************************************************

native function bool IsSquadDefendingArea();

 //-----------------------------------------------------------------------
// Function:
// Description: SPMIRROR: this function is mirrored with the same function
//              in SPAIController, if you change one you change the other
//              as well...
//-----------------------------------------------------------------------
native function bool IsPointInDefendArea(	Vector Loc, optional bool bNoIsDefendAreaCheck);

native function vector GetDefendAreaExtents();
native function bool GetDefendAreaCentroid(out vector centroid);

native final function TPAILog(INT LogDetailLevel,Name logCategory, string logText);

//***********************************************************************
// FUNCTION DECLARATIONS
//***********************************************************************


//-----------------------------------------------------------------------
// Function:
// Description:	Dumps a formatted log statement to the log file associated
//				with this AI controller.
//				@param	logCategory - category of information being dumped
//						(for filtering)
//				@param	logText - string to dump to log file
//-----------------------------------------------------------------------
//native final function SPAILog(Name logCategory, string logText);


//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************


//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function Initialize(Name squadName, TPTeamInfo team)
{
	if (m_team != None && m_team != team)
	{
		m_team.RemoveSquad(self);
	}

	//***SPAI TODO: Inform squad members of squad change???
	m_team = team;
	m_squadName = squadName;

	;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
simulated function Destroyed()
{
	local int idx;
	local TPAIController spController;

	if (m_team != None)
	{
		;
		m_team.RemoveSquad(self);
	}
	else
	{
		;
	}

	//***SPAI TODO: Inform squad members of removal???

	//if Team.RemoveSquad() did not assign a new squad,
	//remove references to this squad...
	for (idx = 0; idx < m_members.Length; idx++)
	{
		spController = TPAIController(m_members[idx]);
		if (spController != None && spController.m_squad == self)
		{
			spController.SetSquad(None);
		}
	}

	Super.Destroyed();
}

//-----------------------------------------------------------------------
// Function:
// Description:	Adds a member to the squad...
//-----------------------------------------------------------------------
function bool AddSquadMember(Controller newMember)
{
	local int idx;
	local TPAIController spController;
	local Controller curMember;

	if (newMember == None)
		return false;

	if (m_team != newMember.PlayerReplicationInfo.Team)
	{
		;
		return false;
	}

	if (!IsAMember(newMember))
	{
		;
		m_members[m_members.Length] = newMember;
		spController = TPAIController(newMember);

		if (spController != None)
		{
			spController.SetSquad(self);
		}

		// notify other squad members of the new member
		for (idx = 0; idx < m_members.Length; idx++)
		{
			curMember = m_members[idx];

			if (curMember != newMember)
			{
				if (spController != None)
				{
					// notify the new member of existing squad members
					spController.NotifyNewSquadMember(curMember);
				}
				if (curMember.IsA('TPAIController'))
				{
					TPAIController(curMember).NotifyNewSquadMember(newMember);
				}
			}
		}

		//Issue any squad command we may be doing to the new member...
		IssueSquadCommandToMember(newMember);
	}

	return true;
}

//-----------------------------------------------------------------------
// Function:
// Description:	Removes the member from the squad...
//-----------------------------------------------------------------------
function bool RemoveSquadMember(Controller removeMember, optional bool bNoReferenceCheck)
{
	local int idx;
	local TPAIController spController;

	if (IsAMember(removeMember, idx))
	{
		//Clear any squad commands we may have to the squad member...
		ClearSquadCommandToMember(removeMember);

		if (!bNoReferenceCheck)
		{
			//Remove references to this squad...
			spController = TPAIController(m_members[idx]);
			if (spController != None && spController.m_squad == self)
			{
				spController.SetSquad(None, true);
			}
		}

		if( idx >= 0 && m_members.Length > idx )
		{
			m_members.Remove(idx, 1);
		}
		;

		return true;
	}

	return false;
}

//-----------------------------------------------------------------------
// Function:
// Description:	Checks to see if the controller is a member of this
//				squad.
//-----------------------------------------------------------------------
native noexport function bool IsAMember(Controller chkMember, optional out int idxOut);
/*
{
	local int idx;

	idxOut = -1;
	for (idx = 0; idx < m_members.Length; idx++)
	{
		if (m_members[idx] == chkMember)
		{
			idxOut = idx;
			return true;
		}
	}

	return false;
}
*/

//-----------------------------------------------------------------------
// Function:
// Description:	Returns true if there are any other squad members besides
//				the checking player.
//-----------------------------------------------------------------------
function bool HasSquadMembers(Controller chkMember)
{
	local int idx;

	for (idx = 0; idx < m_members.Length; idx++)
	{
		if (m_members[idx] != chkMember)
		{
			return true;
		}
	}

	return false;
}


//-----------------------------------------------------------------------
// Function:
// Description:	Copies out a list of squad members.
//-----------------------------------------------------------------------
function bool GetSquadMembers(out array<Controller> squadMembers)
{
	local int idx;

	squadMembers.Length = m_members.Length;
	for (idx = 0; idx < m_members.Length; idx++)
	{
		squadMembers[idx] = m_members[idx];
	}

	return (squadMembers.Length != 0);
}

//-----------------------------------------------------------------------
// Function:
// Description:	Update function that is periodically called by the
//				TPTeamInfo that this squad belongs to
//-----------------------------------------------------------------------
function Update(float updateRate)
{
	local int idx;

	// received
	m_damageReceivedFrequency = 0.f;
	if (m_damageReceivedCount.Length > 0)
	{
		// average out available data
		for (idx = 0; idx < m_damageReceivedCount.Length; idx++)
		{
			m_damageReceivedFrequency += m_damageReceivedCount[idx];
		}
		m_damageReceivedFrequency /= (idx*updateRate);
		// insert a new entry
		m_damageReceivedCount.Insert(0,1);
		// and cap the max
		if (m_damageReceivedCount.Length > 20)
		{
			m_damageReceivedCount.Length = 20;
		}
	}
	// given
	m_damageGivenFrequency = 0.f;
	if (m_damageGivenCount.Length > 0)
	{
		// average out available data
		for (idx = 0; idx < m_damageGivenCount.Length; idx++)
		{
			m_damageGivenFrequency += m_damageGivenCount[idx];
		}
		m_damageGivenFrequency /= (idx*updateRate);
		// insert a new entry
		m_damageGivenCount.Insert(0,1);
		// and cap the max
		if (m_damageGivenCount.Length > 20)
		{
			m_damageGivenCount.Length = 20;
		}
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:	Called by TPTeamInfo when team members notify of enemy...
//-----------------------------------------------------------------------
function BroadcastNotifyEnemy(TPAIController notifier, Controller newEnemy)
{
	local int idx;
	local TPAIController squadMember;


	for (idx = 0; idx < m_members.Length; idx++)
	{
		squadMember = TPAIController(m_members[idx]);
		if (squadMember != None &&
			squadMember != notifier)
		{
			squadMember.NotifyEnemy(notifier,newEnemy);
		}
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:	Sends AI event along to squad members.
//-----------------------------------------------------------------------
function BroadcastSquadAIEvent(TPAIController notifier, Controller eventTarget, Name squadEvent, optional bool bSendToNotifier)
{
	local int idx;
	local TPAIController squadMember;

	for (idx = 0; idx < m_members.Length; idx++)
	{
		squadMember = TPAIController(m_members[idx]);
		if (squadMember != None &&
			(bSendToNotifier || squadMember != notifier) )
		{
			squadMember.NotifySquadAIEvent(notifier,eventTarget,squadEvent);
		}
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:	Adjusts squad morale by specified amount.
//-----------------------------------------------------------------------
function AdjustMorale(float adjustment)
{
	m_morale += adjustment;
}

//-----------------------------------------------------------------------
// Function:
// Description:	Called by TPTeamInfo when one of the squad members
//				receives damage...
//-----------------------------------------------------------------------
function NotifyDamagedReceived(Controller Victim, Controller cInstigator)
{
	if (m_damageReceivedCount.Length == 0)
	{
		m_damageReceivedCount.Length = 1;
	}
	// note damage applied for calculating frequency
	m_damageReceivedCount[0]++;
}

//-----------------------------------------------------------------------
// Function:
// Description:	Called by TPTeamInfo when one of the squad members
//				gives damage...
//-----------------------------------------------------------------------
function NotifyDamageGiven(Controller Victim, Controller cInstigator)
{
	if (m_damageGivenCount.Length == 0)
	{
		m_damageGivenCount.Length = 1;
	}

	m_damageGivenCount[0]++;
}
//-----------------------------------------------------------------------
// Function:
// Description:	Move all members to another squad...
//-----------------------------------------------------------------------
function MoveSquadMembersToNewSquad(TPSquad newSquad)
{
	local int idx;
	local array<Controller> squadMembers;

	if (newSquad == None)
		return;

	if (m_members.Length == 0)
	{
		return;
	}

	if (newSquad.m_team != m_team)
	{
		;
		return;
	}

	squadMembers.Length = m_members.Length;
	for (idx = 0; idx < m_members.Length; idx++)
	{
		squadMembers[idx] = m_members[idx];
	}

	//Add all members to new squad...
	for (idx = 0; idx < squadMembers.Length; idx++)
	{
		//this will automatically remove the member
		//from this squad b/c of the AddSquadMember()'s
		//function call to squadMembers[idx].SetSquad()
		newSquad.AddSquadMember(squadMembers[idx]);
	}
}




//************************ - BEGIN SECTION - ****************************
// GENERIC TARGET MANAGEMENT FUNCTIONS
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function bool IsEnemyTargettedBySquad(Pawn chkEnemy)
{
	local int idx;
	local Controller squadMember;

	for (idx = 0; idx < m_members.Length; idx++)
	{
		squadMember = m_members[idx];
		if (squadMember != None &&
			squadMember.Enemy == chkEnemy)
		{
			return true;
		}
	}

	return false;
}

function bool IsEnemyChallengedBySquad(Pawn chkEnemy)
{
	local int idx;
	local Controller squadMember;

	for (idx = 0; idx < m_members.Length; idx++)
	{
		squadMember = m_members[idx];
		if (squadMember != None &&
			squadMember.Enemy == chkEnemy)
		{
			if( TPAIController(squadMember)!=None )
			{
				if( TPAIController(squadMember).IsChallenging(chkEnemy) )
					return true;
			}
		}
	}

	return false;

}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
native function int GetNumMembersTargettingEnemy(Pawn chkEnemy, TPAIController caller);
/*
{
	local int idx;
    local int numMembersTargetting;
	local Controller squadMember;

	if (chkEnemy == none)
		return 0;

	numMembersTargetting = 0;

	for (idx = 0; idx < m_members.Length; idx++)
	{
		squadMember = m_members[idx];

		if (squadMember != None && squadMember != caller &&
			squadMember.Enemy == chkEnemy)
		{
			numMembersTargetting += 1;
		}
	}

	return numMembersTargetting;
}
*/

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
//native function int GetMembersTargettingEnemy(Pawn chkEnemy,
//						out array<Controller> outMembersTargettingEnemy);
/*
{
	local int idx;
    local int listIdx;
    local int numMembersTargetting;
	local Controller squadMember;

	outMembersTargettingEnemy.Length = 0;

	if (chkEnemy == none)
		return 0;

	numMembersTargetting = 0;

	for (idx = 0; idx < m_members.Length; idx++)
	{
		squadMember = m_members[idx];

		if (squadMember != None &&
			squadMember.Enemy == chkEnemy)
		{
			numMembersTargetting += 1;

			listIdx = outMembersTargettingEnemy.Length;
            outMembersTargettingEnemy.Length = listIdx + 1;
            outMembersTargettingEnemy[listIdx] = squadMember;
		}
	}

	return numMembersTargetting;
}
*/
//***********************************************************************
// GENERIC TARGET MANAGEMENT FUNCTIONS
//************************ - END SECTION - ******************************








//************************ - BEGIN SECTION - ****************************
// SQUAD COMMAND FUNCTIONS
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function IssueSquadCommandToAllMembers()
{
	local int idx;
	//`AILOG(0, 'IssueSquadCommandToAllMembers', "num members:"@m_members.Length);
	for (idx = 0; idx < m_members.Length; idx++)
	{
		IssueSquadCommandToMember(m_members[idx]);
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function ClearSquadCommandToAllMembers()
{
	local int idx;
	//`AILOG(0, 'ClearSquadCommandToAllMembers', "num members:"@m_members.Length);
	for (idx = 0; idx < m_members.Length; idx++)
	{
		ClearSquadCommandToMember(m_members[idx]);
	}

	//Finally clear our squad command
	switch (m_squadCommand)
	{
		case ETPSC_SquadCommand_DefendArea:
			ClearDefendAreaSquadCommand();
			break;
		default:
			break;
	}

}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function IssueSquadCommandToMember(Controller member)
{
	//`AILOG(0, 'IssueSquadCommandToMember', "Member:"@member@" - Command:"@m_squadCommand);
	switch (m_squadCommand)
	{
		case ETPSC_SquadCommand_DefendArea:
			IssueDefendAreaSquadCommandToMember(member);
			break;
		default:
			break;
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function ClearSquadCommandToMember(Controller member)
{
	//`AILOG(0, 'ClearSquadCommandToMember', "member:"@member);
	switch (m_squadCommand)
	{
		case ETPSC_SquadCommand_DefendArea:
			break;
		default:
			break;
	}
}

//***********************************************************************
// SQUAD COMMAND FUNCTIONS
//************************ - END SECTION - ******************************








//************************ - BEGIN SECTION - ****************************
// DEFEND AREA SQUAD COMMAND FUNCTIONS
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function SetDefendAreaSquadCommand(SquadCommandDefendArea_Params param)
{
	if (m_squadCommand == ETPSC_SquadCommand_DefendArea &&
		param.commandPriority == m_squadCommandPriority &&
		param.defendAreaVolume == m_defendAreaVolume &&
		param.defendAreaDynamicVolume == m_defendAreaDynamicVolume &&
		param.destAssignment == m_defendAreaDestAssignment)
	{
		;
		return;
	}

	//`AILOG(0, 'SetDefendAreaSquadCommand', "Clearing old squad command");
	ClearSquadCommandToAllMembers();

    m_squadCommand = ETPSC_SquadCommand_DefendArea;
	m_squadCommandPriority = param.commandPriority;
	m_defendAreaVolume = param.defendAreaVolume;
	m_defendAreaDynamicVolume = param.defendAreaDynamicVolume;
	m_defendAreaDestAssignment = param.destAssignment;
	m_attackDistWhileDefendingArea = param.attackDistWhileDefendingArea;

    GetDefendAreaRotator(m_defendAreaDynamicOrientation);
    GetDefendAreaLocation(m_defendAreaLastLoc);
    m_defendAreaLastLoc = m_defendAreaOrientationLastLoc;

	;
	IssueSquadCommandToAllMembers();
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function ClearDefendAreaSquadCommand()
{
	;
	m_squadCommand = ETPSC_SquadCommand_None;
	m_squadCommandPriority = ETPCP_SquadCommandPriority_None;
	m_defendAreaVolume = None;
	m_defendAreaDynamicVolume = none;
	m_defendAreaDestAssignment = ETPSDDA_DefensivePositions;
	m_attackDistWhileDefendingArea = 3000.0;

    m_defendAreaNodes.Length = 0;
	m_defendAreaLastLoc.X = 0.0f;
	m_defendAreaLastLoc.Y = 0.0f;
	m_defendAreaLastLoc.Z = 0.0f;
    m_defendAreaOrientationLastLoc.X = 0.0f;
    m_defendAreaOrientationLastLoc.Y = 0.0f;
    m_defendAreaOrientationLastLoc.Z = 0.0f;

	ClearDefendAreaZoneInfo();
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function IssueDefendAreaSquadCommandToMember(Controller member)
{
	//local TPAIController spAI;

	//`AILOG(0, 'IssueDefendAreaSquadCommandToMember', "member:"@member);
	//spAI = TPAIController(member);
// 	if (spAI != None)
// 	{
// 		param.defendAreaVolume = m_defendAreaVolume;
// 		param.defendAreaDynamicVolume = m_defendAreaDynamicVolume;
// 		param.commandPriority = m_squadCommandPriority;
// 		param.destAssignment = m_defendAreaDestAssignment;
// 		param.attackDistWhileDefendingArea = m_attackDistWhileDefendingArea;
// 
// 		//spAI.SetDefendAreaSquadCommand(ETPSC_SquadCommand_DefendArea, param);
// 	}
}




//-----------------------------------------------------------------------
// Function:
// Description: Does what the name says...
//-----------------------------------------------------------------------
function bool GetDefendAreaLocation(out vector loc)
{
	if (IsSquadDefendingArea())
	{
		if (m_defendAreaVolume != none)
		{
            loc = m_defendAreaVolume.Location;
            return true;
        }

        if (m_defendAreaDynamicVolume != none)
        {
            loc = m_defendAreaDynamicVolume.Location;
            return true;
        }
	}
	return false;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function float GetDefendAreaRadius()
{
//	local float rad, dst;
//    local int idx;
//    local vector centroid;
//
//	rad = 0.0f;
//
//    if (IsSquadDefendingArea())
//	{
//		if (m_defendAreaVolume != none && m_defendAreaVolume.BrushComponent != None)
//		{
//			rad = m_defendAreaVolume.BrushComponent.Bounds.SphereRadius;
//		}
//
//        if (m_defendAreaDynamicVolume != none && m_defendAreaDynamicVolume.CylinderComponent != none)
//        {
//            rad = m_defendAreaDynamicVolume.CylinderComponent.Bounds.SphereRadius;
//        }
//	}
//
//    //fake it!
//    if (rad <= 0.0f && GetDefendAreaCentroid(centroid))
//    {
//        `AILOG(0, 'Squad',"Invalid Radius for defend area: Manually calculating...");
//        for (idx = 0; idx < m_defendAreaNodes.Length; idx++)
//        {
//            if (m_defendAreaNodes[idx] != none)
//            {
//                dst = VSize(m_defendAreaNodes[idx].Location - centroid);
//                if (dst > rad)
//                {
//                    rad = dst;
//                }
//            }
//        }
//        `AILOG(0, 'Squad',"Calculated radius of:"@rad);
//    }
//
//    return rad;
return 0;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function bool GetDefendAreaAxes(out vector aX, out vector aY, out vector aZ)
{
//    if (IsSquadDefendingArea())
//    {
//        if (m_defendAreaVolume != none)
//        {
//            GetAxes(m_defendAreaVolume.Rotation, aX, aY, aZ);
//            return true;
//        }
//
//        if (m_defendAreaDynamicVolume != none)
//        {
//            //GetAxes(m_defendAreaDynamicVolume.Rotation, aX, aY, aZ);
//            GetAxes(m_defendAreaDynamicOrientation, aX, aY, aZ);
//            return true;
//        }
//    }

    return false;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function bool GetDefendAreaRotator(out rotator outRot)
{
//    if (IsSquadDefendingArea())
//    {
//        if (m_defendAreaVolume != none)
//        {
//            outRot = m_defendAreaVolume.Rotation;
//            return true;
//        }
//
//        if (m_defendAreaDynamicVolume != none)
//        {
//            outRot = m_defendAreaDynamicVolume.Rotation;
//            return true;
//        }
//    }
//
    return false;
}

//-----------------------------------------------------------------------
// Function:
// Description: TPMIRROR: this function is mirrored with the same function
//              in TPAIController, if you change one you change the other
//              as well...
//-----------------------------------------------------------------------
function string GetDefendAreaName()
{
//    if (IsSquadDefendingArea())
//	{
//		if (m_defendAreaVolume != None)
//		{
//            return m_defendAreaVolume.GetDebugName();
//        }
//
//        if (m_defendAreaDynamicVolume != none)
//        {
//            return m_defendAreaDynamicVolume.GetDebugName();
//        }
//	}
//
    return "None";
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function ClearDefendAreaZoneInfo()
{
//    local int idx;
//
//    for (idx = 0; idx < m_defendAreaZoneInfo.Length; idx++)
//    {
//        /**this doesn't work! m_defendAreaZoneInfo[idx].eZoneIdx = idx; */
//        //log("Zone:"@m_defendAreaZoneInfo[idx].eZoneIdx);
//        m_defendAreaZoneInfo[idx].numOccupiedCover = 0;
//        m_defendAreaZoneInfo[idx].numOccupiedNonCoverNodes = 0;
//    }
}


//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function UpdateDefendAreaNodes()
{
//    local float d;
//    local vector currLoc;
//    local vector defAreaVel;
//
//    if (!IsSquadDefendingArea())
//        return;
//
//    GetDefendAreaLocation(currLoc);
//
//    defAreaVel = currLoc - m_defendAreaLastLoc;
//    d = VSize(defAreaVel);
//    if (d > 50.0f)
//    {
//        GetNavigationPointsInDefendArea();
//        m_defendAreaLastLoc = currLoc;
//    }
//
//    defAreaVel = currLoc - m_defendAreaOrientationLastLoc;
//    d = VSize(defAreaVel);
//    if (d > 200.0f)
//    {
//        defAreaVel.Z = 0.0f;
//        if (!IsZero(defAreaVel))
//        {
//            m_defendAreaDynamicOrientation = rotator(defAreaVel);
//        }
//        else
//        {
//            GetDefendAreaRotator(m_defendAreaDynamicOrientation);
//        }
//        m_defendAreaOrientationLastLoc = currloc;
//    }
//
    return;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function UpdateDefendAreaZoneInfo()
{
//    local int idx;
//    local vector vecToNode, centroid;
//    local vector aX, aY, aZ;
//    local NavigationPoint nav;
//    local TPAIController spAI;
//    local float atDot, rightDot;
//    local ETPDefendAreaZones zone;
//    local TPCoverNode spCover;
//    local bool bHasClaimedAsCover;
//
//    if (!IsSquadDefendingArea())
//    {
//        return;
//    }
//
//    ClearDefendAreaZoneInfo();
//
//    if (m_members.Length <= 0)
//    {
//        return;
//    }
//
//    if (!GetDefendAreaCentroid(centroid))
//    {
//        return;
//    }
//
//    if (!GetDefendAreaAxes(aX, aY, aZ))
//    {
//        return;
//    }
//
//    Normal(aX);
//    Normal(aY);
//
//    for (idx = 0; idx < m_members.Length; idx++)
//    {
//        spAI = TPAIController(m_members[idx]);
//        if (spAI != none && spAI.IsDefendingAreaWithSquad(self) &&
//            spAI.m_defendAreaDestination != none &&
//            IsActorInDefendArea(spAI.m_defendAreaDestination, true))
//        {
//            nav = spAI.m_defendAreaDestination;
//            spCover = TPCoverNode(nav);
//            if (spCover != none && spCover.IsClaimedBy(spAI))
//                bHasClaimedAsCover = true;
//            else
//                bHasClaimedAsCover = false;
//
//            vecToNode = Normal(nav.Location - centroid);
//            atDot = aX dot vecToNode;
//            zone = ETPDAZ_Maximus;
//
//            if (atDot >= `DAFRONTDOT)
//                zone = ETPDAZ_Front;
//            else if (atDot < `DAFRONTDOT && atDot > `DAREARDOT)
//            {
//                //side...
//                rightDot = aY dot vecToNode;
//                if (rightDot >= `DARIGHTDOT)
//                    zone = ETPDAZ_Right;
//                else if (rightDot <= `DALEFTDOT)
//                    zone = ETPDAZ_Left;
//            }
//            else if (atDot <= `DAREARDOT)
//                zone = ETPDAZ_Back;
//
//            if (zone != ETPDAZ_Maximus)
//            {
//                if (bHasClaimedAsCover)
//                    m_defendAreaZoneInfo[zone].numOccupiedCover++;
//                else
//                    m_defendAreaZoneInfo[zone].numOccupiedNonCoverNodes++;
//            }
//        }
//    }
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function bool IsDefenseZoneLeastOccupied(ETPDefendAreaZones zoneChk)
{
//    local int idx, zoneChkTotal, zoneTotal;
//    local DefendAreaZoneInfo defZone;
//
//    for (idx = 0; idx < m_defendAreaZoneInfo.Length; idx++)
//    {
//        defZone = m_defendAreaZoneInfo[idx];
//        if (defZone.eZoneIdx == zoneChk)
//        {
//            zoneChkTotal = defZone.numOccupiedCover + defZone.numOccupiedNonCoverNodes;
//        }
//    }
//
//    for (idx = 0; idx < m_defendAreaZoneInfo.Length; idx++)
//    {
//        defZone = m_defendAreaZoneInfo[idx];
//        if (defZone.eZoneIdx != zoneChk)
//        {
//           zoneTotal = defZone.numOccupiedCover + defZone.numOccupiedNonCoverNodes;
//           if (zoneTotal < zoneChkTotal)
//           {
//                return false;
//           }
//        }
//    }
//
    return true;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function bool IsDefenseZoneLeastOccupiedCover(ETPDefendAreaZones zoneChk)
{
//    local int idx;
//
//    for (idx = 0; idx < m_defendAreaZoneInfo.Length; idx++)
//    {
//        if (m_defendAreaZoneInfo[idx].eZoneIdx != zoneChk)
//        {
//           if (m_defendAreaZoneInfo[idx].numOccupiedCover < m_defendAreaZoneInfo[zoneChk].numOccupiedCover)
//           {
//                return false;
//           }
//        }
//    }

    return true;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function bool IsDefenseZoneLeastOccupiedNonCover(ETPDefendAreaZones zoneChk)
{
//    local int idx;
//
//    for (idx = 0; idx < m_defendAreaZoneInfo.Length; idx++)
//    {
//        if (m_defendAreaZoneInfo[idx].eZoneIdx != zoneChk)
//        {
//            if (m_defendAreaZoneInfo[idx].numOccupiedNonCoverNodes < m_defendAreaZoneInfo[zoneChk].numOccupiedNonCoverNodes)
//            {
//                return false;
//            }
//        }
//    }

    return true;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function bool IsDefendAreaPosClaimedByMembers(NavigationPoint navPos)
{
//    local int idx;
//    local TPAIController spAI;
//
//    //see if any other squad members are claming it
//	for (idx = 0; idx < m_members.Length; idx++)
//	{
//	   spAI = TPAIController(m_members[idx]);
//	   if (spAI != None && spAI.m_defendAreaDestination == navPos)
//	   {
//            return true;
//        }
//	}
//
    return false;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function bool PickDefendAreaDestinationForMember(Controller member, optional bool bNoCoverPos)
{
//    //local int idx;
//    local TPAIController spAI;
//    local NavigationPoint pickedPos;
//    local float defAreaRad;
//    local vector defAreaCentroid;
//    local vector rotAxisAt;
//    local vector rotAxisRight;
//    local vector rotAxisUp;
//
//    //Insane sanity check... oh the irony...
//	`AILOG(1, 'SquadDefendArea',"Looking for new defend area destination from squad for"@member.GetPawnName(true));
//
//    if (member == none ||
//        !IsSquadDefendingArea() ||
//        !IsAMember(member))
//    {
//	   `AILOG(0, 'SquadDefendArea',"Unable to find new defArea dest b/c either the squad is not defending area or"@member@"is not member of the squad!");
//        return false;
//    }
//
//    spAI = TPAIController(member);
//
//    if (spAI == none)
//    {
//	   `AILOG(0, 'SquadDefendArea',"Unable to find new defArea dest b/c "@member@"is not an TPAIController");
//        return false;
//    }
//
//    if (!spAI.IsDefendingAreaWithSquad(self))
//    {
//	   `AILOG(0, 'SquadDefendArea',"Unable to find new defArea dest b/c "@spAI.GetPawnName(true)@"is not defending the same area as the squad!");
//	   `AILOG(0, 'SquadDefendArea',"Squad is defending area:"@GetDefendAreaName()@"-"@spAI.GetPawnName(true)@"is defending area:"@spAI.GetDefendAreaName());
//        return false;
//    }
//
//    //update our data...
//    UpdateDefendAreaNodes();
//    `AILOG(0, 'SquadDefendArea',"DefendArea:"@GetDefendAreaName()@"has"@m_defendAreaNodes.Length@"nodes");
//
//    UpdateDefendAreaZoneInfo();
//    //print out zone info;
///*    for (idx = 0; idx < m_defendAreaZoneInfo.Length; idx++)
//    {
//        `AILOG(0, 'SquadDefendArea',"Zone"@m_defendAreaZoneInfo[idx].eZoneIdx@"- OccupiedCover:"@m_defendAreaZoneInfo[idx].numOccupiedCover@"Occupied nodes:"@m_defendAreaZoneInfo[idx].numOccupiedNonCoverNodes);
//    }
//*/
//    defAreaRad = GetDefendAreaRadius();
//    if (defAreaRad <= 0.0f)
//    {
//        defAreaRad = 2048.0f;
//    }
//
//    if (!GetDefendAreaCentroid(defAreaCentroid))
//    {
//	   `AILOG(0, 'SquadDefendArea',"Unable to find new defArea dest b/c DefArea:"@GetDefendAreaName()@"has an invalid centroid!");
//        return false;
//    }
//
//    if (!GetDefendAreaAxes(rotAxisAt, rotAxisRight, rotAxisUp))
//    {
//	   `AILOG(0, 'SquadDefendArea',"Unable to find new defArea dest b/c DefArea:"@GetDefendAreaName()@"has invalid rotation axes!");
//        return false;
//    }
//
//    if (!bNoCoverPos)
//    {
//        pickedPos = PickCoverInDefAreaForMember(spAI,
//                                                defAreaRad,
//                                                defAreaCentroid,
//                                                rotAxisAt,
//                                                rotAxisRight,
//                                                rotAxisUp);
//    }
//
//    `AILOGD(pickedPos != none,"Found new defend area cover position:"@pickedPos@"from squad!");
//
//    if (pickedPos == none)
//    {
//        pickedPos = PickPositionInDefAreaForMember(spAI,
//                        defAreaRad,
//                        defAreaCentroid,
//                        rotAxisAt,
//                        rotAxisRight,
//                        rotAxisUp);
//
//        `AILOGD(pickedPos != none,"Found new defend area position:"@pickedPos@"from squad!");
//    }
//
//    `AILOGD(pickedPos == none,"  !!!NO DEFAREA POSITION FOUND!!!");
//    spAI.SetDefendAreaDestination(pickedPos);
//
//    return (pickedPos != none);
return false;
}


//-----------------------------------------------------------------------
// Function:
// Description: Assumes that you have done sanity checks and updating
//              of defend area data.  See PickDefendAreaDestinationForMember()
//              above.
//-----------------------------------------------------------------------
function TPCoverNode PickCoverInDefAreaForMember(TPAIController spAI,
                    float defAreaRad,
                    vector defAreaCentroid,
                    vector rotAxisAt,
                    vector rotAxisRight,
                    vector rotAxisUp)
{
//    local int idx;
//    local float rating, bestRating;
//    local TPCoverNode spCover, bestCover;
//
//    for (idx=0; idx < m_defendAreaNodes.Length; idx++)
//    {
//        spCover = TPCoverNode(m_defendAreaNodes[idx]);
//        if (spCover != none && !spCover.bBlocked &&
//            spAI.IsPotentialCover(spCover) &&
//            spAI.IsAngleToEnemyValidForThisCoverSlot(spCover, spAI.Enemy))
//        {
//            if (m_defendAreaDestAssignment ==  ETPSDDA_DefensivePositions)
//            {
//                rating = RateDefensiveCoverInDefArea(spCover, defAreaCentroid,
//                                    defAreaRad, rotAxisAt,
//                                    rotAxisRight, rotAxisUp);
//            }
//            else
//            {
//                rating = RateForwardCoverInDefArea(spCover, defAreaCentroid,
//                                    defAreaRad, rotAxisAt,
//                                    rotAxisRight, rotAxisUp);
//            }
//
//            if (rating > bestRating)
//            {
//                bestCover = spCover;
//                bestRating = rating;
//            }
//
//        }
//    }
//
//    return bestCover;
return None;
}

//-----------------------------------------------------------------------
// Function:
// Description: Assumes that you have done sanity checks and updating
//              of defend area data.  See PickDefendAreaDestinationForMember()
//              above.
//-----------------------------------------------------------------------
function NavigationPoint PickPositionInDefAreaForMember(TPAIController spAI,
                        float defAreaRad,
                        vector defAreaCentroid,
                        vector rotAxisAt,
                        vector rotAxisRight,
                        vector rotAxisUp)
{
//    local int idx;
//    local float rating, bestRating;
//    local TPcoverNode coverNode;
//    local NavigationPoint navPos, bestPos;
//
//    for (idx=0; idx < m_defendAreaNodes.Length; idx++)
//    {
//        navPos = m_defendAreaNodes[idx];
//        coverNode = TPCoverNode(navPos);
//        if (navPos != none && coverNode == none && 
//			!navPos.bBlocked && !spAI.IsInvalidatedMoveGoal(coverNode.SlotIdx, coverNode.Link) &&
//            !IsDefendAreaPosClaimedByMembers(navPos))
//        {
//            if (m_defendAreaDestAssignment ==  ETPSDDA_DefensivePositions)
//            {
//                rating = RateDefensivePositionInDefArea(navPos,
//                                    defAreaCentroid,
//                                    defAreaRad, rotAxisAt,
//                                    rotAxisRight, rotAxisUp);
//            }
//            else
//            {
//                rating = RateForwardPositionInDefArea(navPos,
//                                    defAreaCentroid,
//                                    defAreaRad, rotAxisAt,
//                                    rotAxisRight, rotAxisUp);
//            }
//
//            if (rating > bestRating)
//            {
//                bestPos = navPos;
//                bestRating = rating;
//            }
//
//        }
//    }
//
//    return bestPos;
return None;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function float RateDefensiveCoverInDefArea(TPCoverNode cover,
                    vector defAreaCentroid,
                    float defAreaRad,
                    vector rotAxisAt,
                    vector rotAxisRight,
                    vector rotAxisUp)
{
//    local float weight;
//    local float atDot, rightDot, coverDot;
//    local ETPDefendAreaZones zone;
//    local vector vecToNode;
//    local vector coverRotAxisAt, coverRotAxisRight, coverRotAxisUp;
//
//    vecToNode = Normal(cover.Location - defAreaCentroid);
//    atDot = rotAxisAt dot vecToNode;
//    zone = ETPDAZ_Maximus;
//
//    GetAxes(cover.Rotation, coverRotAxisAt, coverRotAxisRight,
//            coverRotAxisUp);
//
//    weight = 0.0f;
//
//    if (atDot >= `DAFRONTDOT)
//    {
//        zone = ETPDAZ_Front;
//        coverDot = rotAxisAt dot coverRotAxisAt;
//        if (coverDot < 0.0f)
//        {
//            weight = -1.0f;
//        }
//    }
//    else if (atDot < `DAFRONTDOT && atDot > `DAREARDOT)
//    {
//        //side...
//        rightDot = rotAxisRight dot vecToNode;
//        if (rightDot >= `DARIGHTDOT)
//        {
//            zone = ETPDAZ_Right;
//            coverDot = rotAxisRight dot coverRotAxisAt;
//            if (coverDot < 0.0f)
//            {
//                weight = -1.0f;
//            }
//        }
//        else if (rightDot <= `DALEFTDOT)
//        {
//            zone = ETPDAZ_Left;
//            coverDot = rotAxisRight dot coverRotAxisAt;
//            if (coverDot > 0.0f)
//            {
//                weight = -1.0f;
//            }
//        }
//    }
//    else if (atDot <= `DAREARDOT)
//    {
//        zone = ETPDAZ_Back;
//        coverDot = rotAxisAt dot coverRotAxisAt;
//        if (coverDot > 0.0f)
//        {
//            weight = -1.0f;
//        }
//    }
//
//    if (weight >= 0.0f)
//    {
//        //favor least occupied cover zones...
//        if (zone != ETPDAZ_Maximus &&
//            IsDefenseZoneLeastOccupiedCover(zone))
//        {
//            weight += 0.25f;
//        }
//
//        //favor furthest cover nodes...
//        weight += (FClamp(VSize(cover.Location - defAreaCentroid)/defAreaRad, 0.0f, 1.0f)) * 0.3f;
//    }
//
//    return weight;
return 0;
}


//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function bool IsValidFrontRearCover(CoverInfo spCover,
									vector defAreaRotAxAt,
									vector defAreaRotAxRight,
									vector coverRotAxisAt,
									vector vecToCover)
{
    local bool bValid, bPopUpCover;
    local float coverDot, rightDot;
    local CoverSlot slot;
    
    slot = spCover.Link.Slots[spCover.SlotIdx];

    coverDot = defAreaRotAxAt dot coverRotAxisAt;

    if (slot.CoverType == CT_MidLevel ) //  ||
       // spCover.CoverType == CT_Crouching) Removed by CHAD
    {
        bPopUpCover = true;
        if (coverDot < 0.4f && coverDot > -0.4f)
        {
            bValid = true;
        }
    }

    if (!bValid && coverDot >= 0.40f)
    {
        if (bPopUpCover)
        {
            bValid = true;
        }
        else
        {
            rightDot =  defAreaRotAxRight dot vecToCover;
            if (slot.bLeanRight && slot.bLeanLeft)
            {
                bValid = true;
            }
            else if (rightDot > 0.0f)
            {
                if (slot.bLeanRight)
                    bValid = false;
                else
                    bValid = true;
            }
            else if (rightDot <= 0.0f)
            {
                if (slot.bLeanLeft)
                    bValid = false;
                else
                    bValid = true;
            }
        }
    }

    return bValid;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function float RateForwardCoverInDefArea(	CoverInfo cover,
											vector defAreaCentroid,
											float defAreaRad,
											vector rotAxisAt,
											vector rotAxisRight,
											vector rotAxisUp)
{
    local float weight;
    local float atDot;
    local ETPDefendAreaZones zone;
    local vector vecToNode;
    local vector coverRotAxisAt, coverRotAxisRight, coverRotAxisUp;
    //local CoverSlot slot;
    
    //slot = cover.Link.Slots[cover.SlotIdx];

    vecToNode = Normal( cover.Link.GetSlotLocation(cover.SlotIdx) - defAreaCentroid);
    atDot = rotAxisAt dot vecToNode;
    zone = ETPDAZ_Maximus;

    GetAxes( cover.Link.GetSlotRotation(cover.SlotIdx) , coverRotAxisAt, coverRotAxisRight,
            coverRotAxisUp);

    weight = 0.0f;

    if (atDot >= 0.0f)
    {
        zone = ETPDAZ_Front;
        if (!IsValidFrontRearCover(cover, rotAxisAt, rotAxisRight,
                    coverRotAxisAt, vecToNode))
        {
            weight = -1.0f;
        }
    }
    else if (atDot <= 0.0f)
    {
        zone = ETPDAZ_Back;
        if (!IsValidFrontRearCover(cover, rotAxisAt, rotAxisRight,
                    coverRotAxisAt, vecToNode))
        {
            weight = -1.0f;
        }
    }

    if (weight >= 0.0f)
    {
        //favor forward cover zones...
        if (zone == ETPDAZ_Front)
        {
            weight += 0.50f;
        }

        //favor furthest cover nodes...
        weight += (FClamp(VSize( cover.Link.GetSlotLocation(cover.SLotIdx) - defAreaCentroid)/defAreaRad, 0.0f, 1.0f)) * 0.3f;
    }

    return weight;
}


//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function float RateDefensivePositionInDefArea(NavigationPoint navPos,
                    vector defAreaCentroid,
                    float defAreaRad,
                    vector rotAxisAt,
                    vector rotAxisRight,
                    vector rotAxisUp)
{
//    local float weight;
//    local float atDot, rightDot;
//    local ETPDefendAreaZones zone;
//    local vector vecToNode;
//
//    vecToNode = Normal(navPos.Location - defAreaCentroid);
//    atDot = rotAxisAt dot vecToNode;
//    zone = ETPDAZ_Maximus;
//
//    weight = 0.0f;
//
//    if (atDot >= `DAFRONTDOT)
//    {
//        zone = ETPDAZ_Front;
//    }
//    else if (atDot < `DAFRONTDOT && atDot > `DAREARDOT)
//    {
//        //side...
//        rightDot = rotAxisRight dot vecToNode;
//        if (rightDot >= `DARIGHTDOT)
//        {
//            zone = ETPDAZ_Right;
//        }
//        else if (rightDot <= `DALEFTDOT)
//        {
//            zone = ETPDAZ_Left;
//        }
//    }
//    else if (atDot <= `DAREARDOT)
//    {
//        zone = ETPDAZ_Back;
//    }
//
//    if (weight >= 0.0f)
//    {
//        //favor least occupied zones...
//        if (zone != ETPDAZ_Maximus &&
//            IsDefenseZoneLeastOccupied(zone))
//        {
//            weight += 0.25f;
//        }
//
//        //favor left or right zones
//        if (zone == ETPDAZ_Right || zone == ETPDAZ_Left)
//        {
//            weight += 0.10f;
//        }
//
//        //favor furthest nodes...
//        weight += (FClamp(VSize(navPos.Location - defAreaCentroid)/defAreaRad, 0.0f, 1.0f)) * 0.3f;
//    }
//
//    return weight;
return 0;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function float RateForwardPositionInDefArea(NavigationPoint navPos,
                    vector defAreaCentroid,
                    float defAreaRad,
                    vector rotAxisAt,
                    vector rotAxisRight,
                    vector rotAxisUp)
{
//    local float weight;
//    local float atDot, rightDot;
//    local ETPDefendAreaZones zone;
//    local vector vecToNode;
//
//    vecToNode = Normal(navPos.Location - defAreaCentroid);
//    atDot = rotAxisAt dot vecToNode;
//    zone = ETPDAZ_Maximus;
//
//    weight = 0.0f;
//
//    if (atDot >= `DAFRONTDOT)
//    {
//        zone = ETPDAZ_Front;
//    }
//    else if (atDot < `DAFRONTDOT && atDot > `DAREARDOT)
//    {
//        //side...
//        rightDot = rotAxisRight dot vecToNode;
//        if (rightDot >= `DARIGHTDOT)
//        {
//            zone = ETPDAZ_Right;
//        }
//        else if (rightDot <= `DALEFTDOT)
//        {
//            zone = ETPDAZ_Left;
//        }
//    }
//    else if (atDot <= `DAREARDOT)
//    {
//        zone = ETPDAZ_Back;
//    }
//
//    if (weight >= 0.0f)
//    {
//        //Heavily favor forward ones...
//        if (atDot > 0.0f)
//        {
//            weight += 0.50f;
//        }
//
//        //favor least occupied zones...
//        if (zone != ETPDAZ_Maximus &&
//            IsDefenseZoneLeastOccupied(zone))
//        {
//            weight += 0.25f;
//        }
//
//        //favor left or right zones
//        if (zone == ETPDAZ_Right || zone == ETPDAZ_Left)
//        {
//            weight += 0.10f;
//        }
//
//        //favor furthest nodes...
//        weight += (FClamp(VSize(navPos.Location - defAreaCentroid)/defAreaRad, 0.0f, 1.0f)) * 0.3f;
//    }
//
//    return weight;
return 0;
}

//***********************************************************************
// DEFEND AREA SQUAD COMMAND FUNCTIONS
//************************ - END SECTION - ******************************

//***********************************************************************
// Default Properties
//***********************************************************************
