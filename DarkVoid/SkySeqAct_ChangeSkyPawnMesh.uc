class SkySeqAct_ChangeSkyPawnMesh extends SequenceAction;

var() bool bChangeBody;
var() bool bChangeLegs;
var() bool bChangeHair;
var() SkeletalMesh NewBodyMesh;
var() SkeletalMesh NewLegsMesh;
var() SkeletalMesh NewHairMesh;

event Activated()
{
    local SkyPawn SP;
    local SkyPlayerController SPC;

    SP = SkyPawn(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
    // End:0x96
    if(SP == none)
    {
        SPC = SkyPlayerController(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
        // End:0x96
        if(SPC != none)
        {
            SP = SkyPawn(SPC.Pawn);
        }
    }
    // End:0x133
    if(SP != none)
    {
        // End:0xCB
        if(bChangeBody)
        {
            SP.Mesh.SetSkeletalMesh(NewBodyMesh);
        }
        // End:0xF5
        if(bChangeLegs)
        {
            SP.LegMesh.SetSkeletalMesh(NewLegsMesh);
        }
        // End:0x133
        if(bChangeHair)
        {
            SP.HairMesh.SetSkeletalMesh(NewHairMesh);
            SP.UpdateSecrets();
        }
    }
    //return;    
}
