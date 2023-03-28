#include scripts\core_common\struct;
#include scripts\core_common\callbacks_shared;
#include scripts\core_common\clientfield_shared;
#include scripts\core_common\math_shared;
#include scripts\core_common\system_shared;
#include scripts\core_common\util_shared;
#include scripts\core_common\hud_util_shared;
#include scripts\core_common\hud_message_shared;
#include scripts\core_common\hud_shared;
#include scripts\core_common\array_shared;
#include scripts\core_common\flag_shared;
#include scripts\core_common\aat_shared.gsc;
#include scripts\mp_common\util.gsc;
#include scripts\core_common\rank_shared.gsc;
#include scripts\core_common\exploder_shared.gsc;
#include scripts\core_common\challenges_shared.gsc;
#include scripts\core_common\contracts_shared.gsc;
#include scripts\core_common\match_record.gsc;
#include scripts\mp_common\gametypes\globallogic_score.gsc;
#include scripts\mp_common\gametypes\globallogic.gsc;
#include scripts\core_common\laststand_shared.gsc;

#namespace bb;

autoexec __init__sytem__()
{
	system::register("bb", &__init__, undefined, undefined);
}

__init__()
{
    callback::on_start_gametype(&init);
    callback::on_spawned(&onPlayerSpawned);
}
