class SeqAct_StartEnvironmentGrapple extends SeqAct_Latent
    dependson(TPAnimNodeGrapplePlaceholder)
    native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

enum eDirection {GR_Front, GR_Back};

struct native GrappleInfo
{
    var() bool             bNoRagDollAfterAnim;
    var() bool             bNoRagDollBlending;
    var() eDirection       Approach;
    var() eXboxDPad        DPad;
    var() name             AnimSeqNamePlayer;
    var() name             AnimSeqNameOpponent;

    var() array<AnimSet>   SpecialAnimSetsPlayer;
    var() array<AnimSet>   SpecialAnimSetsOpponent;

    var() array<name>      ImpactLabels;

    var() float            PlayerWithinDegrees;
    var() float            PositionOffset;

    structdefaultproperties
    {
        //From Maya
        PositionOffset=116.65f

        DPad=XboxDDown
        PlayerWithinDegrees=180.0
    }
};

var(Grapple) GrappleInfo GrappleParams;


