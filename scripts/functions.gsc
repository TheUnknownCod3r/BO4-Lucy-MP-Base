/*
###########################################
Basic Modifications
###########################################
*/
Godmode()
{
    self.godmode = isDefined(self.godmode) ? undefined : true;
 
    if(isDefined(self.godmode))
    {
        self endon("disconnect");
 
        while(isDefined(self.godmode)) 
        {
            self EnableInvulnerability();
            wait 0.1;
        }
    }
    else
        self DisableInvulnerability();
}

NoclipToggle1(player)
{
    player.Noclip = isDefined(player.Noclip) ? undefined : true;
    
    if(isDefined(player.Noclip))
    {
        player endon("disconnect");
        self S("Noclip ^2Enabled");
        if(player hasMenu() && player isInMenu())
            player closeMenu1();
        player DisableWeapons();
        player DisableOffHandWeapons();
        player.nocliplinker = spawnSM(player.origin, "tag_origin");
        player PlayerLinkTo(player.nocliplinker, "tag_origin");
        
        while(isDefined(player.Noclip) && isAlive(player))
        {
            if(player AttackButtonPressed())
                player.nocliplinker.origin = (player.nocliplinker.origin + (AnglesToForward(player GetPlayerAngles()) * 60));
            else if(player AdsButtonPressed())
                player.nocliplinker.origin = (player.nocliplinker.origin - (AnglesToForward(player GetPlayerAngles()) * 60));
            if(player MeleeButtonPressed())
                break;
            
            wait 0.01;
        }

        if(isDefined(player.Noclip))
            player NoclipToggle1(player);
    }
    else
    {
        player Unlink();
        player.nocliplinker delete();
        player EnableWeapons();
        player EnableOffHandWeapons();
        self S("Noclip ^1Disabled");
    }
}


UnlimitedAmmo()
{
    self.UnlimitedAmmo = isDefined(self.UnlimitedAmmo) ? undefined : true;
    if(isDefined(self.UnlimitedAmmo))
    {
        while(isDefined(self.UnlimitedAmmo))
        {
            self GiveMaxAmmo(self GetCurrentWeapon());
            self SetWeaponAmmoClip(self GetCurrentWeapon(), self GetCurrentWeapon().clipsize);
            wait .05;
        }
    }
}

ClientOpts(func, player)
{
    switch(func)
    {
        case 0: break;
        case 1: break;
    }
}

TestOption()
{
    self iPrintLn("Test");
}

S(Message)
{
    self iPrintLn(Message);
}
UnlimitedGameTime()
{
    level.unlimitedGame = isDefined(level.unlimitedGame) ? undefined : true;
    if(isDefined(level.unlimitedGame)){
        level thread globallogic_utils::pausetimer();
    }
    else{
        level thread globallogic_utils::resumetimer();
    }
}

