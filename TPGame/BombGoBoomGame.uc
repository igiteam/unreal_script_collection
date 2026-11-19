class BombGoBoomGame extends BombGoBoomInteraction
    dependson(SeqAct_StartBombGoBoomGame);




var TPPlayerController          tppController;
var TPBombGameProp              bombProp;
var TPBombGameProp              bombClone;

var vector                      oldLocation;
var rotator                     oldRotation;

var SeqAct_StartBombGoBoomGame  seq;

var byte                        WireDone[4];
var byte                        AnimPlaying[4];
var float                       AnimTime[4];
var bool                        Released;
var name                        LastKey;

var eColor                      CurrPeg;
var eColor                      CurrWire;

var float                       AxisTime;
var vector                      LastOrtho;
var vector                      Dir;
var vector                      LastDir;

var name                        KeyboardByPass;

function AnimEnded(bool Attached, eColor _color);


function GetPlayerController(TPPlayerController PlayerController)
{
    tppController = PlayerController;
}
 
function NotifyGameSessionEnded()
{
    bombClone     = None;
    bombProp      = None;
    seq           = None;
    tppController = None;
	super.NotifyGameSessionEnded();
}

function Initialized()
{
	GotoState('Inactive');
	Super.Initialized();
}

function SetBombProp(TPBombGameProp prop)
{
    bombProp = prop;
}

function SetSeqAct(SeqAct_StartBombGoBoomGame sequence)
{
    seq = sequence;
}

function StartGame()
{
    local int     i;
    local vector  EyeLoc;
    local rotator EyeRot;

    for (i = 0; i < 4; i++)
    {
        AnimPlaying[i] = 0;
        WireDone[i]    = 0;
        AnimTime[i]    = 1.0f;
    }

    tppController.Pawn.GetActorEyesViewPoint(EyeLoc, EyeRot);

    tppController.GoToState('PlayerDoNothing');

	tppController.DisableAimDownSight();

    //bombClone         = tppController.Spawn(class'TPBombGameProp',,,EyeLoc + vector(EyeRot)*`PROP_DISTANCE, EyeRot);
    oldLocation = bombProp.Location;
    oldRotation = bombProp.Rotation;

    bombClone         = bombProp;
    bombClone.bgbGame = self;
    bombClone.BombMesh.SetDepthPriorityGroup(SDPG_PostProcess);
    bombClone.SetGhostMaterials(false);
    bombClone.InitializeColors(seq);
    bombClone.SetGameLighting(true);

    tppController.Pawn.Mesh.SetHidden(true);
    if (tppController.Pawn.Weapon != None)
        tppController.Pawn.Weapon.Mesh.SetHidden(true);

    CurrPeg = bombClone.GetInitialPegColor();

    GoToState('Active');
}

