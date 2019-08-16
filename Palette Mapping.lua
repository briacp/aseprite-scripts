local dlg = Dialog("Palette Mapping")
local pc = app.pixelColor

dlg 
    --:label{text="This will set the current image \nto color mode to Indexed and replace \nthe palette with the selected one."}
    :file {id="originPaletteFile", label="Origin Palette:", filetypes={"aseprite"}, open=true}
    :file {id="targetPaletteFile", label="Target Palette:", filetypes={"aseprite"}, open=true}
    :separator()
    :button {id="ok", text="Map Palette",onclick=function()
        local data = dlg.data

        local cel = app.activeCel
        local img = cel.image:clone()

        local originPal = Palette{ fromFile=data.originPaletteFile }
        local targetPal = Palette{ fromFile=data.targetPaletteFile }

        -- Only deal with palette of the same size
        if #originPal ~= #targetPal then
            app.alert{title="Invalid Palettes", text="Both palettes must have the same number of colors.", buttons="OK"}
            return
        end

--        NOT WORKING
--        local paletteMapping = {}
--        for i = 0, #originPal - 1 do
--            paletteMapping[originPal:getColor(i)] = targetPal:getColor(i);
--        end


        for it in img:pixels() do
            local pixel = it()
            local color = Color{r= pc.rgbaR(pixel), g= pc.rgbaG(pixel), b= pc.rgbaB(pixel), a= pc.rgbaA(pixel)}

--        NOT WORKING
--            if paletteMapping[color] ~= nil then
--                it(paletteMapping[color].rgbaPixel)
--            end

            -- Working, but inefficient
            for i = 0, #originPal - 1 do
                local origPalCol = originPal:getColor(i)
                if origPalCol == color then
                    it(targetPal:getColor(i).rgbaPixel)
                end
            end

        end

        cel.image = img

        --Refresh screen
        app.refresh()
        dlg:close()
    end}
    :show{wait=false}