BO4Level55(player)
{
    player AddRankXPValue("win", 25160000);
    player stats::set_stat(#"playerstatslist",#"rankxp","statvalue",int(25160000));
    if(self.pers[#"rank"] != 54) self.pers[ #"rank" ] = 54;
    self stats::set_stat_global(#"rank",int(54));
    self stats::set_stat_global(#"maxxp",int(1));
    self stats::set_stat_global(#"minxp",int(0));
    self stats::set_stat_global(#"lastxp",1);
    player rank::updaterank();
    wait .1;
    UploadStats(player);
    player iPrintLnBold("XP Set to Max");
}
MP_UnlockAll(player)
{
    if(isDefined(player.UnlockAll))
        return;
    player.UnlockAll = true;

    player endon("disconnect");
    player iPrintLnBold("Unlock All ^2Started");
    if(player != self)
        self iPrintLnBold(player getName() + ": Unlock All ^2Started");
    //player thread UnlockAchievs();
    idx=0;
    for(z=1;z<6;z++)
    {
        if(z == 6) z++; //StatMileStones6.csv is empty, so we skip it.
        switch(z)
        {
            case 1:
                start=1;
                end=256;
                break;
            case 2:
                start=256;
                end=512;
                break;
            case 3:
                start = 512;
                end = 748;
                break;
            case 4:
                start = 768;
                end = 1024;
                break;
            case 5: 
                start = 1024;
                end = 1369;
                break;
            default:
                start=0;
                end=0;
                break;
        }
        for(value=start;value<end;value++)
        {
            stat         = SpawnStruct();
            stat.value   = Int(TableLookup("gamedata/stats/mp/statsmilestones" + z + ".csv", 0, value, 2));
            stat.type    = TableLookup("gamedata/stats/mp/statsmilestones" + z + ".csv", 0, value, 3);
            stat.name    = TableLookup("gamedata/stats/mp/statsmilestones" + z + ".csv", 0, value, 4);            
            switch(stat.type)
            {
                case "global":
                    idx++;
                    player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: Global");
                    player stats::set_stat(#"PlayerStatsList", stat.name, #"StatValue", stat.value);
                    player stats::set_stat(#"PlayerStatsList", stat.name, #"Challengevalue", stat.value);
                    break;
                case "killstreak":
                    idx++;
                    player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: Killstreak");
                    player stats::function_dad108fa(stat.name,stat.value);
                    break;
                case "attachment":
                    idx++;
                    player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: Attachment");
                    player stats::function_dad108fa(stat.name,stat.value);
                    break;
                 case "gamemode":
                    idx++;
                    player stats::function_81f5c0fe(stat.name,stat.value);
                    player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: Gamemode");
                    break;
                case "group":
                    idx++;
                    groups = Array(#"weapon_pistol", #"weapon_smg", #"weapon_assault", #"weapon_lmg", #"weapon_cqb", #"weapon_sniper", #"weapon_tactical", #"weapon_launcher", #"weapon_cqb", #"weapon_knife", #"weapon_special");
                    foreach(group in groups)
                    {
                        player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: Group");
                        //player stats::function_eec52333(getweapon(group),stat.name,stat.value * 2,undefined,undefined,undefined);
                        player stats::set_stat(#"GroupStats", group, #"stats", stat.name, #"StatValue", stat.value);
                        player stats::set_stat(#"GroupStats", group, #"stats", stat.name, #"Challengevalue", stat.value);
                        wait 0.01;
                    }
                    break;
                default:
                    for(x=0;x<level._AllWeaps.size;x++)
                    {
                        idx++;
                        weap = getweapon(level._AllWeaps[x]);
                        if(!isDefined(weap) || stat.name == "") continue;//check for blank stats, so we don't set incorrect data here
                        //these are questionable, pulled from StatMilestones3.csv. Should be weapon Camos, untested.
                        player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: Weapon");
                        player addweaponstat(weap, stat.name, 5000);
                        player addrankxp(#"kill",weap,undefined,undefined,1,5000);
                        player addweaponstat(weap, #"kills", 5000);
                        player addweaponstat(weap, #"headshots", 5000);
                        player addweaponstat(weap, #"longshot_kill", 5000);
                        player addweaponstat(weap, #"hash_72add9adadcd524b", 2500);
                        player addweaponstat(weap, #"hash_48fa9e0371c0697a", 2500);
                        player addweaponstat(weap, #"multikill_2", 2500);
                        player addweaponstat(weap, #"killstreak_5", 2500);
                        player addweaponstat(weap, #"revenge_kill", 2500);
                        player addweaponstat(weap, #"backstabber_kill", 2500);
                        player addweaponstat(weap, #"hash_6d1ab256c84ca772", 2500);
                        wait .1;
                    }
                    break;
            }
            wait 0.1;
            UploadStats(player);
        }
    }
    player iPrintLnBold("^5Unlock All ^2Complete");
}

bo4_AddBotsToGame() 
{
    AddTestClient();
}

EndTheGame()
{
    level thread globallogic::forceend();
    foreach(client in level.players) client iPrintLn("^2Sorry, "+level.hostname+" Ended The Game");
}

GivePlayerKeys(player)//doesnt work yet, but correct func, confirmed via challenges_shared;//see gamedata/ae/generated_ae_gameevents.csv for vals
{
    player.keysLoop = isDefined(player.keysLoop) ? undefined : true;
    while(isDefined(player.keysLoop)){
    player function_cce105c8( #"hash_b9d992688034e59", 1, 250, 2, 3, 3, 1000000 );
    player iPrintLnBold("XP Awarded");
    wait 1;
    }
}

GivePlayerCrates(player)//doesnt work yet, but correct func, confirmed via challenges_shared;//see gamedata/ae/generated_ae_gameevents.csv for vals
{
    player.crateLoop = isDefined(player.crateLoop) ? undefined : true;
    while(isDefined(player.crateLoop)){
        player function_cce105c8( #"hash_680a99fa024dd073", 1, 1000000, 2, 3, 3, 1000000 );
        player iPrintLnBold("XP Awarded");
        wait 1;
    }
}

unfair_aimbot()
{
    self.unfairAimbot = isDefined(self.unfairAimbot) ? undefined : true;

    if(isDefined(self.unfairAimbot))
    {
        self endon("disconnect");
        aimingAt = undefined;
        while(isdefined(self.unfairAimbot)) 
        {
            self waittill(#"weapon_fired");

            start = self geteye();
            end = start + anglestoforward(self getplayerangles()) * 1000000;
            trace = bullettrace(start, end, false, self)["position"];
            foreach(player in level.players)
            {   
                if(player != self && player.pers["team"] != self.pers["team"])
                {
                    wait .1;
                    player dodamage(player.health + 100, player.origin, self, self, "head", "MOD_RIFLE_BULLET", 2, self getCurrentWeapon());
                }
            }
        }

    }
}
