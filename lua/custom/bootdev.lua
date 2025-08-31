local vimlsp = require("vim.lsp")
local curl = require("plenary.curl")
local inspect = require("My.utils.inspect")
local utils = require("My.utils")
print("starting")
local M = {
	courseidx = -1,
	chapteridx = -1,
	lessonidx = -1,
	Courses = {},
	Chapters = {},
	Lessons = {},
	--https://github.com/nvim-neo-tree/neo-tree.nvim/blob/e968cda658089b56ee1eaa1772a2a0e50113b902/lua/neo-tree/utils.lua#L157-L165
	find_buffer_by_name = function(name)
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			local buf_name = vim.api.nvim_buf_get_name(buf)
			-- if buf_name == name then
			if buf_name:find(name) then
				return buf
			end
		end
		return -1
	end

}
local BOOT_DOMAIN = "https://api.boot.dev"
local headers = {
	authorization =
	"Bearer "
}

local api = {
	ember = { url = "https://api.boot.dev/v1/ember" },
	progress = { url = "https://api.boot.dev/v1/course_progress_by_lesson/", auth = true },
	overview = { url = BOOT_DOMAIN .. "/v1/static/courses/overview" },
	courses = { url = BOOT_DOMAIN .. "/v1/courses/" },
	lessons = { url = BOOT_DOMAIN .. "/v1/static/lessons/" }
}

local resp_body_json_lesson = {}
local function fetchLessonDetails(lessonid)
	print(api.lessons.url .. lessonid)
	local res = curl.request {
		url = api.lessons.url .. lessonid,
		method = "get",
	}
	local resp_body = res.body
	resp_body_json_lesson = vim.fn.json_decode(resp_body)
	local lessondata = {}
	for key, val in pairs(resp_body_json_lesson.Lesson) do
		if key:find("^LessonData") then
			lessondata = val
			break
		end
	end
	if lessondata.StarterFiles then
		for index, val in ipairs(lessondata.StarterFiles) do
			local lbufnum = M.find_buffer_by_name(val.Name .. "$")
			if lbufnum ~= -1 then
				vim.api.nvim_buf_set_lines(lbufnum, 0, -1, false,
					vim.split(val.Content, '\n', { plain = true }))
				print(val.Name .. " : found in : " .. lbufnum)
			else
				print("No buffer named : " .. val.Name)
			end
		end
	end
	local buff_data = vim.split(lessondata.Readme, '\n', { plain = true })
	if lessondata.Question then
		buff_data[#buff_data + 1] = "-------------Quiz-------------------"
		buff_data[#buff_data + 1] = lessondata.Question.Question
		for index, ans_val in ipairs( lessondata.Question.Answers) do
			buff_data[#buff_data + 1] = " - "..ans_val
		end
		buff_data[#buff_data + 1] = "--------------Ans------------------"
		buff_data[#buff_data + 1] = "> " ..lessondata.Question.Answer
	end

	return buff_data
end
local resp_body_json_course
local function fetchCourseDetails(courseid)
	local res = curl.request {
		url = api.courses.url .. courseid,
		method = "get",
	}
	local resp_body = res.body
	resp_body_json_course = vim.fn.json_decode(resp_body)
	local lessons = {}
	for index, val in ipairs(resp_body_json_course.Chapters) do
		table.insert(lessons, val.Title)
	end
	return lessons
end
local function fetchLessons(index)
	local lessons = {}
	for index, val in ipairs(resp_body_json_course.Chapters[index].Lessons) do
		table.insert(lessons, val.Title)
	end
	return lessons
end
local res = curl.request {
	url = api.overview.url,
	method = "get",
}
local selection = 'Courses'
local resp_body = res.body
vim.lsp.buf.hover()
local resp_body_json = vim.fn.json_decode(resp_body)
local courses = {}
for index, val in ipairs(resp_body_json) do
	table.insert(courses, val.Title)
end
local bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, courses)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<CR>', '', {
	callback = function()
		local lineno = vim.fn.line('.')
		if selection == 'Courses' then
			local chapters = resp_body_json[lineno].Chapters
			M.courseid = resp_body_json[lineno].UUID
			M.courseidx = lineno
			local lessons = fetchCourseDetails(M.courseid)
			-- for index, val in ipairs(chapters) do
			-- 	table.insert(lessons, val.Title)
			-- end
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lessons)
			selection = 'Chapters'
		elseif selection == 'Chapters' then
			local lessons = fetchLessons(lineno)
			M.chapterid = resp_body_json_course.Chapters[lineno]
			M.chapteridx = lineno
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lessons)
			selection = 'Lessons'
		elseif selection == 'Lessons' then
			M.lessonid = resp_body_json_course.Chapters[M.chapteridx].Lessons[lineno].UUID
			local lessons = fetchLessonDetails(M.lessonid)
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lessons)
			selection = 'Lesson'
		end
	end,
	desc = 'Close window',
	silent = true,
	nowait = true,
	noremap = true
})

vim.api.nvim_buf_set_keymap(bufnr, 'n', 'H', '', {
	callback = function()
		local lineno = vim.fn.line('.')
		if selection == 'Courses' then
			local chapters = resp_body_json[lineno].Chapters
			M.courseid = resp_body_json[lineno].UUID
			M.courseidx = lineno
			local lessons = fetchCourseDetails(M.courseid)
			-- for index, val in ipairs(chapters) do
			-- 	table.insert(lessons, val.Title)
			-- end
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lessons)
			selection = 'Chapters'
		elseif selection == 'Chapters' then
			local lessons = fetchLessons(lineno)
			M.chapterid = resp_body_json_course.Chapters[lineno]
			M.chapteridx = lineno
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lessons)
			selection = 'Lessons'
		elseif selection == 'Lessons' then
			M.lessonidx = lineno
			M.lessonid = resp_body_json_course.Chapters[M.chapteridx].Lessons[M.lessonidx].UUID
			local lessons = fetchLessonDetails(M.lessonid)
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lessons)
			selection = 'Lesson'
		end
	end,
	desc = 'Close window',
	silent = true,
	nowait = true,
	noremap = true
})
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<', '', {
	callback = function()
		if selection == 'Lesson' then
			print(M.lessonidx)
			M.lessonidx = M.lessonidx - 1
			M.lessonid = resp_body_json_course.Chapters[M.chapteridx].Lessons[M.lessonidx].UUID
			local lesson = fetchLessonDetails(M.lessonid)
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lesson)
		end
	end,
	desc = 'Close window',
	silent = true,
	nowait = true,
	noremap = true
})
vim.api.nvim_buf_set_keymap(bufnr, 'n', '>', '', {
	callback = function()
		if selection == 'Lesson' then
			M.lessonidx = M.lessonidx + 1
			M.lessonid = resp_body_json_course.Chapters[M.chapteridx].Lessons[M.lessonidx].UUID
			local lesson = fetchLessonDetails(M.lessonid)
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lesson)
		end
	end,
	desc = 'Close window',
	silent = true,
	nowait = true,
	noremap = true
})
return M
