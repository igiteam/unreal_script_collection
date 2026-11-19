class GrappleInteraction_v2 extends Interaction
	within GameViewportClient
	transient
    dependson(SeqAct_StartEnvironmentGrapple)
    dependson(TPAnimNodeGrapplePlaceholder)
	config(Input);





// This is the distance the human shield should be after the transition animation
// finishes...got this value by logging the distance


enum eGrappleAction
{
    GA_Transition,
    GA_Struggle,
    GA_Break,
    GA_Kill,
    GA_EnvKill,
    GA_Shield,
    GA_ShieldKill,
    GA_ShieldDied,
    GA_ShieldHit
};

//var Texture2D               GrapplePromptIcon;
var Texture2D               GrappleKillDPad;
var Texture2D               GrappleKillDPadPS3;

var int                     GrappleCamChoice;

var float                   AccuTime;
var float                   AnimTime;
var float                   StruggleCounter;
var float                   LastShotTime;
var const config float      StruggleTime;
var const config float      FailSafeTime;
var const config float      FailSafeTimeEnv;

var TPPlayerController	    GrapplePlayer;
var TPSoldierAIController	GrappleOpponent;

var TPGrappleNode                  GrappleNode;
var SeqAct_StartEnvironmentGrapple GrappleInfo;

var Actor                          PlayerPosition;
var bool                           bEnvironmentalGrapple;

var array<Transitions>           ActiveTransition;
var TPAnimNodeGrapplePlaceholder GrapplePlaceholder;
var int                          TransitionIndex;
var int                          StruggleIndex;
var int                          BreakIndex;
var int                          KillIndex;
var eXboxDPad                    KillDPad;
var eDirection                   eApproach;

var bool                         bFailSafeTriggered;
var bool                         bShieldDied;
var bool                         bShieldKill;
var config name					 GrappleButton;

var name                         GrappleKeyboard;
var name                         KillKeyboard;
var name                         ShieldKeyboard;

var localized string EnvironmentalKillString;
var localized string InstantKillString;
var localized string HumanShieldString;

function Initialized()
{
	GotoState('Inactive');
	Super.Initialized();
}

function PostRender(Canvas Canvas);
function ActionFinished(eGrappleAction Action);
function GrappleImpact(name Label);
function ShieldHasDied();
function ShieldShotReaction();

function ClearGrapple()
{
    ModifyAnimBlendTimes(false);

	if (GrapplePlayer != None && GrapplePlayer.Pawn != None)
	{
		GrapplePlayer.Pawn.SetPhysics(PHYS_Falling);
	}

	if (GrappleOpponent != None && GrappleOpponent.Pawn != None)
	{
		GrappleOpponent.Pawn.SetPhysics(PHYS_Falling);
	}

    if (GrapplePlayer != None)
	{
	    PlayerPawn(GrapplePlayer.Pawn).SetHumanShield(false);
        TPHUD(GrapplePlayer.myHud).bGrapplePrompt=false;
	}

    GrapplePlayer         = None;
    GrappleOpponent       = None;
    GrapplePlaceholder    = None;
    GrappleInfo           = None;
    PlayerPosition        = None;

    GoToState('Inactive');
}

function EnablePrompt(TPPlayerController player, TPWehrmachtAIController Opponent)
{
	if(player != None)
	{
		GrapplePlayer   = player;
		GrappleOpponent = Opponent;

        if (!IsInState('Prompt'))
		    GotoState('Prompt');
	}
}


function bool GrappleShouldAbsorb(name Key)
{
	local bool bAbsorb;

	local int CurrConfig;
	local bool bSouthPaw;
	GrapplePlayer.ProfileSettings.GetProfileSettingValueId(class'TPProfileSettings'.const.ControllerConfigType, CurrConfig);
	if( CurrConfig==TPCO_DefaultSouthPaw || CurrConfig==TPCO_AlternateSouthPaw)
		bSouthPaw = true;
	else
		bSouthPaw = false;


	bAbsorb = false;

	//`log(self @ "GrappleSouthpaw: " @ bSouthPaw /*GrapplePlayer.ProfileSettings.GetSouthpawForced()*/);

    switch (Key)
    {
		case 'XboxTypeS_LeftTrigger':
			if( bSouthPaw==false ) //Only absorb LT when NOT in southpaw
				bAbsorb = true;
			break;

		case 'XboxTypeS_RightTrigger':
			if( bSouthPaw==true ) //Only absorb RT when in southpaw
				bAbsorb = true;
			break;

			
		case 'XboxTypeS_DPad_Up':
		case 'XboxTypeS_DPad_Down':
		case 'XboxTypeS_DPad_Left':
		case 'XboxTypeS_DPad_Right':
		case 'XboxTypeS_RightShoulder':
		case 'XboxTypeS_LeftShoulder':
		case 'XboxTypeS_A':
		case 'XboxTypeS_B':
		case 'XboxTypeS_X':
		case 'XboxTypeS_Y':
			bAbsorb = true;
		default:
			break;
	}

	return bAbsorb;
}
			


