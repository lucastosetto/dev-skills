# Observability

Match the environment to the task (prod incident: prod server). Always check label names and the
timezone before concluding "nothing found". Quote decisive numbers and give deeplinks when the
tool can generate them.

## Grafana (Loki, Prometheus/Mimir, Tempo, Pyroscope)
- Tools: Grafana MCP (one server per environment, e.g. `grafana-prod`, `grafana-dev`).
- Start: list datasources, then label names/values to learn the app's labels (service, env, route).
- Logs: LogQL `{app="<svc>"} |= "<id>"`; errors `|~ "(?i)error|exception"`; patterns/stats tools for volume.
- Metrics (RED): request rate `sum(rate(<http_requests_total>[5m]))`, error ratio, latency
  `histogram_quantile(0.95, ...)`. Find metric names with the metric-names tool first.
- Traces: TraceQL `{ resource.service.name = "<svc>" && status = error }`, or slow spans by duration.
- Deploy markers: annotations in the window.
- Baseline: same window one week earlier, or the hour before a deploy.

## Error trackers
- Sentry, Rollbar, Honeybadger, Bugsnag: find with ToolSearch, else ask for the dashboard link and
  read what the user pastes. Look at first-seen vs deploy time, count, affected users, release tag.

## APM
- Datadog (`ddtrace`), New Relic (`newrelic`), OpenTelemetry exporters: use their MCP if connected;
  otherwise give the user the exact query to run and read the result they paste.

## Product analytics and experiments
- Amplitude, Mixpanel, Segment, PostHog, Statsig, GrowthBook: event counts and funnels before vs
  after, experiment variant metrics and sample sizes. Use their MCP if connected, else report the gap.

## Console (data checks)
- Rails `rails console`, Django `python manage.py shell`, Node REPL with the ORM. Hand read-only
  commands to the user for production; prefer audit/version tables (PaperTrail, django-simple-history).
