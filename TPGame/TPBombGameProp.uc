class TPBombGameProp extends UseButton
    placeable;

// 65535*2  three 360 degree turns

// 65535*2 - 24575  three 360 degree turns minus ~135 degrees




enum ePosition {BG_Top, BG_Mid, BG_Low, BG_None};

var() bool           bSuccessCauseCountDown;
var() bool           bPlayCountDownSound;
var() float          SuccessTimer;
var() float          WrongWireTimer;
var() SoundCue       CountdownSoundSlow;
var() SoundCue       CountdownSoundFast;
var   SoundCue       FlipSwitchSound;
var   AudioComponent AudioComp;


var SkeletalMeshComponent    bombMesh;
var TPSkelControlPlayerPitch skel_SwitchPitch;

var SkeletalMeshComponent wires[3];
var ePosition             wireMap[4];    // map of colors to positions

var MaterialInstanceConstant pegHighMIC;
var MaterialInstanceConstant pegMidMIC;
var MaterialInstanceConstant pegLowMIC;

var MaterialInstanceConstant wireHighMIC;
var MaterialInstanceConstant wireMidMIC;
var MaterialInstanceConstant wireLowMIC;

var MaterialInstanceConstant failLed;
var MaterialInstanceConstant successLed;
var MaterialInstanceConstant currLed;
var Material                 ledMaterial;
var Material                 ghostMaterial;

var array<MaterialInterface> DefaultBombMeshMaterials;
var array<MaterialInterface> DefaultWire0Materials;
var array<MaterialInterface> DefaultWire1Materials;
var array<MaterialInterface> DefaultWire2Materials;

var ParticleSystemComponent  Sparks;

var PointLightComponent      bombLight;
var PointLightComponent      fillLight;
var PointLightComponent      failLight;
var PointLightComponent      successLight;
var PointLightComponent      currLight;

var bool                     Brighten;
var float                    Brightness;

var SoundCue                 wrongSound;
var SoundCue                 correctSound;

struct NutInfo
{
    var StaticMeshComponent nut;
    var name                socketName;
    var bool                Used;
    var eColor              color;
};

var NutInfo             nuts[3];
var int                 index;
var LinearColor         colors[4];  // colors are coupled to SeqAct_StartBombGoBoomGame eColor

var const name          colorName;
var BombGoBoomGame      bgbGame;
var eColor              currWireColor;
var bool                PlayAttach;

simulated function PostBeginPlay()
{
    local LinearColor led;

    BombMesh.AttachComponentToSocket(Wires[BG_Top], 'Top_wire');
    BombMesh.AttachComponentToSocket(Wires[BG_Mid], 'Mid_wire');
    BombMesh.AttachComponentToSocket(Wires[BG_Low], 'Btm_Wire');

    BombMesh.AttachComponentToSocket(failLight,    'FailLight');
    BombMesh.AttachComponentToSocket(successLight, 'SuccessLight');

    successLed = new class'MaterialInstanceConstant';
    failLed    = new class'MaterialInstanceConstant';
    successLed.SetParent(ledMaterial);
    failLed.SetParent(ledMaterial);

    BombMesh.SetMaterial(1,successLed);
    BombMesh.SetMaterial(2,failLed);

    failLed.SetVectorParameterValue(colorName, led);
    successLed.SetVectorParameterValue(colorName, led);

    index = 0;

    Wires[BG_Top].PlayAnim('bo0001u_na_na_na_na_topwirebpose');
    Wires[BG_Mid].PlayAnim('bo0001t_na_na_na_na_midwirebpose');
    Wires[BG_Low].PlayAnim('bo0001s_na_na_na_na_btmwirebpose');

    skel_SwitchPitch = TPSkelControlPlayerPitch(BombMesh.FindSkelControl('Switch'));
    skel_SwitchPitch.SetSkelControlStrength(1.0,0.0);


	if( WorldInfo.IsPS3Build() )
	{
		//circle button
		colors[0].r = 0.64;
		colors[0].g = 0.17;
		colors[0].b = 0.09;
		
		//X button
		colors[1].r = 0.25;
		colors[1].g = 0.25;
		colors[1].b = 0.50;
		
		//Square button
		colors[2].r = 0.50;
		colors[2].g = 0.21;
		colors[2].b = 0.51;

		//Triangle button
		colors[3].r = 0.18;
		colors[3].g = 0.50;
		colors[3].b = 0.36;
		
	}


    Super.PostBeginPlay();
}

