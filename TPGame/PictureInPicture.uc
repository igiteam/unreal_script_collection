
class PictureInPicture extends Actor;

var float screenX;
var float screenY;
var float screenW;
var float screenH;
var Material renderMaterial;

var bool bEnabled;


var bool  bScreenTransition;
var float screenTargetX;
var float screenTargetY;
var vector screenTargetDelta;
var float screenTargetAccel;
var float screenTargetDecel;


var float onscreenTimer;





var TPSceneCapture2DActor sceneCapActor;


var vector actorStartPos;
var rotator actorStartRot;

var vector actorTargetPos;
var rotator actorTargetRot;
var vector actorTargetLookat;

var float actorTargetSpeed;
var float actorTargetRotSpeed;

var float actorTargetTime;

enum PiPActorTransitionMode
{
	PiP_ActorTransition_None,
	PiP_ActorTransition_PosRot,
	PiP_ActorTransition_PosLookat
};

var PiPActorTransitionMode transitionMode;// bActorTransition;

var float timeOut;

enum PiPRenderShape
{
	PiP_Square,
	PiP_Triangle,
};

var PiPRenderShape renderShape;


function Init()
{












}


event Tick( float DeltaTime )
{





























































































}



function SetSceneCaptureActorPos( vector Pos )
{




}

function SetSceneCaptureActorRot( rotator Rot )
{




}

function SetSceneCaptureActorTargetPos( vector Pos )
{



}

function SetSceneCaptureActorTargetRot( rotator Rot )
{



}

function SetSceneCaptureActorTargetSpeed( float speed )
{



}

function SetSceneCaptureActorTargetTime( float time )
{



}


function SetSceneCaptureActorTarget( vector Pos, rotator Rot, float Speed )
{






}


function MoveSceneCaptureActorToTarget()
{

























}


function MoveOnscreen()
{








}
function MoveOffscreen()
{





	
}


function SetAccel(float accel)
{



}
function SetDecel(float decel)
{



}


function SetRenderMaterial(Material mat)
{



}

function SetRenderShape( PiPRenderShape shape )
{



}

function SetScreenWidth(float w)
{



}

function SetScreenHeight(float h)
{



}

function SetTimeout(float time)
{



}

function EnablePiP(bool set)
{













}



function Render(Canvas Canvas) //single triangle shape
{








































































}


function Render_old(Canvas Canvas) //three triangle stripe shape
{






















































































































}




