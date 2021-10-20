local matrix = {}
local TABLE_SIZE = 10
local cristals = {'A', 'B', 'C', 'D', 'E', 'F'}
local EMPTY_CELL = ' '

local function subTable(t, exclude)
    local sub = {}
    for i = 0, #t do if i ~= exclude then sub[#sub + 1] = t[i] end end
    return sub
end

function matrix.mix()
    for i = 1, TABLE_SIZE do
        matrix[i] = {}
        for j = 1, TABLE_SIZE do
            subCristalsTable = cristals
            cristalsCount = #cristals
            index = math.random(cristalsCount)
            newCristall = subCristalsTable[index]
            if i > 2 then
                if (matrix[i - 1][j] == newCristall and matrix[i - 2][j] ==
                    newCristall) then
                    cristalsCount = cristalsCount - 1
                    subCristalsTable = subTable(subCristalsTable, index)
                    index = math.random(cristalsCount)
                    newCristall = subCristalsTable[index]
                end
            end
            if j > 2 then
                if (matrix[i][j - 1] == newCristall and matrix[i][j - 2] ==
                    newCristall) then
                    cristalsCount = cristalsCount - 1
                    subCristalsTable = subTable(subCristalsTable, index)
                    index = math.random(cristalsCount)
                    newCristall = subCristalsTable[index]
                end
            end
            matrix[i][j] = newCristall
        end
    end
end

function matrix.move(from, to)
    cristal = matrix[from.y][from.x]
    matrix[from.y][from.x] = matrix[to.y][to.x]
    matrix[to.y][to.x] = cristal
end

local function checkHorizont(location)
    X, Y = location.x, location.y
    matchedCells = {}
    if X - 1 > 0 and matrix[Y][X] == matrix[Y][X - 1] then
        matchedCells[#matchedCells + 1] = {x = X - 1, y = Y}
        if X - 2 > 0 and matrix[Y][X] == matrix[Y][X - 2] then
            matchedCells[#matchedCells + 1] = {x = X - 2, y = Y}
        end
    end
    if X + 1 < TABLE_SIZE and matrix[Y][X] == matrix[Y][X + 1] then
        matchedCells[#matchedCells + 1] = {x = X + 1, y = Y}
        if X + 2 < TABLE_SIZE and matrix[Y][X] == matrix[Y][X + 2] then
            matchedCells[#matchedCells + 1] = {x = X + 2, y = Y}
        end
    end

    if #matchedCells > 1 then
        for key, val in pairs(matchedCells) do
            table.insert(_G['matched'], val)
        end
        return true
    end
    return false
end

local function checkVertical(location)
    X, Y = location.x, location.y
    matchedCells = {}
    if Y - 1 > 0 and matrix[Y][X] == matrix[Y - 1][X] then
        matchedCells[#matchedCells + 1] = {x = X, y = Y - 1}
        if Y - 2 > 0 and matrix[Y][X] == matrix[Y - 2][X] then
            matchedCells[#matchedCells + 1] = {x = X, y = Y - 2}
        end
    end
    if Y + 1 < TABLE_SIZE and matrix[Y][X] == matrix[Y + 1][X] then
        matchedCells[#matchedCells + 1] = {x = X, y = Y + 1}
        if Y + 2 < TABLE_SIZE and matrix[Y][X] == matrix[Y + 2][X] then
            matchedCells[#matchedCells + 1] = {x = X, y = Y + 2}
        end
    end

    if #matchedCells > 1 then
        for key, val in pairs(matchedCells) do
            table.insert(_G['matched'], val)
        end
        return true
    end
    return false
end

local function checkPoint(point)
    count = #_G['matched']
    isMatchedVertical = checkVertical(point)
    isMatchedHorizont = checkHorizont(point)

    if count < #_G['matched'] then table.insert(_G['matched'], point) end
    return isMatchedHorizont or isMatchedVertical
end

local function isHavePossibleMoves()
    for i = 1, TABLE_SIZE do
        for j = 1, TABLE_SIZE do
            element = matrix[i][j]
            if m == matrix[i + 1][j] then
                if i < 8 and element == matrix[i + 3][j] then
                    return false
                end
                if j < 10 and i < 9 and element == matrix[i + 2][j + 1] then
                    return false
                end
                if j > 1 and i < 9 and element == matrix[i + 2][j - 1] then
                    return false
                end

                if i > 2 and element == matrix[i - 2][j] then
                    return false
                end
                if j < 10 and i > 1 and element == matrix[i - 1][j + 1] then
                    return false
                end
                if j > 1 and i > 1 and element == matrix[i - 1][j - 1] then
                    return false
                end
            end
            if element == matrix[i][j + 1] then
                if j < 8 and element == matrix[i][j + 3] then
                    return false
                end
                if i < 10 and j < 9 and element == matrix[i + 1][j + 2] then
                    return false
                end
                if i > 1 and j < 9 and element == matrix[i - 1][j + 2] then
                    return false
                end

                if j > 2 and element == matrix[i][j - 2] then
                    return false
                end
                if i < 10 and j > 1 and element == matrix[i + 1][j - 1] then
                    return false
                end
                if i > 1 and j > 1 and element == matrix[i - 1][j - 1] then
                    return false
                end
            end
        end
    end
    return true
end

function matrix.checkPossibleMove()
    if isHavePossibleMoves() then
        matrix.mix()
        _G['m'] = "Нет возможности двигаться"
    end
end

local function clearMatchedLines()
    if #_G['matched'] < 1 then return false end
    for key, val in pairs(_G['matched']) do matrix[val.y][val.x] = EMPTY_CELL end
    _G['c'] = _G['c'] + #_G['matched']
end

function matrix.checkMatched(from, to)
    isMatchedFrom = checkPoint(from)
    isMatchedTo = checkPoint(to)

    clearMatchedLines()
    return isMatchedFrom or isMatchedTo
end

local function isPossibleMatches()
    iterFlag = false
    for i = 1, TABLE_SIZE do
        for j = 1, TABLE_SIZE do
            iterFlag = iterFlag or checkPoint({x = j, y = i})
        end
    end
    return iterFlag
end

function matrix.checkPossibleMatches(dump)
    flag = true
    while flag do
        iterFlag = isPossibleMatches()
        clearMatchedLines()
        dump()
        flag = flag and iterFlag
    end
end

return matrix
