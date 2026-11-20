# twitter-followback

Follows back the people behind an X account: real humans who follow the user,
post actively, and pass a character check. Bots, brands, funnels, and guesses are
skipped.

Canonical instructions: [`SKILL.md`](../../.agents/skills/twitter-followback/SKILL.md).

## When it triggers

- "follow back my followers" or "follow back my mutuals"
- "review my new followers"
- "clean up my follow-back queue"
- "is this follower a bot?"
- "which followers are worth following back?"

It is explicitly **not** for mass-following, growth hacking, or unfollowing.

## Requirements

| Need | Why |
| --- | --- |
| Interactive browser control | Every action happens through the real UI |
| A browser already signed in to X | The skill never handles credentials |
| A local session | Cloud, sandboxed, and headless sessions cannot complete it |

These limits are declared in the skill's `compatibility` field, so a host can
skip it before loading.

## How it works

1. **Prove control** — confirm the browser relay is connected and drive the real
   signed-in session before planning anything.
2. **Learn the UI** — the follow controls change often, so the skill observes the
   current button vocabulary and row anatomy instead of assuming.
3. **Confirm criteria** — scope, recency threshold, and exclusions are agreed
   with the user up front and restated.
4. **Build the queue** — only rows whose control reads `Follow back`, deduplicated
   by handle, collected while scrolling the virtualised list.
5. **Research each candidate** — bio, join date, follower ratio, newest posts.
6. **Follow with exact identity matching** — the control must be tied to that
   handle and verified as `Following` immediately after.
7. **Handle throttling** — a silent click means throttled; wait, retry once, then
   scale back rather than looping.
8. **Report honestly** — separate new follows, pre-existing follows, and skips
   with reasons.

## Safety boundaries

- Only the user's own account, only with the confirmed scope.
- Never unfollow, block, report, or message.
- Never follow accounts from suggestion modules or search results.
- Hand off for login, 2FA, captcha, or payment.
- Stop and ask when identity, scope, or UI behaviour is unclear.

## Related

- [Skills catalog](README.md)
- [Architecture](../architecture.md)
- [Agent instructions](../agent-instructions.md)
