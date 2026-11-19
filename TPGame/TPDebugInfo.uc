class TPDebugInfo extends Object
	native(Debug);
	
	
enum eTPDebugFlags
{
	//Keep these in sync with the DebugFlags array in defaultproperties - the order must match
	TPD_NONE,
	
	TPD_DISABLEAI,
	TPD_SHOWPAWNAI1,
	TPD_SHOWPAWNAI2,
	TPD_SETFOCUSNAME,
	TPD_SETFOCUSCLASS,
	TPD_LOOKATACTORS,
	TPD_LOOKATPAWNS,
	TPD_SETLOGACTOR,
	TPD_SETLOGCLASS,
	TPD_SHOWSHIMMY,
	TPD_SHOWMANTLE,
	TPD_SHOWVAULT,
	TPD_OUTPUTAILOG,
	TPD_SHOWACTORTAGS,
	TPD_SHOWACTORNAMES,
	TPD_SHOWPLAYERINFO,
    TPD_SHOWDOFINFO,
    TPD_SHOWKYAIMESH,
    TPD_SHOWKYGRAPH,
    TPD_SHOWKYPATHS,
    TPD_SHOWKYAVOIDANCE,

    TPD_SHOWKYENTITIES,
    TPD_SHOWKYOBSTACLES,
    TPD_SHOWCOVERSLOTS,
	TPD_SHOWPAWNANIMS,
	TPD_SHOWPAWNANIMSDEEP,
	TPD_SHOWPAWNROT,
	TPD_TESTBONUS,
    TPD_SHOWLIGHTS,
    TPD_SHOWLI,
    TPD_SHOWSTICKY,
	TPD_SHOWGRENDATA,
	TPD_SHOWJUSTHITPOINTS,
	TPD_TOGGLEDEATHBLENDING,

	TPD_FLAGMAX,
};
	
struct native DebugFlag
{	
	var name commandText;
	var name commandDesc;
	var bool bFlag;
};	


var array<DebugFlag> DebugFlags;

var string actorFocusName;
var class actorFocusClass;

var string logFocusName;
var class logFocusClass;

var class lookAtClass;



// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native noexport function bool GetDebugFlag(eTPDebugFlags flag);
native noexport function SetDebugFlag(eTPDebugFlags flag, bool on);
native noexport function class FindClass(string classname);

native final static function WorldInfo GetWorldInfo();






event Activate(eTPDebugFlags flagIndex, string args, LocalPlayer player)
{
	local TPAIController tpai;
    local Light          light;
    local SpriteComponent spriteComp;
    local ArrowComponent  arrowComp;
    local Actor           actor;
    local name            argName;
	local int i;

	local	TPPlayerController	theController;
	local	TPBonus				theBonus;

	if( flagIndex >= TPD_FLAGMAX )
		return;
	if( player == None )
		return;		
		
		
	if( flagIndex == TPD_NONE )
	{
		//Print help text and bail
		for(i=0; i<DebugFlags.Length; i++)
		{
			;
			player.ViewportClient.ViewportConsole.OutputText( DebugFlags[i].commandText @ "=" @ DebugFlags[i].commandDesc );
			
		}
		player.ViewportClient.ViewportConsole.OutputText( "Press 'PageUp' key to scroll up console window.");
		return;
	}
	
		
	//Set the flag		
	DebugFlags[flagIndex].bFlag = ! DebugFlags[flagIndex].bFlag;
	
	//Output the new value of the flag
	player.ViewportClient.ViewportConsole.OutputText(DebugFlags[flagIndex].commandDesc @ DebugFlags[flagIndex].bFlag);


	
	//Special activation code for certain flags that need it.  Could also call a native helper func here.
	if( flagIndex == TPD_DISABLEAI )
	{
		foreach GetWorldInfo().AllActors(class'TPAIController', tpai)
		{
			tpai.DoToggleAI( ! DebugFlags[flagIndex].bFlag );
		}
	}
	else if( flagIndex == TPD_SETFOCUSNAME )
	{
		actorFocusName = args;
	
		DebugFlags[TPD_LOOKATPAWNS].bFlag=false;
		DebugFlags[TPD_LOOKATACTORS].bFlag=false;
		lookAtClass = None;
		actorFocusClass = None;

	}
	else if( flagIndex == TPD_SETFOCUSCLASS )
	{
		actorFocusClass = FindClass(args);
	}
	else if( flagIndex == TPD_LOOKATACTORS )
	{
		DebugFlags[TPD_LOOKATPAWNS].bFlag=false;
		lookAtClass = None;
		actorFocusClass = None;

		if( DebugFlags[flagIndex].bFlag )
			actorFocusName = "No Name";
		else
			actorFocusName = "";
	
	}
	else if( flagIndex == TPD_LOOKATPAWNS )
	{
		DebugFlags[TPD_LOOKATACTORS].bFlag=false;
		lookAtClass = None;
		actorFocusClass = None;

		if( DebugFlags[flagIndex].bFlag )
			actorFocusName = "No Name";
		else
			actorFocusName = "";
	
	}
	else if( flagIndex == TPD_SETLOGACTOR )
	{
		logFocusName = args;
		logFocusClass = None;
	
	}
	else if( flagIndex == TPD_SETLOGCLASS )
	{
		logFocusClass = FindClass(args);
	}
	else if( flagIndex == TPD_OUTPUTAILOG )
	{
		TPGameInfo(GetWorldInfo().Game).bOutputTPAIToLogWindow = DebugFlags[flagIndex].bFlag;
	}
	else if( flagIndex == TPD_TESTBONUS )
	{
		if ( player == None )
			return;

		if ( player.Actor == None )
			return;

		theController = TPPlayerController(player.Actor);

		if ( theController == None )
			return;

		theBonus = theController.bonusInfo;

		if ( theBonus == None )
			return;

		theBonus.ProcessBonus( args );
	}
    else if (flagIndex == TPD_SHOWLIGHTS)
    {
        foreach GetWorldInfo().AllActors(class'Light', light)
		{
            // Light sprite components are set with AlwaysLoadOnClient=false 
            // so they will not show up in game (but they will in PIE) unless 
            // the sprite is already in memory
            foreach light.ComponentList(class'SpriteComponent',spriteComp)
            {
                spriteComp.SetHidden(!DebugFlags[flagIndex].bFlag);
            }
            foreach light.ComponentList(class'ArrowComponent',arrowComp)
            {
                arrowComp.SetHidden(!DebugFlags[flagIndex].bFlag);
            }
			light.SetHidden(!DebugFlags[flagIndex].bFlag);
		}
    }
    else if (flagIndex == TPD_SHOWLI)
    {
        argName = name(args);

        foreach GetWorldInfo().AllActors(class'Actor', actor)
		{
            if (actor.Name == argName)
            {
                if (actor.IsA('Controller'))
                {
                    Controller(actor).Pawn.bShowLightInfluences = !Controller(actor).Pawn.bShowLightInfluences;
                }

                actor.bShowLightInfluences = !actor.bShowLightInfluences;
                break;
            }
        }
    }
}



