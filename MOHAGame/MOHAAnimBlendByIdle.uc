class MOHAAnimBlendByIdle extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object);

var transient MOHASkelControlTwistLean TwistControl;
var() name TwistControlName;
var() name TurnAnimNames[2];
var() float BlendTime;

event OnInit()
{
    super(AnimNode).OnInit();
    TwistControl = MOHASkelControlTwistLean(SkelComponent.FindSkelControl(TwistControlName));
    //return;    
}

defaultproperties
{
    BlendTime=0.3000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}