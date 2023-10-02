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

  -- For layer peak
  local natural = node:Find("natural")
  local survey_point = node:Find("survey_point")

  if natural == "peak" or natural == "volcano" or survey_point ~= "" then
    node:Layer("peak", false)
    node:Attribute("name", node:Find("name"))
    SetEleAttribute(node)

    if node:Holds("natural") then
      node:Attribute("natural", natural)

      if node:Holds("ref") then
        local ref = node:Find("ref")
        node:Attribute("ref", ref)

        if ref:find("^百岳") ~= nil then
          local rank = string.match (ref, "%d+")
          SetLevelAttribute(node, 0 + rank)
          if tonumber(rank) < 20 then
            node:MinZoom(7)
          else
            node:MinZoom(8)
          end
        elseif ref:find("^小百岳") then
          local rank = string.match (ref, "%d+")
          SetLevelAttribute(node, 100 + rank)
          node:MinZoom(10)
        else
          SetLevelAttribute(node, 200)
          node:MinZoom(11)
        end
      else
          SetLevelAttribute(node, 300)
          node:MinZoom(11)
      end

    end

    if node:Holds("survey_point") then
      node:Attribute("survey_point", survey_point)
      if survey_point == "trig_1st" then
        SetLevelAttribute(node, 1000)
        node:MinZoom(10)
      elseif survey_point == "trig_2nd" then
        SetLevelAttribute(node, 2000)
        node:MinZoom(11)
      elseif survey_point == "trig_3rd" then
        SetLevelAttribute(node, 3000)
        node:MinZoom(12)
      else
        SetLevelAttribute(node, 4000)
        node:MinZoom(12)
      end
    end
  end
end

-- Similarly for ways

function way_function(way)
end


-- Set ele on any object
function SetEleAttribute(obj)
  local ele = obj:Find("ele")
  if ele ~= "" then
    local meter = math.floor(tonumber(ele) or 0)
    obj:AttributeNumeric("ele", meter)
    end
end

-- Set ele on any object
function SetLevelAttribute(obj, level)
  obj:AttributeNumeric("level", level)
end
