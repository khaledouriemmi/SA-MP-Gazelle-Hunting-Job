#define GAZELLE_MODEL_ID 19315
new Gazelleex[24];
new timergazelle[24];
new Gazellealive[24];
new GazelleIDs[24];
new hunting[MAX_PLAYERS];
new kilomeat[MAX_PLAYERS];
new numbergazelle[MAX_PLAYERS];
new cangetpaid[MAX_PLAYERS];
new Text3D:GazelleID3d[24];
new huntercar[MAX_PLAYERS];
new GazelleStat[24];
new pickuphunter;
enum Hunterloc
{
	Float:jobXH,
	Float:jobYH,
	Float:jobZH,
	Float:Ro
};
new const gazellesloc[][Hunterloc] =
{
	{-524.27051, -2266.65430, 32.52470, 0.00000},
    {-538.76459, -2287.70996, 30.18230, 0.00000},
    {-529.55853, -2260.59277, 32.52470, 0.00000},
    {-532.78461, -2268.25366, 31.44470, 0.00000},
    {-544.82758, -2290.81934, 28.90230, 0.00000},
    {-555.84619, -2290.86890, 28.42230, 0.00000},
    {-556.99451, -2301.79736, 27.88230, 0.00000},
    {-571.89294, -2306.83496, 27.88230, 0.00000},//
    {-578.09851, -2302.93579, 27.88230, 0.00000},
    {-581.31036, -2323.07593, 27.88230, 0.00000},
    {-581.31036, -2323.07593, 27.88230, 0.00000},
    {-584.98975, -2329.74390, 27.84240, 0.00000},//
    {-586.39587, -2310.64746, 27.84240, 0.00000},
    {-599.89392, -2330.61401, 28.92240, 0.00000},
    {-603.70831, -2342.30786, 28.92240, 0.00000},
    {-609.89307, -2352.03882, 28.92240, 0.00000},
	{-602.45850, -2360.70874, 27.86240, 0.00000},
	{-611.81238, -2358.30859, 28.92240, 0.00000},
	{-602.45587, -2356.71094, 28.26240, 0.00000},
	{-603.18524, -2335.13940, 28.92240, 0.00000},
	{-600.15723, -2335.67139, 28.92240, 0.00000},
	{-600.32819, -2323.12134, 28.92240, 0.00000},
	{-602.51270, -2318.93994, 28.92240, 0.00000},
	{-594.26099, -2319.47974, 28.32240, 0.00000}
};
//look for stock
stock GetClosestmeat(playerid)
{
    new closest_gazelle = -1;
    new Float:closest_distance = 9999.0;

    for (new i = 0; i < sizeof(gazellesloc); i++)
    {
		if(GazelleStat[i] && !Gazellealive[i]){
			new Float:distance = GetPlayerDistanceFromPoint(playerid, gazellesloc[i][jobXH], gazellesloc[i][jobYH], gazellesloc[i][jobZH]);
	        if (distance < closest_distance){
	            closest_gazelle = i;
	            closest_distance = distance;
	        }
		}
    }

    return closest_gazelle;
}

stock GetClosestGazelle(playerid)
{
    new closest_gazelle = -1;
    new Float:closest_distance = 9999.0;

    for (new i = 0; i < sizeof(gazellesloc); i++)
    {
		if(GazelleStat[i] && Gazellealive[i]){
			new Float:distance = GetPlayerDistanceFromPoint(playerid, gazellesloc[i][jobXH], gazellesloc[i][jobYH], gazellesloc[i][jobZH]);
	        if (distance < closest_distance){
	            closest_gazelle = i;
	            closest_distance = distance;
	        }
		}
    }

    return closest_gazelle;
}
-------------------------------------------------------------
you add this to gamemode init
ongamemodeinit
	for (new i = 0; i < 24; i++)
	{
		GazelleIDs[i] = CreateObject(19315, gazellesloc[i][jobXH], gazellesloc[i][jobYH], gazellesloc[i][jobZH], 0, 0, gazellesloc[i][Ro]);
        GazelleStat[i] = false;
        Gazelleex[i] = true;
        Gazellealive[i] = true;
    }
 ActorJob[13] = 
	format(string, sizeof string, "{33CCFF}For sell Gazelle Meat stand up here");
    CreateDynamic3DTextLabel(string, COLOR_YELLOW, -265.517883, -2213.386230, 29.041954, 10.0, .testlos = 1, .streamdistance = 10.0);
	ActorJob[14] = CreateActor(32, -265.517883, -2213.386230, 29.041954, 113.67);
	ApplyActorAnimation(ActorJob[14], "PED", "IDLE_CHAT", 4.1, 1, 1, 1, 1, 1);
  	SetActorInvulnerable(ActorJob[14], true);
	CreateDynamic3DTextLabel("{FFFFFF}stand {1c9e20}here to get vehicle and weapon{FFFFFF}\n{FFD200}to start hunting", COLOR_YELLOW, -262.063415, -2186.230468, 28.946893, 20.0);
	pickuphunter = CreateDynamicPickup(1239, 1, -262.063415, -2186.230468, 28.946893);
