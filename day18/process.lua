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
          local rank = string.match(ref, "%d+")
          SetLevelAttribute(node, 0 + rank)
          if tonumber(rank) < 20 then
            node:MinZoom(7)
          else
            node:MinZoom(8)
          end
        elseif ref:find("^小百岳") then
          local rank = string.match(ref, "%d+")
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
  local isClosed = way:IsClosed()
  local natural  = way:Find("natural")
  local landuse  = way:Find("landuse")
  local water    = way:Find("water")

  -- Set 'water'
  if natural == "water" or landuse == "reservoir" or landuse == "basin" then
    if way:Find("covered") == "yes" or not isClosed then return end
    way:Layer("water", true)
    SetMinZoomByArea(way)

    if way:Find("intermittent") == "yes" then way:Attribute("intermittent", 1) end

    if way:Holds("name") and natural == "water" then
      way:LayerAsCentroid("water_name")
      way:Attribute("name", way:Find("name"))
      SetMinZoomByArea(way)
    end
    return -- in case we get any landuse processing
  end
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

-- Meters per pixel if tile is 256x256
ZRES5  = 4891.97
ZRES6  = 2445.98
ZRES7  = 1222.99
ZRES8  = 611.5
ZRES9  = 305.7
ZRES10 = 152.9
ZRES11 = 76.4
ZRES12 = 38.2
ZRES13 = 19.1

-- Set minimum zoom level by area
function SetMinZoomByArea(way)
	local area=way:Area()
	if     area>ZRES5^2  then way:MinZoom(6)
	elseif area>ZRES6^2  then way:MinZoom(7)
	elseif area>ZRES7^2  then way:MinZoom(8)
	elseif area>ZRES8^2  then way:MinZoom(9)
	elseif area>ZRES9^2  then way:MinZoom(10)
	elseif area>ZRES10^2 then way:MinZoom(11)
	elseif area>ZRES11^2 then way:MinZoom(12)
	elseif area>ZRES12^2 then way:MinZoom(13)
	else                      way:MinZoom(14) end
end