function SetGhostMaterials(bool enable)
{
    local int i;

    if (enable)
    {
        DefaultBombMeshMaterials.Length = 0;
        for (i = 0; i < bombMesh.GetNumElements(); ++i)
        {
            DefaultBombMeshMaterials.AddItem(bombMesh.GetMaterial(i));
            bombMesh.SetMaterial(i, ghostMaterial);
        }

        DefaultWire0Materials.Length = 0;
        for (i = 0; i < wires[0].GetNumElements(); i++)
        {
            DefaultWire0Materials.AddItem(wires[0].GetMaterial(i));
            wires[0].SetMaterial(i, ghostMaterial);
        }

        DefaultWire1Materials.Length = 0;
        for (i = 0; i < wires[1].GetNumElements(); i++)
        {
            DefaultWire1Materials.AddItem(wires[1].GetMaterial(i));
            wires[1].SetMaterial(i, ghostMaterial);
        }

        DefaultWire2Materials.Length = 0;
        for (i = 0; i < wires[2].GetNumElements(); i++)
        {
            DefaultWire2Materials.AddItem(wires[2].GetMaterial(i));
            wires[2].SetMaterial(i, ghostMaterial);
        }
    }
    else
    {
        for (i = 0; i < DefaultBombMeshMaterials.Length; ++i)
        {
            bombMesh.SetMaterial(i, DefaultBombMeshMaterials[i]);
        }

        for (i = 0; i < DefaultWire0Materials.Length; i++)
        {
            wires[0].SetMaterial(i, DefaultWire0Materials[i]);
        }

        for (i = 0; i < DefaultWire1Materials.Length; i++)
        {
            wires[1].SetMaterial(i, DefaultWire1Materials[i]);
        }

        for (i = 0; i < DefaultWire2Materials.Length; i++)
        {
            wires[2].SetMaterial(i, DefaultWire2Materials[i]);
        }
    }
}

function OnSetGhostMaterial(SeqAct_SetGhostMaterial action)
{
    if (action.InputLinks[0].bHasImpulse)
        SetGhostMaterials(true);
    else if (action.InputLinks[1].bHasImpulse)
        SetGhostMaterials(false);
}

function RandomizeGame()
{
    local int i, topWire, midWire, lowWire, topPeg, midPeg, lowPeg;
    local int WiresTemp[3];

    topWire = rand(4);
    midWire = rand(4);
    lowWire = rand(4);

    // make sure midWire isn't same as top
    if (midWire == topWire)
    {
        midWire += 1;
        if (midWire >= 4)
            midWire = 0;
    }

    // make sure lowWire isn't same as top or mid
    for (i = 0; i < 4; i++)
    {
        if (lowWire == topWire)
            ++lowWire;
        else if (lowWire == midWire)
            ++lowWire;
        
        if (lowWire >= 4)
            lowWire = 0;
    }

    WiresTemp[0] = TopWire;
    WiresTemp[1] = MidWire;
    WiresTemp[2] = LowWire;

    topPeg = WiresTemp[rand(3)];

    midPeg = topPeg;
    while (midPeg == topPeg)
    {
        midPeg = WiresTemp[rand(3)];
    }
  
    lowPeg = midPeg;
    while (lowPeg == topPeg || lowPeg == midPeg)
    {
        lowPeg = WiresTemp[rand(3)];
    }

    PegHighMIC.SetVectorParameterValue(colorName, colors[topPeg]);
    PegMidMIC.SetVectorParameterValue(colorName, colors[midPeg]);
    PegLowMIC.SetVectorParameterValue(colorName, colors[lowPeg]);
    Nuts[BG_Top].color = eColor(topPeg);
    Nuts[BG_Mid].color = eColor(midPeg);
    Nuts[BG_Low].color = eColor(lowPeg);

    WireHighMIC.SetVectorParameterValue(colorName, colors[topWire]);
    WireMidMIC.SetVectorParameterValue(colorName, colors[midWire]);
    WireLowMIC.SetVectorParameterValue(colorName, colors[lowWire]);
    
    // Map of colors to positions
    WireMap[topWire] = BG_Top;
    WireMap[midWire] = BG_Mid;
    WireMap[lowWire] = BG_Low;
}

