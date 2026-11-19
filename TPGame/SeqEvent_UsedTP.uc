class SeqEvent_UsedTP extends SeqEvent_Used;

enum eInteractType
{
	IT_Hand,
	IT_Break,
	IT_Ladder,
	IT_Lock,
	IT_Speak,
	IT_Swap,
    IT_Pipe
};

var array<Texture2D> InteractTextures;
var () eInteractType InteractType;
var()  float AimToInteractDotAngle;