function StopGame()
{
    bombProp  = None;
    seq       = None;

    //bombClone.Destroy();
    if (bombClone != None)
    {
        bombClone.SetGameLighting(false);
        bombClone.SetLocation(oldLocation);    
        bombClone.SetRotation(oldRotation);
        bombClone = None;
    }

    if (tppController != None)
        tppController.FinishBombGoBoomGame();

    tppController.Pawn.Mesh.SetHidden(false);
    if (tppController.Pawn.Weapon != None)
        tppController.Pawn.Weapon.Mesh.SetHidden(false);

    tppController.GoToState('PlayerWalking');

    GoToState('Inactive');
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
	if(tppController.WorldInfo.Pauser == None)
	{
        if (Key == tppController.GetNonControllerBinding("Fire")               ||
            Key == tppController.GetNonControllerBinding("EnableAimDownSight | OnRelease DisableAimDownSight") ||
            Key == tppController.GetNonControllerBinding("Use | SkipCinematic") ||
            Key == tppController.GetNonControllerBinding("MoveForward")        ||
            Key == tppController.GetNonControllerBinding("MoveBackward")       ||
            Key == tppController.GetNonControllerBinding("StrafeLeft")         ||
            Key == tppController.GetNonControllerBinding("StrafeRight")        ||
            Key == tppController.GetNonControllerBinding("Jump")               ||
            Key == tppController.GetNonControllerBinding("ChangePosture")      ||
            Key == tppController.GetNonControllerBinding("Button bReload | OnRelease Reload") ||
            Key == tppController.GetNonControllerBinding("DoSprint")           ||
            Key == tppController.GetNonControllerBinding("EquipGrenade | OnRelease FastThrowGrenade") ||
            Key == tppController.GetNonControllerBinding("NextWeapon")         ||
            Key == tppController.GetNonControllerBinding("PrevWeapon")         ||
            Key == tppController.GetNonControllerBinding("ChangeFireType")     ||
            Key == tppController.GetNonControllerBinding("TurnOn"))
        {
            return true;
        }


        switch (Key)
        {
        //case 'XboxTypeS_Start':  // @temp fail safe
        //case KeyboardByPass:
        //    bombClone.FlipSwitch();
        //    return true;
        case 'XboxTypeS_DPad_Up':
        case 'XboxTypeS_DPad_Down':
        case 'XboxTypeS_DPad_Left':
        case 'XboxTypeS_DPad_Right':
        case 'XboxTypeS_LeftTrigger':
        case 'XboxTypeS_RightTrigger':
        case 'XboxTypeS_RightShoulder':
        case 'XboxTypeS_LeftShoulder':
        case 'XboxTypeS_A':
        case 'XboxTypeS_B':
        case 'XboxTypeS_X':
        case 'XboxTypeS_Y':
        case 'XboxTypeS_Back':
        case 'XboxTypeS_RightThumbstick':
        case 'XboxTypeS_LeftThumbstick':
            return true;
        default:
            break;
		}
	}

    return false;
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

function SetBombPosition()
{
    local vector  EyeLoc;
    local rotator EyeRot;

    tppController.Pawn.GetActorEyesViewPoint(EyeLoc, EyeRot);
    bombClone.SetLocation(EyeLoc + vector(EyeRot)*25.0f);
    bombClone.SetRotation(EyeRot);
}

state Inactive
{

}

state Active
{
    event BeginState(name PrevState)
    {
        local int i;
        local int count;

        for (i = 0; i < 4; i++)
        {
            if (WireDone[i] > 0)
                count++;
        }

        if (count >= 3)
            GoToState('FlipSwitch');
    }

    function AnimEnded(bool Attached, eColor _color)
    {
        AnimPlaying[_color] = 0;
        AnimTime[_color]    = 1.0f;
        CurrWire            = _color;

        if (Attached)
            GoToState('PegMe');
        else
            GoToState('Active');
    }

    function bool PlayWireAnim(bool Forward, eColor _color)
    {
        AnimPlaying[_color] = 1;
        AnimTime[_color]    = 1.0f- AnimTime[_color];
        bombClone.MoveWire(Forward, _color, AnimTime[_color]);

        if (Forward)
            GoToState('Wiring');
        else
            GoToState('Active');

        return true;
    }


    function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
    {
	    if (Event == IE_Pressed && tppController.WorldInfo.Pauser == None)
	    {
            LastKey = Key;

            if (Key == 'XboxTypeS_DPad_Up' || Key == tppController.GetNonControllerBinding("MoveForward"))
            {
                CurrPeg = bombClone.MoveNut(true);
                return true;
            }
            else if (Key == 'XboxTypeS_DPad_Down' || Key == tppController.GetNonControllerBinding("MoveBackward"))
            {
                CurrPeg = bombClone.MoveNut(false);
                return true;
            }
            else if (Key == 'XboxTypeS_A' || Key == 'g')
            {
                if (WireDone[XB_Green] == 0)
                    return PlayWireAnim(true, XB_Green);
            }
            else if (Key == 'XboxTypeS_B' || Key == 'r')
            {
                if (WireDone[XB_Red] == 0)
                    return PlayWireAnim(true, XB_Red);
            }
            else if (Key == 'XboxTypeS_Y' || Key == 'y')
            {
                if (WireDone[XB_Yellow] == 0)
                    return PlayWireAnim(true, XB_Yellow);
            }
            else if (Key == 'XboxTypeS_X' || Key == 'b')
            {
                if (WireDone[XB_Blue] == 0)
                    return PlayWireAnim(true, XB_Blue);
            }
			else if (Key == 'XboxTypeS_Back' || Key == 'Escape')
			{
				bombClone.GameAbort();
				return true;
			}
        }

	    return Global.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
    }

    event Tick(float DeltaTime)
    {
        local int i;

        SetBombPosition();

        for (i = 0; i < 4; i++)
            if (AnimPlaying[i] > 0)
                AnimTime[i] += DeltaTime;
    }
}

state Wiring extends Active
{
    event BeginState(name NextState)
    {
        Super.BeginState(NextState);
        Released = false;
    }

    function bool PlayReleaseAnim(eColor _color)
    {
        return PlayWireAnim(false, _color);
    }

    function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
    {
        if (Event == IE_Released && Key == LastKey && !Released && tppController.WorldInfo.Pauser == None)
        {
            Released = true;

            if (bombClone.CheckNut())
            {
                if (CurrPeg == CurrWire)
                {
                    WireDone[CurrWire] = 1;
                    CurrPeg = bombClone.AttachNewNut();
                    bombClone.AttachSuccess();
                    GoToState('Active');
                    return true;
                }
                else
                {
                    GoToState('UnpegMe');
                    return true;
                }
            }

            if (Key == 'XboxTypeS_A' || Key == 'g')
                return PlayReleaseAnim(XB_Green);
            else if (Key == 'XboxTypeS_B' || Key == 'r')
                return PlayReleaseAnim(XB_Red);
            else if (Key == 'XboxTypeS_Y' || Key == 'y')
                return PlayReleaseAnim(XB_Yellow);
            else if (Key == 'XboxTypeS_X' || Key == 'b')
                return PlayReleaseAnim(XB_Blue);
        }

        return Global.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
    }

}

state PegMe extends Wiring
{
    event BeginState(name PrevState)
    {
        Super.BeginState(PrevState);

        if (CurrWire != CurrPeg) // colors don't match
            bombClone.WrongWireAttached();
        else
            bombClone.RightWireAttached();

    }

    event EndState(name NextState)
    {
        Super.EndState(NextState);

        if (NextState == 'Active' && CurrWire != CurrPeg) // colors don't match
            bombClone.WrongWireDetached();
    }

    function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
    {
        Super.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);

        if (CurrWire == CurrPeg && Event == IE_Pressed && tppController.WorldInfo.Pauser == None)
        {
            if (Key == tppController.GetNonControllerBinding("Fire"))
            {
                GoToState('PegMeKeyboard');
                return true;
            }
        }

        return Global.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
    }

    function bool InputAxis( int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad )
    {
        local float  Dot;
        local vector Ortho;
        
        //`log(self @ "InputAxis controllerID" @ ControllerId @ "Player's controllerid=" @ LocalPlayer(tppController.Player).ControllerID );
        if( ControllerId == LocalPlayer(tppController.Player).ControllerID )
        {
			if(Key=='XboxTypeS_LeftX')
				Dir.X = Delta;
			else if(Key=='XboxTypeS_LeftY')
				Dir.Y = Delta;
			Ortho = Dir << rot(0, 16384, 0);

			Dot = LastOrtho dot Dir;

			if (Dot > 0.05f)
				bombClone.SpinNut(false, Normal(Dir) dot Normal(LastDir));
			else if (Dot < -0.05f)
				bombClone.SpinNut(false, -(Normal(Dir) dot Normal(LastDir)));

			LastOrtho = Ortho;
			LastDir   = Dir;
        }



        return false;
    }
}

