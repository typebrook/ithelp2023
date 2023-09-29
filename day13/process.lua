-- Nodes will only be processed if one of these keys is present

node_keys = { "natural", "survey_point" }

-- Initialize Lua logic

function init_function()
end

-- Finalize Lua logic()
function exit_function()
end

-- Assign nodes to a layer, and set attributes, based on OSM tags

function node_function(node)
  local survey_point = node:Find("survey_point")
  if survey_point ~= "" then
    node:Layer("peak", false)
    node:Attribute("survey_point", survey_point)
    if survey_point == "trig_1st" then
      node:MinZoom(10)
    elseif survey_point == "trig_2nd" then
      node:MinZoom(11)
    else
      node:MinZoom(12)
    end
    return
  end
end

-- Similarly for ways

