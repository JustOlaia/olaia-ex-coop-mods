-- name: OlaiaWorld

-- description: Adds 17 skins, such as Olaia, Diego, Alex, Etc. \n\Press D-Pad down to activate the mod. \n\ \n\Press D-Pad left or right to switch the characters.\n\ \nCreated by \\#fff6a7\\Just\\#444444\\Olaia \\#003366\\| version 8.

-- incompatible: olaiaworld



E_MODEL_RAIDEN = smlua_model_util_get_id("raiden_geo")

E_MODEL_IKEOR = smlua_model_util_get_id("ikeor_geo")

E_MODEL_GMP = smlua_model_util_get_id("gmp_geo")

E_MODEL_SONICPRO = smlua_model_util_get_id("sonicpro_geo")

E_MODEL_BLOCKY = smlua_model_util_get_id("blocky_geo")

E_MODEL_MAX = smlua_model_util_get_id("max_geo")

E_MODEL_ZAX = smlua_model_util_get_id("zax_geo")

E_MODEL_FLAREON = smlua_model_util_get_id("larry_geo")

E_MODEL_TERRY = smlua_model_util_get_id("amy_geo")

E_MODEL_SG64 = smlua_model_util_get_id("sg64_geo")

E_MODEL_EPICMAC = smlua_model_util_get_id("epicmac_geo")

E_MODEL_MAXI64 = smlua_model_util_get_id("washiton_geo")

E_MODEL_EMERALD = smlua_model_util_get_id("emeraldlockdown_geo")

E_MODEL_XBOXY = smlua_model_util_get_id("wisam_geo")

E_MODEL_ALEX = smlua_model_util_get_id("alex_geo")

E_MODEL_DIEGO = smlua_model_util_get_id("diego_geo")



local wardrobeMode = false



modelSkin = 0



-- Edit these values to add/delete a model --

modelVars = {nil, E_MODEL_RAIDEN, E_MODEL_IKEOR, E_MODEL_GMP, E_MODEL_SONICPRO, E_MODEL_BLOCKY, E_MODEL_MAX, E_MODEL_ZAX, E_MODEL_FLAREON, E_MODEL_TERRY, E_MODEL_SG64, E_MODEL_EPICMAC, E_MODEL_MAXI64, E_MODEL_EMERALD, E_MODEL_XBOXY, E_MODEL_ALEX, E_MODEL_DIEGO}

modelList = {'Default', 'Raiden', 'Ikeor', 'GMP64', 'Sonicpro808', 'Blocky', 'Max', 'Zax', 'Error Jevil', 'Terry', 'SG64', 'EpicMac', 'Maxi64', 'EmeraldLockdown', 'Xboxy', 'Alex', 'Diego'}



modelSkin_limit = 0

for _ in pairs(modelVars) do modelSkin_limit = modelSkin_limit + 1 end



function mario_update_local(m)

    -- Some Stuff --

    if modelSkin <= -1 then

        modelSkin = modelSkin_limit

    end

    if modelSkin >= modelSkin_limit + 1 then

        modelSkin = 0

    end



    if wardrobeMode == true then

        set_mario_animation(m, MARIO_ANIM_STAND_AGAINST_WALL)

    end

    -- Controls --

    if wardrobeMode == true then

        if (m.controller.buttonPressed & R_JPAD) ~= 0 then

            play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)

            modelSkin = modelSkin + 1

        end

        if (m.controller.buttonPressed & L_JPAD) ~= 0 then

            play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)

            modelSkin = modelSkin - 1

        end

    end

    if (m.controller.buttonPressed & D_JPAD) ~= 0 then

        if wardrobeMode == true then

            play_sound(SOUND_MENU_STAR_SOUND_OKEY_DOKEY, m.marioObj.header.gfx.cameraToObject)

            wardrobeMode = false

            return true

        end

        if wardrobeMode == false then

            play_sound(SOUND_ACTION_READ_SIGN, m.marioObj.header.gfx.cameraToObject)

            wardrobeMode = true

            return true

        end

    end

    -- Models --

    gPlayerSyncTable[0].modelId = modelVars[modelSkin + 1]

end



function mario_update(m)

    if m.playerIndex == 0 then

        mario_update_local(m)

    end



    if gPlayerSyncTable[m.playerIndex].modelId ~= nil then

        obj_set_model_extended(m.marioObj, gPlayerSyncTable[m.playerIndex].modelId)

    end

end



function mario_before_phys_step(m)

    if wardrobeMode == true then

        m.vel.x = 0

        if m.vel.y > 0 then

            m.vel.y = 0

        end

        m.vel.z = 0

    end

end



function hud_char()

    djui_hud_set_resolution(RESOLUTION_DJUI);

    djui_hud_set_font(FONT_MENU);



    local screenHeight = djui_hud_get_screen_height()

    local screenWidth = djui_hud_get_screen_width()

    local scale = 1

    local tscale = 0.8

    local width = 0

    local twidth = 0

    local height = 64 * scale

    local theight = 64 * tscale



    if modelSkin >= modelSkin_limit + 1 then

        width = djui_hud_measure_text(modelList[1]) * scale

    elseif modelSkin <= -1 then

        width = djui_hud_measure_text(modelList[modelSkin_limit + 1]) * scale

    else

        width = djui_hud_measure_text(modelList[modelSkin + 1]) * scale

    end



    if modelSkin >= modelSkin_limit + 1 then

        twidth = djui_hud_measure_text(modelList[1]) * tscale

    elseif modelSkin <= -1 then

        twidth = djui_hud_measure_text(modelList[modelSkin_limit + 1]) * tscale

    else

        twidth = djui_hud_measure_text(modelList[modelSkin + 1]) * tscale

    end



    local y = (screenHeight / 2) - (height / 2) + 300

    local x = (screenWidth / 2) - (width / 2)



    local ty = (screenHeight / 2) - (theight / 2) + 300

    local tx = (screenWidth / 2) - (twidth / 2)



    if wardrobeMode == true then

        if modelSkin >= modelSkin_limit + 1 then

            djui_hud_print_text(modelList[1], x, y, scale)

        elseif modelSkin <= -1 then

            djui_hud_print_text(modelList[modelSkin_limit + 1], x, y, scale)

        else

            djui_hud_print_text(modelList[modelSkin + 1], x, y, scale)

        end



        scale = 0.8

        djui_hud_set_color(255,255,255,123)

        if modelSkin + 1 >= modelSkin_limit + 1 then

            djui_hud_print_text(modelList[1], tx + 500, ty, tscale)

        elseif modelSkin + 1 <= -1 then

            djui_hud_print_text(modelList[modelSkin_limit + 1], tx + 500, ty, tscale)

        else

            djui_hud_print_text(modelList[modelSkin + 2], tx + 500, ty, tscale)

        end



        if modelSkin - 1 >= modelSkin_limit + 1 then

            djui_hud_print_text(modelList[1], tx - 500, ty, tscale)

        elseif modelSkin - 1 <= -1 then

            djui_hud_print_text(modelList[modelSkin_limit + 1], tx - 500, ty, tscale)

        else

            djui_hud_print_text(modelList[modelSkin], tx - 500, ty, tscale)

        end

    end

end



function on_hud_render()

    hud_char()

end



hook_event(HOOK_BEFORE_PHYS_STEP, mario_before_phys_step)

hook_event(HOOK_ON_HUD_RENDER, on_hud_render)

hook_event(HOOK_MARIO_UPDATE, mario_update)