/**
 * Process an input key event routed through unrealscript from another object. This method is assigned as the value for the
 * OnRecievedNativeInputKey delegate so that native input events are routed to this unrealscript function.
 *
 * @param	ControllerId	the controller that generated this input key event
 * @param	Key				the name of the key which an event occured for (KEY_Up, KEY_Down, etc.)
 * @param	EventType		the type of event which occured (pressed, released, etc.)
 * @param	AmountDepressed	for analog keys, the depression percent.
 *
 * @return	true to consume the key event, false to pass it on.
 */
function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
{
    local bool bAbsorb;

    bAbsorb = false;

	if(GrapplePlayer.WorldInfo.Pauser == None)
	{
        if (Key == GrapplePlayer.GetNonControllerBinding("EnableAimDownSight | OnRelease DisableAimDownSight") ||
            Key == GrapplePlayer.GetNonControllerBinding("Use | SkipCinematic") ||
            Key == GrapplePlayer.GetNonControllerBinding("Jump")               ||
            Key == GrapplePlayer.GetNonControllerBinding("ChangePosture")      ||
            Key == GrapplePlayer.GetNonControllerBinding("Button bReload | OnRelease Reload") ||
            Key == GrapplePlayer.GetNonControllerBinding("DoSprint")           ||
            Key == GrapplePlayer.GetNonControllerBinding("EquipGrenade | OnRelease FastThrowGrenade") ||
            Key == GrapplePlayer.GetNonControllerBinding("NextWeapon")         ||
            Key == GrapplePlayer.GetNonControllerBinding("PrevWeapon")         ||
            Key == GrapplePlayer.GetNonControllerBinding("ChangeFireType")     ||
            Key == GrapplePlayer.GetNonControllerBinding("TurnOn"))
        {
            return true;
        }


		if( GrappleShouldAbsorb(Key) )
			bAbsorb = true;

	}
	
	return bAbsorb;
}

/**
 * Provides script-only child classes the opportunity to handle input axis events received from the viewport.
 * This delegate is ONLY called when input is being routed natively from the GameViewportClient
 * (i.e. NOT when unrealscript calls the InputKey native unrealscript function on this Interaction).
 *
 * @param	ControllerId	the controller that generated this input axis event
 * @param	Key				the name of the axis that moved  (KEY_MouseX, KEY_XboxTypeS_LeftX, etc.)
 * @param	Delta			the movement delta for the axis
 * @param	DeltaTime		the time (in seconds) since the last axis update.
 * @param	bGamepad		input came from gamepad (ie xbox controller)
 *
 * @return	return TRUE to indicate that the input event was handled.  if the return value is TRUE, the input event will not
 *			be processed by this Interaction's native code.
 */
function bool InputAxis( int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad )
{
	return false;
}

function ModifyAnimBlendTimes(bool enable)
{
    local TPAnimAISceneNode OpponentNode, PlayerNode;

    if (GrappleOpponent != None && GrappleOpponent.Pawn != None)
        OpponentNode = TPAnimAISceneNode(GrappleOpponent.Pawn.Mesh.Animations.FindAnimNode('TPAnimAISceneNode'));

    if (GrapplePlayer != None)
        PlayerNode   = TPAnimAISceneNode(GrapplePlayer.Pawn.Mesh.Animations.FindAnimNode('TPAnimAISceneNode'));

    if (OpponentNode != None && GrappleOpponent != None)
    {
        if (enable)
            OpponentNode.m_overrideBlendTime = 0.5;
        else
            OpponentNode.m_overrideBlendTime = class'TPAnimAISceneNode'.default.m_overrideBlendTime;
    }

    if (PlayerNode != None && GrapplePlayer != None)
    {
        if (enable)
            PlayerNode.m_overrideBlendTime = 0.5;
        else
            PlayerNode.m_overrideBlendTime = class'TPAnimAISceneNode'.default.m_overrideBlendTime;
    }
}

function DisablePrompt()
{
    if (GrapplePlayer != None)
        TPHUD(GrapplePlayer.myHud).bGrapplePrompt=false;

    GrapplePlayer   = None;
    GrappleOpponent = None;

    GoToState('Inactive');
}

function NotifyGameSessionEnded()
{
	super.NotifyGameSessionEnded();

    ClearGrapple();
    GrappleNode = None;
}

function FindGrapplePlaceholder()
{
    if (GrapplePlayer != None)
        GrapplePlaceholder = TPAnimNodeGrapplePlaceholder(GrapplePlayer.Pawn.Mesh.Animations.FindAnimNode('GrapplePlaceholder'));
    else
    {
        ;
        GrapplePlaceholder = None;
        ClearGrapple(); // uh-oh!
    }
}

