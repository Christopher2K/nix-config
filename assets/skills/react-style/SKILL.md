---
name: React Style
description: Use when writing, editing, or reviewing React components in TSX, including component typing, exports, filenames, body organization, and file structure.
---

# React Style

Apply these rules to React code you create or edit. Do not rewrite unrelated code or framework-generated files. Load and follow the `typescript-style` skill for TypeScript declarations and inline documentation.

## Visual handoff

- At the end of every frontend implementation or visual change, run the app and capture screenshots of the affected screens and important states at the relevant viewport sizes.
- Include the screenshots in the final response using absolute file paths so the user can validate the rendered work. Do not substitute test results or text descriptions for screenshots.
- If no browser or device is available, explicitly report that screenshots could not be captured and explain what is blocking them.

## Component contracts

- Always make component props explicit with a named `<Component>Props` type.
- Annotate the destructured props parameter with that type.
- Do not use inline anonymous prop types or `React.FC`.
- Components without props do not need an artificial empty props type.

## Form validation

- All frontend form validation must use **Valibot** schemas with Standard Schema compatibility.
- Reuse shared schemas from `@signet/core` where available instead of duplicating validation in components.

## Exports

- Declare exported components as arrow functions assigned to `export const`.
- Do not use `export function`.
- Prefer named exports.
- When a framework requires a default export, declare the component as a `const` and export that value as default.

## Filenames

- Use kebab-case for React component filenames: `search-input.tsx`.
- Use PascalCase for the component itself: `SearchInput`.
- Name tests and stories after the component: `search-input.test.tsx`, `search-input.stories.tsx`.
- Preserve framework-required route filenames such as `_layout.tsx`, `index.tsx`, and `[id].tsx`.

## Component body order

Keep every component body in this order, omitting empty sections:

1. **Props:** destructure props and apply defaults in the signature.
2. **Hooks:** state, refs, context, memos, and other hooks.
3. **Callbacks:** event handlers and other callbacks, including `useCallback`.
4. **Effects:** `useEffect`, `useLayoutEffect`, and other effects.
5. **Render:** render-only derived values followed by the `return` block.

Do not interleave these sections. Keep hooks unconditional and place early returns after all hooks.

## One component per file

- Keep one component per file whenever practical.
- Extract additional components into their own kebab-case files instead of colocating them.
- Keep non-component helpers separate when doing so improves component clarity.

## Example

File: `search-input.tsx`

```tsx
import {
  type ChangeEvent,
  useCallback,
  useEffect,
  useRef,
  useState,
} from "react";

/** Search input properties. */
type SearchInputProps = {
  /** Initial search text. */
  initialValue?: string;
  /** Called when search text changes. */
  onChange: (value: string) => void;
};

export const SearchInput = ({
  initialValue = "",
  onChange,
}: SearchInputProps) => {
  const inputRef = useRef<HTMLInputElement>(null);
  const [value, setValue] = useState(initialValue);

  const handleChange = useCallback(
    (event: ChangeEvent<HTMLInputElement>) => {
      const nextValue = event.target.value;
      setValue(nextValue);
      onChange(nextValue);
    },
    [onChange],
  );

  useEffect(() => {
    inputRef.current?.focus();
  }, []);

  return <input ref={inputRef} value={value} onChange={handleChange} />;
};
```
