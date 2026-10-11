---
name: document
description: >-
  Document the current branch's changes where this project keeps docs: API changes in OpenAPI/
  Swagger, Postman collections, curl examples, README/docs pages, changelog files. Use on
  "document this", "document the API changes", "update swagger/postman", "add curl examples",
  "/document".
---

# Document

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` if not loaded this session.

## 1. What changed
Diff the branch against the base branch. Find user-visible and API changes: new/changed routes,
controller/view params, serializers/response shapes, auth rules, status codes, config/env vars,
behavior described in docs.

## 2. Where it is documented here
From the profile's `api_docs` and the repo: OpenAPI/Swagger files, Postman collection files,
`docs/`, README sections, `CHANGELOG`. Match the existing style and level of detail. If the project
documents nothing of this kind, don't invent a new doc system: give curl examples in the report only.

## 3. Update
- In-repo docs (OpenAPI, collection JSON, markdown, changelog) are part of the task: edit them in
  the working tree like code.
- External docs (Postman workspace via API, Notion/Confluence pages, developer portal) go to the
  confirmation list with the exact content.
- For every new or changed endpoint, produce a curl example with realistic placeholder values,
  required headers/auth, and one example response.

## Output
```
Docs updated: <file — what>
External (pending confirmation): <target — what>
curl:
<examples>
```
