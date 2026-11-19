class SeqAct_SetLatentScalarParam extends SeqAct_Latent
    native;

var() array<MaterialInstanceConstant> MtlInsts;
var() float IncrAmount;
var() float StopAtValue;
var() float TimeBetweenIncr;
var() name ParamName;
var() float StartValue;
var float LastTime;
var float CurVal;
var() bool bResetOnDestroy;