function bool CheckGrappleSeqActCriteria()
{
    local float  PlayerAngle;

    PlayerPosition = None;
    PlayerPosition = Actor(SeqVar_Object(GrappleInfo.VariableLinks[0].LinkedVariables[0]).GetObjectValue());

    if (PlayerPosition == None)
        return false;

    PlayerAngle   = vector(PlayerPosition.Rotation)   dot vector(GrapplePlayer.Pawn.Rotation);

    // Check player angle
    if (PlayerAngle < Cos(GrappleInfo.GrappleParams.PlayerWithinDegrees * DegToRad))
        return false;

    // eApproach needs to have been set!
    if (GrappleInfo.GrappleParams.Approach != eApproach)
        return false;

    return true;
}

// Recursively search for a SeqAct_StartEnvironmentGrapple
function bool FindGrappleSeqAction(SequenceOp Op, int level)
{
    local int i, j;
    local bool found;

    if (level >= 3)
        return false;

    for (j = 0; j < Op.OutputLinks.Length; j++)
    {
        for (i = 0; i < Op.OutputLinks[j].Links.Length; ++i)
        {
            GrappleInfo = SeqAct_StartEnvironmentGrapple(Op.OutputLinks[j].Links[i].LinkedOp);
            if (GrappleInfo != None)
                return true;
            else
                found = FindGrappleSeqAction(Op.OutputLinks[j].Links[i].LinkedOp, level+1);

            if (found)
                return true;
        }
    }

    return false;
}

function bool CheckGrappleSeqAct()
{
    local int i;
    local bool bCheck;

    if (GrappleNode.GeneratedEvents.Length > 0)
    {
        for (i = 0; i < GrappleNode.GeneratedEvents[0].OutputLinks[0].Links.Length; ++i)
        {
            // Manually manage trigger count
            if (GrappleNode.GeneratedEvents[0].MaxTriggerCount > 0 &&
                GrappleNode.GeneratedEvents[0].TriggerCount >= GrappleNode.GeneratedEvents[0].MaxTriggerCount)
                return false;

            FindGrappleSeqAction(GrappleNode.GeneratedEvents[0], 0);

            //GrappleInfo = SeqAct_StartEnvironmentGrapple(GrappleNode.GeneratedEvents[0].OutputLinks[0].Links[i].LinkedOp);
            //if (GrappleInfo != None)
            //    break;
        }
    }

    if (GrappleInfo == None)
        return false;

    bCheck = CheckGrappleSeqActCriteria();

    if (bCheck)
        GrappleInfo.Targets[0] = GrappleNode;

    return bCheck;
}

function bool CheckExclusions(const array<name> exclusions)
{
    local int i, k;
    local TPWeapon weap[2];
    local class<TPWeapon> excludeWeap;

    weap[0] = TPWeapon(GrappleOpponent.Pawn.Weapon);
    weap[1] = TPWeapon(GrapplePlayer.Pawn.Weapon);

    for (k = 0; k < 2; ++k)
    {
        if (weap[k] != None)
        {
            for (i = 0; i < exclusions.Length; i++)
            {
                excludeWeap = class<TPWeapon>(FindObject(string(exclusions[i]),class'class'));
                if (excludeWeap == weap[k].class)
                    return true;
            }
        }
    }

    return false;
}

function GetActiveTransition()
{
    local float  Look;

    Look   = vector(GrapplePlayer.Pawn.Rotation) dot vector(GrappleOpponent.Pawn.Rotation);

    eApproach        = GR_Front;
    ActiveTransition = GrapplePlaceholder.FrontTransition;

    if (TPWeapon(GrappleOpponent.Pawn.Weapon).WeapId == 'Pistol')
        ActiveTransition = GrapplePlaceholder.PistolTransition;

    if (Look > 0)
    {
        ActiveTransition = GrapplePlaceholder.BackTransition;
        eApproach        = GR_Back;
    }
}

function GetTransitionIndex()
{
    local int i, len;

    TransitionIndex = rand(ActiveTransition.Length);
    len = ActiveTransition.Length;

    i = 0;
    while (i++ < len)
    {
        if (CheckExclusions(ActiveTransition[TransitionIndex].AnimNameTrans.Exclusions))
        {
            if (++TransitionIndex == len)
                TransitionIndex = 0;
        }
        else
        {
            return;
        }
    }

    // No suitable index, bail out (shouldn't get here)!
    ;
    ClearGrapple();}

