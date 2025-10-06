(
-- Define the target frame number
local targetFrame = 100 -- <--- SET YOUR DESIRED FRAME HERE

-- Array to store the objects that have a key at the target frame
local objectsWithKey = #()

-- Iterate through all scene objects
for obj in objects do
(
    -- Flag to track if a key is found for the current object
    local hasKeyOnFrame = false

    -- 1. Check the object's main controller (e.g., visibility, modifiers, etc.)
    local mainCtrl = obj.controller
    if mainCtrl != undefined and (numKeys mainCtrl >= 1 and isKeyAtFrame mainCtrl targetFrame) then
    (
        hasKeyOnFrame = true
    )

    -- 2. Check the Transform Sub-Controllers (Position, Rotation, Scale)
    -- This uses the getSubAnim structure which is the safest way to iterate P/R/S
    if not hasKeyOnFrame and obj.transform.controller != undefined then
    (
        local xformCtrl = obj.transform.controller
        
        -- A PRS controller has 3 sub-controllers: 1:Position, 2:Rotation, 3:Scale
        for i = 1 to (getNumSubs xformCtrl) do
        (
            local subCtrl = getSubAnim xformCtrl i
            
            -- Check if the sub-item is an actual controller and has a key
            if isController subCtrl and numKeys subCtrl >= 1 and isKeyAtFrame subCtrl targetFrame then
            (
                hasKeyOnFrame = true
                exit  -- Exit the inner loop once a key is found
            )
        )
    )

    -- 3. Final comprehensive check for any other animated property (Modifier, Material, etc.)
    if not hasKeyOnFrame then
    (
        for i = 1 to (getNumSubs obj) do
        (
            local subAnim = getSubAnim obj i
            -- If the sub-anim is a controller, check for keys
            if isController subAnim and numKeys subAnim >= 1 and isKeyAtFrame subAnim targetFrame then
            (
                hasKeyOnFrame = true
                exit -- Exit the loop as soon as a key is found
            )
        )
    )

    -- If any check passed, add the object to the selection array
    if hasKeyOnFrame then
    (
        append objectsWithKey obj
    )
)

-- Clear the current selection and select the found objects
clearSelection()
select objectsWithKey

---- Report the result
--if objectsWithKey.count > 0 then
--(
--    format "Selected % objects with an animation key on frame: %\n" objectsWithKey.count targetFrame
--)
--else
--(
    --format "No objects found

)