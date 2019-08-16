local dlg = Dialog("Change Palette")
dlg 
    --:label{text="This will set the current image \nto color mode to Indexed and replace \nthe palette with the selected one."}
    :file {id="targetPaletteFile", label="Target Palette:", filetypes={"aseprite"}, open=true}

    :separator()
    :button {id="ok", text="Change Palette",onclick=function()
        local data = dlg.data

        local sprite = app.activeSprite
        local srcPal = sprite.palettes[1]
        local targetPal = Palette{ fromFile=data.targetPaletteFile }

        --local oldColorMode = sprite.spec.colorMode
        --app.alert(oldColorMode)
        app.command.ChangePixelFormat{format="indexed"}

        -- TODO check if srcPal has more colors that targetPal
        local maxPal = #targetPal
        if #srcPal < #targetPal then
            maxPal = #srcPal
        end


        app.transaction(function()
            for index = 0, maxPal - 1, 1
            do
                srcPal:setColor(index, targetPal:getColor(index))
            end
        end)

        -- FIXME sprite.spec.colorMode = oldColorMode

        --Refresh screen
        app.refresh()
        dlg:close()
    end}
    :show{wait=false}