---------------------------------------------------------
OnPlayerConnect
	hunting[playerid] = false;
    kilomeat[playerid] = 0;
    cangetpaid[playerid] = true;
    numbergazelle[playerid] = 0;
------------------------------------------------------------------
onplayerdisconnect
if(numbergazelle[playerid] != 0)
    {
	    new money = (((Random(10000,12000) + 2005)*numbergazelle[playerid])/5);
	    GivePlayerCash(playerid, money);
	    kilomeat[playerid] = 0;
	}
    if(hunting[playerid])
    {
        DestroyVehicleEx(huntercar[playerid]);
        RemovePlayerWeapon(playerid, 34);
        SendClientMessage(playerid, COLOR_RED, "** JOB ** you left hunt zone");
        hunting[playerid] = false;
        numbergazelle[playerid] = 0;
	}

--------------------------------------------------------------------
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	
    if(pickupid == pickuphunter && IsPlayerInRangeOfPoint(playerid, 2.0, -262.063415, -2186.230468, 28.946893))
	{
	    if(PlayerInfo[playerid][pJob] != JOB_HUNTER) return 1;
	    if(hunting[playerid]) return 1;
        SetPlayerCheckpoint(playerid, -508.87, -2269.28, 34.67, 8.0);
		huntercar[playerid] = AddStaticVehicleEx(478, -266.935699, -2194.728027, 28.821569, 116.41, -1, -1, -1);
		vehicleFuel[huntercar[playerid]] = 100;
		SetVehicleVirtualWorld(huntercar[playerid], 0);
		PutPlayerInVehicle(playerid, huntercar[playerid], 0);
		GiveWeapon(playerid, 34);
        hunting[playerid] = true;
		SendClientMessage(playerid, COLOR_GREY, "** JOB ** go to checkpoint and start hunting gazelles");
		
	}
	return 1;
}
-----------------------------------------------------------------------
before this  OnPlayerWeaponShot
forward getpaid_gazellejob(h);
public getpaid_gazellejob(h)
{
    cangetpaid[h] = true;
}

forward spawn_gazelle(h);
public spawn_gazelle(h)
{
	if(Gazelleex[h])
	{
	    DestroyObject(GazelleIDs[h]);
	    DestroyDynamic3DTextLabel(GazelleID3d[h]);
	    GazelleIDs[h] = CreateObject(19315, gazellesloc[h][jobXH], gazellesloc[h][jobYH], gazellesloc[h][jobZH], 0.0, 0, gazellesloc[h][Ro]);
		GazelleStat[h] = false;
		Gazellealive[h] = true;
	}
}

forward spawn_gazelles(h);
public spawn_gazelles(h)
{
	if(!Gazelleex[h])
	{
	    DestroyDynamic3DTextLabel(GazelleID3d[h]);
	    DestroyObject(GazelleIDs[h]);
	    GazelleIDs[h] = CreateObject(19315, gazellesloc[h][jobXH], gazellesloc[h][jobYH], gazellesloc[h][jobZH], 0, 0, gazellesloc[h][Ro]);
		GazelleStat[h] = false;
		Gazellealive[h] = true;
	}
}
----------------------------------------------------------------------------
fi  OnPlayerWeaponShot

    if(hittype == BULLET_HIT_TYPE_OBJECT && GetObjectModel(hitid) == GAZELLE_MODEL_ID)
    {
        hitid -= 111;
        if(PlayerInfo[playerid][pJob] != JOB_HUNTER && PlayerInfo[playerid][pSecondJob] != JOB_HUNTER) return SendClientMessage(playerid, COLOR_GREY, "join the job first to start hunting /findjob >>>HUNTER and go to pickup to start hunting");
        
        if(!hunting[playerid]) return SendClientMessage(playerid, COLOR_GREY, "go to pickup to start hunting");
        if(hunting[playerid])
		{
	 		SendClientMessage(playerid, COLOR_GREY, "gazelle t4orbt");
        	// Spawn a new gazelle object with rotated z-axis

        	DestroyObject(GazelleIDs[hitid]);
            GazelleID3d[hitid] = CreateDynamic3DTextLabel("{FFFFFF}press {1c9e20}Y{FFFFFF} to start butchering the meat.", COLOR_YELLOW, gazellesloc[hitid][jobXH], gazellesloc[hitid][jobYH], gazellesloc[hitid][jobZH], 10.0);
	    	GazelleIDs[hitid] = CreateObject(19315, gazellesloc[hitid][jobXH], gazellesloc[hitid][jobYH], gazellesloc[hitid][jobZH], 90.0, 0, gazellesloc[hitid][Ro]);

        	GazelleStat[hitid] = true;

        // Schedule the respawn of the destroyed gazelle after a set time
        	timergazelle[hitid] = SetTimerEx("spawn_gazelle", 180000, 0, "i", hitid);
		}
    }
