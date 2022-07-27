-- add olaia to entrie

E_MODEL_OLAIA_PLAYER = smlua_model_util_get_id("olaia_geo")

local justLaunched = true

local doMoveset = false

function startUpdate()

    

    if justLaunched then

        table.insert(modelVars, E_MODEL_OLAIA_PLAYER)

        table.insert(modelList, 'Olaia')

        -- We have to do this or it will not be added as an entry

        modelSkin_limit = modelSkin_limit + 1

    end

    justLaunched = false

end

hook_event(HOOK_UPDATE, startUpdate)

--do moveset

local fireCooldown = 0

function init_flame(obj)

    obj_scale(obj, 3)

end

function mario_update(m)

    --check if olaia is selected, if not, then return

    if modelList[modelSkin + 1] ~= 'Olaia' then return end

    if m.playerIndex ~= 0 then return end

    if (m.controller.buttonPressed & Y_BUTTON) ~= 0 and fireCooldown <= 0 then

        spawn_sync_object(id_bhvFlameBouncing, E_MODEL_RED_FLAME, m.pos.x, m.pos.y + 300, m.pos.z, init_flame)

        fireCooldown = 1 * 30

    end

    if m.floorHeight ~= m.pos.y then

        if (m.controller.buttonPressed & X_BUTTON) ~= 0 and m.action ~= ACT_TWIRLING then

            m.action = ACT_TWIRLING

            m.vel.y = 90

        end

        if m.action == ACT_TWIRLING and (m.controller.buttonDown & Z_TRIG) ~= 0 then

           m.vel.y = -55

        end

    else

        if m.action == ACT_DIVE_SLIDE  then

            if m.input == INPUT_NONZERO_ANALOG then

                m.slideVelZ = m.slideVelZ * 1.08

                m.slideVelX = m.slideVelX * 1.08

            end

        end

    end

    if m.action == ACT_TWIRL_LAND then

        m.action = ACT_GROUND_POUND_LAND

        m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE

        m.particleFlags = m.particleFlags | PARTICLE_TRIANGLE

        play_sound(SOUND_MARIO_GROUND_POUND_WAH, m.marioObj.header.gfx.cameraToObject)

        play_sound(SOUND_GENERAL_POUND_ROCK, m.marioObj.header.gfx.cameraToObject)

    end

end

function update()

    -- no need to check here

    fireCooldown = fireCooldown - 1

end

hook_event(HOOK_MARIO_UPDATE, mario_update)

hook_event(HOOK_UPDATE, update)

--wall slide

ACT_WALL_SLIDE = (0x0BF | ACT_FLAG_AIR | ACT_FLAG_MOVING | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

function act_wall_slide(m)

    --check if olaia is selected, if not, then return

    if modelList[modelSkin + 1] ~= 'Olaia' then return end

    if (m.input & INPUT_A_PRESSED) ~= 0 then

        local rc = set_mario_action(m, ACT_WALL_KICK_AIR, 0)

        

        m.vel.y = 60.0

        if m.forwardVel < 20.0 then

            m.forwardVel = 20.0

        end

        m.wallKickTimer = 0

        return rc

    end

    -- attempt to stick to the wall a bit. if it's 0, sometimes you'll get kicked off of slightly sloped walls

    mario_set_forward_vel(m, -1.0)

    m.particleFlags = m.particleFlags | PARTICLE_DUST

    play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject)

    set_mario_animation(m, MARIO_ANIM_START_WALLKICK)

    if perform_air_step(m, 0) == AIR_STEP_LANDED then

        mario_set_forward_vel(m, 0.0)

        if check_fall_damage_or_get_stuck(m, ACT_HARD_BACKWARD_GROUND_KB) == 0 then

            return set_mario_action(m, ACT_FREEFALL_LAND, 0)

        end

    end

    m.actionTimer = m.actionTimer + 1

    if m.wall == nil and m.actionTimer > 2 then

        mario_set_forward_vel(m, 0.0)

        return set_mario_action(m, ACT_FREEFALL, 0)

    end

    -- gravity

    m.vel.y = m.vel.y + 2

    return 0

end

function mario_on_set_action(m)

    --check if olaia is selected, if not, then return

    if modelList[modelSkin + 1] ~= 'Olaia' then return end

    -- wall slide

    if m.action == ACT_SOFT_BONK then

        m.faceAngle.y = m.faceAngle.y + 0x8000

        set_mario_action(m, ACT_WALL_SLIDE, 0)

    end

end

hook_event(HOOK_ON_SET_MARIO_ACTION, mario_on_set_action)

hook_mario_action(ACT_WALL_SLIDE, act_wall_slide)