function InitializeColors(SeqAct_StartBombGoBoomGame seq)
{
    local int i;
    i = 0;

    AttachNut(index);

    for (i = 0; i < 4; i++)
        WireMap[i] = BG_None;

    if (seq.BombGameOptions.bRandomGame)
    {
        RandomizeGame();
    }
    else
    {
        PegHighMIC.SetVectorParameterValue(colorName, colors[seq.BombGameOptions.PegTop]);
        PegMidMIC.SetVectorParameterValue(colorName, colors[seq.BombGameOptions.PegMid]);
        PegLowMIC.SetVectorParameterValue(colorName, colors[seq.BombGameOptions.PegLow]);
        Nuts[BG_Top].color = seq.BombGameOptions.PegTop;
        Nuts[BG_Mid].color = seq.BombGameOptions.PegMid;
        Nuts[BG_Low].color = seq.BombGameOptions.PegLow;

        WireHighMIC.SetVectorParameterValue(colorName, colors[seq.BombGameOptions.WireTop]);
        WireMidMIC.SetVectorParameterValue(colorName, colors[seq.BombGameOptions.WireMid]);
        WireLowMIC.SetVectorParameterValue(colorName, colors[seq.BombGameOptions.WireLow]);
        
        // Map of colors to positions
        WireMap[seq.BombGameOptions.WireTop] = BG_Top;
        WireMap[seq.BombGameOptions.WireMid] = BG_Mid;
        WireMap[seq.BombGameOptions.WireLow] = BG_Low;
    }

    TriggerEventClass(class'SeqEvent_BombGameStart', self);
}

function SetGameLighting(bool On)
{
    if (On)
    {
        bombLight.SetEnabled(true);
        fillLight.SetEnabled(true);
        bombMesh.AttachComponentToSocket(bombLight,'LightSocket');
        bombMesh.AttachComponentToSocket(fillLight,'FillLight');
    }
    else
    {
        bombLight.SetEnabled(false);
        fillLight.SetEnabled(false);
        bombMesh.DetachComponent(bombLight);
        bombMesh.DetachComponent(fillLight);
    }
}

function SetFlashingLight(bool bEnable, bool Success)
{
    if (Success)
    {
        currLed  =successLed;
        currLight=successLight;
    }
    else
    {
        currLed  =failLed;
        currLight=failLight;
    }

    currLight.SetEnabled(bEnable);

    if (bEnable)
        GoToState('Flash');
    else
        GoToState('Idle');
}

function MoveWire(bool Forward, eColor _color, float StartTime)
{
    local name       AnimName;
    local ePosition  WirePos;

    WirePos = WireMap[_color];

    if (WirePos != BG_None)
    {
        PlayAttach    = Forward;
        currWireColor = _color;

        if (Forward)
            AnimName = GetAnimTo(WirePos, ePosition(index));
        else
            AnimName = GetAnimFrom(WirePos, ePosition(index));

        if (StartTime < 0)
            StartTime = 0;

        Wires[WirePos].StopAnim();
        Wires[WirePos].PlayAnim(AnimName,,,,StartTime);
    }
}

