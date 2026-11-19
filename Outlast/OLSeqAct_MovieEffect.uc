class OLSeqAct_MovieEffect extends SequenceAction
	native(Sequence);

var() float ScaleIntensity;
var() bool bStartAtRandomFrame;

var() TextureMovie Movie;

var() AkEvent SndEventPlay;
var() AkEvent SndEventStop;

enum MovieEffectAnim
{
	MEA_Random,
	MEA_Anim1,
	MEA_Anim2,
	MEA_Anim3
};

var() MovieEffectAnim AnimType;

var() array<vector2d> Anim1;
var() array<vector2d> Anim2;
var() array<vector2d> Anim3;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Movie Effect"
	ObjCategory="Outlast - Effects"

	ScaleIntensity=1.0
	bStartAtRandomFrame=true

	Movie=TextureMovie'02_NanoCloud.Movie.SwamMind'

	InputLinks(0)=(LinkDesc="Play")
	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty

	Anim1(0)=(X=0.00,Y=0.00)
	Anim1(1)=(X=0.07,Y=1.00)
	Anim1(2)=(X=0.21,Y=0.00)
	Anim1(3)=(X=0.74,Y=0.60)
	Anim1(4)=(X=0.38,Y=0.40)
	Anim1(5)=(X=0.43,Y=0.65)
	Anim1(6)=(X=0.51,Y=0.00)
	Anim1(7)=(X=0.56,Y=1.00)
	Anim1(8)=(X=0.62,Y=0.50)
	Anim1(9)=(X=1.00,Y=0.00)

	Anim2(0)=(X=0.00,Y=0.00)
	Anim2(1)=(X=0.03,Y=0.61)
	Anim2(2)=(X=0.27,Y=1.00)
	Anim2(3)=(X=0.34,Y=0.49)
	Anim2(4)=(X=0.36,Y=0.73)
	Anim2(5)=(X=0.39,Y=0.08)
	Anim2(6)=(X=0.41,Y=0.58)
	Anim2(7)=(X=0.43,Y=0.21)
	Anim2(8)=(X=0.56,Y=0.05)
	Anim2(9)=(X=0.60,Y=0.45)
	Anim2(10)=(X=1.24,Y=0.10)
	Anim2(11)=(X=2.00,Y=0.00)

	Anim3(0)=(X=0.00,Y=0.00)
	Anim3(1)=(X=0.03,Y=0.21)
	Anim3(2)=(X=0.08,Y=1.00)
	Anim3(3)=(X=0.34,Y=1.00)
	Anim3(4)=(X=0.35,Y=0.88)
	Anim3(5)=(X=0.40,Y=0.95)
	Anim3(6)=(X=0.45,Y=0.85)
	Anim3(7)=(X=0.49,Y=0.58)
	Anim3(8)=(X=0.53,Y=0.93)
	Anim3(9)=(X=0.56,Y=0.05)
	Anim3(10)=(X=0.60,Y=0.47)
	Anim3(11)=(X=0.76,Y=0.16)
	Anim3(12)=(X=2.00,Y=0.00)
}