function GetStruggleIndex()
{
    local int i, len;

    StruggleIndex = rand(ActiveTransition[TransitionIndex].Struggle.Length);
    len = ActiveTransition[TransitionIndex].Struggle.Length;

    i = 0;
    while (i++ < len)
    {
        if (CheckExclusions(ActiveTransition[TransitionIndex].Struggle[StruggleIndex].AnimNameStruggle.Exclusions))
        {
            if (++StruggleIndex == len)
                StruggleIndex = 0;
        }
        else
        {
            return;
        }
    }

    // No suitable index, bail out (shouldn't get here)!
    ;
    ClearGrapple();
}

function GetBreakIndex()
{
    local int i, len;

    BreakIndex = rand(ActiveTransition[TransitionIndex].Struggle[StruggleIndex].AnimNameBreak.Length);
    len = ActiveTransition[TransitionIndex].Struggle[StruggleIndex].AnimNameBreak.Length;

    i = 0;
    while (i++ < len)
    {
        if (CheckExclusions(ActiveTransition[TransitionIndex].Struggle[StruggleIndex].AnimNameBreak[BreakIndex].Exclusions))
        {
            if (++BreakIndex == len)
                BreakIndex = 0;
        }
        else
        {
            return;
        }
    }

    // No suitable index, bail out (shouldn't get here)!
    ;
    ClearGrapple();
}

function GetKillIndex()
{
    local int i, len;

    KillIndex = rand(ActiveTransition[TransitionIndex].Struggle[StruggleIndex].AnimNameKill.Length);
    len = ActiveTransition[TransitionIndex].Struggle[StruggleIndex].AnimNameKill.Length;

    i = 0;
    while (i++ < len)
    {
        if (CheckExclusions(ActiveTransition[TransitionIndex].Struggle[StruggleIndex].AnimNameKill[KillIndex].Exclusions))
        {
            if (++KillIndex == len)
                KillIndex = 0;
        }
        else
        {
            return;
        }
    }

    // No suitable index, bail out (shouldn't get here)!
    ;
    ClearGrapple();
}

function SetPawnEnvPositions()
{
    GrapplePlayer.Pawn.SetLocation(PlayerPosition.Location);
    GrapplePlayer.Pawn.SetRotation(PlayerPosition.Rotation);

    if (GrapplePlayer.bUseGrappleCam)
        GrapplePlayer.SetRotation(PlayerPosition.Rotation);

    GrappleOpponent.Pawn.SetLocation(GrapplePlayer.Pawn.Location +
        GrappleInfo.GrappleParams.PositionOffset*vector(GrapplePlayer.Pawn.Rotation));

    if (GrappleInfo.GrappleParams.Approach == GR_Front)
        GrappleOpponent.Pawn.SetRotation(rotator(-vector(GrapplePlayer.Pawn.Rotation)));
    else
        GrappleOpponent.Pawn.SetRotation(GrapplePlayer.Pawn.Rotation);

    GrappleOpponent.PreserveRotation();
}

function SetPawnZPositions()
{
    local vector NewPos;

    GrappleOpponent.Pawn.SetPhysics(PHYS_None);
    GrapplePlayer.Pawn.SetPhysics(PHYS_None);

    if (GrappleOpponent.Pawn.Location.Z > GrapplePlayer.Pawn.Location.Z)
    {
        NewPos   = GrapplePlayer.Pawn.Location;
        NewPos.Z = GrappleOpponent.Pawn.Location.Z;
        GrapplePlayer.Pawn.SetLocation(NewPos);
    }
    else
    {
        NewPos   = GrappleOpponent.Pawn.Location;
        NewPos.Z = GrapplePlayer.Pawn.Location.Z;
        GrappleOpponent.Pawn.SetLocation(NewPos);
    }
}

function SetPawnRotations()
{
    local vector NewRotation, WehrLocation, PlayerLocation;

    WehrLocation     = GrappleOpponent.Pawn.Location;
    WehrLocation.Z   = 0;

    PlayerLocation   = GrapplePlayer.Pawn.Location;
    PlayerLocation.Z = 0;

    NewRotation = Normal(WehrLocation - PlayerLocation);

    GrapplePlayer.Pawn.SetRotation(rotator(NewRotation));

    if (GrapplePlayer.bUseGrappleCam)
        GrapplePlayer.SetRotation(rotator(NewRotation));

    if (eApproach == GR_Front)
        GrappleOpponent.Pawn.SetRotation(rotator(-vector(GrapplePlayer.Pawn.Rotation)));
    else
        GrappleOpponent.Pawn.SetRotation(GrapplePlayer.Pawn.Rotation);

    GrappleOpponent.PreserveRotation();
}

