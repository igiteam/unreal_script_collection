class MOHAAnimBlendByOIR extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object);

enum EOIRIndices
{
    OIRNODE_LOCOMOTION,             // 0
    OIRNODE_OIR,                    // 1
    OIRNODE_STEERING,               // 2
    OIRNODE_MAX                     // 3
};

var() float BlendTime;
var(BlendPreview) editoronly int ActiveChild;
var int PrevChild;
var transient bool bAllowSteer;

function OnBecomeRelevant()
{
    SetActiveChild(0, 0.0000000);
    //return;    
}

defaultproperties
{
    BlendTime=0.2500000
    bPlayActiveChild=true
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}