function WrongWireDetached()
{
    BombMesh.DetachComponent(Sparks);
    Sparks.DeactivateSystem();
    ClearTimer('GameFail');
    SetFlashingLight(false, false);
}

function WrongWireAttached()
{
    BombMesh.AttachComponentToSocket(Sparks, Nuts[index].SocketName);
    PlaySound(wrongSound);
    Sparks.SetScale(0.1);
    Sparks.ActivateSystem();
    SetTimer(WrongWireTimer,,'GameFail');
    SetFlashingLight(true, false);
}

function RightWireAttached()
{
    PlaySound(correctSound);
}

function GameFail()
{
	bgbGame.StopGame();
    TriggerEventClass(class'SeqEvent_BombGameFail', self);
}

function GameAbort()
{
    local int i;

	// detach all the nuts
    for (i = 0; i < 3; i++)
    {
        if (Nuts[i].Used)
        {
            DetachNut(i);
        }
    }

	// reset the start nut
    index = 0;

	// reset the wires anims
    Wires[BG_Top].PlayAnim('bo0001u_na_na_na_na_topwirebpose');
    Wires[BG_Mid].PlayAnim('bo0001t_na_na_na_na_midwirebpose');
    Wires[BG_Low].PlayAnim('bo0001s_na_na_na_na_btmwirebpose');

	bgbGame.StopGame();
    TriggerEventClass(class'SeqEvent_BombGameAbort', self);
}

function AttachNut(int idx)
{
    Nuts[idx].Used = true;
    Nuts[idx].Nut.SetRotation(rot(0,0,0));
    BombMesh.AttachComponentToSocket(Nuts[idx].Nut, Nuts[idx].SocketName);

    index = idx;
}

function eColor AttachNewNut()
{
    local int i;

    for (i = 0; i < 3; i++)
    {
        if (!Nuts[i].Used)
        {
            AttachNut(i);
            return Nuts[i].color;
        }
    }
}

function bool CheckNut()
{
    return Nuts[index].Nut.Rotation.Yaw > 106495;
}

function SpinNut(bool CCW, float Amount)
{
    local rotator rot;

    rot  = Nuts[index].Nut.Rotation;

    if (rot.Yaw > 106495)
        rot.Yaw += Amount * 500;
    else
        rot.Yaw += Amount * 1500;

    if (rot.Yaw > 131070)
        rot.Yaw = 131070;
    else if (rot.Yaw < 0)
        rot.Yaw = 0;

    Nuts[index].Nut.SetRotation(rot);
}

function DetachNut(int idx)
{
    Nuts[idx].Used = false;
    BombMesh.DetachComponent(Nuts[idx].Nut);
}

function eColor GetInitialPegColor()
{
    return Nuts[0].color;
}

function eColor MoveNut(bool Up)
{
    local int i, oldIndex;

    oldIndex = index;

    for (i = 0; i < 3; i++)
    {
        if (Up)
            --index;
        else
            ++index;
        
        if (index < 0) // wrap around
            index = 2;
        if (index > 2)
            index = 0;

        if (!Nuts[index].Used)
        {
            break;
        }
    }

    DetachNut(oldIndex);
    AttachNut(index);

    return Nuts[index].color;
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (bgbGame != None)
        bgbGame.AnimEnded(PlayAttach, currWireColor);
}

function name GetAnimTo(ePosition wirePos, ePosition pegPos)
{
    switch wirePos
    {
    case BG_Top:
        if (pegPos == BG_Top) return 'bo0001m_na_na_na_na_topwireposone';
        if (pegPos == BG_Mid) return 'bo0001o_na_na_na_na_topwirepostwo';
        if (pegPos == BG_Low) return 'bo0001q_na_na_na_na_topwireposthree';
    case BG_Mid:
        if (pegPos == BG_Top) return 'bo0001g_na_na_na_na_midwireposone';
        if (pegPos == BG_Mid) return 'bo0001i_na_na_na_na_midwirepostwo';
        if (pegPos == BG_Low) return 'bo0001k_na_na_na_na_midwireposthree';
    case BG_Low:
        if (pegPos == BG_Top) return 'bo0001a_na_na_na_na_btmwireposone';
        if (pegPos == BG_Mid) return 'bo0001c_na_na_na_na_btmwirepostwo';
        if (pegPos == BG_Low) return 'bo0001e_na_na_na_na_btmwireposthree';
    default:
        break;
    }

    return 'None';
}