function SetPawnLocations()
{
    local vector Offset;
    local bool   CanMove;

    Offset = GrapplePlayer.Pawn.Location +
        ActiveTransition[TransitionIndex].PositionOffset*vector(GrapplePlayer.Pawn.Rotation);

    Offset -= GrappleOpponent.Pawn.Location;

    // Test to see there is room to move the opponent by the offset.  If not,
    // we move the player by the offset
    CanMove = TPPawn(GrappleOpponent.Pawn).CheckMove(Offset, GrappleOpponent.Pawn.Location);
    if (CanMove)
    {
        GrappleOpponent.Pawn.SetLocation(GrapplePlayer.Pawn.Location +
            ActiveTransition[TransitionIndex].PositionOffset*vector(GrapplePlayer.Pawn.Rotation));
    }
    else
    {
        //offset = GrappleOpponent.Pawn.Location -
        //    ActiveTransition[TransitionIndex].PositionOffset*vector(GrappleOpponent.Pawn.Rotation);

        GrapplePlayer.Pawn.SetLocation(GrappleOpponent.Pawn.Location +
            ActiveTransition[TransitionIndex].PositionOffset*vector(GrappleOpponent.Pawn.Rotation));
    }
}

function SetPawnGenericPositions()
{
    SetPawnZPositions();
    SetPawnRotations();
    SetPawnLocations();
}

function SetPawnPositions()
{
    if (bEnvironmentalGrapple)
        SetPawnEnvPositions();
    else
        SetPawnGenericPositions();
}

state Inactive
{
    event BeginState(name PrevState)
    {
        GrappleCamChoice      = 0;
        bEnvironmentalGrapple = false;
    }

	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
    {
        return false;
    }

}

state Prompt
{
    event BeginState(name PrevState)
    {
        TPHUD(GrapplePlayer.myHud).bGrapplePrompt=true;
        
   		if( GrapplePlayer.WorldInfo.IsPS3Build() )
		{
			GrappleKillDPad = GrappleKillDPadPS3;
		}
    }

    // no longer drawing the prompt hovering over a guy...it is a use trigger now
	//function PostRender(Canvas Canvas)
	//{
	//	local vector promptWorldPos, promptScreenPos;

	//	Canvas.SetDrawColor(255, 255, 255, 255);
	//	promptWorldPos    = GrappleOpponent.Pawn.Location;
	//	promptWorldPos.Z += GrappleOpponent.Pawn.GetCollisionHeight() + 5.0f;
	//	promptScreenPos   = Canvas.Project(promptWorldPos);

	//	if( promptScreenPos.Z >= 0 && promptScreenPos.Z <= 1 && GrapplePlayer.myHud.bShowHUD )
	//	{
	//		Canvas.SetPos(promptScreenPos.X - GrapplePromptIcon.SizeX * 0.5f, promptScreenPos.Y);
	//		Canvas.DrawTexture(GrapplePromptIcon, 1.0f);
	//	}
	//}

	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		if( Event == IE_Pressed && GrapplePlayer.WorldInfo.Pauser == None)
		{
            if((Key == GrappleKeyboard || Key == GrappleButton) && GrapplePlayer.PlayerCanGrapple())
			{
                FindGrapplePlaceholder();

				if( GrappleOpponent != None && GrappleOpponent.Pawn != None && GrappleOpponent.Pawn.Health >= 1.0 )
				{
					GetActiveTransition();

					if (GrappleNode != None && CheckGrappleSeqAct())
						bEnvironmentalGrapple = true;

					TPHUD(GrapplePlayer.myHud).bGrapplePrompt=false;

					GoToState('GrappleTransition');

					return true;
				}
			}
		}

		return false; // absorb input
	}
}

