class SpawnMethod_PlayRagdoll extends SpawnMethod
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum ERecoverTypeFromRagdoll
{
    ETFR_AutoRecover,               // 0
    ETFR_RecoverFromKismet,         // 1
    ETFR_RecoverFromAI,             // 2
    ETFR_MAX                        // 3
};

var() RB_LineImpulseActor ImpulseVector;
var() float AngularVariation;
var() float ForceVariation;
var() float SenseLength;
var() SpawnMethod_PlayRagdoll.ERecoverTypeFromRagdoll RecoverType;

function PostCreateActor(Actor NewActor)
{
    local EvilAIReactCond_EmergeEnemyCloseAndVisible EECACondition;
    local EvilPawn P;
    local Vector LinearVel, AngularVel;

    P = EvilPawn(NewActor);
    // End:0x29A
    if(P != none)
    {
        P.SetShowOnRadar(bShowOnRadar);
        // End:0xAD
        if(ImpulseVector != none)
        {
            LinearVel = Vector(ImpulseVector.Rotation) * ImpulseVector.ImpulseStrength;
        }
        // End:0xD6
        if(ForceVariation > float(0))
        {
            LinearVel += (VRand() * ForceVariation);
        }
        // End:0xFE
        if(AngularVariation > float(0))
        {
            AngularVel = VRand() * AngularVariation;
        }
        P.Knockdown(LinearVel, AngularVel,,,, ((int(RecoverType) == int(0)) ? true : false));
        // End:0x1AA
        if(int(RecoverType) == int(1))
        {
            P.MyEvilAI.ReactionManager.SuppressAllReactions();            
        }
        else
        {
            // End:0x1C1
            if(int(RecoverType) == int(0))
            {                
            }
            else
            {
                // End:0x29A
                if(int(RecoverType) == int(2))
                {
                    EECACondition = new (P.MyEvilAI) Class'EvilAIReactCond_EmergeEnemyCloseAndVisible';
                    EECACondition.DistanceThreshold = SenseLength;
                    EECACondition.OutputChannelName = 'SightPlayer';
                    EECACondition.bKnockedDown = true;
                    EECACondition.Initialize();
                }
            }
        }
    }
    //return;    
}

defaultproperties
{
    SenseLength=1000.0000000
}