# Issue trackers

Use the section matching the profile's `tracker`. Find tools with ToolSearch.

## Jira
- Tools: Atlassian MCP. `cloudId` from the accessible-resources tool, or use the site URL.
- Issue: get issue with comments, links, subtasks, attachments list, sprint, story points
  (often `customfield_10016` or a field named "Story Points"; check field metadata once and note it
  in the profile).
- Key pattern: `[A-Z][A-Z0-9]+-\d+`.
- My open sprint: JQL `assignee = currentUser() AND sprint in openSprints() ORDER BY rank`.
  Upcoming: `sprint in futureSprints()`. Sprint start/end dates: the issue's sprint field.
- My recent activity: JQL `updated >= "<date>" AND (assignee = currentUser() OR comment ~ currentUser())`,
  then read changelog/comments for entries by me.
- Create: needs project key and issue type (from project metadata). Draft fields, then confirmation list.
- Linked docs: Confluence pages through the same MCP.

## Linear
- Tools: Linear MCP (get issue, list comments, list issues, cycles).
- Key pattern: `[A-Z]{2,5}-\d+`, or a `linear.app/<team>/issue/<KEY>` URL.
- Sprint = cycle. Current: the team's active cycle filtered to assignee me; upcoming: next cycle.
  Estimates: the issue `estimate` field.
- Create: needs team and optionally project, labels, priority.

## ClickUp
- Tools: ClickUp MCP (`clickup_*`). Note `workspace_id` and your numeric user id
  (`clickup_resolve_assignees` with `["me"]`) in the profile on first use.
- Key pattern: the workspace's custom task id (e.g. `DEV-123`) when it uses them, else the task id;
  or an `app.clickup.com/t/<id>` URL.
- Issue: `clickup_get_task` (with comments and subtasks).
- Sprint = a list in the space's Sprints folder, named with its dates (e.g. `Sprint 12 (10/6 - 10/19)`).
  Find the folder once (`clickup_get_folder` / `clickup_search`) and note `sprint_folder` in the profile.
  Current: the list whose dates hold today; upcoming: the next one. Dates from the name, else the
  list's start/due dates (`clickup_get_list`). My tickets: `clickup_filter_tasks` with that list in
  `list_ids` and me in `assignees`, every page (`has_more`). Rank: the list's order.
  No Sprints folder: no sprints.
- My open tickets: `clickup_filter_tasks` with me in `assignees` (closed excluded), every page.
- My recent activity / comments: the same filter ordered by `updated`, then `clickup_get_task` comments
  only for tasks updated since the window start.
- Create: `clickup_create_task` with `list_id` (confirmation list).

## GitHub Issues / Projects
- Tools: `gh` CLI. `gh issue view <n> --json title,body,comments,labels,assignees,milestone`.
- Sprint = Projects iteration field (`gh project item-list`) or a milestone with a due date.
- My activity: `gh search issues --involves @me --updated ">=<date>"`.
- Create: `gh issue create` (confirmation list).

## Other / unknown
WebFetch the URL for reading. For writes, report that no tool is connected and give the user
the drafted content to paste.
