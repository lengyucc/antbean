
local index = string.find(ngx.var.uri, "([0-9]+)x([0-9]+)");
if (index == nil) then
    ngx.exit(404);
end;

local originalUri = string.sub(ngx.var.uri, 0, index-3);
local area = string.sub(ngx.var.uri, index);
index = string.find(area, "([.])");
area = string.sub(area, 0, index-1);

local image_sizes = {"180x180","210x210","80x80","350x350","50x50","40x40","200x200","800x800"};
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

if table.contains(image_sizes, area) then
    local command = "gm convert " .. ngx.var.image_root .. originalUri .. " -thumbnail " .. area .. " -background white -gravity center -extent " .. area .. " " .. ngx.var.image_root .. ngx.var.uri;
    os.execute(command);
else
    ngx.exit(404);
end;