state PegMeKeyboard
{
    event Tick(float DeltaTime)
    {
        bombClone.SpinNut(false, 70.0f * DeltaTime);

        if (bombClone.CheckNut())
        {
            WireDone[CurrWire] = 1;
            CurrPeg = bombClone.AttachNewNut();
            bombClone.AttachSuccess();
            GoToState('Active');
        }
    }
}

state UnpegMe extends PegMe
{
    event BeginState(name PrevState)
    {
        // Do nothing
    }

    function bool InputAxis( int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad )
    {
        local bool val;

        val = Super.InputAxis(ControllerId, Key, Delta, DeltaTime, bGamepad);

        if (CurrWire != CurrPeg && !bombClone.CheckNut())
            PlayReleaseAnim(CurrWire);

        return val;

    }

}

state FlipSwitch
{
    function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
    {
	    if (Event == IE_Pressed && tppController.WorldInfo.Pauser == None)
	    {
            if (Key == 'XboxTypeS_DPad_Up' || Key == tppController.GetNonControllerBinding("Use | SkipCinematic") ||
                Key == tppController.GetNonControllerBinding("Use"))
            {
                bombClone.FlipSwitch();
                return true;
            }
			else if (Key == 'XboxTypeS_Back' || Key == 'Escape')
			{
				bombClone.GameAbort();
				return true;
			}
        }

        return Global.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
    }

    event Tick(float DeltaTime)
    {
        SetBombPosition();
    }
}

