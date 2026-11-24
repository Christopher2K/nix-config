---
name: TypeScript Style
description: Use when writing, editing, or reviewing TypeScript or TSX code according to the user's type-only, enum-free, concisely documented style.
---

# TypeScript Style

Apply these rules to code you create or edit. Do not rewrite unrelated code, generated files, or third-party declarations.

## Type declarations

- Use `type` aliases for object shapes, unions, and composed types.
- Never declare an `interface`.
- Preserve existing public APIs unless asked to change them.

## Replace enums with records

- Never declare an `enum` or `const enum`.
- Define allowed values in an `as const` record.
- Derive the corresponding type from that record.
- Use `Record` for typed key-value mappings when appropriate.

## Inline documentation

- Add short `/** ... */` comments to named types for both humans and AI.
- Document properties when their purpose, constraints, or units need explanation.
- Keep comments to one short line, usually a few words.
- Explain semantics; do not merely repeat the identifier.
- Avoid long descriptions, tutorials, and obvious commentary.

## Frontend validation

- All frontend and client-side form validation must use **Valibot**.
- Define reusable Valibot schemas with Standard Schema compatibility; do not introduce Zod or parallel handwritten validation rules.
- Reuse schemas from `@signet/core` when validation is shared between web and mobile.

## Example

```ts
/** Supported account states. */
export const accountStatus = {
  active: "active",
  disabled: "disabled",
} as const;

/** Current account state. */
export type AccountStatus =
  (typeof accountStatus)[keyof typeof accountStatus];

/** User account. */
export type Account = {
  /** Stable account identifier. */
  id: string;

  /** Current account state. */
  status: AccountStatus;

  /** UTC expiration time. */
  expiresAt?: string;
};
```
