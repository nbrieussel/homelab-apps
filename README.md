# homelab-apps

Personal apps deployed on the homelab cluster via ArgoCD (Firefly III first).
Kept separate from `IntegratedDynamic/gitops`, which holds the platform itself.

## Layout

- `bootstrap/` — the app-of-apps. The cluster's own bootstrap references it
  (`IntegratedDynamic/gitops`, `bootstrap/values.yaml`, entry `personal-apps`).
- `apps/<name>/` — one chart per app (`firefly-iii`: upstream chart +
  PostgreSQL + ExternalSecret + HTTPRoute).
- Secrets never live here (public repo): they are in OpenBao, declared in
  the infrastructure repo's `11-secrets/openbao/managed`.

## Preview environments (per pull request)

Label a PR with **`preview`** and an ApplicationSet
(`bootstrap/templates/previews.yaml`, Pull Request generator) spawns an
ephemeral Firefly III at `https://firefly-pr-<N>.staging.scalepack.fr`, in its
own namespace `firefly-pr-<N>` with its own empty PostgreSQL. Each push to the
PR re-renders it; closing/merging the PR (or removing the label) deletes the
Application, the namespace and the volumes.

- Detection is by polling (every 3 min), no webhook, no GitHub token (public
  repo: ~20 API calls/h against the 60/h anonymous limit). If that becomes
  limiting, add a token or a webhook.
- Opt-in by label on purpose: each preview costs a Firefly pod + a Postgres
  on a small cluster.

### Known shortcut: previews share the real credentials

Previews read the **same** OpenBao path as the real instance
(`apps/firefly/credentials`: `APP_KEY` and DB password). The data is separate
(each preview has its own fresh database), but a preview can decrypt nothing
of prod's yet shares its secrets. Accepted for now; the fix is a dedicated
`apps/firefly-preview/credentials` (Terraform-managed in the infra repo) read
by the preview Applications only.
