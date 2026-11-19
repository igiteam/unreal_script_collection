//***********************************************************************
// Class:		SPDProcessManager
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

class SPDProcessManager extends Actor
	notplaceable
	native;

	
//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

struct native SPDDamage
{
	var Vector location;
	var Rotator rotation;	
	var int damageAmount; 
	var Controller instigatedBy; 
	var Vector hitlocation; 
	var Vector momentum; 
	var class<DamageType> damageType; 
	var TraceHitInfo hitInfo;
	var bool isValid;
	var bool ShowDebug;
};

enum SPDActionState
{
	SPDActionState_InProgress,	
	SPDActionState_Done,
	SPDActionState_Abort,
};	

enum SPDProcessType
{
	SPDProcessType_Generic,
	SPDProcessType_Destruct,
};	 

struct native SPDProcessState
{
	var SPDActionList			ActionList;
	var int 					CurAction;
	var int						CountActions;
	var bool 					Active;
	var bool					ExecutingLatent;
	var SPDProcessType			ProcessType;
	
	var Actor 					Actor;
	var SPDDamage				DamageInfo;
	
	var int						StackIdx;
	var byte					ProcessData[128];
};

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var SPDestructibleProperties	DestructibleProperties;
var Actor						DestructibleActor;
var SPDDamage					DestructibleDamageInfo;
var int							CurProcess;


var array<SPDProcessState>		ActiveProcessList;
var array<SPDProcessState>		PendingProcessList;

var SPDActionState 				ActionState;
var const class<DamageType> 	DefaultDamageType;

//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// NATIVE FUNCTION DECLARATIONS
//***********************************************************************

native final static function WorldInfo GetWorldInfo();

native function SPDDamageSetDefault( out SPDDamage damageInfo );
native function CreateProcess( SPDActionList ActionList, Actor Actor, out SPDDamage damageInfo, optional SPDProcessType ProcessType = SPDProcessType_Generic );
native function ActivatePending();
native function SPDActionState ExecuteActiveProcess( float ElapsedTime );
native function PostExecute();
native function AddOnDestructProcess();
native function AbortAllProcess();


native function PushFloat( float f );
native function PushInt( int i );
native function PushVector( out vector v );
native function PushObjectRef( Object object );
native function PushBool( bool b );
native function float PopFloat();
native function int PopInt();
native function vector PopVector();
native function Object PopObjectRef();
native function bool PopBool();

native final function actor SpSpawn
(
	class<actor>      SpawnClass,
	optional actor	  SpawnOwner,
	optional name     SpawnTag,
	optional vector   SpawnLocation,
	optional rotator  SpawnRotation
);


