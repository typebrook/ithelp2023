-- 只有當 OSM 物件具有以下的 key，才會被處理
node_keys = { "natural", "survey_point" }

-- 開始邏輯，tilemaker 需要，留白即可
function init_function()
end

-- 結束邏輯，tilemaker 需要，留白即可
function exit_function()
end

-- 如何處理每個 node 物件
function node_function(node)
    -- natural 標籤的值
    local natural = node:Find("natural")
    
    -- survey_point 標籤的值
    local survey_point = node:Find("survey_point")
    
    -- 若 natural 為 peak（山頂）或 volcano（火山），或者 survey_point 不為空白值
    -- 則將該 node 寫入 Layer
    if natural == "peak" or natural == "volcano" or survey_point ~= "" then
        node:Layer("peak", false)
        
        -- 為 Feature 加入 欄位 "natural"
        if node:Holds("natural") then node:Attribute("natural", natural) end
        
        -- 為 Feature 加入 欄位 "survey_point"
        if survey_piont ~= "" then node:Attribute("survey_point", survey_point) end
        return
    end
end

-- 如何處理每個 way 物件，先留白即可
function way_function(way)
end