-----------------------------------------------------------------------------
fi OnPlayerUpdate
if(IsPlayerInRangeOfPoint(playerid, 3.0, -265.517883, -2213.386230, 29.041954))
	{
	    if(!cangetpaid[playerid]) return 1;
	    if(numbergazelle[playerid] != 5)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You need 5 gazelles but you have now %i/5 you need %i more", numbergazelle[playerid],5 - numbergazelle[playerid]);
			cangetpaid[playerid] = false;
			SetTimerEx("getpaid_gazellejob", 10000, 0, "i", playerid);
			return 1;
		}
	    new money = Random(10000,12000) + 2005;
	    kilomeat[playerid] = 0;
	    numbergazelle[playerid] = 0;
	    GivePlayerCash(playerid, money);
	    SendClientMessageEx(playerid, COLOR_GREY, "You get %i for that meat", money);
	    cangetpaid[playerid] = false;
	    SetTimerEx("getpaid_gazellejob", 10000, 0, "i", playerid);

	}
	if(!IsPlayerInRangeOfPoint(playerid, 400.0, -580.36, -2267.91, 26.34))
	{
	    if(hunting[playerid])
	    {
	        DestroyVehicleEx(huntercar[playerid]);
	        RemovePlayerWeapon(playerid, 34);
	        SendClientMessage(playerid, COLOR_RED, "** JOB ** you left hunt zone");
	        hunting[playerid] = false;
		}
	}
-----------------------------------------------------------------------------
OnPlayerKeyStateChange
in the end before the  return 1;
if((newkeys & KEY_YES) && PlayerInfo[playerid][pJob] == JOB_HUNTER)
	{
	    new cg = GetClosestGazelle(playerid);
	    if (IsPlayerInRangeOfPoint(playerid, 2.0, gazellesloc[cg][jobXH], gazellesloc[cg][jobYH], gazellesloc[cg][jobZH]))
		{
		    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 0, 2500, 1);
		    //TogglePlayerControllable(playerid, 0);
		    Gazellealive[cg] = false;
		    DestroyObject(GazelleIDs[cg]);
		    DestroyDynamic3DTextLabel(GazelleID3d[cg]);
		    GazelleIDs[cg] = CreateObject(2806, gazellesloc[cg][jobXH], gazellesloc[cg][jobYH], gazellesloc[cg][jobZH], 0.0, 0.0, 0.0);
		    GazelleID3d[cg] = CreateDynamic3DTextLabel("{FFFFFF}type {1c9e20}/grab{FFFFFF} to grab the meat.", COLOR_YELLOW, gazellesloc[cg][jobXH], gazellesloc[cg][jobYH], gazellesloc[cg][jobZH], 10.0);

            SetTimerEx("spawn_gazelles", 10000, 0, "i", cg);
            KillTimer(timergazelle[cg]);
		}
	}