state GrappleTransition
{
    event BeginState(name PrevState)
    {
        if (TPPawn(GrappleOpponent.Pawn).IsPlayingPerformance())
            TPPawn(GrappleOpponent.Pawn).OnPerformanceEnd();

        ModifyAnimBlendTimes(true);
        GetTransitionIndex();
        SetPawnPositions();

        GetStruggleIndex();
        GetKillIndex();

        GrapplePlayer.GoToState('PlayerGrappling_v2');
        GrapplePlayer.StartGrappleAction(GA_Transition,
            ActiveTransition[TransitionIndex].AnimNameTrans.PlayerAnim, FailSafeTime);

        GrappleOpponent.PushState('Grapple_v2');
        GrappleOpponent.StartGrappleAction(GA_Transition,
            ActiveTransition[TransitionIndex].AnimNameTrans.OpponentAnim, FailSafeTime);

        GrappleOpponent.Pawn.TriggerEventClass(class'SeqEvent_GrappleStart', GrapplePlayer);

        AccuTime = 0;
        AnimTime = GrapplePlayer.Pawn.Mesh.FindAnimSequence
            (ActiveTransition[TransitionIndex].AnimNameTrans.PlayerAnim).SequenceLength;
    }

    function ActionFinished(eGrappleAction action)
    {
        // Hmm...when would action not be GA_Transition?
        if (action == GA_Transition)
        {
            if (WehrmachtPawn(GrappleOpponent.Pawn).bAlwaysBreaksGrapple)
                GoToState('GrappleBreak');
            else
                GoToState('GrappleStruggle');
        }
        else
        {
            ClearGrapple();
        }
    }

    function PostRender(Canvas canvas)
    {
        local float Scale;
        local int   TexSizeY;

        if (WehrmachtPawn(GrappleOpponent.Pawn).bAlwaysBreaksGrapple || GrapplePlayer.WorldInfo.Pauser != None)
            return;

        Scale = 0.5f;

        //TexSizeX = GrappleKillDPad.GetSurfaceWidth() * Scale;
        TexSizeY = GrappleKillDPad.GetSurfaceHeight() * Scale;

		Canvas.SetDrawColor(255, 255, 255, 255);
        Canvas.SetPos(0.7* Canvas.SizeX, 0.8*Canvas.SizeY);
        Canvas.DrawTexture(GrappleKillDPad, Scale);

        // magic numbers galore! temp until proper textures are created
        // top
        Canvas.SetPos(0.7* Canvas.SizeX - 15, 0.8* Canvas.SizeY - 15);
        if (bEnvironmentalGrapple)
            Canvas.DrawText(EnvironmentalKillString);
        else
            Canvas.DrawText(InstantKillString);

        // bottom
        if (!WehrmachtPawn(GrappleOpponent.Pawn).bNoHumanShield)
        {
            Canvas.SetPos(0.7* Canvas.SizeX - 20, 0.8* Canvas.SizeY + TexSizeY - 3);
            Canvas.DrawText(HumanShieldString);
        }
    }

	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
        local bool bAbsorb, bHumanShield;

        bAbsorb      = false;
        bHumanShield = false;

		if( Event == IE_Pressed && GrapplePlayer.WorldInfo.Pauser == None )
		{
            switch (Key)
            {
            case KillKeyboard:
            case 'XboxTypeS_DPad_Up':
                KillDPad = XboxDUp;
                bAbsorb  = true;
                break;
            case ShieldKeyboard:
            case 'XboxTypeS_DPad_Down':
                if (!WehrmachtPawn(GrappleOpponent.Pawn).bNoHumanShield)
                {
                    bHumanShield = true;
                    bAbsorb  = true;
                }
                break;
            //case 'XboxTypeS_DPad_Left':
            //    KillDPad = XboxDLeft;
            //    bAbsorb  = true;
            //    break;
            //case 'XboxTypeS_DPad_Right':
            //    bAbsorb      = true;
            //    break;
            default:
                break;
			}
		}

        if (bHumanShield)
        {
            GoToState('GrappleHumanShieldTransition');
        }
        else if (bAbsorb && bEnvironmentalGrapple)// && (KillDPad == GrappleInfo.GrappleParams.DPad || GrappleInfo.GrappleParams.DPad == XboxDAll))
        {
            GoToState('GrappleEnvironmentKill');
        }
        else if (bAbsorb && ActiveTransition[TransitionIndex].Struggle[StruggleIndex].AnimNameKill[KillIndex].PlayerAnim != '' &&
            ActiveTransition[TransitionIndex].Struggle[StruggleIndex].AnimNameKill[KillIndex].OpponentAnim != '')
        {
            GoToState('GrappleKill');
        }
        else if (bAbsorb)
        {
            ;
        }

		return bAbsorb || Super.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
	}

    event Tick(float DeltaTime)
    {
        AccuTime += DeltaTime;
    }
}

state GrappleStruggle extends GrappleTransition
{
    event BeginState(name PrevState)
    {
        local float FailTime;

        FailTime = FailSafeTime;

        if (GrappleNode != None && GrappleNode.StruggleTime > FailSafeTime)
            FailTime = GrappleNode.StruggleTime + 1;
        else if (GrappleNode != None && GrappleNode.StruggleTime == 0)
            FailTime = 0;

        GrapplePlayer.StartGrappleAction(GA_Struggle,
            ActiveTransition[TransitionIndex].Struggle[StruggleIndex].AnimNameStruggle.PlayerAnim, FailTime, 0);

        GrappleOpponent.StartGrappleAction(GA_Struggle,
            ActiveTransition[TransitionIndex].Struggle[StruggleIndex].AnimNameStruggle.OpponentAnim, FailTime, 0);

        StruggleCounter = 0;
    }

    function ActionFinished(eGrappleAction action)
    {
        GoToState('GrappleKill');
    }


    event Tick(float DeltaTime)
    {
        StruggleCounter += DeltaTime;

        if (GrappleNode != None && GrappleNode.StruggleTime == 0)
        {
            // do nothing
        }
        else if (GrappleNode != None && GrappleNode.StruggleTime > 0)
        {
            if (StruggleCounter > GrappleNode.StruggleTime)
                GoToState('GrappleBreak');
        }
        else if (StruggleCounter > StruggleTime)
        {
            GoToState('GrappleBreak');
        }
    }
}

