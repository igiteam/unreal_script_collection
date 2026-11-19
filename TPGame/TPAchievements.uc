class TPAchievements extends Object;

// IMPORTANT!!!!
// This file must mirror the EXACT order of the achievements in TurningPoint.spa.h, or this will not work correctly.
// The first 13 elements in the enum should be TA_InvalidAchievement (since achievement id 0-12 are invalid).
//
// If you change the order/number of achievements in the xlast file, and build the spa, you HAVE to update this as well or it will totally
// jack it up.
enum ETPGameAchievements
{
	TA_Invalid0,					//0
	TA_Invalid1,					//1
	TA_Invalid2,					//2
	TA_Invalid3,					//3
	TA_Invalid4,					//4
	TA_Invalid5,					//5
	TA_Invalid6,					//6
	TA_Invalid7,					//7
	TA_Invalid8,					//8
	TA_Invalid9,					//9
	TA_Invalid10,					//10
	TA_Invalid11,					//11
	TA_Invalid12,					//12
	TA_RESERVATIONFORONE,			//13
	TA_SHARPSHOOTER,				//14
	TA_DEFENDER,					//15
	TA_SAVEYOURSELF,				//16
	TA_NEEDARIDE,					//17
	TA_ISAVEDTHEGENERAL,			//18
	TA_DOLLYMADISONAWARD,			//19
	TA_IMPEACHED,					//20
	TA_GOINGNUCLEAR,				//21
	TA_OHTHEHUMANITY,				//22
	TA_STOWAWAY,					//23
	TA_TURNINGPOINT,				//24
	TA_PRESIDENTIALMERIT,			//25
	TA_PRESIDENTIALCITIZENS,		//26
	TA_PRESIDENTIALFREEDOM,			//27
	TA_GRAVITYISAHARSHMISTRESS,		//28
	TA_TVREPAIRS,					//29
	TA_SWIRLYTIME,					//30
	TA_ENVIRONMENTALISM,			//31
	TA_SNOOP,						//32
	TA_INTELLECTUAL,				//33
	TA_MASTERSPY,					//34
	TA_CLINGY,						//35
	TA_RUN,							//36
	TA_COMBATEXPERIENCE,			//37
	TA_COMBATVETERAN,				//38
	TA_ONEMANARMY,					//39
	TA_DEADEYE,						//40
	TA_EXPLODINGMONKEY,				//41
	TA_MASTERSNIPER,				//42
	TA_FIRSTTIMEFOREVERYTHING,		//43
	TA_NEXTTIMETAKETHESTAIRS,		//44
	TA_KILLER,						//45
	TA_KILLERINSTINCT,				//46
	TA_MAYBEISHOULDGOOUTSIDE,		//47
	TA_ONEINTHECHAMBER,				//48
	TA_STAYINALIVE,					//49
	TA_MVP,							//50
	TA_TEAMPLAYER,					//51
	TA_R0XX0RMC0WN4G3,				//52
	TA_PH34RM3H,					//53
	TA_WORLDTOUR,					//54
};