-----------------------------------------------------------------------------
after cmd:ad
CMD:grab(playerid)
{
    new cg = GetClosestmeat(playerid);
    if(numbergazelle[playerid] == 5) return SendClientMessage(playerid, COLOR_GREY, "You already have 5 gazelle");
    if(!IsPlayerInRangeOfPoint(playerid, 2.0, gazellesloc[cg][jobXH], gazellesloc[cg][jobYH], gazellesloc[cg][jobZH])) return 1;
    DestroyObject(GazelleIDs[cg]);
    GameTextForPlayer(playerid, "~w~Grab meat...", 2000, 3);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 0, 2500, 0);
    new kilo = Random(1, 30) + 30;
    SendClientMessageEx(playerid, COLOR_GREEN, "You get %i kilos of meat", kilo);
    kilomeat[playerid] += kilo;
    numbergazelle[playerid]++;
    DestroyDynamic3DTextLabel(GazelleID3d[cg]);
    if(numbergazelle[playerid] == 5)
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "You get 5 gazelle go to trapper and back hunt now you have : %i", kilomeat[playerid]);
	}
    return 1;
}
---------------------------------------------------------------------------------
replace
CMD:quitjob(playerid, params[])
{
	new slot;

	if(PlayerInfo[playerid][pVIPPackage] >= 1 && sscanf(params, "i", slot))
	{
	    return SCM(playerid, COLOR_SYNTAX, "Usage: /quitjob [1/2]");
	}

	if((PlayerInfo[playerid][pVIPPackage] < 1) || (PlayerInfo[playerid][pVIPPackage] >= 1 && slot == 1))
	{
	    if(PlayerInfo[playerid][pJob] == JOB_NONE)
	    {
	        return SCM(playerid, COLOR_SYNTAX, "You don't have a job which you can quit.");
	    }
        if(numbergazelle[playerid] != 0)
	    {
		    new money = (((Random(10000,12000) + 2005)*numbergazelle[playerid])/5);
		    GivePlayerCash(playerid, money);
		    kilomeat[playerid] = 0;
		}
        if(PlayerInfo[playerid][pJob] == JOB_HUNTER)
	    {
	        if(numbergazelle[playerid] != 0)
		    {
			    new money = (((Random(10000,12000) + 2005)*numbergazelle[playerid])/5);
			    GivePlayerCash(playerid, money);
			    kilomeat[playerid] = 0;
			}
			if(hunting[playerid])
		    {
		        DestroyVehicleEx(huntercar[playerid]);
		        RemovePlayerWeapon(playerid, 34);
		        hunting[playerid] = false;
		        numbergazelle[playerid] = 0;
			}
		}
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET job = -1 WHERE uid = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_AQUA, "You have quit your job as a "SVRCLR"%s{CCFFFF}.", GetJobName(PlayerInfo[playerid][pJob]));
		PlayerInfo[playerid][pJob] = JOB_NONE;
	}
	else if(slot == 2 && PlayerInfo[playerid][pVIPPackage] >= 1)
	{
	    if(PlayerInfo[playerid][pSecondJob] == JOB_NONE)
	    {
	        return SCM(playerid, COLOR_SYNTAX, "You don't have a job in this slot which you can quit.");
	    }
        if(numbergazelle[playerid] != 0)
	    {
		    new money = (((Random(10000,12000) + 2005)*numbergazelle[playerid])/5);
		    GivePlayerCash(playerid, money);
		    kilomeat[playerid] = 0;
		}
        if(PlayerInfo[playerid][pSecondJob] == JOB_HUNTER)
	    {
	        if(numbergazelle[playerid] != 0)
		    {
			    new money = (((Random(10000,12000) + 2005)*numbergazelle[playerid])/5);
			    GivePlayerCash(playerid, money);
			    kilomeat[playerid] = 0;
			}
			if(hunting[playerid])
		    {
		        DestroyVehicleEx(huntercar[playerid]);
		        RemovePlayerWeapon(playerid, 34);
		        hunting[playerid] = false;
		        numbergazelle[playerid] = 0;
			}
		}
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET secondjob = -1 WHERE uid = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_AQUA, "You have quit your secondary job as a "SVRCLR"%s{CCFFFF}.", GetJobName(PlayerInfo[playerid][pSecondJob]));
		PlayerInfo[playerid][pSecondJob] = JOB_NONE;
	}

	return 1;
}
--------------------------------------------------------------------------------------------------
in cmd:jobhelp add
case JOB_HUNTER: SendClientMessage(playerid, COLOR_GREY, "** JOB ** go to pickup and start hunting");
---------------------------------------------------------------------------------
look for enum
{
	JOB_NONE = -1,
add
JOB_HUNTER,
--------------------------------------------------------------------------------
in your locatemethod gps add
else if(!strcmp(params, "HUNTER", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
	    SetPlayerCheckpoint(playerid, jobLocations[JOB_HUNTER][jobX], jobLocations[JOB_HUNTER][jobY], jobLocations[JOB_HUNTER][jobZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the Hunter job.");
	}
or add it by yourself in your GPS ad HUNTER JOB