state GrappleBreak
{
    event BeginState(name PrevState)
    {
        GetBreakIndex();

        GrapplePlayer.StartGrappleAction(GA_Break,
            ActiveTransition[TransitionIndex].Struggle[StruggleIndex].AnimNameBreak[BreakIndex].PlayerAnim, FailSafeTime);
        GrappleOpponent.StartGrappleAction(GA_Break,
            ActiveTransition[TransitionIndex].Struggle[StruggleIndex].AnimNameBreak[BreakIndex].OpponentAnim, FailSafeTime);
    }

    function ActionFinished(eGrappleAction action)
    {
        GrapplePlayer.GoToState('PlayerWalking');
        GrappleOpponent.PopState();

        if (GrappleOpponent.m_bIsWaitingForAnimToFinish)
            GrappleOpponent.SceneFinished();

        GrappleOpponent.Pawn.TriggerEventClass(class'SeqEvent_GrappleFinish', GrapplePlayer, 0);

        GrapplePlayer.Pawn.AddVelocity(vector(GrapplePlayer.Pawn.Rotation)*-200 + vect(0,0,200),
            GrapplePlayer.Pawn.Location, class'TPDamageTypeGrapple');
        GrapplePlayer.Pawn.TakeDamage(1, GrappleOpponent, GrapplePlayer.Pawn.Location, vect(0,0,0),
            class'TPDamageTypeGrapple');

        ClearGrapple();
    }
}

state GrappleKill
{
    event BeginState(name PrevState)
    {
		GrappleOpponent.bGodMode=false;
        GrapplePlayer.StartGrappleAction(GA_Kill,
            ActiveTransition[TransitionIndex].Struggle[StruggleIndex].AnimNameKill[KillIndex].PlayerAnim, FailSafeTime);

        GrappleOpponent.StartGrappleAction(GA_Kill,
            ActiveTransition[TransitionIndex].Struggle[StruggleIndex].AnimNameKill[KillIndex].OpponentAnim, FailSafeTime);

    }

    function ActionFinished(eGrappleAction action)
    {
        GrapplePlayer.GoToState('PlayerWalking');

        ClearGrapple();
    }
}

state GrappleEnvironmentKill extends GrappleKill
{
    event BeginState(name PrevState)
    {
        GrapplePlayer.Pawn.Mesh.RootMotionMode=RMM_Translate;
        GrappleOpponent.Pawn.Mesh.RootMotionMode=RMM_Translate;

        TPPawn(GrapplePlayer.Pawn).AddAnimSets(GrappleInfo.GrappleParams.SpecialAnimSetsPlayer);
        TPPawn(GrappleOpponent.Pawn).AddAnimSets(GrappleInfo.GrappleParams.SpecialAnimSetsOpponent);

        GrappleNode.TriggerGrappleEvent();

        GrapplePlayer.StartGrappleAction(GA_EnvKill,GrappleInfo.GrappleParams.AnimSeqNamePlayer, FailSafeTimeEnv);
        GrappleOpponent.StartGrappleAction(GA_EnvKill,GrappleInfo.GrappleParams.AnimSeqNameOpponent,
            FailSafeTimeEnv,,GrappleInfo.GrappleParams.bNoRagDollAfterAnim, GrappleInfo.GrappleParams.bNoRagDollBlending);
    }

    function ActionFinished(eGrappleAction action)
    {
        GrappleNode.FinishGrappleEvent();
        Super.ActionFinished(action);
    }

    function GrappleImpact(name Label)
    {
        local int i;

        for (i = 0; i < GrappleInfo.GrappleParams.ImpactLabels.Length; i++)
        {
            if (GrappleInfo.GrappleParams.ImpactLabels[i] == Label)
                GrappleInfo.OutputLinks[i+1].bHasImpulse = true;
        }
    }

}

state GrappleHumanShieldTransition
{
    event BeginState(name PrevState)
    {
        local name PlayerAnim, OpponAnim;

        GrapplePlayer.Pawn.Mesh.RootMotionMode=RMM_Translate;

		/* should not use, causes sliding
        GrappleOpponent.ActivateKynapseBrain(false);
		*/
        GrappleOpponent.KynapseClear();

        GrappleOpponent.Pawn.SetPhysics(PHYS_None);
        GrappleOpponent.Pawn.SetCollision(false, false);
        GrappleOpponent.Pawn.Mesh.RootMotionRotationMode=RMRM_RotateActor;

        GrappleOpponent.Pawn.bCollideWorld=false;
        SetPawnGenericPositions();

        if (eApproach == GR_Back)
        {
            PlayerAnim = 'be0048a_ground_static_stand_attack_humanshieldplayerpistolup';
            OpponAnim  = 'be0048m_ground_static_stand_attack_humanshieldnazipistolup';
        }
        else
        {
            PlayerAnim = 'be0048f_ground_static_stand_attack_humanshieldplayerpupfront';
            OpponAnim  = 'be0048r_ground_static_stand_attack_humanshieldnazipistolupfront';
        }

        if (GrapplePlayer.Pawn.Weapon != None)
            GrapplePlayer.Pawn.Weapon.Mesh.SetHidden(true);

        GrapplePlayer.StartGrappleAction(GA_Shield, PlayerAnim, FailSafeTime);
        GrappleOpponent.StartGrappleAction(GA_Shield, OpponAnim, FailSafeTime);

        // Must do this before calling EndSceneAnimation so proper anims get blended together
        PlayerPawn(GrapplePlayer.Pawn).SetHumanShield(true);
    }

    function ActionFinished(eGrappleAction action)
    {
        if (action == GA_Shield)
        {
            GoToState('GrappleHumanShield');
        }
    }
}

