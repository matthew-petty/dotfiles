local M = {}

function M:peek(job)
	local cache = ya.file_cache(job)
	if not cache then
		return
	end

	if self:preload(job) == 1 then
		local png_path = tostring(cache) .. "/preview.png"
		ya.image_show(Url(png_path), job.area)
	else
		ya.preview_widgets(job, {
			ui.Text("Failed to convert Mermaid chart. Make sure the file contains valid Mermaid syntax.")
		})
	end
end

function M:seek(job)
	-- Since we're showing a static image, seek doesn't need to do anything
end

function M:preload(job)
	local cache = ya.file_cache(job)
	if not cache then
		return 0
	end

	local output = cache .. "/preview.png"
	
	-- Check if already cached
	local exists = io.open(output, "r")
	if exists then
		exists:close()
		return 1
	end

	-- Get the actual file path from URL
	local input = tostring(job.file.url)
	
	-- Calculate dimensions based on preview area (multiply by font size approximation)
	local width = math.floor(job.area.w * 10)
	local height = math.floor(job.area.h * 20)
	
	-- Convert mermaid to PNG using mmdc
	local child = Command("mmdc")
		:arg("-i"):arg(input)
		:arg("-o"):arg(output)
		:arg("-t"):arg("default")
		:arg("-b"):arg("white")
		:arg("-e"):arg("png")
		:arg("-w"):arg(tostring(width))
		:arg("-H"):arg(tostring(height))
		:spawn()
	
	if not child then
		return 0
	end
	
	local status = child:wait()
	if status and status.success then
		return 1
	end
	
	return 0
end

return M