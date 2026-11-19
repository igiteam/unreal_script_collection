class SeqEvent_RigidBodyCollision extends SequenceEvent
    native
    hidecategories(Object);

var() float MinCollisionVelocity;

defaultproperties
{
    bPlayerOnly=false
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="ImpactVelocity",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[2]=(ExpectedType=Class'SeqVar_Vector',LinkedVariables=none,LinkDesc="ImpactLocation",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Rigid Body Collision"
    ObjCategory="Physics"
}