class TPBombProp extends UseButton
    deprecated;
//    native
//    placeable;
//
//`define FAIL_INTERVAL    0.3
//`define SUCCESS_INTERVAL 1.0
//
//var() bool  bFailCauseCountDown;
//var() bool  bSuccessCauseCountDown;
//var() bool  bPlayCountDownSound;
//var() float FailTimer;
//var() float SuccessTimer;
//
//var() SoundCue CountdownSoundSlow;
//var() SoundCue CountdownSoundFast;
//var   AudioComponent AudioComp;
//
//function BombGoBoom()
//{
//    AudioComp.Stop();
//    TriggerEventClass(class'SeqEvent_BombGoBoom', self);
//}
//
//function Fail()
//{
//    AudioComp.Stop();
//    AudioComp = CreateAudioComponent(CountdownSoundFast);
//    AudioComp.Play();
//    SetTimer(FailTimer,false,'BombGoBoom');
//}
//
//function FailCheck()
//{
//    if (bFailCauseCountDown)
//        Fail();
//}
//
//function Success()
//{
//    if (bSuccessCauseCountDown)
//    {
//        AudioComp = CreateAudioComponent(CountdownSoundSlow);
//        AudioComp.Play();
//        SetTimer(SuccessTimer-FailTimer,false,'Fail');
//    }
//}
//
//defaultproperties
//{
//	UseText="Place Bomb"
//
//	Components.Remove(Sprite)
//
//	Begin Object Name=StaticMeshComponent0
//		StaticMesh=StaticMesh'NYBR_Mario.Mesh.NYBR_Bomb_01'
//	End Object
//
//    StaticMesh=StaticMesh'NYBR_Mario.Mesh.NYBR_Bomb_01'
//
//    //CountdownSound=SoundCue'S_XXX_Temp.Test_Beep_Cue'
//    CountdownSoundSlow=SoundCue'S_Prp_Bomb.Bomb_Timer_Slow_Cue'
//    CountdownSoundFast=SoundCue'S_Prp_Bomb.Bomb_Timer_Fast_Cue'
//
//    FailTimer=5.0
//    SuccessTimer=20.0
//
//    bFailCauseCountDown=true
//    bSuccessCauseCountDown=true
//    bPlayCountDownSound=true
//
//    SupportedEvents.Add(class'SeqEvent_BombGameStart')
//    SupportedEvents.Add(class'SeqEvent_BombGameSuccess')
//    SupportedEvents.Add(class'SeqEvent_BombGameFail')
//    SupportedEvents.Add(class'SeqEvent_BombGoBoom')
//}
