local ui = require('UI')
local controll = require('KeyControll')
local matrix = require('TableControll')

local cristals = {'A', 'B', 'C', 'D', 'E', 'F'}
_G['matched'] = {}
_G['c'] = 0
_G['t'] = 360

function init()
    matrix.mix()
    ui.printTable(matrix)
end

function tick()
    os.execute("timeout 1s sleep 0")
    if _G['t'] <= 0 then
        _G['c'] = _G['c'] - 1
    else
        _G['t'] = _G['t'] - 1
    end
end

function dump()
    local matched = _G['matched']
    table.sort(matched, function(a, b) return a.y < b.y end)

    for i = 1, #matched do
        X, Y = matched[i].x, matched[i].y
        while true do
            tick()
            ui.printTable(matrix)
            if Y == 1 then
                matrix[Y][X] = cristals[math.random(#cristals)]
                break
            else
                temp = matrix[Y][X]
                matrix[Y][X] = matrix[Y - 1][X]
                matrix[Y - 1][X] = temp
                Y = Y - 1
            end
        end
        ui.printTable(matrix)
    end
    _G['matched'] = {}
end

init()
while true do
    if _G['t'] <= 0 then break end

    from, to, isExit = controll.readPoints()
    if isExit then break end

    matrix.move(from, to)
    tick()
    ui.printTable(matrix)

    isMatched = matrix.checkMatched(from, to)
    if isMatched then
        dump()
        matrix.checkPossibleMatches(dump)
        matrix.checkPossibleMove()
    end
    ::continue::
    ui.printTable(matrix)
end
ui.exitMessage()