//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
static function SPDProcessManager Get( Actor actor )
{
	local TPSinglePlayerGameInfo  spGameInfo; // problem? was PandoraSPGameInfo
	local SPDProcessManager  ProcessManager;

	spGameInfo = TPSinglePlayerGameInfo(GetWorldInfo().Game); // problem? was PandoraSPGameInfo
	if ( spGameInfo == None )
		return None;

	if ( spGameInfo.ActiveSPDProcessManager != None )
		return spGameInfo.ActiveSPDProcessManager;

	if ( actor == None )
		return None;

	ProcessManager = actor.Spawn(class'SPDProcessManager');
	spGameInfo.ActiveSPDProcessManager = ProcessManager;
	return ProcessManager;
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function MakeInActive()
{
	local TPSinglePlayerGameInfo  spGameInfo; // problem? was PandoraSPGameInfo

	spGameInfo = TPSinglePlayerGameInfo(GetWorldInfo().Game); // problem? was PandoraSPGameInfo
	if ( spGameInfo == None )
		return;

	if ( spGameInfo.ActiveSPDProcessManager == self )
	{
		spGameInfo.ActiveSPDProcessManager = None;
	}
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function bool HasActions( array<SPDActionList> list ) 
{
	local int idx;

	for (idx = 0; idx < list.Length; idx++)
	{
		if ( list[idx].HasActions() )
			return true;
	}
	return false;
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function bool AddActionListWithDamageInfo( SPDActionList ActionList, Actor actor, SPDDamage damageInfo ) 
{
	if ( ! ActionList.HasActions() )
	{
		return false;
	}

	CreateProcess( ActionList, actor, damageInfo );
	return true;
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function bool AddActionList( SPDActionList ActionList, Actor actor, optional bool bForceExecute = false) 
{
	local SPDDamage damageInfo;
	local bool		bRetValue;

	if ( ! ActionList.HasActions() )
	{
		;	
		return false;
	}

	SPDDamageSetDefault(damageInfo);
	damageInfo.location = actor.location;
	damageInfo.rotation = actor.rotation;
	bRetValue = AddActionListWithDamageInfo( ActionList, actor, damageInfo );
	
	if (bForceExecute)
	{
		GotoState('ExecutingDestroy');
	}
	
	return bRetValue;
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function singular AddDestruct( Actor srcActor, SPDestructibleProperties props, int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType, TraceHitInfo HitInfo )
{
	if ( props == None || srcActor == None )
	{
		GotoState('FinishedDestroy');
		return;
	}
	
	if ( ! props.bEnableCommands )
		return;
	
	DestructibleActor = srcActor;
	DestructibleProperties = props;
	
	SPDDamageSetDefault( DestructibleDamageInfo );
	
	DestructibleDamageInfo.location = srcActor.location;
	DestructibleDamageInfo.rotation = srcActor.rotation;
	DestructibleDamageInfo.damageAmount = Damage; 
	DestructibleDamageInfo.instigatedBy = instigatedBy;
	DestructibleDamageInfo.hitlocation = hitlocation; 
	DestructibleDamageInfo.momentum = momentum;
	DestructibleDamageInfo.damageType = damageType; 
	DestructibleDamageInfo.hitInfo = HitInfo;
	DestructibleDamageInfo.isValid = true;
	
	AddOnDestructProcess();
	//actionState = SPDActionState_Done;
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function DoDestruct( Actor srcActor, SPDestructibleProperties props, int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType, TraceHitInfo HitInfo )
{
	AddDestruct( srcActor, props, Damage, instigatedBy, hitlocation, momentum, damageType, HitInfo );
	GotoState('ExecutingDestroy');
}


//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function Tick( float elapsedTime )
{
}

//-----------------------------------------------------------------------
// State:   Waiting
// Description:	
//-----------------------------------------------------------------------
auto state Waiting
{
	Begin:
}

//-----------------------------------------------------------------------
// State:   ExecutingDestroy
// Description:	
//-----------------------------------------------------------------------
state ExecutingDestroy
{

	//-----------------------------------------------------------------------
	// Function:   
	// Description:	
	//-----------------------------------------------------------------------
	function DoDestruct( Actor srcActor, SPDestructibleProperties props, int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType, TraceHitInfo HitInfo )
	{
		AddDestruct( srcActor, props, Damage, instigatedBy, hitlocation, momentum, damageType, HitInfo );
	}

	//-----------------------------------------------------------------------
	// Function:   
	// Description:	
	//-----------------------------------------------------------------------
	function Tick( float elapsedTime )
	{
		ActivatePending();
		actionState = ExecuteActiveProcess( elapsedTime );
		PostExecute();
		if ( actionState == SPDActionState_Done && PendingProcessList.length < 1 )
		{
			MakeInActive();
			GotoState('FinishedDestroy');
		}
	}
}

//-----------------------------------------------------------------------
// State:   FinishedDestroy
// Description:	
//-----------------------------------------------------------------------
state FinishedDestroy
{

	//-----------------------------------------------------------------------
	// Function:   
	// Description:	
	//-----------------------------------------------------------------------
	function DoDestruct( Actor srcActor, SPDestructibleProperties props, int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType, TraceHitInfo HitInfo )
	{
	}

Begin:

	MakeInActive();
	DestructibleProperties = None;
	DestructibleActor = None;
	SPDDamageSetDefault( DestructibleDamageInfo );
	
	Destroy();
}

//***********************************************************************
// Default Properties
//***********************************************************************