function name GetAnimFrom(ePosition wirePos, ePosition pegPos)
{
    switch wirePos
    {
    case BG_Top:
        if (pegPos == BG_Top) return 'bo0001n_na_na_na_na_topwireposonebk';
        if (pegPos == BG_Mid) return 'bo0001p_na_na_na_na_topwirepostwobk';
        if (pegPos == BG_Low) return 'bo0001r_na_na_na_na_topwireposthreebk';
    case BG_Mid:
        if (pegPos == BG_Top) return 'bo0001h_na_na_na_na_midwireposonebk';
        if (pegPos == BG_Mid) return 'bo0001j_na_na_na_na_midwirepostwobk';
        if (pegPos == BG_Low) return 'bo0001l_na_na_na_na_midwireposthreebk';
    case BG_Low:
        if (pegPos == BG_Top) return 'bo0001b_na_na_na_na_btmwireposonebk';
        if (pegPos == BG_Mid) return 'bo0001d_na_na_na_na_btmwirepostwobk';
        if (pegPos == BG_Low) return 'bo0001f_na_na_na_na_btmwireposthreebk';
    default:
        break;
    }

    return 'None';
}

function AttachSuccess()
{
    TriggerEventClass(class'SeqEvent_BombGameSuccess', self, 0);
}

function FlipSwitch()
{
    skel_SwitchPitch.SetSkelControlStrength(0.0, 0.2);
    TriggerEventClass(class'SeqEvent_BombGameSuccess', self, 1);
    SetTimer(1.5f,,'StopGame');
    PlaySound(FlipSwitchSound);

    if (bSuccessCauseCountDown)
    {
        if (bPlayCountDownSound)
        {
            AudioComp = CreateAudioComponent(CountdownSoundSlow);
            AudioComp.Play();
            SetTimer(SuccessTimer-5.0f,,'ChangeSound');
        }
        else
        {
            SetTimer(SuccessTimer,,'BombGoBoom');
        }
    }

    SetFlashingLight(true, true);
}

function ChangeSound()
{
    AudioComp.Stop();
    AudioComp = CreateAudioComponent(CountdownSoundFast);
    AudioComp.Play();
    SetTimer(5.0f,false,'BombGoBoom');
}

function StopGame()
{
    bgbGame.StopGame();
}

function BombGoBoom()
{
    AudioComp.Stop();
    TriggerEventClass(class'SeqEvent_BombGoBoom', self);
}

state Flash
{
    event BeginState(name PrevState)
    {
        Brightness=0;
        Brighten=true;
        currLight.SetLightProperties(Brightness);
    }

    event EndState(name NextState)
    {
        local LinearColor led;

        successLed.SetVectorParameterValue(colorName, led);
        failLed.SetVectorParameterValue(colorName, led);
    }

    event Tick(float DeltaTime)
    {
        local LinearColor led;

        // .5 seconds to reach brightness of .3
        if (Brighten)
        {
            Brightness += DeltaTime*0.6;
            if (Brightness > 0.3)
                Brighten = false;
        }
        else
        {
            Brightness -= DeltaTime*0.6;
            if (Brightness <= 0)
                Brighten = true;
        }

        if (currLed == failLed)
            led.r = Brightness/0.3;
        else if (currLed == successLed)
            led.g = Brightness/0.3;

        currLed.SetVectorParameterValue(colorName, led);
        currLight.SetLightProperties(Brightness);
    }
}

auto state Idle
{

}