state GrappleHumanShield extends GrappleHumanShieldTransition
{
    event BeginState(name PrevState)
    {
        bShieldDied = false;
        bShieldKill = false;

        // Backup in case player was on a slope in which case the root translation
        // will cause the player and enemy to not line up
        if (VSize(GrappleOpponent.Pawn.Location - GrapplePlayer.Pawn.Location) > 44.8042+25)
        {
            GrappleOpponent.Pawn.SetLocation(GrapplePlayer.Pawn.Location +
                44.8042* (vector(GrapplePlayer.Pawn.Rotation) << rot(0,1000,0)));
        }

        GrapplePlayer.Pawn.SetPhysics(PHYS_Falling);

        GrapplePlayer.GoToState('PlayerShielding');
        GrappleOpponent.GrabbedBy(GrapplePlayer);

        // Make sure fail safe timer is reset
        GrappleOpponent.StartGrappleAction(GA_Shield, 'be0048n_ground_static_stand_attack_humanshieldnaziidle', 0, 0);

        bFailSafeTriggered=false;
    }

    function ActionFinished(eGrappleAction action)
    {
        if (action == GA_ShieldKill || action == GA_ShieldDied)
        {
            PlayerPawn(GrapplePlayer.Pawn).SetHumanShield(false);
            GrappleOpponent.SetBase(None);
            GrapplePlayer.GoToState('PlayerWalking');
            ClearGrapple();
        }
    }

	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
        local bool bKill, bAbsorb;

        bKill   = false;
        bAbsorb = false;

		if( Event == IE_Pressed && GrapplePlayer.WorldInfo.Pauser == None )
		{
            switch (Key)
            {
            case GrappleKeyboard:
            case GrappleButton:
                bKill   = true;
                bAbsorb = true;
                break;
            default:
                break;
            }
		}

        if (bKill && !bShieldDied && !bShieldKill)
        {
            bShieldKill = true;

            PlayerPawn(GrapplePlayer.Pawn).SetHumanShield(false);
            GrapplePlayer.StartGrappleAction(GA_ShieldKill, 'be0048g_ground_static_stand_attack_humanshieldplayerkillnazi', FailSafeTime);
            GrappleOpponent.StartGrappleAction(GA_ShieldKill, 'be0048s_ground_static_stand_attack_humanshieldnazikillnazi', FailSafeTime);

            return bAbsorb;
        }

        return bAbsorb || Super.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
	}

    function ShieldHasDied()
    {
        if (!bShieldKill)
        {
            GrapplePlayer.StartGrappleAction(GA_ShieldDied, 'be0048e_ground_static_stand_attack_humanshieldplayerbreak', FailSafeTime);
            GrappleOpponent.StartGrappleAction(GA_ShieldDied, 'be0048q_ground_static_stand_attack_humanshieldnazibreak', FailSafeTime);
            bShieldDied = true;
        }
    }

    function ShieldShotReaction()
    {
        if (!bShieldKill && !bShieldDied && GrappleOpponent.WorldInfo.TimeSeconds - LastShotTime > 0.5f)
        {
            LastShotTime = GrappleOpponent.WorldInfo.TimeSeconds;
            GrappleOpponent.StartGrappleAction(GA_ShieldHit, 'be0048t_ground_static_stand_attack_humanshieldnazigotshot', FailSafeTime);
        }
    }

    event Tick(float DeltaTime)
    {
        // Fail safe in case opponent breaks out of grapple state for some reason due to AI.
        // We don't want to do this if the human shield was explicitly killed by the player or
        // died from bullets - those cases are handled elsewhere.
        if (!GrappleOpponent.IsInState('Grapple_v2') && !bFailSafeTriggered && !bShieldDied && !bShieldKill)
        {
            GrapplePlayer.StartGrappleAction(GA_ShieldDied, 'be0048e_ground_static_stand_attack_humanshieldplayerbreak', FailSafeTime);
            bFailSafeTriggered = true;
        }
    }

}



