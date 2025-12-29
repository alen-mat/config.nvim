local curl = require("plenary.curl")

local M = {
	courseidx = -1,
	chapteridx = -1,
	lessonidx = -1,
	Courses = {},
	Chapters = {},
	Lessons = {},
	find_buffer_by_name = function(name)
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			local buf_name = vim.api.nvim_buf_get_name(buf)
			if buf_name:find(name) then
				return buf
			end
		end
		return -1
	end
}

local BOOT_DOMAIN = "https://api.boot.dev"
local headers = { authorization = "Bearer LLeg" }

local api = {
	ember = { url = BOOT_DOMAIN .. "/v1/ember" },
	progress = { url = BOOT_DOMAIN .. "/v1/course_progress_by_lesson/", auth = true },
	overview = { url = BOOT_DOMAIN .. "/v1/static/courses/overview" },
	courses = { url = BOOT_DOMAIN .. "/v1/courses/" },
	lessons = { url = BOOT_DOMAIN .. "/v1/static/lessons/" }
}

local resp_body_json_course = {}

local function fetchLessonDetails(lessonid)
	local res = curl.request {
		url = api.lessons.url .. lessonid,
		method = "get",
	}
	local lessondata = {}
	local resp_body_json_lesson = vim.fn.json_decode(res.body)

	for key, val in pairs(resp_body_json_lesson.Lesson) do
		if key:find("^LessonData") then
			lessondata = val
			break
		end
	end

	if lessondata.StarterFiles then
		for _, val in ipairs(lessondata.StarterFiles) do
			local lbufnum = M.find_buffer_by_name(val.Name .. "$")
			if lbufnum ~= -1 then
				vim.api.nvim_buf_set_lines(lbufnum, 0, -1, false, vim.split(val.Content, '\n', { plain = true }))
				print(val.Name .. " : found in : " .. lbufnum)
			else
				print("No buffer named : " .. val.Name)
			end
		end
	end

	return vim.split(lessondata.Readme, '\n', { plain = true })
end

local function fetchCourseDetails(courseid)
	local res = curl.request {
		url = api.courses.url .. courseid,
		method = "get",
	}
	local lessons = {}
	resp_body_json_course = vim.fn.json_decode(res.body)
	for _, val in ipairs(resp_body_json_course.Chapters) do
		table.insert(lessons, val.Title)
	end
	return lessons
end

local function fetchLessons(index)
	local lessons = {}
	for _, val in ipairs(resp_body_json_course.Chapters[index].Lessons) do
		table.insert(lessons, val.Title)
	end
	return lessons
end

function M.boot_explorer(self)
	local res = curl.request { url = api.overview.url, method = "get" }
	local selection = 'Courses'
	local resp_body_json = vim.fn.json_decode(res.body)
	local bufnr = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_set_current_buf(bufnr)
	local courses = {}
	for _, val in ipairs(resp_body_json) do
		table.insert(courses, val.Title)
	end
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, courses)

	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<CR>', '', {
		callback = function()
			local lineno = vim.fn.line('.')
			if selection == 'Courses' then
				self.courseid = resp_body_json[lineno].UUID
				self.courseidx = lineno
				local lessons = fetchCourseDetails(self.courseid)
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lessons)
				selection = 'Chapters'
			elseif selection == 'Chapters' then
				local lessons = fetchLessons(lineno)
				self.chapteridx = lineno
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lessons)
				selection = 'Lessons'
			elseif selection == 'Lessons' then
				self.lessonidx = lineno
				self.lessonid = resp_body_json_course.Chapters[self.chapteridx].Lessons[lineno].UUID
				local lesson = fetchLessonDetails(self.lessonid)
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lesson)
				selection = 'Lesson'
			end
		end,
		desc = 'Navigate',
		silent = true,
		noremap = true
	})

	-- Add keybindings for next/prev lesson
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '>', '', {
		callback = function()
			if selection == 'Lesson' then
				self.lessonidx = self.lessonidx + 1
				self.lessonid = resp_body_json_course.Chapters[self.chapteridx].Lessons[self.lessonidx].UUID
				local lesson = fetchLessonDetails(self.lessonid)
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lesson)
			end
		end,
		silent = true,
		noremap = true
	})
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<', '', {
		callback = function()
			if selection == 'Lesson' then
				self.lessonidx = self.lessonidx - 1
				self.lessonid = resp_body_json_course.Chapters[self.chapteridx].Lessons[self.lessonidx].UUID
				local lesson = fetchLessonDetails(self.lessonid)
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lesson)
			end
		end,
		silent = true,
		noremap = true
	})
end

return M
